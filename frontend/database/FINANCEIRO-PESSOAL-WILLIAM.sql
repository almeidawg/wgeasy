-- ============================================
-- FINANCEIRO PESSOAL - WILLIAM GOMES DE ALMEIDA
-- Founder & CEO - Grupo WG Almeida
-- CPF: 342.339.128-63
-- ============================================
-- Criado em: 2025-12-30
-- Objetivo: Avaliacao trimestral de financas pessoais
-- ============================================

-- PARTE 1: GARANTIR QUE WILLIAM EXISTE COMO PESSOA
-- ============================================

INSERT INTO pessoas (nome, tipo)
SELECT 'William Gomes de Almeida - Pessoal', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('William Gomes de Almeida - Pessoal'));

-- PARTE 2: CADASTRAR EMPRESAS PAGADORAS DE PRO-LABORE
-- ============================================

INSERT INTO pessoas (nome, tipo)
SELECT 'WG Almeida Marcenaria de Alto Padrao Ltda', 'FORNECEDOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) LIKE '%MARCENARIA%ALTO%PADRAO%');

INSERT INTO pessoas (nome, tipo)
SELECT 'Moma Engenharia e Construcao Ltda', 'FORNECEDOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) LIKE '%MOMA%ENGENHARIA%');

INSERT INTO pessoas (nome, tipo)
SELECT 'Moma Comercio de Moveis e Planejados Ltda', 'FORNECEDOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) LIKE '%MOMA%MOVEIS%');

-- PARTE 3: CADASTRAR PESSOAS QUE RECEBEM PAGAMENTOS
-- ============================================

-- Jose Ricardo: Proprietario do apartamento (aluguel) + Vendeu 2 carros
INSERT INTO pessoas (nome, tipo)
SELECT 'Jose Ricardo de Menezes', 'FORNECEDOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Jose Ricardo de Menezes'));

-- Josemar: Colaborador
INSERT INTO pessoas (nome, tipo)
SELECT 'Josemar Joaquim de Souza', 'COLABORADOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Josemar Joaquim de Souza'));

-- Victoria: Irma do William - Recebe repasse de pro-labore
INSERT INTO pessoas (nome, tipo)
SELECT 'Victoria Regina de Almeida', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Victoria Regina de Almeida'));

-- Sandra: Tia do William
INSERT INTO pessoas (nome, tipo)
SELECT 'Sandra Regina de Almeida', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Sandra Regina de Almeida'));

-- Camila: Amiga investidora - Empresta dinheiro com retorno de 10% em 30 dias
INSERT INTO pessoas (nome, tipo)
SELECT 'Camila Gabriella Alves de Almeida Lima', 'FORNECEDOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Camila Gabriella Alves de Almeida Lima'));

-- Claudineide: Diarista
INSERT INTO pessoas (nome, tipo)
SELECT 'Claudineide Leobas Silva', 'FORNECEDOR'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Claudineide Leobas Silva'));

-- ============================================
-- PARTE 4: LANCAMENTOS DE PRO-LABORE (ENTRADAS)
-- Centro de Custo: William Gomes de Almeida
-- ============================================

-- PRO-LABORE WG ALMEIDA ARQUITETURA - 2024
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2024-09-25'::date, '2024-09-25'::date, 3500.0, 3500.0,
'PRO-LABORE - WG Almeida Arquitetura e Comercio Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-09-25'::date AND fl.valor_total = 3500.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%ARQUITETURA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2024-11-11'::date, '2024-11-11'::date, 3525.0, 3525.0,
'PRO-LABORE - WG Almeida Arquitetura e Comercio Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-11-11'::date AND fl.valor_total = 3525.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%ARQUITETURA%');

-- PRO-LABORE WG ALMEIDA MARCENARIA - 2025
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-03-28'::date, '2025-03-28'::date, 5000.0, 5000.0,
'PRO-LABORE - WG Almeida Marcenaria de Alto Padrao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-03-28'::date AND fl.valor_total = 5000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MARCENARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-04-28'::date, '2025-04-28'::date, 5000.0, 5000.0,
'PRO-LABORE - WG Almeida Marcenaria de Alto Padrao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-04-28'::date AND fl.valor_total = 5000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MARCENARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-05-28'::date, '2025-05-28'::date, 5000.0, 5000.0,
'PRO-LABORE - WG Almeida Marcenaria de Alto Padrao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-05-28'::date AND fl.valor_total = 5000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MARCENARIA%');

