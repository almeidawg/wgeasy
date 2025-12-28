-- Ver os 2 lançamentos que ficaram sem cliente
SELECT id, descricao, valor_total, tipo, data_competencia
FROM financeiro_lancamentos
WHERE nucleo = 'designer' AND pessoa_id IS NULL;
