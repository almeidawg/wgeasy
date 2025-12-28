-- ============================================================
-- CORREÇÃO: Tabela ceo_checklist_itens
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- PROBLEMA 1: Coluna criado_por pode não existir
-- PROBLEMA 2: Falta de índices para performance
-- ============================================================

-- 1. Adicionar coluna criado_por se não existir
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'ceo_checklist_itens'
    AND column_name = 'criado_por'
  ) THEN
    ALTER TABLE ceo_checklist_itens
    ADD COLUMN criado_por UUID REFERENCES usuarios(id);

    RAISE NOTICE 'Coluna criado_por adicionada com sucesso!';
  ELSE
    RAISE NOTICE 'Coluna criado_por já existe.';
  END IF;
END $$;

-- 2. Criar índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_ceo_checklist_itens_checklist_id
ON ceo_checklist_itens(checklist_id);

CREATE INDEX IF NOT EXISTS idx_ceo_checklist_itens_ordem
ON ceo_checklist_itens(checklist_id, ordem DESC);

CREATE INDEX IF NOT EXISTS idx_ceo_checklist_itens_criado_por
ON ceo_checklist_itens(criado_por)
WHERE criado_por IS NOT NULL;

-- 3. Verificar se a tabela ceo_checklist_mencoes existe
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'ceo_checklist_mencoes'
  ) THEN
    -- Criar tabela de menções
    CREATE TABLE ceo_checklist_mencoes (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      item_id UUID NOT NULL REFERENCES ceo_checklist_itens(id) ON DELETE CASCADE,
      usuario_mencionado_id UUID NOT NULL REFERENCES usuarios(id),
      usuario_autor_id UUID NOT NULL REFERENCES usuarios(id),
      lido BOOLEAN DEFAULT false,
      created_at TIMESTAMPTZ DEFAULT now()
    );

    -- Índices para a tabela de menções
    CREATE INDEX idx_mencoes_usuario_mencionado
    ON ceo_checklist_mencoes(usuario_mencionado_id, lido);

    CREATE INDEX idx_mencoes_item
    ON ceo_checklist_mencoes(item_id);

    -- RLS
    ALTER TABLE ceo_checklist_mencoes ENABLE ROW LEVEL SECURITY;

    -- Policy: usuário pode ver menções onde foi mencionado ou onde é autor
    CREATE POLICY "Usuarios podem ver suas mencoes"
    ON ceo_checklist_mencoes
    FOR SELECT
    USING (
      usuario_mencionado_id = auth.uid()
      OR usuario_autor_id = auth.uid()
    );

    -- Policy: qualquer usuário autenticado pode criar menções
    CREATE POLICY "Usuarios podem criar mencoes"
    ON ceo_checklist_mencoes
    FOR INSERT
    WITH CHECK (auth.uid() IS NOT NULL);

    -- Policy: usuário mencionado pode marcar como lido
    CREATE POLICY "Usuarios podem atualizar suas mencoes"
    ON ceo_checklist_mencoes
    FOR UPDATE
    USING (usuario_mencionado_id = auth.uid());

    RAISE NOTICE 'Tabela ceo_checklist_mencoes criada com sucesso!';
  ELSE
    RAISE NOTICE 'Tabela ceo_checklist_mencoes já existe.';
  END IF;
END $$;

-- 4. Atualizar RLS da tabela ceo_checklist_itens para permitir insert com criado_por
DO $$
BEGIN
  -- Verificar se existe política que bloqueia insert
  -- Se a política existir, recriar para permitir criado_por
  DROP POLICY IF EXISTS "Usuarios podem criar itens no checklist" ON ceo_checklist_itens;

  CREATE POLICY "Usuarios podem criar itens no checklist"
  ON ceo_checklist_itens
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM ceo_checklist_diario
      WHERE id = checklist_id
      AND usuario_id = auth.uid()
    )
    OR criado_por = auth.uid()
  );

  RAISE NOTICE 'Policy de INSERT atualizada!';
EXCEPTION
  WHEN undefined_table THEN
    RAISE NOTICE 'Tabela ceo_checklist_itens não existe ainda.';
END $$;

-- 5. Verificação final
SELECT
  'ceo_checklist_itens' as tabela,
  COUNT(*) as total_registros,
  COUNT(*) FILTER (WHERE criado_por IS NOT NULL) as com_criado_por
FROM ceo_checklist_itens;
