-- ============================================
-- IMPORTACAO AUTOMATICA DE CLIENTES E LANCAMENTOS
-- Gerado em: 2025-12-30 15:37:32
-- Com verificacao automatica de duplicidade
-- CORRIGIDO: Usando colunas corretas da tabela
-- ============================================

-- PARTE 1: CADASTRAR TODOS OS NOVOS CLIENTES

INSERT INTO pessoas (nome, tipo) SELECT 'Marina Wikbold', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Marina Wikbold'));
INSERT INTO pessoas (nome, tipo) SELECT 'Luli e Beto', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Luli e Beto'));
INSERT INTO pessoas (nome, tipo) SELECT 'Uma Uma', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Uma Uma'));
INSERT INTO pessoas (nome, tipo) SELECT 'Ronaldo Wickbold', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Ronaldo Wickbold'));
INSERT INTO pessoas (nome, tipo) SELECT 'Marlisson Fabricio', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Marlisson Fabricio'));
INSERT INTO pessoas (nome, tipo) SELECT 'Luana Mineli', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Luana Mineli'));
INSERT INTO pessoas (nome, tipo) SELECT 'Thais Caminotto', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Thais Caminotto'));
INSERT INTO pessoas (nome, tipo) SELECT 'Thais Fonseca', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Thais Fonseca'));
INSERT INTO pessoas (nome, tipo) SELECT 'Andressa e Tiago Corsi', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Andressa e Tiago Corsi'));
INSERT INTO pessoas (nome, tipo) SELECT 'Ana Paula e Ademir', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Ana Paula e Ademir'));
INSERT INTO pessoas (nome, tipo) SELECT 'Ana e Marcio', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Ana e Marcio'));
INSERT INTO pessoas (nome, tipo) SELECT 'Elvis e Paula', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Elvis e Paula'));
INSERT INTO pessoas (nome, tipo) SELECT 'Vanusa JVCORPORATE', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Vanusa JVCORPORATE'));
INSERT INTO pessoas (nome, tipo) SELECT 'Moma Brooklin Showroom', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Moma Brooklin Showroom'));
INSERT INTO pessoas (nome, tipo) SELECT 'Tamara e Henrique', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Tamara e Henrique'));
INSERT INTO pessoas (nome, tipo) SELECT 'Ricardo Mistrone', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Ricardo Mistrone'));
INSERT INTO pessoas (nome, tipo) SELECT 'ELIANA KIELLANDER LOPES', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('ELIANA KIELLANDER LOPES'));
INSERT INTO pessoas (nome, tipo) SELECT 'RAFAEL DE SOUZA LACERDA', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('RAFAEL DE SOUZA LACERDA'));
INSERT INTO pessoas (nome, tipo) SELECT 'RAPHAEL HENRIQUE PINTO PIRES', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('RAPHAEL HENRIQUE PINTO PIRES'));
INSERT INTO pessoas (nome, tipo) SELECT 'SARA MELO MACEDO', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('SARA MELO MACEDO'));
INSERT INTO pessoas (nome, tipo) SELECT 'ADEMIR DE QUADROS', 'CLIENTE' WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('ADEMIR DE QUADROS'));

-- PARTE 2: IMPORTAR LANCAMENTOS DE MARINA WIKBOLD
-- Colunas: data_competencia, data_emissao, valor_total, descricao, tipo, nucleo, natureza, pessoa_id

-- 1: 2024-09-19 | R$ 39,300.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-09-19'::date, '2024-09-19'::date, 39300.0, 39300.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-09-19'::date AND fl.valor_total = 39300.0 AND fl.pessoa_id = p.id);

-- 2: 2024-10-18 | R$ 13,100.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-10-18'::date, '2024-10-18'::date, 13100.0, 13100.0, 'WG REFORMAS - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-10-18'::date AND fl.valor_total = 13100.0 AND fl.pessoa_id = p.id);

-- 3: 2024-11-01 | R$ 13,100.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-11-01'::date, '2024-11-01'::date, 13100.0, 13100.0, 'WG REFORMAS - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-11-01'::date AND fl.valor_total = 13100.0 AND fl.pessoa_id = p.id);

-- 4: 2024-11-18 | R$ 13,100.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-11-18'::date, '2024-11-18'::date, 13100.0, 13100.0, 'WG REFORMAS - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-11-18'::date AND fl.valor_total = 13100.0 AND fl.pessoa_id = p.id);

-- 5: 2024-12-02 | R$ 13,100.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-02'::date, '2024-12-02'::date, 13100.0, 13100.0, 'WG REFORMAS - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-02'::date AND fl.valor_total = 13100.0 AND fl.pessoa_id = p.id);

-- 6: 2025-01-09 | R$ 13,100.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-01-09'::date, '2025-01-09'::date, 13100.0, 13100.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-01-09'::date AND fl.valor_total = 13100.0 AND fl.pessoa_id = p.id);

