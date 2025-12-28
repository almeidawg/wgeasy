-- ============================================
-- CORRIGIR NÚCLEO DOS LANÇAMENTOS IMPORTADOS
-- De 'arquitetura' para 'designer' (WG Designer)
-- ============================================

-- 1. VERIFICAR: Quantos registros estão com 'arquitetura'
SELECT
    nucleo,
    COUNT(*) as total,
    SUM(valor_total) as valor_total,
    MIN(data_competencia) as data_mais_antiga,
    MAX(data_competencia) as data_mais_recente
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;

-- 2. IDENTIFICAR: Registros importados do Excel (WG Designer)
-- Esses são os que foram importados com observações contendo "Centro:"
-- ou sem contrato_id/pessoa_id (dados históricos)
SELECT
    'REGISTROS A CORRIGIR' as secao,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura'
  AND (observacoes LIKE '%Centro:%' OR (contrato_id IS NULL AND pessoa_id IS NULL));

-- ============================================
-- 3. CORRIGIR: Alterar núcleo de 'arquitetura' para 'designer'
-- APENAS para os registros importados do Excel
-- ============================================

-- DESCOMENTE para executar:

-- UPDATE financeiro_lancamentos
-- SET nucleo = 'designer'
-- WHERE nucleo = 'arquitetura'
--   AND (observacoes LIKE '%Centro:%' OR (contrato_id IS NULL AND pessoa_id IS NULL));

-- ============================================
-- 4. ALTERNATIVA: Corrigir TODOS os registros com 'arquitetura' para 'designer'
-- Use esta opção se TODOS os registros importados eram do WG Designer
-- ============================================

-- DESCOMENTE para executar:

-- UPDATE financeiro_lancamentos
-- SET nucleo = 'designer'
-- WHERE nucleo = 'arquitetura';

-- ============================================
-- 5. REMOVER DUPLICATAS (se houver)
-- Manter apenas o primeiro de cada grupo duplicado
-- ============================================

-- Verificar duplicatas primeiro:
SELECT
    'DUPLICATAS' as secao,
    descricao,
    data_competencia,
    valor_total,
    tipo,
    COUNT(*) as ocorrencias
FROM financeiro_lancamentos
WHERE nucleo = 'designer' OR nucleo = 'arquitetura'
GROUP BY descricao, data_competencia, valor_total, tipo
HAVING COUNT(*) > 1
ORDER BY ocorrencias DESC
LIMIT 20;

-- DESCOMENTE para remover duplicatas:

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
--         WHERE nucleo = 'designer'
--     ) subq
--     WHERE rn > 1
-- );

-- ============================================
-- 6. VERIFICAR APÓS CORREÇÕES
-- ============================================
-- SELECT
--     nucleo,
--     COUNT(*) as total,
--     SUM(CASE WHEN tipo = 'entrada' THEN valor_total ELSE 0 END) as entradas,
--     SUM(CASE WHEN tipo = 'saida' THEN valor_total ELSE 0 END) as saidas
-- FROM financeiro_lancamentos
-- GROUP BY nucleo
-- ORDER BY nucleo;
