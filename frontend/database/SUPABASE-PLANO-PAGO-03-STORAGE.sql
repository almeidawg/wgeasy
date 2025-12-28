-- ============================================================
-- SUPABASE PLANO PAGO - PARTE 3: Storage Transformations
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- Storage Transformations permite redimensionar imagens on-the-fly
-- e gerar thumbnails automaticamente sem precisar de CDN externo.
--
-- DOCUMENTAÇÃO: https://supabase.com/docs/guides/storage/serving/image-transformations
-- ============================================================

-- ============================================================
-- 1. CONFIGURAÇÃO DOS BUCKETS
-- ============================================================

-- Buckets devem ser criados via Dashboard ou API
-- Aqui documentamos a estrutura recomendada
--
-- BUCKETS RECOMENDADOS:
--
-- 1. avatars
--    - Público: SIM
--    - Tamanho máximo: 2MB
--    - Tipos: image/jpeg, image/png, image/webp
--    - Uso: Fotos de perfil de usuários
--
-- 2. documentos
--    - Público: NÃO (autenticado)
--    - Tamanho máximo: 50MB
--    - Tipos: application/pdf, image/*, .dwg, .dxf
--    - Uso: Documentos de projeto, contratos, plantas
--
-- 3. obras
--    - Público: NÃO (autenticado)
--    - Tamanho máximo: 20MB
--    - Tipos: image/*
--    - Uso: Fotos de acompanhamento de obras
--
-- 4. produtos
--    - Público: SIM
--    - Tamanho máximo: 10MB
--    - Tipos: image/*
--    - Uso: Fotos de produtos do catálogo
--
-- 5. temp
--    - Público: NÃO
--    - Tamanho máximo: 50MB
--    - Tipos: *
--    - Uso: Uploads temporários (limpar via cron)

-- ============================================================
-- 2. POLÍTICAS DE STORAGE RLS
-- ============================================================

-- Política: Avatars (público para leitura)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true);

-- Política para avatars - qualquer um pode ler
CREATE POLICY "avatars_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');

-- Política para avatars - usuário autenticado pode inserir seu próprio
CREATE POLICY "avatars_auth_insert" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars'
    AND auth.role() = 'authenticated'
  );

-- Política para avatars - usuário pode atualizar/deletar seu próprio
CREATE POLICY "avatars_owner_update" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "avatars_owner_delete" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================================
-- 3. FUNÇÃO: Gerar URL com transformação
-- ============================================================

CREATE OR REPLACE FUNCTION gerar_url_imagem(
  p_bucket VARCHAR,
  p_path VARCHAR,
  p_width INT DEFAULT NULL,
  p_height INT DEFAULT NULL,
  p_quality INT DEFAULT 80,
  p_format VARCHAR DEFAULT NULL -- webp, jpeg, png
)
RETURNS TEXT AS $$
DECLARE
  v_base_url TEXT;
  v_transform_params TEXT := '';
BEGIN
  -- URL base do projeto Supabase (ajustar conforme necessário)
  v_base_url := current_setting('app.settings.supabase_url', true);

  IF v_base_url IS NULL THEN
    v_base_url := 'https://seu-projeto.supabase.co';
  END IF;

  -- Construir parâmetros de transformação
  IF p_width IS NOT NULL OR p_height IS NOT NULL OR p_quality != 80 OR p_format IS NOT NULL THEN
    v_transform_params := '/render/image';

    IF p_width IS NOT NULL THEN
      v_transform_params := v_transform_params || '?width=' || p_width;
    END IF;

    IF p_height IS NOT NULL THEN
      IF p_width IS NOT NULL THEN
        v_transform_params := v_transform_params || '&height=' || p_height;
      ELSE
        v_transform_params := v_transform_params || '?height=' || p_height;
      END IF;
    END IF;

    IF p_quality != 80 THEN
      IF p_width IS NOT NULL OR p_height IS NOT NULL THEN
        v_transform_params := v_transform_params || '&quality=' || p_quality;
      ELSE
        v_transform_params := v_transform_params || '?quality=' || p_quality;
      END IF;
    END IF;

    IF p_format IS NOT NULL THEN
      v_transform_params := v_transform_params || '&format=' || p_format;
    END IF;
  END IF;

  RETURN v_base_url || '/storage/v1/object/public/' || p_bucket || '/' || p_path || v_transform_params;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================
-- 4. FUNÇÃO: Gerar URLs de thumbnail padrão
-- ============================================================

CREATE OR REPLACE FUNCTION gerar_thumbnails_url(
  p_bucket VARCHAR,
  p_path VARCHAR
)
RETURNS JSONB AS $$
BEGIN
  RETURN jsonb_build_object(
    'original', gerar_url_imagem(p_bucket, p_path),
    'thumbnail', gerar_url_imagem(p_bucket, p_path, 150, 150, 70),
    'small', gerar_url_imagem(p_bucket, p_path, 300, 300, 75),
    'medium', gerar_url_imagem(p_bucket, p_path, 600, 600, 80),
    'large', gerar_url_imagem(p_bucket, p_path, 1200, 1200, 85)
  );
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================
-- 5. TABELA: arquivos_metadata (Metadados de arquivos)
-- ============================================================

CREATE TABLE IF NOT EXISTS arquivos_metadata (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bucket VARCHAR(100) NOT NULL,
  path VARCHAR(500) NOT NULL,
  nome_original VARCHAR(255) NOT NULL,
  tipo_mime VARCHAR(100),
  tamanho_bytes BIGINT,

  -- Dimensões (para imagens)
  largura INT,
  altura INT,

  -- Referências
  entidade_tipo VARCHAR(50), -- pessoa, obra, produto, documento
  entidade_id UUID,

  -- URLs geradas
  urls JSONB DEFAULT '{}',

  -- Upload info
  upload_por UUID REFERENCES usuarios(id),
  temporario BOOLEAN DEFAULT FALSE,

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(bucket, path)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_arquivos_bucket ON arquivos_metadata(bucket);
CREATE INDEX IF NOT EXISTS idx_arquivos_entidade ON arquivos_metadata(entidade_tipo, entidade_id);
CREATE INDEX IF NOT EXISTS idx_arquivos_temporario ON arquivos_metadata(temporario) WHERE temporario = TRUE;

-- ============================================================
-- 6. FUNÇÃO: Registrar upload de arquivo
-- ============================================================

CREATE OR REPLACE FUNCTION registrar_upload_arquivo(
  p_bucket VARCHAR,
  p_path VARCHAR,
  p_nome_original VARCHAR,
  p_tipo_mime VARCHAR DEFAULT NULL,
  p_tamanho_bytes BIGINT DEFAULT NULL,
  p_largura INT DEFAULT NULL,
  p_altura INT DEFAULT NULL,
  p_entidade_tipo VARCHAR DEFAULT NULL,
  p_entidade_id UUID DEFAULT NULL,
  p_temporario BOOLEAN DEFAULT FALSE
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
  v_urls JSONB;
BEGIN
  -- Gerar URLs se for imagem
  IF p_tipo_mime LIKE 'image/%' THEN
    v_urls := gerar_thumbnails_url(p_bucket, p_path);
  ELSE
    v_urls := jsonb_build_object('original', gerar_url_imagem(p_bucket, p_path));
  END IF;

  INSERT INTO arquivos_metadata (
    bucket, path, nome_original, tipo_mime, tamanho_bytes,
    largura, altura, entidade_tipo, entidade_id, urls, temporario,
    upload_por
  ) VALUES (
    p_bucket, p_path, p_nome_original, p_tipo_mime, p_tamanho_bytes,
    p_largura, p_altura, p_entidade_tipo, p_entidade_id, v_urls, p_temporario,
    auth.uid()
  )
  ON CONFLICT (bucket, path) DO UPDATE SET
    nome_original = p_nome_original,
    tipo_mime = p_tipo_mime,
    tamanho_bytes = p_tamanho_bytes,
    largura = p_largura,
    altura = p_altura,
    entidade_tipo = COALESCE(p_entidade_tipo, arquivos_metadata.entidade_tipo),
    entidade_id = COALESCE(p_entidade_id, arquivos_metadata.entidade_id),
    urls = v_urls,
    temporario = p_temporario,
    atualizado_em = NOW()
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 7. VIEW: Arquivos com URLs de transformação
-- ============================================================

CREATE OR REPLACE VIEW view_arquivos_completo AS
SELECT
  a.*,
  (a.urls->>'thumbnail') as url_thumbnail,
  (a.urls->>'small') as url_small,
  (a.urls->>'medium') as url_medium,
  (a.urls->>'large') as url_large,
  (a.urls->>'original') as url_original,
  p.nome as upload_por_nome
FROM arquivos_metadata a
LEFT JOIN usuarios u ON u.id = a.upload_por
LEFT JOIN pessoas p ON p.id = u.pessoa_id;

-- ============================================================
-- 8. FUNÇÃO: Atualizar avatar de pessoa
-- ============================================================

CREATE OR REPLACE FUNCTION atualizar_avatar_pessoa(
  p_pessoa_id UUID,
  p_bucket VARCHAR,
  p_path VARCHAR
)
RETURNS void AS $$
DECLARE
  v_url_avatar TEXT;
BEGIN
  -- Gerar URL com transformação para avatar (200x200)
  v_url_avatar := gerar_url_imagem(p_bucket, p_path, 200, 200, 85, 'webp');

  -- Atualizar pessoa
  UPDATE pessoas
  SET
    avatar_url = v_url_avatar,
    atualizado_em = NOW()
  WHERE id = p_pessoa_id;

  -- Registrar arquivo
  PERFORM registrar_upload_arquivo(
    p_bucket, p_path,
    'avatar_' || p_pessoa_id || '.webp',
    'image/webp',
    NULL, 200, 200,
    'pessoa', p_pessoa_id,
    FALSE
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 9. CONFIGURAÇÕES DE TRANSFORMAÇÃO (Referência)
-- ============================================================

-- PARÂMETROS DE TRANSFORMAÇÃO DISPONÍVEIS:
--
-- URL Base: /storage/v1/render/image/public/{bucket}/{path}
--
-- Parâmetros:
-- - width: Largura em pixels (max 2000)
-- - height: Altura em pixels (max 2000)
-- - resize: cover (padrão), contain, fill
-- - quality: 1-100 (padrão 80)
-- - format: webp, jpeg, png, avif
--
-- EXEMPLOS DE USO:
--
-- 1. Thumbnail 150x150:
--    ?width=150&height=150&resize=cover&quality=70
--
-- 2. Imagem média com WebP:
--    ?width=600&format=webp&quality=80
--
-- 3. Imagem grande mantendo proporção:
--    ?width=1200&resize=contain
--
-- 4. Avatar circular (CSS faz o crop):
--    ?width=200&height=200&resize=cover&format=webp

-- ============================================================
-- 10. RLS POLICIES
-- ============================================================

ALTER TABLE arquivos_metadata ENABLE ROW LEVEL SECURITY;

-- Leitura: usuários autenticados podem ver todos
DROP POLICY IF EXISTS "arquivos_metadata_select" ON arquivos_metadata;
CREATE POLICY "arquivos_metadata_select" ON arquivos_metadata
  FOR SELECT USING (auth.role() = 'authenticated');

-- Insert: usuários autenticados
DROP POLICY IF EXISTS "arquivos_metadata_insert" ON arquivos_metadata;
CREATE POLICY "arquivos_metadata_insert" ON arquivos_metadata
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Update: apenas quem fez upload ou admin
DROP POLICY IF EXISTS "arquivos_metadata_update" ON arquivos_metadata;
CREATE POLICY "arquivos_metadata_update" ON arquivos_metadata
  FOR UPDATE USING (
    auth.uid() = upload_por
    OR EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.auth_user_id = auth.uid()
      AND u.tipo_usuario IN ('MASTER', 'ADMIN')
    )
  );

-- Delete: apenas quem fez upload ou admin
DROP POLICY IF EXISTS "arquivos_metadata_delete" ON arquivos_metadata;
CREATE POLICY "arquivos_metadata_delete" ON arquivos_metadata
  FOR DELETE USING (
    auth.uid() = upload_por
    OR EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.auth_user_id = auth.uid()
      AND u.tipo_usuario IN ('MASTER', 'ADMIN')
    )
  );

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

SELECT 'arquivos_metadata' as tabela, COUNT(*) as registros FROM arquivos_metadata;

-- Testar função de URL
SELECT gerar_url_imagem('avatars', 'test/foto.jpg', 200, 200, 85, 'webp') as url_teste;

-- Testar função de thumbnails
SELECT gerar_thumbnails_url('avatars', 'test/foto.jpg') as urls_teste;
