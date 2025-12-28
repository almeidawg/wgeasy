-- ============================================
-- PASSO 2: VERIFICAR QUAIS VALORES EXISTEM
-- Execute APÓS o Passo 1
-- ============================================

SELECT
    COALESCE(nucleo, 'NULL') as nucleo_valor,
    COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;

-- Anote os resultados e vá para o PASSO 3
