-- ============================================================================
-- WGEASY - SISTEMA DE WORKFLOW DE COMPRAS
-- Grupo WG Almeida - Schema Completo
-- ============================================================================

-- ============================================================================
-- 1. TABELA DE CATEGORIAS (ETAPAS DE OBRA)
-- ============================================================================

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

-- Dados iniciais de categorias
INSERT INTO categorias_compras (codigo, nome, tipo, etapa_obra, ordem_execucao) VALUES
('PRE', 'PRE OBRA', 'PROTECAO', '1-PREPARACAO', 1),
('CIN', 'MATERIAL CINZA', 'CONSTRUCAO', '2-ESTRUTURA', 10),
('HID', 'HIDRAULICA', 'HIDRAULICO', '3-INFRAESTRUTURA', 20),
('GAS', 'GAS', 'GAS', '3-INFRAESTRUTURA', 25),
('ELE', 'ELETRICA', 'ELETRICO', '3-INFRAESTRUTURA', 30),
('AUT', 'AUTOMACAO', 'AUTOMACAO', '3-INFRAESTRUTURA', 35),
('REV', 'PISOS E PAREDES', 'REVESTIMENTO', '4-REVESTIMENTO', 40),
('PIN', 'PINTURA', 'PINTURA', '4-REVESTIMENTO', 45),
('ILU', 'ILUMINACAO', 'ILUMINACAO', '5-ACABAMENTO', 50),
('TRI', 'TRILHOS MAGNETICOS', 'ILUMINACAO', '5-ACABAMENTO', 51),
('LOU', 'CUBAS, LOUCAS E METAIS', 'LOUCA/METAL', '5-ACABAMENTO', 55),
('INT', 'INTERRUPTORES SMART', 'AUTOMACAO', '5-ACABAMENTO', 60),
('CLI', 'AR CONDICIONADO', 'CLIMATIZACAO', '6-INSTALACOES', 70),
('AQU', 'AQUECEDORES', 'CLIMATIZACAO', '6-INSTALACOES', 71),
('VID', 'VIDRACARIA', 'VIDRO', '6-INSTALACOES', 75),
('ENV', 'ENVIDRACAMENTO SACADA', 'VIDRO', '6-INSTALACOES', 76),
('ELD', 'ELETRODOMESTICOS', 'EQUIPAMENTO', '7-EQUIPAMENTOS', 80),
('ELT', 'ELETRONICOS', 'EQUIPAMENTO', '7-EQUIPAMENTOS', 81),
('SEG', 'SEGURANCA', 'AUTOMACAO', '7-EQUIPAMENTOS', 85),
('FIN', 'FINALIZACOES', 'ACABAMENTO', '8-FINALIZACAO', 90),
('INS', 'INSUMOS', 'INSUMO', 'CONTINUO', 99)
ON CONFLICT (codigo) DO NOTHING;

-- ============================================================================
-- 2. TABELA DE PRODUTOS COMPLEMENTARES (ARGAMASSA, REJUNTE, ETC)
-- ============================================================================

CREATE TABLE IF NOT EXISTS produtos_complementares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    produto_base VARCHAR(100) NOT NULL,
    categoria_base VARCHAR(50),
    complemento VARCHAR(255) NOT NULL,
    categoria_complemento VARCHAR(50),
    quantidade_por_unidade DECIMAL(10,4) DEFAULT 1,
    unidade_calculo VARCHAR(20),
    tipo VARCHAR(20) DEFAULT 'RECOMENDADO' CHECK (tipo IN ('OBRIGATORIO', 'RECOMENDADO', 'OPCIONAL')),
    preco_referencia DECIMAL(10,2),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Dados iniciais de complementares