-- 7: 2025-04-23 | R$ 5,000.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-04-23'::date, '2025-04-23'::date, 5000.0, 5000.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-04-23'::date AND fl.valor_total = 5000.0 AND fl.pessoa_id = p.id);

-- 8: 2025-05-16 | R$ 7,200.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-05-16'::date, '2025-05-16'::date, 7200.0, 7200.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-05-16'::date AND fl.valor_total = 7200.0 AND fl.pessoa_id = p.id);

-- 9: 2025-06-20 | R$ 4,000.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-06-20'::date, '2025-06-20'::date, 4000.0, 4000.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-20'::date AND fl.valor_total = 4000.0 AND fl.pessoa_id = p.id);

-- 10: 2025-07-18 | R$ 6,000.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-07-18'::date, '2025-07-18'::date, 6000.0, 6000.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-07-18'::date AND fl.valor_total = 6000.0 AND fl.pessoa_id = p.id);

-- 11: 2025-06-20 | R$ 2,800.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-06-20'::date, '2025-06-20'::date, 2800.0, 2800.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-20'::date AND fl.valor_total = 2800.0 AND fl.pessoa_id = p.id);

-- 12: 2025-06-20 | R$ 4,000.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-06-20'::date, '2025-06-20'::date, 4000.0, 4000.0, 'WG REFORMAS  - mão de obra execução da obra', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-06-20'::date AND fl.valor_total = 4000.0 AND fl.pessoa_id = p.id);

-- 13: 2025-04-24 | R$ 46.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-04-24'::date, '2025-04-24'::date, 46.0, 46.0, 'WG REFORMAS  - cano, conexão de dreno e cola', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-04-24'::date AND fl.valor_total = 46.0 AND fl.pessoa_id = p.id);

-- 14: 2025-04-29 | R$ 143.31
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-04-29'::date, '2025-04-29'::date, 143.31, 143.31, 'WG REFORMAS  - conexões de hidraulica e sauna', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-04-29'::date AND fl.valor_total = 143.31 AND fl.pessoa_id = p.id);

-- 15: 2025-05-05 | R$ 80.99
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-05-05'::date, '2025-05-05'::date, 80.99, 80.99, 'WG REFORMAS  - Fita dupla face 3m', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-05-05'::date AND fl.valor_total = 80.99 AND fl.pessoa_id = p.id);

-- 16: 2025-05-06 | R$ 264.70
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-05-06'::date, '2025-05-06'::date, 264.7, 264.7, 'WG REFORMAS  - panos, fita crepe e lona preta', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-05-06'::date AND fl.valor_total = 264.7 AND fl.pessoa_id = p.id);

-- 17: 2025-05-06 | R$ 12.90
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-05-06'::date, '2025-05-06'::date, 12.9, 12.9, 'WG REFORMAS  - Entre de Material', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-05-06'::date AND fl.valor_total = 12.9 AND fl.pessoa_id = p.id);

-- 18: 2025-05-14 | R$ 259.80
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-05-14'::date, '2025-05-14'::date, 259.8, 259.8, 'WG REFORMAS  - duas latas de massa corrida', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-05-14'::date AND fl.valor_total = 259.8 AND fl.pessoa_id = p.id);

-- 19: 2025-02-28 | R$ 14,000.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2025-02-28'::date, '2025-02-28'::date, 14000.0, 14000.0, 'WG REFORMAS', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2025-02-28'::date AND fl.valor_total = 14000.0 AND fl.pessoa_id = p.id);

-- 20: 2024-09-20 | R$ 6,736.86
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-09-20'::date, '2024-09-20'::date, 6736.86, 6736.86, 'NICOM - material inicial', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-09-20'::date AND fl.valor_total = 6736.86 AND fl.pessoa_id = p.id);

-- 21: 2024-09-25 | R$ 1,517.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-09-25'::date, '2024-09-25'::date, 1517.0, 1517.0, 'MERCADO LIVRE - registros', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-09-25'::date AND fl.valor_total = 1517.0 AND fl.pessoa_id = p.id);

-- 22: 2024-10-03 | R$ 211.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-10-03'::date, '2024-10-03'::date, 211.0, 211.0, 'NOVA DE NOVO - complemento de tijolinhos', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-10-03'::date AND fl.valor_total = 211.0 AND fl.pessoa_id = p.id);

-- 23: 2024-09-26 | R$ 3,937.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-09-26'::date, '2024-09-26'::date, 3937.0, 3937.0, 'NOVA DE NOVO - tijolinhos', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-09-26'::date AND fl.valor_total = 3937.0 AND fl.pessoa_id = p.id);

-- 24: 2024-10-17 | R$ 1,636.10
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-10-17'::date, '2024-10-17'::date, 1636.1, 1636.1, 'NOVA CONSTRUÇÃO - material hidraulica', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-10-17'::date AND fl.valor_total = 1636.1 AND fl.pessoa_id = p.id);

