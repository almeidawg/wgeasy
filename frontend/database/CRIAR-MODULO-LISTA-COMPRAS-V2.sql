-- ============================================================================
-- WGEASY - SISTEMA DE LISTA DE COMPRAS V2
-- Estrutura Completa Supabase
-- Grupo WG Almeida - 2025
-- CORRIGIDO: Alinhado com workflow e padrões existentes
-- ============================================================================

-- ============================================================================
-- PARTE 1: ENUMS E TIPOS (COM VERIFICAÇÃO DE EXISTÊNCIA)
-- ============================================================================

-- Tipo de compra (WG compra vs Cliente compra direto)
DO $$ BEGIN
    CREATE TYPE tipo_compra_enum AS ENUM ('WG_COMPRA', 'CLIENTE_DIRETO');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Tipo de conta (separação fiscal)
DO $$ BEGIN
    CREATE TYPE tipo_conta_enum AS ENUM ('REAL', 'VIRTUAL');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Status do item de compra
DO $$ BEGIN
    CREATE TYPE status_item_compra_enum AS ENUM ('PENDENTE', 'APROVADO', 'COMPRADO', 'ENTREGUE', 'CANCELADO');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Obrigatoriedade do complementar
DO $$ BEGIN
    CREATE TYPE obrigatoriedade_complementar_enum AS ENUM ('OBRIGATORIO', 'RECOMENDADO', 'OPCIONAL');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;


-- ============================================================================
-- PARTE 2: EXTENSÃO DE TABELAS EXISTENTES (SE NECESSÁRIO)
-- ============================================================================

-- Adicionar colunas extras em pricelist_itens (se não existirem)
DO $$
BEGIN
    -- Dimensões para revestimentos
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pricelist_itens' AND column_name = 'espessura_cm') THEN
        ALTER TABLE pricelist_itens ADD COLUMN espessura_cm DECIMAL(10,2);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pricelist_itens' AND column_name = 'largura_cm') THEN
        ALTER TABLE pricelist_itens ADD COLUMN largura_cm DECIMAL(10,2);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pricelist_itens' AND column_name = 'comprimento_cm') THEN
        ALTER TABLE pricelist_itens ADD COLUMN comprimento_cm DECIMAL(10,2);
    END IF;
END $$;


-- ============================================================================
-- PARTE 3: TABELA DE CATEGORIAS DE LISTA DE COMPRAS
-- (Extensão de categorias_compras existente ou nova tabela específica)
-- ============================================================================

-- Verificar e adicionar colunas em categorias_compras se existir
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'categorias_compras') THEN
        -- Adicionar coluna categoria_pai_id se não existir
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'categorias_compras' AND column_name = 'categoria_pai_id') THEN
            ALTER TABLE categorias_compras ADD COLUMN categoria_pai_id UUID REFERENCES categorias_compras(id);
        END IF;
    END IF;
END $$;


-- ============================================================================
-- PARTE 4: TABELA DE REGRAS DE PRODUTOS COMPLEMENTARES
-- (Usar tabela existente produtos_complementares ou criar extensão)
-- ============================================================================

-- Verificar se produtos_complementares existe, se não criar
CREATE TABLE IF NOT EXISTS lista_compras_complementares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Produto base (referência ao pricelist_itens)
    produto_base_id UUID REFERENCES pricelist_itens(id),
    categoria_base VARCHAR(100),

    -- Complemento (pode ou não ter referência ao pricelist)
    complemento_id UUID REFERENCES pricelist_itens(id),
    complemento_descricao VARCHAR(200) NOT NULL,
    categoria_complemento VARCHAR(100),

    -- Cálculo
    qtd_por_unidade DECIMAL(10,4) NOT NULL DEFAULT 1,
    unidade_calculo VARCHAR(20) DEFAULT 'un',

    -- Tipo e obrigatoriedade
    tipo VARCHAR(50),
    obrigatoriedade VARCHAR(20) DEFAULT 'RECOMENDADO'
        CHECK (obrigatoriedade IN ('OBRIGATORIO', 'RECOMENDADO', 'OPCIONAL')),

    -- Preço referência
    preco_referencia DECIMAL(12,2),

    -- Controle
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_lc_complementares_produto ON lista_compras_complementares(produto_base_id);
CREATE INDEX IF NOT EXISTS idx_lc_complementares_categoria ON lista_compras_complementares(categoria_base);


-- ============================================================================
-- PARTE 5: TABELA DE QUANTITATIVO DO PROJETO (DADOS DA ARQUITETA)
-- Usa projetos e contratos existentes do sistema
-- ============================================================================