INSERT INTO produtos_complementares (codigo, produto_base, categoria_base, complemento, categoria_complemento, quantidade_por_unidade, unidade_calculo, tipo, preco_referencia) VALUES
('COMP001', 'PORCELANATO', 'REVESTIMENTOS', 'Argamassa AC-III 20kg', 'ARGAMASSAS', 5, 'kg/m2', 'OBRIGATORIO', 42.90),
('COMP002', 'PORCELANATO', 'REVESTIMENTOS', 'Rejunte Porcelanato 1kg', 'REJUNTES', 0.5, 'kg/m2', 'OBRIGATORIO', 18.90),
('COMP003', 'PORCELANATO', 'REVESTIMENTOS', 'Espacador Nivelador 1mm', 'FERRAMENTAS', 8, 'un/m2', 'OBRIGATORIO', 0.35),
('COMP004', 'PORCELANATO', 'REVESTIMENTOS', 'Cunha Nivelador', 'FERRAMENTAS', 8, 'un/m2', 'RECOMENDADO', 0.15),
('COMP005', 'PORCELANATO', 'REVESTIMENTOS', 'Disco Corte Porcelanato', 'FERRAMENTAS', 0.02, 'un/m2', 'RECOMENDADO', 45.00),
('COMP006', 'BACIA SANITARIA', 'LOUCAS', 'Anel Vedacao', 'ACESSORIOS', 1, 'un', 'OBRIGATORIO', 12.50),
('COMP007', 'BACIA SANITARIA', 'LOUCAS', 'Parafuso Fixacao', 'ACESSORIOS', 2, 'un', 'OBRIGATORIO', 8.90),
('COMP008', 'BACIA SANITARIA', 'LOUCAS', 'Engate Flexivel 40cm', 'HIDRAULICO', 1, 'un', 'OBRIGATORIO', 28.90),
('COMP009', 'BACIA SANITARIA', 'LOUCAS', 'Assento Sanitario', 'ACESSORIOS', 1, 'un', 'OBRIGATORIO', 89.90),
('COMP010', 'BACIA SANITARIA', 'LOUCAS', 'Ducha Higienica Kit', 'METAIS', 1, 'un', 'RECOMENDADO', 285.00),
('COMP011', 'PINTURA', 'TINTAS', 'Selador Acrilico 18L', 'PREPARACAO', 0.2, 'L/m2', 'OBRIGATORIO', 165.00),
('COMP012', 'PINTURA', 'TINTAS', 'Massa Corrida PVA 25kg', 'PREPARACAO', 0.5, 'kg/m2', 'OBRIGATORIO', 86.90),
('COMP013', 'PINTURA', 'TINTAS', 'Lixa 220', 'FERRAMENTAS', 0.1, 'folha/m2', 'OBRIGATORIO', 1.59),
('COMP014', 'PINTURA', 'TINTAS', 'Fita Crepe 48mm', 'FERRAMENTAS', 0.3, 'm/m2', 'RECOMENDADO', 13.95),
('COMP015', 'PINTURA', 'TINTAS', 'Lona Plastica', 'PROTECAO', 1.1, 'm2/m2', 'RECOMENDADO', 3.30),
('COMP016', 'CUBA', 'LOUCAS', 'Valvula Click Clack', 'ACESSORIOS', 1, 'un', 'OBRIGATORIO', 45.00),
('COMP017', 'CUBA', 'LOUCAS', 'Sifao Cromado', 'HIDRAULICO', 1, 'un', 'OBRIGATORIO', 89.90),
('COMP018', 'CUBA', 'LOUCAS', 'Engate Flexivel 30cm', 'HIDRAULICO', 1, 'un', 'OBRIGATORIO', 24.90),
('COMP019', 'CUBA', 'LOUCAS', 'Torneira Lavatorio', 'METAIS', 1, 'un', 'RECOMENDADO', 520.00)
ON CONFLICT (codigo) DO NOTHING;

-- ============================================================================
-- 3. TABELA DE PROJETOS DE COMPRAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS projetos_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    contrato_id UUID REFERENCES contratos(id),
    cliente_id UUID REFERENCES pessoas(id),
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

CREATE INDEX IF NOT EXISTS idx_projetos_compras_codigo ON projetos_compras(codigo);
CREATE INDEX IF NOT EXISTS idx_projetos_compras_status ON projetos_compras(status);
CREATE INDEX IF NOT EXISTS idx_projetos_compras_contrato ON projetos_compras(contrato_id);

