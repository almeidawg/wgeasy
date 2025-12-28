-- ============================================================
-- IMPORTAR MATERIAIS FALTANTES NO PRICELIST
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Materiais identificados nas composições sem vínculo
-- ============================================================

-- ============================================================
-- PARTE 1: CRIAR SUBCATEGORIAS ESPECÍFICAS
-- ============================================================

-- Verificar/Criar categoria Hidráulica
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Hidráulica', 'material', 'Materiais hidráulicos - tubos, conexões, válvulas', 3, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%');

-- Verificar/Criar categoria Gesso e Forros
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Gesso e Forros', 'material', 'Materiais para gesso, forros e sancas', 4, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Gesso%');

-- Verificar/Criar categoria Pisos e Revestimentos
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Pisos e Revestimentos', 'material', 'Materiais para pisos, revestimentos e acabamentos', 5, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%');

-- Verificar/Criar categoria Vedação e Fixação
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Vedação e Fixação', 'material', 'Silicones, colas, vedantes e fixadores', 6, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Vedação%' OR nome ILIKE '%Fixação%');

-- Verificar/Criar categoria Louças e Metais
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Louças e Metais', 'material', 'Louças sanitárias, metais e acessórios', 7, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Louças%' OR nome ILIKE '%Metais%');

-- ============================================================
-- PARTE 2: IMPORTAR MATERIAIS HIDRÁULICOS FALTANTES
-- ============================================================

-- Anel de Vedação para Bacia
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Anel de Vedação para Bacia Sanitária',
  'HID-VED-001',
  'Anel de vedação em borracha para instalação de bacia sanitária',
  8.90,
  'un',
  'Astra',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/anel_de_vedacao_para_vaso_sanitario_astra_89519081_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-VED-001');

-- Curva 90 Longa 100mm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Curva 90° Longa PVC Esgoto 100mm',
  'HID-CUR-001',
  'Curva 90 graus longa em PVC para esgoto, diâmetro 100mm',
  24.90,
  'un',
  'Tigre',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/curva_90_longa_esgoto_serie_normal_100mm_tigre_89354531_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CUR-001');

-- Flexível 40cm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Flexível Trançado Inox 40cm 1/2"',
  'HID-FLEX-001',
  'Engate flexível trançado em aço inox, 40cm, rosca 1/2"',
  18.90,
  'un',
  'Blukit',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/flexivel_trancado_40cm_1_2_x_1_2_blukit_89527579_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-FLEX-001');

-- Flexível para Caixa Acoplada 40cm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Flexível para Caixa Acoplada 40cm',
  'HID-FLEX-002',
  'Engate flexível para caixa acoplada de vaso sanitário, 40cm',
  22.90,
  'un',
  'Blukit',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/flexivel_para_caixa_acoplada_40cm_blukit_89527587_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-FLEX-002');

-- Junção Simples 50mm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Junção Simples PVC Esgoto 50mm',
  'HID-JUN-001',
  'Junção simples em PVC para esgoto, diâmetro 50mm',
  8.90,
  'un',
  'Tigre',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/juncao_simples_esgoto_serie_normal_50mm_tigre_89354445_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-JUN-001');

-- Kit Parafusos Fixação Bacia
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Kit Parafusos Fixação Bacia Sanitária',
  'HID-KIT-001',
  'Kit completo de parafusos para fixação de bacia sanitária no piso',
  15.90,
  'kit',
  'Astra',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/kit_fixacao_vaso_sanitario_astra_89519099_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-KIT-001');

-- Sifão Sanfonado
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Sifão Sanfonado Universal Branco',
  'HID-SIF-001',
  'Sifão sanfonado universal para lavatório e pia, cor branca',
  12.90,
  'un',
  'Astra',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/sifao_sanfonado_universal_branco_astra_89519024_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-SIF-001');

-- Tê PPR 25mm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Tê PPR Água Quente 25mm',
  'HID-TEE-001',
  'Tê em PPR para água quente e fria, diâmetro 25mm',
  6.90,
  'un',
  'Tigre',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/te_ppr_25mm_tigre_89354684_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-TEE-001');

-- Válvula de Escoamento
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Válvula de Escoamento para Lavatório',
  'HID-VAL-001',
  'Válvula de escoamento tipo click para lavatório e cuba',
  28.90,
  'un',
  'Docol',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidráulica%' OR nome ILIKE '%Hidraulica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/valvula_de_escoamento_click_docol_89494789_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-VAL-001');

-- ============================================================
-- PARTE 3: IMPORTAR MATERIAIS DE GESSO E FORROS
-- ============================================================

