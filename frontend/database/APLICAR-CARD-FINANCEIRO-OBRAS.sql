-- ============================================================
-- APLICAR CARD EM FINANCEIRO/OBRAS PARA CONTRATO EXISTENTE
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Este script cria o registro na tabela financeiro_projetos_resumo
-- que alimenta os cards na página financeiro/obras
-- ============================================================

DO $$
DECLARE
    v_contrato_id UUID := '55f98304-0ad6-4555-a304-2a9880feb0ca';
    v_contrato RECORD;
    v_cliente_nome TEXT;
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
        RAISE EXCEPTION 'Contrato nao encontrado: %', v_contrato_id;
    END IF;

    v_cliente_nome := COALESCE(v_contrato.cliente_nome_pessoa, 'Cliente');

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CONTRATO: % - %', v_contrato.numero, v_cliente_nome;
    RAISE NOTICE '============================================================';

    -- ============================================================
    -- CRIAR/ATUALIZAR REGISTRO NA TABELA financeiro_projetos_resumo
    -- ============================================================
    INSERT INTO financeiro_projetos_resumo (
        contrato_id,
        cliente_id,
        cliente_nome,
        numero,
        nucleo,
        valor_total,
        valor_entrada,
        numero_parcelas,
        data_inicio,
        data_previsao_termino,
        status
    ) VALUES (
        v_contrato_id,
        v_contrato.cliente_id,
        v_cliente_nome,
        v_contrato.numero,
        v_contrato.unidade_negocio,
        v_contrato.valor_total,
        COALESCE(v_contrato.valor_entrada, 0),
        COALESCE(v_contrato.numero_parcelas, 0),
        COALESCE(v_contrato.data_inicio, CURRENT_TIMESTAMP),
        v_contrato.data_previsao_termino,
        COALESCE(v_contrato.status, 'ativo')
    )
    ON CONFLICT (contrato_id) DO UPDATE SET
        cliente_id = EXCLUDED.cliente_id,
        cliente_nome = EXCLUDED.cliente_nome,
        numero = EXCLUDED.numero,
        nucleo = EXCLUDED.nucleo,
        valor_total = EXCLUDED.valor_total,
        valor_entrada = EXCLUDED.valor_entrada,
        numero_parcelas = EXCLUDED.numero_parcelas,
        data_inicio = EXCLUDED.data_inicio,
        data_previsao_termino = EXCLUDED.data_previsao_termino,
        status = EXCLUDED.status;

    RAISE NOTICE 'CARD FINANCEIRO CRIADO/ATUALIZADO!';
    RAISE NOTICE '   Cliente: %', v_cliente_nome;
    RAISE NOTICE '   Numero: %', v_contrato.numero;
    RAISE NOTICE '   Valor: R$ %', v_contrato.valor_total;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'PROCESSO CONCLUIDO!';
    RAISE NOTICE '============================================================';

END $$;

-- ============================================================
-- VERIFICACAO: Consultar card criado
-- ============================================================

SELECT
    contrato_id,
    cliente_nome,
    numero,
    nucleo,
    valor_total,
    valor_entrada,
    numero_parcelas,
    status,
    data_inicio,
    data_previsao_termino
FROM financeiro_projetos_resumo
WHERE contrato_id = '55f98304-0ad6-4555-a304-2a9880feb0ca';
