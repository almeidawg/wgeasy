-- ============================================
-- PASSO 4: CRIAR A NOVA CONSTRAINT
-- Execute SOMENTE após corrigir todos os valores
-- ============================================

ALTER TABLE financeiro_lancamentos
ADD CONSTRAINT financeiro_lancamentos_nucleo_check
CHECK (nucleo IN ('designer', 'arquitetura', 'engenharia', 'marcenaria', 'produtos', 'materiais', 'grupo'));

-- Se deu erro, volte ao PASSO 2 para verificar valores
-- Se funcionou, parabéns! Constraint criada com sucesso!
