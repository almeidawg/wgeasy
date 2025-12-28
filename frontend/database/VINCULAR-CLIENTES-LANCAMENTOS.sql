-- ============================================
-- VINCULAR LANÇAMENTOS AOS CLIENTES (CENTRO DE CUSTO)
-- ============================================

-- 1. Verificar quantos lançamentos têm pessoa_id preenchido
SELECT
    CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END as status,
    COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END;

-- 2. Ver exemplos de descrições para identificar padrão
SELECT DISTINCT
    LEFT(descricao, 50) as descricao_inicio,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE pessoa_id IS NULL
GROUP BY LEFT(descricao, 50)
ORDER BY total DESC
LIMIT 20;

-- 3. Ver lista de clientes/pessoas cadastradas
SELECT id, nome, tipo
FROM pessoas
ORDER BY nome
LIMIT 50;