CREATE TABLE IF NOT EXISTS lista_compras_quantitativo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Vínculo com sistema existente
    projeto_id UUID REFERENCES projetos(id) ON DELETE CASCADE,
    contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,

    -- Localização
    ambiente VARCHAR(100) NOT NULL,
    assunto VARCHAR(100),
    aplicacao VARCHAR(100),

    -- Especificação do projeto
    descricao_projeto TEXT NOT NULL,
    qtd_projeto DECIMAL(12,4) NOT NULL,
    unidade VARCHAR(20) DEFAULT 'un',

    -- Fabricante especificado pela arquiteta
    fornecedor VARCHAR(200),
    fabricante VARCHAR(200),
    modelo VARCHAR(200),
    codigo_fabricante VARCHAR(100),

    -- Quantidade ajustada para compra
    qtd_compra DECIMAL(12,4),

    -- Vínculo com pricelist existente
    pricelist_item_id UUID REFERENCES pricelist_itens(id),

    -- Observações
    observacoes TEXT,

    -- Controle
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_lc_quantitativo_projeto ON lista_compras_quantitativo(projeto_id);
CREATE INDEX IF NOT EXISTS idx_lc_quantitativo_contrato ON lista_compras_quantitativo(contrato_id);
CREATE INDEX IF NOT EXISTS idx_lc_quantitativo_ambiente ON lista_compras_quantitativo(ambiente);
CREATE INDEX IF NOT EXISTS idx_lc_quantitativo_pricelist ON lista_compras_quantitativo(pricelist_item_id);


-- ============================================================================
-- PARTE 6: TABELA DE LISTA DE COMPRAS DO PROJETO
-- Usa referências ao sistema existente (pessoas, pricelist_itens, projetos)
-- ============================================================================

CREATE TABLE IF NOT EXISTS lista_compras_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Vínculos com sistema existente
    projeto_id UUID REFERENCES projetos(id) ON DELETE CASCADE,
    contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,
    quantitativo_id UUID REFERENCES lista_compras_quantitativo(id),
    pricelist_item_id UUID REFERENCES pricelist_itens(id),

    -- Localização
    ambiente VARCHAR(100),
    categoria VARCHAR(100),

    -- Produto
    item VARCHAR(200) NOT NULL,
    descricao TEXT,
    imagem_url TEXT,
    link_produto TEXT,

    -- Quantidade e valores
    qtd_compra DECIMAL(12,4) NOT NULL,
    unidade VARCHAR(20) DEFAULT 'un',
    preco_unit DECIMAL(12,2) NOT NULL DEFAULT 0,
    valor_total DECIMAL(14,2) DEFAULT 0,

    -- Tipo de compra e conta (FEE)
    tipo_compra VARCHAR(20) NOT NULL DEFAULT 'WG_COMPRA'
        CHECK (tipo_compra IN ('WG_COMPRA', 'CLIENTE_DIRETO')),
    tipo_conta VARCHAR(10) NOT NULL DEFAULT 'REAL'
        CHECK (tipo_conta IN ('REAL', 'VIRTUAL')),

    -- Taxa FEE
    taxa_fee_percent DECIMAL(5,2) DEFAULT 10.00,
    valor_fee DECIMAL(14,2) DEFAULT 0,

    -- Fornecedor (usa pessoas)
    fornecedor_id UUID REFERENCES pessoas(id),
    fornecedor_nome VARCHAR(200),

    -- Status e datas
    status VARCHAR(20) DEFAULT 'PENDENTE'
        CHECK (status IN ('PENDENTE', 'APROVADO', 'COMPRADO', 'ENTREGUE', 'CANCELADO')),
    data_aprovacao TIMESTAMPTZ,
    data_compra TIMESTAMPTZ,
    data_entrega TIMESTAMPTZ,

    -- Nota fiscal
    numero_nf VARCHAR(50),

    -- Complementar?
    is_complementar BOOLEAN DEFAULT false,
    item_pai_id UUID REFERENCES lista_compras_itens(id),

    -- Observações
    observacoes TEXT,

    -- Auditoria
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_lc_itens_projeto ON lista_compras_itens(projeto_id);
CREATE INDEX IF NOT EXISTS idx_lc_itens_contrato ON lista_compras_itens(contrato_id);
CREATE INDEX IF NOT EXISTS idx_lc_itens_ambiente ON lista_compras_itens(ambiente);
CREATE INDEX IF NOT EXISTS idx_lc_itens_status ON lista_compras_itens(status);
CREATE INDEX IF NOT EXISTS idx_lc_itens_tipo_compra ON lista_compras_itens(tipo_compra);
CREATE INDEX IF NOT EXISTS idx_lc_itens_tipo_conta ON lista_compras_itens(tipo_conta);
CREATE INDEX IF NOT EXISTS idx_lc_itens_fornecedor ON lista_compras_itens(fornecedor_id);
CREATE INDEX IF NOT EXISTS idx_lc_itens_data_compra ON lista_compras_itens(data_compra);


