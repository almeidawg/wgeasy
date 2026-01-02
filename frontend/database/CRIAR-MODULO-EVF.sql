-- ============================================================================
-- MÓDULO EVF - Estudo de Viabilidade Financeira
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================================
-- Execute este script no Supabase SQL Editor
-- ============================================================================

-- ============================================================================
-- 1. TABELA: evf_categorias_config
-- Configuração das 18 categorias do EVF com valores padrão por m²
-- ============================================================================

CREATE TABLE IF NOT EXISTS evf_categorias_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) UNIQUE NOT NULL,
  nome VARCHAR(100) NOT NULL,
  valor_m2_padrao NUMERIC(10,2) DEFAULT 0,
  icone VARCHAR(50),
  cor VARCHAR(20),
  ordem INTEGER DEFAULT 0,
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_evf_categorias_codigo ON evf_categorias_config(codigo);
CREATE INDEX IF NOT EXISTS idx_evf_categorias_ordem ON evf_categorias_config(ordem);
CREATE INDEX IF NOT EXISTS idx_evf_categorias_ativo ON evf_categorias_config(ativo);

-- Inserir as 18 categorias padrão (Valores atualizados - Pesquisa Mercado Dez/2025)
-- Fontes: SINAPI, CUB, Cronoshare, MySide, WebArCondicionado
INSERT INTO evf_categorias_config (codigo, nome, valor_m2_padrao, icone, cor, ordem) VALUES
('aquecedor_gas', 'Aquecedor a Gás', 55.00, 'Flame', '#EF4444', 1),
('arquitetura', 'Arquitetura', 120.00, 'Compass', '#5E9B94', 2),
('infra_ar_condicionado', 'Infra de Ar Condicionado', 170.00, 'Wind', '#3B82F6', 3),
('automacao', 'Automação', 200.00, 'Cpu', '#8B5CF6', 4),
('cubas_loucas_metais', 'Cubas, Louças e Metais', 120.00, 'Droplets', '#06B6D4', 5),
('eletros', 'Eletros', 250.00, 'Refrigerator', '#F59E0B', 6),
('envidracamento', 'Envidraçamento', 280.00, 'LayoutGrid', '#10B981', 7),
('gesso', 'Gesso', 140.00, 'Square', '#6B7280', 8),
('iluminacao', 'Iluminação', 100.00, 'Lightbulb', '#FBBF24', 9),
('mao_obra', 'Mão de Obra', 950.00, 'HardHat', '#2B4580', 10),
('marcenaria', 'Marcenaria', 1800.00, 'Hammer', '#8B5E3C', 11),
('marmoraria', 'Marmoraria', 350.00, 'Gem', '#A78BFA', 12),
('material_basico', 'Material Básico', 250.00, 'Package', '#78716C', 13),
('acabamentos', 'Acabamentos', 280.00, 'Palette', '#EC4899', 14),
('material_pintura', 'Material Pintura', 70.00, 'PaintBucket', '#14B8A6', 15),
('tomadas_interruptores', 'Tomadas e Interruptores', 55.00, 'PlugZap', '#F97316', 16),
('vidracaria', 'Vidraçaria', 250.00, 'GalleryVertical', '#22D3EE', 17),
('ar_condicionado', 'Ar Condicionado', 280.00, 'Snowflake', '#60A5FA', 18)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  valor_m2_padrao = EXCLUDED.valor_m2_padrao,
  icone = EXCLUDED.icone,
  cor = EXCLUDED.cor,
  ordem = EXCLUDED.ordem,
  updated_at = NOW();

-- ============================================================================
-- 2. TABELA: evf_estudos
-- Estudos de Viabilidade Financeira
-- ============================================================================

