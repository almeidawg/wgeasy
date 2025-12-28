-- ============================================================================
-- CORREÇÕES DE AUDITORIA DO SUPABASE - WGEASY
-- Gerado em: 2025-12-27
-- IMPORTANTE: Execute cada seção separadamente e verifique os resultados
-- ============================================================================

-- ============================================================================
-- P0: CORRIGIR VÍNCULO MASTER USER
-- Prioridade: CRÍTICA - Bloqueia acesso admin
-- ============================================================================

-- 1. DIAGNÓSTICO: Verificar situação atual do usuário Master
SELECT
    'USUARIOS' as fonte,
    u.id as usuario_id,
    u.auth_user_id,
    u.tipo_usuario,
    u.ativo,
    p.id as pessoa_id,
    p.nome,
    p.email
FROM usuarios u
LEFT JOIN pessoas p ON p.id = u.pessoa_id
WHERE u.tipo_usuario = 'MASTER'
   OR p.email = 'william@wgalmeida.com.br';

-- 2. DIAGNÓSTICO: Verificar no auth.users
SELECT
    'AUTH.USERS' as fonte,
    id as auth_id,
    email,
    created_at,
    email_confirmed_at,
    last_sign_in_at
FROM auth.users
WHERE email = 'william@wgalmeida.com.br'
   OR email ILIKE '%william%';

-- 3. DIAGNÓSTICO: Verificar desalinhamentos (usuarios sem auth válido)
SELECT
    u.id as usuario_id,
    u.auth_user_id,
    u.tipo_usuario,
    p.nome,
    p.email,
    CASE WHEN a.id IS NULL THEN 'SEM VÍNCULO AUTH' ELSE 'OK' END as status
FROM usuarios u
LEFT JOIN pessoas p ON p.id = u.pessoa_id
LEFT JOIN auth.users a ON a.id = u.auth_user_id
WHERE u.auth_user_id IS NOT NULL
ORDER BY status DESC, u.tipo_usuario;

-- 4. CORREÇÃO: Atualizar auth_user_id do Master (execute após verificar)
-- DESCOMENTE e ajuste o email se necessário:
/*
UPDATE usuarios
SET auth_user_id = (
    SELECT id FROM auth.users WHERE email = 'william@wgalmeida.com.br' LIMIT 1
)
WHERE pessoa_id = (
    SELECT id FROM pessoas WHERE email = 'william@wgalmeida.com.br' LIMIT 1
);
*/

-- ============================================================================
-- P1: APLICAR RLS EM financeiro_lancamentos
-- Prioridade: ALTA - Dados financeiros sensíveis
-- ============================================================================

-- 1. Habilitar RLS na tabela
ALTER TABLE financeiro_lancamentos ENABLE ROW LEVEL SECURITY;

-- 2. Forçar RLS mesmo para table owner
ALTER TABLE financeiro_lancamentos FORCE ROW LEVEL SECURITY;

-- 3. Política de SELECT: Colaboradores internos podem ver tudo
CREATE POLICY "financeiro_select_colaboradores" ON financeiro_lancamentos
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- 4. Política de INSERT: Apenas MASTER, ADMIN, FINANCEIRO
CREATE POLICY "financeiro_insert_autorizados" ON financeiro_lancamentos
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
            AND u.ativo = true
        )
    );

-- 5. Política de UPDATE: Apenas MASTER, ADMIN, FINANCEIRO
CREATE POLICY "financeiro_update_autorizados" ON financeiro_lancamentos
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
            AND u.ativo = true
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
            AND u.ativo = true
        )
    );

-- 6. Política de DELETE: Apenas MASTER e ADMIN
CREATE POLICY "financeiro_delete_admin" ON financeiro_lancamentos
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

-- ============================================================================
-- P1: APLICAR RLS EM contratos
-- Prioridade: ALTA - Dados contratuais sensíveis
-- ============================================================================

-- 1. Habilitar RLS na tabela
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;

-- 2. Forçar RLS mesmo para table owner
ALTER TABLE contratos FORCE ROW LEVEL SECURITY;

-- 3. Política de SELECT: Colaboradores veem todos, Clientes veem os seus
CREATE POLICY "contratos_select_policy" ON contratos
    FOR SELECT TO authenticated
    USING (
        -- Colaboradores internos veem todos
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'FINANCEIRO', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
        OR
        -- Clientes veem apenas seus próprios contratos
        EXISTS (
            SELECT 1 FROM usuarios u
            JOIN pessoas p ON p.id = u.pessoa_id
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario = 'CLIENTE'
            AND u.ativo = true
            AND contratos.cliente_id = p.id
        )
    );

