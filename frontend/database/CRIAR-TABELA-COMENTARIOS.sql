-- ============================================================
-- CRIAÇÃO: Tabelas de Comentários para Tasks
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2025-12-28
-- ============================================================
--
-- Este script é idempotente - pode ser executado múltiplas vezes
-- sem causar erros.
--
-- ============================================================

-- ============================================================
-- PASSO 1: Criar tabelas
-- ============================================================

-- Tabela de comentários
CREATE TABLE IF NOT EXISTS project_tasks_comentarios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id UUID NOT NULL,
  usuario_id UUID NOT NULL,
  usuario_nome VARCHAR(255) NOT NULL,
  usuario_avatar TEXT,
  comentario TEXT NOT NULL,
  mencoes TEXT[] DEFAULT '{}',
  editado BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de notificações
CREATE TABLE IF NOT EXISTS comentarios_notificacoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  comentario_id UUID NOT NULL REFERENCES project_tasks_comentarios(id) ON DELETE CASCADE,
  usuario_id UUID NOT NULL,
  lida BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- PASSO 2: Criar índices (IF NOT EXISTS)
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_ptc_task_id ON project_tasks_comentarios(task_id);
CREATE INDEX IF NOT EXISTS idx_ptc_usuario_id ON project_tasks_comentarios(usuario_id);
CREATE INDEX IF NOT EXISTS idx_ptc_created_at ON project_tasks_comentarios(created_at);
CREATE INDEX IF NOT EXISTS idx_ptc_mencoes ON project_tasks_comentarios USING GIN(mencoes);

CREATE INDEX IF NOT EXISTS idx_cn_usuario_id ON comentarios_notificacoes(usuario_id);
CREATE INDEX IF NOT EXISTS idx_cn_lida ON comentarios_notificacoes(lida);
CREATE INDEX IF NOT EXISTS idx_cn_comentario_id ON comentarios_notificacoes(comentario_id);

-- ============================================================
-- PASSO 3: Habilitar RLS
-- ============================================================

ALTER TABLE project_tasks_comentarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE comentarios_notificacoes ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- PASSO 4: Remover políticas antigas (se existirem)
-- ============================================================

DROP POLICY IF EXISTS "ptc_select_all" ON project_tasks_comentarios;
DROP POLICY IF EXISTS "ptc_insert_authenticated" ON project_tasks_comentarios;
DROP POLICY IF EXISTS "ptc_update_own" ON project_tasks_comentarios;
DROP POLICY IF EXISTS "ptc_delete_own" ON project_tasks_comentarios;

DROP POLICY IF EXISTS "cn_select_own" ON comentarios_notificacoes;
DROP POLICY IF EXISTS "cn_insert_authenticated" ON comentarios_notificacoes;
DROP POLICY IF EXISTS "cn_update_own" ON comentarios_notificacoes;
DROP POLICY IF EXISTS "cn_delete_own" ON comentarios_notificacoes;

-- ============================================================
-- PASSO 5: Criar novas políticas RLS
-- ============================================================

-- Políticas para project_tasks_comentarios
CREATE POLICY "ptc_select_all" ON project_tasks_comentarios
  FOR SELECT USING (true);

CREATE POLICY "ptc_insert_authenticated" ON project_tasks_comentarios
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "ptc_update_own" ON project_tasks_comentarios
  FOR UPDATE USING (usuario_id = auth.uid());

CREATE POLICY "ptc_delete_own" ON project_tasks_comentarios
  FOR DELETE USING (usuario_id = auth.uid());

-- Políticas para comentarios_notificacoes
CREATE POLICY "cn_select_own" ON comentarios_notificacoes
  FOR SELECT USING (usuario_id = auth.uid());

CREATE POLICY "cn_insert_authenticated" ON comentarios_notificacoes
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "cn_update_own" ON comentarios_notificacoes
  FOR UPDATE USING (usuario_id = auth.uid());

CREATE POLICY "cn_delete_own" ON comentarios_notificacoes
  FOR DELETE USING (usuario_id = auth.uid());

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

SELECT 'Tabelas criadas com sucesso!' as status;

SELECT tablename, rowsecurity
FROM pg_tables
WHERE tablename IN ('project_tasks_comentarios', 'comentarios_notificacoes');
