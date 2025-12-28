-- ==============================================================================
-- IMPORTAÇÃO DE MATERIAIS BÁSICOS PARA COMPOSIÇÕES
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ==============================================================================
-- Este SQL importa materiais básicos de construção organizados por disciplina
-- com preços de referência e imagens de produtos reais.
-- ==============================================================================

-- ==============================================================================
-- PARTE 1: CRIAR CATEGORIAS E SUBCATEGORIAS
-- ==============================================================================

-- Categoria principal: Materiais para Composições
INSERT INTO pricelist_categorias (nome, codigo, tipo, descricao, ordem, ativo)
SELECT 'Materiais - Composições', 'MAT-COMP', 'material', 'Materiais básicos para composições de orçamento', 50, true
WHERE NOT EXISTS (
  SELECT 1 FROM pricelist_categorias WHERE codigo = 'MAT-COMP'
);

-- Função auxiliar para criar subcategorias
DO $$
DECLARE
  v_cat_id UUID;
BEGIN
  SELECT id INTO v_cat_id FROM pricelist_categorias WHERE codigo = 'MAT-COMP';

  IF v_cat_id IS NOT NULL THEN
    -- Elétrica
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Elétrica - Acabamentos', 'material', 1, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Elétrica - Infraestrutura', 'material', 2, true)
    ON CONFLICT DO NOTHING;

    -- Hidráulica
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Hidráulica - Tubulações', 'material', 3, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Hidráulica - Conexões', 'material', 4, true)
    ON CONFLICT DO NOTHING;

    -- Pintura
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Pintura - Tintas', 'material', 5, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Pintura - Preparação', 'material', 6, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Pintura - Consumíveis', 'material', 7, true)
    ON CONFLICT DO NOTHING;

    -- Revestimentos
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Revestimentos - Porcelanatos', 'material', 8, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Revestimentos - Consumíveis', 'material', 9, true)
    ON CONFLICT DO NOTHING;

    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Revestimentos - Pisos Especiais', 'material', 10, true)
    ON CONFLICT DO NOTHING;

    -- Gesso e Forro
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Gesso e Forro', 'material', 11, true)
    ON CONFLICT DO NOTHING;

    -- Ferramentas e Consumíveis Gerais
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_cat_id, 'Ferramentas e Acessórios', 'material', 12, true)
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

-- ==============================================================================
-- PARTE 2: MATERIAIS ELÉTRICOS - ACABAMENTOS
-- ==============================================================================

-- Tomada 2P+T 10A
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-TOM-001',
  'Tomada 2P+T 10A Branca',
  'Tomada monobloco 2P+T 10A 250V cor branca. Padrão NBR 14136.',
  'material',
  'un',
  12.90,
  'Tramontina',
  'ACABAMENTO',
  'https://images.tcdn.com.br/img/img_prod/650946/tomada_2p_t_10a_250v_branco_liz_tramontina_57115_001_83310_1_89e39c9d43a13e917c1a49b88c3a1c8e.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Acabamentos'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-TOM-001');

-- Tomada 2P+T 20A
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-TOM-002',
  'Tomada 2P+T 20A Branca',
  'Tomada monobloco 2P+T 20A 250V cor branca para equipamentos de maior potência.',
  'material',
  'un',
  18.90,
  'Tramontina',
  'ACABAMENTO',
  'https://images.tcdn.com.br/img/img_prod/650946/tomada_2p_t_20a_250v_branco_liz_tramontina_57115_041_83314_1_d8bf71b8de0df25d71caca2b9a6d6dd4.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Acabamentos'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-TOM-002');

-- Interruptor Simples
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-INT-001',
  'Interruptor Simples 1 Tecla Branco',
  'Interruptor simples 1 tecla 10A 250V cor branca.',
  'material',
  'un',
  14.90,
  'Tramontina',
  'ACABAMENTO',
  'https://images.tcdn.com.br/img/img_prod/650946/interruptor_simples_1_tecla_branco_liz_tramontina_57115_001_83295_1_46ac32ef3f98fb51d768a72b8c72d1f3.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Acabamentos'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-INT-001');

