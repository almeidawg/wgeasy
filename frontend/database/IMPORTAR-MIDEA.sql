-- ============================================================
-- IMPORTAR PRODUTOS MIDEA - ELETRODOMÉSTICOS E ACESSÓRIOS
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- Fonte: https://www.midea.com.br
-- ============================================================

-- ============================================================
-- PARTE 1: CRIAR CATEGORIAS MIDEA
-- ============================================================

-- Categoria principal Eletrodomésticos (se não existir)
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Eletrodomésticos', 'produto', 'Eletrodomésticos e eletroportáteis', 10, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Eletrodom%stico%');

-- Subcategoria Ar Condicionado
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Ar Condicionado', 'produto', 'Ar condicionado split, janela e portátil', 11, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome = 'Ar Condicionado');

-- Subcategoria Refrigeração
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Refrigeração', 'produto', 'Geladeiras, freezers e frigobares', 12, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome = 'Refrigeração');

-- Subcategoria Lavanderia
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Lavanderia', 'produto', 'Lavadoras, lava e seca, secadoras', 13, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome = 'Lavanderia');

-- Subcategoria Cozinha
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Cozinha Eletrodomésticos', 'produto', 'Cooktops, coifas, fornos, micro-ondas, lava-louças', 14, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos');

-- Subcategoria Eletroportáteis
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Eletroportáteis', 'produto', 'Air fryer, panelas elétricas, aspiradores', 15, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome = 'Eletroportáteis');

-- ============================================================
-- PARTE 2: AR CONDICIONADO SPLIT MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split 9000 BTU AirVolution Frio Midea',
  'MIDEA-AC-001',
  'Ar condicionado split 9.000 BTUs, frio, modelo AirVolution. Eficiência energética, filtro antibacteriano.',
  2159.05,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/166558/01.ar-condicionado-split-9000-btu-airvolution-frio-midea-5-42AFFCI09S5.38TFCI09S5-PackshotA.jpg',
  'https://www.midea.com.br/ar-condicionado-split-9000-btu-airvolution-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split Inverter 9000 BTU AirVolution Frio Midea',
  'MIDEA-AC-002',
  'Ar condicionado split inverter 9.000 BTUs, frio, modelo AirVolution. Economia de energia, operação silenciosa.',
  2209.47,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/166385/01.Ar-Condicionado-split-9000-BTU-AirVolution-Frio-Midea-42AFVCI09S5.38TVCI09S5-PackshotA.jpg',
  'https://www.midea.com.br/ar-condicionado-split-inverter-9000-btu-airvolution-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split Inverter 12000 BTU AirVolution Frio Midea',
  'MIDEA-AC-003',
  'Ar condicionado split inverter 12.000 BTUs, frio, modelo AirVolution. Ideal para ambientes de até 20m².',
  2489.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167243/01.ar-condicionado-split-inverter-12000-btu-airvolution-frio-midea-42AFVCI12S5.38TVCI12S5-PackshotA.jpg',
  'https://www.midea.com.br/ar-condicionado-split-inverter-12000-btu-airvolution-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-003');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split 18000 BTU AirVolution Frio Midea',
  'MIDEA-AC-004',
  'Ar condicionado split 18.000 BTUs, frio, modelo AirVolution. Para ambientes de até 30m².',
  3504.21,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/169196/01---Ar-condicionado-42AFFCI18S5-38TFCI18S5---frentte.jpg',
  'https://www.midea.com.br/ar-condicionado-split-18000-btu-airvolution-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-004');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split Inverter 12000 BTU Black Edition Q/F Midea',
  'MIDEA-AC-005',
  'Ar condicionado split inverter 12.000 BTUs, quente/frio, Black Edition. Design premium preto.',
  3009.47,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167066/1-ar-condicionado-split-inverter-12000-btu-black-edition-q-f-midea-42MGVQI12M5.38MGVQI12M5-Packshot-A.jpg',
  'https://www.midea.com.br/ar-condicionado-split-inverter-12000-btu-black-edition/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-005');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split Inverter 18000 BTU Black Edition Q/F Midea',
  'MIDEA-AC-006',
  'Ar condicionado split inverter 18.000 BTUs, quente/frio, Black Edition. Design premium preto.',
  4449.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167110/1-ar-condicionado-split-inverter-18000-btu-black-edition-q-f-midea-42MGVQI18M5.38MGVQI18M5-Packshot-A.jpg',
  'https://www.midea.com.br/ar-condicionado-split-inverter-18000-btu-black-edition/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-006');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split Inverter 24000 BTU Black Edition Q/F Midea',
  'MIDEA-AC-007',
  'Ar condicionado split inverter 24.000 BTUs, quente/frio, Black Edition. Para ambientes grandes.',
  5988.42,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167152/1-ar-condicionado-split-inverter-24000-btu-black-edition-q-f-midea-42MGVQI24M5.38MGVQI24M5-Packshot-A.jpg',
  'https://www.midea.com.br/ar-condicionado-split-inverter-24000-btu-black-edition/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-007');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split 9000 BTUs Inverter AI Ecomaster Frio Midea',
  'MIDEA-AC-008',
  'Ar condicionado split 9.000 BTUs, inverter AI Ecomaster, frio. Tecnologia de inteligência artificial.',
  2872.63,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/173466/01-ar-condicionado-midea-ai-ecomaster-38EZVCA12M5-packshot.jpg',
  'https://www.midea.com.br/ar-condicionado-split-9000-btus-inverter-ai-ecomaster-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-008');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split 12000 BTUs Inverter AI Ecomaster Frio Midea',
  'MIDEA-AC-009',
  'Ar condicionado split 12.000 BTUs, inverter AI Ecomaster, frio. Tecnologia de inteligência artificial.',
  2825.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/173498/01-ar-condicionado-midea-ai-ecomaster-38EZVCA12M5-packshot.jpg',
  'https://www.midea.com.br/ar-condicionado-split-12000-btus-inverter-ai-ecomaster-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-009');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Ar Condicionado Split 24000 BTUs Inverter AI Ecomaster Frio Midea',
  'MIDEA-AC-010',
  'Ar condicionado split 24.000 BTUs, inverter AI Ecomaster, frio. Para ambientes grandes até 40m².',
  5872.63,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Ar Condicionado' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/173424/01-ar-condicionado-midea-ai-ecomaster-38EZVCA12M5-packshot.jpg',
  'https://www.midea.com.br/ar-condicionado-split-24000-btus-inverter-ai-ecomaster-frio/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AC-010');

