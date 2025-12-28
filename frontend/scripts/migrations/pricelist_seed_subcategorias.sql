-- Seed de subcategorias derivadas das planilhas de acabamentos/CMO
-- Executar após a migration pricelist_subcategorias.sql

with cat as (
  select id, codigo, nome, tipo
  from pricelist_categorias
),
novas as (
  select c.id as categoria_id, s.nome, c.tipo, s.ordem, true as ativo
  from cat c
  join (
    values
      ('023/MAT', 'Piso', 10),
      ('023/MAT', 'Rodapé', 20),
      ('023/MAT', 'Parede', 30),
      ('023/MAT', 'Teto', 40),
      ('023/MAT', 'Rejunte', 50),
      ('023/MAT', 'Tintas e fundos', 60),
      ('023/MAT', 'Porcelanatos/placas', 70),
      ('023/MAT', 'Perfis/acentos', 80),
      ('023/MAT', 'Acessórios', 90),
      ('023/MAT', 'Louças', 100),
      ('023/MAT', 'Metais', 110),
      ('023/MAT', 'Equipamentos', 120),
      ('023/MAT', 'Eletrodomésticos', 130),
      ('023/MAT', 'Instalações', 140)
  ) as s(cod, nome, ordem)
    on true
  where c.codigo = s.cod
)
insert into pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
select categoria_id, nome, tipo, ordem, ativo
from novas n
where not exists (
  select 1
  from pricelist_subcategorias ps
  where ps.categoria_id = n.categoria_id
    and ps.nome = n.nome
);
