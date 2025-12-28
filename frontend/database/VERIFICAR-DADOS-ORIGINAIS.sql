-- ============================================
-- VERIFICAR SE TEMOS INFORMAÇÃO DO CLIENTE
-- ============================================

-- 1. Ver se algum registro tem observacoes preenchido
SELECT COUNT(*) as com_observacoes
FROM financeiro_lancamentos
WHERE observacoes IS NOT NULL AND observacoes != '';

-- 2. Ver exemplos de observacoes (se houver)
SELECT id, descricao, observacoes
FROM financeiro_lancamentos
WHERE observacoes IS NOT NULL AND observacoes != ''
LIMIT 10;

-- 3. Ver se algum registro tem pessoa_id preenchido
SELECT COUNT(*) as com_pessoa
FROM financeiro_lancamentos
WHERE pessoa_id IS NOT NULL;

-- 4. Resumo completo
SELECT
    COUNT(*) as total,
    COUNT(pessoa_id) as com_cliente,
    COUNT(observacoes) as com_obs,
    COUNT(contrato_id) as com_contrato
FROM financeiro_lancamentos;
