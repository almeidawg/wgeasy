-- ============================================
-- REMOVER TODOS OS 'arquitetura' EXCETO OS 3 DA ELIANA
-- Contrato: ARQ-2025-0001
-- ============================================

-- 1. VERIFICAR: Quais registros da ELIANA vão ficar
SELECT id, descricao, valor_total, data_competencia, nucleo
FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura'
  AND descricao LIKE '%ARQ-2025-0001%'
ORDER BY data_competencia;

-- 2. REMOVER: Todos os 'arquitetura' EXCETO os da ELIANA
DELETE FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura'
  AND descricao NOT LIKE '%ARQ-2025-0001%';

-- 3. VERIFICAR após remoção
SELECT nucleo, COUNT(*) as total
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY total DESC;
