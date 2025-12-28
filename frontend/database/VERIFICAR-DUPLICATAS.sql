-- ============================================
-- VERIFICAR DUPLICATAS NOS LANÇAMENTOS
-- ============================================

-- 1. Resumo por núcleo (atual)
SELECT
    nucleo,
    COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;

-- 2. Identificar duplicatas (mesma descrição + data + valor + tipo)
SELECT
    descricao,
    data_competencia,
    valor_total,
    tipo,
    nucleo,
    COUNT(*) as ocorrencias
FROM financeiro_lancamentos
GROUP BY descricao, data_competencia, valor_total, tipo, nucleo
HAVING COUNT(*) > 1
ORDER BY ocorrencias DESC
LIMIT 50;

-- 3. Total de registros duplicados
SELECT
    'RESUMO' as secao,
    COUNT(*) as grupos_duplicados,
    SUM(ocorrencias - 1) as registros_a_remover
FROM (
    SELECT COUNT(*) as ocorrencias
    FROM financeiro_lancamentos
    GROUP BY descricao, data_competencia, valor_total, tipo, nucleo
    HAVING COUNT(*) > 1
) subq;
