-- ============================================================
-- DIAGNÓSTICO: ESTRUTURA DAS TABELAS REEMBOLSOS E COBRANCAS
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================

-- 1. Estrutura da tabela REEMBOLSOS
SELECT
    'REEMBOLSOS' as tabela,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'reembolsos'
ORDER BY ordinal_position;

-- 2. Estrutura da tabela COBRANCAS
SELECT
    'COBRANCAS' as tabela,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'cobrancas'
ORDER BY ordinal_position;

-- 3. Foreign Keys existentes em REEMBOLSOS
SELECT
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table,
    ccu.column_name AS foreign_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'reembolsos'
  AND tc.constraint_type = 'FOREIGN KEY';

-- 4. Foreign Keys existentes em COBRANCAS
SELECT
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table,
    ccu.column_name AS foreign_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name = 'cobrancas'
  AND tc.constraint_type = 'FOREIGN KEY';

-- 5. Amostra de dados de REEMBOLSOS (ver campos preenchidos)
SELECT * FROM reembolsos LIMIT 5;

-- 6. Amostra de dados de COBRANCAS
SELECT * FROM cobrancas LIMIT 5;