-- ============================================================
-- PARTE 3: REFRIGERAÇÃO MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Geladeira Side by Side 511L Inox Midea',
  'MIDEA-REF-001',
  'Geladeira side by side 511L, cor inox, classificação A+++, inverter, painel digital touch, conectada.',
  5549.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Refrigeração' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/178004/01-Geladeira-S-b-s-511L-cor-Inox-MD-RS710FGD461-Frente.jpg',
  'https://www.midea.com.br/geladeira-side-by-side-511l-inox/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-REF-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Geladeira Duplex 347L SmartSensor Midea',
  'MIDEA-REF-002',
  'Geladeira duplex frost free 347L, SmartSensor, desodorizador Active-C Fresh, painel touch.',
  3099.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Refrigeração' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167966/1.geladeira-frost-free-smartsensor-347l-cor-prata-midea-MD-RT468MTA501.MD-RT468MTA502-Frente.jpg',
  'https://www.midea.com.br/geladeira-duplex-347l-smartsensor/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-REF-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Frigobar 124L Inverter Bivolt Preto Midea',
  'MIDEA-REF-003',
  'Frigobar 124L inverter bivolt, preto, compartimento extra frio, gaveta organizadora.',
  1249.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Refrigeração' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/175698/01-Frigobar-Inverter-Bivolt-124L-Preto-Midea-MDRD181FGD303-Frontal.jpg',
  'https://www.midea.com.br/frigobar-124l-inverter-bivolt-preto/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-REF-003');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Freezer Horizontal 100L FlexBeer Preto Midea',
  'MIDEA-REF-004',
  'Freezer horizontal 100L FlexBeer, preto, inverter, painel digital, super freezer.',
  1499.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Refrigeração' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/175258/02_Freezer_MDRC151FZD303_Frontal_Porta-Fechada.jpg',
  'https://www.midea.com.br/freezer-horizontal-100l-flexbeer-preto/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-REF-004');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Freezer Horizontal 145L 3 em 1 Branco Midea',
  'MIDEA-REF-005',
  'Freezer horizontal 145L, 3 em 1, branco, 10 anos garantia compressor, termostato externo.',
  1749.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Refrigeração' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/168032/1.freezer-horizontal-3-em-1-branco-145l-midea-MDRC207SLA011.MDRC207SLA012-Frente-fechada.jpg',
  'https://www.midea.com.br/freezer-horizontal-145l-3-em-1-branco/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-REF-005');

