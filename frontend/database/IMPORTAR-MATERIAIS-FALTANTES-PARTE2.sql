-- ============================================================
-- IMPORTAR MATERIAIS FALTANTES - PARTE 2
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Materiais restantes identificados nas composições
-- ============================================================

-- ============================================================
-- PARTE 1: CRIAR CATEGORIA ILUMINAÇÃO LED (se não existir)
-- ============================================================

INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Iluminação LED', 'material', 'Fitas LED, fontes e acessórios de iluminação', 8, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%LED%' OR nome ILIKE '%Iluminação%');

-- ============================================================
-- PARTE 2: MATERIAIS DE ILUMINAÇÃO LED
-- ============================================================

-- Fita LED 5m
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Fita LED 5m Branco Quente 12V',
  'LED-FIT-001',
  'Fita LED 5 metros, cor branco quente 3000K, 12V, IP20',
  45.90,
  'un',
  'Avant',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%LED%' OR nome ILIKE '%Iluminação%' OR nome ILIKE '%Elétrica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/fita_led_5m_branco_quente_12v_avant_89388455_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'LED-FIT-001');

-- Fonte para LED 12V
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Fonte Driver para LED 12V 5A 60W',
  'LED-FON-001',
  'Fonte de alimentação para fita LED, 12V, 5A, 60W',
  49.90,
  'un',
  'Avant',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%LED%' OR nome ILIKE '%Iluminação%' OR nome ILIKE '%Elétrica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/fonte_para_fita_led_12v_5a_60w_89388463_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'LED-FON-001');

-- ============================================================
-- PARTE 3: MATERIAIS DE PISOS E ACABAMENTOS
-- ============================================================

-- Piso Laminado (por m²)
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Piso Laminado Durafloor Carvalho',
  'PIS-LAM-001',
  'Piso laminado click, cor carvalho, espessura 7mm, caixa 2,14m²',
  89.90,
  'm2',
  'Durafloor',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/piso_laminado_durafloor_nature_carvalho_89465124_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-LAM-001');

-- Piso Vinílico (por m²)
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Piso Vinílico LVT Clicado',
  'PIS-VIN-001',
  'Piso vinílico LVT sistema click, espessura 4mm',
  79.90,
  'm2',
  'Tarkett',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/piso_vinilico_lvt_tarkett_89465140_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-VIN-001');

-- Perfil de Acabamento Alumínio
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Perfil de Acabamento Alumínio 3m',
  'PIS-PER-001',
  'Perfil de acabamento em alumínio para piso laminado/vinílico, 3m',
  35.90,
  'un',
  'Durafloor',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/perfil_de_acabamento_aluminio_durafloor_89465156_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-PER-001');

-- Perfil de Transição
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Perfil de Transição T Alumínio 3m',
  'PIS-PER-002',
  'Perfil de transição T em alumínio para diferentes níveis de piso, 3m',
  42.90,
  'un',
  'Durafloor',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/perfil_de_transicao_t_aluminio_89465164_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-PER-002');

-- Rodapé MDF
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Rodapé MDF Branco 7cm x 2,40m',
  'PIS-ROD-001',
  'Rodapé em MDF revestido, cor branca, 7cm altura, barra 2,40m',
  18.90,
  'ml',
  'Santa Luzia',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/rodape_mdf_branco_7cm_santa_luzia_89465172_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-ROD-001');

-- Rodapé Porcelanato
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Rodapé Porcelanato 10x60cm',
  'PIS-ROD-002',
  'Rodapé em porcelanato, 10x60cm, venda por peça',
  12.90,
  'ml',
  'Portobello',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/rodape_porcelanato_portobello_89465180_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-ROD-002');

-- Rodapé Vinílico
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Rodapé Vinílico Flexível 7cm',
  'PIS-ROD-003',
  'Rodapé vinílico flexível auto-adesivo, 7cm altura, rolo 25m',
  8.90,
  'ml',
  'Tarkett',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/rodape_vinilico_flexivel_tarkett_89465188_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PIS-ROD-003');

