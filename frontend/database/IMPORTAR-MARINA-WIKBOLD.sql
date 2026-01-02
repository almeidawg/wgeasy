-- ============================================
-- IMPORTACAO AUTOMATICA: MARINA WIKBOLD
-- Gerado em: 2025-12-30 15:03:33
-- Total de lancamentos: Verificar apos execucao
-- ============================================

-- PARTE 1: CADASTRAR CLIENTE (se nao existir)
-- ============================================

INSERT INTO pessoas (nome, tipo)
SELECT 'Marina Wikbold', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Marina Wikbold')
);

-- ============================================
-- PARTE 2: IMPORTAR LANCAMENTOS (com verificacao de duplicidade)
-- ============================================


-- Lancamento 1: 2024-09-19 | R$ 39,300.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-09-19'::date,
    39300.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-09-19'::date
    AND fl.valor_total = 39300.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 2: 2024-10-18 | R$ 13,100.00 | WG REFORMAS
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-10-18'::date,
    13100.0,
    'WG REFORMAS - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-10-18'::date
    AND fl.valor_total = 13100.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 3: 2024-11-01 | R$ 13,100.00 | WG REFORMAS
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-11-01'::date,
    13100.0,
    'WG REFORMAS - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-11-01'::date
    AND fl.valor_total = 13100.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 4: 2024-11-18 | R$ 13,100.00 | WG REFORMAS
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-11-18'::date,
    13100.0,
    'WG REFORMAS - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-11-18'::date
    AND fl.valor_total = 13100.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 5: 2024-12-02 | R$ 13,100.00 | WG REFORMAS
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-02'::date,
    13100.0,
    'WG REFORMAS - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-02'::date
    AND fl.valor_total = 13100.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 6: 2025-01-09 | R$ 13,100.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-01-09'::date,
    13100.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-01-09'::date
    AND fl.valor_total = 13100.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 7: 2025-04-23 | R$ 5,000.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-04-23'::date,
    5000.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-04-23'::date
    AND fl.valor_total = 5000.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 8: 2025-05-16 | R$ 7,200.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-05-16'::date,
    7200.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-05-16'::date
    AND fl.valor_total = 7200.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 9: 2025-06-20 | R$ 4,000.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-06-20'::date,
    4000.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-06-20'::date
    AND fl.valor_total = 4000.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 10: 2025-07-18 | R$ 6,000.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-07-18'::date,
    6000.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-07-18'::date
    AND fl.valor_total = 6000.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 11: 2025-06-20 | R$ 2,800.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-06-20'::date,
    2800.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-06-20'::date
    AND fl.valor_total = 2800.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 12: 2025-06-20 | R$ 4,000.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-06-20'::date,
    4000.0,
    'WG REFORMAS  - mão de obra execução da obra',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-06-20'::date
    AND fl.valor_total = 4000.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 13: 2025-04-24 | R$ 46.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-04-24'::date,
    46.0,
    'WG REFORMAS  - cano, conexão de dreno e cola',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-04-24'::date
    AND fl.valor_total = 46.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 14: 2025-04-29 | R$ 143.31 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-04-29'::date,
    143.31,
    'WG REFORMAS  - conexões de hidraulica e sauna',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-04-29'::date
    AND fl.valor_total = 143.31
    AND fl.pessoa_id = p.id
);

-- Lancamento 15: 2025-05-05 | R$ 80.99 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-05-05'::date,
    80.99,
    'WG REFORMAS  - Fita dupla face 3m',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-05-05'::date
    AND fl.valor_total = 80.99
    AND fl.pessoa_id = p.id
);

-- Lancamento 16: 2025-05-06 | R$ 264.70 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-05-06'::date,
    264.7,
    'WG REFORMAS  - panos, fita crepe e lona preta',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-05-06'::date
    AND fl.valor_total = 264.7
    AND fl.pessoa_id = p.id
);

-- Lancamento 17: 2025-05-06 | R$ 12.90 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-05-06'::date,
    12.9,
    'WG REFORMAS  - Entre de Material',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-05-06'::date
    AND fl.valor_total = 12.9
    AND fl.pessoa_id = p.id
);

-- Lancamento 18: 2025-05-14 | R$ 259.80 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-05-14'::date,
    259.8,
    'WG REFORMAS  - duas latas de massa corrida',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-05-14'::date
    AND fl.valor_total = 259.8
    AND fl.pessoa_id = p.id
);

