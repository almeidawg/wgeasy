-- ============================================================================
-- LIMPEZA TOTAL E RECRIAÇÃO DE RLS
-- Gerado em: 2025-12-27
-- IMPORTANTE: Execute este script INTEIRO de uma vez
-- ============================================================================

-- ============================================================================
-- PASSO 1: REMOVER TODAS AS POLÍTICAS ANTIGAS DE contratos
-- ============================================================================

DROP POLICY IF EXISTS "Permitir delete de contratos" ON contratos;
DROP POLICY IF EXISTS "Permitir insert de contratos" ON contratos;
DROP POLICY IF EXISTS "Permitir leitura de contratos" ON contratos;
DROP POLICY IF EXISTS "Permitir update de contratos" ON contratos;
DROP POLICY IF EXISTS "contratos_admin_all" ON contratos;
DROP POLICY IF EXISTS "contratos_delete" ON contratos;
DROP POLICY IF EXISTS "contratos_delete_admin" ON contratos;
DROP POLICY IF EXISTS "contratos_delete_authenticated" ON contratos;
DROP POLICY IF EXISTS "contratos_delete_policy" ON contratos;
DROP POLICY IF EXISTS "contratos_insert" ON contratos;
DROP POLICY IF EXISTS "contratos_insert_colaboradores" ON contratos;
DROP POLICY IF EXISTS "contratos_insert_policy" ON contratos;
DROP POLICY IF EXISTS "contratos_same_company" ON contratos;
DROP POLICY IF EXISTS "contratos_select" ON contratos;
DROP POLICY IF EXISTS "contratos_select_policy" ON contratos;
DROP POLICY IF EXISTS "contratos_update" ON contratos;
DROP POLICY IF EXISTS "contratos_update_authenticated" ON contratos;
DROP POLICY IF EXISTS "contratos_update_colaboradores" ON contratos;
DROP POLICY IF EXISTS "contratos_update_policy" ON contratos;

-- ============================================================================
-- PASSO 2: REMOVER TODAS AS POLÍTICAS ANTIGAS DE financeiro_lancamentos
-- ============================================================================

DROP POLICY IF EXISTS "Permitir INSERT via trigger" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "Permitir atualização para usuários autenticados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "Permitir exclusão para usuários autenticados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "Permitir inserção para usuários autenticados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "Permitir leitura para usuários autenticados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "Permitir tudo financeiro" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_delete_admin" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_full_access" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_insert_autorizados" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_select_colaboradores" ON financeiro_lancamentos;
DROP POLICY IF EXISTS "financeiro_update_autorizados" ON financeiro_lancamentos;

-- ============================================================================
-- PASSO 3: REMOVER TODAS AS POLÍTICAS ANTIGAS DE pessoas
-- ============================================================================

DROP POLICY IF EXISTS "Pessoas - Insert" ON pessoas;
DROP POLICY IF EXISTS "Pessoas - Select" ON pessoas;
DROP POLICY IF EXISTS "Pessoas - Update" ON pessoas;
DROP POLICY IF EXISTS "Usuários autenticados podem acessar pessoas" ON pessoas;
DROP POLICY IF EXISTS "pessoas_delete_authenticated" ON pessoas;
DROP POLICY IF EXISTS "pessoas_delete_policy" ON pessoas;
DROP POLICY IF EXISTS "pessoas_insert_authenticated" ON pessoas;
DROP POLICY IF EXISTS "pessoas_insert_policy" ON pessoas;
DROP POLICY IF EXISTS "pessoas_select_authenticated" ON pessoas;
DROP POLICY IF EXISTS "pessoas_select_policy" ON pessoas;
DROP POLICY IF EXISTS "pessoas_update_authenticated" ON pessoas;
DROP POLICY IF EXISTS "pessoas_update_policy" ON pessoas;

-- ============================================================================
-- PASSO 4: REMOVER TODAS AS POLÍTICAS ANTIGAS DE propostas
-- ============================================================================

DROP POLICY IF EXISTS "Usuários autenticados podem atualizar propostas" ON propostas;
DROP POLICY IF EXISTS "Usuários autenticados podem criar propostas" ON propostas;
DROP POLICY IF EXISTS "Usuários autenticados podem deletar propostas" ON propostas;
DROP POLICY IF EXISTS "Usuários autenticados podem ver todas as propostas" ON propostas;
DROP POLICY IF EXISTS "Usuários autenticados podem visualizar propostas" ON propostas;
DROP POLICY IF EXISTS "propostas_delete_authenticated" ON propostas;
DROP POLICY IF EXISTS "propostas_delete_policy" ON propostas;
DROP POLICY IF EXISTS "propostas_insert_authenticated" ON propostas;
DROP POLICY IF EXISTS "propostas_insert_policy" ON propostas;
DROP POLICY IF EXISTS "propostas_select_authenticated" ON propostas;
DROP POLICY IF EXISTS "propostas_select_policy" ON propostas;
DROP POLICY IF EXISTS "propostas_update_authenticated" ON propostas;
DROP POLICY IF EXISTS "propostas_update_policy" ON propostas;

-- ============================================================================
-- PASSO 5: REMOVER TODAS AS POLÍTICAS ANTIGAS DE usuarios
-- ============================================================================

