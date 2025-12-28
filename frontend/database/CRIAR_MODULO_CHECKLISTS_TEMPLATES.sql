-- =====================================================
-- MÓDULO DE CHECKLISTS TEMPLATES
-- Sistema de templates de checklists para cards de clientes
-- Baseado no modelo Trello com checklists personalizados
-- =====================================================

BEGIN;

-- =====================================================
-- 1. TABELA DE TEMPLATES DE CHECKLISTS
-- =====================================================
CREATE TABLE IF NOT EXISTS checklist_templates (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nome TEXT NOT NULL,
  nucleo TEXT NOT NULL CHECK (nucleo IN ('arquitetura', 'engenharia', 'marcenaria', 'geral')),
  descricao TEXT,
  ordem INTEGER DEFAULT 0,
  ativo BOOLEAN DEFAULT true,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW(),
  nucleo_id UUID REFERENCES nucleos(id) ON DELETE SET NULL
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_checklist_templates_nucleo ON checklist_templates(nucleo, ativo);
CREATE INDEX IF NOT EXISTS idx_checklist_templates_ordem ON checklist_templates(ordem);

-- =====================================================
-- 2. TABELA DE ITENS DOS TEMPLATES
-- =====================================================
CREATE TABLE IF NOT EXISTS checklist_template_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  template_id UUID NOT NULL REFERENCES checklist_templates(id) ON DELETE CASCADE,
  texto TEXT NOT NULL,
  ordem INTEGER DEFAULT 0,
  grupo TEXT, -- Para agrupar itens (opcional)
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_template_items_template ON checklist_template_items(template_id, ordem);

-- =====================================================
-- 3. TABELA DE CHECKLISTS DOS CLIENTES
-- (Aplicados a partir dos templates)
-- =====================================================
CREATE TABLE IF NOT EXISTS cliente_checklists (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  oportunidade_id UUID REFERENCES oportunidades(id) ON DELETE CASCADE,
  template_id UUID REFERENCES checklist_templates(id) ON DELETE SET NULL,
  nome TEXT NOT NULL,
  progresso INTEGER DEFAULT 0 CHECK (progresso >= 0 AND progresso <= 100),
  concluido BOOLEAN DEFAULT false,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_cliente_checklists_oportunidade ON cliente_checklists(oportunidade_id);
CREATE INDEX IF NOT EXISTS idx_cliente_checklists_template ON cliente_checklists(template_id);

-- =====================================================
-- 4. TABELA DE ITENS DOS CHECKLISTS DOS CLIENTES
-- =====================================================
CREATE TABLE IF NOT EXISTS cliente_checklist_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  checklist_id UUID NOT NULL REFERENCES cliente_checklists(id) ON DELETE CASCADE,
  texto TEXT NOT NULL,
  concluido BOOLEAN DEFAULT false,
  ordem INTEGER DEFAULT 0,
  concluido_em TIMESTAMPTZ,
  concluido_por UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_checklist_items_checklist ON cliente_checklist_items(checklist_id, ordem);
CREATE INDEX IF NOT EXISTS idx_checklist_items_concluido ON cliente_checklist_items(concluido);

-- =====================================================
-- 5. FUNCTION: CALCULAR PROGRESSO DO CHECKLIST
-- =====================================================
CREATE OR REPLACE FUNCTION calcular_progresso_checklist()
RETURNS TRIGGER AS $$
DECLARE
  total_itens INTEGER;
  itens_concluidos INTEGER;
  novo_progresso INTEGER;
BEGIN
  -- Contar total de itens e itens concluídos
  SELECT
    COUNT(*),
    COUNT(*) FILTER (WHERE concluido = true)
  INTO total_itens, itens_concluidos
  FROM cliente_checklist_items
  WHERE checklist_id = COALESCE(NEW.checklist_id, OLD.checklist_id);

  -- Calcular progresso (0-100)
  IF total_itens > 0 THEN
    novo_progresso := ROUND((itens_concluidos::NUMERIC / total_itens::NUMERIC) * 100);
  ELSE
    novo_progresso := 0;
  END IF;

  -- Atualizar tabela de checklists
  UPDATE cliente_checklists
  SET
    progresso = novo_progresso,
    concluido = (novo_progresso = 100),
    atualizado_em = NOW()
  WHERE id = COALESCE(NEW.checklist_id, OLD.checklist_id);

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 6. TRIGGER: ATUALIZAR PROGRESSO AUTOMATICAMENTE
-- =====================================================
DROP TRIGGER IF EXISTS trigger_calcular_progresso ON cliente_checklist_items;
CREATE TRIGGER trigger_calcular_progresso
AFTER INSERT OR UPDATE OR DELETE ON cliente_checklist_items
FOR EACH ROW
EXECUTE FUNCTION calcular_progresso_checklist();

-- =====================================================
-- 7. FUNCTION: APLICAR TEMPLATE EM OPORTUNIDADE
-- =====================================================
CREATE OR REPLACE FUNCTION aplicar_template_checklist(
  p_oportunidade_id UUID,
  p_template_id UUID
)
RETURNS UUID AS $$
DECLARE
  v_checklist_id UUID;
  v_template_nome TEXT;
  v_item RECORD;
BEGIN
  -- Buscar nome do template
  SELECT nome INTO v_template_nome
  FROM checklist_templates
  WHERE id = p_template_id;

  -- Criar checklist baseado no template
  INSERT INTO cliente_checklists (oportunidade_id, template_id, nome)
  VALUES (p_oportunidade_id, p_template_id, v_template_nome)
  RETURNING id INTO v_checklist_id;

  -- Copiar itens do template
  INSERT INTO cliente_checklist_items (checklist_id, texto, ordem)
  SELECT
    v_checklist_id,
    texto,
    ordem
  FROM checklist_template_items
  WHERE template_id = p_template_id
  ORDER BY ordem;

  RETURN v_checklist_id;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 8. RLS (Row Level Security)
-- =====================================================

-- Templates de Checklists
ALTER TABLE checklist_templates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Templates visíveis para todos" ON checklist_templates;
CREATE POLICY "Templates visíveis para todos"
  ON checklist_templates FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Apenas admins podem gerenciar templates" ON checklist_templates;
CREATE POLICY "Apenas admins podem gerenciar templates"
  ON checklist_templates FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE id = auth.uid()
      AND role IN ('admin', 'gerente')
    )
  );