-- Interruptor Paralelo (Three-way)
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-INT-002',
  'Interruptor Paralelo (Three-way) Branco',
  'Interruptor paralelo three-way 10A 250V cor branca para comandar de dois pontos.',
  'material',
  'un',
  19.90,
  'Tramontina',
  'ACABAMENTO',
  'https://images.tcdn.com.br/img/img_prod/650946/interruptor_paralelo_branco_liz_tramontina_57115_004_83297_1_7e57f89a2e73ed2dee498c64d46eb789.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Acabamentos'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-INT-002');

-- Placa 4x2
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-PLC-001',
  'Placa 4x2 para 2 Postos Branca',
  'Placa de acabamento 4x2 para 2 postos cor branca.',
  'material',
  'un',
  6.90,
  'Tramontina',
  'ACABAMENTO',
  'https://images.tcdn.com.br/img/img_prod/650946/placa_4x2_2_postos_branco_liz_tramontina_57106_004_83267_1_acf37f3f7e71b5f76d79ca0f57f6e4d7.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Acabamentos'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-PLC-001');

-- ==============================================================================
-- PARTE 3: MATERIAIS ELÉTRICOS - INFRAESTRUTURA
-- ==============================================================================

-- Caixa 4x2
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-CX-001',
  'Caixa de Luz 4x2 PVC Amarela',
  'Caixa de derivação/embutir 4x2 em PVC amarelo para instalações elétricas.',
  'material',
  'un',
  1.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/caixa_de_luz_4x2_plastica_amarela_tigre_89450098_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-CX-001');

-- Caixa 4x4
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-CX-002',
  'Caixa de Luz 4x4 PVC Amarela',
  'Caixa de derivação/embutir 4x4 em PVC amarelo para instalações elétricas.',
  'material',
  'un',
  3.50,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/caixa_de_luz_4x4_plastica_amarela_tigre_89450099_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-CX-002');

-- Caixa Octogonal
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-CX-003',
  'Caixa Octogonal Fundo Móvel PVC',
  'Caixa octogonal com fundo móvel para instalação de lustres e plafons.',
  'material',
  'un',
  4.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/caixa_octogonal_fundo_movel_tigre_89450154_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-CX-003');

-- Eletroduto Corrugado 25mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-ELET-001',
  'Eletroduto Corrugado Flexível 25mm Rolo 50m',
  'Eletroduto corrugado flexível antichama 25mm rolo com 50 metros.',
  'material',
  'rolo',
  89.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/eletroduto_corrugado_flexivel_antichama_25mm_laranja_tigre_rolo_50m_89450092_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-ELET-001');

-- Fio 2,5mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-FIO-001',
  'Fio Flexível 2,5mm² Rolo 100m',
  'Fio flexível de cobre 2,5mm² 750V antichama rolo com 100 metros.',
  'material',
  'rolo',
  189.90,
  'Sil',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/fio_flexivel_sil_2_5mm_100m_89433186_8c6d_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-FIO-001');

-- Fio 4mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-FIO-002',
  'Fio Flexível 4mm² Rolo 100m',
  'Fio flexível de cobre 4mm² 750V antichama rolo com 100 metros.',
  'material',
  'rolo',
  289.90,
  'Sil',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/fio_flexivel_sil_4mm_100m_89433188_7a2a_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-FIO-002');

-- Fita Isolante
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-FIT-001',
  'Fita Isolante 19mm x 20m Preta',
  'Fita isolante em PVC 19mm x 20m cor preta.',
  'material',
  'un',
  8.90,
  '3M',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/fita_isolante_19mm_x_20m_preta_3m_89395134_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-FIT-001');

-- Abraçadeira Nylon
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'ELE-ABR-001',
  'Abraçadeira de Nylon 200mm Pacote 100un',
  'Abraçadeira de nylon branca 200mm x 2,5mm pacote com 100 unidades.',
  'material',
  'pct',
  12.90,
  'Vonder',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/abracadeira_de_nylon_branca_200mm_x_2_5mm_pacote_com_100_pecas_89418734_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Elétrica - Infraestrutura'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'ELE-ABR-001');

-- ==============================================================================
-- PARTE 4: MATERIAIS HIDRÁULICOS - TUBULAÇÕES
-- ==============================================================================

-- Tubo PVC Soldável 25mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-TUB-001',
  'Tubo PVC Soldável 25mm Barra 3m',
  'Tubo PVC soldável para água fria 25mm (3/4") barra com 3 metros.',
  'material',
  'barra',
  16.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/tubo_pvc_soldavel_25mm_3m_tigre_89418215_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Tubulações'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-TUB-001');