-- ============================================================================
-- PARTE 7: TABELA DE FLUXO FINANCEIRO DE COMPRAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS lista_compras_fluxo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Referências
    projeto_id UUID REFERENCES projetos(id),
    contrato_id UUID REFERENCES contratos(id),
    lista_compra_id UUID REFERENCES lista_compras_itens(id),

    -- Data
    data DATE NOT NULL DEFAULT CURRENT_DATE,

    -- Identificação
    cliente_id UUID REFERENCES pessoas(id),
    cliente_nome VARCHAR(200),
    categoria VARCHAR(100),
    descricao TEXT,

    -- Tipo
    tipo_compra VARCHAR(20) NOT NULL CHECK (tipo_compra IN ('WG_COMPRA', 'CLIENTE_DIRETO')),
    tipo_conta VARCHAR(10) NOT NULL CHECK (tipo_conta IN ('REAL', 'VIRTUAL')),

    -- Fornecedor (usa pessoas)
    fornecedor_id UUID REFERENCES pessoas(id),
    fornecedor_nome VARCHAR(200),

    -- Valores
    valor_bruto DECIMAL(14,2) NOT NULL,
    taxa_fee_percent DECIMAL(5,2) DEFAULT 0,
    valor_fee DECIMAL(14,2) DEFAULT 0,
    valor_liquido DECIMAL(14,2) DEFAULT 0,

    -- Status
    status VARCHAR(50) DEFAULT 'PENDENTE'
        CHECK (status IN ('PENDENTE', 'EFETIVADO', 'CANCELADO')),

    -- Vínculo com financeiro existente
    lancamento_id UUID REFERENCES financeiro_lancamentos(id),

    -- Nota Fiscal
    numero_nf VARCHAR(50),
    data_nf DATE,

    -- Observações
    observacoes TEXT,

    -- Auditoria
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_lc_fluxo_projeto ON lista_compras_fluxo(projeto_id);
CREATE INDEX IF NOT EXISTS idx_lc_fluxo_contrato ON lista_compras_fluxo(contrato_id);
CREATE INDEX IF NOT EXISTS idx_lc_fluxo_lista ON lista_compras_fluxo(lista_compra_id);
CREATE INDEX IF NOT EXISTS idx_lc_fluxo_data ON lista_compras_fluxo(data);
CREATE INDEX IF NOT EXISTS idx_lc_fluxo_tipo_conta ON lista_compras_fluxo(tipo_conta);
CREATE INDEX IF NOT EXISTS idx_lc_fluxo_status ON lista_compras_fluxo(status);


-- ============================================================================
-- PARTE 8: VIEWS
-- ============================================================================

-- IMPORTANTE: DROP antes de CREATE para evitar erro de alteração de colunas
-- Também remove views que podem existir do script original ou de CRIAR-WORKFLOW-COMPRAS.sql

-- Views do script V2
DROP VIEW IF EXISTS v_lista_compras_separacao_fiscal CASCADE;
DROP VIEW IF EXISTS v_lista_compras_dashboard CASCADE;
DROP VIEW IF EXISTS v_lista_compras_completa CASCADE;

-- Views que podem existir do script original do usuário (conflitantes)
DROP VIEW IF EXISTS v_separacao_fiscal CASCADE;
DROP VIEW IF EXISTS v_dashboard_projeto CASCADE;
DROP VIEW IF EXISTS v_produtos_complementares CASCADE;

-- Views do CRIAR-WORKFLOW-COMPRAS.sql (serão recriadas com nova estrutura)
DROP VIEW IF EXISTS v_resumo_financeiro_compras CASCADE;

-- VIEW: Separação Fiscal (CONTA REAL vs VIRTUAL)
CREATE VIEW v_lista_compras_separacao_fiscal AS
SELECT
    tipo_conta,
    COUNT(*) as total_itens,
    SUM(CASE WHEN tipo_compra = 'WG_COMPRA' THEN valor_bruto ELSE 0 END) as total_compras_wg,
    SUM(CASE WHEN tipo_compra = 'CLIENTE_DIRETO' THEN valor_bruto ELSE 0 END) as total_cliente_direto,
    SUM(valor_fee) as total_fee,
    SUM(valor_liquido) as total_liquido
