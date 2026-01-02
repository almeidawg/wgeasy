-- =====================================================
-- MÓDULO FINANCEIRO PESSOAL - COMPLETO
-- Data: 2024-12-28
-- =====================================================

-- =====================================================
-- 1. TABELA: CONTAS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_contas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    banco VARCHAR(100),
    agencia VARCHAR(20),
    numero_conta VARCHAR(30),
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('PF', 'PJ')),
    subtipo VARCHAR(30) CHECK (subtipo IN (
        'corrente', 'poupanca', 'investimento', 'carteira', 'cartao_credito'
    )),
    saldo_inicial DECIMAL(15,2) DEFAULT 0,
    saldo_atual DECIMAL(15,2) DEFAULT 0,
    cor VARCHAR(7) DEFAULT '#F25C26',
    icone VARCHAR(50) DEFAULT 'wallet',
    ordem INTEGER DEFAULT 0,
    is_principal BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'ativa' CHECK (status IN ('ativa', 'inativa', 'arquivada')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_contas_usuario ON fin_pessoal_contas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_contas_status ON fin_pessoal_contas(status);

-- =====================================================
-- 2. TABELA: CATEGORIAS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('receita', 'despesa', 'ambos')),
    categoria_pai_id UUID REFERENCES fin_pessoal_categorias(id),
    cor VARCHAR(7) DEFAULT '#6B7280',
    icone VARCHAR(50),
    ordem INTEGER DEFAULT 0,
    is_sistema BOOLEAN DEFAULT false,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_categorias_usuario ON fin_pessoal_categorias(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_categorias_tipo ON fin_pessoal_categorias(tipo);

-- Categorias padrão
INSERT INTO fin_pessoal_categorias (nome, tipo, cor, icone, is_sistema, ordem) VALUES
('Salário/Pró-labore', 'receita', '#22C55E', 'briefcase', true, 1),
('Investimentos', 'receita', '#3B82F6', 'trending-up', true, 2),
('Freelance', 'receita', '#8B5CF6', 'code', true, 3),
('Aluguéis', 'receita', '#14B8A6', 'home', true, 4),
('Dividendos', 'receita', '#F59E0B', 'coins', true, 5),
('Outros Rendimentos', 'receita', '#6B7280', 'plus-circle', true, 6),
('Alimentação', 'despesa', '#EF4444', 'utensils', true, 10),
('Moradia', 'despesa', '#F97316', 'home', true, 11),
('Transporte', 'despesa', '#EAB308', 'car', true, 12),
('Saúde', 'despesa', '#EC4899', 'heart', true, 13),
('Educação', 'despesa', '#14B8A6', 'book-open', true, 14),
('Lazer', 'despesa', '#A855F7', 'gamepad-2', true, 15),
('Vestuário', 'despesa', '#F472B6', 'shirt', true, 16),
('Serviços/Assinaturas', 'despesa', '#64748B', 'settings', true, 17),
('Impostos', 'despesa', '#DC2626', 'file-text', true, 18),
('Cartão de Crédito', 'despesa', '#7C3AED', 'credit-card', true, 19),
('Outras Despesas', 'despesa', '#6B7280', 'minus-circle', true, 20)
ON CONFLICT DO NOTHING;

-- =====================================================
-- 3. TABELA: LANCAMENTOS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_lancamentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    numero VARCHAR(50) UNIQUE,
    tipo VARCHAR(15) NOT NULL CHECK (tipo IN ('receita', 'despesa', 'transferencia')),
    descricao TEXT NOT NULL,
    valor DECIMAL(15,2) NOT NULL CHECK (valor > 0),
    categoria_id UUID REFERENCES fin_pessoal_categorias(id),
    tags JSONB DEFAULT '[]',
    conta_id UUID REFERENCES fin_pessoal_contas(id),
    conta_destino_id UUID REFERENCES fin_pessoal_contas(id),
    data_lancamento DATE NOT NULL DEFAULT CURRENT_DATE,
    data_vencimento DATE,
    data_efetivacao DATE,
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN (
        'pendente', 'efetivado', 'agendado', 'vencido', 'cancelado'
    )),
    is_recorrente BOOLEAN DEFAULT false,
    recorrencia_tipo VARCHAR(20) CHECK (recorrencia_tipo IN ('semanal', 'mensal', 'anual')),
    recorrencia_pai_id UUID REFERENCES fin_pessoal_lancamentos(id),
    vinculo_financeiro_principal_id UUID,
    vinculo_tipo VARCHAR(30) CHECK (vinculo_tipo IN ('prolabore', 'transferencia', 'pagamento')),
    vinculo_origem VARCHAR(50) DEFAULT 'manual' CHECK (vinculo_origem IN ('manual', 'automatico', 'sugerido')),
    comprovante_url TEXT,
    observacoes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_usuario ON fin_pessoal_lancamentos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_tipo ON fin_pessoal_lancamentos(tipo);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_status ON fin_pessoal_lancamentos(status);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_data ON fin_pessoal_lancamentos(data_lancamento);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_conta ON fin_pessoal_lancamentos(conta_id);