-- Tubo PVC Esgoto 50mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-TUB-002',
  'Tubo PVC Esgoto 50mm Barra 3m',
  'Tubo PVC para esgoto série normal 50mm barra com 3 metros.',
  'material',
  'barra',
  24.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/tubo_pvc_esgoto_serie_normal_50mm_3m_tigre_89418222_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Tubulações'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-TUB-002');

-- Tubo PVC Esgoto 100mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-TUB-003',
  'Tubo PVC Esgoto 100mm Barra 3m',
  'Tubo PVC para esgoto série normal 100mm barra com 3 metros.',
  'material',
  'barra',
  48.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/tubo_pvc_esgoto_serie_normal_100mm_3m_tigre_89418226_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Tubulações'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-TUB-003');

-- Tubo PPR Água Quente 25mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-TUB-004',
  'Tubo PPR Água Quente 25mm Barra 3m',
  'Tubo PPR para água quente/fria 25mm barra com 3 metros.',
  'material',
  'barra',
  32.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/tubo_ppr_agua_quente_25mm_3m_tigre_89418238_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Tubulações'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-TUB-004');

-- ==============================================================================
-- PARTE 5: MATERIAIS HIDRÁULICOS - CONEXÕES
-- ==============================================================================

-- Joelho 90 Soldável 25mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-CON-001',
  'Joelho 90° Soldável 25mm PVC',
  'Joelho 90 graus PVC soldável 25mm para água fria.',
  'material',
  'un',
  1.20,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/joelho_90_soldavel_25mm_tigre_89450193_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Conexões'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CON-001');

-- Tê Soldável 25mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-CON-002',
  'Tê Soldável 25mm PVC',
  'Tê PVC soldável 25mm para água fria.',
  'material',
  'un',
  2.50,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/te_soldavel_25mm_tigre_89450220_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Conexões'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CON-002');

-- Luva Soldável 25mm
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-CON-003',
  'Luva Soldável 25mm PVC',
  'Luva de união PVC soldável 25mm para água fria.',
  'material',
  'un',
  0.90,
  'Tigre',
  'INSUMO',
  'https://cdn.leroymerlin.com.br/products/luva_soldavel_25mm_tigre_89450209_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Conexões'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CON-003');

-- Cola PVC
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-CON-004',
  'Cola PVC 175g',
  'Adesivo plástico para PVC frasco 175g.',
  'material',
  'un',
  14.90,
  'Tigre',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/adesivo_plastico_para_pvc_tigre_175g_89417806_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Conexões'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CON-004');

-- Fita Veda Rosca
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-CON-005',
  'Fita Veda Rosca 18mm x 50m',
  'Fita veda rosca PTFE 18mm x 50m para vedação de roscas.',
  'material',
  'un',
  9.90,
  'Tigre',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/fita_veda_rosca_18mm_x_50m_tigre_89417815_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Conexões'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CON-005');

-- Abraçadeira de Metal 3/4"
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'HID-CON-006',
  'Abraçadeira Metálica 3/4" com Parafuso',
  'Abraçadeira metálica tipo U 3/4" (25mm) com parafuso para fixação.',
  'material',
  'un',
  2.90,
  'Vonder',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/abracadeira_metalica_tipo_u_3_4_89417857_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Hidráulica - Conexões'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'HID-CON-006');

-- ==============================================================================
-- PARTE 6: MATERIAIS DE PINTURA - TINTAS
-- ==============================================================================

-- Tinta Acrílica Premium
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'PINT-TIN-001',
  'Tinta Acrílica Premium Fosco 18L',
  'Tinta acrílica premium acabamento fosco para paredes internas e externas. Lata 18 litros.',
  'material',
  'lata',
  389.90,
  'Suvinil',
  'ACABAMENTO',
  'https://cdn.leroymerlin.com.br/products/tinta_acrilica_fosco_premium_branco_18l_suvinil_89418892_0001_600x600.jpg',
  50,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Tintas'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-TIN-001');

-- Tinta Acrílica Galão 3.6L
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'PINT-TIN-002',
  'Tinta Acrílica Premium Fosco 3.6L',
  'Tinta acrílica premium acabamento fosco para paredes internas e externas. Galão 3.6 litros.',
  'material',
  'galao',
  119.90,
  'Suvinil',
  'ACABAMENTO',
  'https://cdn.leroymerlin.com.br/products/tinta_acrilica_fosco_premium_branco_3_6l_suvinil_89418890_0001_600x600.jpg',
  10,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Tintas'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-TIN-002');