FROM lista_compras_fluxo
WHERE status != 'CANCELADO'
GROUP BY tipo_conta;


-- VIEW: Dashboard Financeiro por Projeto
CREATE VIEW v_lista_compras_dashboard AS
SELECT
    p.id as projeto_id,
    p.nome as projeto_nome,
    c.numero as contrato_numero,
    c.cliente_id,
    pes.nome as cliente_nome,

    -- Totais Lista de Compras
    COUNT(DISTINCT lc.id) as total_itens,
    SUM(lc.valor_total) as valor_total_lista,

    -- Por tipo de compra
    SUM(CASE WHEN lc.tipo_compra = 'WG_COMPRA' THEN lc.valor_total ELSE 0 END) as total_wg_compra,
    SUM(CASE WHEN lc.tipo_compra = 'CLIENTE_DIRETO' THEN lc.valor_total ELSE 0 END) as total_cliente_direto,

    -- FEE
    SUM(lc.valor_fee) as total_fee,

    -- Separação fiscal
    SUM(CASE WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total ELSE 0 END) as conta_real,
    SUM(CASE WHEN lc.tipo_conta = 'VIRTUAL' THEN lc.valor_fee ELSE 0 END) as conta_virtual,

    -- Por status
    SUM(CASE WHEN lc.status = 'PENDENTE' THEN lc.valor_total ELSE 0 END) as valor_pendente,
    SUM(CASE WHEN lc.status = 'APROVADO' THEN lc.valor_total ELSE 0 END) as valor_aprovado,
    SUM(CASE WHEN lc.status = 'COMPRADO' THEN lc.valor_total ELSE 0 END) as valor_comprado,
    SUM(CASE WHEN lc.status = 'ENTREGUE' THEN lc.valor_total ELSE 0 END) as valor_entregue

FROM projetos p
LEFT JOIN contratos c ON c.id = p.contrato_id
LEFT JOIN pessoas pes ON pes.id = c.cliente_id
LEFT JOIN lista_compras_itens lc ON lc.projeto_id = p.id
WHERE p.status = 'ativo'
GROUP BY p.id, p.nome, c.numero, c.cliente_id, pes.nome;


-- VIEW: Lista de Compras Completa
CREATE VIEW v_lista_compras_completa AS
SELECT
    lc.id,
    lc.projeto_id,
    p.nome as projeto_nome,
    c.numero as contrato_numero,
    pes.nome as cliente_nome,

    lc.ambiente,
    lc.categoria,
    lc.item,
    lc.descricao,

    -- Produto do Pricelist
    pl.codigo as produto_codigo,
    pl.fabricante,
    pl.modelo,
    pl.linha,

    -- Valores
    lc.qtd_compra,
    lc.unidade,
    lc.preco_unit,
    lc.valor_total,

    -- Tipo e conta
    lc.tipo_compra,
    lc.tipo_conta,
    lc.taxa_fee_percent,
    lc.valor_fee,

    -- Fornecedor
    COALESCE(lc.fornecedor_nome, f.nome) as fornecedor,

    -- Status
    lc.status,
    lc.data_aprovacao,
    lc.data_compra,
    lc.data_entrega,

    -- Links
    COALESCE(lc.imagem_url, pl.imagem_url) as imagem_url,
    COALESCE(lc.link_produto, pl.link_produto) as link_produto,

    -- Complementar
    lc.is_complementar,
    lc.observacoes

FROM lista_compras_itens lc
LEFT JOIN projetos p ON p.id = lc.projeto_id
LEFT JOIN contratos c ON c.id = lc.contrato_id
LEFT JOIN pessoas pes ON pes.id = c.cliente_id
LEFT JOIN pricelist_itens pl ON pl.id = lc.pricelist_item_id
LEFT JOIN pessoas f ON f.id = lc.fornecedor_id
ORDER BY p.nome, lc.ambiente, lc.categoria;


-- ============================================================================
-- PARTE 9: FUNCTIONS
-- ============================================================================

