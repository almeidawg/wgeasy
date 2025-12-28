-- ============================================================
-- FLUXO INTELIGENTE: JORNADA DO CLIENTE
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- CONCEITO:
-- 1. OPORTUNIDADE = Single Source of Truth (Card Master)
-- 2. CONTRATO = Gerado da Oportunidade
-- 3. CONTRATOS_NUCLEOS = Cards por núcleo (Arq, Eng, Marc)
-- 4. TIMELINE = Todas as atualizações consolidadas
--
-- ============================================================

-- ============================================================
-- 1. EXPANDIR TABELA: oportunidades (Single Source of Truth)
-- ============================================================

-- Adicionar campos para consolidar dados do projeto
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS tipo_projeto VARCHAR(50);
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS tipo_imovel VARCHAR(50);
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS area_total NUMERIC(12,2);
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS padrao_construtivo VARCHAR(50);
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS endereco_obra TEXT;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS analise_projeto_id UUID REFERENCES analises_projeto(id);
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS proposta_id UUID REFERENCES propostas(id);
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS contrato_id UUID REFERENCES contratos(id);

-- Campos de progresso consolidado
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS progresso_geral INT DEFAULT 0;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS progresso_arquitetura INT DEFAULT 0;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS progresso_engenharia INT DEFAULT 0;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS progresso_marcenaria INT DEFAULT 0;

-- Campos de valores consolidados
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS valor_arquitetura NUMERIC(12,2) DEFAULT 0;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS valor_engenharia NUMERIC(12,2) DEFAULT 0;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS valor_marcenaria NUMERIC(12,2) DEFAULT 0;
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS valor_total_executado NUMERIC(12,2) DEFAULT 0;

-- Dados do imóvel (preenchidos no checklist)
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS dados_imovel JSONB DEFAULT '{}';
-- Estrutura: { metragem, quartos, banheiros, vagas, condominio, iptu, etc }

-- Dados do projeto (consolidado das análises)
ALTER TABLE oportunidades ADD COLUMN IF NOT EXISTS dados_projeto JSONB DEFAULT '{}';
-- Estrutura: { ambientes, servicos, materiais, acabamentos, etc }

-- Índices
CREATE INDEX IF NOT EXISTS idx_oportunidades_contrato ON oportunidades(contrato_id);
CREATE INDEX IF NOT EXISTS idx_oportunidades_analise ON oportunidades(analise_projeto_id);
CREATE INDEX IF NOT EXISTS idx_oportunidades_proposta ON oportunidades(proposta_id);

-- ============================================================
-- 2. EXPANDIR TABELA: contratos_nucleos (Cards por Núcleo)
-- ============================================================

-- Verificar se a tabela existe, se não criar
CREATE TABLE IF NOT EXISTS contratos_nucleos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contrato_id UUID REFERENCES contratos(id) ON DELETE CASCADE,
  oportunidade_id UUID REFERENCES oportunidades(id) ON DELETE SET NULL,

  -- Núcleo
  nucleo VARCHAR(50) NOT NULL, -- arquitetura, engenharia, marcenaria

  -- Status Kanban
  status_kanban VARCHAR(50) DEFAULT 'backlog', -- backlog, em_andamento, revisao, aprovacao, concluido

  -- Responsável (referencia pessoas, não usuarios)
  responsavel_id UUID REFERENCES pessoas(id),
  equipe_ids UUID[] DEFAULT '{}',

  -- Progresso
  progresso INT DEFAULT 0, -- 0-100%
  data_inicio DATE,
  data_previsao DATE,
  data_conclusao DATE,

  -- Valores específicos do núcleo
  valor_previsto NUMERIC(12,2) DEFAULT 0,
  valor_executado NUMERIC(12,2) DEFAULT 0,

  -- Dados específicos do núcleo (JSON flexível)
  dados_especificos JSONB DEFAULT '{}',
  -- Arquitetura: { projeto_aprovado, memorial, cores, acabamentos }
  -- Engenharia: { hidraulica, eletrica, estrutura, instalacoes }
  -- Marcenaria: { ambientes, moveis, medidas, producao }

  -- Observações
  observacoes TEXT,

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(contrato_id, nucleo)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_contratos_nucleos_contrato ON contratos_nucleos(contrato_id);
CREATE INDEX IF NOT EXISTS idx_contratos_nucleos_oportunidade ON contratos_nucleos(oportunidade_id);
CREATE INDEX IF NOT EXISTS idx_contratos_nucleos_nucleo ON contratos_nucleos(nucleo);
CREATE INDEX IF NOT EXISTS idx_contratos_nucleos_status ON contratos_nucleos(status_kanban);
CREATE INDEX IF NOT EXISTS idx_contratos_nucleos_responsavel ON contratos_nucleos(responsavel_id);

