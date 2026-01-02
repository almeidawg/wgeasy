-- ============================================
-- ADICIONAR NUCLEO 'PESSOAL' A CONSTRAINT
-- ============================================
-- Data: 2025-12-30
-- Objetivo: Permitir lancamentos do financeiro pessoal do Founder
-- ============================================

-- PASSO 1: Remover constraint atual
ALTER TABLE financeiro_lancamentos
DROP CONSTRAINT IF EXISTS financeiro_lancamentos_nucleo_check;

-- PASSO 2: Criar constraint com valor 'pessoal' adicionado
ALTER TABLE financeiro_lancamentos
ADD CONSTRAINT financeiro_lancamentos_nucleo_check
CHECK (nucleo IN ('designer', 'arquitetura', 'engenharia', 'marcenaria', 'produtos', 'materiais', 'grupo', 'pessoal'));

-- Verificacao
SELECT 'Constraint atualizada com sucesso! Valor pessoal agora permitido.' as resultado;