DROP POLICY IF EXISTS "Users can update own record" ON usuarios;
DROP POLICY IF EXISTS "usuarios_delete_policy" ON usuarios;
DROP POLICY IF EXISTS "usuarios_full_access" ON usuarios;
DROP POLICY IF EXISTS "usuarios_insert_policy" ON usuarios;
DROP POLICY IF EXISTS "usuarios_select_policy" ON usuarios;
DROP POLICY IF EXISTS "usuarios_update_policy" ON usuarios;

-- ============================================================================
-- PASSO 6: GARANTIR QUE RLS ESTÁ HABILITADO
-- ============================================================================

ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos FORCE ROW LEVEL SECURITY;

ALTER TABLE financeiro_lancamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_lancamentos FORCE ROW LEVEL SECURITY;

ALTER TABLE pessoas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pessoas FORCE ROW LEVEL SECURITY;

ALTER TABLE propostas ENABLE ROW LEVEL SECURITY;
ALTER TABLE propostas FORCE ROW LEVEL SECURITY;

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios FORCE ROW LEVEL SECURITY;

-- ============================================================================
-- PASSO 7: CRIAR NOVAS POLÍTICAS PARA contratos
-- ============================================================================

-- SELECT: Colaboradores veem todos, Clientes veem os seus
CREATE POLICY "contratos_select" ON contratos
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

-- INSERT: Colaboradores autorizados
CREATE POLICY "contratos_insert" ON contratos
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- UPDATE: Colaboradores autorizados
CREATE POLICY "contratos_update" ON contratos
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'JURIDICO', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- DELETE: Apenas MASTER e ADMIN
CREATE POLICY "contratos_delete" ON contratos
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
-- PASSO 8: CRIAR NOVAS POLÍTICAS PARA financeiro_lancamentos
-- ============================================================================

-- SELECT: MASTER, ADMIN, FINANCEIRO, COLABORADOR
CREATE POLICY "financeiro_select" ON financeiro_lancamentos
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- INSERT: MASTER, ADMIN, FINANCEIRO
CREATE POLICY "financeiro_insert" ON financeiro_lancamentos
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
            AND u.ativo = true
        )
    );

-- UPDATE: MASTER, ADMIN, FINANCEIRO
CREATE POLICY "financeiro_update" ON financeiro_lancamentos
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO')
            AND u.ativo = true
        )
    );

-- DELETE: Apenas MASTER e ADMIN
CREATE POLICY "financeiro_delete" ON financeiro_lancamentos
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
-- PASSO 9: CRIAR NOVAS POLÍTICAS PARA pessoas
-- ============================================================================

-- SELECT: Colaboradores veem todos, pessoa vê a si mesma
CREATE POLICY "pessoas_select" ON pessoas
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

-- INSERT: Colaboradores
CREATE POLICY "pessoas_insert" ON pessoas
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR', 'ATENDIMENTO')
            AND u.ativo = true
        )
    );

-- UPDATE: Colaboradores ou própria pessoa
CREATE POLICY "pessoas_update" ON pessoas
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

-- DELETE: Apenas MASTER e ADMIN
CREATE POLICY "pessoas_delete" ON pessoas
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
-- PASSO 10: CRIAR NOVAS POLÍTICAS PARA propostas
-- ============================================================================

-- SELECT: Colaboradores veem todas, Clientes veem as suas
CREATE POLICY "propostas_select" ON propostas
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

-- INSERT: Colaboradores
CREATE POLICY "propostas_insert" ON propostas
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- UPDATE: Colaboradores
CREATE POLICY "propostas_update" ON propostas
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COLABORADOR')
            AND u.ativo = true
        )
    );

-- DELETE: Apenas MASTER e ADMIN
CREATE POLICY "propostas_delete" ON propostas
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
-- PASSO 11: CRIAR NOVAS POLÍTICAS PARA usuarios
-- ============================================================================

-- SELECT: Próprio usuário ou Admins
CREATE POLICY "usuarios_select" ON usuarios
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

-- INSERT: Apenas MASTER e ADMIN
CREATE POLICY "usuarios_insert" ON usuarios
    FOR INSERT TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN')
            AND u.ativo = true
        )
    );

-- UPDATE: Próprio usuário ou Admins
CREATE POLICY "usuarios_update" ON usuarios
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

-- DELETE: Apenas MASTER e ADMIN
CREATE POLICY "usuarios_delete" ON usuarios
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
-- PASSO 12: CRIAR ÍNDICES PARA PERFORMANCE
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_usuarios_auth_user_id ON usuarios(auth_user_id);
CREATE INDEX IF NOT EXISTS idx_usuarios_tipo_ativo ON usuarios(tipo_usuario, ativo);
CREATE INDEX IF NOT EXISTS idx_usuarios_pessoa_id ON usuarios(pessoa_id);
CREATE INDEX IF NOT EXISTS idx_contratos_cliente_id ON contratos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_propostas_cliente_id ON propostas(cliente_id);

-- ============================================================================
-- PASSO 13: VERIFICAÇÃO FINAL
-- ============================================================================

SELECT
    tablename,
    policyname,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
AND tablename IN ('usuarios', 'pessoas', 'contratos', 'propostas', 'financeiro_lancamentos')
ORDER BY tablename, cmd;