-- ==============================================================================
-- PARTE 7: MATERIAIS DE PINTURA - PREPARAÇÃO
-- ==============================================================================

-- Selador Acrílico
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'PINT-SEL-001',
  'Selador Acrílico 3.6L',
  'Selador acrílico para preparação de superfícies. Galão 3.6 litros.',
  'material',
  'galao',
  79.90,
  'Suvinil',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/selador_acrilico_3_6l_suvinil_89418908_0001_600x600.jpg',
  40,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Preparação'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-SEL-001');

-- Massa Corrida PVA
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'PINT-MAS-001',
  'Massa Corrida PVA 25kg',
  'Massa corrida PVA para correção de imperfeições em paredes internas. Lata 25kg.',
  'material',
  'lata',
  89.90,
  'Suvinil',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/massa_corrida_pva_25kg_suvinil_89418968_0001_600x600.jpg',
  2,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Preparação'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-MAS-001');

-- Massa Acrílica
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'PINT-MAS-002',
  'Massa Acrílica 25kg',
  'Massa acrílica para correção de imperfeições em paredes internas e externas. Lata 25kg.',
  'material',
  'lata',
  129.90,
  'Suvinil',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/massa_acrilica_25kg_suvinil_89418972_0001_600x600.jpg',
  2,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Preparação'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-MAS-002');

-- ==============================================================================
-- PARTE 8: MATERIAIS DE PINTURA - CONSUMÍVEIS
-- ==============================================================================

-- Lixa Massa
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'PINT-LIX-001',
  'Lixa para Massa nº 150',
  'Lixa d água para massa nº 150 folha 225x275mm.',
  'material',
  'folha',
  1.90,
  'Norton',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/lixa_d_agua_para_massa_n_150_norton_89395156_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-LIX-001');

-- Fita Crepe
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'PINT-FIT-001',
  'Fita Crepe 48mm x 50m',
  'Fita crepe para pintura 48mm x 50m.',
  'material',
  'rolo',
  24.90,
  '3M',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/fita_crepe_48mm_x_50m_3m_89395142_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-FIT-001');

-- Lona Plástica
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'PINT-LON-001',
  'Lona Plástica Preta 4x5m',
  'Lona plástica preta para proteção 4x5 metros.',
  'material',
  'un',
  19.90,
  'Vonder',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/lona_plastica_preta_4x5m_vonder_89403122_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-LON-001');

-- Rolo de Lã
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'PINT-ROL-001',
  'Rolo de Lã 23cm Antigota',
  'Rolo de lã 23cm para pintura de paredes acabamento antigota.',
  'material',
  'un',
  34.90,
  'Atlas',
  'FERRAMENTA',
  'https://cdn.leroymerlin.com.br/products/rolo_de_la_23cm_antigota_atlas_89395280_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-ROL-001');

-- Pincel 2"
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'PINT-PIN-001',
  'Pincel 2 Polegadas',
  'Pincel para pintura 2 polegadas cerdas de nylon.',
  'material',
  'un',
  12.90,
  'Atlas',
  'FERRAMENTA',
  'https://cdn.leroymerlin.com.br/products/pincel_2_polegadas_atlas_89395262_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Pintura - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'PINT-PIN-001');

-- ==============================================================================
-- PARTE 9: MATERIAIS DE REVESTIMENTOS - CONSUMÍVEIS
-- ==============================================================================

-- Argamassa AC-III
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'REV-ARG-001',
  'Argamassa Colante AC-III Cinza 20kg',
  'Argamassa colante AC-III para assentamento de porcelanatos internos e externos. Saco 20kg.',
  'material',
  'saco',
  42.90,
  'Quartzolit',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/argamassa_colante_ac_iii_cinza_quartzolit_20kg_89407842_0001_600x600.jpg',
  5,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-ARG-001');

-- Argamassa AC-II
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'REV-ARG-002',
  'Argamassa Colante AC-II Cinza 20kg',
  'Argamassa colante AC-II para assentamento de cerâmicas internas. Saco 20kg.',
  'material',
  'saco',
  28.90,
  'Quartzolit',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/argamassa_colante_ac_ii_cinza_quartzolit_20kg_89407838_0001_600x600.jpg',
  5,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-ARG-002');

