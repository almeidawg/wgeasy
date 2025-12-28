-- ============================================================
-- VINCULAR ITENS DE COMPOSIÇÕES AO PRICELIST
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Este script tenta vincular automaticamente os itens das
-- composições aos produtos correspondentes no pricelist
-- baseado em padrões de nome.
-- ============================================================

-- Ver quantos itens existem sem vínculo
SELECT
  COUNT(*) as total_itens,
  COUNT(*) FILTER (WHERE pricelist_item_id IS NULL) as sem_vinculo,
  COUNT(*) FILTER (WHERE pricelist_item_id IS NOT NULL) as com_vinculo
FROM modelos_composicao_itens;

-- ============================================================
-- VINCULAR POR PADRÕES DE NOME
-- ============================================================

-- Tomadas
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%tomada%2p%t%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%tomada%2p%t%'
  AND pricelist_item_id IS NULL;

-- Placas 4x2
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%placa%4x2%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%placa%4x2%'
  AND pricelist_item_id IS NULL;

-- Caixa 4x2
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%caixa%4x2%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%caixa%4x2%'
  AND pricelist_item_id IS NULL;

-- Fio 2,5mm
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%fio%2,5%' OR nome ILIKE '%fio%2.5%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%fio%2,5%'
  AND pricelist_item_id IS NULL;

-- Eletroduto corrugado
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%eletroduto%corrugado%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%eletroduto%corrugado%'
  AND pricelist_item_id IS NULL;

-- Fita isolante
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%fita%isolante%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%fita%isolante%'
  AND pricelist_item_id IS NULL;

-- Argamassa AC-III
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE (nome ILIKE '%argamassa%ac%iii%' OR nome ILIKE '%argamassa%ac3%')
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%argamassa%ac%iii%'
  AND pricelist_item_id IS NULL;

-- Rejunte
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%rejunte%flex%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%rejunte%flex%'
  AND pricelist_item_id IS NULL;

-- Espaçadores
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%espa%ador%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%espa%ador%'
  AND pricelist_item_id IS NULL;

-- Disco diamantado
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%disco%diamant%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%disco%diamant%'
  AND pricelist_item_id IS NULL;

-- Selador acrílico
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%selador%acr%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%selador%acr%'
  AND pricelist_item_id IS NULL;

-- Massa corrida
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%massa%corrida%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%massa%corrida%'
  AND pricelist_item_id IS NULL;

-- Tinta acrílica
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%tinta%acr%lic%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%tinta%acr%lic%'
  AND pricelist_item_id IS NULL;

-- Lixa
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%lixa%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%lixa%'
  AND pricelist_item_id IS NULL;

-- Fita crepe
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%fita%crepe%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%fita%crepe%'
  AND pricelist_item_id IS NULL;

-- Lona plástica
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%lona%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%lona%pl%'
  AND pricelist_item_id IS NULL;

-- Rolo lã
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%rolo%l%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%rolo%l%'
  AND pricelist_item_id IS NULL;

-- Pincel
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%pincel%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%pincel%'
  AND pricelist_item_id IS NULL;

-- Tubo PVC soldável
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%tubo%pvc%sold%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%tubo%pvc%sold%'
  AND pricelist_item_id IS NULL;

-- Joelho 90
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%joelho%90%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%joelho%90%'
  AND pricelist_item_id IS NULL;

-- Tê soldável
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%te%sold%' OR nome ILIKE '%tê%sold%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%te%sold%'
  AND pricelist_item_id IS NULL;

-- Cola PVC
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%cola%pvc%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%cola%pvc%'
  AND pricelist_item_id IS NULL;

-- Fita veda-rosca
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%veda%rosca%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%veda%rosca%'
  AND pricelist_item_id IS NULL;

-- Abraçadeira
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%abra%adeira%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%abra%adeira%'
  AND pricelist_item_id IS NULL;

-- Massa autonivelante
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%massa%autonivel%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%massa%autonivel%'
  AND pricelist_item_id IS NULL;

-- Cola piso vinílico
UPDATE modelos_composicao_itens mci
SET pricelist_item_id = (
  SELECT id FROM pricelist_itens
  WHERE nome ILIKE '%cola%vinil%' OR nome ILIKE '%cola%piso%vinil%'
    AND ativo = true
  ORDER BY preco ASC
  LIMIT 1
)
WHERE descricao_generica ILIKE '%cola%piso%vinil%'
  AND pricelist_item_id IS NULL;

-- ============================================================
-- RESULTADO FINAL
-- ============================================================

SELECT
  'ANTES' as momento,
  COUNT(*) as total_itens,
  0 as sem_vinculo,
  0 as com_vinculo
FROM modelos_composicao_itens
WHERE FALSE
UNION ALL
SELECT
  'DEPOIS' as momento,
  COUNT(*) as total_itens,
  COUNT(*) FILTER (WHERE pricelist_item_id IS NULL) as sem_vinculo,
  COUNT(*) FILTER (WHERE pricelist_item_id IS NOT NULL) as com_vinculo
FROM modelos_composicao_itens;

-- Ver itens vinculados com preços
SELECT
  mc.codigo as composicao_codigo,
  mc.nome as composicao_nome,
  mci.descricao_generica,
  mci.classificacao,
  pi.nome as pricelist_nome,
  pi.preco
FROM modelos_composicao_itens mci
JOIN modelos_composicao mc ON mc.id = mci.composicao_id
LEFT JOIN pricelist_itens pi ON pi.id = mci.pricelist_item_id
ORDER BY mc.codigo, mci.ordem;

-- Ver itens que ainda não têm vínculo
SELECT DISTINCT
  mci.descricao_generica,
  mci.classificacao
FROM modelos_composicao_itens mci
WHERE pricelist_item_id IS NULL
ORDER BY mci.classificacao, mci.descricao_generica;
