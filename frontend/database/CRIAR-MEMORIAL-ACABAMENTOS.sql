-- ============================================================
-- MEMORIAL DE ACABAMENTOS
-- Sistema WG Easy - Grupo WG Almeida
-- Especificação técnica de acabamentos por ambiente
-- ============================================================

-- Dropar tabelas se existirem (para recriação limpa)
DROP TABLE IF EXISTS memorial_acabamentos CASCADE;
DROP TABLE IF EXISTS ambientes_templates CASCADE;

-- ============================================================
-- TABELA: ambientes_templates
-- Templates de ambientes padrão com categorias associadas
-- ============================================================

CREATE TABLE ambientes_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  categorias_padrao JSONB DEFAULT '[]'::JSONB,
  ordem INTEGER DEFAULT 0,
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir ambientes padrão
INSERT INTO ambientes_templates (nome, descricao, categorias_padrao, ordem) VALUES
('ÁREA GOURMET', 'Espaço gourmet com churrasqueira/forno', '["LOUÇAS", "METAIS", "ELETRODOMÉSTICOS", "ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 1),
('LAVABO', 'Banheiro social', '["LOUÇAS", "METAIS", "ACABAMENTOS E REVESTIMENTOS", "ACESSÓRIOS", "ILUMINAÇÃO", "VIDRAÇARIA"]', 2),
('BANHO SUÍTE MASTER', 'Banheiro da suíte principal', '["LOUÇAS", "METAIS", "ACABAMENTOS E REVESTIMENTOS", "ACESSÓRIOS", "ILUMINAÇÃO", "VIDRAÇARIA"]', 3),
('BANHO SUÍTE 02', 'Banheiro da suíte 02', '["LOUÇAS", "METAIS", "ACABAMENTOS E REVESTIMENTOS", "ACESSÓRIOS", "ILUMINAÇÃO", "VIDRAÇARIA"]', 4),
('BANHO SUÍTE 03', 'Banheiro da suíte 03', '["LOUÇAS", "METAIS", "ACABAMENTOS E REVESTIMENTOS", "ACESSÓRIOS", "ILUMINAÇÃO", "VIDRAÇARIA"]', 5),
('BANHO SERVIÇO', 'Banheiro de serviço/empregada', '["LOUÇAS", "METAIS", "ACABAMENTOS E REVESTIMENTOS", "ACESSÓRIOS"]', 6),
('COZINHA', 'Cozinha principal', '["LOUÇAS", "METAIS", "ELETRODOMÉSTICOS", "ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 7),
('LAVANDERIA', 'Área de serviço/lavanderia', '["LOUÇAS", "METAIS", "ELETRODOMÉSTICOS", "ACABAMENTOS E REVESTIMENTOS"]', 8),
('SALA DE ESTAR', 'Sala de estar principal', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "AUTOMAÇÃO"]', 9),
('SALA DE JANTAR', 'Sala de jantar', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 10),
('SUÍTE MASTER', 'Dormitório da suíte principal', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "AUTOMAÇÃO"]', 11),
('SUÍTE 02', 'Dormitório da suíte 02', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "AUTOMAÇÃO"]', 12),
('SUÍTE 03', 'Dormitório da suíte 03', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "AUTOMAÇÃO"]', 13),
('CLOSET', 'Closet geral', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 14),
('CLOSET MASTER', 'Closet da suíte master', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 15),
('CIRCULAÇÃO ÍNTIMA', 'Corredor área íntima', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 16),
('CIRCULAÇÃO SOCIAL', 'Corredor área social', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 17),
('HALL SOCIAL', 'Hall de entrada', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "AUTOMAÇÃO"]', 18),
('HOME OFFICE', 'Escritório/home office', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "AUTOMAÇÃO"]', 19),
('VARANDA', 'Varanda/sacada', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO"]', 20),
('PISCINA', 'Área da piscina', '["ACABAMENTOS E REVESTIMENTOS", "ILUMINAÇÃO", "EQUIPAMENTOS"]', 21),
('AQUECIMENTO CENTRAL', 'Sistema de aquecimento central', '["EQUIPAMENTOS"]', 22),
('AUTOMAÇÃO GERAL', 'Sistema de automação residencial', '["AUTOMAÇÃO"]', 23);

-- Índices para ambientes_templates
CREATE INDEX idx_ambientes_templates_nome ON ambientes_templates(nome);
CREATE INDEX idx_ambientes_templates_ativo ON ambientes_templates(ativo);

-- ============================================================
-- TABELA: memorial_acabamentos
-- Itens de acabamento por ambiente vinculados a projetos
-- ============================================================

CREATE TABLE memorial_acabamentos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Vínculo com projeto
  projeto_id UUID REFERENCES projetos(id) ON DELETE CASCADE,

  -- Classificação do item
  ambiente VARCHAR(100) NOT NULL,
  categoria VARCHAR(50) NOT NULL,
  assunto VARCHAR(100) NOT NULL,
  item VARCHAR(200) NOT NULL,

  -- Vínculo com Pricelist (opcional)
  pricelist_item_id UUID REFERENCES pricelist_itens(id) ON DELETE SET NULL,

  -- Dados manuais (usados quando não há vínculo com Pricelist)
  fabricante VARCHAR(100),
  modelo VARCHAR(200),
  codigo_fabricante VARCHAR(50),

  -- Quantidades
  quantidade DECIMAL(10,2) DEFAULT 1,
  unidade VARCHAR(20) DEFAULT 'un',

  -- Preços (herdados do Pricelist ou manual)
  preco_unitario DECIMAL(12,2),
  preco_total DECIMAL(12,2) GENERATED ALWAYS AS (quantidade * COALESCE(preco_unitario, 0)) STORED,

  -- Metadados
  observacoes TEXT,
  ordem INTEGER DEFAULT 0,
  status VARCHAR(20) DEFAULT 'pendente', -- pendente, especificado, aprovado, comprado, instalado

  -- Auditoria
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id)
);

-- Índices para memorial_acabamentos
CREATE INDEX idx_memorial_projeto ON memorial_acabamentos(projeto_id);
CREATE INDEX idx_memorial_ambiente ON memorial_acabamentos(ambiente);
CREATE INDEX idx_memorial_categoria ON memorial_acabamentos(categoria);
CREATE INDEX idx_memorial_assunto ON memorial_acabamentos(assunto);
CREATE INDEX idx_memorial_pricelist ON memorial_acabamentos(pricelist_item_id);
CREATE INDEX idx_memorial_status ON memorial_acabamentos(status);

-- ============================================================
-- TRIGGERS
-- ============================================================

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_memorial_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_memorial_updated_at
  BEFORE UPDATE ON memorial_acabamentos
  FOR EACH ROW
  EXECUTE FUNCTION update_memorial_updated_at();

-- Trigger para herdar preço do Pricelist quando vinculado
CREATE OR REPLACE FUNCTION sync_preco_pricelist()
RETURNS TRIGGER AS $$
BEGIN
  -- Se tem vínculo com pricelist e preço não foi informado manualmente
  IF NEW.pricelist_item_id IS NOT NULL AND NEW.preco_unitario IS NULL THEN
    SELECT preco INTO NEW.preco_unitario
    FROM pricelist_itens
    WHERE id = NEW.pricelist_item_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_sync_preco_pricelist
  BEFORE INSERT OR UPDATE ON memorial_acabamentos
  FOR EACH ROW
  EXECUTE FUNCTION sync_preco_pricelist();

-- ============================================================
-- VIEWS
-- ============================================================

-- View para memorial com dados do pricelist agregados
CREATE OR REPLACE VIEW vw_memorial_completo AS
SELECT
  m.id,
  m.projeto_id,
  m.ambiente,
  m.categoria,
  m.assunto,
  m.item,
  m.pricelist_item_id,
  -- Dados do pricelist (ou manual)
  COALESCE(p.fabricante, m.fabricante) as fabricante,
  COALESCE(p.modelo, m.modelo) as modelo,
  COALESCE(p.codigo_fabricante, m.codigo_fabricante) as codigo_fabricante,
  p.codigo as pricelist_codigo,
  p.nome as pricelist_nome,
  -- Preços
  m.quantidade,
  m.unidade,
  COALESCE(m.preco_unitario, p.preco, 0) as preco_unitario,
  m.quantidade * COALESCE(m.preco_unitario, p.preco, 0) as preco_total,
  -- Status
  m.observacoes,
  m.ordem,
  m.status,
  m.created_at,
  m.updated_at
FROM memorial_acabamentos m
LEFT JOIN pricelist_itens p ON m.pricelist_item_id = p.id;

-- View para resumo por ambiente
CREATE OR REPLACE VIEW vw_memorial_resumo_ambiente AS
SELECT
  m.projeto_id,
  m.ambiente,
  COUNT(*) as total_itens,
  COUNT(CASE WHEN m.status = 'pendente' THEN 1 END) as itens_pendentes,
  COUNT(CASE WHEN m.status = 'especificado' THEN 1 END) as itens_especificados,
  COUNT(CASE WHEN m.status = 'aprovado' THEN 1 END) as itens_aprovados,
  SUM(m.quantidade * COALESCE(m.preco_unitario, p.preco, 0)) as valor_total
FROM memorial_acabamentos m
LEFT JOIN pricelist_itens p ON m.pricelist_item_id = p.id
GROUP BY m.projeto_id, m.ambiente;

-- ============================================================
-- RLS (Row Level Security)
-- ============================================================

ALTER TABLE memorial_acabamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE ambientes_templates ENABLE ROW LEVEL SECURITY;

-- Políticas para memorial_acabamentos
CREATE POLICY "memorial_select_authenticated" ON memorial_acabamentos
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "memorial_insert_authenticated" ON memorial_acabamentos
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "memorial_update_authenticated" ON memorial_acabamentos
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "memorial_delete_authenticated" ON memorial_acabamentos
  FOR DELETE TO authenticated USING (true);

-- Políticas para ambientes_templates (somente leitura para todos)
CREATE POLICY "templates_select_all" ON ambientes_templates
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "templates_admin_all" ON ambientes_templates
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.auth_user_id = auth.uid()
      AND u.tipo_usuario IN ('MASTER', 'ADMIN')
    )
  );

-- ============================================================
-- COMENTÁRIOS
-- ============================================================

COMMENT ON TABLE memorial_acabamentos IS 'Especificação técnica de acabamentos por ambiente para projetos';
COMMENT ON TABLE ambientes_templates IS 'Templates de ambientes padrão com categorias pré-definidas';

COMMENT ON COLUMN memorial_acabamentos.pricelist_item_id IS 'Vínculo opcional com item do catálogo de preços';
COMMENT ON COLUMN memorial_acabamentos.preco_total IS 'Calculado automaticamente: quantidade × preço_unitário';
COMMENT ON COLUMN memorial_acabamentos.status IS 'Status do item: pendente, especificado, aprovado, comprado, instalado';

-- ============================================================
-- GRANT PERMISSIONS
-- ============================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON memorial_acabamentos TO authenticated;
GRANT SELECT ON ambientes_templates TO authenticated;
GRANT SELECT ON vw_memorial_completo TO authenticated;
GRANT SELECT ON vw_memorial_resumo_ambiente TO authenticated;