-- Placa de Gesso 60x60
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Placa de Gesso Acartonado 60x60cm',
  'GES-PLC-001',
  'Placa de gesso acartonado para forro, 60x60cm, espessura 10mm',
  8.90,
  'm2',
  'Placo',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/placa_de_gesso_acartonado_standard_placo_89494126_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'GES-PLC-001');

-- Perfil para Forro
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Perfil Metálico para Forro Drywall',
  'GES-PER-001',
  'Perfil metálico galvanizado para estrutura de forro drywall',
  12.90,
  'm',
  'Knauf',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/perfil_montante_m_48_knauf_89494142_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'GES-PER-001');

-- Perfil para Sanca
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Perfil para Sanca de Gesso',
  'GES-PER-002',
  'Perfil metálico para execução de sancas em gesso',
  15.90,
  'm',
  'Knauf',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/perfil_guia_u_48_knauf_89494134_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'GES-PER-002');

-- Placa de Gesso para Sanca
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Placa de Gesso para Sanca',
  'GES-PLC-002',
  'Placa de gesso especial para execução de sancas decorativas',
  18.90,
  'ml',
  'Gypsum',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/moldura_de_gesso_para_sanca_89519247_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'GES-PLC-002');

-- Gesso Cola 1kg
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Gesso Cola 1kg',
  'GES-COL-001',
  'Gesso cola para fixação e acabamento de placas, saco 1kg',
  6.90,
  'kg',
  'Gypsum',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/gesso_cola_1kg_89519255_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'GES-COL-001');

-- Massa para Gesso
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Massa para Gesso/Drywall 5kg',
  'GES-MAS-001',
  'Massa para tratamento de juntas em drywall e gesso, balde 5kg',
  45.90,
  'kg',
  'Knauf',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/massa_para_drywall_readyfix_knauf_5kg_89494150_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'GES-MAS-001');

-- ============================================================
-- PARTE 4: IMPORTAR MATERIAIS DE PISOS
-- ============================================================

-- Manta para Piso Laminado
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Manta de Polietileno para Piso Laminado',
  'PIS-MAN-001',
  'Manta de polietileno expandido para instalação de piso laminado, 2mm',
  4.90,
  'm2',
  'Durafloor',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/manta_para_piso_laminado_2mm_durafloor_89465132_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-MAN-001');

-- Rejunte Epóxi
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Rejunte Epóxi Branco 1kg',
  'REV-REJ-002',
  'Rejunte epóxi bicomponente para áreas úmidas, cor branca, 1kg',
  89.90,
  'kg',
  'Quartzolit',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/rejunte_epoxi_bicomponente_quartzolit_89388844_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-REJ-002');

-- ============================================================
-- PARTE 5: IMPORTAR MATERIAIS DE VEDAÇÃO E FIXAÇÃO
-- ============================================================

-- Silicone Neutro
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Silicone Neutro Incolor 280g',
  'VED-SIL-001',
  'Silicone neutro incolor para vedação, bisnaga 280g',
  32.90,
  'un',
  'Tekbond',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Vedação%' OR nome ILIKE '%Fixação%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/silicone_neutro_incolor_280g_tekbond_89388091_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'VED-SIL-001');

-- Arame Galvanizado
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Arame Galvanizado BWG 18 (1,24mm)',
  'VED-ARA-001',
  'Arame galvanizado para amarração, BWG 18, rolo 1kg',
  18.90,
  'm',
  'Gerdau',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Vedação%' OR nome ILIKE '%Fixação%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/arame_galvanizado_18_1kg_89388927_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'VED-ARA-001');

-- ============================================================
-- PARTE 6: VINCULAR MATERIAIS ÀS COMPOSIÇÕES
-- ============================================================

-- Anel de vedação para bacia
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-VED-001')
WHERE descricao_generica ILIKE '%anel%vedacao%bacia%'
  AND pricelist_item_id IS NULL;

-- Arame galvanizado
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'VED-ARA-001')
WHERE descricao_generica ILIKE '%arame%galvanizado%'
  AND pricelist_item_id IS NULL;

-- Curva 90 longa 100mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CUR-001')
WHERE descricao_generica ILIKE '%curva%90%100%'
  AND pricelist_item_id IS NULL;

-- Flexível 40cm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-FLEX-001')
WHERE descricao_generica ILIKE '%flexivel%40%'
  AND descricao_generica NOT ILIKE '%caixa%acoplada%'
  AND pricelist_item_id IS NULL;

-- Flexível para caixa acoplada
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-FLEX-002')
WHERE descricao_generica ILIKE '%flexivel%caixa%acoplada%'
  AND pricelist_item_id IS NULL;

-- Junção simples 50mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-JUN-001')
WHERE descricao_generica ILIKE '%juncao%simples%50%'
  AND pricelist_item_id IS NULL;

