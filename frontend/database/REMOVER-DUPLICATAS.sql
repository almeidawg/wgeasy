-- ============================================
-- REMOVER DUPLICATAS (manter apenas o primeiro)
-- Total a remover: 72 registros
-- ============================================

DELETE FROM financeiro_lancamentos
WHERE id IN (
    SELECT id FROM (
        SELECT
            id,
            ROW_NUMBER() OVER (
                PARTITION BY descricao, data_competencia, valor_total, tipo, nucleo
                ORDER BY created_at ASC
            ) as rn
        FROM financeiro_lancamentos
    ) subq
    WHERE rn > 1
);

-- Após executar, verifique o total:
-- SELECT nucleo, COUNT(*) as total FROM financeiro_lancamentos GROUP BY nucleo;
