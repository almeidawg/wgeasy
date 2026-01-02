-- ============================================================================
-- CORREÇÃO DE ERROS 400 - APIs
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2025-12-29
-- ============================================================================
-- Execute este script no Supabase SQL Editor para corrigir os erros 400
-- ============================================================================

-- ============================================================================
-- 1. TABELA: pedidos_compra
-- Usada na página de Aprovações
-- ============================================================================

CREATE TABLE IF NOT EXISTS pedidos_compra (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero VARCHAR(20) UNIQUE,
  descricao TEXT,
  valor_total NUMERIC(14,2) DEFAULT 0,
  data_pedido DATE DEFAULT CURRENT_DATE,
  status VARCHAR(20) DEFAULT 'pendente',
  fornecedor_id UUID REFERENCES pessoas(id) ON DELETE SET NULL,
  projeto_id UUID REFERENCES projetos_compras(id) ON DELETE SET NULL,
  solicitante_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_status ON pedidos_compra(status);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_fornecedor ON pedidos_compra(fornecedor_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_data ON pedidos_compra(data_pedido DESC);

-- ============================================================================
-- 2. TABELA: financeiro_solicitacoes
-- Usada na página de Aprovações
-- ============================================================================

CREATE TABLE IF NOT EXISTS financeiro_solicitacoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  descricao TEXT NOT NULL,
  valor NUMERIC(14,2) NOT NULL DEFAULT 0,
  status VARCHAR(20) DEFAULT 'pendente',
  tipo VARCHAR(50) DEFAULT 'pagamento',
  urgencia VARCHAR(20) DEFAULT 'media',
  solicitante_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  aprovador_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  data_aprovacao TIMESTAMPTZ,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_fin_solicitacoes_status ON financeiro_solicitacoes(status);
CREATE INDEX IF NOT EXISTS idx_fin_solicitacoes_solicitante ON financeiro_solicitacoes(solicitante_id);
CREATE INDEX IF NOT EXISTS idx_fin_solicitacoes_created ON financeiro_solicitacoes(created_at DESC);

-- ============================================================================
-- 3. VERIFICAR/CORRIGIR analises_projeto
-- Adicionar FK cliente_id se não existir
-- ============================================================================

DO $$
BEGIN
  -- Verificar se a coluna cliente_id existe
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'analises_projeto' AND column_name = 'cliente_id'
  ) THEN
    ALTER TABLE analises_projeto ADD COLUMN cliente_id UUID REFERENCES pessoas(id) ON DELETE SET NULL;
  END IF;
END $$;

-- ============================================================================
-- 4. TABELA/VIEW: usuarios (para joins de solicitante)
-- Verifica se já existe como tabela antes de criar view
-- ============================================================================

-- Se "usuarios" já existe como tabela, não fazer nada
-- Se não existe, criar uma view de auth.users
DO $$
BEGIN
  -- Verificar se usuarios existe como tabela
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_name = 'usuarios'
    AND table_type = 'BASE TABLE'
  ) THEN
    -- Verificar se existe como view
    IF EXISTS (
      SELECT 1 FROM information_schema.views
      WHERE table_schema = 'public'
      AND table_name = 'usuarios'
    ) THEN
      DROP VIEW IF EXISTS usuarios;
    END IF;

    -- Criar a view apenas se não existir como tabela
    EXECUTE 'CREATE VIEW usuarios AS
      SELECT
        id,
        email,
        COALESCE(raw_user_meta_data->>''nome'', raw_user_meta_data->>''name'', split_part(email, ''@'', 1)) as nome,
        raw_user_meta_data->>''avatar_url'' as avatar_url,
        created_at,
        last_sign_in_at
      FROM auth.users';

    RAISE NOTICE 'View usuarios criada com sucesso';
  ELSE
    RAISE NOTICE 'Tabela usuarios já existe, mantendo a tabela existente';
  END IF;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Erro ao criar view usuarios: %. Continuando...', SQLERRM;
END $$;

-- ============================================================================
-- 5. POLÍTICAS RLS
-- ============================================================================

-- Habilitar RLS
ALTER TABLE pedidos_compra ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_solicitacoes ENABLE ROW LEVEL SECURITY;

-- Dropar políticas existentes
DROP POLICY IF EXISTS "pedidos_compra_select" ON pedidos_compra;
DROP POLICY IF EXISTS "pedidos_compra_insert" ON pedidos_compra;
DROP POLICY IF EXISTS "pedidos_compra_update" ON pedidos_compra;
DROP POLICY IF EXISTS "pedidos_compra_delete" ON pedidos_compra;
DROP POLICY IF EXISTS "fin_solicitacoes_select" ON financeiro_solicitacoes;
DROP POLICY IF EXISTS "fin_solicitacoes_insert" ON financeiro_solicitacoes;
DROP POLICY IF EXISTS "fin_solicitacoes_update" ON financeiro_solicitacoes;
DROP POLICY IF EXISTS "fin_solicitacoes_delete" ON financeiro_solicitacoes;

-- Políticas para pedidos_compra
CREATE POLICY "pedidos_compra_select" ON pedidos_compra
  FOR SELECT TO authenticated USING (true);
CREATE POLICY "pedidos_compra_insert" ON pedidos_compra
  FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "pedidos_compra_update" ON pedidos_compra
  FOR UPDATE TO authenticated USING (true);
CREATE POLICY "pedidos_compra_delete" ON pedidos_compra
  FOR DELETE TO authenticated USING (true);

-- Políticas para financeiro_solicitacoes
CREATE POLICY "fin_solicitacoes_select" ON financeiro_solicitacoes
  FOR SELECT TO authenticated USING (true);
CREATE POLICY "fin_solicitacoes_insert" ON financeiro_solicitacoes
  FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "fin_solicitacoes_update" ON financeiro_solicitacoes
  FOR UPDATE TO authenticated USING (true);
CREATE POLICY "fin_solicitacoes_delete" ON financeiro_solicitacoes
  FOR DELETE TO authenticated USING (true);

-- ============================================================================
-- 6. VERIFICAÇÃO
-- ============================================================================

SELECT 'Tabelas criadas/verificadas:' as info;

SELECT
  table_name,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as colunas
FROM information_schema.tables t
WHERE table_schema = 'public'
  AND table_name IN ('pedidos_compra', 'financeiro_solicitacoes', 'analises_projeto', 'projeto_lista_compras')
ORDER BY table_name;
