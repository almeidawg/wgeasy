-- ============================================================================
-- CORREÇÕES RLS - VERSÃO 2 (com DROP antes de CREATE)
-- Gerado em: 2025-12-27
-- ============================================================================

-- ============================================================================
-- P1: RLS EM financeiro_lancamentos
-- ============================================================================

-- Habilitar RLS
ALTER TABLE financeiro_lancamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_lancamentos FORCE ROW LEVEL SECURITY;

-- Remover políticas existentes
DROP POLICY IF EXISTS "financeiro_select_colaboradores" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_insert_autorizados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_update_autorizados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_delete_admin" ON financeiro_lancamentos;

-- Criar novas políticas
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
-- P1: RLS EM contratos
-- ============================================================================

-- Habilitar RLS
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos FORCE ROW LEVEL SECURITY;

-- Remover políticas existentes
DROP POLICY IF EXISTS "contratos_select_policy" ON contratos;
DROP POLICY IF EXISTS "contratos_insert_colaboradores" ON contratos;
DROP POLICY IF EXISTS "contratos_update_colaboradores" ON contratos;
DROP POLICY IF EXISTS "contratos_delete_admin" ON contratos;

-- Criar novas políticas
CREATE POLICY "contratos_select_policy" ON contratos
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'FINANCEIRO', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
        OR
        EXISTS (
            SELECT 1 FROM usuarios u
            JOIN pessoas p ON p.id = u.pessoa_id
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario = 'CLIENTE'
            AND u.ativo = true
            AND contratos.cliente_id = p.id
        )
    );

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
-- P1: RLS EM propostas
-- ============================================================================

-- Habilitar RLS
ALTER TABLE propostas ENABLE ROW LEVEL SECURITY;
ALTER TABLE propostas FORCE ROW LEVEL SECURITY;

-- Remover políticas existentes
DROP POLICY IF EXISTS "propostas_select_policy" ON propostas;
DROP POLICY IF EXISTS "propostas_insert_policy" ON propostas;
DROP POLICY IF EXISTS "propostas_update_policy" ON propostas;
DROP POLICY IF EXISTS "propostas_delete_policy" ON propostas;

-- Criar novas políticas
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
-- P1: RLS EM pessoas
-- ============================================================================

-- Habilitar RLS
ALTER TABLE pessoas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pessoas FORCE ROW LEVEL SECURITY;

-- Remover políticas existentes
DROP POLICY IF EXISTS "pessoas_select_policy" ON pessoas;
DROP POLICY IF EXISTS "pessoas_insert_policy" ON pessoas;
DROP POLICY IF EXISTS "pessoas_update_policy" ON pessoas;
DROP POLICY IF EXISTS "pessoas_delete_policy" ON pessoas;

-- Criar novas políticas
CREATE POLICY "pessoas_select_policy" ON pessoas
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'FINANCEIRO', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
        OR
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
-- P1: RLS EM usuarios
-- ============================================================================

-- Habilitar RLS
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios FORCE ROW LEVEL SECURITY;

-- Remover políticas existentes
DROP POLICY IF EXISTS "usuarios_select_policy" ON usuarios;
DROP POLICY IF EXISTS "usuarios_insert_policy" ON usuarios;
DROP POLICY IF EXISTS "usuarios_update_policy" ON usuarios;
DROP POLICY IF EXISTS "usuarios_delete_policy" ON usuarios;

-- Criar novas políticas
CREATE POLICY "usuarios_select_policy" ON usuarios
    FOR SELECT TO authenticated
    USING (
        auth_user_id = auth.uid()
        OR
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
        auth_user_id = auth.uid()
        OR
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
-- ÍNDICES DE PERFORMANCE PARA RLS
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_usuarios_auth_user_id ON usuarios(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_usuarios_tipo_ativo ON usuarios(tipo_usuario, ativo);
CREATE INDEX IF NOT EXISTS idx_usuarios_pessoa_id ON usuarios(pessoa_id);
CREATE INDEX IF NOT EXISTS idx_contratos_cliente_id ON contratos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_fin_lancamentos_projeto ON financeiro_lancamentos(projeto_id);
CREATE INDEX IF NOT EXISTS idx_fin_lancamentos_contrato ON financeiro_lancamentos(contrato_id);

-- ============================================================================
-- FUNÇÃO AUXILIAR: Verificar permissão do usuário atual
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
AND tablename IN ('usuarios', 'pessoas', 'contratos', 'propostas', 'financeiro_lancamentos')
ORDER BY tablename;

-- Listar todas as políticas criadas
SELECT
    tablename,
    policyname,
    permissive,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('usuarios', 'pessoas', 'contratos', 'propostas', 'financeiro_lancamentos')
ORDER BY tablename, policyname;
