-- PARTE 1: TABELAS BASE

-- Categorias de Compras
CREATE TABLE IF NOT EXISTS categorias_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(10) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    etapa_obra VARCHAR(50),
    ordem_execucao INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Produtos Complementares
CREATE TABLE IF NOT EXISTS produtos_complementares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    produto_base VARCHAR(100) NOT NULL,
    categoria_base VARCHAR(50),
    complemento VARCHAR(255) NOT NULL,
    categoria_complemento VARCHAR(50),
    quantidade_por_unidade DECIMAL(10,4) DEFAULT 1,
    unidade_calculo VARCHAR(20),
    tipo VARCHAR(20) DEFAULT 'RECOMENDADO',
    preco_referencia DECIMAL(10,2),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Projetos de Compras
CREATE TABLE IF NOT EXISTS projetos_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    contrato_id UUID,
    cliente_id UUID,
    cliente_nome VARCHAR(255),
    nome VARCHAR(255) NOT NULL,
    endereco TEXT,
    area_total DECIMAL(10,2),
    tipo_projeto VARCHAR(50),
    status VARCHAR(50) DEFAULT 'EM_ANDAMENTO',
    data_inicio DATE,
    data_previsao DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Quantitativo do Projeto
CREATE TABLE IF NOT EXISTS projeto_quantitativo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) NOT NULL,
    projeto_id UUID REFERENCES projetos_compras(id) ON DELETE CASCADE,
    ambiente VARCHAR(100) NOT NULL,
    assunto VARCHAR(100) DEFAULT 'ACABAMENTOS E REVESTIMENTOS',
    aplicacao VARCHAR(50),
    descricao_projeto TEXT NOT NULL,
    quantidade_projeto DECIMAL(10,4),
    unidade VARCHAR(20),
    fornecedor VARCHAR(100),
    fabricante VARCHAR(100),
    modelo VARCHAR(255),
    codigo_produto VARCHAR(50),
    quantidade_compra DECIMAL(10,4),
    observacoes TEXT,
    pricelist_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Lista de Compras
CREATE TABLE IF NOT EXISTS projeto_lista_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) NOT NULL,
    projeto_id UUID REFERENCES projetos_compras(id) ON DELETE CASCADE,
    quantitativo_id UUID,
    pricelist_id UUID,
    categoria_id UUID,
    ambiente VARCHAR(100),
    descricao TEXT NOT NULL,
    especificacao TEXT,
    quantidade_projeto DECIMAL(10,4),
    quantidade_compra DECIMAL(10,4),
    unidade VARCHAR(20),
    preco_unitario DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    tipo_compra VARCHAR(20) NOT NULL DEFAULT 'WG_COMPRA',
    tipo_conta VARCHAR(10) NOT NULL DEFAULT 'REAL',
    taxa_fee_percent DECIMAL(5,2) DEFAULT 15,
    valor_fee DECIMAL(10,2) DEFAULT 0,
    fornecedor VARCHAR(100),
    link_produto TEXT,
    status VARCHAR(20) DEFAULT 'PENDENTE',
    data_aprovacao TIMESTAMPTZ,
    data_compra TIMESTAMPTZ,
    data_entrega TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Fluxo Financeiro
CREATE TABLE IF NOT EXISTS fluxo_financeiro_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    projeto_id UUID REFERENCES projetos_compras(id),
    lista_compra_id UUID,
    data_registro DATE DEFAULT CURRENT_DATE,
    cliente_nome VARCHAR(255),
    categoria VARCHAR(100),
    descricao TEXT,
    tipo_compra VARCHAR(20) NOT NULL,
    fornecedor VARCHAR(100),
    valor_bruto DECIMAL(10,2) NOT NULL,
    taxa_fee_percent DECIMAL(5,2) DEFAULT 0,
    valor_fee DECIMAL(10,2) DEFAULT 0,
    valor_liquido DECIMAL(10,2),
    tipo_conta VARCHAR(10) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDENTE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
