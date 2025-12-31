-- ============================================
-- PREPARAÇÃO ANTES DE IMPORTAR OS LANÇAMENTOS
-- Execute ANTES dos BATCH_01 a BATCH_12
-- ============================================

-- 1. Verificar quantos lançamentos existem atualmente
SELECT
    'ANTES DA IMPORTAÇÃO' as fase,
    COUNT(*) as total_lancamentos,
    SUM(CASE WHEN tipo = 'entrada' THEN 1 ELSE 0 END) as entradas,
    SUM(CASE WHEN tipo = 'saida' THEN 1 ELSE 0 END) as saidas
FROM financeiro_lancamentos;

-- 2. Verificar distribuição por núcleo
SELECT
    nucleo,
    COUNT(*) as total,
    SUM(valor_total) as valor_total,
    MIN(data_competencia) as data_mais_antiga,
    MAX(data_competencia) as data_mais_recente
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY nucleo;

-- 3. LIMPAR lançamentos antigos do núcleo arquitetura (WG Designer)
-- DESCOMENTE e execute APENAS se precisar substituir:

-- DELETE FROM financeiro_lancamentos
-- WHERE nucleo = 'arquitetura';

-- ============================================
-- APÓS VERIFICAR:
-- 1. Decida se precisa limpar registros existentes
-- 2. Execute os BATCH_01_financeiro a BATCH_12_financeiro
-- ============================================
