-- ============================================
-- PASSO 3: CORRIGIR VALORES INVÁLIDOS
-- ============================================

-- 3.1 Converter 'wg almeida' para 'designer' (2181 registros)
UPDATE financeiro_lancamentos
SET nucleo = 'designer'
WHERE nucleo = 'wg almeida';

-- 3.2 Converter 'arquitetura' para 'designer'
-- EXCETO os 3 registros do contrato ARQ-2025-0001
UPDATE financeiro_lancamentos
SET nucleo = 'designer'
WHERE nucleo = 'arquitetura'
  AND (contrato_id IS NULL OR contrato_id NOT IN (
    SELECT id FROM contratos WHERE numero = 'ARQ-2025-0001'
  ));

-- Após executar os dois comandos, vá para o PASSO 4