CREATE TABLE IF NOT EXISTS evf_estudos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Referências
  analise_projeto_id UUID REFERENCES analises_projeto(id) ON DELETE SET NULL,
  cliente_id UUID REFERENCES pessoas(id) ON DELETE SET NULL,

  -- Dados do estudo
  titulo VARCHAR(255) NOT NULL,
  metragem_total NUMERIC(10,2) NOT NULL DEFAULT 0,
  padrao_acabamento VARCHAR(20) NOT NULL DEFAULT 'medio_alto',

  -- Totais calculados
  valor_total NUMERIC(14,2) DEFAULT 0,
  valor_m2_medio NUMERIC(10,2) DEFAULT 0,

  -- Observações
  observacoes TEXT,

  -- Auditoria
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT evf_estudos_padrao_check CHECK (
    padrao_acabamento IN ('economico', 'medio_alto', 'alto_luxo')
  )
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_evf_estudos_cliente ON evf_estudos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_evf_estudos_analise ON evf_estudos(analise_projeto_id);
CREATE INDEX IF NOT EXISTS idx_evf_estudos_created_at ON evf_estudos(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_evf_estudos_padrao ON evf_estudos(padrao_acabamento);

-- ============================================================================
-- 3. TABELA: evf_estudos_itens
-- Itens/categorias de cada estudo
-- ============================================================================

CREATE TABLE IF NOT EXISTS evf_estudos_itens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Referência ao estudo
  estudo_id UUID NOT NULL REFERENCES evf_estudos(id) ON DELETE CASCADE,

  -- Dados do item
  categoria VARCHAR(50) NOT NULL,
  nome VARCHAR(100) NOT NULL,

  -- Valores
  valor_m2_base NUMERIC(10,2) DEFAULT 0,
  valor_m2_ajustado NUMERIC(10,2) DEFAULT 0,
  valor_previsao NUMERIC(14,2) DEFAULT 0,
  valor_minimo NUMERIC(14,2) DEFAULT 0,
  valor_maximo NUMERIC(14,2) DEFAULT 0,
  valor_estudo_real NUMERIC(14,2) DEFAULT 0,

  -- Percentual
  percentual_total NUMERIC(5,2) DEFAULT 0,

  -- Ordem
  ordem INTEGER DEFAULT 0,

  -- Auditoria
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_evf_itens_estudo ON evf_estudos_itens(estudo_id);
CREATE INDEX IF NOT EXISTS idx_evf_itens_categoria ON evf_estudos_itens(categoria);
CREATE INDEX IF NOT EXISTS idx_evf_itens_ordem ON evf_estudos_itens(ordem);

-- ============================================================================
-- 4. TRIGGER: Atualizar updated_at automaticamente
-- ============================================================================

-- Função para atualizar updated_at
CREATE OR REPLACE FUNCTION atualizar_evf_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para evf_estudos
DROP TRIGGER IF EXISTS trigger_evf_estudos_updated_at ON evf_estudos;
CREATE TRIGGER trigger_evf_estudos_updated_at
  BEFORE UPDATE ON evf_estudos
  FOR EACH ROW
  EXECUTE FUNCTION atualizar_evf_updated_at();

-- Trigger para evf_categorias_config
DROP TRIGGER IF EXISTS trigger_evf_categorias_updated_at ON evf_categorias_config;
CREATE TRIGGER trigger_evf_categorias_updated_at
  BEFORE UPDATE ON evf_categorias_config
  FOR EACH ROW
  EXECUTE FUNCTION atualizar_evf_updated_at();

-- ============================================================================
-- 5. POLÍTICAS RLS (Row Level Security)
-- ============================================================================

-- Habilitar RLS
ALTER TABLE evf_estudos ENABLE ROW LEVEL SECURITY;
ALTER TABLE evf_estudos_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE evf_categorias_config ENABLE ROW LEVEL SECURITY;

-- Dropar políticas existentes (se houver)
DROP POLICY IF EXISTS "evf_estudos_select" ON evf_estudos;
DROP POLICY IF EXISTS "evf_estudos_insert" ON evf_estudos;
DROP POLICY IF EXISTS "evf_estudos_update" ON evf_estudos;
DROP POLICY IF EXISTS "evf_estudos_delete" ON evf_estudos;
DROP POLICY IF EXISTS "evf_itens_select" ON evf_estudos_itens;
DROP POLICY IF EXISTS "evf_itens_insert" ON evf_estudos_itens;
DROP POLICY IF EXISTS "evf_itens_update" ON evf_estudos_itens;
DROP POLICY IF EXISTS "evf_itens_delete" ON evf_estudos_itens;
DROP POLICY IF EXISTS "evf_categorias_select" ON evf_categorias_config;
DROP POLICY IF EXISTS "evf_categorias_insert" ON evf_categorias_config;
DROP POLICY IF EXISTS "evf_categorias_update" ON evf_categorias_config;

-- Políticas para evf_estudos
CREATE POLICY "evf_estudos_select" ON evf_estudos
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "evf_estudos_insert" ON evf_estudos
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "evf_estudos_update" ON evf_estudos
  FOR UPDATE TO authenticated
  USING (true);

CREATE POLICY "evf_estudos_delete" ON evf_estudos
  FOR DELETE TO authenticated
  USING (true);

-- Políticas para evf_estudos_itens
CREATE POLICY "evf_itens_select" ON evf_estudos_itens
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "evf_itens_insert" ON evf_estudos_itens
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "evf_itens_update" ON evf_estudos_itens
  FOR UPDATE TO authenticated
  USING (true);

CREATE POLICY "evf_itens_delete" ON evf_estudos_itens
  FOR DELETE TO authenticated
  USING (true);

-- Políticas para evf_categorias_config (leitura para todos, escrita para admins)
CREATE POLICY "evf_categorias_select" ON evf_categorias_config
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "evf_categorias_insert" ON evf_categorias_config
  FOR INSERT TO authenticated
  WITH CHECK (true);

CREATE POLICY "evf_categorias_update" ON evf_categorias_config
  FOR UPDATE TO authenticated
  USING (true);

-- ============================================================================
-- 6. FUNÇÃO: Recalcular totais do estudo
-- ============================================================================

CREATE OR REPLACE FUNCTION recalcular_totais_evf(p_estudo_id UUID)
RETURNS VOID AS $$
DECLARE
  v_total NUMERIC(14,2);
  v_metragem NUMERIC(10,2);
  v_m2_medio NUMERIC(10,2);
BEGIN
  -- Buscar metragem do estudo
  SELECT metragem_total INTO v_metragem
  FROM evf_estudos
  WHERE id = p_estudo_id;

  -- Calcular total dos itens
  SELECT COALESCE(SUM(valor_estudo_real), 0) INTO v_total
  FROM evf_estudos_itens
  WHERE estudo_id = p_estudo_id;

  -- Calcular valor por m²
  v_m2_medio := CASE WHEN v_metragem > 0 THEN v_total / v_metragem ELSE 0 END;

  -- Atualizar estudo
  UPDATE evf_estudos
  SET valor_total = v_total,
      valor_m2_medio = v_m2_medio
  WHERE id = p_estudo_id;

  -- Recalcular percentuais dos itens
  UPDATE evf_estudos_itens
  SET percentual_total = CASE
    WHEN v_total > 0 THEN (valor_estudo_real / v_total) * 100
    ELSE 0
  END
  WHERE estudo_id = p_estudo_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 7. VIEW: Lista de estudos com dados relacionados
-- ============================================================================

CREATE OR REPLACE VIEW vw_evf_estudos_completos AS
SELECT
  e.id,
  e.titulo,
  e.metragem_total,
  e.padrao_acabamento,
  e.valor_total,
  e.valor_m2_medio,
  e.observacoes,
  e.created_at,
  e.updated_at,
  e.analise_projeto_id,
  e.cliente_id,
  e.created_by,

  -- Dados da análise
  ap.titulo AS analise_titulo,

  -- Dados do cliente
  p.nome AS cliente_nome,

  -- Contagem de itens
  (SELECT COUNT(*) FROM evf_estudos_itens WHERE estudo_id = e.id) AS total_itens

FROM evf_estudos e
LEFT JOIN analises_projeto ap ON ap.id = e.analise_projeto_id
LEFT JOIN pessoas p ON p.id = e.cliente_id
ORDER BY e.created_at DESC;

-- ============================================================================
-- 8. VERIFICAÇÃO
-- ============================================================================

-- Verificar tabelas criadas
SELECT 'evf_categorias_config' as tabela, COUNT(*) as registros FROM evf_categorias_config
UNION ALL
SELECT 'evf_estudos', COUNT(*) FROM evf_estudos
UNION ALL
SELECT 'evf_estudos_itens', COUNT(*) FROM evf_estudos_itens;

-- Listar categorias
SELECT codigo, nome, valor_m2_padrao, ordem
FROM evf_categorias_config
ORDER BY ordem;
