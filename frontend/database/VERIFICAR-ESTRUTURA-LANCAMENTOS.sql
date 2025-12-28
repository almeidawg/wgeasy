-- ============================================
-- VERIFICAR ESTRUTURA DA TABELA financeiro_lancamentos
-- ============================================

-- 1. Ver todas as colunas da tabela
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'financeiro_lancamentos'
ORDER BY ordinal_position;

-- 2. Ver um exemplo de observações com centro de custo
SELECT id, descricao, observacoes
FROM financeiro_lancamentos
WHERE observacoes LIKE '%Centro:%'
LIMIT 5;
