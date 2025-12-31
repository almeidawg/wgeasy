-- =====================================================
-- WNO MAS - SCRIPT COMPLETO PARA HOSTINGER
-- Execute este arquivo no phpMyAdmin
-- =====================================================

-- =====================================================
-- PARTE 1: ESTRUTURA DO BANCO
-- =====================================================

-- CATEGORIAS
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO categorias (nome, descricao) VALUES
('Tinto', 'Vinhos tintos'),
('Branco', 'Vinhos brancos'),
('Espumante', 'Espumantes e champagnes'),
('Rosé', 'Vinhos rosés');

-- PAÍSES
CREATE TABLE IF NOT EXISTS paises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO paises (nome, codigo) VALUES
('Argentina', 'ARG'),
('Brasil', 'BRA'),
('Chile', 'CHL'),
('Espanha', 'ESP'),
('França', 'FRA'),
('Itália', 'ITA'),
('Portugal', 'PRT');

-- REGIÕES
CREATE TABLE IF NOT EXISTS regioes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    pais_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pais_id) REFERENCES paises(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO regioes (nome, pais_id) VALUES
('Mendoza', 1),
('Luján de Cuyo', 1),
('Valle de Uco', 1),
('Serra Gaúcha', 2),
('Vale dos Vinhedos', 2),
('Cava', 4),
('Bordeaux', 5),
('Champagne', 5);

-- UVAS
CREATE TABLE IF NOT EXISTS uvas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('Tinta', 'Branca') NOT NULL,
    descricao TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO uvas (nome, tipo, descricao) VALUES
('Malbec', 'Tinta', 'Uva emblemática da Argentina'),
('Cabernet Sauvignon', 'Tinta', 'Uma das uvas tintas mais populares do mundo'),
('Merlot', 'Tinta', 'Uva tinta suave e frutada'),
('Cabernet Franc', 'Tinta', 'Uva elegante com notas herbáceas'),
('Petit Verdot', 'Tinta', 'Uva intensa usada em blends'),
('Pinot Noir', 'Tinta', 'Uva delicada e aromática'),
('Chardonnay', 'Branca', 'Uva branca versátil'),
('Sauvignon Blanc', 'Branca', 'Uva branca fresca e cítrica'),
('Macabeo', 'Branca', 'Uva espanhola para espumantes'),
('Xarel-lo', 'Branca', 'Uva catalã para Cava'),
('Parellada', 'Branca', 'Uva aromática da Catalunha');

-- FORNECEDORES
CREATE TABLE IF NOT EXISTS fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cnpj VARCHAR(20),
    email VARCHAR(150),
    telefone VARCHAR(20),
    endereco TEXT,
    contato_nome VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- VINHOS
CREATE TABLE IF NOT EXISTS vinhos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL UNIQUE,
    categoria_id INT,
    regiao_id INT,
    safra YEAR,
    descricao TEXT,
    descricao_curta VARCHAR(500),
    nota_wno_mas TEXT,
    teor_alcoolico DECIMAL(4,2),
    temperatura_servir VARCHAR(20),
    potencial_guarda VARCHAR(50),
    corpo ENUM('Leve', 'Médio', 'Encorpado') DEFAULT 'Médio',
    nivel_corpo INT DEFAULT 3,
    doce_seco ENUM('Seco', 'Meio-seco', 'Meio-doce', 'Doce') DEFAULT 'Seco',
    nivel_doce_seco INT DEFAULT 1,
    custo_base DECIMAL(10,2) NOT NULL,
    margem_lucro DECIMAL(5,2) DEFAULT 50.00,
    preco DECIMAL(10,2) GENERATED ALWAYS AS (custo_base * (1 + margem_lucro/100)) STORED,
    preco_promocional DECIMAL(10,2),
    imagem VARCHAR(255),
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    FOREIGN KEY (regiao_id) REFERENCES regioes(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- VINHO_UVAS (relacionamento N:N)
CREATE TABLE IF NOT EXISTS vinho_uvas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL,
    uva_id INT NOT NULL,
    percentual DECIMAL(5,2) DEFAULT 100.00,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE,
    FOREIGN KEY (uva_id) REFERENCES uvas(id) ON DELETE CASCADE,
    UNIQUE KEY (vinho_id, uva_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ESTOQUE
CREATE TABLE IF NOT EXISTS estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL UNIQUE,
    quantidade INT DEFAULT 0,
    quantidade_minima INT DEFAULT 6,
    localizacao VARCHAR(50) DEFAULT 'A-01',
    ultima_entrada DATE,
    ultima_saida DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- MOVIMENTAÇÕES DE ESTOQUE
CREATE TABLE IF NOT EXISTS movimentacoes_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL,
    tipo ENUM('entrada', 'saida', 'ajuste') NOT NULL,
    quantidade INT NOT NULL,
    quantidade_anterior INT NOT NULL,
    quantidade_posterior INT NOT NULL,
    motivo VARCHAR(255),
    usuario VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- HARMONIZAÇÕES
CREATE TABLE IF NOT EXISTS harmonizacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    icone VARCHAR(50),
    categoria ENUM('Carnes', 'Queijos', 'Massas', 'Frutos do Mar', 'Sobremesas', 'Outros') DEFAULT 'Outros',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO harmonizacoes (nome, icone, categoria) VALUES
('Carnes Vermelhas', 'beef', 'Carnes'),
('Carnes Grelhadas', 'grill', 'Carnes'),
('Cordeiro', 'lamb', 'Carnes'),
('Aves', 'chicken', 'Carnes'),
('Frutos do Mar', 'seafood', 'Frutos do Mar'),
('Peixes', 'fish', 'Frutos do Mar'),
('Massas', 'pasta', 'Massas'),
('Queijos', 'cheese', 'Queijos'),
('Queijos Curados', 'aged-cheese', 'Queijos'),
('Sobremesas', 'dessert', 'Sobremesas'),
('Aperitivos', 'appetizer', 'Outros'),
('Saladas', 'salad', 'Outros');

-- VINHO_HARMONIZACOES
CREATE TABLE IF NOT EXISTS vinho_harmonizacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL,
    harmonizacao_id INT NOT NULL,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE,
    FOREIGN KEY (harmonizacao_id) REFERENCES harmonizacoes(id) ON DELETE CASCADE,
    UNIQUE KEY (vinho_id, harmonizacao_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- CLIENTES
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    cpf VARCHAR(14),
    cep VARCHAR(10),
    endereco VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    preferencia_vinho VARCHAR(50) DEFAULT 'Todos',
    aceita_marketing BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- PEDIDOS
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    cliente_id INT,
    subtotal DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0,
    frete DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('pendente', 'confirmado', 'preparando', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',
    forma_pagamento VARCHAR(50),
    status_pagamento ENUM('pendente', 'aprovado', 'recusado', 'estornado') DEFAULT 'pendente',
    endereco_entrega TEXT,
    data_envio DATE,
    data_entrega DATE,
    codigo_rastreio VARCHAR(50),
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ITENS DO PEDIDO
CREATE TABLE IF NOT EXISTS pedido_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    vinho_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- KITS
CREATE TABLE IF NOT EXISTS kits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    slug VARCHAR(200) NOT NULL UNIQUE,
    descricao TEXT,
    desconto_percentual DECIMAL(5,2) DEFAULT 10.00,
    imagem VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- KIT_VINHOS
CREATE TABLE IF NOT EXISTS kit_vinhos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kit_id INT NOT NULL,
    vinho_id INT NOT NULL,
    quantidade INT DEFAULT 1,
    FOREIGN KEY (kit_id) REFERENCES kits(id) ON DELETE CASCADE,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- CONFIGURAÇÕES
CREATE TABLE IF NOT EXISTS configuracoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chave VARCHAR(100) NOT NULL UNIQUE,
    valor TEXT,
    tipo ENUM('texto', 'numero', 'booleano', 'json') DEFAULT 'texto',
    descricao VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO configuracoes (chave, valor, tipo, descricao) VALUES
('loja_nome', 'Wno Mas - Vinho & Companhia', 'texto', 'Nome da loja'),
('loja_email', 'contato@wnomas.com.br', 'texto', 'Email principal'),
('loja_telefone', '(11) 99999-9999', 'texto', 'Telefone de contato'),
('frete_gratis_minimo', '350', 'numero', 'Valor mínimo para frete grátis'),
('estoque_alerta', '6', 'numero', 'Quantidade para alerta de estoque baixo');

-- VINHO_FORNECEDOR
CREATE TABLE IF NOT EXISTS vinho_fornecedor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL,
    fornecedor_id INT NOT NULL,
    preco_compra DECIMAL(10,2),
    prazo_entrega INT DEFAULT 7,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(id) ON DELETE CASCADE,
    UNIQUE KEY (vinho_id, fornecedor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- PARTE 2: DADOS DOS VINHOS
-- =====================================================

-- Fornecedores
INSERT INTO fornecedores (nome, email, telefone, contato_nome) VALUES
('Importadora Mistral', 'compras@mistral.com.br', '(11) 3333-1111', 'Carlos Silva'),
('Decanter Importações', 'vendas@decanter.com.br', '(11) 3333-2222', 'Maria Santos'),
('Grand Cru Brasil', 'contato@grandcru.com.br', '(11) 3333-3333', 'João Oliveira');

-- 20 VINHOS COMPLETOS
INSERT INTO vinhos (nome, slug, categoria_id, regiao_id, safra, descricao, descricao_curta, nota_wno_mas, teor_alcoolico, temperatura_servir, potencial_guarda, corpo, nivel_corpo, doce_seco, nivel_doce_seco, custo_base, margem_lucro, destaque) VALUES

-- 1. Don Guerino Reserva Malbec 2021
('Don Guerino Reserva Malbec', 'don-guerino-reserva-malbec', 1, 1, 2021,
'Produzido na região de Mendoza, este Malbec apresenta coloração violeta intensa e aromas de frutas negras maduras, como ameixa e amora, com notas sutis de especiarias e baunilha provenientes do estágio em carvalho.',
'Malbec argentino com frutas negras e especiarias. Ideal para carnes grelhadas.',
'Um Malbec que entrega tudo o que a Argentina promete: intensidade, elegância e aquele final que faz você querer mais uma taça.',
14.0, '16-18°C', '5-8 anos', 'Encorpado', 4, 'Seco', 2, 45.00, 55.00, TRUE),

-- 2. Terrazas Reserva Cabernet Sauvignon 2020
('Terrazas Reserva Cabernet Sauvignon', 'terrazas-reserva-cabernet', 1, 2, 2020,
'Cultivado em vinhedos de altitude em Luján de Cuyo, este Cabernet Sauvignon se destaca por sua estrutura firme e taninos elegantes, com aromas de cassis e pimentão vermelho.',
'Cabernet de altitude com estrutura firme e taninos elegantes.',
'Altitude transforma uvas em poesia. Este Cabernet é prova de que a montanha sabe fazer vinho.',
13.5, '16-18°C', '8-10 anos', 'Encorpado', 5, 'Seco', 1, 52.00, 55.00, TRUE),

-- 3. Catena Zapata Malbec High Mountain Vines 2019
('Catena Zapata High Mountain Malbec', 'catena-zapata-high-mountain', 1, 3, 2019,
'Da lendária vinícola Catena Zapata, este Malbec de altitude expressa toda a complexidade dos vinhedos de alta montanha do Valle de Uco, com notas de violeta, frutas negras e uma mineralidade marcante.',
'Malbec de altitude excepcional, complexo e mineral.',
'Catena Zapata não faz vinhos. Faz experiências. Este aqui é daqueles que você lembra onde estava quando provou.',
14.5, '17-19°C', '10-15 anos', 'Encorpado', 5, 'Seco', 1, 95.00, 50.00, TRUE),

-- 4. Alamos Malbec 2022
('Alamos Malbec', 'alamos-malbec', 1, 1, 2022,
'Vinho acessível e muito prazeroso da linha Alamos, com perfil frutado dominante, taninos macios e ótimo custo-benefício para o dia a dia.',
'Malbec frutado e acessível, perfeito para o dia a dia.',
'Nem todo herói usa capa. Alguns vêm em garrafa e custam menos que uma pizza.',
13.5, '16-18°C', '2-4 anos', 'Médio', 3, 'Seco', 2, 28.00, 60.00, FALSE),

-- 5. Luigi Bosca Malbec DOC 2020
('Luigi Bosca Malbec DOC', 'luigi-bosca-malbec-doc', 1, 2, 2020,
'Um dos poucos Malbecs com denominação de origem controlada da Argentina, produzido pela histórica vinícola Luigi Bosca em Luján de Cuyo.',
'Malbec DOC de vinícola histórica, elegante e complexo.',
'DOC não é só um selo. É uma promessa. Luigi Bosca cumpre há mais de um século.',
14.0, '17-18°C', '6-10 anos', 'Encorpado', 4, 'Seco', 1, 65.00, 50.00, TRUE),

-- 6. Trapiche Broquel Malbec 2021
('Trapiche Broquel Malbec', 'trapiche-broquel-malbec', 1, 1, 2021,
'Da linha premium Broquel da Trapiche, este Malbec passou por carvalho francês e apresenta boa complexidade com notas defumadas e baunilha.',
'Malbec premium com passagem em carvalho francês.',
'Broquel significa escudo. E este vinho protege sua noite de qualquer mediocridade.',
14.0, '16-18°C', '4-6 anos', 'Encorpado', 4, 'Seco', 2, 38.00, 55.00, FALSE),

-- 7. Norton Reserva Malbec 2020
('Norton Reserva Malbec', 'norton-reserva-malbec', 1, 2, 2020,
'Vinícola tradicional de Luján de Cuyo, a Norton produz este Reserva com uvas selecionadas e estágio de 12 meses em carvalho.',
'Reserva clássico com 12 meses de carvalho.',
'Norton é daquelas vinícolas que você pode confiar de olhos fechados. Este Reserva é o motivo.',
14.5, '16-18°C', '5-8 anos', 'Encorpado', 4, 'Seco', 1, 42.00, 55.00, FALSE),

-- 8. El Esteco Old Vines Malbec 2019
('El Esteco Old Vines Malbec', 'el-esteco-old-vines', 1, 1, 2019,
'Produzido com uvas de vinhas velhas, este Malbec oferece concentração excepcional e complexidade que só a idade das videiras pode proporcionar.',
'Vinhas velhas, sabor concentrado e complexo.',
'Vinhas velhas são como avós: têm histórias incríveis pra contar. Só precisa saber ouvir.',
14.5, '17-18°C', '8-12 anos', 'Encorpado', 5, 'Seco', 1, 58.00, 52.00, TRUE),

-- 9. Kaiken Ultra Malbec 2020
('Kaiken Ultra Malbec', 'kaiken-ultra-malbec', 1, 1, 2020,
'Projeto da família Montes do Chile em terras argentinas, o Kaiken Ultra representa a excelência do Malbec com perfil moderno e internacional.',
'Projeto chileno-argentino, moderno e internacional.',
'Quando Chile e Argentina se unem, o vinho transcende fronteiras. Literalmente.',
14.5, '17-18°C', '6-10 anos', 'Encorpado', 4, 'Seco', 1, 55.00, 52.00, FALSE),

-- 10. Zuccardi Serie A Malbec 2021
('Zuccardi Serie A Malbec', 'zuccardi-serie-a-malbec', 1, 3, 2021,
'Da revolucionária vinícola Zuccardi no Valle de Uco, este Malbec da Serie A expressa o terroir único da região com frescor e elegância.',
'Valle de Uco em sua expressão mais pura e fresca.',
'Zuccardi reinventou o vinho argentino. Este é o ingresso para essa revolução.',
14.0, '16-18°C', '4-7 anos', 'Médio', 4, 'Seco', 2, 48.00, 55.00, FALSE),

-- 11. Cave Geisse Brut Rosé
('Cave Geisse Brut Rosé', 'cave-geisse-brut-rose', 3, 4, 2021,
'Espumante brasileiro da prestigiada Cave Geisse, elaborado pelo método tradicional com Pinot Noir da Serra Gaúcha.',
'Espumante brasileiro método tradicional, elegante e refrescante.',
'Brasil fazendo espumante de classe mundial. Cave Geisse é a prova que não precisamos importar bolhas.',
12.5, '6-8°C', '2-3 anos', 'Leve', 2, 'Seco', 2, 65.00, 45.00, TRUE),

-- 12. Miolo Cuvée Tradition Brut
('Miolo Cuvée Tradition Brut', 'miolo-cuvee-tradition', 3, 5, 2022,
'Espumante brasileiro da Miolo, um dos maiores produtores nacionais, com perlage fino e sabor equilibrado.',
'Espumante brasileiro acessível com excelente custo-benefício.',
'Celebrar não precisa custar caro. Miolo entendeu isso muito bem.',
12.0, '6-8°C', '1-2 anos', 'Leve', 2, 'Seco', 3, 32.00, 55.00, FALSE),

-- 13. Codorníu Clasico Brut Cava
('Codorníu Clasico Brut', 'codorniu-clasico-brut', 3, 6, 2022,
'Cava espanhol da tradicional casa Codorníu, a mais antiga produtora de espumantes da Espanha, fundada em 1551.',
'Cava tradicional espanhol, fresco e versátil.',
'1551. Enquanto o Brasil era descoberto, Codorníu já fazia bolhas. Tradição tem gosto.',
11.5, '6-8°C', '1-3 anos', 'Leve', 2, 'Seco', 3, 38.00, 50.00, FALSE),

-- 14. Freixenet Cordon Negro Brut
('Freixenet Cordon Negro', 'freixenet-cordon-negro', 3, 6, 2022,
'Um dos Cavas mais conhecidos do mundo, o Cordon Negro da Freixenet é perfeito para celebrações e aperitivos.',
'Cava popular e confiável para todas as ocasiões.',
'A garrafa preta mais famosa do mundo. Freixenet é sinônimo de celebração.',
11.5, '6-8°C', '1-2 anos', 'Leve', 2, 'Seco', 3, 35.00, 52.00, FALSE),

-- 15. Chandon Brut Argentina
('Chandon Brut', 'chandon-brut-argentina', 3, 1, 2022,
'Espumante da casa Chandon na Argentina, combinando expertise francesa com terroir mendocino.',
'Espumante franco-argentino, elegante e consistente.',
'Chandon é aquele amigo que nunca decepciona. Sempre bem-vindo, sempre delicioso.',
12.5, '6-8°C', '1-3 anos', 'Leve', 2, 'Seco', 2, 45.00, 50.00, FALSE),

-- 16. Rutini Apartado Gran Malbec 2018
('Rutini Apartado Gran Malbec', 'rutini-apartado-gran-malbec', 1, 3, 2018,
'Topo de linha da Rutini, este Gran Malbec é produzido apenas em safras excepcionais com uvas do Valle de Uco.',
'Grande Malbec de safras excepcionais, complexo e longevo.',
'Alguns vinhos são para beber. Este é para contemplar. E depois beber. Com calma.',
15.0, '17-19°C', '15-20 anos', 'Encorpado', 5, 'Seco', 1, 180.00, 45.00, TRUE),

-- 17. Achaval Ferrer Malbec 2020
('Achaval Ferrer Malbec', 'achaval-ferrer-malbec', 1, 1, 2020,
'Vinícola boutique fundada em 1998 que rapidamente se tornou referência em Malbecs de terroir.',
'Boutique Malbec de terroir, intenso e autêntico.',
'Achaval Ferrer prova que tamanho não é documento. Vinícola pequena, vinho gigante.',
14.5, '17-18°C', '8-12 anos', 'Encorpado', 5, 'Seco', 1, 85.00, 48.00, TRUE),

-- 18. Salentein Reserva Malbec 2021
('Salentein Reserva Malbec', 'salentein-reserva-malbec', 1, 3, 2021,
'Do impressionante complexo Salentein no Valle de Uco, este Reserva combina arte, arquitetura e vinificação de excelência.',
'Malbec do Valle de Uco com arte e excelência.',
'Salentein é onde vinho encontra arte. Este Reserva é a tela, a taça é a moldura.',
14.0, '16-18°C', '5-8 anos', 'Encorpado', 4, 'Seco', 2, 52.00, 52.00, FALSE),

-- 19. Susana Balbo Signature Malbec 2020
('Susana Balbo Signature Malbec', 'susana-balbo-signature', 1, 1, 2020,
'Criado pela primeira mulher enóloga da Argentina, este Malbec reflete décadas de experiência e paixão.',
'Malbec autoral da primeira enóloga argentina.',
'Susana Balbo abriu portas. Este vinho é seu legado líquido.',
14.5, '17-18°C', '6-10 anos', 'Encorpado', 4, 'Seco', 1, 62.00, 50.00, FALSE),

-- 20. Colomé Estate Malbec 2020
('Colomé Estate Malbec', 'colome-estate-malbec', 1, 1, 2020,
'Da vinícola mais alta da Argentina em Salta, o Colomé Estate oferece um Malbec único marcado pela altitude extrema.',
'Malbec de altitude extrema, único e mineral.',
'A 3.000 metros, as uvas sofrem. E transformam sofrimento em grandeza.',
14.0, '16-18°C', '8-12 anos', 'Encorpado', 4, 'Seco', 1, 75.00, 48.00, TRUE);

-- =====================================================
-- RELACIONAMENTOS E ESTOQUE
-- =====================================================

-- Relação Vinho-Uvas
INSERT INTO vinho_uvas (vinho_id, uva_id) VALUES
(1, 1), (2, 2), (3, 1), (4, 1), (5, 1),
(6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
(11, 6), (12, 7), (13, 9), (13, 10), (13, 11),
(14, 9), (14, 10), (14, 11), (15, 6), (15, 7),
(16, 1), (17, 1), (18, 1), (19, 1), (20, 1);

-- Estoque inicial
INSERT INTO estoque (vinho_id, quantidade, quantidade_minima, localizacao, ultima_entrada) VALUES
(1, 24, 6, 'A-01', CURDATE()),
(2, 18, 6, 'A-02', CURDATE()),
(3, 12, 4, 'A-03', CURDATE()),
(4, 36, 12, 'B-01', CURDATE()),
(5, 18, 6, 'A-04', CURDATE()),
(6, 24, 6, 'B-02', CURDATE()),
(7, 18, 6, 'B-03', CURDATE()),
(8, 12, 4, 'A-05', CURDATE()),
(9, 18, 6, 'B-04', CURDATE()),
(10, 24, 6, 'B-05', CURDATE()),
(11, 12, 4, 'C-01', CURDATE()),
(12, 36, 12, 'C-02', CURDATE()),
(13, 24, 6, 'C-03', CURDATE()),
(14, 30, 6, 'C-04', CURDATE()),
(15, 24, 6, 'C-05', CURDATE()),
(16, 6, 2, 'D-01', CURDATE()),
(17, 12, 4, 'D-02', CURDATE()),
(18, 18, 6, 'D-03', CURDATE()),
(19, 12, 4, 'D-04', CURDATE()),
(20, 12, 4, 'D-05', CURDATE());

-- Harmonizações dos vinhos
INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id) VALUES
(1, 1), (1, 2), (1, 8), (2, 1), (2, 3), (2, 9),
(3, 1), (3, 3), (3, 9), (4, 1), (4, 7), (4, 8),
(5, 1), (5, 2), (5, 9), (6, 1), (6, 7), (6, 8),
(7, 1), (7, 2), (7, 8), (8, 1), (8, 3), (8, 9),
(9, 1), (9, 2), (9, 8), (10, 1), (10, 7), (10, 8),
(11, 5), (11, 6), (11, 11), (12, 11), (12, 12), (12, 5),
(13, 11), (13, 12), (13, 5), (14, 11), (14, 12), (14, 5),
(15, 11), (15, 5), (15, 6), (16, 1), (16, 3), (16, 9),
(17, 1), (17, 2), (17, 9), (18, 1), (18, 7), (18, 8),
(19, 1), (19, 2), (19, 8), (20, 1), (20, 3), (20, 9);

-- Relacionamento Vinho-Fornecedor
INSERT INTO vinho_fornecedor (vinho_id, fornecedor_id, preco_compra, prazo_entrega) VALUES
(1, 1, 40.00, 7), (2, 1, 48.00, 7), (3, 2, 90.00, 14),
(4, 1, 25.00, 5), (5, 2, 60.00, 10), (6, 1, 35.00, 7),
(7, 1, 38.00, 7), (8, 2, 55.00, 10), (9, 2, 52.00, 10),
(10, 3, 45.00, 7), (11, 3, 60.00, 14), (12, 3, 28.00, 5),
(13, 1, 35.00, 10), (14, 1, 32.00, 10), (15, 2, 42.00, 7),
(16, 2, 170.00, 21), (17, 2, 80.00, 14), (18, 2, 48.00, 10),
(19, 3, 58.00, 10), (20, 3, 70.00, 14);

-- Kits
INSERT INTO kits (nome, slug, descricao, desconto_percentual) VALUES
('Kit Descoberta Argentina', 'kit-descoberta-argentina', 'Três Malbecs para conhecer a diversidade argentina', 12.00),
('Kit Celebração', 'kit-celebracao', 'Espumantes brasileiros e importados para suas festas', 10.00),
('Kit Premium', 'kit-premium', 'Seleção dos melhores rótulos para ocasiões especiais', 8.00);

INSERT INTO kit_vinhos (kit_id, vinho_id, quantidade) VALUES
(1, 1, 1), (1, 4, 1), (1, 5, 1),
(2, 11, 1), (2, 12, 1), (2, 15, 1),
(3, 3, 1), (3, 16, 1), (3, 17, 1);

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX idx_vinhos_categoria ON vinhos(categoria_id);
CREATE INDEX idx_vinhos_slug ON vinhos(slug);
CREATE INDEX idx_vinhos_ativo ON vinhos(ativo);
CREATE INDEX idx_estoque_quantidade ON estoque(quantidade);
CREATE INDEX idx_pedidos_status ON pedidos(status);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_clientes_email ON clientes(email);

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
