-- ============================================================
-- MEDIÇÃO FINANCEIRA DO CRONOGRAMA
-- Sistema WG Easy - Grupo WG Almeida
-- EXECUTAR NO SUPABASE SQL EDITOR
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/sql/new
-- ============================================================

-- ============================================================
-- TABELAS PARA HISTÓRICO DE MEDIÇÕES
-- ============================================================

-- 1. Tabela principal de medições (cabeçalho)
CREATE TABLE IF NOT EXISTS projeto_medicoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    projeto_id UUID NOT NULL REFERENCES projetos(id) ON DELETE CASCADE,
    data_corte DATE NOT NULL,
    numero_medicao INTEGER NOT NULL,

    -- Totais calculados no momento da medição
    valor_total_contrato DECIMAL(15,2) DEFAULT 0,
    valor_realizado DECIMAL(15,2) DEFAULT 0,
    valor_pendente DECIMAL(15,2) DEFAULT 0,
    percentual_geral DECIMAL(5,2) DEFAULT 0,

    -- Custos profissionais
    custo_profissional_total DECIMAL(15,2) DEFAULT 0,
    custo_profissional_realizado DECIMAL(15,2) DEFAULT 0,

    -- Margem
    margem_bruta DECIMAL(15,2) DEFAULT 0,

    -- Status da medição
    status VARCHAR(20) DEFAULT 'rascunho' CHECK (status IN ('rascunho', 'finalizada', 'aprovada')),

    -- Metadados
    observacoes TEXT,
    created_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(projeto_id, numero_medicao)
);

-- 2. Itens da medição (snapshot das tarefas no momento)
CREATE TABLE IF NOT EXISTS projeto_medicao_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    medicao_id UUID NOT NULL REFERENCES projeto_medicoes(id) ON DELETE CASCADE,
    tarefa_id UUID REFERENCES cronograma_tarefas(id) ON DELETE SET NULL,

    -- Dados da tarefa no momento
    tarefa_nome VARCHAR(255) NOT NULL,
    categoria VARCHAR(100),

    -- Progresso
    progresso_anterior DECIMAL(5,2) DEFAULT 0,
    progresso_atual DECIMAL(5,2) DEFAULT 0,
    progresso_periodo DECIMAL(5,2) DEFAULT 0, -- atual - anterior

    -- Datas
    data_inicio DATE,
    data_fim DATE,
    dias_totais INTEGER DEFAULT 0,
    dias_executados INTEGER DEFAULT 0,

    -- Valores do contrato
    valor_total DECIMAL(15,2) DEFAULT 0,
    valor_por_dia DECIMAL(15,2) DEFAULT 0,
    valor_realizado DECIMAL(15,2) DEFAULT 0,
    valor_periodo DECIMAL(15,2) DEFAULT 0, -- valor realizado no período
    valor_pendente DECIMAL(15,2) DEFAULT 0,

    -- Custo profissional
    custo_profissional_total DECIMAL(15,2) DEFAULT 0,
    custo_profissional_realizado DECIMAL(15,2) DEFAULT 0,

    -- Margem do item
    margem_bruta DECIMAL(15,2) DEFAULT 0,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ÍNDICES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_medicoes_projeto ON projeto_medicoes(projeto_id);
CREATE INDEX IF NOT EXISTS idx_medicoes_data ON projeto_medicoes(data_corte);
CREATE INDEX IF NOT EXISTS idx_medicoes_status ON projeto_medicoes(status);
CREATE INDEX IF NOT EXISTS idx_medicao_itens_medicao ON projeto_medicao_itens(medicao_id);
CREATE INDEX IF NOT EXISTS idx_medicao_itens_tarefa ON projeto_medicao_itens(tarefa_id);

-- ============================================================
-- RLS (Row Level Security)
-- ============================================================

ALTER TABLE projeto_medicoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE projeto_medicao_itens ENABLE ROW LEVEL SECURITY;

-- Políticas permissivas para desenvolvimento
DROP POLICY IF EXISTS "projeto_medicoes_all" ON projeto_medicoes;
CREATE POLICY "projeto_medicoes_all" ON projeto_medicoes FOR ALL USING (true);

DROP POLICY IF EXISTS "projeto_medicao_itens_all" ON projeto_medicao_itens;
CREATE POLICY "projeto_medicao_itens_all" ON projeto_medicao_itens FOR ALL USING (true);

-- ============================================================
-- TRIGGER PARA UPDATED_AT
-- ============================================================

CREATE OR REPLACE FUNCTION update_medicao_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_medicao_updated_at ON projeto_medicoes;
CREATE TRIGGER trigger_medicao_updated_at
    BEFORE UPDATE ON projeto_medicoes
    FOR EACH ROW
    EXECUTE FUNCTION update_medicao_updated_at();

