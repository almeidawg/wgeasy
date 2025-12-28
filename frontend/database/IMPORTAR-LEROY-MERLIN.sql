-- ==============================================================================
-- IMPORTAÇÃO DE PRODUTOS LEROY MERLIN - MATERIAIS DE CONSTRUÇÃO E REFORMA
-- Gerado automaticamente a partir da planilha de materiais
-- ==============================================================================

-- Verifica ou cria a categoria principal 'Materiais de Construção'
INSERT INTO pricelist_categorias (nome, codigo, tipo, descricao, ordem, ativo)
SELECT 'Materiais de Construção', 'MATCONST', 'produto', 'Materiais para construção e reforma', 2, true
WHERE NOT EXISTS (
  SELECT 1 FROM pricelist_categorias
  WHERE nome = 'Materiais de Construção' AND tipo = 'produto'
);

-- Criar subcategorias

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Aquecedores', 'produto', 1, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Aquecedores'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Automação', 'produto', 2, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Automação'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Automação Inteligente', 'produto', 3, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Automação Inteligente'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Climatização', 'produto', 4, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Climatização'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Construção Civil', 'produto', 5, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Construção Civil'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Eletrodomésticos', 'produto', 6, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Eletrodomésticos'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Eletrônicos', 'produto', 7, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Eletrônicos'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Elétrica', 'produto', 8, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Elétrica'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Hidráulica', 'produto', 9, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Hidráulica'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Iluminação', 'produto', 10, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Iluminação'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Instalação de Gás', 'produto', 11, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Instalação de Gás'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Insumos', 'produto', 12, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Insumos'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Louças e Metais', 'produto', 13, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Louças e Metais'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Pintura', 'produto', 14, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Pintura'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Pisos e Revestimentos', 'produto', 15, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Pisos e Revestimentos'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Proteção de Obra', 'produto', 16, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Proteção de Obra'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Segurança', 'produto', 17, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Segurança'
);

INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
SELECT c.id, 'Vidraçaria', 'produto', 18, true
FROM pricelist_categorias c
WHERE c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
AND NOT EXISTS (
  SELECT 1 FROM pricelist_subcategorias s 
  WHERE s.categoria_id = c.id AND s.nome = 'Vidraçaria'
);


-- ==============================================================================
-- PRODUTOS LEROY MERLIN
-- ==============================================================================