-- ============================================================
-- PARTE 4: LAVANDERIA MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Lava e Seca 10,5kg Branca Conectada Midea',
  'MIDEA-LAV-001',
  'Lava e seca 10,5kg, branca, motor inverter quattro, 14 programas, HealthGuard, painel touch, Wi-Fi.',
  3299.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Lavanderia' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/163662/01.Lava-e-secaHG-MF200D105WB-WK-01.MF200D105WB-WK-02-Frente.jpg',
  'https://www.midea.com.br/lava-e-seca-10-5kg-branca-conectada/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-LAV-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Lava e Seca 10,5kg Titanium Conectada Midea',
  'MIDEA-LAV-002',
  'Lava e seca 10,5kg, titanium, motor inverter quattro, 14 programas, HealthGuard, conectividade Wi-Fi.',
  3499.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Lavanderia' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/178584/MF200D105WBGK01MF200D105WBGK0201.jpg',
  'https://www.midea.com.br/lava-e-seca-10-5kg-titanium-conectada/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-LAV-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Lava e Seca 11kg Slim HealthGuard Titanium Midea',
  'MIDEA-LAV-003',
  'Lava e seca 11kg, slim, HealthGuard, titanium, design compacto, SmartHome, função turbo.',
  3699.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Lavanderia' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/172988/01-Lavadora_titanium-01_Botao-frente.jpg',
  'https://www.midea.com.br/lava-e-seca-11kg-slim-healthguard/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-LAV-003');

-- ============================================================
-- PARTE 5: LAVA-LOUÇAS MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Lava-louças 14 Serviços Preta Midea',
  'MIDEA-LL-001',
  'Lava-louças 14 serviços, preta, pré-lavagem, programa ECO, programa intensivo.',
  3099.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/178978/01-Lava-Loucas-Midea-14-Servicos-Preta-DWA14P1.DWA14P2-Frente.jpg',
  'https://www.midea.com.br/lava-loucas-14-servicos-preta/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-LL-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Lava-louças 8 Serviços Preta Midea',
  'MIDEA-LL-002',
  'Lava-louças 8 serviços, preta, pré-lavagem, programa ECO, intensivo até 70°C.',
  2099.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/172576/02.Lava-Loucas-Midea-8-Servicos--Preta-DWA08P1.DWA08P2-Frente.jpg',
  'https://www.midea.com.br/lava-loucas-8-servicos-preta/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-LL-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Lava-louças 8 Serviços Cinza Touch Midea',
  'MIDEA-LL-003',
  'Lava-louças 8 serviços, cinza, painel full touch, função compras, secagem extra, programa rápido.',
  2314.74,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/178630/MDWTF08B101.jpg',
  'https://www.midea.com.br/lava-loucas-8-servicos-cinza-touch/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-LL-003');