-- Porcelanato Piso
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Porcelanato Acetinado 60x60cm Bege',
  'REV-POR-001',
  'Porcelanato acetinado para piso, 60x60cm, cor bege, caixa 1,44m²',
  69.90,
  'm2',
  'Portobello',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/porcelanato_acetinado_60x60_bege_portobello_89388836_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-POR-001');

-- Porcelanato Parede
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Porcelanato Esmaltado Parede 30x60cm Branco',
  'REV-POR-002',
  'Porcelanato esmaltado para parede, 30x60cm, cor branca, caixa 1,08m²',
  59.90,
  'm2',
  'Portobello',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/porcelanato_parede_30x60_branco_portobello_89388828_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-POR-002');

-- ============================================================
-- PARTE 4: MATERIAIS ELÉTRICOS FALTANTES
-- ============================================================

-- Placa 4x4
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Placa 4x4 Branca 3 Postos',
  'ELE-PLC-002',
  'Placa de acabamento 4x4 para 3 postos, cor branca',
  8.90,
  'un',
  'Tramontina',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Elétrica%' OR nome ILIKE '%Eletrica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/placa_4x4_3_postos_branca_tramontina_89354299_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-PLC-002');

-- Fio 1,5mm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Fio Flexível 1,5mm² Preto 100m',
  'ELE-FIO-003',
  'Fio elétrico flexível 1,5mm², cor preta, rolo 100m',
  89.90,
  'm',
  'Sil',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Elétrica%' OR nome ILIKE '%Eletrica%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/fio_flexivel_1_5mm_preto_100m_sil_89354356_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-FIO-003');

-- ============================================================
-- PARTE 5: CONSUMÍVEIS E FERRAMENTAS
-- ============================================================

-- Fita de Borda para Manta
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Fita de Borda Adesiva para Manta',
  'CON-FIT-001',
  'Fita adesiva para acabamento de bordas de manta, rolo 50m',
  25.90,
  'un',
  'Durafloor',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Vedação%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/fita_de_borda_adesiva_durafloor_89465196_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'CON-FIT-001');

-- Proteção para Piso
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Proteção para Piso Papelão Ondulado',
  'CON-PRO-001',
  'Papelão ondulado para proteção de piso durante obra, rolo 50m²',
  89.90,
  'un',
  'Tigre',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Vedação%' OR nome ILIKE '%Pintura%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/protecao_piso_papelao_ondulado_89388919_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'CON-PRO-001');

-- Rolo Anti-gota 23cm
INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, ativo)
SELECT
  'Rolo Anti-gota 23cm com Cabo',
  'FER-ROL-001',
  'Rolo de pintura anti-gota 23cm com cabo extensível',
  32.90,
  'un',
  'Atlas',
  (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Pintura%' LIMIT 1),
  'https://cdn.leroymerlin.com.br/products/rolo_antigota_23cm_atlas_89388695_0001_600x600.jpg',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'FER-ROL-001');

-- ============================================================
-- PARTE 6: VINCULAR MATERIAIS ÀS COMPOSIÇÕES
-- ============================================================

-- Fita LED 5m
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'LED-FIT-001')
WHERE descricao_generica ILIKE '%fita%led%5m%'
  AND pricelist_item_id IS NULL;

-- Fonte para LED 12V
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'LED-FON-001')
WHERE descricao_generica ILIKE '%fonte%led%12v%'
  AND pricelist_item_id IS NULL;

-- Piso laminado
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-LAM-001')
WHERE descricao_generica ILIKE '%piso%laminado%'
  AND pricelist_item_id IS NULL;

-- Piso vinílico
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-VIN-001')
WHERE descricao_generica ILIKE '%piso%vinil%'
  AND pricelist_item_id IS NULL;

