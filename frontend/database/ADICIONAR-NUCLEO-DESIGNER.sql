-- ============================================
-- ADICIONAR 'designer' À CONSTRAINT DE NÚCLEO
-- Tabela: financeiro_lancamentos
-- ============================================

-- 1. VERIFICAR: Qual é a constraint atual
SELECT
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint
WHERE conrelid = 'financeiro_lancamentos'::regclass
  AND conname LIKE '%nucleo%';

-- 2. REMOVER a constraint antiga
ALTER TABLE financeiro_lancamentos
DROP CONSTRAINT IF EXISTS financeiro_lancamentos_nucleo_check;

-- 3. CRIAR nova constraint incluindo 'designer'
ALTER TABLE financeiro_lancamentos
ADD CONSTRAINT financeiro_lancamentos_nucleo_check
CHECK (nucleo IN ('designer', 'arquitetura', 'engenharia', 'marcenaria', 'produtos', 'materiais', 'grupo'));

-- 4. VERIFICAR a nova constraint
SELECT
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint
WHERE conrelid = 'financeiro_lancamentos'::regclass
  AND conname LIKE '%nucleo%';

-- ============================================
-- APÓS EXECUTAR ESTE SQL:
-- Agora você pode usar o valor 'designer' no campo nucleo
-- ============================================
