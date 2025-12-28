-- ============================================
-- LIMPAR USUARIOS ORFAOS
-- Data: 2024-12-27
-- Problema: 16 usuarios referenciam pessoas que nao existem
-- ============================================

-- Verificar antes de deletar
SELECT
    u.id,
    u.tipo_usuario,
    u.pessoa_id,
    CASE WHEN p.id IS NULL THEN 'ORFAO' ELSE 'OK' END as status
FROM usuarios u
LEFT JOIN pessoas p ON u.pessoa_id = p.id;

-- Deletar usuarios orfaos (onde pessoa_id nao existe em pessoas)
DELETE FROM usuarios
WHERE pessoa_id NOT IN (SELECT id FROM pessoas WHERE id IS NOT NULL);

-- Verificar resultado
SELECT COUNT(*) as usuarios_restantes FROM usuarios;
SELECT COUNT(*) as pessoas_total FROM pessoas;
