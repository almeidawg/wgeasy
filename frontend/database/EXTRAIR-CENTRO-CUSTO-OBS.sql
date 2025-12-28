-- ============================================
-- EXTRAIR CENTRO DE CUSTO DAS OBSERVAÇÕES
-- ============================================

-- 1. Ver formato das observações
SELECT id, descricao, observacoes
FROM financeiro_lancamentos
WHERE observacoes IS NOT NULL AND observacoes != ''
LIMIT 10;

-- 2. Extrair centros de custo únicos (assumindo formato "Centro: NOME | ...")
SELECT DISTINCT
    TRIM(SUBSTRING(observacoes FROM 'Centro: ([^|]+)')) as centro_custo,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE observacoes LIKE '%Centro:%'
GROUP BY TRIM(SUBSTRING(observacoes FROM 'Centro: ([^|]+)'))
ORDER BY total DESC;

-- 3. Total de centros de custo únicos
SELECT COUNT(DISTINCT TRIM(SUBSTRING(observacoes FROM 'Centro: ([^|]+)'))) as total_centros
FROM financeiro_lancamentos
WHERE observacoes LIKE '%Centro:%';