-- 25: 2024-10-25 | R$ 21,035.20
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-10-25'::date, '2024-10-25'::date, 21035.2, 21035.2, 'LEROY MERLIN  - revestimentos', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-10-25'::date AND fl.valor_total = 21035.2 AND fl.pessoa_id = p.id);

-- 26: 2024-12-02 | R$ 4,800.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-02'::date, '2024-12-02'::date, 4800.0, 4800.0, 'MARACA MATERIAL  - eletrico e hidraulica', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-02'::date AND fl.valor_total = 4800.0 AND fl.pessoa_id = p.id);

-- 27: 2024-12-05 | R$ 1,134.17
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-05'::date, '2024-12-05'::date, 1134.17, 1134.17, 'NICOM - material eletrico', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-05'::date AND fl.valor_total = 1134.17 AND fl.pessoa_id = p.id);

-- 28: 2024-12-20 | R$ 537.68
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-20'::date, '2024-12-20'::date, 537.68, 537.68, 'MERCADO LIVRE - cabo plastchumbo', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-20'::date AND fl.valor_total = 537.68 AND fl.pessoa_id = p.id);

-- 29: 2024-12-20 | R$ 5,250.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-20'::date, '2024-12-20'::date, 5250.0, 5250.0, 'SAUNA   - sauna', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-20'::date AND fl.valor_total = 5250.0 AND fl.pessoa_id = p.id);

-- 30: 2024-12-20 | R$ 4,400.00
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-20'::date, '2024-12-20'::date, 4400.0, 4400.0, 'STM PORTAS - portas ambientes', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-20'::date AND fl.valor_total = 4400.0 AND fl.pessoa_id = p.id);

-- 31: 2024-12-24 | R$ 180.50
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, pessoa_id) SELECT '2024-12-24'::date, '2024-12-24'::date, 180.5, 180.5, 'NOVA CONSTRUÇÃO - material hidraulica', 'saida', 'designer', 'despesa', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-12-24'::date AND fl.valor_total = 180.5 AND fl.pessoa_id = p.id);

-- LANCAMENTOS PENDENTES (sem data definida)

-- Pendente 1: R$ 37,423.11 | CLIMA FRIO 
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 37423.11, 37423.11, 'CLIMA FRIO  - ar condicionado (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 37423.11 AND fl.pessoa_id = p.id);

-- Pendente 2: R$ 38,297.00 | PEDRAS GALICIA
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 38297.0, 38297.0, 'PEDRAS GALICIA - marmoraria (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 38297.0 AND fl.pessoa_id = p.id);

-- Pendente 3: R$ 2,544.00 | MARACA MATERIAL
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 2544.0, 2544.0, 'MARACA MATERIAL - material eletrico (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 2544.0 AND fl.pessoa_id = p.id);

-- Pendente 4: R$ 208,517.00 | WG MARCENARIA
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 208517.0, 208517.0, 'WG MARCENARIA - marcenaria (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 208517.0 AND fl.pessoa_id = p.id);

-- Pendente 5: R$ 6,000.00 | -
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 6000.0, 6000.0, 'bacias sanitárias (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 6000.0 AND fl.pessoa_id = p.id);

-- Pendente 6: R$ 11,825.00 | SANTIL 
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 11825.0, 11825.0, 'SANTIL  - Luminarias (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 11825.0 AND fl.pessoa_id = p.id);

-- Pendente 7: R$ 4,500.00 | -
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 4500.0, 4500.0, 'Interruptores e Tomadas (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 4500.0 AND fl.pessoa_id = p.id);

-- Pendente 8: R$ 22,580.00 | LEAO GLASS 
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 22580.0, 22580.0, 'LEAO GLASS  - vidros e espelhos (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 22580.0 AND fl.pessoa_id = p.id);

-- Pendente 9: R$ 549,277.02 | 
INSERT INTO financeiro_lancamentos (data_competencia, data_emissao, valor_total, valor, descricao, tipo, nucleo, natureza, status, pessoa_id) SELECT CURRENT_DATE, CURRENT_DATE, 549277.02, 549277.02, 'Lancamento (PENDENTE)', 'saida', 'designer', 'despesa', 'pendente', p.id FROM pessoas p WHERE UPPER(p.nome) = UPPER('Marina Wikbold') AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.valor_total = 549277.02 AND fl.pessoa_id = p.id);

-- PARTE 3: VERIFICACAO POS-IMPORTACAO

SELECT p.nome as cliente, COUNT(*) as total_lancamentos, SUM(fl.valor_total) as valor_total 
FROM financeiro_lancamentos fl 
JOIN pessoas p ON fl.pessoa_id = p.id 
WHERE UPPER(p.nome) = UPPER('Marina Wikbold') 
GROUP BY p.nome;

-- Lista de clientes novos cadastrados
SELECT nome, tipo, created_at FROM pessoas WHERE tipo = 'CLIENTE' ORDER BY created_at DESC LIMIT 25;
