-- ============================================
-- EXTRAIR CLIENTES DOS LANÇAMENTOS IMPORTADOS
-- Para cadastrar na tabela pessoas
-- ============================================

-- 1. Ver estrutura das descrições (nome do cliente está no início?)
SELECT descricao, valor_total, tipo
FROM financeiro_lancamentos
WHERE nucleo = 'designer'
ORDER BY descricao
LIMIT 30;

-- 2. Se o nome do cliente estiver antes do " - ", extrair:
SELECT DISTINCT
    TRIM(SPLIT_PART(descricao, ' - ', 1)) as cliente_nome,
    COUNT(*) as total_lancamentos
FROM financeiro_lancamentos
WHERE nucleo = 'designer'
GROUP BY TRIM(SPLIT_PART(descricao, ' - ', 1))
ORDER BY cliente_nome
LIMIT 50;

-- 3. Total de clientes únicos
SELECT COUNT(DISTINCT TRIM(SPLIT_PART(descricao, ' - ', 1))) as total_clientes
FROM financeiro_lancamentos
WHERE nucleo = 'designer';
