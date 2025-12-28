-- ============================================================
-- CRIAR ACESSO PARA CLIENTE: rsl.saopaulo@gmail.com
-- Execute no Supabase SQL Editor
-- ============================================================

-- PASSO 1: Verificar se o cliente existe
SELECT
    id,
    nome,
    email,
    cpf,
    telefone,
    tipo
FROM pessoas
WHERE id = 'a8921a1a-4c1f-4cd5-b8e3-f72d951dc951';

-- PASSO 2: Verificar se já tem usuário
SELECT u.*, p.nome, p.email
FROM usuarios u
JOIN pessoas p ON p.id = u.pessoa_id
WHERE u.pessoa_id = 'a8921a1a-4c1f-4cd5-b8e3-f72d951dc951';

-- PASSO 3: Verificar se o email existe no Auth
-- (Precisa verificar manualmente no Supabase Dashboard > Authentication > Users)

-- ============================================================
-- SE O CLIENTE NÃO TEM ACESSO, CRIAR VIA FUNÇÃO ADMIN:
-- ============================================================

-- OPÇÃO A: Usar a função criar_usuario_admin (se existir)
SELECT criar_usuario_admin(
    'rsl.saopaulo@gmail.com',  -- p_email
    'RSL2024!',                 -- p_senha (senha temporária)
    'a8921a1a-4c1f-4cd5-b8e3-f72d951dc951',  -- p_pessoa_id
    'CLIENTE'                   -- p_tipo_usuario
);

-- OPÇÃO B: Resetar senha se já existe no Auth
-- Vá em Supabase Dashboard > Authentication > Users
-- Encontre o email rsl.saopaulo@gmail.com
-- Clique em "..." > "Send password recovery"

-- ============================================================
-- SENHA SUGERIDA PARA ENVIAR AO CLIENTE: RSL2024!
-- ============================================================