-- Aquecedores (1 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-AR2-0167',
    'Aquecedor Rinnai 27 Litros E27 Feh Glp Prata (digital) + Kit Ligação De 40cm',
    'Aquecedor Rinnai 27 Litros E27 Feh Glp Prata (digital) + Kit Ligação De 40cm',
    'produto',
    'un',
    3649.77,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Aquecedor+Rinnai+27+Litros+E27+Feh+Glp+Prata+digit',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Aquecedores' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Automação (5 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDR-0101',
    'Cabo De Rede Cat6 Cmx Cx 305m Azul Sohoplus',
    'Cabo De Rede Cat6 Cmx Cx 305m Azul Sohoplus',
    'produto',
    'un',
    1219.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cabo+De+Rede+Cat6+Cmx+Cx+305m+Azul+Sohoplus',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FSC-0102',
    'Fio Som Cristal 2x12 -2,50 100m Alum Cobreado',
    'Fio Som Cristal 2x12 -2,50 100m Alum Cobreado',
    'produto',
    'un',
    277.38,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fio+Som+Cristal+2x12+250+100m+Alum+Cobreado',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CC3-0103',
    'Conduíte Corrugado 3/4" 50 Metros',
    'Conduíte Corrugado 3/4" 50 Metros',
    'produto',
    'un',
    28.45,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Condute+Corrugado+34+++++50+Metros',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MMP-0183',
    'MINI MÓDULO PARALELO 1 CANAL',
    'MINI MÓDULO PARALELO 1 CANAL',
    'produto',
    'un',
    110.08,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=MINI+MDULO+PARALELO+1+CANAL',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDE-0184',
    'MONITOR DE ENERGIA INTELIGENTE WIFI 80A',
    'MONITOR DE ENERGIA INTELIGENTE WIFI 80A',
    'produto',
    'un',
    700.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=MONITOR+DE+ENERGIA+INTELIGENTE+WIFI+80A',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Automação Inteligente (14 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IDI-0169',
    'Interruptor Dimmer Inteligente',
    'Interruptor Dimmer Inteligente',
    'produto',
    'un',
    98.88,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Dimmer+Inteligente',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIS-0170',
    'Interruptor Inteligente Série Touch Zigbee/Wi-Fi - 1 Circuito',
    'Interruptor Inteligente Série Touch Zigbee/Wi-Fi - 1 Circuito',
    'produto',
    'un',
    61.80,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Srie+Touch+ZigbeeWiFi++1+C',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIC-0171',
    'Interruptor Inteligente Cortina Persiana Wifi',
    'Interruptor Inteligente Cortina Persiana Wifi',
    'produto',
    'un',
    83.20,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Cortina+Persiana+Wifi',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIS-0172',
    'Interruptor Inteligente Série Touch Zigbee/Wi-Fi - 1 Circuito',
    'Interruptor Inteligente Série Touch Zigbee/Wi-Fi - 1 Circuito',
    'produto',
    'un',
    64.38,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Srie+Touch+ZigbeeWiFi++1+C',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIS-0173',
    'Interruptor Inteligente Série Touch 2.5d Zigbee/Wi-Fi - 2 Circuitos',
    'Interruptor Inteligente Série Touch 2.5d Zigbee/Wi-Fi - 2 Circuitos',
    'produto',
    'un',
    64.38,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Srie+Touch+25d+ZigbeeWiFi+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIT-0174',
    'Interruptor Inteligente Touch Zigbee/Wi-Fi - 4X4 - 4 Circuitos',
    'Interruptor Inteligente Touch Zigbee/Wi-Fi - 4X4 - 4 Circuitos',
    'produto',
    'un',
    94.76,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Touch+ZigbeeWiFi++4X4++4+C',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIS-0175',
    'Interruptor Inteligente Série Touch 2.5d Zigbee/Wi-Fi - 3 Circuitos',
    'Interruptor Inteligente Série Touch 2.5d Zigbee/Wi-Fi - 3 Circuitos',
    'produto',
    'un',
    66.95,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Srie+Touch+25d+ZigbeeWiFi+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIS-0176',
    'Interruptor Inteligente Série Touch - Zigbee/Wi-Fi - 4 Circuitos',
    'Interruptor Inteligente Série Touch - Zigbee/Wi-Fi - 4 Circuitos',
    'produto',
    'un',
    70.81,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Srie+Touch++ZigbeeWiFi++4+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIT-0177',
    'Interruptor Inteligente Touch Zigbee/Wi-Fi - 4X4 - 6 Circuitos',
    'Interruptor Inteligente Touch Zigbee/Wi-Fi - 4X4 - 6 Circuitos',
    'produto',
    'un',
    123.50,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+Touch+ZigbeeWiFi++4X4++6+C',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ICT-0178',
    'Interruptor com Tomada 20A Touch 1 Circuito WIFI',
    'Interruptor com Tomada 20A Touch 1 Circuito WIFI',
    'produto',
    'un',
    96.56,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+com+Tomada+20A+Touch+1+Circuito+WIFI',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ICT-0179',
    'Interruptor Com Tomada 20A Touch - 1Circruito WIFI',
    'Interruptor Com Tomada 20A Touch - 1Circruito WIFI',
    'produto',
    'un',
    103.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Com+Tomada+20A+Touch++1Circruito+WIFI',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ICT-0180',
    'Interruptor Com Tomada 20A Touch - 2 Circruitos WIFI',
    'Interruptor Com Tomada 20A Touch - 2 Circruitos WIFI',
    'produto',
    'un',
    103.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Com+Tomada+20A+Touch++2+Circruitos+WIF',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-IIC-0181',
    'Interruptor Inteligente com 2 Tomadas 4x4 WiFi',
    'Interruptor Inteligente com 2 Tomadas 4x4 WiFi',
    'produto',
    'un',
    128.75,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Interruptor+Inteligente+com+2+Tomadas+4x4+WiFi',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DWU-0182',
    'Double with USB-A+USB-C 16A - Glass',
    'Double with USB-A+USB-C 16A - Glass',
    'produto',
    'un',
    90.64,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Double+with+USBAUSBC+16A++Glass',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Automação Inteligente' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Climatização (1 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ACS-0154',
    'Ar Condicionado Split Rotativo Frio 18000 BTUs 220V TPRO 2.0 Wi Fi TCL',
    'Ar Condicionado Split Rotativo Frio 18000 BTUs 220V TPRO 2.0 Wi Fi TCL',
    'produto',
    'un',
    2978.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Ar+Condicionado+Split+Rotativo+Frio+18000+BTUs+220',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Climatização' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Construção Civil (15 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-API-0010',
    'Argamassa Polimérica Impermeabilizante Viapol Viaplus 5000 Fibras 18kg Cinza',
    'Argamassa Polimérica Impermeabilizante Viapol Viaplus 5000 Fibras 18kg Cinza',
    'produto',
    'un',
    169.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Argamassa+Polimrica+Impermeabilizante+Viapol+Viapl',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-API-0011',
    'Argamassa Polimérica Impermeabilizante Viapol Viaplus 7000 Fibras 18kg Cinza',
    'Argamassa Polimérica Impermeabilizante Viapol Viaplus 7000 Fibras 18kg Cinza',
    'produto',
    'un',
    219.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Argamassa+Polimrica+Impermeabilizante+Viapol+Viapl',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-APC-0012',
    'Aditivo para Chapisco Bianco 18kg Branco Vedacit',
    'Aditivo para Chapisco Bianco 18kg Branco Vedacit',
    'produto',
    'un',
    259.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Aditivo+para+Chapisco+Bianco+18kg+Branco+Vedacit',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-AFS-0013',
    'Areia fina/média saco  20 Kg',
    'Areia fina/média saco  20 Kg',
    'produto',
    'un',
    4.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Areia+finamdia+saco++20+Kg',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PB1-0014',
    'Pedra Britada 1 Saco de 20kg',
    'Pedra Britada 1 Saco de 20kg',
    'produto',
    'un',
    4.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Pedra+Britada+1+Saco+de+20kg',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CCI-0015',
    'Cimento CP II F 32 Todas as Obras 50kg Votoran',
    'Cimento CP II F 32 Todas as Obras 50kg Votoran',
    'produto',
    'un',
    31.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cimento+CP+II+F+32+Todas+as+Obras+50kg+Votoran',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GEP-0016',
    'Gesso em Pó - 40kg',
    'Gesso em Pó - 40kg',
    'produto',
    'un',
    43.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Gesso+em+P++40kg',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-AE5-0017',
    'Argila Expandida - 50 Litros',
    'Argila Expandida - 50 Litros',
    'produto',
    'un',
    37.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Argila+Expandida++50+Litros',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDM-0018',
    'Chapa de Madeira Compensado Resinado 9mm',
    'Chapa de Madeira Compensado Resinado 9mm',
    'produto',
    'un',
    114.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Chapa+de+Madeira+Compensado+Resinado+9mm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDL-0019',
    'Caixa De Luz Quadrada 4x4',
    'Caixa De Luz Quadrada 4x4',
    'produto',
    'un',
    6.89,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Caixa+De+Luz+Quadrada+4x4',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDL-0020',
    'Caixa De Luz Quadrada 4x2',
    'Caixa De Luz Quadrada 4x2',
    'produto',
    'un',
    2.49,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Caixa+De+Luz+Quadrada+4x2',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDL-0021',
    'Caixa De Luz Quadrada 4x2 Drywall',
    'Caixa De Luz Quadrada 4x2 Drywall',
    'produto',
    'un',
    3.49,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Caixa+De+Luz+Quadrada+4x2+Drywall',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TCD-0022',
    'Tijolo Comum de Barro 4,3x9,1x18cm 10 Unidades',
    'Tijolo Comum de Barro 4,3x9,1x18cm 10 Unidades',
    'produto',
    'un',
    0.89,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Tijolo+Comum+de+Barro+43x91x18cm+10+Unidades',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BCV-0023',
    'Bloco Cerâmico Vedação 11,5x14x24cm',
    'Bloco Cerâmico Vedação 11,5x14x24cm',
    'produto',
    'un',
    1.69,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Bloco+Cermico+Vedao+115x14x24cm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-SPE-0024',
    'Sacos para Entulho',
    'Sacos para Entulho',
    'produto',
    'un',
    4.50,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Sacos+para+Entulho',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Construção Civil' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Eletrodomésticos (9 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FB9-0155',
    'Frigobar Branco 93 Litros Midea',
    'Frigobar Branco 93 Litros Midea',
    'produto',
    'un',
    1139.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Frigobar+Branco+93+Litros+Midea',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FB1-0156',
    'Frigobar Branco 124 Litros Midea',
    'Frigobar Branco 124 Litros Midea',
    'produto',
    'un',
    1349.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Frigobar+Branco+124+Litros+Midea',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FBE-0157',
    'Frigobar Black Edition Preto 124 Litros Midea',
    'Frigobar Black Edition Preto 124 Litros Midea',
    'produto',
    'un',
    1139.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Frigobar+Black+Edition+Preto+124+Litros+Midea',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GIF-0158',
    'Geladeira Inverse Frost Free 347L Inverter cor Inox Midea',
    'Geladeira Inverse Frost Free 347L Inverter cor Inox Midea',
    'produto',
    'un',
    2754.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Geladeira+Inverse+Frost+Free+347L+Inverter+cor+Ino',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GIF-0159',
    'Geladeira Inverse Frost Free 416L Inverter cor Inox Midea',
    'Geladeira Inverse Frost Free 416L Inverter cor Inox Midea',
    'produto',
    'un',
    3704.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Geladeira+Inverse+Frost+Free+416L+Inverter+cor+Ino',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GFF-0160',
    'Geladeira Frost Free Duplex 491L Inverter cor Inox Midea',
    'Geladeira Frost Free Duplex 491L Inverter cor Inox Midea',
    'produto',
    'un',
    3894.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Geladeira+Frost+Free+Duplex+491L+Inverter+cor+Inox',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GSB-0161',
    'Geladeira Side by Side 511L Inverter Preta Conectada Midea',
    'Geladeira Side by Side 511L Inverter Preta Conectada Midea',
    'produto',
    'un',
    5081.55,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Geladeira+Side+by+Side+511L+Inverter+Preta+Conecta',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GSB-0162',
    'Geladeira Side by Side 511L Inverter Cor Inox Conectada Midea',
    'Geladeira Side by Side 511L Inverter Cor Inox Conectada Midea',
    'produto',
    'un',
    4599.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Geladeira+Side+by+Side+511L+Inverter+Cor+Inox+Cone',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-GSB-0163',
    'Geladeira Side by Side 570L Dispenser Água e Gelo Inverter cor Inox Midea',
    'Geladeira Side by Side 570L Dispenser Água e Gelo Inverter cor Inox Midea',
    'produto',
    'un',
    8999.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Geladeira+Side+by+Side+570L+Dispenser+gua+e+Gelo+I',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrodomésticos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Eletrônicos (3 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-STS-0164',
    'Smart Tv Samsung 55" Uhd 4k 2024 55du7700',
    'Smart Tv Samsung 55" Uhd 4k 2024 55du7700',
    'produto',
    'un',
    2781.36,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Smart+Tv+Samsung+55+Uhd+4k+2024+55du7700',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrônicos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-STS-0165',
    'Smart Tv Samsung 65" Uhd 4k 2024 55du7700',
    'Smart Tv Samsung 65" Uhd 4k 2024 55du7700',
    'produto',
    'un',
    2781.36,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Smart+Tv+Samsung+65+Uhd+4k+2024+55du7700',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrônicos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-STS-0166',
    'Smart Tv Samsung 75" Uhd 4k 2024 55du7700',
    'Smart Tv Samsung 75" Uhd 4k 2024 55du7700',
    'produto',
    'un',
    2781.36,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Smart+Tv+Samsung+75+Uhd+4k+2024+55du7700',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Eletrônicos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Elétrica (49 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CC3-0052',
    'Conduíte Corrugado 3/4" 50 Metros',
    'Conduíte Corrugado 3/4" 50 Metros',
    'produto',
    'un',
    88.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Condute+Corrugado+34+++++50+Metros',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CC1-0053',
    'Conduíte Corrugado 1"                   25 Metros',
    'Conduíte Corrugado 1"                   25 Metros',
    'produto',
    'un',
    81.75,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Condute+Corrugado+1+++++++++++++++++++25+Metros',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ADC-0054',
    'Abraçadeira D com Cunha para Instalações Hidráulicas e Elétricas 3/4" Aço Zincado',
    'Abraçadeira D com Cunha para Instalações Hidráulicas e Elétricas 3/4" Aço Zincado',
    'produto',
    'un',
    1.60,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Abraadeira+D+com+Cunha+para+Instalaes+Hidrulicas+e',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ADC-0055',
    'Abraçadeira D com Cunha para Instalações Hidráulicas e Elétricas 1/2" Aço Zincado',
    'Abraçadeira D com Cunha para Instalações Hidráulicas e Elétricas 1/2" Aço Zincado',
    'produto',
    'un',
    1.30,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Abraadeira+D+com+Cunha+para+Instalaes+Hidrulicas+e',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FCF-0056',
    'Fio Cabo Flexível Sil 1,5Mm Amarelo Rolo 50 Metros - Ilumnação',
    'Fio Cabo Flexível Sil 1,5Mm Amarelo Rolo 50 Metros - Ilumnação',
    'produto',
    'un',
    139.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fio+Cabo+Flexvel+Sil+15Mm+Amarelo+Rolo+50+Metros++',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FCF-0057',
    'Fio Cabo Flexível Sil 1,5Mm Branco Rolo 50 Metros - Ilumnação',
    'Fio Cabo Flexível Sil 1,5Mm Branco Rolo 50 Metros - Ilumnação',
    'produto',
    'un',
    139.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fio+Cabo+Flexvel+Sil+15Mm+Branco+Rolo+50+Metros++I',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FCF-0058',
    'Fio Cabo Flexível Sil 1,5Mm Amarelo Rolo 100 Metros - Ilumnação',
    'Fio Cabo Flexível Sil 1,5Mm Amarelo Rolo 100 Metros - Ilumnação',
    'produto',
    'un',
    139.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fio+Cabo+Flexvel+Sil+15Mm+Amarelo+Rolo+100+Metros+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FCF-0059',
    'Fio Cabo Flexível Sil 1,5Mm Branco Rolo 100 Metros - Ilumnação',
    'Fio Cabo Flexível Sil 1,5Mm Branco Rolo 100 Metros - Ilumnação',
    'produto',
    'un',
    139.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fio+Cabo+Flexvel+Sil+15Mm+Branco+Rolo+100+Metros++',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CF2-0060',
    'Cabo Flexível 2,5mm 100Metros Azul 750V - Neutro Ilumnação',
    'Cabo Flexível 2,5mm 100Metros Azul 750V - Neutro Ilumnação',
    'produto',
    'un',
    209.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cabo+Flexvel+25mm+100Metros+Azul+750V++Neutro+Ilum',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CF2-0061',
    'Cabo Flexível 2,5mm 100Metros Verde 750V - Terra',
    'Cabo Flexível 2,5mm 100Metros Verde 750V - Terra',
    'produto',
    'un',
    209.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cabo+Flexvel+25mm+100Metros+Verde+750V++Terra',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CF4-0062',
    'Cabo Flexível 4mm 100Metros Preto 750V SIL Fios',
    'Cabo Flexível 4mm 100Metros Preto 750V SIL Fios',
    'produto',
    'un',
    345.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cabo+Flexvel+4mm+100Metros+Preto+750V+SIL+Fios',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CF4-0063',
    'Cabo Flexível 4mm 100Metros Vermelho 750V SIL Fios',
    'Cabo Flexível 4mm 100Metros Vermelho 750V SIL Fios',
    'produto',
    'un',
    345.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cabo+Flexvel+4mm+100Metros+Vermelho+750V+SIL+Fios',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-QDD-0064',
    'Quadro De Distribuição 18/24 + Barramentos Embutir Tigre',
    'Quadro De Distribuição 18/24 + Barramentos Embutir Tigre',
    'produto',
    'un',
    383.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Quadro+De+Distribuio+1824++Barramentos+Embutir+Tig',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDD-0065',
    'Caixa de Distribuição de Embutir com Barramento 27/36 Disjuntores Tigre',
    'Caixa de Distribuição de Embutir com Barramento 27/36 Disjuntores Tigre',
    'produto',
    'un',
    669.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Caixa+de+Distribuio+de+Embutir+com+Barramento+2736',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDT-0066',
    'Disjuntor DR Tripola 63A/30MA Steck',
    'Disjuntor DR Tripola 63A/30MA Steck',
    'produto',
    'un',
    269.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+DR+Tripola+63A30MA+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DM4-0067',
    'DPS Monopolar 45000A Front 275V Clamper',
    'DPS Monopolar 45000A Front 275V Clamper',
    'produto',
    'un',
    59.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=DPS+Monopolar+45000A+Front+275V+Clamper',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDM-0068',
    'Disjuntor Din Monopolar Curva C 16A Steck',
    'Disjuntor Din Monopolar Curva C 16A Steck',
    'produto',
    'un',
    11.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Monopolar+Curva+C+16A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDM-0069',
    'Disjuntor Din Monopolar Curva A 20A Steck',
    'Disjuntor Din Monopolar Curva A 20A Steck',
    'produto',
    'un',
    11.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Monopolar+Curva+A+20A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDM-0070',
    'Disjuntor Din Monopolar Curva A 32A Steck',
    'Disjuntor Din Monopolar Curva A 32A Steck',
    'produto',
    'un',
    11.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Monopolar+Curva+A+32A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDB-0071',
    'Disjuntor Din Bipolar Curva A 16A Steck',
    'Disjuntor Din Bipolar Curva A 16A Steck',
    'produto',
    'un',
    38.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Bipolar+Curva+A+16A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDB-0072',
    'Disjuntor Din Bipolar Curva A 20A Steck',
    'Disjuntor Din Bipolar Curva A 20A Steck',
    'produto',
    'un',
    38.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Bipolar+Curva+A+20A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDB-0073',
    'Disjuntor Din Bipolar Curva C 25A Steck',
    'Disjuntor Din Bipolar Curva C 25A Steck',
    'produto',
    'un',
    44.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Bipolar+Curva+C+25A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDB-0074',
    'Disjuntor Din Bipolar Curva A 32A Steck',
    'Disjuntor Din Bipolar Curva A 32A Steck',
    'produto',
    'un',
    44.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Bipolar+Curva+A+32A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDM-0075',
    'Disjuntor Din Monopolar Curva A 40A Steck',
    'Disjuntor Din Monopolar Curva A 40A Steck',
    'produto',
    'un',
    44.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Monopolar+Curva+A+40A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDB-0076',
    'Disjuntor Din Bipolar Curva C 63A Steck',
    'Disjuntor Din Bipolar Curva C 63A Steck',
    'produto',
    'un',
    51.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disjuntor+Din+Bipolar+Curva+C+63A+Steck',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-SPP-0077',
    'Suporte para Placa 4x2 Horizontal Plus Pial Legrand',
    'Suporte para Placa 4x2 Horizontal Plus Pial Legrand',
    'produto',
    'un',
    4.19,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Suporte+para+Placa+4x2+Horizontal+Plus+Pial+Legran',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-SPP-0078',
    'Suporte para Placa 4x2 Vertical Pial Plus Pial Legrand',
    'Suporte para Placa 4x2 Vertical Pial Plus Pial Legrand',
    'produto',
    'un',
    5.59,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Suporte+para+Placa+4x2+Vertical+Pial+Plus+Pial+Leg',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-SPP-0079',
    'Suporte para Placa 4x4 Pial Plus Pial Legrand',
    'Suporte para Placa 4x4 Pial Plus Pial Legrand',
    'produto',
    'un',
    8.39,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Suporte+para+Placa+4x4+Pial+Plus+Pial+Legrand',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PSS-0080',
    'Placa sem Suporte 4x2 Horizontal 1Módulo Branco Pial Plus Pial Legrand',
    'Placa sem Suporte 4x2 Horizontal 1Módulo Branco Pial Plus Pial Legrand',
    'produto',
    'un',
    11.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+sem+Suporte+4x2+Horizontal+1Mdulo+Branco+Pia',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PSS-0081',
    'Placa sem Suporte 4x2 Vertical 1 Módulo Branco Pial Plus Legrand',
    'Placa sem Suporte 4x2 Vertical 1 Módulo Branco Pial Plus Legrand',
    'produto',
    'un',
    11.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+sem+Suporte+4x2+Vertical+1+Mdulo+Branco+Pial',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PSS-0082',
    'Placa sem Suporte 4x2 2 Módulos Branco Pial Plus Legrand',
    'Placa sem Suporte 4x2 2 Módulos Branco Pial Plus Legrand',
    'produto',
    'un',
    11.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+sem+Suporte+4x2+2+Mdulos+Branco+Pial+Plus+Le',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PSS-0083',
    'Placa sem Suporte 4x2 3 Módulos Branco Pial Plus Legrand',
    'Placa sem Suporte 4x2 3 Módulos Branco Pial Plus Legrand',
    'produto',
    'un',
    11.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+sem+Suporte+4x2+3+Mdulos+Branco+Pial+Plus+Le',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PC4-0084',
    'Placa Cega 4x2 Branco Pial Plus Pial Legrand',
    'Placa Cega 4x2 Branco Pial Plus Pial Legrand',
    'produto',
    'un',
    11.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+Cega+4x2+Branco+Pial+Plus+Pial+Legrand',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PSS-0085',
    'Placa sem Suporte 4x4 2 Módulos Branco Pial Plus Legrand',
    'Placa sem Suporte 4x4 2 Módulos Branco Pial Plus Legrand',
    'produto',
    'un',
    32.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+sem+Suporte+4x4+2+Mdulos+Branco+Pial+Plus+Le',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-P4M-0086',
    'Placa 4 Módulos + Suporte 4x4 - Pial Plus',
    'Placa 4 Módulos + Suporte 4x4 - Pial Plus',
    'produto',
    'un',
    28.14,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+4+Mdulos++Suporte+4x4++Pial+Plus',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-P6M-0087',
    'Placa 6 Módulos 4x4 - Pial Plus',
    'Placa 6 Módulos 4x4 - Pial Plus',
    'produto',
    'un',
    22.46,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+6+Mdulos+4x4++Pial+Plus',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PSS-0088',
    'Placa sem Suporte Cega 4x4 Branco Pial Plus Pial Legrand',
    'Placa sem Suporte Cega 4x4 Branco Pial Plus Pial Legrand',
    'produto',
    'un',
    32.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Placa+sem+Suporte+Cega+4x4+Branco+Pial+Plus+Pial+L',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDI-0089',
    'Módulo de Interruptor Simples 10A Pial Plus Pial Legrand',
    'Módulo de Interruptor Simples 10A Pial Plus Pial Legrand',
    'produto',
    'un',
    19.99,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+de+Interruptor+Simples+10A+Pial+Plus+Pial+Le',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDI-0090',
    'Módulo de Interruptor Paralelo 10A Pial Plus Pial Legrand',
    'Módulo de Interruptor Paralelo 10A Pial Plus Pial Legrand',
    'produto',
    'un',
    29.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+de+Interruptor+Paralelo+10A+Pial+Plus+Pial+L',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDI-0091',
    'Módulo de Interruptor Intermediário 10A Pial Plus Pial Legrand',
    'Módulo de Interruptor Intermediário 10A Pial Plus Pial Legrand',
    'produto',
    'un',
    99.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+de+Interruptor+Intermedirio+10A+Pial+Plus+Pi',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDT-0092',
    'Módulo de Tomada de Energia 10A Pial PlusPial Legrand',
    'Módulo de Tomada de Energia 10A Pial PlusPial Legrand',
    'produto',
    'un',
    21.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+de+Tomada+de+Energia+10A+Pial+PlusPial+Legra',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDT-0093',
    'Módulo de Tomada de Energia 20A Pial PlusPial Legrand',
    'Módulo de Tomada de Energia 20A Pial PlusPial Legrand',
    'produto',
    'un',
    21.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+de+Tomada+de+Energia+20A+Pial+PlusPial+Legra',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDT-0094',
    'Módulo de Tomada de Energia 20A Vermelho Pial PlusPial Legrand',
    'Módulo de Tomada de Energia 20A Vermelho Pial PlusPial Legrand',
    'produto',
    'un',
    21.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+de+Tomada+de+Energia+20A+Vermelho+Pial+PlusP',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-C1T-0095',
    'Conjunto 1 Tomada Energia 10A 4x2 Branco Pial Plus Legrand',
    'Conjunto 1 Tomada Energia 10A 4x2 Branco Pial Plus Legrand',
    'produto',
    'un',
    23.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Conjunto+1+Tomada+Energia+10A+4x2+Branco+Pial+Plus',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-C1T-0096',
    'Conjunto 1 Tomada Energia 20A 4x2 Branco Pial Plus Legrand',
    'Conjunto 1 Tomada Energia 20A 4x2 Branco Pial Plus Legrand',
    'produto',
    'un',
    41.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Conjunto+1+Tomada+Energia+20A+4x2+Branco+Pial+Plus',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-C2T-0097',
    'Conjunto 2 Tomadas Energia 10A 4x2 Branco Pial Plus Legrand',
    'Conjunto 2 Tomadas Energia 10A 4x2 Branco Pial Plus Legrand',
    'produto',
    'un',
    92.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Conjunto+2+Tomadas+Energia+10A+4x2+Branco+Pial+Plu',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-C2I-0098',
    'Conjunto 2 Interruptores Simples - Pial Plus - 612100',
    'Conjunto 2 Interruptores Simples - Pial Plus - 612100',
    'produto',
    'un',
    57.32,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Conjunto+2+Interruptores+Simples++Pial+Plus++61210',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-C1T-0099',
    'Conjunto 1 Tomada e 1 Interruptor Energia Simples 10A 4x2 Branco Pial Plus Legrand',
    'Conjunto 1 Tomada e 1 Interruptor Energia Simples 10A 4x2 Branco Pial Plus Legrand',
    'produto',
    'un',
    69.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Conjunto+1+Tomada+e+1+Interruptor+Energia+Simples+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MDB-0100',
    'Módulo Dimmer Bivolt- Branco - Pial Plus',
    'Módulo Dimmer Bivolt- Branco - Pial Plus',
    'produto',
    'un',
    110.83,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mdulo+Dimmer+Bivolt+Branco++Pial+Plus',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Elétrica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Hidráulica (21 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CMP-0025',
    'Cano Marrom PVC Soldável 25mm ou 3/4" 3m',
    'Cano Marrom PVC Soldável 25mm ou 3/4" 3m',
    'produto',
    'un',
    15.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cano+Marrom+PVC+Soldvel+25mm+ou+34+3m',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-J4M-0026',
    'Joelho 45° Marrom PVC Soldável 25mm ou 3/4"',
    'Joelho 45° Marrom PVC Soldável 25mm ou 3/4"',
    'produto',
    'un',
    2.19,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+45+Marrom+PVC+Soldvel+25mm+ou+34',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-J9M-0027',
    'Joelho 90° Marrom PVC Soldável 25mm ou 3/4"',
    'Joelho 90° Marrom PVC Soldável 25mm ou 3/4"',
    'produto',
    'un',
    1.09,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+90+Marrom+PVC+Soldvel+25mm+ou+34',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-J9C-0028',
    'Joelho 90° com Bucha PVC Azul Roscável e Soldável 3/4x1/2" 25x20mm',
    'Joelho 90° com Bucha PVC Azul Roscável e Soldável 3/4x1/2" 25x20mm',
    'produto',
    'un',
    4.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+90+com+Bucha+PVC+Azul+Roscvel+e+Soldvel+34x',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PPB-0029',
    'Plug PVC Branco Roscável 1/2" 20mm Plastilit',
    'Plug PVC Branco Roscável 1/2" 20mm Plastilit',
    'produto',
    'un',
    0.78,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Plug+PVC+Branco+Roscvel+12+20mm+Plastilit',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PPB-0030',
    'Plug PVC Branco Roscável 3/4" 25mm Plastilit',
    'Plug PVC Branco Roscável 3/4" 25mm Plastilit',
    'produto',
    'un',
    1.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Plug+PVC+Branco+Roscvel+34+25mm+Plastilit',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CPP-0031',
    'Cano PVC para Esgoto 40mm ou 1.1/4" 3m Tigre',
    'Cano PVC para Esgoto 40mm ou 1.1/4" 3m Tigre',
    'produto',
    'un',
    21.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cano+PVC+para+Esgoto+40mm+ou+114+3m+Tigre',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-J4B-0032',
    'Joelho 45° Branco PVC Soldável 40mm',
    'Joelho 45° Branco PVC Soldável 40mm',
    'produto',
    'un',
    2.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+45+Branco+PVC+Soldvel+40mm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-J9B-0033',
    'Joelho 90° Branco PVC Soldável 40mm',
    'Joelho 90° Branco PVC Soldável 40mm',
    'produto',
    'un',
    3.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+90+Branco+PVC+Soldvel+40mm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MF6-0034',
    'Mangueira Flexível 60cm 1/2 Polegada Aço Inox Engate Fêmea X Fêmea Cozinha Banheiro Torneira Pia San',
    'Mangueira Flexível 60cm 1/2 Polegada Aço Inox Engate Fêmea X Fêmea Cozinha Banheiro Torneira Pia Sanitário',
    'produto',
    'un',
    16.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Mangueira+Flexvel+60cm+12+Polegada+Ao+Inox+Engate+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FVR-0035',
    'Fita Veda Rosca 18mmx25m Tigre',
    'Fita Veda Rosca 18mmx25m Tigre',
    'produto',
    'un',
    4.95,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fita+Veda+Rosca+18mmx25m+Tigre',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CPP-0036',
    'Cola para PVC Incolor Frasco 175g Tigre',
    'Cola para PVC Incolor Frasco 175g Tigre',
    'produto',
    'un',
    22.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cola+para+PVC+Incolor+Frasco+175g+Tigre',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CCP-0037',
    'Cano CPVC para Água Quente 22mm ou 3/4" 3m Aquatherm Tigre',
    'Cano CPVC para Água Quente 22mm ou 3/4" 3m Aquatherm Tigre',
    'produto',
    'un',
    63.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cano+CPVC+para+gua+Quente+22mm+ou+34+3m+Aquatherm+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-J9C-0038',
    'Joelho 90° CPVC Liso para Condução de Água Quente 22mm ou 3/4" Aquatherm Tigre',
    'Joelho 90° CPVC Liso para Condução de Água Quente 22mm ou 3/4" Aquatherm Tigre',
    'produto',
    'un',
    3.99,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+90+CPVC+Liso+para+Conduo+de+gua+Quente+22mm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-JDT-0039',
    'Joelho de Transição CPVC Roscável e Liso para Condução de Água Quente 22mm ou 3/4" Aquatherm  Rosca',
    'Joelho de Transição CPVC Roscável e Liso para Condução de Água Quente 22mm ou 3/4" Aquatherm  Rosca 1/2',
    'produto',
    'un',
    11.53,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Joelho+de+Transio+CPVC+Roscvel+e+Liso+para+Conduo+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-T9C-0040',
    'Tê 90° CPVC Liso para Condução de Água Quente 22mm ou 3/4" Aquatherm Tigre',
    'Tê 90° CPVC Liso para Condução de Água Quente 22mm ou 3/4" Aquatherm Tigre',
    'produto',
    'un',
    5.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=T+90+CPVC+Liso+para+Conduo+de+gua+Quente+22mm+ou+3',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TRE-0041',
    'Torneira Registro Esfera Maquina Tanque 1/4 De Volta Torneira Esferica Borboleta Metal',
    'Torneira Registro Esfera Maquina Tanque 1/4 De Volta Torneira Esferica Borboleta Metal',
    'produto',
    'un',
    34.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Torneira+Registro+Esfera+Maquina+Tanque+14+De+Volt',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CPC-0042',
    'Cola para CPVC Frasco 175g Aquatherm Tigre',
    'Cola para CPVC Frasco 175g Aquatherm Tigre',
    'produto',
    'un',
    53.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cola+para+CPVC+Frasco+175g+Aquatherm+Tigre',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-A3C-0043',
    'Abraçadeira 3/4" Cinza',
    'Abraçadeira 3/4" Cinza',
    'produto',
    'un',
    1.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Abraadeira+34+Cinza',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-A1C-0044',
    'Abraçadeira 1/2" Cinza',
    'Abraçadeira 1/2" Cinza',
    'produto',
    'un',
    11.79,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Abraadeira+12+Cinza',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-APB-0045',
    'Abracadeira Pvc Branco Pro 1"',
    'Abracadeira Pvc Branco Pro 1"',
    'produto',
    'un',
    0.72,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Abracadeira+Pvc+Branco+Pro+1',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Hidráulica' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Iluminação (2 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TME-0140',
    'TRILHOS MAGNÉTICOS Embutir  1 METRO VOLTAGEM: 48V NECESSÁRIO FONTE',
    'TRILHOS MAGNÉTICOS Embutir  1 METRO VOLTAGEM: 48V NECESSÁRIO FONTE',
    'produto',
    'un',
    47.79,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=TRILHOS+MAGNTICOS+Embutir++1+METRO+VOLTAGEM+48V+NE',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Iluminação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TOM-0141',
    'TODOS OS MODELOS: COMPRIMENTO: 1 METRO TENSÃO: 48V NECESSÁRIO FONTE',
    'TODOS OS MODELOS: COMPRIMENTO: 1 METRO TENSÃO: 48V NECESSÁRIO FONTE',
    'produto',
    'un',
    43.87,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=TODOS+OS+MODELOS+COMPRIMENTO+1+METRO+TENSO+48V+NEC',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Iluminação' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Instalação de Gás (6 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TP2-0046',
    'Tubo Pex 20mm Para Gás 10 Metros Amanco',
    'Tubo Pex 20mm Para Gás 10 Metros Amanco',
    'produto',
    'un',
    125.32,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Tubo+Pex+20mm+Para+Gs+10+Metros+Amanco',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Instalação de Gás' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-C2M-0047',
    'Cotovelo 20 Mm X 20 Mm Para Tubo Pex 20mm De Gás',
    'Cotovelo 20 Mm X 20 Mm Para Tubo Pex 20mm De Gás',
    'produto',
    'un',
    31.01,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cotovelo+20+Mm+X+20+Mm+Para+Tubo+Pex+20mm+De+Gs',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Instalação de Gás' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-UM1-0048',
    'União Metálica 16 Pex Gás Amanco',
    'União Metálica 16 Pex Gás Amanco',
    'produto',
    'un',
    29.05,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Unio+Metlica+16+Pex+Gs+Amanco',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Instalação de Gás' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CMP-0049',
    'Cotovelo Multicamadas Pex Gás 16mm X 1/2"',
    'Cotovelo Multicamadas Pex Gás 16mm X 1/2"',
    'produto',
    'un',
    31.80,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cotovelo+Multicamadas+Pex+Gs+16mm+X+12',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Instalação de Gás' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CMP-0050',
    'Cotovelo Multicamadas Pex Gás 16mm X 1/2"(f) Com Suporte',
    'Cotovelo Multicamadas Pex Gás 16mm X 1/2"(f) Com Suporte',
    'produto',
    'un',
    45.30,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cotovelo+Multicamadas+Pex+Gs+16mm+X+12f+Com+Suport',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Instalação de Gás' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TM1-0051',
    'Tee Metálico 16 Pex Gás Amanco',
    'Tee Metálico 16 Pex Gás Amanco',
    'produto',
    'un',
    38.15,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Tee+Metlico+16+Pex+Gs+Amanco',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Instalação de Gás' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Insumos (3 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDP-0137',
    'Disco Diamantado para Makita Segmentado Para Concreto E Alvenaria',
    'Disco Diamantado para Makita Segmentado Para Concreto E Alvenaria',
    'produto',
    'un',
    72.38,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disco+Diamantado+para+Makita+Segmentado+Para+Concr',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Insumos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDL-0138',
    'Disco de Lixa para Mármore Grão 50 100mm 4 " 1 unidade G50 Stamaco',
    'Disco de Lixa para Mármore Grão 50 100mm 4 " 1 unidade G50 Stamaco',
    'produto',
    'un',
    24.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disco+de+Lixa+para+Mrmore+Gro+50+100mm+4++1+unidad',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Insumos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DDC-0139',
    'Disco De Corte Fino De Ferro E Aço De Esmerilhadeira 10 Pçs',
    'Disco De Corte Fino De Ferro E Aço De Esmerilhadeira 10 Pçs',
    'produto',
    'un',
    48.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Disco+De+Corte+Fino+De+Ferro+E+Ao+De+Esmerilhadeir',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Insumos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Louças e Metais (12 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CPC-0142',
    'Cuba Pia Cozinha Gourmet Aço Inox 304 Retangular Acabamento Escovado 58x40 Tubrax',
    'Cuba Pia Cozinha Gourmet Aço Inox 304 Retangular Acabamento Escovado 58x40 Tubrax',
    'produto',
    'un',
    396.91,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cuba+Pia+Cozinha+Gourmet+Ao+Inox+304+Retangular+Ac',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CCL-0143',
    'Cuba Cozinha Luxo Gourmet Inox com Acessórios Aquas Tubrax',
    'Cuba Cozinha Luxo Gourmet Inox com Acessórios Aquas Tubrax',
    'produto',
    'un',
    298.41,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cuba+Cozinha+Luxo+Gourmet+Inox+com+Acessrios+Aquas',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-T5X-0144',
    'Tanque 55 X 45 X 22 Cm Aço Inox 304 Com Válvula Tubrax',
    'Tanque 55 X 45 X 22 Cm Aço Inox 304 Com Válvula Tubrax',
    'produto',
    'un',
    284.91,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Tanque+55+X+45+X+22+Cm+Ao+Inox+304+Com+Vlvula+Tubr',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDI-0145',
    'Cuba Dupla Inox com Torneira Gourmet, Dispenser, Lixeira, Cesto, Porta Facas e Acessórios',
    'Cuba Dupla Inox com Torneira Gourmet, Dispenser, Lixeira, Cesto, Porta Facas e Acessórios',
    'produto',
    'un',
    946.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cuba+Dupla+Inox+com+Torneira+Gourmet+Dispenser+Lix',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BLP-0146',
    'Banheiro Luxo Preto Fosco Completo Deca Torneira Petra 1.1/4',
    'Banheiro Luxo Preto Fosco Completo Deca Torneira Petra 1.1/4',
    'produto',
    'un',
    1409.10,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Banheiro+Luxo+Preto+Fosco+Completo+Deca+Torneira+P',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TCM-0147',
    'Torneira Cozinha Monocomando Gourmet Aço Escovado',
    'Torneira Cozinha Monocomando Gourmet Aço Escovado',
    'produto',
    'un',
    259.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Torneira+Cozinha+Monocomando+Gourmet+Ao+Escovado',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-VSM-0148',
    'Vaso Sanitário Monobloco Completo - Caixa Acoplada Privada Acies Tubrax',
    'Vaso Sanitário Monobloco Completo - Caixa Acoplada Privada Acies Tubrax',
    'produto',
    'un',
    746.91,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Vaso+Sanitrio+Monobloco+Completo++Caixa+Acoplada+P',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-DHA-0149',
    'Ducha Higiênica Aço Inox Escovado Com Registro Nox15 Doan',
    'Ducha Higiênica Aço Inox Escovado Com Registro Nox15 Doan',
    'produto',
    'un',
    94.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Ducha+Higinica+Ao+Inox+Escovado+Com+Registro+Nox15',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BLC-0150',
    'Banheiro Luxo Cromada Completo Deca Torneira Quadrada Alta 1.1/4 - Soft Inox',
    'Banheiro Luxo Cromada Completo Deca Torneira Quadrada Alta 1.1/4 - Soft Inox',
    'produto',
    'un',
    1294.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Banheiro+Luxo+Cromada+Completo+Deca+Torneira+Quadr',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CDB-0151',
    'Cuba de Banheiro 40,5cm L73 Deca com Sifão Válvula e Fita Veda-Rosca',
    'Cuba de Banheiro 40,5cm L73 Deca com Sifão Válvula e Fita Veda-Rosca',
    'produto',
    'un',
    791.89,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cuba+de+Banheiro+405cm+L73+Deca+com+Sifo+Vlvula+e+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TMG-0152',
    'Torneira Monocomando Gourmet de Pia para Cozinha com Bica Alta Flexível Preto Fosco Tomas Delinia',
    'Torneira Monocomando Gourmet de Pia para Cozinha com Bica Alta Flexível Preto Fosco Tomas Delinia',
    'produto',
    'un',
    889.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Torneira+Monocomando+Gourmet+de+Pia+para+Cozinha+c',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TMG-0153',
    'Torneira Monocomando Gourmet de Pia para Cozinha com Bica Alta Flexível Inox Escovado Tomas Delinia',
    'Torneira Monocomando Gourmet de Pia para Cozinha com Bica Alta Flexível Inox Escovado Tomas Delinia',
    'produto',
    'un',
    889.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Torneira+Monocomando+Gourmet+de+Pia+para+Cozinha+c',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Louças e Metais' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Pintura (10 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-LP4-0127',
    'Lona Plástica 4x50m Preta',
    'Lona Plástica 4x50m Preta',
    'produto',
    'un',
    164.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Lona+Plstica+4x50m+Preta',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TAT-0128',
    'Tinta Acrílica Toque Premium Fosco Completo Interno e Externo Branco Neve 20L Suvinil',
    'Tinta Acrílica Toque Premium Fosco Completo Interno e Externo Branco Neve 20L Suvinil',
    'produto',
    'un',
    599.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Tinta+Acrlica+Toque+Premium+Fosco+Completo+Interno',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-A0-0129',
    'Aguarrás 0,9L',
    'Aguarrás 0,9L',
    'produto',
    'un',
    24.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Aguarrs+09L',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-MC2-0130',
    'Massa Corrida 25Kg',
    'Massa Corrida 25Kg',
    'produto',
    'un',
    86.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Massa+Corrida+25Kg',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-SAS-0131',
    'Selador Acrílico Suvinil 18L',
    'Selador Acrílico Suvinil 18L',
    'produto',
    'un',
    184.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Selador+Acrlico+Suvinil+18L',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-T9-0132',
    'Thinner 900ml',
    'Thinner 900ml',
    'produto',
    'un',
    22.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Thinner+900ml',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-LMG-0133',
    'Lixa Massa - Grão 180',
    'Lixa Massa - Grão 180',
    'produto',
    'un',
    1.59,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Lixa+Massa++Gro+180',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-LMG-0134',
    'Lixa Massa - Grão 150',
    'Lixa Massa - Grão 150',
    'produto',
    'un',
    1.59,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Lixa+Massa++Gro+150',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-LPM-0135',
    'Lixa para Madeira e Massa Grão 120 225x275cm 1 Unidade',
    'Lixa para Madeira e Massa Grão 120 225x275cm 1 Unidade',
    'produto',
    'un',
    1.79,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Lixa+para+Madeira+e+Massa+Gro+120+225x275cm+1+Unid',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-TES-0136',
    'Tinta Esmalte Sintético Base Solvente Sempre Branco Acetinado 3,6L Suvinil',
    'Tinta Esmalte Sintético Base Solvente Sempre Branco Acetinado 3,6L Suvinil',
    'produto',
    'un',
    179.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Tinta+Esmalte+Sinttico+Base+Solvente+Sempre+Branco',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pintura' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Pisos e Revestimentos (23 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CPA-0104',
    'Cunha Para Azulejo - C/ 100 Peças Niveladora para Piso',
    'Cunha Para Azulejo - C/ 100 Peças Niveladora para Piso',
    'produto',
    'un',
    15.83,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cunha+Para+Azulejo++C+100+Peas+Niveladora+para+Pis',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-EN1-0105',
    'Espaçador Nivelador 1,0mm Smart Cortag Pacote com 100 Unidades',
    'Espaçador Nivelador 1,0mm Smart Cortag Pacote com 100 Unidades',
    'produto',
    'un',
    28.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Espaador+Nivelador+10mm+Smart+Cortag+Pacote+com+10',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-EP1-0106',
    'Espaçador Plástico 1,0mm (Embalagem com 100 peças) Cruszeta',
    'Espaçador Plástico 1,0mm (Embalagem com 100 peças) Cruszeta',
    'produto',
    'un',
    4.61,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Espaador+Plstico+10mm+Embalagem+com+100+peas+Crusz',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-KC1-0107',
    'Kit Com 10 Barras Rodapé Liso 10cmx1,5cmx220cm Mdf Revestido Casablanca 33m Branco',
    'Kit Com 10 Barras Rodapé Liso 10cmx1,5cmx220cm Mdf Revestido Casablanca 33m Branco',
    'produto',
    'un',
    244.20,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Kit+Com+10+Barras+Rodap+Liso+10cmx15cmx220cm+Mdf+R',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-KC1-0108',
    'Kit Com 10 Barras Rodapé De Mdf 15cm X 15mm X 2.20m Revestido Liso Casablanca 22m Branco',
    'Kit Com 10 Barras Rodapé De Mdf 15cm X 15mm X 2.20m Revestido Liso Casablanca 22m Branco',
    'produto',
    'un',
    322.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Kit+Com+10+Barras+Rodap+De+Mdf+15cm+X+15mm+X+220m+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-KC1-0109',
    'Kit Com 10 Barras Rodapé De Mdf 15cm X 15mm X 2.20m Mdf Revestido Frisado Casablanca 22m Branco',
    'Kit Com 10 Barras Rodapé De Mdf 15cm X 15mm X 2.20m Mdf Revestido Frisado Casablanca 22m Branco',
    'produto',
    'un',
    322.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Kit+Com+10+Barras+Rodap+De+Mdf+15cm+X+15mm+X+220m+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-CPR-0110',
    'Cola para Rodapé Balde 5Kg Santa Luzia',
    'Cola para Rodapé Balde 5Kg Santa Luzia',
    'produto',
    'un',
    299.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Cola+para+Rodap+Balde+5Kg+Santa+Luzia',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PLC-0111',
    'Piso Laminado com rodapé de 10 cm',
    'Piso Laminado com rodapé de 10 cm',
    'produto',
    'un',
    295.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Piso+Laminado+com+rodap+de+10+cm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PVC-0112',
    'Piso Vinilico  com rodapé de 10 cm',
    'Piso Vinilico  com rodapé de 10 cm',
    'produto',
    'un',
    295.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Piso+Vinilico++com+rodap+de+10+cm',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PDM-0113',
    'Piso de Madeira Taco 7x45 / 10x40',
    'Piso de Madeira Taco 7x45 / 10x40',
    'produto',
    'un',
    1003.09,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Piso+de+Madeira+Taco+7x45++10x40',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PAD-0114',
    'Piso Assolaho de Madeira 10 / 15 / 20',
    'Piso Assolaho de Madeira 10 / 15 / 20',
    'produto',
    'un',
    1647.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Piso+Assolaho+de+Madeira+10++15++20',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-RIM-0115',
    'Rodapé Invertido, Mod "l", Alumínio Epóxi Preto Fosco , 13 X 30 X 3000 Mm',
    'Rodapé Invertido, Mod "l", Alumínio Epóxi Preto Fosco , 13 X 30 X 3000 Mm',
    'produto',
    'un',
    110.66,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Rodap+Invertido+Mod+l+Alumnio+Epxi+Preto+Fosco++13',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PCA-0116',
    'Porcelanato Cimentício Acetinado Borda Reta Interno 80x80cm Hit Fendi Natural Portobello',
    'Porcelanato Cimentício Acetinado Borda Reta Interno 80x80cm Hit Fendi Natural Portobello',
    'produto',
    'un',
    98.61,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Porcelanato+Cimentcio+Acetinado+Borda+Reta+Interno',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PCN-0117',
    'Porcelanato Cimentício Natural Borda Reta Interno 120x120cm Belgique Clair Portobello',
    'Porcelanato Cimentício Natural Borda Reta Interno 120x120cm Belgique Clair Portobello',
    'produto',
    'un',
    93.91,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Porcelanato+Cimentcio+Natural+Borda+Reta+Interno+1',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PMA-0118',
    'Porcelanato Marmorizado Acetinado Borda Reta Interno 90x90cm Chiaro di Versilia Natural Portobello',
    'Porcelanato Marmorizado Acetinado Borda Reta Interno 90x90cm Chiaro di Versilia Natural Portobello',
    'produto',
    'un',
    108.01,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Porcelanato+Marmorizado+Acetinado+Borda+Reta+Inter',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PCA-0119',
    'Porcelanato Cimentício Acetinado Borda Reta Interno 120x120cm Hit Camel Natural Portobello',
    'Porcelanato Cimentício Acetinado Borda Reta Interno 120x120cm Hit Camel Natural Portobello',
    'produto',
    'un',
    140.91,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Porcelanato+Cimentcio+Acetinado+Borda+Reta+Interno',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PAA-0120',
    'Porcelanato Amadeirado Acetinado Borda Reta Interno 20x120cm Arca Nordic ST Natural Portobello',
    'Porcelanato Amadeirado Acetinado Borda Reta Interno 20x120cm Arca Nordic ST Natural Portobello',
    'produto',
    'un',
    155.01,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Porcelanato+Amadeirado+Acetinado+Borda+Reta+Intern',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PMP-0121',
    'Porcelanato Marmorizado Polido Borda Reta Interno 120x120cm Mare D''Autunno Portobello',
    'Porcelanato Marmorizado Polido Borda Reta Interno 120x120cm Mare D''Autunno Portobello',
    'produto',
    'un',
    338.31,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Porcelanato+Marmorizado+Polido+Borda+Reta+Interno+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-RPP-0122',
    'Rejunte para Porcelanato Cinza Platina 5kg Quartzolit',
    'Rejunte para Porcelanato Cinza Platina 5kg Quartzolit',
    'produto',
    'un',
    71.35,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Rejunte+para+Porcelanato+Cinza+Platina+5kg+Quartzo',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-RAB-0123',
    'Rejunte Acrílico Bege 1 Kg Quartzolit',
    'Rejunte Acrílico Bege 1 Kg Quartzolit',
    'produto',
    'un',
    43.99,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Rejunte+Acrlico+Bege+1+Kg+Quartzolit',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-REC-0124',
    'Rejunte Epóxi Cinza Claro 1 Kg Axton',
    'Rejunte Epóxi Cinza Claro 1 Kg Axton',
    'produto',
    'un',
    59.10,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Rejunte+Epxi+Cinza+Claro+1+Kg+Axton',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-API-0125',
    'Argamassa Porcelanato Interno 20kg Cinza Fortaleza',
    'Argamassa Porcelanato Interno 20kg Cinza Fortaleza',
    'produto',
    'un',
    26.23,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Argamassa+Porcelanato+Interno+20kg+Cinza+Fortaleza',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-AAI-0126',
    'Argamassa ACIII Interno e Externo 20kg Branco CimentCola Quartzolit',
    'Argamassa ACIII Interno e Externo 20kg Branco CimentCola Quartzolit',
    'produto',
    'un',
    62.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Argamassa+ACIII+Interno+e+Externo+20kg+Branco+Cime',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Pisos e Revestimentos' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Proteção de Obra (9 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PDQ-0001',
    'Protetor de Quina 1,20mx5cm Salva Quina',
    'Protetor de Quina 1,20mx5cm Salva Quina',
    'produto',
    'un',
    12.29,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Protetor+de+Quina+120mx5cm+Salva+Quina',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PDR-0002',
    'Protetor de Ralo e Tubulações 10cm Salva Ralo',
    'Protetor de Ralo e Tubulações 10cm Salva Ralo',
    'produto',
    'un',
    3.89,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Protetor+de+Ralo+e+Tubulaes+10cm+Salva+Ralo',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PDP-0003',
    'Protetor de Piso 25x1m Salva Piso',
    'Protetor de Piso 25x1m Salva Piso',
    'produto',
    'un',
    189.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Protetor+de+Piso+25x1m+Salva+Piso',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PDP-0004',
    'Proteção de Pisos e Bancadas Salva Obra Papelão Reforçado 1,2x25m 300g Salvabras',
    'Proteção de Pisos e Bancadas Salva Obra Papelão Reforçado 1,2x25m 300g Salvabras',
    'produto',
    'un',
    95.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Proteo+de+Pisos+e+Bancadas+Salva+Obra+Papelo+Refor',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BPO-0005',
    'Bobina Papel Ondulado com 50 metros',
    'Bobina Papel Ondulado com 50 metros',
    'produto',
    'un',
    179.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Bobina+Papel+Ondulado+com+50+metros',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-SAD-0006',
    'Saco alvejado de pano',
    'Saco alvejado de pano',
    'produto',
    'un',
    10.99,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Saco+alvejado+de+pano',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FCB-0007',
    'Fita Crepe Branca 48mm x 50m',
    'Fita Crepe Branca 48mm x 50m',
    'produto',
    'un',
    13.95,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fita+Crepe+Branca+48mm+x+50m',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FCB-0008',
    'Fita Crepe Branca 24mm x 50m',
    'Fita Crepe Branca 24mm x 50m',
    'produto',
    'un',
    8.50,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fita+Crepe+Branca+24mm+x+50m',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-VON-0009',
    'Vassoura Original Noviça Concept Bettanin',
    'Vassoura Original Noviça Concept Bettanin',
    'produto',
    'un',
    24.90,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Vassoura+Original+Novia+Concept+Bettanin',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Proteção de Obra' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Segurança (1 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-FED-0168',
    'Fechadura Eletrônica Digital Elsys com Biometria e Senha',
    'Fechadura Eletrônica Digital Elsys com Biometria e Senha',
    'produto',
    'un',
    700.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Fechadura+Eletrnica+Digital+Elsys+com+Biometria+e+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Segurança' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

-- Vidraçaria (13 produtos)
-- ------------------------------------------------------------------------------

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BPB-0185',
    'Box para Banheiro 90x185cm Vidro Incolor Frontal de Abrir 2 Folhas',
    'Box para Banheiro 90x185cm Vidro Incolor Frontal de Abrir 2 Folhas',
    'produto',
    'un',
    1531.81,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Box+para+Banheiro+90x185cm+Vidro+Incolor+Frontal+d',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BPB-0186',
    'Box para Banheiro 130x190cm Vidro Incolor',
    'Box para Banheiro 130x190cm Vidro Incolor',
    'produto',
    'un',
    1531.81,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Box+para+Banheiro+130x190cm+Vidro+Incolor',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-BPB-0187',
    'Box para Banheiro 110x200cm Vidro Incolor Frontal de Correr 2 Folhas',
    'Box para Banheiro 110x200cm Vidro Incolor Frontal de Correr 2 Folhas',
    'produto',
    'un',
    1931.81,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Box+para+Banheiro+110x200cm+Vidro+Incolor+Frontal+',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PT9-0188',
    'Piso Teto -  90x2400 - Vidro Incolor Frontal de Abrir 2 Folhas',
    'Piso Teto -  90x2400 - Vidro Incolor Frontal de Abrir 2 Folhas',
    'produto',
    'un',
    1531.81,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Piso+Teto+++90x2400++Vidro+Incolor+Frontal+de+Abri',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-PT1-0189',
    'Piso Teto - 130x2400 - Vidro Incolor',
    'Piso Teto - 130x2400 - Vidro Incolor',
    'produto',
    'un',
    1531.81,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Piso+Teto++130x2400++Vidro+Incolor',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ECC-0190',
    'Espelho Com Chassi para Led',
    'Espelho Com Chassi para Led',
    'produto',
    'un',
    875.32,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Espelho+Com+Chassi+para+Led',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-E-0191',
    'Espelho',
    'Espelho',
    'produto',
    'un',
    765.91,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Espelho',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-EO-0192',
    'Espelho Orgânico',
    'Espelho Orgânico',
    'produto',
    'un',
    995.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Espelho+Orgnico',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ETE-0193',
    'Espelhos tamanhos Especiais',
    'Espelhos tamanhos Especiais',
    'produto',
    'un',
    875.32,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Espelhos+tamanhos+Especiais',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ES1-0194',
    'Envidraçamento Sacada 10MM - Sistema sem roldana',
    'Envidraçamento Sacada 10MM - Sistema sem roldana',
    'produto',
    'un',
    1750.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Envidraamento+Sacada+10MM++Sistema+sem+roldana',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ES1-0195',
    'Envidraçamento Sacada 10MM - Sistema com roldana',
    'Envidraçamento Sacada 10MM - Sistema com roldana',
    'produto',
    'un',
    1750.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Envidraamento+Sacada+10MM++Sistema+com+roldana',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ES1-0196',
    'Envidraçamento Sacada 12MM - Sistema sem roldana',
    'Envidraçamento Sacada 12MM - Sistema sem roldana',
    'produto',
    'un',
    1950.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Envidraamento+Sacada+12MM++Sistema+sem+roldana',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;

INSERT INTO pricelist_itens (
    subcategoria_id, codigo, nome, descricao, tipo, unidade, 
    preco, fabricante, link_produto, ativo
)
SELECT 
    s.id,
    'LM-ES1-0197',
    'Envidraçamento Sacada 12MM - Sistema com roldana',
    'Envidraçamento Sacada 12MM - Sistema com roldana',
    'produto',
    'un',
    1950.00,
    'Leroy Merlin',
    'https://www.leroymerlin.com.br/busca?term=Envidraamento+Sacada+12MM++Sistema+com+roldana',
    true
FROM pricelist_subcategorias s
JOIN pricelist_categorias c ON s.categoria_id = c.id
WHERE s.nome = 'Vidraçaria' AND c.nome = 'Materiais de Construção' AND c.tipo = 'produto'
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    link_produto = EXCLUDED.link_produto;


-- ==============================================================================
-- VERIFICAÇÃO DA IMPORTAÇÃO
-- ==============================================================================
SELECT 
    'Leroy Merlin' as fabricante,
    COUNT(*) as total_produtos,
    COUNT(CASE WHEN link_produto IS NOT NULL THEN 1 END) as com_link
FROM pricelist_itens 
WHERE fabricante = 'Leroy Merlin';

SELECT 
    s.nome as subcategoria,
    COUNT(*) as produtos
FROM pricelist_itens i
JOIN pricelist_subcategorias s ON i.subcategoria_id = s.id
WHERE i.fabricante = 'Leroy Merlin'
GROUP BY s.nome
ORDER BY produtos DESC;
