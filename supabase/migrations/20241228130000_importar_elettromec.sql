-- ============================================================
-- IMPORTAÇÃO DE PRODUTOS ELETTROMEC COM IMAGENS
-- Sistema WG Easy - Grupo WG Almeida
-- Atualizado em: 2025-12-26
-- ============================================================

-- Criar categoria de Eletrodomésticos se não existir
INSERT INTO pricelist_categorias (nome, codigo, tipo, descricao, ordem, ativo)
SELECT 'Eletrodomésticos', 'ELETRO', 'produto', 'Eletrodomésticos de alto padrão', 1, true
WHERE NOT EXISTS (
  SELECT 1 FROM pricelist_categorias
  WHERE nome = 'Eletrodomésticos' AND tipo = 'produto'
);

-- Guardar o ID da categoria
DO $$
DECLARE
  v_categoria_id UUID;
  v_subcategoria_cooktop_id UUID;
  v_subcategoria_forno_id UUID;
  v_subcategoria_coifa_id UUID;
BEGIN
  -- Buscar categoria
  SELECT id INTO v_categoria_id
  FROM pricelist_categorias
  WHERE nome = 'Eletrodomésticos' AND tipo = 'produto';

  -- Criar subcategorias
  INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
  SELECT v_categoria_id, 'Cooktops', 'produto', 1, true
  WHERE NOT EXISTS (
    SELECT 1 FROM pricelist_subcategorias
    WHERE categoria_id = v_categoria_id AND nome = 'Cooktops'
  );

  INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
  SELECT v_categoria_id, 'Fornos', 'produto', 2, true
  WHERE NOT EXISTS (
    SELECT 1 FROM pricelist_subcategorias
    WHERE categoria_id = v_categoria_id AND nome = 'Fornos'
  );

  INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
  SELECT v_categoria_id, 'Coifas', 'produto', 3, true
  WHERE NOT EXISTS (
    SELECT 1 FROM pricelist_subcategorias
    WHERE categoria_id = v_categoria_id AND nome = 'Coifas'
  );

  -- Buscar IDs das subcategorias
  SELECT id INTO v_subcategoria_cooktop_id FROM pricelist_subcategorias WHERE categoria_id = v_categoria_id AND nome = 'Cooktops';
  SELECT id INTO v_subcategoria_forno_id FROM pricelist_subcategorias WHERE categoria_id = v_categoria_id AND nome = 'Fornos';
  SELECT id INTO v_subcategoria_coifa_id FROM pricelist_subcategorias WHERE categoria_id = v_categoria_id AND nome = 'Coifas';

  -- ============================================================
  -- COOKTOPS ELETTROMEC
  -- ============================================================

  INSERT INTO pricelist_itens (categoria_id, subcategoria_id, codigo, nome, descricao, tipo, unidade, preco, fabricante, modelo, codigo_fabricante, link_produto, imagem_url, ativo) VALUES
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-CKI-60', 'Cooktop Indução 60 cm', 'Cooktop de indução com 4 zonas de cocção, 60cm, vidro preto com frame inox', 'produto', 'un', 0, 'Elettromec', 'Indução 60cm', 'CKI-4Q-60-CI-2KSA', 'https://elettromec.com.br/produto/cooktop-inducao-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/03/elettromec_E2_124-Cooktop-Inducao-60-Cm-220V-01.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-CKI-90', 'Cooktop Indução 90 cm', 'Cooktop de indução com zonas flexíveis, 90cm', 'produto', 'un', 0, 'Elettromec', 'Indução 90cm', 'E2_125', 'https://elettromec.com.br/produto/cooktop-inducao-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/03/elettromec_E2_125-Cooktop-Inducao-90-Cm-220V-01.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-LUCE-4Q-60', 'Cooktop Luce 4 Queimadores 60 cm', 'Cooktop a gás linha Luce, 4 queimadores, 60cm', 'produto', 'un', 0, 'Elettromec', 'Luce 4Q 60cm', 'EF_35', 'https://elettromec.com.br/produto/cooktop-luce-4-queimadores-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_35-Cooktop-Luce-60-Cm_01-1-scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-LUCE-5Q-75', 'Cooktop Luce 5 Queimadores 75 cm', 'Cooktop a gás linha Luce, 5 queimadores, 75cm', 'produto', 'un', 0, 'Elettromec', 'Luce 5Q 75cm', 'EF_36', 'https://elettromec.com.br/produto/cooktop-luce-5-queimadores-75-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_36-Cooktop-Luce-70-Cm_01-scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-LUCE-5Q-90', 'Cooktop Luce 5 Queimadores 90 cm', 'Cooktop a gás linha Luce, 5 queimadores, 90cm', 'produto', 'un', 0, 'Elettromec', 'Luce 5Q 90cm', 'EF_37', 'https://elettromec.com.br/produto/cooktop-luce-5-queimadores-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_37-Cooktop-Luce-90-Cm_01--scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-QUAD-4Q-60', 'Cooktop Quadratto 4 Queimadores 60 cm', 'Cooktop a gás linha Quadratto, 4 queimadores, 60cm', 'produto', 'un', 0, 'Elettromec', 'Quadratto 4Q 60cm', 'E1_58', 'https://elettromec.com.br/produto/cooktop-quadratto-4-queimadores-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_E1_58-Cooktop-Quadratto-60cm-01-2.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-QUAD-5Q-75', 'Cooktop Quadratto 5 Queimadores 75 cm', 'Cooktop a gás linha Quadratto, 5 queimadores, 75cm', 'produto', 'un', 0, 'Elettromec', 'Quadratto 5Q 75cm', 'EF_59', 'https://elettromec.com.br/produto/cooktop-quadratto-5-queimadores-75-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_59-Cooktop-Quadratto-75cm_01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-QUAD-5Q-90', 'Cooktop Quadratto 5 Queimadores 90 cm', 'Cooktop a gás linha Quadratto, 5 queimadores com Dual Flame, 90cm, aço inox', 'produto', 'un', 0, 'Elettromec', 'Quadratto 5Q 90cm', 'CKG-5Q-90-XQ-3ZEA', 'https://elettromec.com.br/produto/cooktop-quadratto-5-queimadores-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_60-Cooktop-Quadratto-90cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-QUAD-6Q-90', 'Cooktop Quadratto 6 Queimadores 90 cm', 'Cooktop a gás linha Quadratto, 6 queimadores, 90cm', 'produto', 'un', 0, 'Elettromec', 'Quadratto 6Q 90cm', 'EF_61', 'https://elettromec.com.br/produto/cooktop-quadratto-6-queimadores-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_61-COOKTOP-QUADRATTO-90CM_01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-REV-90', 'Cooktop Revestir 90 cm', 'Cooktop a gás para revestir, 90cm', 'produto', 'un', 0, 'Elettromec', 'Revestir 90cm', 'EF_104', 'https://elettromec.com.br/produto/cooktop-revestir-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_104-Cooktop-Revestir-90-cm-127V-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-SOLE-4Q-60', 'Cooktop Sole 4 Queimadores 60 cm', 'Cooktop a gás linha Sole, 4 queimadores, 60cm', 'produto', 'un', 0, 'Elettromec', 'Sole 4Q 60cm', 'EF_62', 'https://elettromec.com.br/produto/cooktop-sole-4-queimadores-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_62-Cooktop-Sole-60cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-SOLE-5Q-70', 'Cooktop Sole 5 Queimadores 70 cm', 'Cooktop a gás linha Sole, 5 queimadores, 70cm', 'produto', 'un', 0, 'Elettromec', 'Sole 5Q 70cm', NULL, 'https://elettromec.com.br/produto/cooktop-sole-5-queimadores-70-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/ELETTR_1-scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-SOLE-5Q-90', 'Cooktop Sole 5 Queimadores 90 cm', 'Cooktop a gás linha Sole, 5 queimadores, 90cm', 'produto', 'un', 0, 'Elettromec', 'Sole 5Q 90cm', 'EF_64', 'https://elettromec.com.br/produto/cooktop-sole-5-queimadores-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_64-Cooktop-Sole-90cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-VETRO-4Q-60', 'Cooktop Vetro 4 Queimadores 60 cm', 'Cooktop a gás linha Vetro (vidro), 4 queimadores, 60cm', 'produto', 'un', 0, 'Elettromec', 'Vetro 4Q 60cm', 'EF_65', 'https://elettromec.com.br/produto/cooktop-vetro-4-queimadores-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_65-Cooktop-Vetro-60cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-VETRO-5Q-70', 'Cooktop Vetro 5 Queimadores 70 cm', 'Cooktop a gás linha Vetro (vidro), 5 queimadores, 70cm', 'produto', 'un', 0, 'Elettromec', 'Vetro 5Q 70cm', 'EF_47', 'https://elettromec.com.br/produto/cooktop-vetro-5-queimadores-70-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_47-Cooktop-Vetro-70-Cm-Bivolt-Dual-Flame-Lateral_01-scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-VETRO-5Q-90', 'Cooktop Vetro 5 Queimadores 90 cm', 'Cooktop a gás linha Vetro (vidro), 5 queimadores, 90cm', 'produto', 'un', 0, 'Elettromec', 'Vetro 5Q 90cm', 'EF_67', 'https://elettromec.com.br/produto/cooktop-vetro-5-queimadores-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_67-Cooktop-Vetro-90cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-VITRO-60', 'Cooktop Vitrocerâmico 60 cm', 'Cooktop vitrocerâmico elétrico, 60cm', 'produto', 'un', 0, 'Elettromec', 'Vitrocerâmico 60cm', 'E1_121', 'https://elettromec.com.br/produto/cooktop-vitroceramico-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/elettromec_E1_121-Cooktop-Vitroceramico-60-Cm-220V-01-1-scaled.png', true),
  (v_categoria_id, v_subcategoria_cooktop_id, 'ELET-VITRO-90', 'Cooktop Vitrocerâmico 90 cm', 'Cooktop vitrocerâmico elétrico, 90cm', 'produto', 'un', 0, 'Elettromec', 'Vitrocerâmico 90cm', 'E3_122', 'https://elettromec.com.br/produto/cooktop-vitroceramico-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/elettromec_E3_122-Cooktop-Vitroceramico-90-Cm-220V-01-scaled.png', true)
  ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    fabricante = EXCLUDED.fabricante,
    modelo = EXCLUDED.modelo,
    codigo_fabricante = EXCLUDED.codigo_fabricante,
    link_produto = EXCLUDED.link_produto,
    imagem_url = EXCLUDED.imagem_url;

  -- ============================================================
  -- FORNOS ELETTROMEC
  -- ============================================================

  INSERT INTO pricelist_itens (categoria_id, subcategoria_id, codigo, nome, descricao, tipo, unidade, preco, fabricante, modelo, link_produto, imagem_url, ativo) VALUES
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-LUCE-G60', 'Forno Luce Gás 60 cm', 'Forno a gás linha Luce, 60cm', 'produto', 'un', 0, 'Elettromec', 'Luce Gás 60cm', 'https://elettromec.com.br/produto/forno-luce-gas-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_E1_Forno_Luce_Gas_60_01-scaled.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-LUCE-G90', 'Forno Luce Gás 90 cm', 'Forno a gás linha Luce, 90cm', 'produto', 'un', 0, 'Elettromec', 'Luce Gás 90cm', 'https://elettromec.com.br/produto/forno-luce-gas-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_E2_129-Forno-Luce-Gas-90-Cm-220-V-01-1-scaled.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-LUCE-E60', 'Forno Luce Multifunção Elétrico 60 cm', 'Forno elétrico multifunção linha Luce, 60cm', 'produto', 'un', 0, 'Elettromec', 'Luce Elétrico 60cm', 'https://elettromec.com.br/produto/forno-luce-multifuncao-eletrico-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_E1_Forno_Luce_Multifuncao_Eletronico_60_01-scaled.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-LUCE-E75', 'Forno Luce Multifunção Elétrico 75 cm', 'Forno elétrico multifunção linha Luce, 75cm', 'produto', 'un', 0, 'Elettromec', 'Luce Elétrico 75cm', 'https://elettromec.com.br/produto/forno-luce-multifuncao-eletrico-75-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/0315-ELETTROMEC-12-09-18-1024x878-1.webp', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-LUCE-E90', 'Forno Luce Multifunção Elétrico 90 cm', 'Forno elétrico multifunção linha Luce, 90cm', 'produto', 'un', 0, 'Elettromec', 'Luce Elétrico 90cm', 'https://elettromec.com.br/produto/forno-luce-multifuncao-eletrico-90-m/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_E2_128-Forno-Luce-Multifuncao-Eletronico-90-Cm-220-V-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-SOLE-VAPOR', 'Forno Sole a Vapor Elétrico Digital 60 cm', 'Forno a vapor elétrico digital linha Sole, 60cm', 'produto', 'un', 0, 'Elettromec', 'Sole Vapor 60cm', 'https://elettromec.com.br/produto/forno-sole-a-vapor-eletrico-digital-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/03/Elettromec_E2_126-Forno-Sole-A-Vapor-Digital-60Cm-220-V-01.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-SOLE-DIG', 'Forno Sole Multifunção Digital Elétrico 60 cm', 'Forno elétrico digital multifunção linha Sole, 60cm', 'produto', 'un', 0, 'Elettromec', 'Sole Digital 60cm', 'https://elettromec.com.br/produto/forno-sole-multifuncao-digital-eletrico-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_E1_Forno_Sole_Multifuncao_Digital_60_01-scaled.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-VETRO-DIG', 'Forno Vetro Multifunção Digital Elétrico 60 cm', 'Forno elétrico digital multifunção linha Vetro, 60cm', 'produto', 'un', 0, 'Elettromec', 'Vetro Digital 60cm', 'https://elettromec.com.br/produto/forno-vetro-multifuncao-digital-eletrico-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/ELETTR1-3-scaled.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-VETRO-60', 'Forno Vetro Multifunção Elétrico 60 cm', 'Forno elétrico multifunção linha Vetro, 60cm', 'produto', 'un', 0, 'Elettromec', 'Vetro Elétrico 60cm', 'https://elettromec.com.br/produto/forno-vetro-multifuncao-eletrico-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/FM-EL-60-VT-2TNA_05.png', true),
  (v_categoria_id, v_subcategoria_forno_id, 'ELET-FORNO-VETRO-75', 'Forno Vetro Multifunção Elétrico 75 cm', 'Forno elétrico multifunção linha Vetro, 75cm', 'produto', 'un', 0, 'Elettromec', 'Vetro Elétrico 75cm', 'https://elettromec.com.br/produto/forno-vetro-multifuncao-eletrico-75-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/FM-EL-75-VT-2TNA_02-1024x931-1.webp', true)
  ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    fabricante = EXCLUDED.fabricante,
    modelo = EXCLUDED.modelo,
    link_produto = EXCLUDED.link_produto,
    imagem_url = EXCLUDED.imagem_url;

  -- ============================================================
  -- COIFAS ELETTROMEC
  -- ============================================================

  INSERT INTO pricelist_itens (categoria_id, subcategoria_id, codigo, nome, descricao, tipo, unidade, preco, fabricante, modelo, link_produto, imagem_url, ativo) VALUES
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-ADRIA-ILH-90', 'Coifa Adria Ilha 90 cm Connect', 'Coifa de ilha linha Adria com conectividade, 90cm', 'produto', 'un', 0, 'Elettromec', 'Adria Ilha 90cm', 'https://elettromec.com.br/produto/coifa-adria-ilha-90-cm-connect/', 'https://elettromec.com.br/wp-content/uploads/2025/04/adria-ilha.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-ADRIA-PAR-90', 'Coifa Adria Parede 90 cm Connect', 'Coifa de parede linha Adria com conectividade, 90cm', 'produto', 'un', 0, 'Elettromec', 'Adria Parede 90cm', 'https://elettromec.com.br/produto/coifa-adria-parede-90-cm-connect/', 'https://elettromec.com.br/wp-content/uploads/2025/04/adria-ilha.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-ADRIA-VETRO-ILH', 'Coifa Adria Vetro Ilha 90 cm', 'Coifa de ilha linha Adria Vetro (vidro), 90cm', 'produto', 'un', 0, 'Elettromec', 'Adria Vetro Ilha 90cm', 'https://elettromec.com.br/produto/coifa-adria-vetro-ilha-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/adria-vetro.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-ADRIA-VETRO-PAR', 'Coifa Adria Vetro Parede 90 cm', 'Coifa de parede linha Adria Vetro (vidro), 90cm', 'produto', 'un', 0, 'Elettromec', 'Adria Vetro Parede 90cm', 'https://elettromec.com.br/produto/coifa-adria-vetro-parede-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/adria-vetro.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-CHURR-75', 'Coifa Churrasqueira 75 cm', 'Coifa para churrasqueira, 75cm', 'produto', 'un', 0, 'Elettromec', 'Churrasqueira 75cm', 'https://elettromec.com.br/produto/coifa-churrasqueira-75-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/03/elettromec_E1-127-Coifa-Churrasqueira-Parede-75-Cm-220V-01.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-CHURR-90', 'Coifa Churrasqueira 90 cm', 'Coifa para churrasqueira, 90cm', 'produto', 'un', 0, 'Elettromec', 'Churrasqueira 90cm', 'https://elettromec.com.br/produto/coifa-churasqueira-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/03/elettromec_E1-134-Coifa-Churrasqueira-Parede-90-Cm-220V-01.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MILANO-ILH-120', 'Coifa Milano Ilha 120 cm', 'Coifa de ilha linha Milano, 120cm', 'produto', 'un', 0, 'Elettromec', 'Milano Ilha 120cm', 'https://elettromec.com.br/produto/coifa-milano-ilha-120-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/milano-ilha-120.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MILANO-ILH-90', 'Coifa Milano Ilha 90 cm', 'Coifa de ilha linha Milano, 90cm', 'produto', 'un', 0, 'Elettromec', 'Milano Ilha 90cm', 'https://elettromec.com.br/produto/coifa-milano-ilha-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/milano-ilha-90-1.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MILANO-PAR-120', 'Coifa Milano Parede 120 cm', 'Coifa de parede linha Milano, 120cm', 'produto', 'un', 0, 'Elettromec', 'Milano Parede 120cm', 'https://elettromec.com.br/produto/coifa-milano-parede-120-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/milano-ilha-120.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MILANO-PAR-60', 'Coifa Milano Parede 60 cm', 'Coifa de parede linha Milano, 60cm', 'produto', 'un', 0, 'Elettromec', 'Milano Parede 60cm', 'https://elettromec.com.br/produto/coifa-milano-parede-60-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/milano-parede-60.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MILANO-PAR-80', 'Coifa Milano Parede 80 cm', 'Coifa de parede linha Milano, 80cm', 'produto', 'un', 0, 'Elettromec', 'Milano Parede 80cm', 'https://elettromec.com.br/produto/coifa-milano-parede-80-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/milano-parede-80.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MILANO-PAR-90', 'Coifa Milano Parede 90 cm', 'Coifa de parede linha Milano, 90cm', 'produto', 'un', 0, 'Elettromec', 'Milano Parede 90cm', 'https://elettromec.com.br/produto/coifa-milano-parede-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/milano-ilha-90.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-MOBILE-90', 'Coifa Mobile Built-in 90 cm Connect', 'Coifa embutida Mobile com conectividade, 90cm', 'produto', 'un', 0, 'Elettromec', 'Mobile Built-in 90cm', 'https://elettromec.com.br/produto/coifa-mobile-built-in-90-cm-connect/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_94-Coifa-Ilha-Mobile-Connect-01-1024x576-1.webp', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-NAUTILUS-35', 'Coifa Nautilus Ilha 35 cm', 'Coifa de ilha linha Nautilus, 35cm', 'produto', 'un', 0, 'Elettromec', 'Nautilus Ilha 35cm', 'https://elettromec.com.br/produto/coifa-nautilus-ilha-35-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_35-Coifa-Nautilus-Ilha-35cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-NAUTILUS-120', 'Coifa Nautilus Sorelle Ilha 120 cm', 'Coifa de ilha linha Nautilus Sorelle, 120cm', 'produto', 'un', 0, 'Elettromec', 'Nautilus Sorelle 120cm', 'https://elettromec.com.br/produto/coifa-nautilus-sorelle-ilha-120-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_36-Coifa-Nautilus-Sorelle-120cm-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PANDORA-50', 'Coifa Pandora Ilha 50 cm', 'Coifa de ilha linha Pandora, 50cm', 'produto', 'un', 0, 'Elettromec', 'Pandora Ilha 50cm', 'https://elettromec.com.br/produto/coifa-pandora-ilha-50-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_37-Coifa-Pandora-Ilha-50cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROF-CHURR-34', 'Coifa Professional Churrasqueira Built-In 34"', 'Coifa profissional para churrasqueira embutida, 34 polegadas', 'produto', 'un', 0, 'Elettromec', 'Professional Churr 34"', 'https://elettromec.com.br/produto/coifa-professional-churrasqueira-built-in-34/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_25-Coifa-Churrasqueira-Built-in-34-Polegadas-220V-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROF-CHURR-58', 'Coifa Professional Churrasqueira Built-In 58"', 'Coifa profissional para churrasqueira embutida, 58 polegadas', 'produto', 'un', 0, 'Elettromec', 'Professional Churr 58"', 'https://elettromec.com.br/produto/coifa-professional-churrasqueira-built-in-58/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_26-Coifa-Churrasqueira-Built-in-58-Polegadas-220V-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROF-PAR-30', 'Coifa Professional Churrasqueira Parede 30"', 'Coifa profissional para churrasqueira de parede, 30 polegadas', 'produto', 'un', 0, 'Elettromec', 'Professional Parede 30"', 'https://elettromec.com.br/produto/coifa-professional-churrasqueira-parede-30/', 'https://elettromec.com.br/wp-content/uploads/2025/04/BENEFICIO-02-Elettromec_EF_27-Coifa-Churrasqueira-Parede-30-Polegadas-220V-01-1-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROF-PAR-36', 'Coifa Professional Churrasqueira Parede 36"', 'Coifa profissional para churrasqueira de parede, 36 polegadas', 'produto', 'un', 0, 'Elettromec', 'Professional Parede 36"', 'https://elettromec.com.br/produto/coifa-professional-churrasqueira-parede-36/', 'https://elettromec.com.br/wp-content/uploads/2025/04/BENEFICIO-02-Elettromec_EF_32-Coifa-Churrasqueira-Parede-36-Polegadas-220V_01-2-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROF-PAR-48', 'Coifa Professional Churrasqueira Parede 48"', 'Coifa profissional para churrasqueira de parede, 48 polegadas', 'produto', 'un', 0, 'Elettromec', 'Professional Parede 48"', 'https://elettromec.com.br/produto/coifa-professional-churrasqueira-parede-48/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Coifa-Professional-Churrasqueira-Parede-48.webp', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROF-PAR-60', 'Coifa Professional Churrasqueira Parede 60"', 'Coifa profissional para churrasqueira de parede, 60 polegadas', 'produto', 'un', 0, 'Elettromec', 'Professional Parede 60"', 'https://elettromec.com.br/produto/coifa-professional-churrasqueira-parede-60/', 'https://elettromec.com.br/wp-content/uploads/2025/04/BENEFICIO-02-Elettromec_EF_34-Coifa-Churrasqueira-Parede-60-Polegadas-220V_01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-PROTEUS-35', 'Coifa Proteus Ilha 35 cm', 'Coifa de ilha linha Proteus, 35cm', 'produto', 'un', 0, 'Elettromec', 'Proteus Ilha 35cm', 'https://elettromec.com.br/produto/coifa-proteus-ilha-35-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_38-Coifa-Proteus-Ilha-35cm-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-RAVENA-PAR', 'Coifa Ravena Parede 90 cm', 'Coifa de parede linha Ravena, 90cm', 'produto', 'un', 0, 'Elettromec', 'Ravena Parede 90cm', 'https://elettromec.com.br/produto/coifa-ravena-parede-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_43-Coifa-Ravenna-Parede-90cm-03-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-RAVENNA-ILH', 'Coifa Ravenna Ilha 90 cm', 'Coifa de ilha linha Ravenna, 90cm', 'produto', 'un', 0, 'Elettromec', 'Ravenna Ilha 90cm', 'https://elettromec.com.br/produto/coifa-ravenna-ilha-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_40-Coifa-Ravenna-Ilha-90cm-01-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-SERATA-PAR', 'Coifa Serata Parede 90 cm', 'Coifa de parede linha Serata, 90cm', 'produto', 'un', 0, 'Elettromec', 'Serata Parede 90cm', 'https://elettromec.com.br/produto/coifa-serata-parede-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_48-COIFA-SERATA-PAREDE-90-CM_02-scaled.jpg', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-SOLLEVARE-90', 'Coifa Sollevare Downdraft Connect 90 cm', 'Coifa downdraft Sollevare com conectividade, 90cm', 'produto', 'un', 0, 'Elettromec', 'Sollevare Downdraft 90cm', 'https://elettromec.com.br/produto/coifa-sollevare-downdraft-connect-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_95-Coifa-Downdraft-Solevare-Connect-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-SOSPESA-110', 'Coifa Sospesa Ilha 110 cm Connect', 'Coifa de ilha linha Sospesa com conectividade, 110cm', 'produto', 'un', 0, 'Elettromec', 'Sospesa Ilha 110cm', 'https://elettromec.com.br/produto/coifa-sospesa-ilha-110-cm-connect/', 'https://elettromec.com.br/wp-content/uploads/2025/04/Elettromec_EF_96-Coifa-Ilha-Sospesa-Connect-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-VETRO-ILH-90', 'Coifa Vetro Ilha Connect 90 cm', 'Coifa de ilha linha Vetro com conectividade, 90cm', 'produto', 'un', 0, 'Elettromec', 'Vetro Ilha 90cm', 'https://elettromec.com.br/produto/coifa-vetro-ilha-connect-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/Elettromec_EF_97-Coifa-Ilha-Vetro-Connect-01-scaled.png', true),
  (v_categoria_id, v_subcategoria_coifa_id, 'ELET-COIFA-VETRO-PAR-90', 'Coifa Vetro Parede Connect 90 cm', 'Coifa de parede linha Vetro com conectividade, 90cm', 'produto', 'un', 0, 'Elettromec', 'Vetro Parede 90cm', 'https://elettromec.com.br/produto/coifa-vetro-parede-connect-90-cm/', 'https://elettromec.com.br/wp-content/uploads/2025/05/DESTAQUE-02-1-1-1024x1024-1.webp', true)
  ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    fabricante = EXCLUDED.fabricante,
    modelo = EXCLUDED.modelo,
    link_produto = EXCLUDED.link_produto,
    imagem_url = EXCLUDED.imagem_url;

  RAISE NOTICE 'Importação Elettromec concluída: 18 cooktops, 10 fornos, 30 coifas = 58 produtos COM IMAGENS';
END $$;

-- Verificar importação
SELECT
  'Elettromec' as fabricante,
  COUNT(*) as total_produtos,
  COUNT(CASE WHEN imagem_url IS NOT NULL THEN 1 END) as com_imagem
FROM pricelist_itens
WHERE fabricante = 'Elettromec';