-- ============================================================
-- PARTE 6: COOKTOPS MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 4 Bocas Indução Even Pro Midea',
  'MIDEA-COOK-001',
  'Cooktop 4 bocas de indução Even Pro, potência ajustável, timer, trava de segurança.',
  1499.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171021/01-Cooktop-CYC40P2-FRONTAL.jpg',
  'https://www.midea.com.br/cooktop-4-bocas-inducao-even-pro/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 4 Bocas Elétrico Vitrocerâmico Midea',
  'MIDEA-COOK-002',
  'Cooktop 4 bocas elétrico vitrocerâmico, superfície fácil de limpar, controle touch.',
  999.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171075/01-Cooktop-CCB40P2-FRONTAL.jpg',
  'https://www.midea.com.br/cooktop-4-bocas-eletrico-vitroceramico/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 2 Bocas Elétrico Vitrocerâmico Midea',
  'MIDEA-COOK-003',
  'Cooktop 2 bocas elétrico vitrocerâmico, compacto, ideal para espaços pequenos.',
  735.79,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171063/01-Cooktop-CCB20P2-FRONTAL.jpg',
  'https://www.midea.com.br/cooktop-2-bocas-eletrico-vitroceramico/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-003');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 1 Boca Indução Portátil Even Pro Midea',
  'MIDEA-COOK-004',
  'Cooktop portátil 1 boca de indução Even Pro, 127V ou 220V, compacto e prático.',
  299.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171035/01-Cooktop-CYDJ11.CYDJ12-frente.jpg',
  'https://www.midea.com.br/cooktop-1-boca-inducao-portatil/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-004');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 4 Bocas Indução 77cm Freezone Even Pro Midea',
  'MIDEA-COOK-005',
  'Cooktop 4 bocas indução 77cm Freezone Even Pro, zona flexível de cozimento.',
  2599.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177634/01-Cooktop-4-Bocas-de-Inducao-77cm-Freezone-Even-Pro-Frente.jpg',
  'https://www.midea.com.br/cooktop-4-bocas-inducao-77cm-freezone/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-005');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 2 Bocas Indução Freezone Midea',
  'MIDEA-COOK-006',
  'Cooktop 2 bocas indução Freezone, zona flexível, compacto.',
  899.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171255/Frontal---Cooktop---CFBD22.jpg',
  'https://www.midea.com.br/cooktop-2-bocas-inducao-freezone/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-006');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 5 Bocas a Gás Inox Midea',
  'MIDEA-COOK-007',
  'Cooktop 5 bocas a gás, inox, trempes de ferro fundido, acendimento automático.',
  1199.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/168316/01.Cooktop-Inox-5-bocas-CYB5B-Frente-Cima.jpg',
  'https://www.midea.com.br/cooktop-5-bocas-gas-inox/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-007');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Cooktop 4 Bocas a Gás Inox Midea',
  'MIDEA-COOK-008',
  'Cooktop 4 bocas a gás, inox, trempes de ferro fundido, acendimento automático.',
  1051.58,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/168351/01.Cooktop-Inox-4-Bocas-CYB4B-Cima-V1.jpg',
  'https://www.midea.com.br/cooktop-4-bocas-gas-inox/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COOK-008');

-- ============================================================
-- PARTE 7: COIFAS MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Coifa de Parede 60cm Smart Pro Touch Midea',
  'MIDEA-COIFA-001',
  'Coifa de parede 60cm, Smart Pro Touch, iluminação LED, 3 velocidades.',
  1699.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171541/01-Coifa-de-Parede-60cm-Smart-Pro-Touch-Midea-MH60M77AT22MW1-Frente.jpg',
  'https://www.midea.com.br/coifa-parede-60cm-smart-pro-touch/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COIFA-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Coifa de Parede 90cm Black Inox Midea',
  'MIDEA-COIFA-002',
  'Coifa de parede 90cm, black inox, design premium, iluminação LED.',
  2399.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177019/01-Coifa-de-Parede-90cm-Black-Inox-Midea-Frente.jpg',
  'https://www.midea.com.br/coifa-parede-90cm-black-inox/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COIFA-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Coifa de Ilha 90cm Smart Pro Touch Midea',
  'MIDEA-COIFA-003',
  'Coifa de ilha 90cm, Smart Pro Touch, design moderno, iluminação LED.',
  3399.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177723/01-Coifa-de-Ilha-90cm-Smart-Pro-Touch-Midea-Frente.jpg',
  'https://www.midea.com.br/coifa-ilha-90cm-smart-pro-touch/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-COIFA-003');