-- Lancamento 19: 2025-02-28 | R$ 14,000.00 | WG REFORMAS 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2025-02-28'::date,
    14000.0,
    'WG REFORMAS',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2025-02-28'::date
    AND fl.valor_total = 14000.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 20: 2024-09-20 | R$ 6,736.86 | NICOM
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-09-20'::date,
    6736.86,
    'NICOM - material inicial',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-09-20'::date
    AND fl.valor_total = 6736.86
    AND fl.pessoa_id = p.id
);

-- Lancamento 21: 2024-09-25 | R$ 1,517.00 | MERCADO LIVRE
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-09-25'::date,
    1517.0,
    'MERCADO LIVRE - registros',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-09-25'::date
    AND fl.valor_total = 1517.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 22: 2024-10-03 | R$ 211.00 | NOVA DE NOVO
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-10-03'::date,
    211.0,
    'NOVA DE NOVO - complemento de tijolinhos',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-10-03'::date
    AND fl.valor_total = 211.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 23: 2024-09-26 | R$ 3,937.00 | NOVA DE NOVO
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-09-26'::date,
    3937.0,
    'NOVA DE NOVO - tijolinhos',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-09-26'::date
    AND fl.valor_total = 3937.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 24: 2024-10-17 | R$ 1,636.10 | NOVA CONSTRUÇÃO
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-10-17'::date,
    1636.1,
    'NOVA CONSTRUÇÃO - material hidraulica',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-10-17'::date
    AND fl.valor_total = 1636.1
    AND fl.pessoa_id = p.id
);

-- Lancamento 25: 2024-10-25 | R$ 21,035.20 | LEROY MERLIN 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-10-25'::date,
    21035.2,
    'LEROY MERLIN  - revestimentos',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-10-25'::date
    AND fl.valor_total = 21035.2
    AND fl.pessoa_id = p.id
);

-- Lancamento 26: 2024-12-02 | R$ 4,800.00 | MARACA MATERIAL 
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-02'::date,
    4800.0,
    'MARACA MATERIAL  - eletrico e hidraulica',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-02'::date
    AND fl.valor_total = 4800.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 27: 2024-12-05 | R$ 1,134.17 | NICOM
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-05'::date,
    1134.17,
    'NICOM - material eletrico',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-05'::date
    AND fl.valor_total = 1134.17
    AND fl.pessoa_id = p.id
);

-- Lancamento 28: 2024-12-20 | R$ 537.68 | MERCADO LIVRE
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-20'::date,
    537.68,
    'MERCADO LIVRE - cabo plastchumbo',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-20'::date
    AND fl.valor_total = 537.68
    AND fl.pessoa_id = p.id
);

-- Lancamento 29: 2024-12-20 | R$ 5,250.00 | SAUNA  
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-20'::date,
    5250.0,
    'SAUNA   - sauna',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-20'::date
    AND fl.valor_total = 5250.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 30: 2024-12-20 | R$ 4,400.00 | STM PORTAS
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-20'::date,
    4400.0,
    'STM PORTAS - portas ambientes',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-20'::date
    AND fl.valor_total = 4400.0
    AND fl.pessoa_id = p.id
);

-- Lancamento 31: 2024-12-24 | R$ 180.50 | NOVA CONSTRUÇÃO
INSERT INTO financeiro_lancamentos (
    data_lancamento, 
    valor_total, 
    descricao, 
    tipo, 
    nucleo,
    pessoa_id
)
SELECT 
    '2024-12-24'::date,
    180.5,
    'NOVA CONSTRUÇÃO - material hidraulica',
    'saida',
    'designer',
    p.id
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_lancamento = '2024-12-24'::date
    AND fl.valor_total = 180.5
    AND fl.pessoa_id = p.id
);

-- ============================================
-- PARTE 3: VERIFICACAO POS-IMPORTACAO
-- ============================================

-- Resumo de lancamentos importados
SELECT 
    'Marina Wikbold' as cliente,
    COUNT(*) as total_lancamentos,
    SUM(CASE WHEN tipo = 'entrada' THEN valor_total ELSE 0 END) as entradas,
    SUM(CASE WHEN tipo = 'saida' THEN valor_total ELSE 0 END) as saidas
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('Marina Wikbold');

-- Lista dos lancamentos importados
SELECT 
    fl.data_lancamento,
    fl.valor_total,
    fl.descricao,
    fl.tipo
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE UPPER(p.nome) = UPPER('Marina Wikbold')
ORDER BY fl.data_lancamento;
