-- =====================================================
-- WNO MAS - BANCO DE DADOS COMPLETO
-- Vinho & Companhia
-- =====================================================

-- Criar banco de dados (executar separadamente se necessário)
-- CREATE DATABASE IF NOT EXISTS wnomas_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE wnomas_db;

-- =====================================================
-- TABELA: CATEGORIAS DE VINHOS
-- =====================================================
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

-- =====================================================
-- TABELA: PAÍSES
-- =====================================================
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

-- =====================================================
-- TABELA: REGIÕES
-- =====================================================
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

-- =====================================================
-- TABELA: UVAS
-- =====================================================
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

-- =====================================================
-- TABELA: FORNECEDORES
-- =====================================================
CREATE TABLE IF NOT EXISTS fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cnpj VARCHAR(20),
    email VARCHAR(150),
    telefone VARCHAR(20),
    endereco TEXT,
    cidade VARCHAR(100),
    estado VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO fornecedores (nome, email, telefone, ativo) VALUES
('Catena Zapata', 'contato@catenazapata.com', '(11) 3456-7890', TRUE),
('Mistral', 'vendas@mistral.com.br', '(11) 2345-6789', TRUE),
('Grand Cru', 'compras@grandcru.com.br', '(11) 3456-7891', TRUE),
('Decanter', 'contato@decanter.com.br', '(11) 4567-8901', TRUE),
('Zahil', 'vendas@zahil.com.br', '(11) 5678-9012', TRUE),
('LVMH', 'brazil@lvmh.com', '(11) 6789-0123', TRUE),
('Henkell Freixenet', 'brasil@freixenet.com', '(11) 7890-1234', TRUE);