-- ============================================================
-- VIEW: Medições com dados do projeto
-- ============================================================

CREATE OR REPLACE VIEW vw_projeto_medicoes AS
SELECT
    pm.*,
    p.nome AS projeto_titulo,
    c.numero AS contrato_numero,
    p.nucleo,
    p.status AS projeto_status,
    pes.nome AS cliente_nome,
    pes.telefone AS cliente_telefone,
    pes.email AS cliente_email,
    (SELECT COUNT(*) FROM projeto_medicao_itens pmi WHERE pmi.medicao_id = pm.id) AS total_itens
FROM projeto_medicoes pm
LEFT JOIN projetos p ON p.id = pm.projeto_id
LEFT JOIN contratos c ON c.id = p.contrato_id
LEFT JOIN pessoas pes ON pes.id = p.cliente_id
ORDER BY pm.created_at DESC;

-- ============================================================
-- FUNÇÃO: Calcular próximo número de medição
-- ============================================================

CREATE OR REPLACE FUNCTION get_proximo_numero_medicao(p_projeto_id UUID)
RETURNS INTEGER AS $$
DECLARE
    v_numero INTEGER;
BEGIN
    SELECT COALESCE(MAX(numero_medicao), 0) + 1 INTO v_numero
    FROM projeto_medicoes
    WHERE projeto_id = p_projeto_id;

    RETURN v_numero;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- FUNÇÃO: Calcular medição de um projeto
-- ============================================================