-- FUNCTION: Busca de produtos no pricelist (full-text search)
CREATE OR REPLACE FUNCTION buscar_produtos_lista_compras(termo TEXT)
RETURNS TABLE (
    id UUID,
    codigo VARCHAR,
    nome VARCHAR,
    descricao TEXT,
    fabricante VARCHAR,
    modelo VARCHAR,
    preco DECIMAL,
    unidade VARCHAR,
    imagem_url TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pl.id,
        pl.codigo,
        pl.nome,
        pl.descricao,
        pl.fabricante,
        pl.modelo,
        pl.preco,
        pl.unidade,
        pl.imagem_url
    FROM pricelist_itens pl
    WHERE
        pl.ativo = true
        AND (
            pl.codigo ILIKE '%' || termo || '%'
            OR pl.nome ILIKE '%' || termo || '%'
            OR pl.fabricante ILIKE '%' || termo || '%'
            OR pl.modelo ILIKE '%' || termo || '%'
            OR pl.descricao ILIKE '%' || termo || '%'
        )
    ORDER BY pl.nome
    LIMIT 50;
END;
$$ LANGUAGE plpgsql;


-- FUNCTION: Calcular complementares para um produto
CREATE OR REPLACE FUNCTION calcular_complementares_lista_compras(
    p_produto_id UUID,
    p_quantidade DECIMAL
)
RETURNS TABLE (
    complemento_descricao VARCHAR,
    quantidade_necessaria DECIMAL,
    unidade VARCHAR,
    preco_referencia DECIMAL,
    valor_estimado DECIMAL,
    obrigatoriedade VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pc.complemento_descricao,
        ROUND(p_quantidade * pc.qtd_por_unidade, 2) as quantidade_necessaria,
        pc.unidade_calculo,
        pc.preco_referencia,
        ROUND(p_quantidade * pc.qtd_por_unidade * COALESCE(pc.preco_referencia, 0), 2) as valor_estimado,
        pc.obrigatoriedade
    FROM pricelist_itens pl
    LEFT JOIN lista_compras_complementares pc ON pc.produto_base_id = pl.id
    WHERE pl.id = p_produto_id
        AND pc.ativo = true
    ORDER BY
        CASE pc.obrigatoriedade
            WHEN 'OBRIGATORIO' THEN 1
            WHEN 'RECOMENDADO' THEN 2
            ELSE 3
        END,
        pc.complemento_descricao;
END;
$$ LANGUAGE plpgsql;


-- FUNCTION: Gerar lista de compras a partir do quantitativo
CREATE OR REPLACE FUNCTION gerar_lista_compras_projeto(p_projeto_id UUID)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER := 0;
    v_quant RECORD;
    v_contrato_id UUID;
BEGIN
    -- Obter contrato do projeto
    SELECT contrato_id INTO v_contrato_id FROM projetos WHERE id = p_projeto_id;

    -- Para cada item do quantitativo
    FOR v_quant IN
        SELECT
            q.id,
            q.ambiente,
            q.descricao_projeto,
            COALESCE(q.qtd_compra, q.qtd_projeto) as qtd,
            q.unidade,
            q.pricelist_item_id,
            pl.nome as item,
            pl.preco,
            pl.imagem_url,
            pl.link_produto,
            pl.fornecedor_id
        FROM lista_compras_quantitativo q
        LEFT JOIN pricelist_itens pl ON pl.id = q.pricelist_item_id
        WHERE q.projeto_id = p_projeto_id
    LOOP
        -- Inserir na lista de compras
        INSERT INTO lista_compras_itens (
            projeto_id,
            contrato_id,
            quantitativo_id,
            pricelist_item_id,
            ambiente,
            item,
            descricao,
            qtd_compra,
            unidade,
            preco_unit,
            valor_total,
            fornecedor_id,
            imagem_url,
            link_produto,
            status
        ) VALUES (
            p_projeto_id,
            v_contrato_id,
            v_quant.id,
            v_quant.pricelist_item_id,
            v_quant.ambiente,
            COALESCE(v_quant.item, v_quant.descricao_projeto),
            v_quant.descricao_projeto,
            v_quant.qtd,
            v_quant.unidade,
            COALESCE(v_quant.preco, 0),
            COALESCE(v_quant.qtd, 0) * COALESCE(v_quant.preco, 0),
            v_quant.fornecedor_id,
            v_quant.imagem_url,
            v_quant.link_produto,
            'PENDENTE'
        );

        v_count := v_count + 1;
    END LOOP;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql;


-- FUNCTION: Totalizar projeto
CREATE OR REPLACE FUNCTION totalizar_lista_compras_projeto(p_projeto_id UUID)
RETURNS TABLE (
    total_itens INTEGER,
    valor_total DECIMAL,
    valor_wg_compra DECIMAL,
    valor_cliente_direto DECIMAL,
    valor_fee DECIMAL,
    conta_real DECIMAL,
    conta_virtual DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*)::INTEGER as total_itens,
        COALESCE(SUM(lc.valor_total), 0) as valor_total,
        COALESCE(SUM(CASE WHEN lc.tipo_compra = 'WG_COMPRA' THEN lc.valor_total ELSE 0 END), 0) as valor_wg_compra,
        COALESCE(SUM(CASE WHEN lc.tipo_compra = 'CLIENTE_DIRETO' THEN lc.valor_total ELSE 0 END), 0) as valor_cliente_direto,
        COALESCE(SUM(lc.valor_fee), 0) as valor_fee,
        COALESCE(SUM(CASE WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total ELSE 0 END), 0) as conta_real,
        COALESCE(SUM(CASE WHEN lc.tipo_conta = 'VIRTUAL' THEN lc.valor_fee ELSE 0 END), 0) as conta_virtual
    FROM lista_compras_itens lc
    WHERE lc.projeto_id = p_projeto_id
        AND lc.status != 'CANCELADO';
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- PARTE 10: TRIGGERS
-- ============================================================================

-- TRIGGER: Atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_lista_compras_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar triggers de updated_at
DROP TRIGGER IF EXISTS tr_lc_quantitativo_updated_at ON lista_compras_quantitativo;
CREATE TRIGGER tr_lc_quantitativo_updated_at
    BEFORE UPDATE ON lista_compras_quantitativo
    FOR EACH ROW EXECUTE FUNCTION update_lista_compras_updated_at();

DROP TRIGGER IF EXISTS tr_lc_itens_updated_at ON lista_compras_itens;
CREATE TRIGGER tr_lc_itens_updated_at
    BEFORE UPDATE ON lista_compras_itens
    FOR EACH ROW EXECUTE FUNCTION update_lista_compras_updated_at();

DROP TRIGGER IF EXISTS tr_lc_fluxo_updated_at ON lista_compras_fluxo;
CREATE TRIGGER tr_lc_fluxo_updated_at
    BEFORE UPDATE ON lista_compras_fluxo
    FOR EACH ROW EXECUTE FUNCTION update_lista_compras_updated_at();


-- TRIGGER: Calcular valores automaticamente
CREATE OR REPLACE FUNCTION calcular_valores_lista_compras()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcular valor total
    NEW.valor_total = COALESCE(NEW.qtd_compra, 0) * COALESCE(NEW.preco_unit, 0);

    -- Definir tipo de conta baseado no tipo de compra
    IF NEW.tipo_compra = 'CLIENTE_DIRETO' THEN
        NEW.tipo_conta = 'VIRTUAL';
        NEW.valor_fee = NEW.valor_total * COALESCE(NEW.taxa_fee_percent, 10) / 100;
    ELSE
        NEW.tipo_conta = 'REAL';
        NEW.valor_fee = 0;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_lc_itens_calcular_valores ON lista_compras_itens;
CREATE TRIGGER tr_lc_itens_calcular_valores
    BEFORE INSERT OR UPDATE ON lista_compras_itens
    FOR EACH ROW EXECUTE FUNCTION calcular_valores_lista_compras();


-- TRIGGER: Sincronizar fluxo financeiro ao atualizar lista de compras
-- COM PROTEÇÃO CONTRA DUPLICATAS
CREATE OR REPLACE FUNCTION sync_lista_compras_fluxo()
RETURNS TRIGGER AS $$
DECLARE
    v_cliente_id UUID;
    v_cliente_nome VARCHAR;
BEGIN
    -- Quando status muda para COMPRADO, criar registro no fluxo
    IF NEW.status = 'COMPRADO' AND (OLD.status IS NULL OR OLD.status != 'COMPRADO') THEN

        -- Verificar se já existe registro (proteção contra duplicatas)
        IF NOT EXISTS (SELECT 1 FROM lista_compras_fluxo WHERE lista_compra_id = NEW.id) THEN

            -- Obter dados do cliente
            SELECT c.cliente_id, pes.nome
            INTO v_cliente_id, v_cliente_nome
            FROM contratos c
            LEFT JOIN pessoas pes ON pes.id = c.cliente_id
            WHERE c.id = NEW.contrato_id;

            INSERT INTO lista_compras_fluxo (
                projeto_id,
                contrato_id,
                lista_compra_id,
                data,
                cliente_id,
                cliente_nome,
                categoria,
                descricao,
                tipo_compra,
                tipo_conta,
                fornecedor_id,
                fornecedor_nome,
                valor_bruto,
                taxa_fee_percent,
                valor_fee,
                valor_liquido,
                status
            ) VALUES (
                NEW.projeto_id,
                NEW.contrato_id,
                NEW.id,
                COALESCE(NEW.data_compra::DATE, CURRENT_DATE),
                v_cliente_id,
                v_cliente_nome,
                NEW.categoria,
                NEW.item || ' - ' || COALESCE(NEW.descricao, ''),
                NEW.tipo_compra,
                NEW.tipo_conta,
                NEW.fornecedor_id,
                NEW.fornecedor_nome,
                NEW.valor_total,
                NEW.taxa_fee_percent,
                NEW.valor_fee,
                CASE WHEN NEW.tipo_compra = 'WG_COMPRA' THEN NEW.valor_total ELSE NEW.valor_fee END,
                'EFETIVADO'
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_sync_lista_compras_fluxo ON lista_compras_itens;
CREATE TRIGGER tr_sync_lista_compras_fluxo
    AFTER UPDATE ON lista_compras_itens
    FOR EACH ROW EXECUTE FUNCTION sync_lista_compras_fluxo();


-- ============================================================================
-- PARTE 11: ROW LEVEL SECURITY (RLS) - SEGUINDO PADRÕES DO SISTEMA
-- ============================================================================

-- Habilitar RLS nas tabelas
ALTER TABLE lista_compras_complementares ENABLE ROW LEVEL SECURITY;
ALTER TABLE lista_compras_quantitativo ENABLE ROW LEVEL SECURITY;
ALTER TABLE lista_compras_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE lista_compras_fluxo ENABLE ROW LEVEL SECURITY;


-- Políticas para lista_compras_complementares (público para leitura)
DROP POLICY IF EXISTS "lc_complementares_select" ON lista_compras_complementares;
CREATE POLICY "lc_complementares_select" ON lista_compras_complementares
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "lc_complementares_manage" ON lista_compras_complementares;
CREATE POLICY "lc_complementares_manage" ON lista_compras_complementares
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO')
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO')
        )
    );


-- Políticas para lista_compras_quantitativo
DROP POLICY IF EXISTS "lc_quantitativo_select" ON lista_compras_quantitativo;
CREATE POLICY "lc_quantitativo_select" ON lista_compras_quantitativo
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "lc_quantitativo_manage" ON lista_compras_quantitativo;
CREATE POLICY "lc_quantitativo_manage" ON lista_compras_quantitativo
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO', 'COLABORADOR')
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO', 'COLABORADOR')
        )
    );