-- ============================================================
-- PARTE 8: MICRO-ONDAS MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas de Embutir 35L Preto Midea',
  'MIDEA-MW-001',
  'Micro-ondas de embutir 35L, preto, design integrado, funções pré-programadas.',
  1499.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177181/01-Micro-ondas-de-Embutir-35L-Preto-Midea-MGB35M-Frente.jpg',
  'https://www.midea.com.br/micro-ondas-embutir-35l-preto/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 35L Branco SmartPlate Midea',
  'MIDEA-MW-002',
  'Micro-ondas 35L, branco, porta preta, SmartPlate para descongelamento uniforme.',
  635.55,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167795/1.microondas-35l-branco-porta-preta-smartplate-midea-MXSA35P1.MXSA35P2-Superior.jpg',
  'https://www.midea.com.br/micro-ondas-35l-branco-smartplate/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 35L Prata SmartPlate Midea',
  'MIDEA-MW-003',
  'Micro-ondas 35L, prata, porta espelhada, SmartPlate.',
  664.05,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167849/1.microondas-35l-prata-porta-espelhada-smartplate-midea-MXSA35S1.MXSA35S2-Superior.jpg',
  'https://www.midea.com.br/micro-ondas-35l-prata-smartplate/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-003');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 27L Branco SmartPlate Midea',
  'MIDEA-MW-004',
  'Micro-ondas 27L, branco, porta preta, SmartPlate.',
  588.05,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/167713/1.microondas-27l-branco-porta-preta-smartplate-midea-MXSA27P1.MXSA27P2-Superior.jpg',
  'https://www.midea.com.br/micro-ondas-27l-branco-smartplate/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-004');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 20L Branco MasterCook Midea',
  'MIDEA-MW-005',
  'Micro-ondas 20L, branco, MasterCook, compacto, ideal para espaços pequenos.',
  569.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177153/01_Micro-ondas-branco_MHP20B_Frontal.jpg',
  'https://www.midea.com.br/micro-ondas-20l-branco-mastercook/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-005');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 20L Preto MasterCook Midea',
  'MIDEA-MW-006',
  'Micro-ondas 20L, preto, MasterCook, design moderno.',
  569.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177250/01_Micro-ondas-preto_MHP20P_Frontal.jpg',
  'https://www.midea.com.br/micro-ondas-20l-preto-mastercook/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-006');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 20L Prata MasterCook Midea',
  'MIDEA-MW-007',
  'Micro-ondas 20L, prata, porta espelhada, MasterCook.',
  589.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/178869/01-Micro-ondas-20L-Prata-Porta-Espelhada-MasterCook-MHP20S1.MHP20S2-Frente.jpg',
  'https://www.midea.com.br/micro-ondas-20l-prata-mastercook/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-007');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Micro-ondas 35L Branco MasterCook Midea',
  'MIDEA-MW-008',
  'Micro-ondas 35L, branco, MasterCook, grande capacidade.',
  769.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Cozinha Eletrodomésticos' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/177387/01_Micro-ondas-branco_MPH35B_Frontal.jpg',
  'https://www.midea.com.br/micro-ondas-35l-branco-mastercook/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-MW-008');

