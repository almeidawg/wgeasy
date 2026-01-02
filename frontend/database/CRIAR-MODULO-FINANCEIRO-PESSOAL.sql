-- =====================================================
-- MODULO FINANCEIRO PESSOAL - WGeasy
-- Data: 2024-12-28
-- Descricao: Submódulo de controle financeiro pessoal
--            vinculado ao dashboard do usuário logado
-- =====================================================

-- =====================================================
-- 1. TABELA: CONTAS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_contas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Dados da Conta
    nome VARCHAR(100) NOT NULL,
    banco VARCHAR(100),
    agencia VARCHAR(20),
    numero_conta VARCHAR(30),
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('PF', 'PJ')),
    subtipo VARCHAR(30) CHECK (subtipo IN (
        'corrente', 'poupanca', 'investimento', 'carteira', 'cartao_credito'
    )),

    -- Saldos
    saldo_inicial DECIMAL(15,2) DEFAULT 0,
    saldo_atual DECIMAL(15,2) DEFAULT 0,

    -- Controle visual
    cor VARCHAR(7) DEFAULT '#F25C26',
    icone VARCHAR(50) DEFAULT 'wallet',
    ordem INTEGER DEFAULT 0,
    is_principal BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'ativa' CHECK (status IN ('ativa', 'inativa', 'arquivada')),

    -- Auditoria
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_contas_usuario ON fin_pessoal_contas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_contas_status ON fin_pessoal_contas(status);

COMMENT ON TABLE fin_pessoal_contas IS 'Contas bancárias pessoais do usuário (PF e PJ)';