-- Políticas para lista_compras_itens
DROP POLICY IF EXISTS "lc_itens_select" ON lista_compras_itens;
CREATE POLICY "lc_itens_select" ON lista_compras_itens
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "lc_itens_insert" ON lista_compras_itens;
CREATE POLICY "lc_itens_insert" ON lista_compras_itens
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO', 'COLABORADOR')
        )
    );

DROP POLICY IF EXISTS "lc_itens_update" ON lista_compras_itens;
CREATE POLICY "lc_itens_update" ON lista_compras_itens
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO', 'FINANCEIRO')
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'ATENDIMENTO', 'FINANCEIRO')
        )
    );

DROP POLICY IF EXISTS "lc_itens_delete" ON lista_compras_itens;
CREATE POLICY "lc_itens_delete" ON lista_compras_itens
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
        )
    );


-- Políticas para lista_compras_fluxo
DROP POLICY IF EXISTS "lc_fluxo_select" ON lista_compras_fluxo;
CREATE POLICY "lc_fluxo_select" ON lista_compras_fluxo
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO', 'COMERCIAL')
        )
    );

DROP POLICY IF EXISTS "lc_fluxo_manage" ON lista_compras_fluxo;
CREATE POLICY "lc_fluxo_manage" ON lista_compras_fluxo
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
        )
    );