CREATE OR REPLACE FUNCTION calcular_medicao_projeto(
    p_projeto_id UUID,
    p_data_corte DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE (
    tarefa_id UUID,
    tarefa_nome VARCHAR,
    categoria VARCHAR,
    data_inicio DATE,
    data_fim DATE,
    dias_totais INTEGER,
    dias_executados INTEGER,
    progresso DECIMAL,
    valor_total DECIMAL,
    valor_por_dia DECIMAL,
    valor_realizado DECIMAL,
    valor_pendente DECIMAL,
    custo_profissional_total DECIMAL,
    custo_profissional_realizado DECIMAL,
    margem_bruta DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ct.id AS tarefa_id,
        ct.descricao::VARCHAR AS tarefa_nome,
        ct.categoria::VARCHAR,
        ct.data_inicio::DATE,
        ct.data_termino::DATE AS data_fim,
        COALESCE(
            EXTRACT(DAY FROM (ct.data_termino - ct.data_inicio))::INTEGER + 1,
            ci.dias_estimados::INTEGER,
            1
        ) AS dias_totais,
        CASE
            WHEN ct.data_inicio IS NOT NULL THEN
                GREATEST(0, EXTRACT(DAY FROM (p_data_corte - ct.data_inicio))::INTEGER + 1)
            ELSE 0
        END AS dias_executados,
        COALESCE(ct.progresso, 0)::DECIMAL AS progresso,
        COALESCE(ci.valor_total, 0)::DECIMAL AS valor_total,
        CASE
            WHEN COALESCE(ci.dias_estimados, 1) > 0 THEN
                (COALESCE(ci.valor_total, 0) / COALESCE(ci.dias_estimados, 1))::DECIMAL
            ELSE 0::DECIMAL
        END AS valor_por_dia,
        (COALESCE(ct.progresso, 0) / 100.0 * COALESCE(ci.valor_total, 0))::DECIMAL AS valor_realizado,
        (COALESCE(ci.valor_total, 0) - (COALESCE(ct.progresso, 0) / 100.0 * COALESCE(ci.valor_total, 0)))::DECIMAL AS valor_pendente,
        COALESCE(pe.horas_alocadas * pe.custo_hora, 0)::DECIMAL AS custo_profissional_total,
        (COALESCE(ct.progresso, 0) / 100.0 * COALESCE(pe.horas_alocadas * pe.custo_hora, 0))::DECIMAL AS custo_profissional_realizado,
        (
            (COALESCE(ct.progresso, 0) / 100.0 * COALESCE(ci.valor_total, 0)) -
            (COALESCE(ct.progresso, 0) / 100.0 * COALESCE(pe.horas_alocadas * pe.custo_hora, 0))
        )::DECIMAL AS margem_bruta
    FROM cronograma_tarefas ct
    LEFT JOIN contratos_itens ci ON ci.id = ct.item_contrato_id
    LEFT JOIN projeto_equipes pe ON pe.projeto_id = ct.projeto_id AND pe.funcao = ct.categoria
    WHERE ct.projeto_id = p_projeto_id
      AND ct.status != 'cancelado'
    ORDER BY ct.ordem, ct.created_at;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- FUNÇÃO: Gerar medição completa (criar registro)
-- ============================================================

CREATE OR REPLACE FUNCTION gerar_medicao_projeto(
    p_projeto_id UUID,
    p_data_corte DATE DEFAULT CURRENT_DATE,
    p_observacoes TEXT DEFAULT NULL,
    p_created_by UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_medicao_id UUID;
    v_numero INTEGER;
    v_totais RECORD;
    v_progresso_anterior DECIMAL;
BEGIN
    -- Obter próximo número
    v_numero := get_proximo_numero_medicao(p_projeto_id);

    -- Calcular totais
    SELECT
        COALESCE(SUM(valor_total), 0) AS total_contrato,
        COALESCE(SUM(valor_realizado), 0) AS total_realizado,
        COALESCE(SUM(valor_pendente), 0) AS total_pendente,
        COALESCE(SUM(custo_profissional_total), 0) AS custo_total,
        COALESCE(SUM(custo_profissional_realizado), 0) AS custo_realizado,
        COALESCE(SUM(margem_bruta), 0) AS margem,
        CASE
            WHEN COALESCE(SUM(valor_total), 0) > 0
            THEN (COALESCE(SUM(valor_realizado), 0) / COALESCE(SUM(valor_total), 1) * 100)
            ELSE 0
        END AS percentual
    INTO v_totais
    FROM calcular_medicao_projeto(p_projeto_id, p_data_corte);

    -- Criar medição
    INSERT INTO projeto_medicoes (
        projeto_id,
        data_corte,
        numero_medicao,
        valor_total_contrato,
        valor_realizado,
        valor_pendente,
        percentual_geral,
        custo_profissional_total,
        custo_profissional_realizado,
        margem_bruta,
        observacoes,
        created_by
    ) VALUES (
        p_projeto_id,
        p_data_corte,
        v_numero,
        v_totais.total_contrato,
        v_totais.total_realizado,
        v_totais.total_pendente,
        v_totais.percentual,
        v_totais.custo_total,
        v_totais.custo_realizado,
        v_totais.margem,
        p_observacoes,
        p_created_by
    )
    RETURNING id INTO v_medicao_id;

    -- Inserir itens da medição
    INSERT INTO projeto_medicao_itens (
        medicao_id,
        tarefa_id,
        tarefa_nome,
        categoria,
        data_inicio,
        data_fim,
        dias_totais,
        dias_executados,
        progresso_anterior,
        progresso_atual,
        progresso_periodo,
        valor_total,
        valor_por_dia,
        valor_realizado,
        valor_pendente,
        custo_profissional_total,
        custo_profissional_realizado,
        margem_bruta
    )
    SELECT
        v_medicao_id,
        cm.tarefa_id,
        cm.tarefa_nome,
        cm.categoria,
        cm.data_inicio,
        cm.data_fim,
        cm.dias_totais,
        cm.dias_executados,
        -- Progresso anterior (da última medição)
        COALESCE((
            SELECT pmi.progresso_atual
            FROM projeto_medicao_itens pmi
            JOIN projeto_medicoes pm ON pm.id = pmi.medicao_id
            WHERE pm.projeto_id = p_projeto_id
              AND pmi.tarefa_id = cm.tarefa_id
              AND pm.numero_medicao = v_numero - 1
        ), 0) AS progresso_anterior,
        cm.progresso AS progresso_atual,
        cm.progresso - COALESCE((
            SELECT pmi.progresso_atual
            FROM projeto_medicao_itens pmi
            JOIN projeto_medicoes pm ON pm.id = pmi.medicao_id
            WHERE pm.projeto_id = p_projeto_id
              AND pmi.tarefa_id = cm.tarefa_id
              AND pm.numero_medicao = v_numero - 1
        ), 0) AS progresso_periodo,
        cm.valor_total,
        cm.valor_por_dia,
        cm.valor_realizado,
        cm.valor_pendente,
        cm.custo_profissional_total,
        cm.custo_profissional_realizado,
        cm.margem_bruta
    FROM calcular_medicao_projeto(p_projeto_id, p_data_corte) cm;

    RETURN v_medicao_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- VERIFICAR CRIAÇÃO
-- ============================================================

SELECT 'Tabelas de medição financeira criadas com sucesso!' AS resultado;

-- Listar tabelas criadas
SELECT table_name
FROM information_schema.tables
WHERE table_name IN ('projeto_medicoes', 'projeto_medicao_itens')
  AND table_schema = 'public';