-- Kit parafusos fixação bacia
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-KIT-001')
WHERE descricao_generica ILIKE '%kit%parafuso%fixa%bacia%'
  AND pricelist_item_id IS NULL;

-- Manta para piso laminado
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-MAN-001')
WHERE descricao_generica ILIKE '%manta%piso%laminado%'
  AND pricelist_item_id IS NULL;

-- Perfil para forro
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'GES-PER-001')
WHERE descricao_generica ILIKE '%perfil%forro%'
  AND pricelist_item_id IS NULL;

-- Perfil para sanca
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'GES-PER-002')
WHERE descricao_generica ILIKE '%perfil%sanca%'
  AND pricelist_item_id IS NULL;

-- Placa de gesso 60x60
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'GES-PLC-001')
WHERE descricao_generica ILIKE '%placa%gesso%60%'
  AND pricelist_item_id IS NULL;

-- Placa de gesso para sanca
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'GES-PLC-002')
WHERE descricao_generica ILIKE '%placa%gesso%sanca%'
  AND pricelist_item_id IS NULL;

-- Sifão sanfonado
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-SIF-001')
WHERE (descricao_generica ILIKE '%sifao%sanfonado%' OR descricao_generica ILIKE '%sifao%copo%')
  AND pricelist_item_id IS NULL;

-- Tê PPR 25mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-TEE-001')
WHERE descricao_generica ILIKE '%te%ppr%25%'
  AND pricelist_item_id IS NULL;

-- Válvula de escoamento
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-VAL-001')
WHERE descricao_generica ILIKE '%valvula%escoamento%'
  AND pricelist_item_id IS NULL;

-- Gesso cola
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'GES-COL-001')
WHERE descricao_generica ILIKE '%gesso%cola%'
  AND pricelist_item_id IS NULL;

-- Massa para gesso
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'GES-MAS-001')
WHERE descricao_generica ILIKE '%massa%gesso%'
  AND pricelist_item_id IS NULL;

-- Rejunte epóxi
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-REJ-002')
WHERE descricao_generica ILIKE '%rejunte%epox%'
  AND pricelist_item_id IS NULL;

-- Silicone neutro
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'VED-SIL-001')
WHERE descricao_generica ILIKE '%silicone%neutro%'
  AND pricelist_item_id IS NULL;

-- ============================================================
-- PARTE 7: VERIFICAÇÃO FINAL
-- ============================================================

-- Resumo de vinculações
DO $$
DECLARE
  v_total INT;
  v_vinculados INT;
  v_sem_vinculo INT;
  v_novos_itens INT;
BEGIN
  SELECT COUNT(*) INTO v_total FROM modelos_composicao_itens;
  SELECT COUNT(*) INTO v_vinculados FROM modelos_composicao_itens WHERE pricelist_item_id IS NOT NULL;
  SELECT COUNT(*) INTO v_sem_vinculo FROM modelos_composicao_itens WHERE pricelist_item_id IS NULL;
  SELECT COUNT(*) INTO v_novos_itens FROM pricelist_itens WHERE codigo LIKE 'HID-%' OR codigo LIKE 'GES-%' OR codigo LIKE 'PIS-%' OR codigo LIKE 'VED-%';

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'IMPORTAÇÃO DE MATERIAIS FALTANTES - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Novos itens importados: %', v_novos_itens;
  RAISE NOTICE 'Total de itens de composição: %', v_total;
  RAISE NOTICE 'Itens vinculados ao pricelist: %', v_vinculados;
  RAISE NOTICE 'Itens ainda sem vínculo: %', v_sem_vinculo;
  RAISE NOTICE '============================================================';
END $$;

-- Listar categorias criadas
SELECT id, nome, descricao FROM pricelist_categorias ORDER BY ordem;

-- Listar novos itens importados
SELECT
  p.codigo,
  p.nome,
  p.preco,
  p.unidade,
  c.nome as categoria
FROM pricelist_itens p
LEFT JOIN pricelist_categorias c ON c.id = p.categoria_id
WHERE p.codigo LIKE 'HID-%'
   OR p.codigo LIKE 'GES-%'
   OR p.codigo LIKE 'PIS-%'
   OR p.codigo LIKE 'VED-%'
   OR p.codigo LIKE 'REV-REJ-002'
ORDER BY p.codigo;

-- Listar itens que AINDA não têm vínculo
SELECT DISTINCT
  mci.descricao_generica,
  mci.classificacao
FROM modelos_composicao_itens mci
WHERE pricelist_item_id IS NULL
ORDER BY mci.classificacao, mci.descricao_generica;