-- =====================================================
-- 4. TABELA: SUGESTOES DE VINCULO
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_sugestoes_vinculo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    financeiro_principal_id UUID NOT NULL,
    financeiro_tipo VARCHAR(30) NOT NULL CHECK (financeiro_tipo IN ('prolabore', 'transferencia', 'pagamento')),
    valor DECIMAL(15,2) NOT NULL,
    data_lancamento DATE NOT NULL,
    descricao TEXT,
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN (
        'pendente', 'aceita', 'rejeitada', 'ignorada'
    )),
    lancamento_pessoal_id UUID REFERENCES fin_pessoal_lancamentos(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    processado_at TIMESTAMPTZ,
    processado_by UUID REFERENCES usuarios(id)
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_sugestoes_usuario ON fin_pessoal_sugestoes_vinculo(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_sugestoes_status ON fin_pessoal_sugestoes_vinculo(status);

-- =====================================================
-- 5. TABELA: ALERTAS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_alertas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN (
        'prolabore_ausente', 'deposito_sem_origem', 'vencimento_proximo',
        'meta_atingida', 'orcamento_estourado', 'lancamento_sugerido'
    )),
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT,
    dados JSONB,
    acao_tipo VARCHAR(30),
    acao_referencia_id UUID,
    status VARCHAR(20) DEFAULT 'ativo' CHECK (status IN (
        'ativo', 'lido', 'resolvido', 'ignorado'
    )),
    prioridade VARCHAR(10) DEFAULT 'media' CHECK (prioridade IN ('baixa', 'media', 'alta')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    lido_at TIMESTAMPTZ,
    resolvido_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_alertas_usuario ON fin_pessoal_alertas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_alertas_status ON fin_pessoal_alertas(status);

-- =====================================================
-- 6. TABELAS: ORCAMENTOS E METAS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_orcamentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    categoria_id UUID REFERENCES fin_pessoal_categorias(id),
    valor_limite DECIMAL(15,2) NOT NULL,
    mes_ano DATE NOT NULL,
    alertar_percentual INTEGER DEFAULT 80,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_orcamentos_usuario ON fin_pessoal_orcamentos(usuario_id);

CREATE TABLE IF NOT EXISTS fin_pessoal_metas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    tipo VARCHAR(30) CHECK (tipo IN ('reserva', 'investimento', 'compra', 'viagem', 'outro')),
    valor_alvo DECIMAL(15,2) NOT NULL,
    valor_atual DECIMAL(15,2) DEFAULT 0,
    data_inicio DATE DEFAULT CURRENT_DATE,
    data_alvo DATE,
    conta_destino_id UUID REFERENCES fin_pessoal_contas(id),
    cor VARCHAR(7) DEFAULT '#3B82F6',
    icone VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ativa' CHECK (status IN ('ativa', 'pausada', 'concluida', 'cancelada')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fin_pessoal_metas_usuario ON fin_pessoal_metas(usuario_id);

-- =====================================================
-- 7. FUNÇÕES
-- =====================================================

-- Gerar número sequencial
CREATE OR REPLACE FUNCTION gerar_numero_lancamento_pessoal()
RETURNS TRIGGER AS $$
DECLARE
    ano_atual TEXT;
    proximo_numero INTEGER;
BEGIN
    ano_atual := EXTRACT(YEAR FROM CURRENT_DATE)::TEXT;
    SELECT COALESCE(MAX(
        CAST(SUBSTRING(numero FROM 'FP-' || ano_atual || '-(\d+)') AS INTEGER)
    ), 0) + 1
    INTO proximo_numero
    FROM fin_pessoal_lancamentos
    WHERE numero LIKE 'FP-' || ano_atual || '-%';
    NEW.numero := 'FP-' || ano_atual || '-' || LPAD(proximo_numero::TEXT, 5, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_numero_lancamento_pessoal ON fin_pessoal_lancamentos;
CREATE TRIGGER trg_numero_lancamento_pessoal
BEFORE INSERT ON fin_pessoal_lancamentos
FOR EACH ROW WHEN (NEW.numero IS NULL)
EXECUTE FUNCTION gerar_numero_lancamento_pessoal();

-- Atualizar saldo da conta
CREATE OR REPLACE FUNCTION fn_atualizar_saldo_conta_pessoal()
RETURNS TRIGGER AS $$
DECLARE
    v_multiplicador INTEGER;
BEGIN
    IF NEW.tipo = 'receita' THEN v_multiplicador := 1;
    ELSIF NEW.tipo = 'despesa' THEN v_multiplicador := -1;
    ELSE v_multiplicador := 0;
    END IF;

    IF NEW.conta_id IS NOT NULL AND NEW.status = 'efetivado' THEN
        UPDATE fin_pessoal_contas
        SET saldo_atual = saldo_atual + (NEW.valor * v_multiplicador), updated_at = NOW()
        WHERE id = NEW.conta_id;
    END IF;

    IF NEW.tipo = 'transferencia' AND NEW.conta_destino_id IS NOT NULL AND NEW.status = 'efetivado' THEN
        UPDATE fin_pessoal_contas
        SET saldo_atual = saldo_atual + NEW.valor, updated_at = NOW()
        WHERE id = NEW.conta_destino_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_atualizar_saldo_conta ON fin_pessoal_lancamentos;
CREATE TRIGGER trg_atualizar_saldo_conta
AFTER INSERT OR UPDATE OF status ON fin_pessoal_lancamentos
FOR EACH ROW EXECUTE FUNCTION fn_atualizar_saldo_conta_pessoal();

-- Obter usuario_id pelo auth.uid()
CREATE OR REPLACE FUNCTION fn_get_usuario_id_by_auth()
RETURNS UUID AS $$
DECLARE
    v_usuario_id UUID;
BEGIN
    SELECT id INTO v_usuario_id
    FROM usuarios
    WHERE auth_user_id = auth.uid();
    RETURN v_usuario_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- =====================================================
-- 8. VIEWS
-- =====================================================

DROP VIEW IF EXISTS vw_prolabore_empresa;
CREATE OR REPLACE VIEW vw_prolabore_empresa AS
SELECT
    fl.id,
    fl.numero,
    fl.descricao,
    fl.valor_total as valor,
    fl.data_competencia,
    fl.data_pagamento,
    fl.status,
    fl.pessoa_id,
    p.nome as pessoa_nome,
    u.id as usuario_id,
    u.auth_user_id
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
LEFT JOIN usuarios u ON u.pessoa_id = p.id
WHERE fl.tipo = 'saida'
  AND (
    LOWER(fl.descricao) LIKE '%pró-labore%'
    OR LOWER(fl.descricao) LIKE '%pro-labore%'
    OR LOWER(fl.descricao) LIKE '%prolabore%'
    OR LOWER(fl.descricao) LIKE '%pro labore%'
  );

DROP VIEW IF EXISTS vw_dashboard_financeiro_pessoal;
CREATE OR REPLACE VIEW vw_dashboard_financeiro_pessoal AS
SELECT
    fpl.usuario_id,
    u.auth_user_id,
    COALESCE(SUM(CASE
        WHEN fpl.tipo = 'receita'
             AND EXTRACT(MONTH FROM fpl.data_lancamento) = EXTRACT(MONTH FROM CURRENT_DATE)
             AND EXTRACT(YEAR FROM fpl.data_lancamento) = EXTRACT(YEAR FROM CURRENT_DATE)
             AND fpl.status != 'cancelado'
        THEN fpl.valor ELSE 0 END), 0) as receitas_mes,
    COALESCE(SUM(CASE
        WHEN fpl.tipo = 'despesa'
             AND EXTRACT(MONTH FROM fpl.data_lancamento) = EXTRACT(MONTH FROM CURRENT_DATE)
             AND EXTRACT(YEAR FROM fpl.data_lancamento) = EXTRACT(YEAR FROM CURRENT_DATE)
             AND fpl.status != 'cancelado'
        THEN fpl.valor ELSE 0 END), 0) as despesas_mes,
    COUNT(CASE WHEN fpl.status = 'pendente' THEN 1 END) as lancamentos_pendentes,
    COUNT(CASE WHEN fpl.status = 'vencido' THEN 1 END) as lancamentos_vencidos
FROM fin_pessoal_lancamentos fpl
LEFT JOIN usuarios u ON u.id = fpl.usuario_id
GROUP BY fpl.usuario_id, u.auth_user_id;

-- =====================================================
-- 9. RLS
-- =====================================================

ALTER TABLE fin_pessoal_contas ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_lancamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_sugestoes_vinculo ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_alertas ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_orcamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_metas ENABLE ROW LEVEL SECURITY;

-- Políticas CONTAS
DROP POLICY IF EXISTS "fin_pessoal_contas_select" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_select" ON fin_pessoal_contas FOR SELECT USING (usuario_id = fn_get_usuario_id_by_auth());
DROP POLICY IF EXISTS "fin_pessoal_contas_insert" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_insert" ON fin_pessoal_contas FOR INSERT WITH CHECK (usuario_id = fn_get_usuario_id_by_auth());
DROP POLICY IF EXISTS "fin_pessoal_contas_update" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_update" ON fin_pessoal_contas FOR UPDATE USING (usuario_id = fn_get_usuario_id_by_auth());
DROP POLICY IF EXISTS "fin_pessoal_contas_delete" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_delete" ON fin_pessoal_contas FOR DELETE USING (usuario_id = fn_get_usuario_id_by_auth());

-- Políticas CATEGORIAS
DROP POLICY IF EXISTS "fin_pessoal_categorias_select" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_select" ON fin_pessoal_categorias FOR SELECT USING (usuario_id = fn_get_usuario_id_by_auth() OR is_sistema = true);
DROP POLICY IF EXISTS "fin_pessoal_categorias_insert" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_insert" ON fin_pessoal_categorias FOR INSERT WITH CHECK (usuario_id = fn_get_usuario_id_by_auth());
DROP POLICY IF EXISTS "fin_pessoal_categorias_update" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_update" ON fin_pessoal_categorias FOR UPDATE USING (usuario_id = fn_get_usuario_id_by_auth() AND is_sistema = false);
DROP POLICY IF EXISTS "fin_pessoal_categorias_delete" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_delete" ON fin_pessoal_categorias FOR DELETE USING (usuario_id = fn_get_usuario_id_by_auth() AND is_sistema = false);

-- Políticas LANCAMENTOS
DROP POLICY IF EXISTS "fin_pessoal_lancamentos_all" ON fin_pessoal_lancamentos;
CREATE POLICY "fin_pessoal_lancamentos_all" ON fin_pessoal_lancamentos FOR ALL USING (usuario_id = fn_get_usuario_id_by_auth());

-- Políticas SUGESTOES
DROP POLICY IF EXISTS "fin_pessoal_sugestoes_all" ON fin_pessoal_sugestoes_vinculo;
CREATE POLICY "fin_pessoal_sugestoes_all" ON fin_pessoal_sugestoes_vinculo FOR ALL USING (usuario_id = fn_get_usuario_id_by_auth());

-- Políticas ALERTAS
DROP POLICY IF EXISTS "fin_pessoal_alertas_all" ON fin_pessoal_alertas;
CREATE POLICY "fin_pessoal_alertas_all" ON fin_pessoal_alertas FOR ALL USING (usuario_id = fn_get_usuario_id_by_auth());

-- Políticas ORCAMENTOS
DROP POLICY IF EXISTS "fin_pessoal_orcamentos_all" ON fin_pessoal_orcamentos;
CREATE POLICY "fin_pessoal_orcamentos_all" ON fin_pessoal_orcamentos FOR ALL USING (usuario_id = fn_get_usuario_id_by_auth());

-- Políticas METAS
DROP POLICY IF EXISTS "fin_pessoal_metas_all" ON fin_pessoal_metas;
CREATE POLICY "fin_pessoal_metas_all" ON fin_pessoal_metas FOR ALL USING (usuario_id = fn_get_usuario_id_by_auth());

-- =====================================================
-- 10. GRANTS
-- =====================================================

GRANT SELECT ON vw_prolabore_empresa TO authenticated;
GRANT SELECT ON vw_dashboard_financeiro_pessoal TO authenticated;
GRANT EXECUTE ON FUNCTION fn_get_usuario_id_by_auth TO authenticated;

SELECT 'Módulo Financeiro Pessoal criado com sucesso!' as resultado;