-- PRO-LABORE MOMA ENGENHARIA - 2025
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-06-17'::date, '2025-06-17'::date, 8000.0, 8000.0,
'PRO-LABORE - Moma Engenharia e Construcao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-17'::date AND fl.valor_total = 8000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%ENGENHARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-07-17'::date, '2025-07-17'::date, 10000.0, 10000.0,
'PRO-LABORE - Moma Engenharia e Construcao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-17'::date AND fl.valor_total = 10000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%ENGENHARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-08-18'::date, '2025-08-18'::date, 12000.0, 12000.0,
'PRO-LABORE - Moma Engenharia e Construcao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-08-18'::date AND fl.valor_total = 12000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%ENGENHARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-09-15'::date, '2025-09-15'::date, 15000.0, 15000.0,
'PRO-LABORE - Moma Engenharia e Construcao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-09-15'::date AND fl.valor_total = 15000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%ENGENHARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-10-15'::date, '2025-10-15'::date, 18000.0, 18000.0,
'PRO-LABORE - Moma Engenharia e Construcao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-10-15'::date AND fl.valor_total = 18000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%ENGENHARIA%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-11-15'::date, '2025-11-15'::date, 12000.0, 12000.0,
'PRO-LABORE - Moma Engenharia e Construcao Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-11-15'::date AND fl.valor_total = 12000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%ENGENHARIA%');

-- PRO-LABORE MOMA MOVEIS - 2025
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-06-25'::date, '2025-06-25'::date, 6000.0, 6000.0,
'PRO-LABORE - Moma Comercio de Moveis e Planejados Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-25'::date AND fl.valor_total = 6000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%MOVEIS%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-07-25'::date, '2025-07-25'::date, 8000.0, 8000.0,
'PRO-LABORE - Moma Comercio de Moveis e Planejados Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-25'::date AND fl.valor_total = 8000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%MOVEIS%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-08-25'::date, '2025-08-25'::date, 10000.0, 10000.0,
'PRO-LABORE - Moma Comercio de Moveis e Planejados Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-08-25'::date AND fl.valor_total = 10000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%MOVEIS%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-09-25'::date, '2025-09-25'::date, 12000.0, 12000.0,
'PRO-LABORE - Moma Comercio de Moveis e Planejados Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-09-25'::date AND fl.valor_total = 12000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%MOVEIS%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-10-25'::date, '2025-10-25'::date, 10000.0, 10000.0,
'PRO-LABORE - Moma Comercio de Moveis e Planejados Ltda', 'entrada', 'pessoal', 'receita', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-10-25'::date AND fl.valor_total = 10000.0 AND fl.pessoa_id = p.id AND fl.descricao LIKE '%PRO-LABORE%MOMA%MOVEIS%');

-- ============================================
-- PARTE 4B: DESPESAS PESSOAIS FIXAS
-- ============================================

-- ALUGUEL - Jose Ricardo de Menezes (Locador)
-- Valor: R$ 4.000/mes

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-06-01'::date, '2025-06-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-07-01'::date, '2025-07-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-08-01'::date, '2025-08-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-08-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-09-01'::date, '2025-09-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-09-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-10-01'::date, '2025-10-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-10-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-11-01'::date, '2025-11-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-11-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-12-01'::date, '2025-12-01'::date, 4000.0, 4000.0,
'ALUGUEL - Apartamento - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-12-01'::date AND fl.descricao LIKE '%ALUGUEL%Jose Ricardo%');

-- COMPRA DE VEICULOS - Jose Ricardo de Menezes
-- Mercedes (mais antigo): R$ 10.000
-- Audi: R$ 35.000

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-06-15'::date, '2025-06-15'::date, 10000.0, 10000.0,
'COMPRA VEICULO - Mercedes - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.descricao LIKE '%Mercedes%Jose Ricardo%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-09-20'::date, '2025-09-20'::date, 35000.0, 35000.0,
'COMPRA VEICULO - Audi - Jose Ricardo de Menezes', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.descricao LIKE '%Audi%Jose Ricardo%');

