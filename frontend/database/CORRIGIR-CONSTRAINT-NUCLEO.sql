-- ============================================
-- CORRIGIR CONSTRAINT DE NÚCLEO
-- Passo a passo seguro
-- ============================================

-- 1. VERIFICAR: Quais valores de núcleo existem atualmente
SELECT
    COALESCE(nucleo, 'NULL') as nucleo_valor,
    COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;

-- 2. REMOVER a constraint antiga (sem recriar ainda)
ALTER TABLE financeiro_lancamentos
DROP CONSTRAINT IF EXISTS financeiro_lancamentos_nucleo_check;

-- 3. CORRIGIR valores inválidos ANTES de criar a nova constraint
-- Primeiro, veja o resultado do SELECT acima e ajuste conforme necessário

-- Se houver valores NULL, defina um padrão:
UPDATE financeiro_lancamentos
SET nucleo = 'designer'
WHERE nucleo IS NULL;

-- Se houver 'arquitetura' que deveria ser 'designer':
-- UPDATE financeiro_lancamentos
-- SET nucleo = 'designer'
-- WHERE nucleo = 'arquitetura';

-- 4. VERIFICAR novamente após correções
SELECT
    COALESCE(nucleo, 'NULL') as nucleo_valor,
    COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;

-- 5. CRIAR a nova constraint (só execute após corrigir os valores)
ALTER TABLE financeiro_lancamentos
ADD CONSTRAINT financeiro_lancamentos_nucleo_check
CHECK (nucleo IN ('designer', 'arquitetura', 'engenharia', 'marcenaria', 'produtos', 'materiais', 'grupo'));

-- 6. CONFIRMAR que a constraint foi criada
SELECT
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint
WHERE conrelid = 'financeiro_lancamentos'::regclass
  AND conname LIKE '%nucleo%';
