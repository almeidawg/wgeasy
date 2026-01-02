-- ============================================================================
-- ATUALIZAR LANÇAMENTOS PENDENTES PARA PAGO/RECEBIDO
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2025-12-29
-- ============================================================================
-- Este script atualiza todos os lançamentos com status 'pendente' para 'pago'
-- No sistema, 'pago' é exibido como:
--   - "Recebido" para entradas (receitas)
--   - "Pago" para saídas (despesas)
-- ============================================================================

-- ============================================================================
-- 1. VERIFICAR SITUAÇÃO ATUAL
-- ============================================================================

-- Contar lançamentos por status ANTES da atualização
SELECT
  status,
  tipo,
  COUNT(*) as quantidade,
  SUM(valor_total) as valor_total
FROM financeiro_lancamentos
GROUP BY status, tipo
ORDER BY status, tipo;

-- ============================================================================
-- 2. ATUALIZAR TODOS OS PENDENTES PARA PAGO
-- ============================================================================

UPDATE financeiro_lancamentos
SET
  status = 'pago',
  data_pagamento = CURRENT_DATE,
  updated_at = NOW()
WHERE status = 'pendente';

-- ============================================================================
-- 3. TAMBÉM ATUALIZAR PREVISTOS PARA PAGO (OPCIONAL)
-- ============================================================================
-- Descomente as linhas abaixo se quiser também atualizar os "previstos"

-- UPDATE financeiro_lancamentos
-- SET
--   status = 'pago',
--   data_pagamento = CURRENT_DATE,
--   updated_at = NOW()
-- WHERE status = 'previsto';

-- ============================================================================
-- 4. VERIFICAR RESULTADO
-- ============================================================================

-- Contar lançamentos por status DEPOIS da atualização
SELECT
  status,
  tipo,
  COUNT(*) as quantidade,
  SUM(valor_total) as valor_total
FROM financeiro_lancamentos
GROUP BY status, tipo
ORDER BY status, tipo;

-- Resumo geral
SELECT
  'Total de lançamentos' as descricao,
  COUNT(*) as quantidade,
  SUM(valor_total) as valor_total
FROM financeiro_lancamentos;

-- ============================================================================
-- 5. VERIFICAR ENTRADAS vs SAÍDAS PAGAS
-- ============================================================================

SELECT
  CASE
    WHEN tipo = 'entrada' THEN 'Recebido (Entradas)'
    WHEN tipo = 'saida' THEN 'Pago (Saídas)'
  END as categoria,
  COUNT(*) as quantidade,
  SUM(valor_total) as valor_total
FROM financeiro_lancamentos
WHERE status = 'pago'
GROUP BY tipo;
