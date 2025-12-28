-- ============================================
-- VERIFICAR DUPLICIDADES NOS LANÇAMENTOS
-- E CORRIGIR NÚCLEO PARA 'arquitetura' (WG Designer)
-- ============================================

-- 1. ANÁLISE: Verificar total de registros e distribuição por núcleo
SELECT
    'ANÁLISE GERAL' as secao,
    COUNT(*) as total_lancamentos,
    COUNT(DISTINCT nucleo) as nucleos_distintos
FROM financeiro_lancamentos;

-- 2. Distribuição por núcleo
SELECT
    COALESCE(nucleo, 'SEM NÚCLEO') as nucleo,
    COUNT(*) as total,
    SUM(valor_total) as valor_total,
    MIN(data_competencia) as data_mais_antiga,
    MAX(data_competencia) as data_mais_recente
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;

-- 3. IDENTIFICAR DUPLICIDADES: Mesmo descricao + data + valor
SELECT
    'POSSÍVEIS DUPLICATAS' as secao,
    descricao,
    data_competencia,
    valor_total,
    tipo,
    COUNT(*) as ocorrencias
FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura' OR nucleo IS NULL
GROUP BY descricao, data_competencia, valor_total, tipo
HAVING COUNT(*) > 1
ORDER BY ocorrencias DESC
LIMIT 50;

-- 4. Contar total de duplicatas
SELECT
    'RESUMO DUPLICATAS' as secao,
    COUNT(*) as total_grupos_duplicados,
    SUM(ocorrencias - 1) as registros_a_remover
FROM (
    SELECT COUNT(*) as ocorrencias
    FROM financeiro_lancamentos
    WHERE nucleo = 'arquitetura' OR nucleo IS NULL
    GROUP BY descricao, data_competencia, valor_total, tipo
    HAVING COUNT(*) > 1
) subq;

-- ============================================
-- 5. CORRIGIR: Definir núcleo 'arquitetura' para registros sem núcleo
-- ============================================
-- DESCOMENTE para executar:

-- UPDATE financeiro_lancamentos
-- SET nucleo = 'arquitetura'
-- WHERE nucleo IS NULL;

-- ============================================
-- 6. REMOVER DUPLICATAS (manter apenas o primeiro de cada grupo)
-- ============================================
-- CUIDADO: Verifique antes de executar!
-- DESCOMENTE para executar:

-- DELETE FROM financeiro_lancamentos
-- WHERE id IN (
--     SELECT id FROM (
--         SELECT
--             id,
--             ROW_NUMBER() OVER (
--                 PARTITION BY descricao, data_competencia, valor_total, tipo, nucleo
--                 ORDER BY created_at ASC
--             ) as rn
--         FROM financeiro_lancamentos
--         WHERE nucleo = 'arquitetura'
--     ) subq
--     WHERE rn > 1
-- );

-- ============================================
-- 7. VERIFICAR APÓS LIMPEZA
-- ============================================
-- SELECT
--     'APÓS LIMPEZA' as fase,
--     COUNT(*) as total_lancamentos,
--     SUM(CASE WHEN tipo = 'entrada' THEN 1 ELSE 0 END) as entradas,
--     SUM(CASE WHEN tipo = 'saida' THEN 1 ELSE 0 END) as saidas
-- FROM financeiro_lancamentos
-- WHERE nucleo = 'arquitetura';
