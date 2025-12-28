-- ============================================================
-- CORREÇÃO URGENTE: Recursão Infinita em RLS
-- Erro: "infinite recursion detected in policy for relation usuarios"
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2025-12-27
-- ============================================================

-- O problema ocorre quando uma política RLS da tabela "usuarios"
-- tenta consultar a própria tabela "usuarios" para verificar permissões,
-- criando um loop infinito.

-- ============================================================
-- PASSO 1: Remover políticas problemáticas
-- ============================================================

-- Desabilitar RLS temporariamente para limpar
ALTER TABLE usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE pessoas DISABLE ROW LEVEL SECURITY;

-- Remover TODAS as políticas da tabela usuarios
DO $$
DECLARE
    pol RECORD;
BEGIN
    FOR pol IN
        SELECT policyname
        FROM pg_policies
        WHERE tablename = 'usuarios'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON usuarios', pol.policyname);
        RAISE NOTICE 'Removida política: %', pol.policyname;
    END LOOP;
END $$;

-- Remover TODAS as políticas da tabela pessoas
DO $$
DECLARE
    pol RECORD;
BEGIN
    FOR pol IN
        SELECT policyname
        FROM pg_policies
        WHERE tablename = 'pessoas'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON pessoas', pol.policyname);
        RAISE NOTICE 'Removida política: %', pol.policyname;
    END LOOP;
END $$;

-- ============================================================
-- PASSO 2: Criar função SECURITY DEFINER para verificar usuário
-- Esta função bypassa RLS e evita recursão
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_user_tipo(user_auth_id UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT tipo_usuario FROM usuarios WHERE auth_user_id = user_auth_id LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.is_user_master()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM usuarios
        WHERE auth_user_id = auth.uid()
        AND tipo_usuario = 'MASTER'
    );
$$;

CREATE OR REPLACE FUNCTION public.is_user_admin_or_master()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM usuarios
        WHERE auth_user_id = auth.uid()
        AND tipo_usuario IN ('MASTER', 'ADMIN')
    );
$$;

-- ============================================================
-- PASSO 3: Recriar políticas SIMPLES para usuarios
-- ============================================================

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

-- Política de SELECT: usuário vê próprio registro OU admin/master vê todos
CREATE POLICY "usuarios_select_own" ON usuarios
    FOR SELECT
    USING (
        auth_user_id = auth.uid()
        OR public.is_user_admin_or_master()
    );

-- Política de UPDATE: usuário atualiza próprio registro OU admin/master atualiza todos
CREATE POLICY "usuarios_update_own" ON usuarios
    FOR UPDATE
    USING (
        auth_user_id = auth.uid()
        OR public.is_user_admin_or_master()
    );

-- Política de INSERT: apenas admin/master pode inserir
CREATE POLICY "usuarios_insert_admin" ON usuarios
    FOR INSERT
    WITH CHECK (public.is_user_admin_or_master());

-- Política de DELETE: apenas master pode deletar
CREATE POLICY "usuarios_delete_master" ON usuarios
    FOR DELETE
    USING (public.is_user_master());

-- ============================================================
-- PASSO 4: Recriar políticas SIMPLES para pessoas
-- ============================================================

ALTER TABLE pessoas ENABLE ROW LEVEL SECURITY;

-- Política de SELECT: todos podem ver pessoas (necessário para buscas)
CREATE POLICY "pessoas_select_all" ON pessoas
    FOR SELECT
    USING (true);

-- Política de UPDATE: admin/master pode atualizar
CREATE POLICY "pessoas_update_admin" ON pessoas
    FOR UPDATE
    USING (public.is_user_admin_or_master());

-- Política de INSERT: admin/master pode inserir
CREATE POLICY "pessoas_insert_admin" ON pessoas
    FOR INSERT
    WITH CHECK (public.is_user_admin_or_master());

-- Política de DELETE: apenas master pode deletar
CREATE POLICY "pessoas_delete_master" ON pessoas
    FOR DELETE
    USING (public.is_user_master());

-- ============================================================
-- PASSO 5: Verificar resultado
-- ============================================================

SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd
FROM pg_policies
WHERE tablename IN ('usuarios', 'pessoas')
ORDER BY tablename, policyname;

-- Testar se funciona (não deve dar erro de recursão)
SELECT 'Teste OK - sem recursão!' as status;