-- PAGAMENTO DIARISTA - Claudineide Leobas Silva
-- Valor estimado mensal

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-06-15'::date, '2025-06-15'::date, 800.0, 800.0,
'DIARISTA - Claudineide Leobas Silva', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-15'::date AND fl.descricao LIKE '%DIARISTA%Claudineide%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-07-15'::date, '2025-07-15'::date, 800.0, 800.0,
'DIARISTA - Claudineide Leobas Silva', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-15'::date AND fl.descricao LIKE '%DIARISTA%Claudineide%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-08-15'::date, '2025-08-15'::date, 800.0, 800.0,
'DIARISTA - Claudineide Leobas Silva', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-08-15'::date AND fl.descricao LIKE '%DIARISTA%Claudineide%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-09-15'::date, '2025-09-15'::date, 800.0, 800.0,
'DIARISTA - Claudineide Leobas Silva', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-09-15'::date AND fl.descricao LIKE '%DIARISTA%Claudineide%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-10-15'::date, '2025-10-15'::date, 800.0, 800.0,
'DIARISTA - Claudineide Leobas Silva', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-10-15'::date AND fl.descricao LIKE '%DIARISTA%Claudineide%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-11-15'::date, '2025-11-15'::date, 800.0, 800.0,
'DIARISTA - Claudineide Leobas Silva', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-11-15'::date AND fl.descricao LIKE '%DIARISTA%Claudineide%');

-- ============================================
-- PARTE 4C: REPASSE PRO-LABORE PARA IRMA (VICTORIA)
-- ============================================

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-07-15'::date, '2025-07-15'::date, 2000.0, 2000.0,
'REPASSE PRO-LABORE - Victoria Regina de Almeida (Irma)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-15'::date AND fl.descricao LIKE '%REPASSE%Victoria%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-08-15'::date, '2025-08-15'::date, 2000.0, 2000.0,
'REPASSE PRO-LABORE - Victoria Regina de Almeida (Irma)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-08-15'::date AND fl.descricao LIKE '%REPASSE%Victoria%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-09-15'::date, '2025-09-15'::date, 2500.0, 2500.0,
'REPASSE PRO-LABORE - Victoria Regina de Almeida (Irma)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-09-15'::date AND fl.descricao LIKE '%REPASSE%Victoria%');

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-10-15'::date, '2025-10-15'::date, 2500.0, 2500.0,
'REPASSE PRO-LABORE - Victoria Regina de Almeida (Irma)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-10-15'::date AND fl.descricao LIKE '%REPASSE%Victoria%');

-- ============================================
-- PARTE 5: DIVIDAS BANCARIAS (Controle de Passivo)
-- ============================================

-- DIVIDA ITAU PERSONNALITE - Posicao Dez/2024
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2024-12-31'::date, '2024-12-31'::date, 127471.08, 127471.08,
'DIVIDA - Itau Personnalite - Saldo em 31/12/2024 (4 contratos)', 'saida', 'pessoal', 'despesa', 'pendente', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-31'::date AND fl.descricao LIKE '%DIVIDA%Itau%Personnalite%');

-- DIVIDA BANCO ORIGINAL - Posicao Dez/2024 (INADIMPLENTE)
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2024-12-31'::date, '2024-12-31'::date, 76620.77, 76620.77,
'DIVIDA INADIMPLENTE - Banco Original/PicPay - Saldo em 31/12/2024 (3 contratos) [VENCIDO]', 'saida', 'pessoal', 'despesa', 'pendente', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-31'::date AND fl.descricao LIKE '%DIVIDA%Banco Original%');

-- ============================================
-- PARTE 6: IMPOSTOS PAGOS
-- ============================================

INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2025-04-30'::date, '2025-04-30'::date, 4405.27, 4405.27,
'IMPOSTO - DARF Ministerio da Fazenda', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-04-30'::date AND fl.valor_total = 4405.27 AND fl.pessoa_id = p.id);

-- ============================================
-- PARTE 7: HISTORICO DE DIVIDAS ITAU (para analise trimestral)
-- ============================================

-- 2017
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2017-12-31'::date, '2017-12-31'::date, 128539.16, 128539.16,
'HISTORICO DIVIDA - Itau Personnalite - Posicao 31/12/2017', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2017-12-31'::date AND fl.descricao LIKE '%HISTORICO DIVIDA%Itau%2017%');

