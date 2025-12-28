-- ============================================
-- POPULAR nucleo_id NOS ITENS DO PRICELIST
-- Sistema WG Easy - Grupo WG Almeida
-- ============================================

-- Este script popula o campo nucleo_id nos itens do pricelist
-- baseado no tipo do item e palavras-chave no nome/categoria

-- ============================================
-- PASSO 1: Verificar nucleos existentes
-- ============================================
SELECT id, nome, codigo, cor FROM nucleos ORDER BY ordem;

-- ============================================
-- PASSO 2: Verificar itens sem nucleo
-- ============================================
SELECT
    COUNT(*) as total_sem_nucleo,
    COUNT(CASE WHEN tipo = 'material' THEN 1 END) as materiais,
    COUNT(CASE WHEN tipo = 'mao_obra' THEN 1 END) as mao_obra,
    COUNT(CASE WHEN tipo = 'servico' THEN 1 END) as servicos,
    COUNT(CASE WHEN tipo = 'produto' THEN 1 END) as produtos
FROM pricelist_itens
WHERE nucleo_id IS NULL;

-- ============================================
-- PASSO 3: Popular nucleo_id baseado em regras
-- ============================================

-- 3.1 Itens de MARCENARIA (baseado no nome ou categoria)
UPDATE pricelist_itens
SET nucleo_id = (SELECT id FROM nucleos WHERE nome ILIKE 'Marcenaria' LIMIT 1)
WHERE nucleo_id IS NULL
  AND (
    nome ILIKE '%marcenari%'
    OR nome ILIKE '%movel%'
    OR nome ILIKE '%moveis%'
    OR nome ILIKE '%armario%'
    OR nome ILIKE '%guarda%roupa%'
    OR nome ILIKE '%cozinha planejada%'
    OR nome ILIKE '%closet%'
    OR nome ILIKE '%mdf%'
    OR nome ILIKE '%laminado%'
    OR nome ILIKE '%compensado%'
    OR EXISTS (
      SELECT 1 FROM pricelist_categorias c
      WHERE c.id = pricelist_itens.categoria_id
      AND (c.nome ILIKE '%marcenari%' OR c.nome ILIKE '%movel%')
    )
  );

-- 3.2 Itens de ENGENHARIA (serviços de obra civil)
UPDATE pricelist_itens
SET nucleo_id = (SELECT id FROM nucleos WHERE nome ILIKE 'Engenharia' LIMIT 1)
WHERE nucleo_id IS NULL
  AND (
    tipo IN ('servico', 'mao_obra')
    AND (
      nome ILIKE '%hidraul%'
      OR nome ILIKE '%eletric%'
      OR nome ILIKE '%alvenaria%'
      OR nome ILIKE '%reboco%'
      OR nome ILIKE '%contrapiso%'
      OR nome ILIKE '%gesso%'
      OR nome ILIKE '%drywall%'
      OR nome ILIKE '%pintura%'
      OR nome ILIKE '%instalacao%'
      OR nome ILIKE '%demolicao%'
      OR nome ILIKE '%impermeabiliza%'
      OR nome ILIKE '%telhado%'
      OR nome ILIKE '%fundacao%'
      OR nome ILIKE '%estrutura%'
      OR nome ILIKE '%concreto%'
      OR nome ILIKE '%piso%'
      OR nome ILIKE '%revestimento%'
      OR EXISTS (
        SELECT 1 FROM pricelist_categorias c
        WHERE c.id = pricelist_itens.categoria_id
        AND (c.nome ILIKE '%obra%' OR c.nome ILIKE '%civil%' OR c.nome ILIKE '%construc%')
      )
    )
  );

-- 3.3 Itens de ARQUITETURA (projetos e design)
UPDATE pricelist_itens
SET nucleo_id = (SELECT id FROM nucleos WHERE nome ILIKE 'Arquitetura' LIMIT 1)
WHERE nucleo_id IS NULL
  AND (
    nome ILIKE '%projeto%'
    OR nome ILIKE '%arquitet%'
    OR nome ILIKE '%design%'
    OR nome ILIKE '%3d%'
    OR nome ILIKE '%render%'
    OR nome ILIKE '%maquete%'
    OR nome ILIKE '%planta%'
    OR nome ILIKE '%layout%'
    OR nome ILIKE '%consultoria%'
    OR EXISTS (
      SELECT 1 FROM pricelist_categorias c
      WHERE c.id = pricelist_itens.categoria_id
      AND (c.nome ILIKE '%projeto%' OR c.nome ILIKE '%arquitet%' OR c.nome ILIKE '%design%')
    )
  );

-- 3.4 Itens MATERIAIS (tipo material restante)
UPDATE pricelist_itens
SET nucleo_id = (
    SELECT id FROM nucleos WHERE nome IN ('Materiais', 'Geral') LIMIT 1
)
WHERE nucleo_id IS NULL
  AND tipo = 'material';

-- 3.5 Itens PRODUTOS (tipo produto restante)
UPDATE pricelist_itens
SET nucleo_id = (
    SELECT id FROM nucleos WHERE nome IN ('Produtos', 'Geral') LIMIT 1
)
WHERE nucleo_id IS NULL
  AND tipo = 'produto';

-- 3.6 Demais itens de mao_obra e servico -> Engenharia (padrão)
UPDATE pricelist_itens
SET nucleo_id = (SELECT id FROM nucleos WHERE nome ILIKE 'Engenharia' LIMIT 1)
WHERE nucleo_id IS NULL
  AND tipo IN ('servico', 'mao_obra');

-- ============================================
-- PASSO 4: Verificar resultado
-- ============================================
SELECT
    n.nome as nucleo,
    COUNT(*) as total_itens,
    COUNT(CASE WHEN i.tipo = 'material' THEN 1 END) as materiais,
    COUNT(CASE WHEN i.tipo = 'mao_obra' THEN 1 END) as mao_obra,
    COUNT(CASE WHEN i.tipo = 'servico' THEN 1 END) as servicos,
    COUNT(CASE WHEN i.tipo = 'produto' THEN 1 END) as produtos
FROM pricelist_itens i
LEFT JOIN nucleos n ON n.id = i.nucleo_id
GROUP BY n.nome
ORDER BY total_itens DESC;

-- ============================================
-- PASSO 5: Verificar se ainda há itens sem nucleo
-- ============================================
SELECT
    id,
    codigo,
    nome,
    tipo,
    categoria_id
FROM pricelist_itens
WHERE nucleo_id IS NULL
LIMIT 50;

-- ============================================
-- FIM DO SCRIPT
-- ============================================