-- =====================================================
-- TABELA: VINHOS (PRINCIPAL)
-- =====================================================
CREATE TABLE IF NOT EXISTS vinhos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(100) UNIQUE NOT NULL,
    nome VARCHAR(200) NOT NULL,
    categoria_id INT,
    regiao_id INT,
    safra VARCHAR(10),

    -- Características
    corpo ENUM('Leve', 'Médio', 'Encorpado', 'Muito Encorpado') DEFAULT 'Médio',
    acidez ENUM('Baixa', 'Média', 'Alta') DEFAULT 'Média',
    taninos VARCHAR(50),
    teor_alcoolico DECIMAL(4,2),
    temperatura_ideal VARCHAR(20),
    metodo_producao VARCHAR(100),
    potencial_guarda VARCHAR(50),

    -- Descrições
    descricao TEXT,
    nota_wnomas TEXT,
    dica_sommelier TEXT,
    historia_produtor TEXT,

    -- Preços e custos
    custo_base DECIMAL(10,2) NOT NULL,
    margem_percentual DECIMAL(5,2) DEFAULT 40.00,
    preco_venda DECIMAL(10,2),

    -- Imagem
    imagem_url TEXT,

    -- Status
    ativo BOOLEAN DEFAULT TRUE,
    destaque BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    FOREIGN KEY (regiao_id) REFERENCES regioes(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: VINHO_UVAS (RELACIONAMENTO N:N)
-- =====================================================
CREATE TABLE IF NOT EXISTS vinho_uvas (
    vinho_id INT NOT NULL,
    uva_id INT NOT NULL,
    percentual DECIMAL(5,2),
    PRIMARY KEY (vinho_id, uva_id),
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE,
    FOREIGN KEY (uva_id) REFERENCES uvas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: VINHO_FORNECEDORES (RELACIONAMENTO N:N)
-- =====================================================
CREATE TABLE IF NOT EXISTS vinho_fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL,
    fornecedor_id INT NOT NULL,
    custo DECIMAL(10,2),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE,
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: ESTOQUE
-- =====================================================
CREATE TABLE IF NOT EXISTS estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL UNIQUE,
    quantidade INT DEFAULT 0,
    quantidade_minima INT DEFAULT 6,
    localizacao VARCHAR(20),
    ultima_entrada DATE,
    ultima_saida DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: MOVIMENTAÇÕES DE ESTOQUE
-- =====================================================
CREATE TABLE IF NOT EXISTS movimentacoes_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vinho_id INT NOT NULL,
    tipo ENUM('entrada', 'saida', 'ajuste') NOT NULL,
    quantidade INT NOT NULL,
    quantidade_anterior INT,
    quantidade_posterior INT,
    motivo TEXT,
    usuario VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefone VARCHAR(20),
    cpf VARCHAR(14),

    -- Endereço
    cep VARCHAR(10),
    endereco VARCHAR(255),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(2),

    -- Preferências
    preferencia_vinho ENUM('Tinto', 'Branco', 'Espumante', 'Rosé', 'Todos'),
    aceita_marketing BOOLEAN DEFAULT FALSE,

    -- Status
    ativo BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: PEDIDOS
-- =====================================================
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) UNIQUE NOT NULL,
    cliente_id INT,

    -- Valores
    subtotal DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    frete DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,

    -- Status
    status ENUM('pendente', 'confirmado', 'preparando', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',

    -- Pagamento
    forma_pagamento ENUM('pix', 'cartao_credito', 'cartao_debito', 'boleto', 'transferencia'),
    status_pagamento ENUM('pendente', 'aprovado', 'recusado', 'estornado') DEFAULT 'pendente',

    -- Entrega
    endereco_entrega TEXT,
    data_envio DATE,
    data_entrega DATE,
    codigo_rastreio VARCHAR(50),

    observacoes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: ITENS DO PEDIDO
-- =====================================================
CREATE TABLE IF NOT EXISTS pedido_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    vinho_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: KITS/SELEÇÕES
-- =====================================================
CREATE TABLE IF NOT EXISTS kits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2),
    preco_promocional DECIMAL(10,2),
    ativo BOOLEAN DEFAULT TRUE,
    destaque BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO kits (nome, descricao, preco, ativo, destaque) VALUES
('Kit 1 - Começar Bem', 'Seleção ideal para quem está começando no mundo dos vinhos', 299.00, TRUE, TRUE),
('Kit 2 - Jantar em Casa', 'Vinhos perfeitos para acompanhar um jantar especial', 399.00, TRUE, TRUE),
('Kit 3 - Malbecs da Argentina', 'Os melhores Malbecs argentinos em uma seleção exclusiva', 499.00, TRUE, FALSE),
('Kit 4 - Noite Especial', 'Para momentos que merecem vinhos excepcionais', 799.00, TRUE, FALSE);

-- =====================================================
-- TABELA: KIT_VINHOS (RELACIONAMENTO N:N)
-- =====================================================
CREATE TABLE IF NOT EXISTS kit_vinhos (
    kit_id INT NOT NULL,
    vinho_id INT NOT NULL,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (kit_id, vinho_id),
    FOREIGN KEY (kit_id) REFERENCES kits(id) ON DELETE CASCADE,
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: HARMONIZAÇÕES
-- =====================================================
CREATE TABLE IF NOT EXISTS harmonizacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('prato', 'momento') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO harmonizacoes (nome, tipo) VALUES
('Carnes vermelhas', 'prato'),
('Massas', 'prato'),
('Queijos', 'prato'),
('Peixes', 'prato'),
('Frutos do mar', 'prato'),
('Aves', 'prato'),
('Sobremesas', 'prato'),
('Aperitivos', 'prato'),
('Jantares especiais', 'momento'),
('Encontros casuais', 'momento'),
('Celebrações', 'momento'),
('Noites frias', 'momento'),
('Dias quentes', 'momento'),
('Happy hour', 'momento'),
('Almoços leves', 'momento'),
('Comemorações', 'momento');

-- =====================================================
-- TABELA: VINHO_HARMONIZACOES (RELACIONAMENTO N:N)
-- =====================================================
CREATE TABLE IF NOT EXISTS vinho_harmonizacoes (
    vinho_id INT NOT NULL,
    harmonizacao_id INT NOT NULL,
    PRIMARY KEY (vinho_id, harmonizacao_id),
    FOREIGN KEY (vinho_id) REFERENCES vinhos(id) ON DELETE CASCADE,
    FOREIGN KEY (harmonizacao_id) REFERENCES harmonizacoes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- TABELA: CONFIGURAÇÕES DO SISTEMA
-- =====================================================
CREATE TABLE IF NOT EXISTS configuracoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chave VARCHAR(100) UNIQUE NOT NULL,
    valor TEXT,
    descricao VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO configuracoes (chave, valor, descricao) VALUES
('custo_embalagem', '15.00', 'Custo fixo de embalagem por garrafa'),
('custo_frete_base', '5.00', 'Custo base de frete por garrafa'),
('percentual_operacional', '10', 'Percentual de custo operacional'),
('email_contato', 'contato@wnomas.com.br', 'Email de contato principal'),
('telefone_contato', '(11) 99999-9999', 'Telefone de contato'),
('instagram', '@wnomas', 'Instagram da marca'),
('whatsapp', '5511999999999', 'WhatsApp para pedidos');

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

-- View: Vinhos com estoque baixo
CREATE OR REPLACE VIEW vw_estoque_baixo AS
SELECT
    v.id,
    v.nome,
    v.slug,
    e.quantidade,
    e.quantidade_minima,
    e.localizacao
FROM vinhos v
JOIN estoque e ON v.id = e.vinho_id
WHERE e.quantidade <= e.quantidade_minima
AND v.ativo = TRUE;

-- View: Resumo de vendas por vinho
CREATE OR REPLACE VIEW vw_vendas_por_vinho AS
SELECT
    v.id,
    v.nome,
    SUM(pi.quantidade) as total_vendido,
    SUM(pi.subtotal) as faturamento_total,
    COUNT(DISTINCT p.id) as total_pedidos
FROM vinhos v
LEFT JOIN pedido_itens pi ON v.id = pi.vinho_id
LEFT JOIN pedidos p ON pi.pedido_id = p.id AND p.status != 'cancelado'
GROUP BY v.id, v.nome;

-- View: Resumo financeiro por vinho
CREATE OR REPLACE VIEW vw_financeiro_vinhos AS
SELECT
    v.id,
    v.nome,
    v.custo_base,
    v.margem_percentual,
    v.preco_venda,
    (v.preco_venda - (v.custo_base * 1.30)) as lucro_estimado,
    e.quantidade as estoque_atual,
    (e.quantidade * v.custo_base) as valor_estoque
FROM vinhos v
LEFT JOIN estoque e ON v.id = e.vinho_id
WHERE v.ativo = TRUE;

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================
CREATE INDEX idx_vinhos_categoria ON vinhos(categoria_id);
CREATE INDEX idx_vinhos_regiao ON vinhos(regiao_id);
CREATE INDEX idx_vinhos_ativo ON vinhos(ativo);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_status ON pedidos(status);
CREATE INDEX idx_pedidos_data ON pedidos(created_at);
CREATE INDEX idx_clientes_email ON clientes(email);

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