-- 2018
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2018-12-31'::date, '2018-12-31'::date, 126947.36, 126947.36,
'HISTORICO DIVIDA - Itau Personnalite - Posicao 31/12/2018', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2018-12-31'::date AND fl.descricao LIKE '%HISTORICO DIVIDA%Itau%2018%');

-- 2019
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2019-12-31'::date, '2019-12-31'::date, 126906.37, 126906.37,
'HISTORICO DIVIDA - Itau Personnalite - Posicao 31/12/2019', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2019-12-31'::date AND fl.descricao LIKE '%HISTORICO DIVIDA%Itau%2019%');

-- 2020 (Renegociacao)
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2020-12-31'::date, '2020-12-31'::date, 82146.13, 82146.13,
'HISTORICO DIVIDA - Itau Personnalite - Posicao 31/12/2020 (Renegociado Set/2020)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2020-12-31'::date AND fl.descricao LIKE '%HISTORICO DIVIDA%Itau%2020%');

-- 2021 (QUITADO!) - Nao inserir pois valor = 0 nao e permitido
-- Marco historico: Divida Itau Personnalite foi QUITADA em 2021

-- 2022 (Novo emprestimo)
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2022-12-31'::date, '2022-12-31'::date, 96625.92, 96625.92,
'HISTORICO DIVIDA - Itau Personnalite - Posicao 31/12/2022 (Novo emprestimo Dez/2022)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-12-31'::date AND fl.descricao LIKE '%HISTORICO DIVIDA%Itau%2022%');

-- 2023 (Renegociacao)
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id)
SELECT '2023-12-31'::date, '2023-12-31'::date, 127644.48, 127644.48,
'HISTORICO DIVIDA - Itau Personnalite - Posicao 31/12/2023 (Renegociado Mar/2023)', 'saida', 'pessoal', 'despesa', 'pago', p.id
FROM pessoas p WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2023-12-31'::date AND fl.descricao LIKE '%HISTORICO DIVIDA%Itau%2023%');

-- ============================================
-- PARTE 8: QUERIES PARA AVALIACAO TRIMESTRAL
-- ============================================

-- Query 1: Resumo de Pro-labore por Trimestre
/*
SELECT
    EXTRACT(YEAR FROM data_competencia) as ano,
    EXTRACT(QUARTER FROM data_competencia) as trimestre,
    SUM(valor_total) as total_prolabore
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND fl.descricao LIKE '%PRO-LABORE%'
GROUP BY EXTRACT(YEAR FROM data_competencia), EXTRACT(QUARTER FROM data_competencia)
ORDER BY ano, trimestre;
*/

-- Query 2: Evolucao de Dividas por Ano
/*
SELECT
    EXTRACT(YEAR FROM data_competencia) as ano,
    MAX(valor_total) as divida_total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND fl.descricao LIKE '%HISTORICO DIVIDA%'
GROUP BY EXTRACT(YEAR FROM data_competencia)
ORDER BY ano;
*/

-- Query 3: Balanco Geral (Entradas vs Saidas)
/*
SELECT
    tipo,
    SUM(valor_total) as total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND descricao NOT LIKE '%HISTORICO DIVIDA%'
GROUP BY tipo;
*/

-- Query 4: Dividas Atuais (Pendentes e Vencidas)
/*
SELECT
    descricao,
    valor_total,
    status,
    data_competencia
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND status = 'pendente'
ORDER BY valor_total DESC;
*/

-- ============================================
-- VERIFICACAO POS-IMPORTACAO
-- ============================================

SELECT
    'PRO-LABORE' as categoria,
    COUNT(*) as qtd_lancamentos,
    SUM(valor_total) as valor_total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND fl.descricao LIKE '%PRO-LABORE%'

UNION ALL

SELECT
    'DIVIDAS' as categoria,
    COUNT(*) as qtd_lancamentos,
    SUM(valor_total) as valor_total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND fl.descricao LIKE '%DIVIDA%'
AND fl.descricao NOT LIKE '%HISTORICO%'

UNION ALL

SELECT
    'IMPOSTOS' as categoria,
    COUNT(*) as qtd_lancamentos,
    SUM(valor_total) as valor_total
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('William Gomes de Almeida - Pessoal')
AND fl.descricao LIKE '%IMPOSTO%';