-- Perfil de acabamento alumínio
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-PER-001')
WHERE descricao_generica ILIKE '%perfil%acabamento%alumin%'
  AND pricelist_item_id IS NULL;

-- Perfil de transição
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-PER-002')
WHERE descricao_generica ILIKE '%perfil%transi%'
  AND pricelist_item_id IS NULL;

-- Rodapé MDF
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-ROD-001')
WHERE descricao_generica ILIKE '%rodape%mdf%'
  AND pricelist_item_id IS NULL;

-- Rodapé porcelanato
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-ROD-002')
WHERE descricao_generica ILIKE '%rodape%porcelanato%'
  AND pricelist_item_id IS NULL;

-- Rodapé vinílico
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PIS-ROD-003')
WHERE descricao_generica ILIKE '%rodape%vinil%'
  AND pricelist_item_id IS NULL;

-- Porcelanato piso
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-POR-001')
WHERE descricao_generica ILIKE '%porcelanato%piso%'
  AND pricelist_item_id IS NULL;

-- Porcelanato parede
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-POR-002')
WHERE descricao_generica ILIKE '%porcelanato%parede%'
  AND pricelist_item_id IS NULL;

-- Placa 4x4
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-PLC-002')
WHERE descricao_generica ILIKE '%placa%4x4%'
  AND pricelist_item_id IS NULL;

-- Fio 1,5mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-FIO-003')
WHERE (descricao_generica ILIKE '%fio%1,5%' OR descricao_generica ILIKE '%fio%1.5%')
  AND pricelist_item_id IS NULL;

-- Fita de borda para manta
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'CON-FIT-001')
WHERE descricao_generica ILIKE '%fita%borda%manta%'
  AND pricelist_item_id IS NULL;

-- Proteção para piso
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'CON-PRO-001')
WHERE descricao_generica ILIKE '%prote%o%piso%'
  AND pricelist_item_id IS NULL;

-- Rolo anti-gota 23cm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'FER-ROL-001')
WHERE descricao_generica ILIKE '%rolo%anti%gota%23%'
  AND pricelist_item_id IS NULL;

-- ============================================================
-- PARTE 7: VERIFICAÇÃO FINAL COMPLETA
-- ============================================================

DO $$
DECLARE
  v_total INT;
  v_vinculados INT;
  v_sem_vinculo INT;
BEGIN
  SELECT COUNT(*) INTO v_total FROM modelos_composicao_itens;
  SELECT COUNT(*) INTO v_vinculados FROM modelos_composicao_itens WHERE pricelist_item_id IS NOT NULL;
  SELECT COUNT(*) INTO v_sem_vinculo FROM modelos_composicao_itens WHERE pricelist_item_id IS NULL;

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'IMPORTAÇÃO PARTE 2 - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de itens de composição: %', v_total;
  RAISE NOTICE 'Itens vinculados ao pricelist: % (%.1f%%)', v_vinculados, (v_vinculados::float / v_total * 100);
  RAISE NOTICE 'Itens ainda sem vínculo: %', v_sem_vinculo;
  RAISE NOTICE '============================================================';
END $$;

-- Listar todos os novos itens importados nesta parte
SELECT
  p.codigo,
  p.nome,
  p.preco,
  p.unidade
FROM pricelist_itens p
WHERE p.codigo LIKE 'LED-%'
   OR p.codigo LIKE 'PIS-%'
   OR p.codigo LIKE 'REV-POR-%'
   OR p.codigo LIKE 'ELE-PLC-002'
   OR p.codigo LIKE 'ELE-FIO-003'
   OR p.codigo LIKE 'CON-%'
   OR p.codigo LIKE 'FER-%'
ORDER BY p.codigo;

-- Se ainda houver itens sem vínculo, listar
SELECT DISTINCT
  mci.descricao_generica,
  mci.classificacao
FROM modelos_composicao_itens mci
WHERE pricelist_item_id IS NULL
ORDER BY mci.classificacao, mci.descricao_generica;
