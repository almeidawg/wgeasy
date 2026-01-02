-- Correção de tipo de usuário: Restaurar MASTER/Founder & CEO
-- Data: 2 de Janeiro, 2026

-- ⚠️ IMPORTANTE: Primeiro, vamos inspecionar a estrutura da tabela usuarios
-- Execute isto para ver quais colunas existem:

-- \d usuarios

-- ============================================================
-- OPÇÃO 1: Se a tabela tem coluna 'email'
-- ============================================================

UPDATE usuarios
SET tipo_usuario = 'MASTER'
WHERE email = 'william@wgalmeida.com.br'
AND tipo_usuario = 'COLABORADOR';

-- ============================================================
-- OPÇÃO 2: Se a tabela NÃO tem coluna 'email' (use auth_user_id via auth.users)
-- ============================================================

-- Primeiro, encontre o auth_user_id do seu email
-- SELECT id FROM auth.users WHERE email = 'william@wgalmeida.com.br';

-- Depois use este comando (substitua YOUR_UUID pelo id retornado):
UPDATE usuarios
SET tipo_usuario = 'MASTER'
WHERE auth_user_id = 'YOUR_UUID'
AND tipo_usuario = 'COLABORADOR';

-- ============================================================
-- OPÇÃO 3: Se a tabela tem pessoa_id (relacionada com pessoas table)
-- ============================================================

-- Encontre a pessoa associada
SELECT p.id, p.email, u.id, u.tipo_usuario
FROM pessoas p
LEFT JOIN usuarios u ON u.pessoa_id = p.id
WHERE p.email = 'william@wgalmeida.com.br';

-- Depois atualize (substitua pessoa_id se necessário):
UPDATE usuarios
SET tipo_usuario = 'MASTER'
WHERE pessoa_id IN (
  SELECT id FROM pessoas WHERE email = 'william@wgalmeida.com.br'
)
AND tipo_usuario = 'COLABORADOR';

-- ============================================================
-- VERIFICAÇÃO FINAL - Execute após a atualização
-- ============================================================

-- Ver estrutura da tabela
\d usuarios

-- Ver seu usuário (se houver email)
SELECT * FROM usuarios WHERE tipo_usuario = 'MASTER';

-- Ver email no auth.users
SELECT id, email FROM auth.users WHERE email = 'william@wgalmeida.com.br';

-- Ver todos os usuários MASTER
SELECT
  u.id,
  u.auth_user_id,
  u.tipo_usuario,
  u.ativo,
  u.created_at,
  p.email as pessoa_email
FROM usuarios u
LEFT JOIN pessoas p ON u.pessoa_id = p.id
WHERE u.tipo_usuario = 'MASTER'
ORDER BY u.created_at DESC;
