-- ============================================================
-- MIGRATION: Sincronizar foto_url para avatar_url
-- Sistema WG Easy - Grupo WG Almeida
-- ============================================================
-- Este script copia foto_url para avatar_url onde avatar_url está vazia
-- mas foto_url tem um valor. Isso garante que todas as fotos existentes
-- sejam exibidas automaticamente no avatar.
-- ============================================================

-- 1. Ver quantos registros serão afetados (preview)
SELECT
  COUNT(*) as total_registros,
  COUNT(CASE WHEN avatar_url IS NULL AND foto_url IS NOT NULL THEN 1 END) as sera_atualizado
FROM pessoas;

-- 2. Atualizar avatar_url com foto_url onde avatar_url está vazia
UPDATE pessoas
SET
  avatar_url = foto_url,
  updated_at = NOW()
WHERE
  avatar_url IS NULL
  AND foto_url IS NOT NULL
  AND foto_url != '';

-- 3. Verificar resultado
SELECT id, nome, avatar_url, foto_url
FROM pessoas
WHERE foto_url IS NOT NULL
LIMIT 20;

-- ============================================================
-- OPCIONAL: Atualizar a view vw_usuarios_completo para incluir foto_url
-- Execute isso se a view não tiver o campo foto_url
-- ============================================================

-- DROP VIEW IF EXISTS vw_usuarios_completo;
-- CREATE OR REPLACE VIEW vw_usuarios_completo AS
-- SELECT
--   u.*,
--   p.nome,
--   p.email,
--   p.telefone,
--   COALESCE(p.avatar_url, p.foto_url) as avatar_url,
--   p.foto_url
-- FROM usuarios u
-- LEFT JOIN pessoas p ON u.pessoa_id = p.id;
