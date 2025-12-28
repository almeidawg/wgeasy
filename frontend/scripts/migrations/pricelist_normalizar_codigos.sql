-- Normaliza códigos de itens para o padrão ORD/CODIGO-### por categoria
-- Exemplo: categoria ordem 008, código AUT => 008/AUT-001, 008/AUT-002, ...
-- Ajuste conforme necessário antes de rodar em produção.

with cat as (
  select id, ordem, codigo
  from pricelist_categorias
),
renum as (
  select
    i.id,
    c.ordem,
    c.codigo,
    row_number() over (partition by i.categoria_id order by i.created_at, i.id) as seq
  from pricelist_itens i
  join cat c on c.id = i.categoria_id
  where i.categoria_id is not null
),
novos as (
  select
    r.id,
    case
      when r.codigo is not null and length(trim(r.codigo)) > 0
        then upper(trim(r.codigo)) || '-' || lpad(seq::text, 3, '0')
      else lpad(seq::text, 3, '0')
    end as codigo_novo
  from renum r
)
update pricelist_itens i
set codigo = n.codigo_novo
from novos n
where n.id = i.id;
