-- ============================================
-- IMPORTACAO DE LANCAMENTOS ADICIONAIS
-- Dados encontrados em planilhas secundarias
-- Com verificacao automatica de duplicidade
-- ============================================

-- PARTE 1: CADASTRAR CLIENTES ADICIONAIS (se nao existirem)

INSERT INTO pessoas (nome, tipo) SELECT 'Uma Uma', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Uma Uma'));
INSERT INTO pessoas (nome, tipo) SELECT 'Skic', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Skic'));
INSERT INTO pessoas (nome, tipo) SELECT 'Luiz 181B', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Luiz 181B'));

-- PARTE 2: LANCAMENTOS ADICIONAIS DE MARINA WIKBOLD

-- 2024-12-17 | R$ 13,100.00 | WG REFORMAS (em aberto)
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2024-12-17'::date, '2024-12-17'::date, 13100.0, 13100.0, 'WG REFORMAS - mao de obra execucao (em aberto)', 'saida', 'designer', 'despesa', 'pendente', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-17'::date AND fl.valor_total = 13100.0 AND fl.pessoa_id = p.id);

-- 2025-07-19 | R$ 4,000.00 | WG REFORMAS
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2025-07-19'::date, '2025-07-19'::date, 4000.0, 4000.0, 'WG REFORMAS - mao de obra execucao', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-19'::date AND fl.valor_total = 4000.0 AND fl.pessoa_id = p.id);

-- 2025-07-21 | R$ 4,800.00 | WG REFORMAS
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2025-07-21'::date, '2025-07-21'::date, 4800.0, 4800.0, 'WG REFORMAS - mao de obra execucao', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-21'::date AND fl.valor_total = 4800.0 AND fl.pessoa_id = p.id);

-- 2024-12-02 | R$ 5,000.00 | WG REFORMAS (adicional)
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-12-02'::date, '2024-12-02'::date, 5000.0, 5000.0, 'WG REFORMAS - mao de obra adicional', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-02'::date AND fl.valor_total = 5000.0 AND fl.pessoa_id = p.id);

-- PARTE 3: LANCAMENTOS DE OUTROS CLIENTES

-- Uma Uma | 2024-11-29 | R$ 19,972.30
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-11-29'::date, '2024-11-29'::date, 19972.30, 19972.30, 'Uma Uma - Lancamento financeiro', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Uma Uma')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-11-29'::date AND fl.valor_total = 19972.30 AND fl.pessoa_id = p.id);

-- Uma Uma | 2024-12-25 | R$ 19,972.30
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-12-25'::date, '2024-12-25'::date, 19972.30, 19972.30, 'Uma Uma - Lancamento financeiro', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Uma Uma')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-25'::date AND fl.valor_total = 19972.30 AND fl.pessoa_id = p.id);

-- Skic | 2024-11-29 | R$ 2,401.86
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-11-29'::date, '2024-11-29'::date, 2401.86, 2401.86, 'Skic - Lancamento financeiro', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Skic')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-11-29'::date AND fl.valor_total = 2401.86 AND fl.pessoa_id = p.id);

-- Luiz 181B | 2024-11-26 | R$ 3,785.90
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-11-26'::date, '2024-11-26'::date, 3785.90, 3785.90, 'Luiz 181B - Lancamento financeiro', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Luiz 181B')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-11-26'::date AND fl.valor_total = 3785.90 AND fl.pessoa_id = p.id);

-- PARTE 4: LANCAMENTOS DE DEMOLICAO MARINA (periodo anterior)

-- 2024-07-30 | R$ 21,985.36 | Demolicao
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-07-30'::date, '2024-07-30'::date, 21985.36, 21985.36, 'WG REFORMAS - Demolicao', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-07-30'::date AND fl.valor_total = 21985.36 AND fl.pessoa_id = p.id);

-- 2024-08-24 | R$ 1,960.00 | Demolicao
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-08-24'::date, '2024-08-24'::date, 1960.0, 1960.0, 'WG REFORMAS - Demolicao', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-08-24'::date AND fl.valor_total = 1960.0 AND fl.pessoa_id = p.id);

-- 2024-09-03 | R$ 25,305.00 | Demolicao
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id)
SELECT '2024-09-03'::date, '2024-09-03'::date, 25305.0, 25305.0, 'WG REFORMAS - Demolicao', 'saida', 'designer', 'despesa', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-09-03'::date AND fl.valor_total = 25305.0 AND fl.pessoa_id = p.id);

-- PARTE 5: VERIFICACAO POS-IMPORTACAO

-- Resumo por cliente
SELECT
    p.nome as cliente,
    COUNT(*) as total_lancamentos,
    SUM(fl.valor_total) as valor_total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE p.nome IN ('Marina Wikbold', 'Uma Uma', 'Skic', 'Luiz 181B')
GROUP BY p.nome
ORDER BY total_lancamentos DESC;
