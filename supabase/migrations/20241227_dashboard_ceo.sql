-- ============================================================
-- MIGRATION: Dashboard CEO - Frases Motivacionais e Checklist
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- SUPABASE STUDIO - TABELAS:
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/frases_motivacionais
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/ceo_checklist_diario
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/ceo_checklist_itens
--
-- ============================================================

-- ============================================================
-- 1. TABELA: frases_motivacionais
-- Frases de impacto para o Dashboard do CEO
-- ============================================================
CREATE TABLE IF NOT EXISTS frases_motivacionais (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  frase TEXT NOT NULL,
  autor VARCHAR(100) DEFAULT 'Grupo WG Almeida',
  categoria VARCHAR(50), -- 'lideranca', 'sucesso', 'equipe', 'cliente', 'excelencia'
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índice para buscar frases ativas
CREATE INDEX IF NOT EXISTS idx_frases_motivacionais_ativo ON frases_motivacionais(ativo);

-- Inserir frases iniciais do Grupo WG Almeida
INSERT INTO frases_motivacionais (frase, autor, categoria) VALUES
  ('Excelência não é um ato, é um hábito.', 'Aristóteles / WG Almeida', 'excelencia'),
  ('Construímos sonhos, entregamos realidade.', 'Grupo WG Almeida', 'cliente'),
  ('Cada detalhe importa quando se busca a perfeição.', 'Grupo WG Almeida', 'excelencia'),
  ('O sucesso é a soma de pequenos esforços repetidos dia após dia.', 'Robert Collier / WG Almeida', 'sucesso'),
  ('Liderança é a capacidade de transformar visão em realidade.', 'Warren Bennis / WG Almeida', 'lideranca'),
  ('A qualidade nunca é um acidente. É sempre o resultado de um esforço inteligente.', 'John Ruskin / WG Almeida', 'excelencia'),
  ('Nossos clientes são parceiros na jornada de transformar espaços.', 'Grupo WG Almeida', 'cliente'),
  ('Juntos, construímos mais do que obras - construímos legados.', 'Grupo WG Almeida', 'equipe'),
  ('A inovação distingue um líder de um seguidor.', 'Steve Jobs / WG Almeida', 'lideranca'),
  ('Compromisso com a excelência é o que nos diferencia.', 'Grupo WG Almeida', 'excelencia'),
  ('O melhor momento para plantar uma árvore foi há 20 anos. O segundo melhor é agora.', 'Provérbio Chinês / WG Almeida', 'sucesso'),
  ('Arquitetura é a vontade de uma época traduzida em espaço.', 'Ludwig Mies van der Rohe / WG Almeida', 'excelencia'),
  ('O único lugar onde o sucesso vem antes do trabalho é no dicionário.', 'Vidal Sassoon / WG Almeida', 'sucesso'),
  ('Grandes equipes constroem grandes resultados.', 'Grupo WG Almeida', 'equipe'),
  ('A satisfação do cliente é nossa maior recompensa.', 'Grupo WG Almeida', 'cliente')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. TABELA: ceo_checklist_diario
-- Checklist diário do CEO/Founder
-- ============================================================
CREATE TABLE IF NOT EXISTS ceo_checklist_diario (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data DATE NOT NULL,
  usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(data, usuario_id)
);

-- Índices para busca eficiente
CREATE INDEX IF NOT EXISTS idx_ceo_checklist_diario_data ON ceo_checklist_diario(data);
CREATE INDEX IF NOT EXISTS idx_ceo_checklist_diario_usuario ON ceo_checklist_diario(usuario_id);

-- ============================================================
-- 3. TABELA: ceo_checklist_itens
-- Itens do checklist diário
-- ============================================================
CREATE TABLE IF NOT EXISTS ceo_checklist_itens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  checklist_id UUID NOT NULL REFERENCES ceo_checklist_diario(id) ON DELETE CASCADE,
  texto TEXT NOT NULL,
  prioridade VARCHAR(20) DEFAULT 'media' CHECK (prioridade IN ('alta', 'media', 'baixa')),
  concluido BOOLEAN DEFAULT false,
  concluido_em TIMESTAMPTZ,
  ordem INTEGER DEFAULT 0,
  fonte VARCHAR(50) DEFAULT 'manual' CHECK (fonte IN ('manual', 'mencao', 'automatico', 'recorrente')),
  referencia_id UUID, -- ID da tarefa/menção original (se aplicável)
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para busca eficiente
CREATE INDEX IF NOT EXISTS idx_ceo_checklist_itens_checklist ON ceo_checklist_itens(checklist_id);
CREATE INDEX IF NOT EXISTS idx_ceo_checklist_itens_concluido ON ceo_checklist_itens(concluido);

-- ============================================================
-- 4. FUNÇÃO: Copiar itens não concluídos para o próximo dia
-- ============================================================
CREATE OR REPLACE FUNCTION copiar_checklist_nao_concluido(
  p_usuario_id UUID,
  p_data_origem DATE,
  p_data_destino DATE
) RETURNS UUID AS $$
DECLARE
  v_checklist_origem_id UUID;
  v_checklist_destino_id UUID;
BEGIN
  -- Buscar checklist de origem
  SELECT id INTO v_checklist_origem_id
  FROM ceo_checklist_diario
  WHERE usuario_id = p_usuario_id AND data = p_data_origem;

  IF v_checklist_origem_id IS NULL THEN
    RETURN NULL;
  END IF;

  -- Criar ou buscar checklist de destino
  INSERT INTO ceo_checklist_diario (data, usuario_id)
  VALUES (p_data_destino, p_usuario_id)
  ON CONFLICT (data, usuario_id) DO UPDATE SET updated_at = NOW()
  RETURNING id INTO v_checklist_destino_id;

  -- Copiar itens não concluídos
  INSERT INTO ceo_checklist_itens (checklist_id, texto, prioridade, ordem, fonte)
  SELECT
    v_checklist_destino_id,
    texto,
    prioridade,
    ordem,
    'recorrente'
  FROM ceo_checklist_itens
  WHERE checklist_id = v_checklist_origem_id
    AND concluido = false
    AND NOT EXISTS (
      -- Evitar duplicatas
      SELECT 1 FROM ceo_checklist_itens ci2
      WHERE ci2.checklist_id = v_checklist_destino_id
        AND ci2.texto = ceo_checklist_itens.texto
    );

  RETURN v_checklist_destino_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 5. POLÍTICAS RLS (Row Level Security)
-- ============================================================
ALTER TABLE frases_motivacionais ENABLE ROW LEVEL SECURITY;
ALTER TABLE ceo_checklist_diario ENABLE ROW LEVEL SECURITY;
ALTER TABLE ceo_checklist_itens ENABLE ROW LEVEL SECURITY;

-- Frases: todos podem ler, apenas admins podem inserir/atualizar
CREATE POLICY "frases_select_all" ON frases_motivacionais
  FOR SELECT USING (true);

CREATE POLICY "frases_insert_admin" ON frases_motivacionais
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.auth_user_id = auth.uid()
      AND u.tipo_usuario IN ('MASTER', 'ADMIN')
    )
  );

