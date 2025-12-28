-- ============================================================
-- MODELOS DE ORCAMENTO COM ITENS COMPLETOS DO PRICELIST
-- Data: 2024-12-27
-- Objetivo: Modelos ja vem com itens vinculados ao Pricelist
-- ============================================================

-- ============================================================
-- 1. TABELA: modelos_orcamento
-- ============================================================
CREATE TABLE IF NOT EXISTS modelos_orcamento (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identificacao
  codigo VARCHAR(50) UNIQUE NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT,

  -- Classificacao
  nucleo VARCHAR(50) NOT NULL DEFAULT 'arquitetura', -- arquitetura, engenharia, marcenaria
  categoria VARCHAR(100), -- reforma, construcao, projeto, etc.
  tags TEXT[] DEFAULT '{}',

  -- Visual
  icone VARCHAR(50), -- nome do icone lucide
  cor_primaria VARCHAR(7) DEFAULT '#5E9B94',
  cor_secundaria VARCHAR(7) DEFAULT '#E8F5F3',

  -- Estatisticas
  vezes_utilizado INT DEFAULT 0,
  popular BOOLEAN DEFAULT FALSE,

  -- Status
  ativo BOOLEAN DEFAULT TRUE,
  ordem INT DEFAULT 0,

  -- Auditoria
  criado_por UUID,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_modelos_orcamento_nucleo ON modelos_orcamento(nucleo);
CREATE INDEX IF NOT EXISTS idx_modelos_orcamento_ativo ON modelos_orcamento(ativo);
CREATE INDEX IF NOT EXISTS idx_modelos_orcamento_popular ON modelos_orcamento(popular);

-- ============================================================
-- 2. TABELA: modelos_orcamento_categorias
-- ============================================================
CREATE TABLE IF NOT EXISTS modelos_orcamento_categorias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  modelo_id UUID REFERENCES modelos_orcamento(id) ON DELETE CASCADE,

  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  cor VARCHAR(7) DEFAULT '#5E9B94',
  ordem INT DEFAULT 0,

  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_modelos_cat_modelo ON modelos_orcamento_categorias(modelo_id);

-- ============================================================
-- 3. TABELA: modelos_orcamento_itens (vinculados ao Pricelist)
-- ============================================================
CREATE TABLE IF NOT EXISTS modelos_orcamento_itens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  modelo_id UUID REFERENCES modelos_orcamento(id) ON DELETE CASCADE,
  categoria_id UUID REFERENCES modelos_orcamento_categorias(id) ON DELETE SET NULL,

  -- Vinculo com Pricelist
  pricelist_item_id UUID, -- FK para pricelist_itens

  -- Dados do item (cache do pricelist ou customizado)
  codigo VARCHAR(50),
  descricao TEXT NOT NULL,
  unidade VARCHAR(20) DEFAULT 'un',
  preco_unitario NUMERIC(12,2),

  -- Tipo de item
  tipo_item VARCHAR(50) DEFAULT 'servico', -- servico, material, produto, mao_de_obra

  -- Quantidade padrao
  quantidade_padrao NUMERIC(12,4) DEFAULT 1,
  formula_quantidade TEXT, -- ex: "area_piso * 1.1" para calcular automaticamente

  -- Metadados
  obrigatorio BOOLEAN DEFAULT FALSE,
  ordem INT DEFAULT 0,

  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_modelos_itens_modelo ON modelos_orcamento_itens(modelo_id);
CREATE INDEX IF NOT EXISTS idx_modelos_itens_categoria ON modelos_orcamento_itens(categoria_id);
CREATE INDEX IF NOT EXISTS idx_modelos_itens_pricelist ON modelos_orcamento_itens(pricelist_item_id);
CREATE INDEX IF NOT EXISTS idx_modelos_itens_tipo ON modelos_orcamento_itens(tipo_item);

-- ============================================================
-- 4. TABELA: lista_compras_obra (gerada automaticamente)
-- ============================================================
CREATE TABLE IF NOT EXISTS lista_compras_obra (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Relacionamentos
  proposta_id UUID REFERENCES propostas(id) ON DELETE CASCADE,
  contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,
  orcamento_id UUID,
  analise_id UUID REFERENCES analises_projeto(id) ON DELETE SET NULL,

  -- Identificacao
  numero VARCHAR(50),
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT,

  -- Status
  status VARCHAR(30) DEFAULT 'rascunho', -- rascunho, aguardando_aprovacao, aprovado, em_compra, comprado

  -- Totais
  total_itens INT DEFAULT 0,
  valor_estimado NUMERIC(12,2) DEFAULT 0,
  valor_aprovado NUMERIC(12,2),

  -- Auditoria
  criado_por UUID,
  aprovado_por UUID,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  aprovado_em TIMESTAMPTZ,
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lista_compras_proposta ON lista_compras_obra(proposta_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_contrato ON lista_compras_obra(contrato_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_status ON lista_compras_obra(status);

-- ============================================================
-- 5. TABELA: lista_compras_obra_itens
-- ============================================================
CREATE TABLE IF NOT EXISTS lista_compras_obra_itens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lista_id UUID REFERENCES lista_compras_obra(id) ON DELETE CASCADE,

  -- Vinculo com Pricelist
  pricelist_item_id UUID,

  -- Dados do item
  codigo VARCHAR(50),
  descricao TEXT NOT NULL,
  unidade VARCHAR(20) DEFAULT 'un',

  -- Quantidades
  quantidade_necessaria NUMERIC(12,4) NOT NULL,
  quantidade_aprovada NUMERIC(12,4),
  quantidade_comprada NUMERIC(12,4) DEFAULT 0,

  -- Valores
  preco_estimado NUMERIC(12,2),
  preco_aprovado NUMERIC(12,2),
  preco_comprado NUMERIC(12,2),

  -- Tipo
  tipo_item VARCHAR(50) DEFAULT 'material', -- material, produto, ferramenta
  categoria VARCHAR(100),

  -- Fornecedor
  fornecedor_id UUID REFERENCES pessoas(id),
  fornecedor_nome VARCHAR(255),

  -- Status
  status VARCHAR(30) DEFAULT 'pendente', -- pendente, aprovado, em_cotacao, comprado, entregue

  -- Metadados
  urgente BOOLEAN DEFAULT FALSE,
  observacoes TEXT,
  ordem INT DEFAULT 0,

  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lista_compras_itens_lista ON lista_compras_obra_itens(lista_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_itens_pricelist ON lista_compras_obra_itens(pricelist_item_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_itens_status ON lista_compras_obra_itens(status);
CREATE INDEX IF NOT EXISTS idx_lista_compras_itens_tipo ON lista_compras_obra_itens(tipo_item);

-- ============================================================
-- 6. FUNCAO: Gerar lista de compras a partir de analise/proposta
-- ============================================================
CREATE OR REPLACE FUNCTION gerar_lista_compras_obra(
  p_analise_id UUID DEFAULT NULL,
  p_proposta_id UUID DEFAULT NULL,
  p_titulo VARCHAR DEFAULT 'Lista de Compras'
)
RETURNS UUID AS $$
DECLARE
  v_lista_id UUID;
  v_total_itens INT := 0;
  v_valor_total NUMERIC := 0;
BEGIN
  -- Criar lista
  INSERT INTO lista_compras_obra (analise_id, proposta_id, titulo, status)
  VALUES (p_analise_id, p_proposta_id, p_titulo, 'rascunho')
  RETURNING id INTO v_lista_id;

  -- Se tem analise, buscar servicos do tipo material/produto
  IF p_analise_id IS NOT NULL THEN
    INSERT INTO lista_compras_obra_itens (
      lista_id, pricelist_item_id, descricao, unidade,
      quantidade_necessaria, preco_estimado, tipo_item, categoria
    )
    SELECT
      v_lista_id,
      s.pricelist_item_id,
      s.descricao,
      s.unidade,
      COALESCE(s.quantidade, s.area, 1),
      0, -- preco sera preenchido depois
      CASE
        WHEN s.categoria ILIKE '%material%' THEN 'material'
        WHEN s.categoria ILIKE '%produto%' THEN 'produto'
        ELSE 'material'
      END,
      s.categoria
    FROM analises_projeto_servicos s
    WHERE s.analise_id = p_analise_id
      AND s.selecionado = TRUE
      AND (s.categoria ILIKE '%material%' OR s.categoria ILIKE '%produto%' OR s.categoria ILIKE '%insumo%');

    GET DIAGNOSTICS v_total_itens = ROW_COUNT;
  END IF;

  -- Atualizar totais
  UPDATE lista_compras_obra
  SET total_itens = v_total_itens
  WHERE id = v_lista_id;

  RETURN v_lista_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 7. TRIGGER: Atualizar contador de uso do modelo
-- ============================================================
CREATE OR REPLACE FUNCTION trigger_incrementar_uso_modelo()
RETURNS TRIGGER AS $$
BEGIN
  -- Quando um orcamento usar um modelo, incrementar contador
  IF NEW.modelo_id IS NOT NULL AND (OLD IS NULL OR OLD.modelo_id IS DISTINCT FROM NEW.modelo_id) THEN
    UPDATE modelos_orcamento
    SET vezes_utilizado = vezes_utilizado + 1,
        atualizado_em = NOW()
    WHERE id = NEW.modelo_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 8. INSERIR MODELOS BASE COM ITENS DO PRICELIST
-- ============================================================

-- Primeiro inserir os modelos
INSERT INTO modelos_orcamento (codigo, titulo, descricao, nucleo, icone, popular, ordem) VALUES
('REFORMA-COMPLETA', 'Reforma Completa', 'Orcamento completo para reforma residencial ou comercial', 'arquitetura', 'Home', TRUE, 1),
('PROJETO-INTERIORES', 'Projeto de Interiores', 'Design de interiores com mobiliario e acabamentos', 'arquitetura', 'Palette', TRUE, 2),
('COZINHA-PLANEJADA', 'Cozinha Planejada', 'Projeto e execucao de cozinha sob medida', 'marcenaria', 'ChefHat', TRUE, 3),
('BANHEIRO-REFORMA', 'Reforma de Banheiro', 'Reforma completa com hidraulica e revestimentos', 'engenharia', 'Bath', FALSE, 4),
('CLOSET-PLANEJADO', 'Closet Planejado', 'Projeto e execucao de closet sob medida', 'marcenaria', 'Bed', FALSE, 5),
('AREA-GOURMET', 'Area Gourmet', 'Projeto completo com churrasqueira e mobiliario', 'arquitetura', 'Trees', FALSE, 6),
('PROJETO-ARQUITETONICO', 'Projeto Arquitetonico', 'Projeto arquitetonico para construcao ou reforma', 'arquitetura', 'Ruler', FALSE, 7),
('CONSTRUCAO-CIVIL', 'Construcao Civil', 'Orcamento para construcao nova', 'engenharia', 'HardHat', FALSE, 8),
('MOBILIARIO-CORPORATIVO', 'Mobiliario Corporativo', 'Projeto para escritorios e empresas', 'marcenaria', 'Building2', FALSE, 9),
('SALA-PLANEJADA', 'Sala Planejada', 'Moveis planejados para sala de estar', 'marcenaria', 'Sofa', FALSE, 10)
ON CONFLICT (codigo) DO NOTHING;

-- ============================================================
-- VERIFICACAO
-- ============================================================
SELECT 'modelos_orcamento' as tabela, COUNT(*) as registros FROM modelos_orcamento
UNION ALL
SELECT 'modelos_orcamento_categorias', COUNT(*) FROM modelos_orcamento_categorias
UNION ALL
SELECT 'modelos_orcamento_itens', COUNT(*) FROM modelos_orcamento_itens
UNION ALL
SELECT 'lista_compras_obra', COUNT(*) FROM lista_compras_obra;
