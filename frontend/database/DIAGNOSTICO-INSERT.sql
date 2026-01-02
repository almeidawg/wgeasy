-- ============================================
-- DIAGNOSTICO: Por que os INSERTs nao funcionam?
-- ============================================

-- TESTE 1: Verificar se a pessoa existe
SELECT id, nome FROM pessoas WHERE UPPER(nome) = UPPER('Renata Lizas Verpa');

-- TESTE 2: Verificar constraint do nucleo
SELECT conname, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'financeiro_lancamentos'::regclass;

-- TESTE 3: Verificar colunas da tabela
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'financeiro_lancamentos'
ORDER BY ordinal_position;

-- TESTE 4: INSERT simples direto (sem SELECT)
-- Se este funcionar, o problema esta no SELECT...FROM pessoas
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
) VALUES (
    '2023-01-01'::date,
    100.00,
    'TESTE DIAGNOSTICO - PODE DELETAR',
    'entrada',
    'arquitetura',
    'pendente',
    (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Renata Lizas Verpa') LIMIT 1),
    'Teste para verificar se INSERT funciona'
);

-- TESTE 5: Verificar se o teste foi inserido
SELECT id, descricao, valor_total FROM financeiro_lancamentos WHERE descricao LIKE '%TESTE DIAGNOSTICO%';

-- TESTE 6: Se funcionou, deletar o teste
DELETE FROM financeiro_lancamentos WHERE descricao LIKE '%TESTE DIAGNOSTICO%';
