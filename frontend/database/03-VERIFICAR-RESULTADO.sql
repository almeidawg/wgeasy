-- ============================================
-- PARTE 3: VERIFICAR RESULTADO
-- ============================================

-- 1. Resumo por cliente
SELECT
    p.nome as cliente,
    COUNT(*) as total_lancamentos,
    SUM(CASE WHEN fl.tipo = 'entrada' THEN fl.valor_total ELSE 0 END) as entradas,
    SUM(CASE WHEN fl.tipo = 'saida' THEN fl.valor_total ELSE 0 END) as saidas
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
WHERE fl.nucleo = 'designer'
GROUP BY p.nome
ORDER BY total_lancamentos DESC;

-- 2. Lançamentos sem cliente
SELECT COUNT(*) as sem_cliente
FROM financeiro_lancamentos
WHERE nucleo = 'designer' AND pessoa_id IS NULL;