-- 4. Política de INSERT: Colaboradores autorizados
CREATE POLICY "contratos_insert_colaboradores" ON contratos
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- 5. Política de UPDATE: Colaboradores autorizados
CREATE POLICY "contratos_update_colaboradores" ON contratos
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'COLABORADOR')
            AND u.ativo = true
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- 6. Política de DELETE: Apenas MASTER e ADMIN
CREATE POLICY "contratos_delete_admin" ON contratos
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

-- ============================================================================
-- P1: APLICAR RLS EM propostas (se existir)
-- ============================================================================

-- Verificar se tabela existe antes de aplicar
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'propostas') THEN
        -- Habilitar RLS
        ALTER TABLE propostas ENABLE ROW LEVEL SECURITY;
        ALTER TABLE propostas FORCE ROW LEVEL SECURITY;

        -- Remover políticas existentes se houver
        DROP POLICY IF EXISTS "propostas_select_policy" ON propostas;
        DROP POLICY IF EXISTS "propostas_insert_policy" ON propostas;
        DROP POLICY IF EXISTS "propostas_update_policy" ON propostas;
        DROP POLICY IF EXISTS "propostas_delete_policy" ON propostas;
    END IF;
END $$;

-- Criar políticas para propostas
CREATE POLICY "propostas_select_policy" ON propostas
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
        OR
        EXISTS (
            SELECT 1 FROM usuarios u
            JOIN pessoas p ON p.id = u.pessoa_id
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario = 'CLIENTE'
            AND u.ativo = true
            AND propostas.cliente_id = p.id
        )
    );

CREATE POLICY "propostas_insert_policy" ON propostas
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR')
            AND u.ativo = true
        )
    );

CREATE POLICY "propostas_update_policy" ON propostas
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR')
            AND u.ativo = true
        )
    );

CREATE POLICY "propostas_delete_policy" ON propostas
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

-- ============================================================================
-- P1: APLICAR RLS EM pessoas
-- ============================================================================

ALTER TABLE pessoas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pessoas FORCE ROW LEVEL SECURITY;

-- Colaboradores veem todos, Clientes veem apenas a si mesmos
CREATE POLICY "pessoas_select_policy" ON pessoas
    FOR SELECT TO authenticated
    USING (
        -- Colaboradores internos veem todos
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'FINANCEIRO', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
        OR
        -- Pessoa vê a si mesma
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.pessoa_id = pessoas.id
            AND u.ativo = true
        )
    );

CREATE POLICY "pessoas_insert_policy" ON pessoas
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
    );

CREATE POLICY "pessoas_update_policy" ON pessoas
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
        OR
        -- Pessoa pode atualizar a si mesma
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.pessoa_id = pessoas.id
            AND u.ativo = true
        )
    );

CREATE POLICY "pessoas_delete_policy" ON pessoas
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

-- ============================================================================
-- P1: APLICAR RLS EM usuarios
-- ============================================================================

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios FORCE ROW LEVEL SECURITY;

-- Usuário vê a si mesmo, admins veem todos
CREATE POLICY "usuarios_select_policy" ON usuarios
    FOR SELECT TO authenticated
    USING (
        -- Próprio usuário
        auth_user_id = auth.uid()
        OR
        -- Admins
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

CREATE POLICY "usuarios_insert_policy" ON usuarios
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

CREATE POLICY "usuarios_update_policy" ON usuarios
    FOR UPDATE TO authenticated
    USING (
        -- Próprio usuário pode atualizar alguns campos
        auth_user_id = auth.uid()
        OR
        -- Admins podem atualizar qualquer usuário
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

CREATE POLICY "usuarios_delete_policy" ON usuarios
    FOR DELETE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

-- ============================================================================
-- P2: UNIFICAR AUDIT_LOGS
-- Manter apenas audit_trail, migrar dados e remover redundantes
-- ============================================================================

-- 1. Verificar tabelas de auditoria existentes
SELECT
    table_name,
    (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as num_colunas
FROM information_schema.tables t
WHERE table_schema = 'public'
AND table_name IN ('audit_logs', 'audit_trail', 'auditoria_logs');

-- 2. Verificar quantidade de registros em cada uma
DO $$
DECLARE
    v_audit_logs_count INTEGER := 0;
    v_audit_trail_count INTEGER := 0;
    v_auditoria_logs_count INTEGER := 0;
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'audit_logs') THEN
        EXECUTE 'SELECT COUNT(*) FROM audit_logs' INTO v_audit_logs_count;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'audit_trail') THEN
        EXECUTE 'SELECT COUNT(*) FROM audit_trail' INTO v_audit_trail_count;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'auditoria_logs') THEN
        EXECUTE 'SELECT COUNT(*) FROM auditoria_logs' INTO v_auditoria_logs_count;
    END IF;

    RAISE NOTICE 'audit_logs: % registros', v_audit_logs_count;
    RAISE NOTICE 'audit_trail: % registros', v_audit_trail_count;
    RAISE NOTICE 'auditoria_logs: % registros', v_auditoria_logs_count;
