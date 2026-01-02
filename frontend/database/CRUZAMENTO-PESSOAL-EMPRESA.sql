-- ============================================
-- CRUZAMENTO: FINANCEIRO PESSOAL x EMPRESA
-- Analise Global de Pagamentos
-- ============================================
-- Data: 2025-12-30
-- Objetivo: Identificar pessoas que recebem tanto
-- do financeiro pessoal quanto das empresas
-- ============================================

-- ============================================
-- PARTE 1: BUSCAR PESSOAS NO SISTEMA
-- ============================================

-- Query 1: Verificar se as pessoas existem no sistema
SELECT
    id,
    nome,
    tipo,
    created_at
FROM pessoas
WHERE UPPER(nome) LIKE '%JOSE RICARDO%'
   OR UPPER(nome) LIKE '%JOSEMAR%'
   OR UPPER(nome) LIKE '%WELLINGTON%'
   OR UPPER(nome) LIKE '%VICTORIA%ALMEIDA%'
   OR UPPER(nome) LIKE '%SANDRA%ALMEIDA%'
   OR UPPER(nome) LIKE '%CAMILA%ALMEIDA%'
   OR UPPER(nome) LIKE '%CLAUDINEIDE%'
ORDER BY nome;

-- ============================================
-- PARTE 2: LANCAMENTOS POR PESSOA
-- ============================================

-- Query 2: Todos os lancamentos dessas pessoas (como beneficiarios)
SELECT
    p.nome as beneficiario,
    p.tipo as tipo_pessoa,
    fl.data_competencia,
    fl.valor_total,
    fl.descricao,
    fl.tipo as tipo_lancamento,
    fl.natureza,
    fl.status
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) LIKE '%JOSE RICARDO%'
   OR UPPER(p.nome) LIKE '%JOSEMAR%'
   OR UPPER(p.nome) LIKE '%WELLINGTON%'
   OR UPPER(p.nome) LIKE '%VICTORIA%ALMEIDA%'
   OR UPPER(p.nome) LIKE '%SANDRA%ALMEIDA%'
   OR UPPER(p.nome) LIKE '%CAMILA%ALMEIDA%'
   OR UPPER(p.nome) LIKE '%CLAUDINEIDE%'
ORDER BY p.nome, fl.data_competencia DESC;

-- ============================================
-- PARTE 3: RESUMO POR PESSOA
-- ============================================

-- Query 3: Total recebido por pessoa
SELECT
    p.nome as beneficiario,
    p.tipo as tipo_pessoa,
    COUNT(*) as qtd_lancamentos,
    SUM(CASE WHEN fl.tipo = 'saida' THEN fl.valor_total ELSE 0 END) as total_recebido,
    MIN(fl.data_competencia) as primeiro_lancamento,
    MAX(fl.data_competencia) as ultimo_lancamento
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) LIKE '%JOSE RICARDO%'
   OR UPPER(p.nome) LIKE '%JOSEMAR%'
   OR UPPER(p.nome) LIKE '%WELLINGTON%'
   OR UPPER(p.nome) LIKE '%VICTORIA%ALMEIDA%'
   OR UPPER(p.nome) LIKE '%SANDRA%ALMEIDA%'
   OR UPPER(p.nome) LIKE '%CAMILA%ALMEIDA%'
   OR UPPER(p.nome) LIKE '%CLAUDINEIDE%'
GROUP BY p.nome, p.tipo
ORDER BY total_recebido DESC;

-- ============================================
-- PARTE 4: LANCAMENTOS COM DESCRICAO CONTENDO NOMES
-- ============================================

-- Query 4: Buscar em descricoes (caso pessoa nao esteja cadastrada mas apareca em descricao)
SELECT
    fl.data_competencia,
    fl.valor_total,
    fl.descricao,
    fl.tipo,
    fl.natureza,
    p.nome as centro_custo
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(fl.descricao) LIKE '%JOSE RICARDO%'
   OR UPPER(fl.descricao) LIKE '%JOSEMAR%'
   OR UPPER(fl.descricao) LIKE '%WELLINGTON%'
   OR UPPER(fl.descricao) LIKE '%VICTORIA%'
   OR UPPER(fl.descricao) LIKE '%SANDRA%'
   OR UPPER(fl.descricao) LIKE '%CAMILA%'
   OR UPPER(fl.descricao) LIKE '%CLAUDINEIDE%'
   OR UPPER(fl.descricao) LIKE '%DIARISTA%'
   OR UPPER(fl.descricao) LIKE '%ALUGUEL%'
