-- ============================================================
-- APLICAR PROJETO/CRONOGRAMA EM CONTRATO EXISTENTE
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Este script cria o projeto (cronograma) que faltou na emissão:
-- 1. Projeto (projetos)
-- 2. Tarefas (cronograma_tarefas)
-- ============================================================

DO $$
DECLARE
    v_contrato_id UUID := '55f98304-0ad6-4555-a304-2a9880feb0ca';
    v_contrato RECORD;
    v_projeto_id UUID;
    v_cliente_nome TEXT;
    v_nome_projeto TEXT;
    v_item RECORD;
    v_data_inicio DATE := CURRENT_DATE;
    v_data_tarefa DATE;
    v_data_fim_tarefa DATE;
    v_ordem INT := 0;
    v_tarefas_criadas INT := 0;
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
    v_nome_projeto := 'Obra ' || v_contrato.numero || ' - ' || v_cliente_nome;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CONTRATO: % - %', v_contrato.numero, v_cliente_nome;
    RAISE NOTICE '============================================================';

    -- ============================================================
    -- PARTE 1: VERIFICAR SE JA EXISTE PROJETO
    -- ============================================================
    SELECT id INTO v_projeto_id
    FROM projetos
    WHERE contrato_id = v_contrato_id
    LIMIT 1;

    IF v_projeto_id IS NOT NULL THEN
        RAISE NOTICE 'Projeto ja existe para este contrato: %', v_projeto_id;
        RETURN;
    END IF;

    -- ============================================================
    -- PARTE 2: CRIAR PROJETO
    -- ============================================================
    INSERT INTO projetos (
        nome,
        descricao,
        cliente_id,
        contrato_id,
        nucleo,
        data_inicio,
        data_termino,
        status,
        progresso
    ) VALUES (
        v_nome_projeto,
        COALESCE(v_contrato.descricao, 'Projeto gerado do contrato ' || v_contrato.numero),
        v_contrato.cliente_id,
        v_contrato_id,
        COALESCE(v_contrato.unidade_negocio, 'engenharia'),
        CURRENT_DATE,
        v_contrato.data_previsao_termino::date,
        'em_andamento',
        0
    )
    RETURNING id INTO v_projeto_id;

    RAISE NOTICE 'PROJETO CRIADO: %', v_nome_projeto;
    RAISE NOTICE '   ID: %', v_projeto_id;

    -- ============================================================
    -- PARTE 3: CRIAR TAREFAS BASEADAS NOS ITENS DO CONTRATO
    -- ============================================================
    FOR v_item IN
        SELECT *
        FROM contratos_itens
        WHERE contrato_id = v_contrato_id
        ORDER BY ordem ASC
    LOOP
        v_ordem := v_ordem + 1;
        v_data_tarefa := v_data_inicio + (v_ordem - 1) * 7; -- Uma semana por tarefa
        v_data_fim_tarefa := v_data_tarefa + 6;

        INSERT INTO cronograma_tarefas (
            projeto_id,
            titulo,
            descricao,
            nucleo,
            categoria,
            data_inicio,
            data_termino,
            progresso,
            status,
            ordem
        ) VALUES (
            v_projeto_id,
            LEFT(COALESCE(v_item.descricao, 'Item ' || v_ordem), 100),
            COALESCE(v_item.quantidade::text, '1') || ' ' ||
                COALESCE(v_item.unidade, 'un') || ' - ' ||
                COALESCE(v_item.tipo, 'servico'),
            COALESCE(v_item.nucleo, v_contrato.unidade_negocio, 'engenharia'),
            v_item.categoria,
            v_data_tarefa,
            v_data_fim_tarefa,
            0,
            'pendente',
            v_ordem
        );

        v_tarefas_criadas := v_tarefas_criadas + 1;
    END LOOP;

    -- Se nao tem itens, criar tarefa padrao
    IF v_tarefas_criadas = 0 THEN
        v_data_fim_tarefa := v_data_inicio + COALESCE(v_contrato.prazo_entrega_dias, 30);

        INSERT INTO cronograma_tarefas (
            projeto_id,
            titulo,
            descricao,
            nucleo,
            data_inicio,
            data_termino,
            progresso,
            status,
            ordem
        ) VALUES (
            v_projeto_id,
            'Execucao da Obra',
            COALESCE(v_contrato.descricao, 'Executar conforme contrato'),
            COALESCE(v_contrato.unidade_negocio, 'engenharia'),
            v_data_inicio,
            v_data_fim_tarefa,
            0,
            'pendente',
            1
        );

        v_tarefas_criadas := 1;
        RAISE NOTICE 'Tarefa padrao criada (contrato sem itens)';
    END IF;

    RAISE NOTICE 'TAREFAS CRIADAS: %', v_tarefas_criadas;

    -- ============================================================
    -- RESUMO FINAL
    -- ============================================================
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'PROCESSO CONCLUIDO!';
    RAISE NOTICE 'Projeto: %', v_nome_projeto;
    RAISE NOTICE 'Tarefas: %', v_tarefas_criadas;
    RAISE NOTICE '============================================================';

END $$;

-- ============================================================
-- VERIFICACAO: Consultar projeto e tarefas criados
-- ============================================================

-- Ver projeto criado
SELECT
    'PROJETO' as tipo,
    p.id,
    p.nome,
    p.status,
    p.progresso,
    p.data_inicio,
    p.data_termino
FROM projetos p
WHERE p.contrato_id = '55f98304-0ad6-4555-a304-2a9880feb0ca';

-- Ver tarefas criadas
SELECT
    'TAREFA' as tipo,
    t.id,
    t.titulo,
    t.status,
    t.data_inicio,
    t.data_termino,
    t.ordem
FROM cronograma_tarefas t
WHERE t.projeto_id IN (
    SELECT id FROM projetos WHERE contrato_id = '55f98304-0ad6-4555-a304-2a9880feb0ca'
)
ORDER BY t.ordem;
