-- ============================================
-- EXTRAIR CENTROS DE CUSTO DAS OBSERVAÇÕES
-- ============================================

-- 1. Ver quais centros de custo existem nas observações
SELECT DISTINCT
    TRIM(SUBSTRING(observacoes FROM 'Centro: ([^|]+)')) as centro_custo_texto,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE observacoes LIKE '%Centro:%'
GROUP BY TRIM(SUBSTRING(observacoes FROM 'Centro: ([^|]+)'))
ORDER BY total DESC;