-- ============================================================================
-- PARTE 12: DADOS INICIAIS DE COMPLEMENTARES
-- ============================================================================

INSERT INTO lista_compras_complementares (categoria_base, complemento_descricao, categoria_complemento, qtd_por_unidade, unidade_calculo, tipo, obrigatoriedade, preco_referencia)
SELECT * FROM (VALUES
    -- PORCELANATO
    ('REVESTIMENTOS', 'Argamassa AC-III', 'ARGAMASSAS', 5::DECIMAL, 'kg/m²', 'ASSENTAMENTO', 'OBRIGATORIO', 42.90::DECIMAL),
    ('REVESTIMENTOS', 'Rejunte Porcelanato', 'REJUNTES', 0.5::DECIMAL, 'kg/m²', 'ACABAMENTO', 'OBRIGATORIO', 18.90::DECIMAL),
    ('REVESTIMENTOS', 'Espaçador 2mm', 'ACESSÓRIOS', 8::DECIMAL, 'un/m²', 'ASSENTAMENTO', 'OBRIGATORIO', 0.15::DECIMAL),
    ('REVESTIMENTOS', 'Cunha niveladora', 'ACESSÓRIOS', 8::DECIMAL, 'un/m²', 'ASSENTAMENTO', 'RECOMENDADO', 0.25::DECIMAL),
    ('REVESTIMENTOS', 'Disco de corte diamantado', 'FERRAMENTAS', 0.02::DECIMAL, 'un/m²', 'EXECUÇÃO', 'RECOMENDADO', 89.90::DECIMAL),

    -- PINTURA
    ('PINTURA', 'Selador acrílico', 'PREPARAÇÃO', 0.2::DECIMAL, 'L/m²', 'PREPARAÇÃO', 'OBRIGATORIO', 95.00::DECIMAL),
    ('PINTURA', 'Massa corrida PVA', 'PREPARAÇÃO', 0.5::DECIMAL, 'kg/m²', 'PREPARAÇÃO', 'OBRIGATORIO', 32.90::DECIMAL),
    ('PINTURA', 'Lixa 220', 'ACESSÓRIOS', 0.1::DECIMAL, 'folha/m²', 'PREPARAÇÃO', 'OBRIGATORIO', 3.50::DECIMAL),
    ('PINTURA', 'Fita crepe', 'ACESSÓRIOS', 0.3::DECIMAL, 'm/m²', 'PROTEÇÃO', 'RECOMENDADO', 0.25::DECIMAL),
    ('PINTURA', 'Lona plástica', 'PROTEÇÃO', 1.1::DECIMAL, 'm²/m²', 'PROTEÇÃO', 'RECOMENDADO', 2.50::DECIMAL),

    -- BACIA SANITÁRIA
    ('LOUÇAS', 'Anel de vedação', 'ACESSÓRIOS', 1::DECIMAL, 'un', 'INSTALAÇÃO', 'OBRIGATORIO', 15.90::DECIMAL),
    ('LOUÇAS', 'Parafuso fixação', 'ACESSÓRIOS', 2::DECIMAL, 'un', 'INSTALAÇÃO', 'OBRIGATORIO', 8.90::DECIMAL),
    ('LOUÇAS', 'Engate flexível 40cm', 'HIDRÁULICA', 1::DECIMAL, 'un', 'INSTALAÇÃO', 'OBRIGATORIO', 25.90::DECIMAL),
    ('LOUÇAS', 'Assento sanitário', 'ACESSÓRIOS', 1::DECIMAL, 'un', 'ACABAMENTO', 'OBRIGATORIO', 89.90::DECIMAL),
    ('LOUÇAS', 'Ducha higiênica', 'METAIS', 1::DECIMAL, 'un', 'COMPLEMENTO', 'RECOMENDADO', 189.90::DECIMAL),

    -- CUBA BANHEIRO
    ('LOUÇAS', 'Válvula click clack', 'METAIS', 1::DECIMAL, 'un', 'INSTALAÇÃO', 'OBRIGATORIO', 89.90::DECIMAL),
    ('LOUÇAS', 'Sifão cromado', 'HIDRÁULICA', 1::DECIMAL, 'un', 'INSTALAÇÃO', 'OBRIGATORIO', 65.90::DECIMAL),
    ('LOUÇAS', 'Engate flexível 30cm', 'HIDRÁULICA', 1::DECIMAL, 'un', 'INSTALAÇÃO', 'OBRIGATORIO', 22.90::DECIMAL),
    ('LOUÇAS', 'Torneira lavatório', 'METAIS', 1::DECIMAL, 'un', 'COMPLEMENTO', 'RECOMENDADO', 320.00::DECIMAL)
) AS v(categoria_base, complemento_descricao, categoria_complemento, qtd_por_unidade, unidade_calculo, tipo, obrigatoriedade, preco_referencia)
WHERE NOT EXISTS (
    SELECT 1 FROM lista_compras_complementares lcc
    WHERE lcc.categoria_base = v.categoria_base
    AND lcc.complemento_descricao = v.complemento_descricao
);


-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================

-- Para verificar a estrutura criada:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE 'lista_compras%';
-- SELECT routine_name FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name LIKE '%lista_compras%';

SELECT 'MÓDULO LISTA DE COMPRAS V2 - INSTALADO COM SUCESSO' AS resultado;