ORDER BY fl.data_competencia DESC;

-- ============================================
-- PARTE 5: ANALISE DE CAMILA (INVESTIDORA)
-- Emprestimo com retorno de 10% em 30 dias
-- ============================================

-- Query 5: Buscar movimentacoes que parecem ser emprestimos/investimentos
SELECT
    fl.data_competencia,
    fl.valor_total,
    fl.descricao,
    fl.tipo,
    fl.natureza,
    p.nome as centro_custo
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(fl.descricao) LIKE '%CAMILA%'
   OR UPPER(fl.descricao) LIKE '%EMPRESTIMO%'
   OR UPPER(fl.descricao) LIKE '%INVESTIMENTO%'
   OR UPPER(fl.descricao) LIKE '%APORTE%'
   OR UPPER(fl.descricao) LIKE '%RETORNO%'
ORDER BY fl.data_competencia DESC;

-- ============================================
-- PARTE 6: WILLIAM - TODOS OS LANCAMENTOS
-- ============================================

-- Query 6: Verificar lancamentos do William no sistema da empresa
SELECT
    fl.data_competencia,
    fl.valor_total,
    fl.descricao,
    fl.tipo,
    fl.natureza,
    fl.status,
    p.nome as centro_custo
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) LIKE '%WILLIAM%'
   OR UPPER(fl.descricao) LIKE '%WILLIAM%'
   OR UPPER(fl.descricao) LIKE '%PRO-LABORE%'
   OR UPPER(fl.descricao) LIKE '%PROLABORE%'
   OR UPPER(fl.descricao) LIKE '%FOUNDER%'
   OR UPPER(fl.descricao) LIKE '%SOCIO%'
ORDER BY fl.data_competencia DESC
LIMIT 100;

-- ============================================
-- PARTE 7: RESUMO GERAL POR CATEGORIA
-- ============================================

-- Query 7: Categorias de gastos pessoais vs empresa
SELECT
    CASE
        WHEN UPPER(fl.descricao) LIKE '%ALUGUEL%' THEN 'ALUGUEL'
        WHEN UPPER(fl.descricao) LIKE '%VEICULO%' OR UPPER(fl.descricao) LIKE '%CARRO%' THEN 'VEICULOS'
        WHEN UPPER(fl.descricao) LIKE '%PRO-LABORE%' OR UPPER(fl.descricao) LIKE '%PROLABORE%' THEN 'PRO-LABORE'
        WHEN UPPER(fl.descricao) LIKE '%REPASSE%' THEN 'REPASSE FAMILIAR'
        WHEN UPPER(fl.descricao) LIKE '%DIARISTA%' THEN 'SERVICOS DOMESTICOS'
        WHEN UPPER(fl.descricao) LIKE '%IMPOSTO%' OR UPPER(fl.descricao) LIKE '%DARF%' THEN 'IMPOSTOS'
        WHEN UPPER(fl.descricao) LIKE '%DIVIDA%' THEN 'DIVIDAS'
        ELSE 'OUTROS'
    END as categoria,
    COUNT(*) as qtd,
    SUM(fl.valor_total) as total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
GROUP BY 1
ORDER BY total DESC;

-- ============================================
-- PARTE 8: FLUXO TRIMESTRAL (para avaliacoes)
-- ============================================

-- Query 8: Fluxo por trimestre
SELECT
    EXTRACT(YEAR FROM fl.data_competencia) as ano,
    EXTRACT(QUARTER FROM fl.data_competencia) as trimestre,
    fl.tipo,
    COUNT(*) as qtd_lancamentos,
    SUM(fl.valor_total) as total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
GROUP BY 1, 2, 3
ORDER BY ano, trimestre, tipo;