-- ============================================================
-- 3. CRIAR TABELA: oportunidade_timeline (Histórico Unificado)
-- ============================================================

CREATE TABLE IF NOT EXISTS oportunidade_timeline (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  oportunidade_id UUID REFERENCES oportunidades(id) ON DELETE CASCADE,
  contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,

  -- Origem da atualização
  nucleo VARCHAR(50), -- null = geral, ou arquitetura, engenharia, marcenaria
  origem VARCHAR(50) NOT NULL, -- checklist, analise, proposta, contrato, execucao, financeiro, documento

  -- Tipo de evento
  tipo VARCHAR(50) NOT NULL, -- status, progresso, documento, foto, custo, pagamento, etapa, comentario

  -- Dados do evento
  titulo VARCHAR(255) NOT NULL,
  descricao TEXT,
  dados JSONB DEFAULT '{}',

  -- Arquivos anexos
  arquivo_url TEXT,
  arquivo_tipo VARCHAR(50), -- imagem, pdf, documento

  -- Referências
  referencia_tipo VARCHAR(50), -- checklist_item, servico, etapa, pagamento, etc
  referencia_id UUID,

  -- Visibilidade
  visivel_cliente BOOLEAN DEFAULT FALSE,
  destaque BOOLEAN DEFAULT FALSE,

  -- Usuário que criou
  usuario_id UUID REFERENCES usuarios(id),
  usuario_nome VARCHAR(255),

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_timeline_oportunidade ON oportunidade_timeline(oportunidade_id);
CREATE INDEX IF NOT EXISTS idx_timeline_contrato ON oportunidade_timeline(contrato_id);
CREATE INDEX IF NOT EXISTS idx_timeline_nucleo ON oportunidade_timeline(nucleo);
CREATE INDEX IF NOT EXISTS idx_timeline_tipo ON oportunidade_timeline(tipo);
CREATE INDEX IF NOT EXISTS idx_timeline_data ON oportunidade_timeline(criado_em DESC);
CREATE INDEX IF NOT EXISTS idx_timeline_cliente ON oportunidade_timeline(visivel_cliente) WHERE visivel_cliente = TRUE;

-- ============================================================
-- 4. FUNÇÃO: Criar Cards por Núcleo ao Ativar Contrato
-- ============================================================

CREATE OR REPLACE FUNCTION criar_cards_nucleos_contrato()
RETURNS TRIGGER AS $$
DECLARE
  v_nucleo VARCHAR;
  v_oportunidade_id UUID;
BEGIN
  -- Só executar quando status mudar para 'ativo'
  IF NEW.status = 'ativo' AND (OLD.status IS NULL OR OLD.status != 'ativo') THEN

    -- Buscar oportunidade vinculada
    SELECT id INTO v_oportunidade_id
    FROM oportunidades
    WHERE contrato_id = NEW.id
    LIMIT 1;

    -- Criar card para cada núcleo do contrato
    -- Núcleo principal
    IF NEW.nucleo IS NOT NULL THEN
      INSERT INTO contratos_nucleos (contrato_id, oportunidade_id, nucleo, status_kanban)
      VALUES (NEW.id, v_oportunidade_id, NEW.nucleo, 'backlog')
      ON CONFLICT (contrato_id, nucleo) DO NOTHING;
    END IF;

    -- Núcleos adicionais (se existirem na tabela auxiliar)
    FOR v_nucleo IN
      SELECT DISTINCT nucleo FROM contratos_nucleos WHERE contrato_id = NEW.id
    LOOP
      -- Já existe, apenas atualizar status se necessário
      UPDATE contratos_nucleos
      SET status_kanban = COALESCE(status_kanban, 'backlog'),
          oportunidade_id = COALESCE(oportunidade_id, v_oportunidade_id)
      WHERE contrato_id = NEW.id AND nucleo = v_nucleo;
    END LOOP;

    -- Registrar na timeline
    IF v_oportunidade_id IS NOT NULL THEN
      INSERT INTO oportunidade_timeline (
        oportunidade_id, contrato_id, origem, tipo, titulo, descricao, visivel_cliente
      ) VALUES (
        v_oportunidade_id, NEW.id, 'contrato', 'status',
        'Contrato ativado',
        'O contrato foi ativado e os núcleos de execução foram criados.',
        TRUE
      );
    END IF;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
DROP TRIGGER IF EXISTS trigger_criar_cards_nucleos ON contratos;
CREATE TRIGGER trigger_criar_cards_nucleos
  AFTER UPDATE ON contratos
  FOR EACH ROW
  EXECUTE FUNCTION criar_cards_nucleos_contrato();

-- ============================================================
-- 5. FUNÇÃO: Atualizar Progresso da Oportunidade
-- ============================================================

CREATE OR REPLACE FUNCTION atualizar_progresso_oportunidade()
RETURNS TRIGGER AS $$
DECLARE
  v_oportunidade_id UUID;
  v_prog_arq INT := 0;
  v_prog_eng INT := 0;
  v_prog_marc INT := 0;
  v_prog_geral INT := 0;
  v_total_nucleos INT := 0;
BEGIN
  -- Buscar oportunidade vinculada
  v_oportunidade_id := COALESCE(NEW.oportunidade_id, OLD.oportunidade_id);

  IF v_oportunidade_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Calcular progresso por núcleo
  SELECT
    COALESCE(MAX(CASE WHEN nucleo = 'arquitetura' THEN progresso END), 0),
    COALESCE(MAX(CASE WHEN nucleo = 'engenharia' THEN progresso END), 0),
    COALESCE(MAX(CASE WHEN nucleo = 'marcenaria' THEN progresso END), 0),
    COUNT(*)
  INTO v_prog_arq, v_prog_eng, v_prog_marc, v_total_nucleos
  FROM contratos_nucleos
  WHERE oportunidade_id = v_oportunidade_id;

  -- Calcular progresso geral (média dos núcleos ativos)
  IF v_total_nucleos > 0 THEN
    v_prog_geral := (v_prog_arq + v_prog_eng + v_prog_marc) / v_total_nucleos;
  END IF;

  -- Atualizar oportunidade
  UPDATE oportunidades
  SET
    progresso_arquitetura = v_prog_arq,
    progresso_engenharia = v_prog_eng,
    progresso_marcenaria = v_prog_marc,
    progresso_geral = v_prog_geral,
    atualizado_em = NOW()
  WHERE id = v_oportunidade_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
DROP TRIGGER IF EXISTS trigger_atualizar_progresso_oportunidade ON contratos_nucleos;
CREATE TRIGGER trigger_atualizar_progresso_oportunidade
  AFTER INSERT OR UPDATE OF progresso ON contratos_nucleos
  FOR EACH ROW
  EXECUTE FUNCTION atualizar_progresso_oportunidade();

-- ============================================================
-- 6. FUNÇÃO: Registrar Evento na Timeline
-- ============================================================

CREATE OR REPLACE FUNCTION registrar_timeline_evento(
  p_oportunidade_id UUID,
  p_contrato_id UUID DEFAULT NULL,
  p_nucleo VARCHAR DEFAULT NULL,
  p_origem VARCHAR DEFAULT 'sistema',
  p_tipo VARCHAR DEFAULT 'status',
  p_titulo VARCHAR DEFAULT NULL,
  p_descricao TEXT DEFAULT NULL,
  p_dados JSONB DEFAULT '{}',
  p_visivel_cliente BOOLEAN DEFAULT FALSE,
  p_usuario_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_timeline_id UUID;
  v_usuario_nome VARCHAR;
BEGIN
  -- Buscar nome do usuário (via tabela pessoas)
  IF p_usuario_id IS NOT NULL THEN
    SELECT p.nome INTO v_usuario_nome
    FROM usuarios u
    JOIN pessoas p ON p.id = u.pessoa_id
    WHERE u.id = p_usuario_id;
  END IF;

  INSERT INTO oportunidade_timeline (
    oportunidade_id, contrato_id, nucleo, origem, tipo,
    titulo, descricao, dados, visivel_cliente,
    usuario_id, usuario_nome
  ) VALUES (
    p_oportunidade_id, p_contrato_id, p_nucleo, p_origem, p_tipo,
    p_titulo, p_descricao, p_dados, p_visivel_cliente,
    p_usuario_id, v_usuario_nome
  )
  RETURNING id INTO v_timeline_id;

  RETURN v_timeline_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 7. VIEWS: Cards por Núcleo (Kanban)
-- ============================================================

-- View: Kanban Arquitetura
CREATE OR REPLACE VIEW view_kanban_arquitetura AS
SELECT
  cn.id,
  cn.contrato_id,
  cn.oportunidade_id,
  cn.status_kanban,
  cn.progresso,
  cn.data_inicio,
  cn.data_previsao,
  cn.valor_previsto,
  cn.valor_executado,
  cn.dados_especificos,
  cn.observacoes,
  cn.criado_em,
  c.numero AS contrato_numero,
  c.titulo AS contrato_titulo,
  c.cliente_id,
  p.nome AS cliente_nome,
  o.titulo AS oportunidade_titulo,
  o.area_total,
  o.tipo_projeto,
  o.endereco_obra,
  r.nome AS responsavel_nome
FROM contratos_nucleos cn
JOIN contratos c ON c.id = cn.contrato_id
LEFT JOIN pessoas p ON p.id = c.cliente_id
LEFT JOIN oportunidades o ON o.id = cn.oportunidade_id
LEFT JOIN pessoas r ON r.id = cn.responsavel_id
WHERE cn.nucleo = 'arquitetura';

-- View: Kanban Engenharia
CREATE OR REPLACE VIEW view_kanban_engenharia AS
SELECT
  cn.id,
  cn.contrato_id,
  cn.oportunidade_id,
  cn.status_kanban,
  cn.progresso,
  cn.data_inicio,
  cn.data_previsao,
  cn.valor_previsto,
  cn.valor_executado,
  cn.dados_especificos,
  cn.observacoes,
  cn.criado_em,
  c.numero AS contrato_numero,
  c.titulo AS contrato_titulo,
  c.cliente_id,
  p.nome AS cliente_nome,
  o.titulo AS oportunidade_titulo,
  o.area_total,
  o.tipo_projeto,
  o.endereco_obra,
  r.nome AS responsavel_nome
FROM contratos_nucleos cn
JOIN contratos c ON c.id = cn.contrato_id
LEFT JOIN pessoas p ON p.id = c.cliente_id
LEFT JOIN oportunidades o ON o.id = cn.oportunidade_id
LEFT JOIN pessoas r ON r.id = cn.responsavel_id
WHERE cn.nucleo = 'engenharia';

-- View: Kanban Marcenaria
CREATE OR REPLACE VIEW view_kanban_marcenaria AS
SELECT
  cn.id,
  cn.contrato_id,
  cn.oportunidade_id,
  cn.status_kanban,
  cn.progresso,
  cn.data_inicio,
  cn.data_previsao,
  cn.valor_previsto,
  cn.valor_executado,
  cn.dados_especificos,
  cn.observacoes,
  cn.criado_em,
  c.numero AS contrato_numero,
  c.titulo AS contrato_titulo,
  c.cliente_id,
  p.nome AS cliente_nome,
  o.titulo AS oportunidade_titulo,
  o.area_total,
  o.tipo_projeto,
  o.endereco_obra,
  r.nome AS responsavel_nome
FROM contratos_nucleos cn
JOIN contratos c ON c.id = cn.contrato_id
LEFT JOIN pessoas p ON p.id = c.cliente_id
LEFT JOIN oportunidades o ON o.id = cn.oportunidade_id
LEFT JOIN pessoas r ON r.id = cn.responsavel_id
WHERE cn.nucleo = 'marcenaria';

-- View: Timeline do Cliente (só eventos visíveis)
CREATE OR REPLACE VIEW view_timeline_cliente AS
SELECT
  t.id,
  t.oportunidade_id,
  t.nucleo,
  t.tipo,
  t.titulo,
  t.descricao,
  t.arquivo_url,
  t.arquivo_tipo,
  t.destaque,
  t.criado_em,
  o.titulo AS oportunidade_titulo,
  p.nome AS cliente_nome,
  p.id AS cliente_id
FROM oportunidade_timeline t
JOIN oportunidades o ON o.id = t.oportunidade_id
JOIN pessoas p ON p.id = o.cliente_id
WHERE t.visivel_cliente = TRUE
ORDER BY t.criado_em DESC;

-- ============================================================
-- 8. POLÍTICAS RLS
-- ============================================================

ALTER TABLE contratos_nucleos ENABLE ROW LEVEL SECURITY;
ALTER TABLE oportunidade_timeline ENABLE ROW LEVEL SECURITY;

-- Políticas para contratos_nucleos
DROP POLICY IF EXISTS "contratos_nucleos_select" ON contratos_nucleos;
CREATE POLICY "contratos_nucleos_select" ON contratos_nucleos
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "contratos_nucleos_all" ON contratos_nucleos;
CREATE POLICY "contratos_nucleos_all" ON contratos_nucleos
  FOR ALL USING (true);

-- Políticas para timeline
DROP POLICY IF EXISTS "timeline_select" ON oportunidade_timeline;
CREATE POLICY "timeline_select" ON oportunidade_timeline
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "timeline_insert" ON oportunidade_timeline;
CREATE POLICY "timeline_insert" ON oportunidade_timeline
  FOR INSERT WITH CHECK (true);

-- ============================================================
-- 9. DADOS INICIAIS: Status Kanban por Núcleo
-- ============================================================

-- Criar tabela de configuração de status por núcleo (se não existir)
CREATE TABLE IF NOT EXISTS config_kanban_status (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nucleo VARCHAR(50) NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  cor VARCHAR(7) DEFAULT '#5E9B94',
  ordem INT DEFAULT 0,
  ativo BOOLEAN DEFAULT TRUE,
  UNIQUE(nucleo, codigo)
);

-- Inserir status padrão
INSERT INTO config_kanban_status (nucleo, codigo, titulo, cor, ordem) VALUES
-- Arquitetura
('arquitetura', 'backlog', 'Aguardando', '#6B7280', 1),
('arquitetura', 'briefing', 'Briefing', '#8B5CF6', 2),
('arquitetura', 'projeto', 'Em Projeto', '#3B82F6', 3),
('arquitetura', 'revisao', 'Revisão', '#F59E0B', 4),
('arquitetura', 'aprovacao', 'Aprovação Cliente', '#EC4899', 5),
('arquitetura', 'execucao', 'Em Execução', '#10B981', 6),
('arquitetura', 'concluido', 'Concluído', '#059669', 7),

-- Engenharia
('engenharia', 'backlog', 'Aguardando', '#6B7280', 1),
('engenharia', 'levantamento', 'Levantamento', '#8B5CF6', 2),
('engenharia', 'projeto', 'Em Projeto', '#3B82F6', 3),
('engenharia', 'compras', 'Compras', '#F59E0B', 4),
('engenharia', 'execucao', 'Em Execução', '#10B981', 5),
('engenharia', 'acabamento', 'Acabamento', '#EC4899', 6),
('engenharia', 'concluido', 'Concluído', '#059669', 7),

-- Marcenaria
('marcenaria', 'backlog', 'Aguardando', '#6B7280', 1),
('marcenaria', 'medicao', 'Medição', '#8B5CF6', 2),
('marcenaria', 'projeto', 'Em Projeto', '#3B82F6', 3),
('marcenaria', 'producao', 'Em Produção', '#F59E0B', 4),
('marcenaria', 'montagem', 'Montagem', '#10B981', 5),
('marcenaria', 'acabamento', 'Acabamento', '#EC4899', 6),
('marcenaria', 'concluido', 'Concluído', '#059669', 7)
ON CONFLICT (nucleo, codigo) DO NOTHING;

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

SELECT 'oportunidades' as tabela,
       COUNT(*) as registros,
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'oportunidades') as colunas
UNION ALL
SELECT 'contratos_nucleos', COUNT(*),
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'contratos_nucleos')
FROM contratos_nucleos
UNION ALL
SELECT 'oportunidade_timeline', COUNT(*),
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = 'oportunidade_timeline')
FROM oportunidade_timeline
UNION ALL
SELECT 'config_kanban_status', COUNT(*), NULL
FROM config_kanban_status;
