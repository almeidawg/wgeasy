-- ============================================================
-- ADICIONAR TABELA: analises_projeto_servicos
-- Data: 2024-12-27
-- Problema: IA extrai servicos mas nao estao sendo salvos
-- ============================================================

-- ============================================================
-- TABELA: analises_projeto_servicos
-- Armazena os servicos extraidos pela IA para uso em Propostas
-- ============================================================
CREATE TABLE IF NOT EXISTS analises_projeto_servicos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  analise_id UUID REFERENCES analises_projeto(id) ON DELETE CASCADE,
  ambiente_id UUID REFERENCES analises_projeto_ambientes(id) ON DELETE SET NULL,

  -- Identificacao do Servico
  categoria VARCHAR(100) NOT NULL, -- demolição, alvenaria, hidráulica, elétrica, revestimento, etc.
  tipo VARCHAR(100), -- subtipo do servico
  descricao TEXT NOT NULL, -- descricao completa do servico

  -- Quantidades
  unidade VARCHAR(20) DEFAULT 'un', -- m2, ml, un, vb, etc.
  quantidade NUMERIC(12,4),
  area NUMERIC(12,4), -- area em m2 se aplicavel
  metragem_linear NUMERIC(12,4), -- metragem linear se aplicavel

  -- Especificacoes (JSON)
  especificacoes JSONB DEFAULT '{}'::jsonb,
  -- Ex: {"material": "porcelanato", "dimensoes": "60x60", "espessura": 10, "modelo": "acetinado", "marca": "Portobello"}

  -- Vinculacao com Pricelist
  termo_busca VARCHAR(255), -- termo sugerido pela IA para buscar no pricelist
  palavras_chave TEXT[], -- array de palavras-chave para match
  categoria_sugerida VARCHAR(100), -- categoria sugerida para pricelist
  pricelist_item_id UUID, -- id do item vinculado no pricelist (preenchido apos match)
  pricelist_match_score NUMERIC(3,2), -- score de confianca do match (0.00 a 1.00)

  -- Ambiente(s) relacionado(s)
  ambiente_nome VARCHAR(100), -- nome do ambiente principal
  ambientes_nomes TEXT[], -- array de nomes de ambientes (se multiplos)

  -- Metadados
  ordem INT DEFAULT 0,
  origem VARCHAR(20) DEFAULT 'ia', -- ia, manual
  selecionado BOOLEAN DEFAULT TRUE, -- usuario pode desmarcar itens que nao quer
  importado_para_proposta BOOLEAN DEFAULT FALSE, -- controle de importacao

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Indices para performance
CREATE INDEX IF NOT EXISTS idx_analises_servicos_analise_id ON analises_projeto_servicos(analise_id);
CREATE INDEX IF NOT EXISTS idx_analises_servicos_ambiente_id ON analises_projeto_servicos(ambiente_id);
CREATE INDEX IF NOT EXISTS idx_analises_servicos_categoria ON analises_projeto_servicos(categoria);
CREATE INDEX IF NOT EXISTS idx_analises_servicos_pricelist ON analises_projeto_servicos(pricelist_item_id);
CREATE INDEX IF NOT EXISTS idx_analises_servicos_selecionado ON analises_projeto_servicos(selecionado);

-- Trigger para atualizar timestamp
DROP TRIGGER IF EXISTS trg_analises_servicos_updated_at ON analises_projeto_servicos;
CREATE TRIGGER trg_analises_servicos_updated_at
  BEFORE UPDATE ON analises_projeto_servicos
  FOR EACH ROW
  EXECUTE FUNCTION trigger_analises_projeto_updated_at();

-- Comentarios
COMMENT ON TABLE analises_projeto_servicos IS 'Servicos extraidos pela IA da analise de projeto - usado para gerar propostas';
COMMENT ON COLUMN analises_projeto_servicos.termo_busca IS 'Termo sugerido pela IA para buscar item correspondente no pricelist';
COMMENT ON COLUMN analises_projeto_servicos.palavras_chave IS 'Palavras-chave para match fuzzy com pricelist';
COMMENT ON COLUMN analises_projeto_servicos.pricelist_item_id IS 'ID do item do pricelist vinculado apos match';
COMMENT ON COLUMN analises_projeto_servicos.selecionado IS 'Usuario pode desmarcar itens que nao deseja incluir na proposta';
COMMENT ON COLUMN analises_projeto_servicos.origem IS 'Origem: ia (extraido automaticamente), manual (adicionado pelo usuario)';

-- ============================================================
-- ADICIONAR CONTADOR DE SERVICOS NA TABELA PRINCIPAL
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'analises_projeto' AND column_name = 'total_servicos'
  ) THEN
    ALTER TABLE analises_projeto ADD COLUMN total_servicos INT DEFAULT 0;
    COMMENT ON COLUMN analises_projeto.total_servicos IS 'Total de servicos extraidos pela IA';
  END IF;
END $$;

-- ============================================================
-- TRIGGER: Recalcular total_servicos quando servicos mudam
-- ============================================================
CREATE OR REPLACE FUNCTION trigger_recalcular_total_servicos()
RETURNS TRIGGER AS $$
DECLARE
  v_analise_id UUID;
BEGIN
  IF TG_OP = 'DELETE' THEN
    v_analise_id := OLD.analise_id;
  ELSE
    v_analise_id := NEW.analise_id;
  END IF;

  UPDATE analises_projeto
  SET
    total_servicos = (
      SELECT COUNT(*) FROM analises_projeto_servicos WHERE analise_id = v_analise_id AND selecionado = TRUE
    ),
    atualizado_em = NOW()
  WHERE id = v_analise_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_recalcular_total_servicos ON analises_projeto_servicos;
CREATE TRIGGER trg_recalcular_total_servicos
  AFTER INSERT OR UPDATE OR DELETE ON analises_projeto_servicos
  FOR EACH ROW
  EXECUTE FUNCTION trigger_recalcular_total_servicos();

-- ============================================================
-- VERIFICACAO
-- ============================================================
SELECT 'Tabela analises_projeto_servicos' as item,
       CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'analises_projeto_servicos')
            THEN 'CRIADA' ELSE 'ERRO' END as status
UNION ALL
SELECT 'Coluna total_servicos em analises_projeto',
       CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'analises_projeto' AND column_name = 'total_servicos')
            THEN 'ADICIONADA' ELSE 'ERRO' END;
