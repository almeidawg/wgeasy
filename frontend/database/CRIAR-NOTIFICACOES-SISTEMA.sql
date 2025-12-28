-- ============================================================
-- CRIAR TABELA: notificacoes_sistema
-- Sistema WG Easy - Grupo WG Almeida
-- Notificações internas do sistema
-- ============================================================

-- Dropar tabela se existir (para recriar limpa)
DROP TABLE IF EXISTS notificacoes_sistema CASCADE;

-- Criar tabela de notificações
CREATE TABLE notificacoes_sistema (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Tipo e conteúdo
  tipo TEXT NOT NULL DEFAULT 'geral',
  titulo TEXT NOT NULL,
  mensagem TEXT,

  -- Relacionamentos opcionais (sem FK para evitar erros)
  pessoa_id UUID,
  referencia_tipo TEXT, -- 'cliente', 'proposta', 'contrato', etc.
  referencia_id UUID,

  -- Status
  lida BOOLEAN DEFAULT FALSE,
  lida_em TIMESTAMPTZ,
  lida_por UUID,

  -- Prioridade
  prioridade TEXT DEFAULT 'normal',

  -- Metadados
  dados JSONB DEFAULT '{}',

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  criado_por UUID
);

-- Índices para performance
CREATE INDEX idx_notificacoes_sistema_tipo ON notificacoes_sistema(tipo);
CREATE INDEX idx_notificacoes_sistema_lida ON notificacoes_sistema(lida);
CREATE INDEX idx_notificacoes_sistema_pessoa ON notificacoes_sistema(pessoa_id);
CREATE INDEX idx_notificacoes_sistema_criado ON notificacoes_sistema(criado_em DESC);

-- Comentários
COMMENT ON TABLE notificacoes_sistema IS 'Notificações internas do sistema WG Easy';

-- Habilitar RLS
ALTER TABLE notificacoes_sistema ENABLE ROW LEVEL SECURITY;

-- Política: Todos autenticados podem ver
CREATE POLICY "Autenticados podem ver notificações"
  ON notificacoes_sistema FOR SELECT
  TO authenticated
  USING (true);

-- Política: Todos autenticados podem inserir
CREATE POLICY "Autenticados podem criar notificações"
  ON notificacoes_sistema FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Política: Todos autenticados podem atualizar
CREATE POLICY "Autenticados podem atualizar notificações"
  ON notificacoes_sistema FOR UPDATE
  TO authenticated
  USING (true);

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================
SELECT 'Tabela notificacoes_sistema criada com sucesso!' as status;
