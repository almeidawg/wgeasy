-- =====================================================
-- MIGRAÇÃO: Sistema de Menções no Checklist
-- Data: 2024-12-28
-- Descrição: Permite mencionar usuários (@nome) nas tarefas
--            e compartilhar tarefas entre checklists
-- =====================================================

-- Tabela de menções em itens do checklist
CREATE TABLE IF NOT EXISTS ceo_checklist_mencoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID NOT NULL REFERENCES ceo_checklist_itens(id) ON DELETE CASCADE,
    usuario_mencionado_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    usuario_autor_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    lido BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),

    -- Evitar duplicatas
    UNIQUE(item_id, usuario_mencionado_id)
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_checklist_mencoes_mencionado ON ceo_checklist_mencoes(usuario_mencionado_id);
CREATE INDEX IF NOT EXISTS idx_checklist_mencoes_item ON ceo_checklist_mencoes(item_id);
CREATE INDEX IF NOT EXISTS idx_checklist_mencoes_lido ON ceo_checklist_mencoes(lido) WHERE lido = false;

-- Adicionar campo de autor no item do checklist (quem criou)
ALTER TABLE ceo_checklist_itens
ADD COLUMN IF NOT EXISTS criado_por UUID REFERENCES usuarios(id);

-- RLS para menções
ALTER TABLE ceo_checklist_mencoes ENABLE ROW LEVEL SECURITY;

-- Política: usuário pode ver menções onde ele é o mencionado ou o autor
CREATE POLICY "mencoes_select" ON ceo_checklist_mencoes
    FOR SELECT USING (
        usuario_mencionado_id IN (SELECT id FROM usuarios WHERE auth_user_id = auth.uid())
        OR
        usuario_autor_id IN (SELECT id FROM usuarios WHERE auth_user_id = auth.uid())
    );

-- Política: usuário pode criar menções
CREATE POLICY "mencoes_insert" ON ceo_checklist_mencoes
    FOR INSERT WITH CHECK (
        usuario_autor_id IN (SELECT id FROM usuarios WHERE auth_user_id = auth.uid())
    );

-- Política: usuário pode atualizar menções onde é o mencionado (marcar como lido)
CREATE POLICY "mencoes_update" ON ceo_checklist_mencoes
    FOR UPDATE USING (
        usuario_mencionado_id IN (SELECT id FROM usuarios WHERE auth_user_id = auth.uid())
    );

-- Política: autor pode deletar suas menções
CREATE POLICY "mencoes_delete" ON ceo_checklist_mencoes
    FOR DELETE USING (
        usuario_autor_id IN (SELECT id FROM usuarios WHERE auth_user_id = auth.uid())
    );

-- View para facilitar busca de tarefas mencionadas
CREATE OR REPLACE VIEW vw_checklist_com_mencoes AS
SELECT
    i.*,
    m.usuario_mencionado_id,
    m.lido as mencao_lida,
    m.created_at as mencao_created_at,
    autor.id as autor_id,
    p_autor.nome as autor_nome,
    p_mencionado.nome as mencionado_nome
FROM ceo_checklist_itens i
LEFT JOIN ceo_checklist_mencoes m ON m.item_id = i.id
LEFT JOIN usuarios autor ON autor.id = i.criado_por
LEFT JOIN pessoas p_autor ON p_autor.id = autor.pessoa_id
LEFT JOIN usuarios mencionado ON mencionado.id = m.usuario_mencionado_id
LEFT JOIN pessoas p_mencionado ON p_mencionado.id = mencionado.pessoa_id;

-- Função para buscar usuários por nome (para autocomplete de @menções)
CREATE OR REPLACE FUNCTION buscar_usuarios_para_mencao(termo TEXT)
RETURNS TABLE (
    id UUID,
    nome TEXT,
    tipo_usuario TEXT,
    avatar_url TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id,
        p.nome::TEXT,
        u.tipo_usuario::TEXT,
        COALESCE(p.avatar_url, p.foto_url)::TEXT as avatar_url
    FROM usuarios u
    JOIN pessoas p ON p.id = u.pessoa_id
    WHERE
        u.ativo = true
        AND (
            p.nome ILIKE '%' || termo || '%'
            OR p.email ILIKE '%' || termo || '%'
        )
    ORDER BY p.nome
    LIMIT 10;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON TABLE ceo_checklist_mencoes IS 'Menções de usuários em tarefas do checklist (@usuario)';
COMMENT ON FUNCTION buscar_usuarios_para_mencao IS 'Busca usuários para autocomplete de menções';
