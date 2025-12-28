-- ============================================================
-- FIX: Vincular usuário MASTER ao auth.users
-- Execute este SQL no Supabase SQL Editor
-- ============================================================

-- 1. VERIFICAR: Buscar o usuário pelo email
SELECT
  u.id as usuario_id,
  u.auth_user_id,
  u.tipo_usuario,
  u.ativo,
  p.id as pessoa_id,
  p.nome,
  p.email
FROM usuarios u
LEFT JOIN pessoas p ON p.id = u.pessoa_id
WHERE p.email = 'william@wgalmeida.com.br'
   OR u.auth_user_id = 'dad106de-ef0d-47fe-8bda-e2c7c95b3a23';

-- 2. VERIFICAR: Buscar na tabela auth.users
SELECT id, email, created_at
FROM auth.users
WHERE email = 'william@wgalmeida.com.br';

-- 3. VERIFICAR: Buscar pessoa pelo email
SELECT id, nome, email, tipo
FROM pessoas
WHERE email = 'william@wgalmeida.com.br';

-- ============================================================
-- CORREÇÃO: Execute após verificar os resultados acima
-- ============================================================

-- 4. ATUALIZAR o auth_user_id do usuário existente
-- (substitua os valores conforme necessário)

-- Opção A: Se o usuário existe mas auth_user_id está errado
UPDATE usuarios
SET auth_user_id = 'dad106de-ef0d-47fe-8bda-e2c7c95b3a23'
WHERE pessoa_id = (
  SELECT id FROM pessoas WHERE email = 'william@wgalmeida.com.br' LIMIT 1
);

-- 5. VERIFICAR o resultado
SELECT
  u.id,
  u.auth_user_id,
  u.tipo_usuario,
  u.ativo,
  p.nome,
  p.email
FROM usuarios u
JOIN pessoas p ON p.id = u.pessoa_id
WHERE u.auth_user_id = 'dad106de-ef0d-47fe-8bda-e2c7c95b3a23';

-- ============================================================
-- SE O USUÁRIO NÃO EXISTIR: Criar novo
-- ============================================================

-- 6. Primeiro, encontrar ou criar a pessoa
-- (execute apenas se a pessoa não existir)
/*
INSERT INTO pessoas (nome, email, tipo, ativo)
VALUES ('William', 'william@wgalmeida.com.br', 'COLABORADOR', true)
ON CONFLICT (email) DO NOTHING
RETURNING id;
*/

-- 7. Criar o usuário MASTER
-- (execute apenas se o usuário não existir)
/*
INSERT INTO usuarios (
  auth_user_id,
  pessoa_id,
  tipo_usuario,
  ativo
)
SELECT
  'dad106de-ef0d-47fe-8bda-e2c7c95b3a23',
  id,
  'MASTER',
  true
FROM pessoas
WHERE email = 'william@wgalmeida.com.br';
*/