-- Rejunte Flexível
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'REV-REJ-001',
  'Rejunte Flexível Cinza Platina 1kg',
  'Rejunte flexível para porcelanatos cor cinza platina. Saco 1kg.',
  'material',
  'kg',
  12.90,
  'Quartzolit',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/rejunte_flexivel_cinza_platina_quartzolit_1kg_89407902_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-REJ-001');

-- Espaçadores
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'REV-ESP-001',
  'Espaçador para Piso 2mm Pacote 100un',
  'Espaçador plástico para assentamento de pisos 2mm. Pacote com 100 unidades.',
  'material',
  'pct',
  8.90,
  'Cortag',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/espacador_para_piso_2mm_cortag_pacote_100_pecas_89407954_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-ESP-001');

-- Disco Diamantado
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'REV-DIS-001',
  'Disco Diamantado 110mm Turbo',
  'Disco diamantado 110mm corte turbo para porcelanatos e cerâmicas.',
  'material',
  'un',
  39.90,
  'Bosch',
  'FERRAMENTA',
  'https://cdn.leroymerlin.com.br/products/disco_diamantado_110mm_turbo_bosch_89398254_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-DIS-001');

-- Massa Autonivelante
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, rendimento, ativo
)
SELECT
  s.id,
  'REV-MAS-001',
  'Massa Autonivelante 20kg',
  'Massa autonivelante para regularização de pisos. Saco 20kg.',
  'material',
  'saco',
  79.90,
  'Quartzolit',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/massa_autonivelante_quartzolit_20kg_89407926_0001_600x600.jpg',
  5,
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-MAS-001');

-- Cola para Piso Vinílico
INSERT INTO pricelist_itens (
  subcategoria_id, codigo, nome, descricao, tipo, unidade, preco,
  fabricante, classificacao_orcamento, imagem_url, ativo
)
SELECT
  s.id,
  'REV-COL-001',
  'Cola para Piso Vinílico 4kg',
  'Cola acrílica para assentamento de piso vinílico. Balde 4kg.',
  'material',
  'balde',
  89.90,
  'Tarkett',
  'CONSUMIVEL',
  'https://cdn.leroymerlin.com.br/products/cola_para_piso_vinilico_tarkett_4kg_89408002_0001_600x600.jpg',
  true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON c.id = s.categoria_id
WHERE c.codigo = 'MAT-COMP' AND s.nome = 'Revestimentos - Consumíveis'
AND NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'REV-COL-001');

-- ==============================================================================
-- PARTE 10: VERIFICAÇÃO E VINCULAÇÃO COM COMPOSIÇÕES
-- ==============================================================================

-- Verificar quantos materiais foram importados
DO $$
DECLARE
  v_total INT;
BEGIN
  SELECT COUNT(*) INTO v_total
  FROM pricelist_itens
  WHERE codigo LIKE 'ELE-%' OR codigo LIKE 'HID-%'
     OR codigo LIKE 'PINT-%' OR codigo LIKE 'REV-%';

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'IMPORTAÇÃO DE MATERIAIS BÁSICOS - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de materiais importados: %', v_total;
  RAISE NOTICE '';
  RAISE NOTICE 'Categorias:';
  RAISE NOTICE '  - Elétrica - Acabamentos';
  RAISE NOTICE '  - Elétrica - Infraestrutura';
  RAISE NOTICE '  - Hidráulica - Tubulações';
  RAISE NOTICE '  - Hidráulica - Conexões';
  RAISE NOTICE '  - Pintura - Tintas';
  RAISE NOTICE '  - Pintura - Preparação';
  RAISE NOTICE '  - Pintura - Consumíveis';
  RAISE NOTICE '  - Revestimentos - Consumíveis';
  RAISE NOTICE '============================================================';
END $$;

-- Listar materiais importados
SELECT
  codigo,
  nome,
  classificacao_orcamento,
  preco,
  unidade,
  fabricante
FROM pricelist_itens
WHERE codigo LIKE 'ELE-%' OR codigo LIKE 'HID-%'
   OR codigo LIKE 'PINT-%' OR codigo LIKE 'REV-%'
ORDER BY codigo;
