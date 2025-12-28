insert into financeiro_lancamentos (
  id, descricao, tipo, status, valor_total,
  data_competencia, pessoa_id, contrato_id
)
values (
  gen_random_uuid(),
  'Teste Entrada',
  'entrada',
  'previsto',
  1234.56,
  current_date,
  'b2ae63d3-4c43-4bb3-82e0-209603889fc8',
  null
);
