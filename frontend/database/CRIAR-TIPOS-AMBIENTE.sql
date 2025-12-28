-- ============================================================
-- Script: Criar tabela de Tipos de Ambiente
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2025-12-27
-- ============================================================

-- Criar tabela de tipos de ambiente
CREATE TABLE IF NOT EXISTS tipos_ambiente (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo TEXT NOT NULL UNIQUE,
    nome TEXT NOT NULL,
    ordem INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    criado_por UUID REFERENCES auth.users(id),
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_tipos_ambiente_codigo ON tipos_ambiente(codigo);
CREATE INDEX IF NOT EXISTS idx_tipos_ambiente_ativo ON tipos_ambiente(ativo);
CREATE INDEX IF NOT EXISTS idx_tipos_ambiente_ordem ON tipos_ambiente(ordem);

-- Trigger para atualizar timestamp
CREATE OR REPLACE FUNCTION update_tipos_ambiente_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_tipos_ambiente_timestamp ON tipos_ambiente;
CREATE TRIGGER trigger_tipos_ambiente_timestamp
    BEFORE UPDATE ON tipos_ambiente
    FOR EACH ROW
    EXECUTE FUNCTION update_tipos_ambiente_timestamp();

-- Habilitar RLS
ALTER TABLE tipos_ambiente ENABLE ROW LEVEL SECURITY;

-- Política de leitura: todos podem ver tipos ativos
DROP POLICY IF EXISTS "tipos_ambiente_select" ON tipos_ambiente;
CREATE POLICY "tipos_ambiente_select" ON tipos_ambiente
    FOR SELECT
    USING (ativo = true);

-- Política de inserção: apenas MASTER pode inserir
DROP POLICY IF EXISTS "tipos_ambiente_insert" ON tipos_ambiente;
CREATE POLICY "tipos_ambiente_insert" ON tipos_ambiente
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario = 'MASTER'
        )
    );

-- Política de atualização: apenas MASTER pode atualizar
DROP POLICY IF EXISTS "tipos_ambiente_update" ON tipos_ambiente;
CREATE POLICY "tipos_ambiente_update" ON tipos_ambiente
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario = 'MASTER'
        )
    );

-- Política de exclusão: apenas MASTER pode excluir
DROP POLICY IF EXISTS "tipos_ambiente_delete" ON tipos_ambiente;
CREATE POLICY "tipos_ambiente_delete" ON tipos_ambiente
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario = 'MASTER'
        )
    );

-- Popular com tipos padrão do sistema
INSERT INTO tipos_ambiente (codigo, nome, ordem, ativo) VALUES
    ('quarto', 'Quarto', 1, true),
    ('suite', 'Suíte', 2, true),
    ('sala', 'Sala', 3, true),
    ('cozinha', 'Cozinha', 4, true),
    ('banheiro', 'Banheiro', 5, true),
    ('lavabo', 'Lavabo', 6, true),
    ('area_servico', 'Área de Serviço', 7, true),
    ('lavanderia', 'Lavanderia', 8, true),
    ('varanda', 'Varanda', 9, true),
    ('sacada', 'Sacada', 10, true),
    ('escritorio', 'Escritório', 11, true),
    ('closet', 'Closet', 12, true),
    ('corredor', 'Corredor', 13, true),
    ('hall', 'Hall', 14, true),
    ('deposito', 'Depósito', 15, true),
    ('garagem', 'Garagem', 16, true),
    ('area_externa', 'Área Externa', 17, true),
    ('outro', 'Outro', 99, true)
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    ordem = EXCLUDED.ordem,
    atualizado_em = NOW();

-- Verificar resultado
SELECT codigo, nome, ordem, ativo FROM tipos_ambiente ORDER BY ordem;