-- Checklist: usuário vê apenas seus próprios
CREATE POLICY "checklist_select_own" ON ceo_checklist_diario
  FOR SELECT USING (
    usuario_id IN (
      SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "checklist_insert_own" ON ceo_checklist_diario
  FOR INSERT WITH CHECK (
    usuario_id IN (
      SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
    )
  );

CREATE POLICY "checklist_update_own" ON ceo_checklist_diario
  FOR UPDATE USING (
    usuario_id IN (
      SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
    )
  );

-- Itens do checklist: baseado no checklist pai
CREATE POLICY "checklist_itens_select" ON ceo_checklist_itens
  FOR SELECT USING (
    checklist_id IN (
      SELECT id FROM ceo_checklist_diario
      WHERE usuario_id IN (
        SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
      )
    )
  );

CREATE POLICY "checklist_itens_insert" ON ceo_checklist_itens
  FOR INSERT WITH CHECK (
    checklist_id IN (
      SELECT id FROM ceo_checklist_diario
      WHERE usuario_id IN (
        SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
      )
    )
  );

CREATE POLICY "checklist_itens_update" ON ceo_checklist_itens
  FOR UPDATE USING (
    checklist_id IN (
      SELECT id FROM ceo_checklist_diario
      WHERE usuario_id IN (
        SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
      )
    )
  );

CREATE POLICY "checklist_itens_delete" ON ceo_checklist_itens
  FOR DELETE USING (
    checklist_id IN (
      SELECT id FROM ceo_checklist_diario
      WHERE usuario_id IN (
        SELECT id FROM usuarios WHERE auth_user_id = auth.uid()
      )
    )
  );

-- ============================================================
-- FIM DA MIGRATION
-- ============================================================
