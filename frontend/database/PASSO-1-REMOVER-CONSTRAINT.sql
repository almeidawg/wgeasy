-- ============================================
-- PASSO 1: REMOVER A CONSTRAINT ANTIGA
-- Execute SOMENTE este comando primeiro
-- ============================================

ALTER TABLE financeiro_lancamentos
DROP CONSTRAINT IF EXISTS financeiro_lancamentos_nucleo_check;

-- Se executou sem erro, vá para o PASSO 2
