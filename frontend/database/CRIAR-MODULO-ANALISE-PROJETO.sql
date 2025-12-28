-- ============================================================
-- MÓDULO: Análise de Projeto (Pré-Proposta)
-- Sistema WG Easy - Grupo WG Almeida
-- Criado em: 2025-12-25
-- ============================================================
-- Este módulo cria a nova etapa "Análise de Projeto" no workflow comercial
-- Fluxo: Oportunidades → ANÁLISE DE PROJETO → Propostas
-- ============================================================

-- ============================================================
-- 1. TABELA PRINCIPAL: analises_projeto
-- ============================================================
CREATE TABLE IF NOT EXISTS analises_projeto (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Relacionamentos
  cliente_id UUID REFERENCES pessoas(id) ON DELETE CASCADE,
  oportunidade_id UUID REFERENCES oportunidades(id) ON DELETE SET NULL,
  proposta_id UUID REFERENCES propostas(id) ON DELETE SET NULL,

  -- Identificação
  numero VARCHAR(50),
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT,

  -- Dados do Projeto
  tipo_projeto VARCHAR(50) DEFAULT 'reforma', -- reforma, obra_nova, ampliacao
  tipo_imovel VARCHAR(50), -- apartamento, casa, comercial, industrial
  area_total NUMERIC(10,2),
  pe_direito_padrao NUMERIC(4,2) DEFAULT 2.70,
  endereco_obra TEXT,
  padrao_construtivo VARCHAR(20), -- alto, medio, economico

  -- Arquivos e Documentos
  plantas_urls JSONB DEFAULT '[]'::jsonb, -- Array de URLs das plantas
  memorial_descritivo TEXT,
  contrato_texto TEXT,

  -- Análise IA
  analise_ia JSONB, -- Resultado completo da análise (ambientes, elementos, acabamentos)
  prompt_utilizado TEXT,
  provedor_ia VARCHAR(20), -- openai, anthropic
  modelo_ia VARCHAR(50), -- gpt-4-vision, claude-sonnet-4, etc.
  confiabilidade_analise NUMERIC(3,2) DEFAULT 0.85, -- 0.00 a 1.00
  tempo_processamento_ms INT, -- Tempo de processamento em milissegundos

  -- Totais Calculados
  total_ambientes INT DEFAULT 0,
  total_area_piso NUMERIC(12,2) DEFAULT 0,
  total_area_paredes NUMERIC(12,2) DEFAULT 0,
  total_perimetro NUMERIC(12,2) DEFAULT 0,

  -- Status do Workflow
  status VARCHAR(30) DEFAULT 'rascunho', -- rascunho, analisando, analisado, aprovado, vinculado

  -- Auditoria
  criado_por UUID,
  atualizado_por UUID,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_analises_projeto_cliente_id ON analises_projeto(cliente_id);
CREATE INDEX IF NOT EXISTS idx_analises_projeto_oportunidade_id ON analises_projeto(oportunidade_id);
CREATE INDEX IF NOT EXISTS idx_analises_projeto_proposta_id ON analises_projeto(proposta_id);
CREATE INDEX IF NOT EXISTS idx_analises_projeto_status ON analises_projeto(status);
CREATE INDEX IF NOT EXISTS idx_analises_projeto_criado_em ON analises_projeto(criado_em DESC);

-- Comentários
COMMENT ON TABLE analises_projeto IS 'Análises de projetos arquitetônicos com IA - etapa pré-proposta';
COMMENT ON COLUMN analises_projeto.tipo_projeto IS 'Tipo: reforma, obra_nova, ampliacao';
COMMENT ON COLUMN analises_projeto.tipo_imovel IS 'Tipo: apartamento, casa, comercial, industrial';
COMMENT ON COLUMN analises_projeto.padrao_construtivo IS 'Padrão: alto, medio, economico';
COMMENT ON COLUMN analises_projeto.analise_ia IS 'JSON com resultado da análise: ambientes, elementos, acabamentos';
COMMENT ON COLUMN analises_projeto.status IS 'Status: rascunho, analisando, analisado, aprovado, vinculado';

-- ============================================================
-- 2. TABELA: analises_projeto_ambientes
-- ============================================================
CREATE TABLE IF NOT EXISTS analises_projeto_ambientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  analise_id UUID REFERENCES analises_projeto(id) ON DELETE CASCADE,

  -- Identificação
  nome VARCHAR(100) NOT NULL,
  tipo VARCHAR(50), -- quarto, sala, cozinha, banheiro, lavabo, area_servico, varanda, etc.
  codigo VARCHAR(20), -- Código do ambiente (ex: AMB01, SUITE01)

  -- Dimensões Básicas
  largura NUMERIC(8,2),
  comprimento NUMERIC(8,2),
  pe_direito NUMERIC(4,2) DEFAULT 2.70,

  -- Áreas Calculadas
  area_piso NUMERIC(10,2),
  area_teto NUMERIC(10,2),
  perimetro NUMERIC(10,2),
  area_paredes_bruta NUMERIC(10,2), -- Antes de descontar vãos
  area_paredes_liquida NUMERIC(10,2), -- Após descontar vãos

  -- Vãos (para cálculo de área líquida de paredes)
  portas JSONB DEFAULT '[]'::jsonb, -- [{largura, altura, tipo}]
  janelas JSONB DEFAULT '[]'::jsonb, -- [{largura, altura, tipo}]
  area_vaos_total NUMERIC(10,2) DEFAULT 0, -- Soma de todas as áreas de vãos

  -- Instalações Elétricas
  tomadas_110v INT DEFAULT 0,
  tomadas_220v INT DEFAULT 0,
  tomadas_especiais JSONB DEFAULT '[]'::jsonb, -- [{tipo, voltagem, descricao}]
  pontos_iluminacao INT DEFAULT 0,
  interruptores_simples INT DEFAULT 0,
  interruptores_paralelo INT DEFAULT 0,
  interruptores_intermediario INT DEFAULT 0,
  circuitos JSONB DEFAULT '[]'::jsonb, -- [{numero, tipo, carga}]

  -- Instalações Hidráulicas
  pontos_agua_fria INT DEFAULT 0,
  pontos_agua_quente INT DEFAULT 0,
  pontos_esgoto INT DEFAULT 0,
  pontos_gas INT DEFAULT 0,
  tubulacao_seca JSONB DEFAULT '[]'::jsonb, -- [{tipo, diametro, metragem}]

  -- Acabamentos Previstos
  piso_tipo VARCHAR(100),
  piso_area NUMERIC(10,2),
  parede_tipo VARCHAR(100),
  parede_area NUMERIC(10,2),
  teto_tipo VARCHAR(100),
  teto_area NUMERIC(10,2),
  rodape_tipo VARCHAR(100),
  rodape_ml NUMERIC(10,2), -- Metragem linear

  -- Metadados
  ordem INT DEFAULT 0,
  observacoes TEXT,
  alertas JSONB DEFAULT '[]'::jsonb, -- Alertas de dados inferidos ou incompletos
  origem VARCHAR(20) DEFAULT 'ia', -- ia, manual
  editado_manualmente BOOLEAN DEFAULT FALSE,

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_analises_ambientes_analise_id ON analises_projeto_ambientes(analise_id);
CREATE INDEX IF NOT EXISTS idx_analises_ambientes_tipo ON analises_projeto_ambientes(tipo);
CREATE INDEX IF NOT EXISTS idx_analises_ambientes_ordem ON analises_projeto_ambientes(ordem);

-- Comentários
COMMENT ON TABLE analises_projeto_ambientes IS 'Ambientes extraídos da análise de projeto';
COMMENT ON COLUMN analises_projeto_ambientes.origem IS 'Origem do dado: ia (extraído pela IA), manual (inserido pelo usuário)';

-- ============================================================
-- 3. TABELA: analises_projeto_elementos
-- ============================================================
CREATE TABLE IF NOT EXISTS analises_projeto_elementos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  analise_id UUID REFERENCES analises_projeto(id) ON DELETE CASCADE,
  ambiente_id UUID REFERENCES analises_projeto_ambientes(id) ON DELETE CASCADE,

  -- Identificação
  tipo VARCHAR(50) NOT NULL, -- porta, janela, vao, tomada, interruptor, luminaria, circuito
  subtipo VARCHAR(50), -- Subtipo específico
  descricao TEXT,

  -- Quantidade e Medidas
  quantidade INT DEFAULT 1,
  largura NUMERIC(6,2),
  altura NUMERIC(6,2),
  profundidade NUMERIC(6,2),
  area NUMERIC(8,2), -- Área do elemento (para portas/janelas)

  -- Especificações
  especificacoes JSONB DEFAULT '{}'::jsonb,

  -- Metadados
  ordem INT DEFAULT 0,
  origem VARCHAR(20) DEFAULT 'ia',

  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_analises_elementos_analise_id ON analises_projeto_elementos(analise_id);
CREATE INDEX IF NOT EXISTS idx_analises_elementos_ambiente_id ON analises_projeto_elementos(ambiente_id);
CREATE INDEX IF NOT EXISTS idx_analises_elementos_tipo ON analises_projeto_elementos(tipo);

-- ============================================================
-- 4. TABELA: analises_projeto_acabamentos
-- ============================================================
CREATE TABLE IF NOT EXISTS analises_projeto_acabamentos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  analise_id UUID REFERENCES analises_projeto(id) ON DELETE CASCADE,
  ambiente_id UUID REFERENCES analises_projeto_ambientes(id) ON DELETE CASCADE,

  -- Identificação
  tipo VARCHAR(50) NOT NULL, -- piso, parede, teto, pintura, revestimento, rodape, forro, etc.
  material VARCHAR(100),
  descricao TEXT,

  -- Quantidades
  area_m2 NUMERIC(10,2),
  metragem_linear NUMERIC(10,2),
  quantidade INT,
  unidade VARCHAR(20) DEFAULT 'm2',

  -- Especificações
  especificacoes JSONB DEFAULT '{}'::jsonb,

  -- Metadados
  ordem INT DEFAULT 0,
  origem VARCHAR(20) DEFAULT 'ia',

  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_analises_acabamentos_analise_id ON analises_projeto_acabamentos(analise_id);
CREATE INDEX IF NOT EXISTS idx_analises_acabamentos_ambiente_id ON analises_projeto_acabamentos(ambiente_id);
CREATE INDEX IF NOT EXISTS idx_analises_acabamentos_tipo ON analises_projeto_acabamentos(tipo);

-- ============================================================
-- 5. TABELA: analises_projeto_arquivos
-- ============================================================
CREATE TABLE IF NOT EXISTS analises_projeto_arquivos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  analise_id UUID REFERENCES analises_projeto(id) ON DELETE CASCADE,

  -- Arquivo
  nome VARCHAR(255) NOT NULL,
  tipo VARCHAR(50), -- planta_baixa, corte, fachada, eletrica, hidraulica, memorial, contrato
  url TEXT NOT NULL,
  tamanho_bytes BIGINT,
  mime_type VARCHAR(100),

  -- Análise
  analisado BOOLEAN DEFAULT FALSE,
  analise_resultado JSONB,

  -- Metadados
  ordem INT DEFAULT 0,

  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_analises_arquivos_analise_id ON analises_projeto_arquivos(analise_id);

-- ============================================================
-- 6. TRIGGERS DE ATUALIZAÇÃO
-- ============================================================

-- Trigger para atualizar atualizado_em
CREATE OR REPLACE FUNCTION trigger_analises_projeto_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.atualizado_em = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_analises_projeto_updated_at ON analises_projeto;
CREATE TRIGGER trg_analises_projeto_updated_at
  BEFORE UPDATE ON analises_projeto
  FOR EACH ROW
  EXECUTE FUNCTION trigger_analises_projeto_updated_at();

DROP TRIGGER IF EXISTS trg_analises_ambientes_updated_at ON analises_projeto_ambientes;
CREATE TRIGGER trg_analises_ambientes_updated_at
  BEFORE UPDATE ON analises_projeto_ambientes
  FOR EACH ROW
  EXECUTE FUNCTION trigger_analises_projeto_updated_at();

-- ============================================================
-- 7. TRIGGER: Recalcular totais quando ambientes mudam
-- ============================================================
CREATE OR REPLACE FUNCTION trigger_recalcular_totais_analise()
RETURNS TRIGGER AS $$
DECLARE
  v_analise_id UUID;
BEGIN
  -- Determinar qual análise precisa ser recalculada
  IF TG_OP = 'DELETE' THEN
    v_analise_id := OLD.analise_id;
  ELSE
    v_analise_id := NEW.analise_id;
  END IF;

  -- Recalcular totais
  UPDATE analises_projeto
  SET
    total_ambientes = (
      SELECT COUNT(*) FROM analises_projeto_ambientes WHERE analise_id = v_analise_id
    ),
    total_area_piso = (
      SELECT COALESCE(SUM(area_piso), 0) FROM analises_projeto_ambientes WHERE analise_id = v_analise_id
    ),
    total_area_paredes = (
      SELECT COALESCE(SUM(area_paredes_liquida), 0) FROM analises_projeto_ambientes WHERE analise_id = v_analise_id
    ),
    total_perimetro = (
      SELECT COALESCE(SUM(perimetro), 0) FROM analises_projeto_ambientes WHERE analise_id = v_analise_id
    ),
    atualizado_em = NOW()
  WHERE id = v_analise_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_recalcular_totais_analise ON analises_projeto_ambientes;
CREATE TRIGGER trg_recalcular_totais_analise
  AFTER INSERT OR UPDATE OR DELETE ON analises_projeto_ambientes
  FOR EACH ROW
  EXECUTE FUNCTION trigger_recalcular_totais_analise();

-- ============================================================
-- 8. FUNÇÃO: Gerar número sequencial da análise
-- ============================================================
CREATE OR REPLACE FUNCTION gerar_numero_analise(p_cliente_id UUID)
RETURNS VARCHAR(50) AS $$
DECLARE
  v_ano VARCHAR(4);
  v_mes VARCHAR(2);
  v_seq INT;
  v_numero VARCHAR(50);
BEGIN
  v_ano := TO_CHAR(NOW(), 'YYYY');
  v_mes := TO_CHAR(NOW(), 'MM');

  -- Buscar próxima sequência para o mês
  SELECT COALESCE(MAX(
    NULLIF(REGEXP_REPLACE(numero, '[^0-9]', '', 'g'), '')::INT
  ), 0) + 1
  INTO v_seq
  FROM analises_projeto
  WHERE numero LIKE 'AP/' || v_ano || v_mes || '%';

  -- Formato: AP/YYYYMM-SEQ
  v_numero := 'AP/' || v_ano || v_mes || '-' || LPAD(v_seq::TEXT, 3, '0');

  RETURN v_numero;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 9. VIEW: Análises com dados do cliente
-- ============================================================
CREATE OR REPLACE VIEW vw_analises_projeto_completas AS
SELECT
  a.*,
  p.nome AS cliente_nome,
  p.email AS cliente_email,
  p.telefone AS cliente_telefone,
  o.titulo AS oportunidade_titulo,
  pr.titulo AS proposta_titulo,
  pr.numero AS proposta_numero
FROM analises_projeto a
LEFT JOIN pessoas p ON p.id = a.cliente_id
LEFT JOIN oportunidades o ON o.id = a.oportunidade_id
LEFT JOIN propostas pr ON pr.id = a.proposta_id
ORDER BY a.criado_em DESC;

-- ============================================================
-- 10. FUNÇÃO: Vincular análise à proposta
-- ============================================================
CREATE OR REPLACE FUNCTION vincular_analise_proposta(
  p_analise_id UUID,
  p_proposta_id UUID
)
RETURNS BOOLEAN AS $$
BEGIN
  -- Atualizar análise
  UPDATE analises_projeto
  SET
    proposta_id = p_proposta_id,
    status = 'vinculado',
    atualizado_em = NOW()
  WHERE id = p_analise_id;

  -- Atualizar proposta com referência à análise
  UPDATE propostas
  SET
    analise_projeto_id = p_analise_id,
    updated_at = NOW()
  WHERE id = p_proposta_id;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 11. RLS (Row Level Security) - Opcional
-- ============================================================
-- Habilitar RLS se necessário
-- ALTER TABLE analises_projeto ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE analises_projeto_ambientes ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 12. ADICIONAR COLUNA NA TABELA PROPOSTAS (referência reversa)
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'propostas' AND column_name = 'analise_projeto_id'
  ) THEN
    ALTER TABLE propostas ADD COLUMN analise_projeto_id UUID REFERENCES analises_projeto(id) ON DELETE SET NULL;
    CREATE INDEX idx_propostas_analise_projeto_id ON propostas(analise_projeto_id);
  END IF;
END $$;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
DO $$
BEGIN
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'MÓDULO ANÁLISE DE PROJETO - Instalação concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Tabelas criadas:';
  RAISE NOTICE '  - analises_projeto';
  RAISE NOTICE '  - analises_projeto_ambientes';
  RAISE NOTICE '  - analises_projeto_elementos';
  RAISE NOTICE '  - analises_projeto_acabamentos';
  RAISE NOTICE '  - analises_projeto_arquivos';
  RAISE NOTICE '';
  RAISE NOTICE 'Views criadas:';
  RAISE NOTICE '  - vw_analises_projeto_completas';
  RAISE NOTICE '';
  RAISE NOTICE 'Funções criadas:';
  RAISE NOTICE '  - gerar_numero_analise()';
  RAISE NOTICE '  - vincular_analise_proposta()';
  RAISE NOTICE '';
  RAISE NOTICE 'Coluna adicionada em propostas:';
  RAISE NOTICE '  - analise_projeto_id';
  RAISE NOTICE '============================================================';
END $$;