-- ============================================================================
-- 4. TABELA DE QUANTITATIVO DO PROJETO
-- ============================================================================

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
    pricelist_id UUID REFERENCES pricelist_itens(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_quantitativo_projeto ON projeto_quantitativo(projeto_id);
CREATE INDEX IF NOT EXISTS idx_quantitativo_ambiente ON projeto_quantitativo(ambiente);

-- ============================================================================
-- 5. TABELA DE LISTA DE COMPRAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS projeto_lista_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) NOT NULL,
    projeto_id UUID REFERENCES projetos_compras(id) ON DELETE CASCADE,
    quantitativo_id UUID REFERENCES projeto_quantitativo(id),
    pricelist_id UUID REFERENCES pricelist_itens(id),

    -- Dados do produto
    categoria_id UUID REFERENCES categorias_compras(id),
    ambiente VARCHAR(100),
    descricao TEXT NOT NULL,
    especificacao TEXT,

    -- Quantidades
    quantidade_projeto DECIMAL(10,4),
    quantidade_compra DECIMAL(10,4),
    unidade VARCHAR(20),

    -- Precos
    preco_unitario DECIMAL(10,2),
    valor_total DECIMAL(10,2),

    -- TIPO DE COMPRA (FEE)
    tipo_compra VARCHAR(20) NOT NULL DEFAULT 'WG_COMPRA'
        CHECK (tipo_compra IN ('WG_COMPRA', 'CLIENTE_DIRETO')),

    -- CONTA (REAL vs VIRTUAL)
    tipo_conta VARCHAR(10) NOT NULL DEFAULT 'REAL'
        CHECK (tipo_conta IN ('REAL', 'VIRTUAL')),

    -- FEE (para CLIENTE_DIRETO)
    taxa_fee_percent DECIMAL(5,2) DEFAULT 15,
    valor_fee DECIMAL(10,2) DEFAULT 0,

    -- Fornecedor
    fornecedor VARCHAR(100),
    link_produto TEXT,

    -- Status
    status VARCHAR(20) DEFAULT 'PENDENTE'
        CHECK (status IN ('PENDENTE', 'APROVADO', 'COMPRADO', 'ENTREGUE', 'CANCELADO')),

    -- Controle
    data_aprovacao TIMESTAMPTZ,
    data_compra TIMESTAMPTZ,
    data_entrega TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lista_compras_projeto ON projeto_lista_compras(projeto_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_status ON projeto_lista_compras(status);
CREATE INDEX IF NOT EXISTS idx_lista_compras_tipo_compra ON projeto_lista_compras(tipo_compra);
CREATE INDEX IF NOT EXISTS idx_lista_compras_tipo_conta ON projeto_lista_compras(tipo_conta);

-- ============================================================================
-- 6. TABELA DE FLUXO FINANCEIRO
-- ============================================================================

CREATE TABLE IF NOT EXISTS fluxo_financeiro_compras (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    projeto_id UUID REFERENCES projetos_compras(id),
    lista_compra_id UUID REFERENCES projeto_lista_compras(id),
    data_registro DATE DEFAULT CURRENT_DATE,
    cliente_nome VARCHAR(255),
    categoria VARCHAR(100),
    descricao TEXT,
    tipo_compra VARCHAR(20) NOT NULL
        CHECK (tipo_compra IN ('WG_COMPRA', 'CLIENTE_DIRETO')),
    fornecedor VARCHAR(100),
    valor_bruto DECIMAL(10,2) NOT NULL,
    taxa_fee_percent DECIMAL(5,2) DEFAULT 0,
    valor_fee DECIMAL(10,2) DEFAULT 0,
    valor_liquido DECIMAL(10,2),
    tipo_conta VARCHAR(10) NOT NULL
        CHECK (tipo_conta IN ('REAL', 'VIRTUAL')),
    status VARCHAR(20) DEFAULT 'PENDENTE'
        CHECK (status IN ('PENDENTE', 'PAGO', 'CANCELADO')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fluxo_projeto ON fluxo_financeiro_compras(projeto_id);
CREATE INDEX IF NOT EXISTS idx_fluxo_tipo_conta ON fluxo_financeiro_compras(tipo_conta);
CREATE INDEX IF NOT EXISTS idx_fluxo_status ON fluxo_financeiro_compras(status);

-- ============================================================================
-- 7. TRIGGER: CALCULAR VALORES DE COMPRA
-- ============================================================================

CREATE OR REPLACE FUNCTION calcular_valores_lista_compra()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcular valor total
    NEW.valor_total = COALESCE(NEW.quantidade_compra, 0) * COALESCE(NEW.preco_unitario, 0);

    -- Definir tipo de conta e calcular FEE
    IF NEW.tipo_compra = 'CLIENTE_DIRETO' THEN
        NEW.tipo_conta = 'VIRTUAL';
        NEW.valor_fee = NEW.valor_total * COALESCE(NEW.taxa_fee_percent, 15) / 100;
    ELSE
        NEW.tipo_conta = 'REAL';
        NEW.valor_fee = 0;
    END IF;

    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_calcular_valores_lista_compra ON projeto_lista_compras;
CREATE TRIGGER trigger_calcular_valores_lista_compra
    BEFORE INSERT OR UPDATE ON projeto_lista_compras
    FOR EACH ROW EXECUTE FUNCTION calcular_valores_lista_compra();

-- ============================================================================
-- 8. VIEW: RESUMO FINANCEIRO POR PROJETO
-- ============================================================================

CREATE OR REPLACE VIEW v_resumo_financeiro_compras AS
SELECT
    p.id AS projeto_id,
    p.codigo AS projeto_codigo,
    p.nome AS projeto_nome,
    p.cliente_nome,
    COUNT(lc.id) AS total_itens,
    COUNT(CASE WHEN lc.status = 'PENDENTE' THEN 1 END) AS itens_pendentes,
    COUNT(CASE WHEN lc.status = 'COMPRADO' THEN 1 END) AS itens_comprados,
    COALESCE(SUM(CASE WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total ELSE 0 END), 0) AS total_conta_real,
    COALESCE(SUM(CASE WHEN lc.tipo_conta = 'VIRTUAL' THEN lc.valor_total ELSE 0 END), 0) AS total_conta_virtual,
    COALESCE(SUM(lc.valor_fee), 0) AS total_fee,
    COALESCE(SUM(lc.valor_total), 0) AS total_geral
FROM projetos_compras p
LEFT JOIN projeto_lista_compras lc ON lc.projeto_id = p.id
GROUP BY p.id, p.codigo, p.nome, p.cliente_nome;

-- ============================================================================
-- 9. VIEW: LISTA DE COMPRAS COMPLETA
-- ============================================================================

CREATE OR REPLACE VIEW v_lista_compras_completa AS
SELECT
    lc.*,
    p.codigo AS projeto_codigo,
    p.nome AS projeto_nome,
    p.cliente_nome,
    cat.nome AS categoria_nome,
    cat.etapa_obra,
    cat.ordem_execucao,
    CASE
        WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total
        ELSE lc.valor_fee
    END AS valor_efetivo
FROM projeto_lista_compras lc
LEFT JOIN projetos_compras p ON p.id = lc.projeto_id
LEFT JOIN categorias_compras cat ON cat.id = lc.categoria_id
ORDER BY cat.ordem_execucao, lc.ambiente, lc.descricao;

-- ============================================================================
-- 10. FUNCTION: BUSCAR COMPLEMENTARES DE UM PRODUTO
-- ============================================================================

CREATE OR REPLACE FUNCTION get_complementares_produto(p_produto_base VARCHAR)
RETURNS TABLE (
    complemento VARCHAR,
    quantidade_por_unidade DECIMAL,
    unidade_calculo VARCHAR,
    tipo VARCHAR,
    preco_referencia DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pc.complemento,
        pc.quantidade_por_unidade,
        pc.unidade_calculo,
        pc.tipo,
        pc.preco_referencia
    FROM produtos_complementares pc
    WHERE pc.produto_base ILIKE p_produto_base
    AND pc.ativo = true
    ORDER BY
        CASE pc.tipo
            WHEN 'OBRIGATORIO' THEN 1
            WHEN 'RECOMENDADO' THEN 2
            ELSE 3
        END;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 11. FUNCTION: CALCULAR TOTAL DO PROJETO
-- ============================================================================

CREATE OR REPLACE FUNCTION get_total_projeto_compras(p_projeto_id UUID)
RETURNS TABLE (
    total_real DECIMAL,
    total_virtual DECIMAL,
    total_fee DECIMAL,
    total_geral DECIMAL,
    itens_pendentes INTEGER,
    itens_comprados INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(SUM(CASE WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total ELSE 0 END), 0),
        COALESCE(SUM(CASE WHEN lc.tipo_conta = 'VIRTUAL' THEN lc.valor_total ELSE 0 END), 0),
        COALESCE(SUM(lc.valor_fee), 0),
        COALESCE(SUM(lc.valor_total), 0),
        COUNT(CASE WHEN lc.status = 'PENDENTE' THEN 1 END)::INTEGER,
        COUNT(CASE WHEN lc.status = 'COMPRADO' THEN 1 END)::INTEGER
    FROM projeto_lista_compras lc
    WHERE lc.projeto_id = p_projeto_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 12. POLITICAS RLS
-- ============================================================================

ALTER TABLE categorias_compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_complementares ENABLE ROW LEVEL SECURITY;
ALTER TABLE projetos_compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE projeto_quantitativo ENABLE ROW LEVEL SECURITY;
ALTER TABLE projeto_lista_compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE fluxo_financeiro_compras ENABLE ROW LEVEL SECURITY;

-- Politicas para usuarios autenticados
CREATE POLICY "Allow all for authenticated" ON categorias_compras FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON produtos_complementares FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON projetos_compras FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON projeto_quantitativo FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON projeto_lista_compras FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON fluxo_financeiro_compras FOR ALL USING (true);

-- ============================================================================
-- FIM DO SCHEMA
-- ============================================================================
