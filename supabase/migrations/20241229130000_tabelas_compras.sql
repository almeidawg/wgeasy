-- ============================================================
-- TABELAS DO MÓDULO DE COMPRAS
-- Sistema WG Easy - Grupo WG Almeida
-- Corrige erros 400 em pedidos_compra e projeto_lista_compras
-- ============================================================

-- ============================================================
-- 1. CATEGORIAS DE COMPRAS
-- ============================================================

CREATE TABLE IF NOT EXISTS categorias_compras (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(200) NOT NULL,
  tipo VARCHAR(50) DEFAULT 'MATERIAL',
  etapa_obra VARCHAR(100),
  ordem_execucao INTEGER DEFAULT 0,
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_categorias_compras_codigo ON categorias_compras(codigo);
CREATE INDEX IF NOT EXISTS idx_categorias_compras_ativo ON categorias_compras(ativo);

-- RLS
ALTER TABLE categorias_compras ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categorias_compras' AND policyname = 'categorias_compras_select') THEN
    CREATE POLICY categorias_compras_select ON categorias_compras FOR SELECT TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categorias_compras' AND policyname = 'categorias_compras_insert') THEN
    CREATE POLICY categorias_compras_insert ON categorias_compras FOR INSERT TO authenticated WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categorias_compras' AND policyname = 'categorias_compras_update') THEN
    CREATE POLICY categorias_compras_update ON categorias_compras FOR UPDATE TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categorias_compras' AND policyname = 'categorias_compras_delete') THEN
    CREATE POLICY categorias_compras_delete ON categorias_compras FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- 2. PROJETOS DE COMPRAS
-- ============================================================

CREATE TABLE IF NOT EXISTS projetos_compras (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  contrato_id UUID,
  cliente_id UUID,
  cliente_nome VARCHAR(200),
  nome VARCHAR(300) NOT NULL,
  endereco TEXT,
  area_total NUMERIC(10,2),
  tipo_projeto VARCHAR(100),
  status VARCHAR(50) DEFAULT 'EM_ANDAMENTO',
  data_inicio DATE,
  data_previsao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_projetos_compras_codigo ON projetos_compras(codigo);
CREATE INDEX IF NOT EXISTS idx_projetos_compras_status ON projetos_compras(status);
CREATE INDEX IF NOT EXISTS idx_projetos_compras_cliente ON projetos_compras(cliente_id);

-- RLS
ALTER TABLE projetos_compras ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projetos_compras' AND policyname = 'projetos_compras_select') THEN
    CREATE POLICY projetos_compras_select ON projetos_compras FOR SELECT TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projetos_compras' AND policyname = 'projetos_compras_insert') THEN
    CREATE POLICY projetos_compras_insert ON projetos_compras FOR INSERT TO authenticated WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projetos_compras' AND policyname = 'projetos_compras_update') THEN
    CREATE POLICY projetos_compras_update ON projetos_compras FOR UPDATE TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projetos_compras' AND policyname = 'projetos_compras_delete') THEN
    CREATE POLICY projetos_compras_delete ON projetos_compras FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- 3. PROJETO LISTA DE COMPRAS
-- ============================================================

CREATE TABLE IF NOT EXISTS projeto_lista_compras (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  projeto_id UUID NOT NULL REFERENCES projetos_compras(id) ON DELETE CASCADE,
  quantitativo_id UUID,
  pricelist_id UUID,
  categoria_id UUID REFERENCES categorias_compras(id) ON DELETE SET NULL,
  ambiente VARCHAR(200),
  descricao TEXT NOT NULL,
  especificacao TEXT,
  quantidade_projeto NUMERIC(12,4),
  quantidade_compra NUMERIC(12,4),
  unidade VARCHAR(20),
  preco_unitario NUMERIC(14,4),
  valor_total NUMERIC(14,2),
  tipo_compra VARCHAR(50) DEFAULT 'WG_COMPRA',
  tipo_conta VARCHAR(50) DEFAULT 'REAL',
  taxa_fee_percent NUMERIC(5,2) DEFAULT 0,
  valor_fee NUMERIC(14,2) DEFAULT 0,
  fornecedor VARCHAR(200),
  link_produto TEXT,
  status VARCHAR(50) DEFAULT 'PENDENTE',
  data_aprovacao TIMESTAMPTZ,
  data_compra TIMESTAMPTZ,
  data_entrega TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_projeto_lista_compras_codigo ON projeto_lista_compras(codigo);
CREATE INDEX IF NOT EXISTS idx_projeto_lista_compras_projeto ON projeto_lista_compras(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_lista_compras_status ON projeto_lista_compras(status);
CREATE INDEX IF NOT EXISTS idx_projeto_lista_compras_categoria ON projeto_lista_compras(categoria_id);

-- RLS
ALTER TABLE projeto_lista_compras ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_lista_compras' AND policyname = 'projeto_lista_compras_select') THEN
    CREATE POLICY projeto_lista_compras_select ON projeto_lista_compras FOR SELECT TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_lista_compras' AND policyname = 'projeto_lista_compras_insert') THEN
    CREATE POLICY projeto_lista_compras_insert ON projeto_lista_compras FOR INSERT TO authenticated WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_lista_compras' AND policyname = 'projeto_lista_compras_update') THEN
    CREATE POLICY projeto_lista_compras_update ON projeto_lista_compras FOR UPDATE TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_lista_compras' AND policyname = 'projeto_lista_compras_delete') THEN
    CREATE POLICY projeto_lista_compras_delete ON projeto_lista_compras FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- 4. PEDIDOS DE COMPRA (tabela que estava dando erro 400)
-- ============================================================

CREATE TABLE IF NOT EXISTS pedidos_compra (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero VARCHAR(50) NOT NULL UNIQUE,
  descricao TEXT,
  valor_total NUMERIC(14,2) DEFAULT 0,
  data_pedido DATE DEFAULT CURRENT_DATE,
  status VARCHAR(50) DEFAULT 'pendente',
  fornecedor_id UUID,
  projeto_id UUID,
  usuario_id UUID,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_numero ON pedidos_compra(numero);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_status ON pedidos_compra(status);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_data ON pedidos_compra(data_pedido);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_fornecedor ON pedidos_compra(fornecedor_id);

-- RLS
ALTER TABLE pedidos_compra ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_select') THEN
    CREATE POLICY pedidos_compra_select ON pedidos_compra FOR SELECT TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_insert') THEN
    CREATE POLICY pedidos_compra_insert ON pedidos_compra FOR INSERT TO authenticated WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_update') THEN
    CREATE POLICY pedidos_compra_update ON pedidos_compra FOR UPDATE TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_delete') THEN
    CREATE POLICY pedidos_compra_delete ON pedidos_compra FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- 5. FLUXO FINANCEIRO DE COMPRAS
-- ============================================================

CREATE TABLE IF NOT EXISTS fluxo_financeiro_compras (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  projeto_id UUID REFERENCES projetos_compras(id) ON DELETE SET NULL,
  lista_compra_id UUID REFERENCES projeto_lista_compras(id) ON DELETE SET NULL,
  data_registro DATE DEFAULT CURRENT_DATE,
  cliente_nome VARCHAR(200),
  categoria VARCHAR(100),
  descricao TEXT,
  tipo_compra VARCHAR(50) DEFAULT 'WG_COMPRA',
  fornecedor VARCHAR(200),
  valor_bruto NUMERIC(14,2) DEFAULT 0,
  taxa_fee_percent NUMERIC(5,2) DEFAULT 0,
  valor_fee NUMERIC(14,2) DEFAULT 0,
  valor_liquido NUMERIC(14,2),
  tipo_conta VARCHAR(50) DEFAULT 'REAL',
  status VARCHAR(50) DEFAULT 'PENDENTE',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_fluxo_financeiro_compras_projeto ON fluxo_financeiro_compras(projeto_id);
CREATE INDEX IF NOT EXISTS idx_fluxo_financeiro_compras_status ON fluxo_financeiro_compras(status);

-- RLS
ALTER TABLE fluxo_financeiro_compras ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'fluxo_financeiro_compras' AND policyname = 'fluxo_financeiro_compras_select') THEN
    CREATE POLICY fluxo_financeiro_compras_select ON fluxo_financeiro_compras FOR SELECT TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'fluxo_financeiro_compras' AND policyname = 'fluxo_financeiro_compras_insert') THEN
    CREATE POLICY fluxo_financeiro_compras_insert ON fluxo_financeiro_compras FOR INSERT TO authenticated WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'fluxo_financeiro_compras' AND policyname = 'fluxo_financeiro_compras_update') THEN
    CREATE POLICY fluxo_financeiro_compras_update ON fluxo_financeiro_compras FOR UPDATE TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'fluxo_financeiro_compras' AND policyname = 'fluxo_financeiro_compras_delete') THEN
    CREATE POLICY fluxo_financeiro_compras_delete ON fluxo_financeiro_compras FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- 6. PROJETO QUANTITATIVO
-- ============================================================

CREATE TABLE IF NOT EXISTS projeto_quantitativo (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL,
  projeto_id UUID NOT NULL REFERENCES projetos_compras(id) ON DELETE CASCADE,
  ambiente VARCHAR(200),
  assunto VARCHAR(200),
  aplicacao TEXT,
  descricao_projeto TEXT NOT NULL,
  quantidade_projeto NUMERIC(12,4),
  unidade VARCHAR(20),
  fornecedor VARCHAR(200),
  fabricante VARCHAR(200),
  modelo VARCHAR(200),
  codigo_produto VARCHAR(100),
  quantidade_compra NUMERIC(12,4),
  observacoes TEXT,
  pricelist_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_projeto_quantitativo_projeto ON projeto_quantitativo(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_quantitativo_ambiente ON projeto_quantitativo(ambiente);

-- RLS
ALTER TABLE projeto_quantitativo ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_quantitativo' AND policyname = 'projeto_quantitativo_select') THEN
    CREATE POLICY projeto_quantitativo_select ON projeto_quantitativo FOR SELECT TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_quantitativo' AND policyname = 'projeto_quantitativo_insert') THEN
    CREATE POLICY projeto_quantitativo_insert ON projeto_quantitativo FOR INSERT TO authenticated WITH CHECK (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_quantitativo' AND policyname = 'projeto_quantitativo_update') THEN
    CREATE POLICY projeto_quantitativo_update ON projeto_quantitativo FOR UPDATE TO authenticated USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'projeto_quantitativo' AND policyname = 'projeto_quantitativo_delete') THEN
    CREATE POLICY projeto_quantitativo_delete ON projeto_quantitativo FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- 7. VIEWS PARA RELATÓRIOS
-- ============================================================

-- Dropar views existentes para evitar conflitos
DROP VIEW IF EXISTS v_lista_compras_completa CASCADE;
DROP VIEW IF EXISTS v_resumo_financeiro_compras CASCADE;

-- View: Resumo Financeiro por Projeto
CREATE OR REPLACE VIEW v_resumo_financeiro_compras AS
SELECT
  p.id AS projeto_id,
  p.nome AS projeto_nome,
  p.cliente_nome,
  COUNT(lc.id) AS total_itens,
  COALESCE(SUM(CASE WHEN lc.tipo_compra = 'WG_COMPRA' THEN lc.valor_total ELSE 0 END), 0) AS valor_wg_compra,
  COALESCE(SUM(CASE WHEN lc.tipo_compra = 'CLIENTE_DIRETO' THEN lc.valor_total ELSE 0 END), 0) AS valor_cliente_direto,
  COALESCE(SUM(lc.valor_fee), 0) AS total_fee,
  COALESCE(SUM(CASE WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total ELSE 0 END), 0) AS valor_conta_real,
  COALESCE(SUM(CASE WHEN lc.tipo_conta = 'VIRTUAL' THEN lc.valor_total ELSE 0 END), 0) AS valor_conta_virtual
FROM projetos_compras p
LEFT JOIN projeto_lista_compras lc ON lc.projeto_id = p.id
GROUP BY p.id, p.nome, p.cliente_nome;

-- View: Lista de Compras Completa
CREATE OR REPLACE VIEW v_lista_compras_completa AS
SELECT
  lc.*,
  p.codigo AS projeto_codigo,
  p.nome AS projeto_nome,
  p.cliente_nome,
  c.codigo AS categoria_codigo,
  c.nome AS categoria_nome
FROM projeto_lista_compras lc
LEFT JOIN projetos_compras p ON p.id = lc.projeto_id
LEFT JOIN categorias_compras c ON c.id = lc.categoria_id;

-- ============================================================
-- 8. DADOS INICIAIS DE CATEGORIAS
-- ============================================================

INSERT INTO categorias_compras (codigo, nome, tipo, etapa_obra, ordem_execucao) VALUES
  ('CAT-001', 'Elétrica', 'MATERIAL', 'ELETRICA', 1),
  ('CAT-002', 'Hidráulica', 'MATERIAL', 'HIDRAULICA', 2),
  ('CAT-003', 'Revestimentos', 'MATERIAL', 'REVESTIMENTOS', 3),
  ('CAT-004', 'Pintura', 'MATERIAL', 'PINTURA', 4),
  ('CAT-005', 'Gesso/Forro', 'MATERIAL', 'FORRO', 5),
  ('CAT-006', 'Louças e Metais', 'ACABAMENTO', 'ACABAMENTO', 6),
  ('CAT-007', 'Iluminação', 'ACABAMENTO', 'ACABAMENTO', 7),
  ('CAT-008', 'Marcenaria', 'ACABAMENTO', 'ACABAMENTO', 8),
  ('CAT-009', 'Ferragens', 'MATERIAL', 'ALVENARIA', 9),
  ('CAT-010', 'Material Cinza', 'INSUMO', 'PRE_OBRA', 10)
ON CONFLICT (codigo) DO NOTHING;

-- ============================================================
-- COMENTÁRIOS
-- ============================================================

COMMENT ON TABLE categorias_compras IS 'Categorias para organização de itens de compra';
COMMENT ON TABLE projetos_compras IS 'Projetos de compras vinculados a contratos/clientes';
COMMENT ON TABLE projeto_lista_compras IS 'Itens da lista de compras por projeto';
COMMENT ON TABLE pedidos_compra IS 'Pedidos de compra (requisições)';
COMMENT ON TABLE fluxo_financeiro_compras IS 'Fluxo financeiro de compras';
COMMENT ON TABLE projeto_quantitativo IS 'Quantitativo detalhado do projeto';

DO $$ BEGIN
  RAISE NOTICE '=== TABELAS DE COMPRAS CRIADAS/ATUALIZADAS COM SUCESSO ===';
END $$;
