-- ============================================================
-- APLICAR REGISTROS FINANCEIROS EM CONTRATO EXISTENTE
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Este script cria os registros que faltaram na emissão do contrato:
-- 1. Obra (financeiro/obras)
-- 2. Lançamentos financeiros (financeiro/lancamentos)
-- 3. Cobranças (financeiro/cobrancas)
-- ============================================================

-- CONFIGURAÇÃO: ID do contrato a corrigir
-- Substitua pelo ID do contrato que precisa ser corrigido
DO $$
DECLARE
    v_contrato_id UUID := '55f98304-0ad6-4555-a304-2a9880feb0ca';
    v_contrato RECORD;
    v_obra_id UUID;
    v_lancamento_id UUID;
    v_user_id UUID;
    v_cliente_nome TEXT;
    v_nome_obra TEXT;
    v_endereco TEXT;
BEGIN
    -- ============================================================
    -- BUSCAR DADOS DO CONTRATO
    -- ============================================================
    SELECT
        c.*,
        p.nome as cliente_nome_pessoa
    INTO v_contrato
    FROM contratos c
    LEFT JOIN pessoas p ON p.id = c.cliente_id
    WHERE c.id = v_contrato_id;

    IF v_contrato IS NULL THEN
        RAISE EXCEPTION 'Contrato não encontrado: %', v_contrato_id;
    END IF;

    v_cliente_nome := COALESCE(v_contrato.cliente_nome_pessoa, 'Cliente');
    v_nome_obra := 'Obra ' || v_contrato.numero || ' - ' || v_cliente_nome;

    -- Extrair endereço do JSON se disponível
    v_endereco := NULL;
    IF v_contrato.dados_imovel_json IS NOT NULL THEN
        v_endereco := v_contrato.dados_imovel_json->>'endereco';
        IF v_endereco IS NULL THEN
            v_endereco := v_contrato.dados_imovel_json->>'endereco_completo';
        END IF;
    END IF;

    -- Obter user_id do criador
    v_user_id := COALESCE(v_contrato.created_by, (SELECT id FROM auth.users LIMIT 1));

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CONTRATO: % - %', v_contrato.numero, v_cliente_nome;
    RAISE NOTICE 'Valor Total: R$ %', v_contrato.valor_total;
    RAISE NOTICE '============================================================';

    -- ============================================================
    -- PARTE 1: CRIAR OBRA (se não existir)
    -- ============================================================
    SELECT id INTO v_obra_id
    FROM obras
    WHERE nome = v_nome_obra
    LIMIT 1;

    IF v_obra_id IS NULL THEN
        INSERT INTO obras (
            user_id,
            nome,
            endereco,
            data_prevista_entrega,
            status
        ) VALUES (
            v_user_id,
            v_nome_obra,
            v_endereco,
            v_contrato.data_previsao_termino::date,
            'em_andamento'
        )
        RETURNING id INTO v_obra_id;

        RAISE NOTICE '✅ OBRA CRIADA: %', v_nome_obra;
        RAISE NOTICE '   ID: %', v_obra_id;
    ELSE
        RAISE NOTICE '⚠️ Obra já existe: %', v_nome_obra;
    END IF;

    -- ============================================================
    -- PARTE 2: CRIAR LANÇAMENTO FINANCEIRO (se não existir)
    -- ============================================================
    SELECT id INTO v_lancamento_id
    FROM financeiro_lancamentos
    WHERE contrato_id = v_contrato_id
    AND tipo = 'entrada'
    LIMIT 1;

    IF v_lancamento_id IS NULL AND COALESCE(v_contrato.valor_total, 0) > 0 THEN
        INSERT INTO financeiro_lancamentos (
            tipo,
            status,
            descricao,
            valor_total,
            pessoa_id,
            contrato_id,
            nucleo,
            unidade_negocio,
            categoria_id,
            data_competencia,
            vencimento
        ) VALUES (
            'entrada',
            'pendente',
            'Receita contrato ' || v_contrato.numero ||
                CASE WHEN v_contrato.unidade_negocio IS NOT NULL
                     THEN ' - ' || UPPER(v_contrato.unidade_negocio)
                     ELSE '' END,
            v_contrato.valor_total,
            v_contrato.cliente_id,
            v_contrato_id,
            v_contrato.unidade_negocio,
            v_contrato.unidade_negocio,
            NULL,
            CURRENT_DATE,
            COALESCE(v_contrato.data_inicio::date, CURRENT_DATE)
        )
        RETURNING id INTO v_lancamento_id;

        RAISE NOTICE '✅ LANÇAMENTO FINANCEIRO CRIADO';
        RAISE NOTICE '   ID: %', v_lancamento_id;
        RAISE NOTICE '   Valor: R$ %', v_contrato.valor_total;
    ELSE
        IF v_lancamento_id IS NOT NULL THEN
            RAISE NOTICE '⚠️ Lançamento financeiro já existe para este contrato';
        ELSE
            RAISE NOTICE '⚠️ Contrato sem valor total definido';
        END IF;
    END IF;

    -- ============================================================
    -- PARTE 3: CRIAR COBRANÇA (se não existir e lançamento foi criado)
    -- ============================================================
    IF v_lancamento_id IS NOT NULL AND v_obra_id IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM cobrancas
            WHERE obra_id = v_obra_id
            AND cliente = v_cliente_nome
            AND valor = v_contrato.valor_total
        ) THEN
            INSERT INTO cobrancas (
                obra_id,
                cliente,
                valor,
                vencimento,
                status
            ) VALUES (
                v_obra_id,
                v_cliente_nome,
                v_contrato.valor_total,
                COALESCE(v_contrato.data_inicio::date, CURRENT_DATE),
                'Pendente'
            );

            RAISE NOTICE '✅ COBRANÇA CRIADA';
            RAISE NOTICE '   Cliente: %', v_cliente_nome;
            RAISE NOTICE '   Valor: R$ %', v_contrato.valor_total;
        ELSE
            RAISE NOTICE '⚠️ Cobrança já existe para esta obra/cliente/valor';
        END IF;
    END IF;

    -- ============================================================
    -- RESUMO FINAL
    -- ============================================================
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'PROCESSO CONCLUÍDO!';
    RAISE NOTICE '============================================================';

END $$;

-- ============================================================
-- VERIFICAÇÃO: Consultar registros criados
-- ============================================================

-- Ver obra criada (busca pelo número do contrato)
SELECT
    'OBRA' as tipo,
    o.id,
    o.nome,
    o.endereco,
    o.status,
    o.data_prevista_entrega
FROM obras o
WHERE o.nome LIKE 'Obra ' || (
    SELECT c.numero FROM contratos c WHERE c.id = '55f98304-0ad6-4555-a304-2a9880feb0ca'
) || '%'
ORDER BY o.criado_em DESC
LIMIT 5;

-- Ver lançamentos do contrato
SELECT
    'LANCAMENTO' as tipo,
    id,
    descricao,
    valor_total,
    status,
    vencimento,
    nucleo
FROM financeiro_lancamentos
WHERE contrato_id = '55f98304-0ad6-4555-a304-2a9880feb0ca';

-- Ver cobranças relacionadas
SELECT
    'COBRANCA' as tipo,
    id,
    cliente,
    valor,
    status,
    vencimento
FROM cobrancas
WHERE cliente IN (
    SELECT p.nome
    FROM contratos c
    LEFT JOIN pessoas p ON p.id = c.cliente_id
    WHERE c.id = '55f98304-0ad6-4555-a304-2a9880feb0ca'
);