-- =====================================================
-- 2. TABELA: CATEGORIAS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Dados da Categoria
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('receita', 'despesa', 'ambos')),

    -- Hierarquia (subcategorias)
    categoria_pai_id UUID REFERENCES fin_pessoal_categorias(id),

    -- Visual
    cor VARCHAR(7) DEFAULT '#6B7280',
    icone VARCHAR(50),

    -- Controle
    ordem INTEGER DEFAULT 0,
    is_sistema BOOLEAN DEFAULT false,
    ativo BOOLEAN DEFAULT true,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_categorias_usuario ON fin_pessoal_categorias(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_categorias_tipo ON fin_pessoal_categorias(tipo);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_categorias_pai ON fin_pessoal_categorias(categoria_pai_id);

COMMENT ON TABLE fin_pessoal_categorias IS 'Categorias de receitas e despesas pessoais';

-- =====================================================
-- 3. INSERIR CATEGORIAS PADRAO DO SISTEMA
-- =====================================================

INSERT INTO fin_pessoal_categorias (nome, tipo, cor, icone, is_sistema, ordem) VALUES
-- Receitas
('Salário/Pró-labore', 'receita', '#22C55E', 'briefcase', true, 1),
('Investimentos', 'receita', '#3B82F6', 'trending-up', true, 2),
('Freelance', 'receita', '#8B5CF6', 'code', true, 3),
('Aluguéis', 'receita', '#14B8A6', 'home', true, 4),
('Dividendos', 'receita', '#F59E0B', 'coins', true, 5),
('Outros Rendimentos', 'receita', '#6B7280', 'plus-circle', true, 6),

-- Despesas
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
-- 4. TABELA: LANCAMENTOS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_lancamentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    numero VARCHAR(50) UNIQUE,

    -- Dados do Lançamento
    tipo VARCHAR(15) NOT NULL CHECK (tipo IN ('receita', 'despesa', 'transferencia')),
    descricao TEXT NOT NULL,
    valor DECIMAL(15,2) NOT NULL CHECK (valor > 0),

    -- Classificação
    categoria_id UUID REFERENCES fin_pessoal_categorias(id),
    tags JSONB DEFAULT '[]',

    -- Contas vinculadas
    conta_id UUID REFERENCES fin_pessoal_contas(id),
    conta_destino_id UUID REFERENCES fin_pessoal_contas(id),

    -- Datas
    data_lancamento DATE NOT NULL DEFAULT CURRENT_DATE,
    data_vencimento DATE,
    data_efetivacao DATE,

    -- Status
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN (
        'pendente', 'efetivado', 'agendado', 'vencido', 'cancelado'
    )),

    -- Recorrência
    is_recorrente BOOLEAN DEFAULT false,
    recorrencia_tipo VARCHAR(20) CHECK (recorrencia_tipo IN ('semanal', 'mensal', 'anual')),
    recorrencia_pai_id UUID REFERENCES fin_pessoal_lancamentos(id),

    -- Vínculo com Financeiro Principal (READ-ONLY)
    vinculo_financeiro_principal_id UUID,
    vinculo_tipo VARCHAR(30) CHECK (vinculo_tipo IN ('prolabore', 'transferencia', 'pagamento')),
    vinculo_origem VARCHAR(50) DEFAULT 'manual' CHECK (vinculo_origem IN ('manual', 'automatico', 'sugerido')),

    -- Anexos e observações
    comprovante_url TEXT,
    observacoes TEXT,

    -- Auditoria
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indices de performance
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_usuario ON fin_pessoal_lancamentos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_tipo ON fin_pessoal_lancamentos(tipo);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_status ON fin_pessoal_lancamentos(status);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_data ON fin_pessoal_lancamentos(data_lancamento);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_conta ON fin_pessoal_lancamentos(conta_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_categoria ON fin_pessoal_lancamentos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_vinculo ON fin_pessoal_lancamentos(vinculo_financeiro_principal_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_lanc_vencimento ON fin_pessoal_lancamentos(data_vencimento);

COMMENT ON TABLE fin_pessoal_lancamentos IS 'Lançamentos financeiros pessoais (receitas, despesas, transferências)';

-- =====================================================
-- 5. FUNCAO: GERAR NUMERO SEQUENCIAL
-- =====================================================

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

-- Trigger para gerar número
DROP TRIGGER IF EXISTS trg_numero_lancamento_pessoal ON fin_pessoal_lancamentos;
CREATE TRIGGER trg_numero_lancamento_pessoal
BEFORE INSERT ON fin_pessoal_lancamentos
FOR EACH ROW
WHEN (NEW.numero IS NULL)
EXECUTE FUNCTION gerar_numero_lancamento_pessoal();

-- =====================================================
-- 6. TABELA: SUGESTOES DE VINCULO (PRO-LABORE)
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_sugestoes_vinculo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Referência ao financeiro principal
    financeiro_principal_id UUID NOT NULL,
    financeiro_tipo VARCHAR(30) NOT NULL CHECK (financeiro_tipo IN ('prolabore', 'transferencia', 'pagamento')),

    -- Dados do lançamento original
    valor DECIMAL(15,2) NOT NULL,
    data_lancamento DATE NOT NULL,
    descricao TEXT,

    -- Status da sugestão
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN (
        'pendente', 'aceita', 'rejeitada', 'ignorada'
    )),

    -- Lançamento pessoal criado (se aceita)
    lancamento_pessoal_id UUID REFERENCES fin_pessoal_lancamentos(id),

    -- Auditoria
    created_at TIMESTAMPTZ DEFAULT NOW(),
    processado_at TIMESTAMPTZ,
    processado_by UUID REFERENCES usuarios(id)
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_sugestoes_usuario ON fin_pessoal_sugestoes_vinculo(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_sugestoes_status ON fin_pessoal_sugestoes_vinculo(status);

COMMENT ON TABLE fin_pessoal_sugestoes_vinculo IS 'Sugestões de vínculo entre financeiro pessoal e principal';

-- =====================================================
-- 7. TABELA: ALERTAS PESSOAIS
-- =====================================================

CREATE TABLE IF NOT EXISTS fin_pessoal_alertas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Tipo do alerta
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN (
        'prolabore_ausente',
        'deposito_sem_origem',
        'vencimento_proximo',
        'meta_atingida',
        'orcamento_estourado',
        'lancamento_sugerido'
    )),

    -- Conteúdo
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT,
    dados JSONB,

    -- Ação sugerida
    acao_tipo VARCHAR(30),
    acao_referencia_id UUID,

    -- Status
    status VARCHAR(20) DEFAULT 'ativo' CHECK (status IN (
        'ativo', 'lido', 'resolvido', 'ignorado'
    )),
    prioridade VARCHAR(10) DEFAULT 'media' CHECK (prioridade IN ('baixa', 'media', 'alta')),

    -- Auditoria
    created_at TIMESTAMPTZ DEFAULT NOW(),
    lido_at TIMESTAMPTZ,
    resolvido_at TIMESTAMPTZ
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_alertas_usuario ON fin_pessoal_alertas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_alertas_status ON fin_pessoal_alertas(status);
CREATE INDEX IF NOT EXISTS idx_fin_pessoal_alertas_tipo ON fin_pessoal_alertas(tipo);

COMMENT ON TABLE fin_pessoal_alertas IS 'Alertas inteligentes do sistema para o usuário';

-- =====================================================
-- 8. VIEW: PRO-LABORE DO FINANCEIRO PRINCIPAL (READ-ONLY)
-- =====================================================

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
    p.usuario_id as usuario_id
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
WHERE fl.tipo = 'saida'
  AND (
    fl.referencia_tipo = 'prolabore'
    OR fl.descricao ILIKE '%pró-labore%'
    OR fl.descricao ILIKE '%pro-labore%'
    OR fl.descricao ILIKE '%prolabore%'
    OR fl.descricao ILIKE '%pro labore%'
  );

COMMENT ON VIEW vw_prolabore_empresa IS 'View READ-ONLY para identificar pró-labores no financeiro principal';

-- =====================================================
-- 9. VIEW: DASHBOARD CONSOLIDADO
-- =====================================================

CREATE OR REPLACE VIEW vw_dashboard_financeiro_pessoal AS
SELECT
    fpl.usuario_id,

    -- Totais do Mês Atual
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

    -- Pendentes e vencidos
    COUNT(CASE WHEN fpl.status = 'pendente' THEN 1 END) as lancamentos_pendentes,
    COUNT(CASE WHEN fpl.status = 'vencido' THEN 1 END) as lancamentos_vencidos

FROM fin_pessoal_lancamentos fpl
GROUP BY fpl.usuario_id;

COMMENT ON VIEW vw_dashboard_financeiro_pessoal IS 'View consolidada para dashboard do financeiro pessoal';

-- =====================================================
-- 10. FUNCAO: IDENTIFICAR DEPOSITOS SEM ORIGEM
-- =====================================================

CREATE OR REPLACE FUNCTION fn_identificar_depositos_sem_origem(p_usuario_id UUID)
RETURNS TABLE (
    lancamento_id UUID,
    valor DECIMAL,
    data_lancamento DATE,
    descricao TEXT,
    tem_correspondencia BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        fpl.id as lancamento_id,
        fpl.valor,
        fpl.data_lancamento,
        fpl.descricao,
        EXISTS (
            SELECT 1 FROM vw_prolabore_empresa vpe
            WHERE vpe.usuario_id = p_usuario_id
              AND vpe.valor = fpl.valor
              AND vpe.data_pagamento IS NOT NULL
              AND ABS(EXTRACT(EPOCH FROM (vpe.data_pagamento::timestamp - fpl.data_lancamento::timestamp)) / 86400) <= 3
        ) as tem_correspondencia
    FROM fin_pessoal_lancamentos fpl
    WHERE fpl.usuario_id = p_usuario_id
      AND fpl.tipo = 'receita'
      AND fpl.vinculo_financeiro_principal_id IS NULL
      AND fpl.status != 'cancelado'
    ORDER BY fpl.data_lancamento DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION fn_identificar_depositos_sem_origem IS 'Identifica receitas pessoais sem correspondência no financeiro principal';

-- =====================================================
-- 11. FUNCAO: ATUALIZAR SALDO DA CONTA
-- =====================================================

CREATE OR REPLACE FUNCTION fn_atualizar_saldo_conta_pessoal()
RETURNS TRIGGER AS $$
DECLARE
    v_multiplicador INTEGER;
BEGIN
    -- Define multiplicador baseado no tipo
    IF NEW.tipo = 'receita' THEN
        v_multiplicador := 1;
    ELSIF NEW.tipo = 'despesa' THEN
        v_multiplicador := -1;
    ELSE
        v_multiplicador := 0;
    END IF;

    -- Atualiza saldo da conta de origem
    IF NEW.conta_id IS NOT NULL AND NEW.status = 'efetivado' THEN
        UPDATE fin_pessoal_contas
        SET saldo_atual = saldo_atual + (NEW.valor * v_multiplicador),
            updated_at = NOW()
        WHERE id = NEW.conta_id;
    END IF;

    -- Para transferências, atualiza conta destino
    IF NEW.tipo = 'transferencia' AND NEW.conta_destino_id IS NOT NULL AND NEW.status = 'efetivado' THEN
        UPDATE fin_pessoal_contas
        SET saldo_atual = saldo_atual + NEW.valor,
            updated_at = NOW()
        WHERE id = NEW.conta_destino_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar saldo
DROP TRIGGER IF EXISTS trg_atualizar_saldo_conta ON fin_pessoal_lancamentos;
CREATE TRIGGER trg_atualizar_saldo_conta
AFTER INSERT OR UPDATE OF status ON fin_pessoal_lancamentos
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_saldo_conta_pessoal();

-- =====================================================
-- 12. FUNCAO: VERIFICAR LANCAMENTOS VENCIDOS
-- =====================================================

CREATE OR REPLACE FUNCTION fn_verificar_lancamentos_vencidos()
RETURNS void AS $$
BEGIN
    -- Atualiza status para vencido
    UPDATE fin_pessoal_lancamentos
    SET status = 'vencido',
        updated_at = NOW()
    WHERE status = 'pendente'
      AND data_vencimento < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_verificar_lancamentos_vencidos IS 'Atualiza status de lançamentos vencidos';

-- =====================================================
-- 13. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE fin_pessoal_contas ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_lancamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_sugestoes_vinculo ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_pessoal_alertas ENABLE ROW LEVEL SECURITY;

-- Políticas para CONTAS
DROP POLICY IF EXISTS "fin_pessoal_contas_select" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_select" ON fin_pessoal_contas
    FOR SELECT USING (usuario_id = auth.uid());

DROP POLICY IF EXISTS "fin_pessoal_contas_insert" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_insert" ON fin_pessoal_contas
    FOR INSERT WITH CHECK (usuario_id = auth.uid());

DROP POLICY IF EXISTS "fin_pessoal_contas_update" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_update" ON fin_pessoal_contas
    FOR UPDATE USING (usuario_id = auth.uid());

DROP POLICY IF EXISTS "fin_pessoal_contas_delete" ON fin_pessoal_contas;
CREATE POLICY "fin_pessoal_contas_delete" ON fin_pessoal_contas
    FOR DELETE USING (usuario_id = auth.uid());

-- Políticas para CATEGORIAS (próprias + sistema)
DROP POLICY IF EXISTS "fin_pessoal_categorias_select" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_select" ON fin_pessoal_categorias
    FOR SELECT USING (usuario_id = auth.uid() OR is_sistema = true);

DROP POLICY IF EXISTS "fin_pessoal_categorias_insert" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_insert" ON fin_pessoal_categorias
    FOR INSERT WITH CHECK (usuario_id = auth.uid());

DROP POLICY IF EXISTS "fin_pessoal_categorias_update" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_update" ON fin_pessoal_categorias
    FOR UPDATE USING (usuario_id = auth.uid() AND is_sistema = false);

DROP POLICY IF EXISTS "fin_pessoal_categorias_delete" ON fin_pessoal_categorias;
CREATE POLICY "fin_pessoal_categorias_delete" ON fin_pessoal_categorias
    FOR DELETE USING (usuario_id = auth.uid() AND is_sistema = false);

-- Políticas para LANCAMENTOS
DROP POLICY IF EXISTS "fin_pessoal_lancamentos_all" ON fin_pessoal_lancamentos;
CREATE POLICY "fin_pessoal_lancamentos_all" ON fin_pessoal_lancamentos
    FOR ALL USING (usuario_id = auth.uid());

-- Políticas para SUGESTOES
DROP POLICY IF EXISTS "fin_pessoal_sugestoes_all" ON fin_pessoal_sugestoes_vinculo;
CREATE POLICY "fin_pessoal_sugestoes_all" ON fin_pessoal_sugestoes_vinculo
    FOR ALL USING (usuario_id = auth.uid());

-- Políticas para ALERTAS
DROP POLICY IF EXISTS "fin_pessoal_alertas_all" ON fin_pessoal_alertas;
CREATE POLICY "fin_pessoal_alertas_all" ON fin_pessoal_alertas
    FOR ALL USING (usuario_id = auth.uid());

-- =====================================================
-- 14. GRANTS
-- =====================================================

GRANT SELECT ON vw_prolabore_empresa TO authenticated;
GRANT SELECT ON vw_dashboard_financeiro_pessoal TO authenticated;
GRANT EXECUTE ON FUNCTION fn_identificar_depositos_sem_origem TO authenticated;
GRANT EXECUTE ON FUNCTION fn_verificar_lancamentos_vencidos TO authenticated;

-- =====================================================
-- 15. TABELAS FASE 2: ORCAMENTOS E METAS (OPCIONAL)
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
ALTER TABLE fin_pessoal_orcamentos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "fin_pessoal_orcamentos_all" ON fin_pessoal_orcamentos;
CREATE POLICY "fin_pessoal_orcamentos_all" ON fin_pessoal_orcamentos
    FOR ALL USING (usuario_id = auth.uid());

COMMENT ON TABLE fin_pessoal_orcamentos IS 'Orçamentos mensais por categoria';

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
ALTER TABLE fin_pessoal_metas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "fin_pessoal_metas_all" ON fin_pessoal_metas;
CREATE POLICY "fin_pessoal_metas_all" ON fin_pessoal_metas
    FOR ALL USING (usuario_id = auth.uid());

COMMENT ON TABLE fin_pessoal_metas IS 'Metas financeiras pessoais';

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================

-- Para executar este script no Supabase:
-- 1. Acesse o SQL Editor do Supabase Dashboard
-- 2. Cole este conteúdo
-- 3. Execute o script

SELECT 'Módulo Financeiro Pessoal criado com sucesso!' as resultado;