END $$;

-- 3. BACKUP antes de remover (criar tabela de backup)
-- DESCOMENTE para executar:
/*
CREATE TABLE IF NOT EXISTS _backup_audit_logs AS SELECT * FROM audit_logs;
CREATE TABLE IF NOT EXISTS _backup_auditoria_logs AS SELECT * FROM auditoria_logs;
*/

-- 4. Após verificar que audit_trail está sendo usada corretamente,
-- remover tabelas redundantes:
-- DESCOMENTE para executar:
/*
DROP TABLE IF EXISTS auditoria_logs;
-- audit_logs tem 20k+ linhas, manter backup antes de dropar
*/

-- ============================================================================
-- P2: REMOVER TABELA profiles NÃO USADA
-- ============================================================================

-- 1. Verificar se profiles está sendo usada
SELECT
    COUNT(*) as total_registros,
    MAX(created_at) as ultimo_registro
FROM profiles;

-- 2. Verificar dependências
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE ccu.table_name = 'profiles';

-- 3. Se não houver dependências e dados importantes, remover
-- DESCOMENTE para executar:
/*
DROP TABLE IF EXISTS profiles;
*/

-- ============================================================================
-- P3: IDENTIFICAR TABELAS VAZIAS PARA REMOÇÃO
-- ============================================================================

-- Lista tabelas com 0 linhas que podem ser candidatas a remoção
DO $$
DECLARE
    r RECORD;
    v_count INTEGER;
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'TABELAS VAZIAS (0 registros):';
    RAISE NOTICE '========================================';

    FOR r IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
        ORDER BY table_name
    LOOP
        EXECUTE format('SELECT COUNT(*) FROM %I', r.table_name) INTO v_count;
        IF v_count = 0 THEN
            RAISE NOTICE 'VAZIA: %', r.table_name;
        END IF;
    END LOOP;
END $$;

-- ============================================================================
-- P3: CONFIGURAR REALTIME COM POLÍTICAS
-- Aplicar em tabelas que usam realtime
-- ============================================================================

-- 1. Verificar configuração atual do realtime
SELECT * FROM realtime.subscription LIMIT 10;

-- 2. Política para realtime.messages (se existir)
-- Apenas usuários autenticados podem receber mensagens do seu contexto
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'realtime' AND table_name = 'messages') THEN
        ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

        -- Política básica: usuários autenticados
        DROP POLICY IF EXISTS "realtime_messages_policy" ON realtime.messages;
        CREATE POLICY "realtime_messages_policy" ON realtime.messages
            FOR ALL TO authenticated
            USING (true);
    END IF;
END $$;

-- ============================================================================
-- ÍNDICES DE PERFORMANCE PARA RLS
-- Criar índices para otimizar as consultas de RLS
-- ============================================================================

-- Índice para buscar usuário por auth_user_id (usado em todas as policies)
CREATE INDEX IF NOT EXISTS idx_usuarios_auth_user_id ON usuarios(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_usuarios_tipo_ativo ON usuarios(tipo_usuario, ativo);
CREATE INDEX IF NOT EXISTS idx_usuarios_pessoa_id ON usuarios(pessoa_id);

-- Índice para contratos por cliente
CREATE INDEX IF NOT EXISTS idx_contratos_cliente_id ON contratos(cliente_id);

-- Índice para financeiro por projeto/contrato
CREATE INDEX IF NOT EXISTS idx_fin_lancamentos_projeto ON financeiro_lancamentos(projeto_id);
CREATE INDEX IF NOT EXISTS idx_fin_lancamentos_contrato ON financeiro_lancamentos(contrato_id);

-- ============================================================================
-- FUNÇÃO AUXILIAR: Verificar permissão do usuário atual
-- Útil para debugging de RLS
-- ============================================================================

CREATE OR REPLACE FUNCTION public.get_my_permissions()
RETURNS TABLE (
    usuario_id UUID,
    auth_user_id UUID,
    tipo_usuario VARCHAR,
    pessoa_nome VARCHAR,
    ativo BOOLEAN
)
LANGUAGE SQL
SECURITY DEFINER
AS $$
    SELECT
        u.id,
        u.auth_user_id,
        u.tipo_usuario,
        p.nome,
        u.ativo
    FROM usuarios u
    LEFT JOIN pessoas p ON p.id = u.pessoa_id
    WHERE u.auth_user_id = auth.uid();
$$;

-- Uso: SELECT * FROM get_my_permissions();

-- ============================================================================
-- VERIFICAÇÃO FINAL
-- ============================================================================

-- Verificar status do RLS em todas as tabelas
SELECT
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY rls_enabled DESC, tablename;

-- Listar todas as políticas criadas
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
