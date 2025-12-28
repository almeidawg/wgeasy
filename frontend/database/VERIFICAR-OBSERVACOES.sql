-- ============================================
-- VERIFICAR CONTEÚDO DAS OBSERVAÇÕES
-- ============================================

-- 1. Ver exemplos de observações
SELECT id, descricao, observacoes, nucleo
FROM financeiro_lancamentos
WHERE observacoes IS NOT NULL
LIMIT 10;

-- 2. Contar registros com observações
SELECT
    COUNT(*) as total_registros,
    COUNT(observacoes) as com_observacoes,
    COUNT(*) - COUNT(observacoes) as sem_observacoes
FROM financeiro_lancamentos;

-- 3. Ver distribuição atual
SELECT nucleo, COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;
