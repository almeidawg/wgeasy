-- ============================================================
-- CRIAR FUNÇÃO PARA CRIAR USUÁRIO NO AUTH + TABELA USUARIOS
-- Execute no Supabase SQL Editor
-- ============================================================

-- IMPORTANTE: Esta função usa a extensão supabase_auth_admin
-- que permite criar usuários diretamente no auth.users

-- ============================================================
-- PASSO 1: HABILITAR EXTENSÃO (se não estiver)
-- ============================================================
-- A criação de usuários no Auth via SQL requer a extensão
-- "supabase_auth_admin" ou usar Edge Functions

-- ============================================================
-- PASSO 2: CRIAR A FUNÇÃO criar_usuario_admin
-- ============================================================

CREATE OR REPLACE FUNCTION criar_usuario_admin(
    p_email TEXT,
    p_senha TEXT,
    p_pessoa_id UUID,
    p_tipo_usuario TEXT DEFAULT 'CLIENTE'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_auth_user_id UUID;
    v_usuario_id UUID;
    v_pessoa RECORD;
    v_resultado JSONB;
BEGIN
    -- Validar email
    IF p_email IS NULL OR p_email = '' THEN
        RETURN jsonb_build_object('sucesso', false, 'erro', 'Email é obrigatório');
    END IF;

    -- Validar senha
    IF p_senha IS NULL OR LENGTH(p_senha) < 6 THEN
        RETURN jsonb_build_object('sucesso', false, 'erro', 'Senha deve ter pelo menos 6 caracteres');
    END IF;

    -- Buscar pessoa
    SELECT id, cpf, nome INTO v_pessoa
    FROM pessoas
    WHERE id = p_pessoa_id;

    IF v_pessoa.id IS NULL THEN
        RETURN jsonb_build_object('sucesso', false, 'erro', 'Pessoa não encontrada');
    END IF;

    -- Verificar se já existe usuário para essa pessoa
    SELECT id INTO v_usuario_id
    FROM usuarios
    WHERE pessoa_id = p_pessoa_id;

    IF v_usuario_id IS NOT NULL THEN
        RETURN jsonb_build_object('sucesso', false, 'erro', 'Já existe usuário para esta pessoa', 'usuario_id', v_usuario_id);
    END IF;

    -- Verificar se email já existe no auth
    SELECT id INTO v_auth_user_id
    FROM auth.users
    WHERE email = LOWER(p_email);

    IF v_auth_user_id IS NOT NULL THEN
        -- Usuário já existe no Auth, apenas vincular
        INSERT INTO usuarios (
            auth_user_id,
            pessoa_id,
            cpf,
            tipo_usuario,
            ativo,
            primeiro_acesso,
            criado_em,
            atualizado_em
        ) VALUES (
            v_auth_user_id,
            p_pessoa_id,
            COALESCE(v_pessoa.cpf, ''),
            p_tipo_usuario,
            true,
            true,
            NOW(),
            NOW()
        )
        RETURNING id INTO v_usuario_id;

        RETURN jsonb_build_object(
            'sucesso', true,
            'usuario_id', v_usuario_id,
            'auth_user_id', v_auth_user_id,
            'mensagem', 'Email já existia no Auth. Vinculado à pessoa. Use recuperação de senha.'
        );
    END IF;

    -- Criar usuário no Auth usando a função interna do Supabase
    -- NOTA: Esta parte requer permissões especiais ou Edge Function
    -- Por isso, vamos criar apenas o registro na tabela usuarios
    -- e o auth será criado via API

    -- Gerar UUID para o auth_user_id (será atualizado quando o usuário for criado via API)
    v_auth_user_id := gen_random_uuid();

    -- Criar registro na tabela usuarios
    INSERT INTO usuarios (
        id,
        auth_user_id,
        pessoa_id,
        cpf,
        tipo_usuario,
        ativo,
        primeiro_acesso,
        cliente_pode_ver_valores,
        cliente_pode_ver_cronograma,
        cliente_pode_ver_documentos,
        cliente_pode_ver_proposta,
        cliente_pode_ver_contratos,
        cliente_pode_fazer_upload,
        cliente_pode_comentar,
        criado_em,
        atualizado_em
    ) VALUES (
        gen_random_uuid(),
        NULL, -- Será preenchido quando criar no Auth
        p_pessoa_id,
        COALESCE(v_pessoa.cpf, ''),
        p_tipo_usuario,
        true,
        true,
        false,
        true,
        true,
        true,
        true,
        false,
        true,
        NOW(),
        NOW()
    )
    RETURNING id INTO v_usuario_id;

    RETURN jsonb_build_object(
        'sucesso', true,
        'usuario_id', v_usuario_id,
        'email', p_email,
        'mensagem', 'Registro criado. Use a API para criar no Auth.'
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object('sucesso', false, 'erro', SQLERRM);
END;
$$;

-- ============================================================
-- PASSO 3: CRIAR FUNÇÃO PARA VINCULAR AUTH_USER_ID
-- ============================================================

CREATE OR REPLACE FUNCTION vincular_auth_user(
    p_usuario_id UUID,
    p_auth_user_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE usuarios
    SET
        auth_user_id = p_auth_user_id,
        atualizado_em = NOW()
    WHERE id = p_usuario_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('sucesso', false, 'erro', 'Usuário não encontrado');
    END IF;

    RETURN jsonb_build_object('sucesso', true, 'mensagem', 'Auth user vinculado com sucesso');
END;
$$;

-- ============================================================
-- PASSO 4: TRIGGER PARA VINCULAR AUTOMATICAMENTE
-- ============================================================

-- Quando um novo usuário é criado no Auth, vincular automaticamente
-- se existir um registro na tabela usuarios com o mesmo email

CREATE OR REPLACE FUNCTION vincular_usuario_ao_auth()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_pessoa_id UUID;
BEGIN
    -- Buscar pessoa pelo email
    SELECT id INTO v_pessoa_id
    FROM pessoas
    WHERE LOWER(email) = LOWER(NEW.email)
    LIMIT 1;

    IF v_pessoa_id IS NOT NULL THEN
        -- Atualizar ou criar usuário
        UPDATE usuarios
        SET
            auth_user_id = NEW.id,
            atualizado_em = NOW()
        WHERE pessoa_id = v_pessoa_id AND auth_user_id IS NULL;

        -- Se não atualizou nenhum, pode criar um novo
        IF NOT FOUND THEN
            INSERT INTO usuarios (
                auth_user_id,
                pessoa_id,
                cpf,
                tipo_usuario,
                ativo,
                primeiro_acesso,
                criado_em,
                atualizado_em
            )
            SELECT
                NEW.id,
                p.id,
                COALESCE(p.cpf, ''),
                CASE
                    WHEN p.tipo = 'CLIENTE' THEN 'CLIENTE'
                    WHEN p.tipo = 'COLABORADOR' THEN 'COLABORADOR'
                    WHEN p.tipo = 'FORNECEDOR' THEN 'FORNECEDOR'
                    ELSE 'CLIENTE'
                END,
                true,
                true,
                NOW(),
                NOW()
            FROM pessoas p
            WHERE p.id = v_pessoa_id
            ON CONFLICT DO NOTHING;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

-- Criar o trigger (se não existir)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION vincular_usuario_ao_auth();

-- ============================================================
-- PASSO 5: VERIFICAR USUÁRIOS SEM AUTH
-- ============================================================

-- Listar usuários que precisam de acesso Auth
SELECT
    u.id as usuario_id,
    u.pessoa_id,
    u.auth_user_id,
    u.tipo_usuario,
    p.nome,
    p.email,
    p.cpf,
    CASE
        WHEN u.auth_user_id IS NULL THEN '❌ SEM AUTH'
        ELSE '✅ COM AUTH'
    END as status_auth
FROM usuarios u
JOIN pessoas p ON p.id = u.pessoa_id
WHERE u.auth_user_id IS NULL
ORDER BY p.nome;

-- ============================================================
-- GRANT PERMISSIONS
-- ============================================================
GRANT EXECUTE ON FUNCTION criar_usuario_admin TO authenticated;
GRANT EXECUTE ON FUNCTION criar_usuario_admin TO service_role;
GRANT EXECUTE ON FUNCTION vincular_auth_user TO authenticated;
GRANT EXECUTE ON FUNCTION vincular_auth_user TO service_role;