-- ============================================================
-- PARTE 9: ELETROPORTÁTEIS MIDEA
-- ============================================================

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Fritadeira Air Fryer 5,5L Widemax Midea',
  'MIDEA-AF-001',
  'Air Fryer 5,5L Widemax, 1900W, antiaderente BlackStone, timer, controle de temperatura.',
  379.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/173066/01-Air-Fryer-5-5L-Widemax-Midea-Frente.jpg',
  'https://www.midea.com.br/air-fryer-5-5l-widemax/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AF-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Fritadeira Air Fryer 6L Smart Chef Pro Midea',
  'MIDEA-AF-002',
  'Air Fryer 6L Smart Chef Pro, duplo aquecimento, conectado via app, receitas inteligentes.',
  550.05,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/170003/01-Air-Fryer-6L-Smart-Chef-Pro-Midea-Frente.jpg',
  'https://www.midea.com.br/air-fryer-6l-smart-chef-pro/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-AF-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Panela de Pressão Elétrica 5L NutriPro Inox Midea',
  'MIDEA-PP-001',
  'Panela de pressão elétrica 5L NutriPro, inox, 9 dispositivos de segurança, função Nutri-Pro.',
  429.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/173182/01-Panela-de-Pressao-5L-NutriPro-Inox-Midea-Frente.jpg',
  'https://www.midea.com.br/panela-pressao-eletrica-5l-nutripro/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-PP-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Panela de Pressão Elétrica 6L Mecânica Midea',
  'MIDEA-PP-002',
  'Panela de pressão elétrica 6L, mecânica, 4 funções, 8 dispositivos de segurança.',
  426.75,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/156648/01.Panela-de-pressao-mecanica-6L-Midea-MY-CS6004W-Vista-Superior.jpg',
  'https://www.midea.com.br/panela-pressao-eletrica-6l-mecanica/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-PP-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Chaleira Elétrica Double Wall 1,7L Midea',
  'MIDEA-CH-001',
  'Chaleira elétrica 1,7L, Double Wall, 1500W, isolamento térmico, desligamento automático.',
  149.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/172010/01-Chaleira-Double-Wall-1-7L-Midea-Frente.jpg',
  'https://www.midea.com.br/chaleira-eletrica-double-wall-1-7l/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-CH-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Chaleira Elétrica Glass 1,8L Top Fill Midea',
  'MIDEA-CH-002',
  'Chaleira elétrica 1,8L, vidro, 1850W, recarga superior, iluminação LED.',
  149.00,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/171968/01-Chaleira-Glass-1-8L-Top-Fill-Midea-Frente.jpg',
  'https://www.midea.com.br/chaleira-eletrica-glass-1-8l/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-CH-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Aspirador de Pó PowerDust Vertical Midea',
  'MIDEA-ASP-001',
  'Aspirador de pó vertical PowerDust, 12.000 Pa de sucção, sem fio, bateria de longa duração.',
  498.75,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/156812/01.Aspirador-vertical-powerdust-midea-VSJ20A1-Vista-Frontal.jpg',
  'https://www.midea.com.br/aspirador-po-powerdust-vertical/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-ASP-001');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Aspirador de Pó 2 em 1 Midea',
  'MIDEA-ASP-002',
  'Aspirador de pó 2 em 1, 1350W, filtro HEPA, função vertical e portátil.',
  189.05,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/175360/01-Aspirador-2-em-1-Midea-Frente.jpg',
  'https://www.midea.com.br/aspirador-po-2-em-1/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-ASP-002');

INSERT INTO pricelist_itens (nome, codigo, descricao, preco, unidade, fabricante, categoria_id, imagem_url, link_produto, ativo)
SELECT
  'Robô Aspirador SmartMop Midea',
  'MIDEA-ASP-003',
  'Robô aspirador SmartMop, aspira e passa pano, 100 min de autonomia, mapeamento inteligente.',
  1300.55,
  'un',
  'Midea',
  (SELECT id FROM pricelist_categorias WHERE nome = 'Eletroportáteis' LIMIT 1),
  'https://mideabr.vtexassets.com/arquivos/ids/168180/1.robo-aspirador-smartmop-midea-VCR20W.VCR20B-Vista-Superior.jpg',
  'https://www.midea.com.br/robo-aspirador-smartmop/p',
  true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_itens WHERE codigo = 'MIDEA-ASP-003');

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
DECLARE
  v_total_midea INT;
  v_categorias INT;
BEGIN
  SELECT COUNT(*) INTO v_total_midea FROM pricelist_itens WHERE codigo LIKE 'MIDEA-%';
  SELECT COUNT(DISTINCT categoria_id) INTO v_categorias FROM pricelist_itens WHERE codigo LIKE 'MIDEA-%';

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'IMPORTAÇÃO MIDEA - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de produtos Midea importados: %', v_total_midea;
  RAISE NOTICE 'Categorias utilizadas: %', v_categorias;
  RAISE NOTICE '============================================================';
END $$;

-- Listar todos os produtos Midea importados
SELECT
  codigo,
  LEFT(nome, 50) as nome,
  preco,
  unidade
FROM pricelist_itens
WHERE codigo LIKE 'MIDEA-%'
ORDER BY codigo;