-- Itens dos Templates
ALTER TABLE checklist_template_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Itens de templates visíveis para todos" ON checklist_template_items;
CREATE POLICY "Itens de templates visíveis para todos"
  ON checklist_template_items FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Apenas admins podem gerenciar itens de templates" ON checklist_template_items;
CREATE POLICY "Apenas admins podem gerenciar itens de templates"
  ON checklist_template_items FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM usuarios
      WHERE id = auth.uid()
      AND role IN ('admin', 'gerente')
    )
  );

-- Checklists dos Clientes
ALTER TABLE cliente_checklists ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Usuários podem ver checklists" ON cliente_checklists;
CREATE POLICY "Usuários podem ver checklists"
  ON cliente_checklists FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Usuários podem gerenciar checklists" ON cliente_checklists;
CREATE POLICY "Usuários podem gerenciar checklists"
  ON cliente_checklists FOR ALL
  USING (true);

-- Itens dos Checklists dos Clientes
ALTER TABLE cliente_checklist_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Usuários podem ver itens de checklists" ON cliente_checklist_items;
CREATE POLICY "Usuários podem ver itens de checklists"
  ON cliente_checklist_items FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Usuários podem gerenciar itens de checklists" ON cliente_checklist_items;
CREATE POLICY "Usuários podem gerenciar itens de checklists"
  ON cliente_checklist_items FOR ALL
  USING (true);

COMMIT;

-- =====================================================
-- 9. COMENTÁRIOS NAS TABELAS
-- =====================================================
COMMENT ON TABLE checklist_templates IS 'Templates padronizados de checklists para aplicar em cards de clientes';
COMMENT ON TABLE checklist_template_items IS 'Itens dos templates de checklists';
COMMENT ON TABLE cliente_checklists IS 'Checklists aplicados nos cards dos clientes';
COMMENT ON TABLE cliente_checklist_items IS 'Itens dos checklists dos clientes com status de conclusão';

COMMENT ON FUNCTION aplicar_template_checklist IS 'Aplica um template de checklist em uma oportunidade, criando uma cópia com todos os itens';
COMMENT ON FUNCTION calcular_progresso_checklist IS 'Calcula automaticamente o progresso (0-100%) do checklist baseado nos itens concluídos';
