-- ============================================================
-- TABELA DE COMENTARIOS DO CLIENTE - EASY SYSTEM
-- Comentarios que viram itens de checklist para a equipe
-- ============================================================

-- 1. TABELA PRINCIPAL DE COMENTARIOS
CREATE TABLE IF NOT EXISTS comentarios_cliente (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,
    contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,
    projeto_id UUID REFERENCES projetos(id) ON DELETE SET NULL,

    -- Conteudo do comentario
    texto TEXT NOT NULL,

    -- Classificacao
    nucleo VARCHAR(20) DEFAULT 'geral' CHECK (nucleo IN ('arquitetura', 'engenharia', 'marcenaria', 'geral')),
    prioridade VARCHAR(20) DEFAULT 'normal' CHECK (prioridade IN ('baixa', 'normal', 'alta', 'urgente')),

    -- Status do checklist
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN ('pendente', 'em_andamento', 'concluido', 'arquivado')),

    -- Resposta da equipe
    resposta_equipe TEXT,
    respondido_por UUID REFERENCES usuarios(id),
    respondido_em TIMESTAMPTZ,

    -- Atribuicao
    atribuido_para UUID REFERENCES usuarios(id),

    -- Metadados
    criado_em TIMESTAMPTZ DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- 2. INDICES PARA PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_cliente ON comentarios_cliente(cliente_id);
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_contrato ON comentarios_cliente(contrato_id);
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_projeto ON comentarios_cliente(projeto_id);
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_status ON comentarios_cliente(status);
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_nucleo ON comentarios_cliente(nucleo);
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_prioridade ON comentarios_cliente(prioridade);
CREATE INDEX IF NOT EXISTS idx_comentarios_cliente_atribuido ON comentarios_cliente(atribuido_para);

-- 3. TRIGGER PARA ATUALIZAR TIMESTAMP
CREATE OR REPLACE FUNCTION update_comentarios_cliente_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_comentarios_cliente ON comentarios_cliente;
CREATE TRIGGER trigger_update_comentarios_cliente
    BEFORE UPDATE ON comentarios_cliente
    FOR EACH ROW
    EXECUTE FUNCTION update_comentarios_cliente_timestamp();

-- 4. RLS (Row Level Security)
ALTER TABLE comentarios_cliente ENABLE ROW LEVEL SECURITY;

-- Remover politicas existentes
DROP POLICY IF EXISTS "comentarios_cliente_select_cliente" ON comentarios_cliente;
DROP POLICY IF EXISTS "comentarios_cliente_insert_cliente" ON comentarios_cliente;
DROP POLICY IF EXISTS "comentarios_cliente_select_equipe" ON comentarios_cliente;
DROP POLICY IF EXISTS "comentarios_cliente_all_equipe" ON comentarios_cliente;

-- Clientes podem ver e criar seus proprios comentarios
CREATE POLICY "comentarios_cliente_select_cliente" ON comentarios_cliente
    FOR SELECT TO authenticated
    USING (
        cliente_id IN (
            SELECT id FROM pessoas
            WHERE email = (SELECT email FROM auth.users WHERE id = auth.uid())
        )
    );

CREATE POLICY "comentarios_cliente_insert_cliente" ON comentarios_cliente
    FOR INSERT TO authenticated
    WITH CHECK (
        cliente_id IN (
            SELECT id FROM pessoas
            WHERE email = (SELECT email FROM auth.users WHERE id = auth.uid())
        )
    );

-- Equipe interna pode ver e gerenciar todos os comentarios
CREATE POLICY "comentarios_cliente_select_equipe" ON comentarios_cliente
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios
            WHERE auth_user_id = auth.uid()
            AND tipo IN ('admin', 'super_admin', 'colaborador')
        )
    );

CREATE POLICY "comentarios_cliente_all_equipe" ON comentarios_cliente
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios
            WHERE auth_user_id = auth.uid()
            AND tipo IN ('admin', 'super_admin', 'colaborador')
        )
    );

-- 5. VIEW PARA DASHBOARD DA EQUIPE
CREATE OR REPLACE VIEW vw_comentarios_pendentes AS
SELECT
    c.id,
    c.texto,
    c.nucleo,
    c.prioridade,
    c.status,
    c.criado_em,
    p.nome AS cliente_nome,
    p.email AS cliente_email,
    co.titulo AS contrato_titulo,
    pr.nome AS projeto_nome,
    u.nome AS atribuido_nome
FROM comentarios_cliente c
LEFT JOIN pessoas p ON p.id = c.cliente_id
LEFT JOIN contratos co ON co.id = c.contrato_id
LEFT JOIN projetos pr ON pr.id = c.projeto_id
LEFT JOIN usuarios u ON u.id = c.atribuido_para
WHERE c.status IN ('pendente', 'em_andamento')
ORDER BY
    CASE c.prioridade
        WHEN 'urgente' THEN 1
        WHEN 'alta' THEN 2
        WHEN 'normal' THEN 3
        ELSE 4
    END,
    c.criado_em DESC;

-- 6. FUNCAO PARA CONTAR COMENTARIOS PENDENTES POR NUCLEO
CREATE OR REPLACE FUNCTION get_comentarios_pendentes_por_nucleo()
RETURNS TABLE (
    nucleo VARCHAR,
    total BIGINT,
    urgentes BIGINT,
    altas BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.nucleo,
        COUNT(*)::BIGINT AS total,
        COUNT(*) FILTER (WHERE c.prioridade = 'urgente')::BIGINT AS urgentes,
        COUNT(*) FILTER (WHERE c.prioridade = 'alta')::BIGINT AS altas
    FROM comentarios_cliente c
    WHERE c.status IN ('pendente', 'em_andamento')
    GROUP BY c.nucleo
    ORDER BY total DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- FIM DO SCRIPT
-- Execute este script no Supabase SQL Editor
-- ============================================================
