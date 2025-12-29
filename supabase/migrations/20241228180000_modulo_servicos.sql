-- ============================================================================
-- MÓDULO DE SERVIÇOS - WGeasy
-- Versão: 1.0.0 | Data: 2024-12-28
-- Gestão de solicitações de serviços com aceite via WhatsApp
-- ============================================================================

-- ===================
-- CATEGORIAS DE SERVIÇO
-- ===================
CREATE TABLE IF NOT EXISTS servico_categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    icone VARCHAR(50),
    cor VARCHAR(7),
    ativo BOOLEAN DEFAULT true,
    ordem INTEGER DEFAULT 0,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Categorias padrão
INSERT INTO servico_categorias (codigo, nome, descricao, icone, cor, ordem) VALUES
('frete', 'Frete', 'Transporte de materiais e equipamentos', 'Truck', '#3B82F6', 1),
('coleta', 'Coleta de Material', 'Retirada de materiais em fornecedores', 'Package', '#10B981', 2),
('entrega', 'Entrega', 'Entrega de materiais em obra ou cliente', 'MapPin', '#F59E0B', 3),
('mao_obra', 'Mão de Obra Pontual', 'Serviços de mão de obra avulsa', 'Hammer', '#8B5CF6', 4),
('tecnico', 'Serviço Técnico', 'Serviços técnicos especializados', 'Wrench', '#EF4444', 5),
('montagem', 'Montagem', 'Montagem de móveis e estruturas', 'Box', '#06B6D4', 6),
('outros', 'Outros', 'Outros tipos de serviço', 'MoreHorizontal', '#6B7280', 99)
ON CONFLICT (codigo) DO NOTHING;

-- ===================
-- VÍNCULO PRESTADOR-CATEGORIA
-- ===================
CREATE TABLE IF NOT EXISTS prestador_categoria_vinculo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    prestador_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,
    categoria_id UUID NOT NULL REFERENCES servico_categorias(id) ON DELETE CASCADE,
    principal BOOLEAN DEFAULT false,
    observacoes TEXT,
    criado_em TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(prestador_id, categoria_id)
);

CREATE INDEX IF NOT EXISTS idx_prestador_categoria_prestador ON prestador_categoria_vinculo(prestador_id);
CREATE INDEX IF NOT EXISTS idx_prestador_categoria_categoria ON prestador_categoria_vinculo(categoria_id);

-- ===================
-- SOLICITAÇÕES DE SERVIÇO
-- ===================
CREATE TABLE IF NOT EXISTS solicitacoes_servico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero VARCHAR(20) UNIQUE,

    -- TIPO DE VÍNCULO
    tipo_vinculo VARCHAR(20) NOT NULL CHECK (tipo_vinculo IN ('projeto', 'obra', 'contrato', 'avulso')),
    projeto_id UUID REFERENCES contratos(id) ON DELETE SET NULL,
    cliente_id UUID REFERENCES pessoas(id) ON DELETE SET NULL,

    -- CATEGORIA DO SERVIÇO
    categoria_id UUID NOT NULL REFERENCES servico_categorias(id),

    -- DESCRIÇÃO
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,

    -- ENDEREÇOS - Coletar em
    coletar_tipo VARCHAR(20) CHECK (coletar_tipo IN ('obra', 'fornecedor', 'manual')),
    coletar_pessoa_id UUID REFERENCES pessoas(id),
    coletar_endereco_completo TEXT,
    coletar_cep VARCHAR(15),
    coletar_logradouro VARCHAR(255),
    coletar_numero VARCHAR(20),
    coletar_complemento VARCHAR(100),
    coletar_bairro VARCHAR(100),
    coletar_cidade VARCHAR(100),
    coletar_estado VARCHAR(2),
    coletar_referencia TEXT,

    -- ENDEREÇOS - Entregar em
    entregar_tipo VARCHAR(20) CHECK (entregar_tipo IN ('obra', 'cliente', 'manual')),
    entregar_pessoa_id UUID REFERENCES pessoas(id),
    entregar_endereco_completo TEXT,
    entregar_cep VARCHAR(15),
    entregar_logradouro VARCHAR(255),
    entregar_numero VARCHAR(20),
    entregar_complemento VARCHAR(100),
    entregar_bairro VARCHAR(100),
    entregar_cidade VARCHAR(100),
    entregar_estado VARCHAR(2),
    entregar_referencia TEXT,

    -- VALOR
    valor_servico DECIMAL(15,2) NOT NULL,
    forma_pagamento VARCHAR(50),
    observacoes_pagamento TEXT,

    -- PRESTADOR SELECIONADO (após aceite)
    prestador_id UUID REFERENCES pessoas(id),
    prestador_tipo VARCHAR(20) CHECK (prestador_tipo IN ('fornecedor', 'colaborador')),

    -- DATAS
    data_solicitacao TIMESTAMPTZ DEFAULT NOW(),
    data_necessidade DATE,
    data_aceite TIMESTAMPTZ,
    data_inicio_execucao TIMESTAMPTZ,
    data_conclusao TIMESTAMPTZ,

    -- STATUS
    status VARCHAR(20) NOT NULL DEFAULT 'criado' CHECK (status IN (
        'criado',
        'enviado',
        'aceito',
        'em_andamento',
        'concluido',
        'cancelado'
    )),

    -- LINK DE ACEITE
    token_aceite UUID UNIQUE DEFAULT gen_random_uuid(),
    link_expira_em TIMESTAMPTZ,

    -- INTEGRAÇÃO FINANCEIRA
    lancamento_id UUID,
    solicitacao_pagamento_id UUID,

    -- CANCELAMENTO
    motivo_cancelamento TEXT,
    cancelado_por UUID,
    cancelado_em TIMESTAMPTZ,

    -- AUDITORIA
    criado_por UUID,
    criado_em TIMESTAMPTZ DEFAULT NOW(),
    atualizado_por UUID,
    atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_solicitacoes_servico_status ON solicitacoes_servico(status);
CREATE INDEX IF NOT EXISTS idx_solicitacoes_servico_projeto ON solicitacoes_servico(projeto_id);
CREATE INDEX IF NOT EXISTS idx_solicitacoes_servico_prestador ON solicitacoes_servico(prestador_id);
CREATE INDEX IF NOT EXISTS idx_solicitacoes_servico_categoria ON solicitacoes_servico(categoria_id);
CREATE INDEX IF NOT EXISTS idx_solicitacoes_servico_token ON solicitacoes_servico(token_aceite);
CREATE INDEX IF NOT EXISTS idx_solicitacoes_servico_data ON solicitacoes_servico(data_necessidade);

-- ===================
-- PRESTADORES CONVIDADOS
-- ===================
CREATE TABLE IF NOT EXISTS servico_prestadores_convidados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitacao_id UUID NOT NULL REFERENCES solicitacoes_servico(id) ON DELETE CASCADE,
    prestador_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,
    prestador_tipo VARCHAR(20) NOT NULL CHECK (prestador_tipo IN ('fornecedor', 'colaborador')),

    -- Status individual
    status VARCHAR(20) DEFAULT 'convidado' CHECK (status IN (
        'convidado',
        'visualizado',
        'aceito',
        'recusado',
        'expirado'
    )),

    -- Tracking
    link_enviado_em TIMESTAMPTZ,
    visualizado_em TIMESTAMPTZ,
    respondido_em TIMESTAMPTZ,
    motivo_recusa TEXT,

    -- Token individual por prestador
    token UUID UNIQUE DEFAULT gen_random_uuid(),

    criado_em TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(solicitacao_id, prestador_id)
);

CREATE INDEX IF NOT EXISTS idx_servico_convidados_solicitacao ON servico_prestadores_convidados(solicitacao_id);
CREATE INDEX IF NOT EXISTS idx_servico_convidados_prestador ON servico_prestadores_convidados(prestador_id);
CREATE INDEX IF NOT EXISTS idx_servico_convidados_token ON servico_prestadores_convidados(token);

-- ===================
-- HISTÓRICO DE STATUS
-- ===================
CREATE TABLE IF NOT EXISTS servico_historico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitacao_id UUID NOT NULL REFERENCES solicitacoes_servico(id) ON DELETE CASCADE,
    status_anterior VARCHAR(20),
    status_novo VARCHAR(20) NOT NULL,
    observacao TEXT,
    criado_por UUID,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_servico_historico_solicitacao ON servico_historico(solicitacao_id);

-- ===================
-- ANEXOS DO SERVIÇO
-- ===================
CREATE TABLE IF NOT EXISTS servico_anexos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitacao_id UUID NOT NULL REFERENCES solicitacoes_servico(id) ON DELETE CASCADE,
    tipo VARCHAR(50),
    nome VARCHAR(255) NOT NULL,
    arquivo_url TEXT NOT NULL,
    tamanho_bytes INTEGER,
    criado_por UUID,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_servico_anexos_solicitacao ON servico_anexos(solicitacao_id);

-- ===================
-- FUNÇÃO: GERAR NÚMERO SEQUENCIAL
-- ===================
CREATE OR REPLACE FUNCTION gerar_numero_servico()
RETURNS TRIGGER AS $$
DECLARE
    ano_atual TEXT;
    proximo_numero INTEGER;
BEGIN
    ano_atual := TO_CHAR(NOW(), 'YYYY');

    SELECT COALESCE(MAX(CAST(SUBSTRING(numero FROM 9) AS INTEGER)), 0) + 1
    INTO proximo_numero
    FROM solicitacoes_servico
    WHERE numero LIKE 'SS-' || ano_atual || '-%';

    NEW.numero := 'SS-' || ano_atual || '-' || LPAD(proximo_numero::TEXT, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_gerar_numero_servico ON solicitacoes_servico;
CREATE TRIGGER trg_gerar_numero_servico
    BEFORE INSERT ON solicitacoes_servico
    FOR EACH ROW
    WHEN (NEW.numero IS NULL)
    EXECUTE FUNCTION gerar_numero_servico();

-- ===================
-- FUNÇÃO: REGISTRAR HISTÓRICO
-- ===================
CREATE OR REPLACE FUNCTION fn_registrar_historico_servico()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO servico_historico (solicitacao_id, status_anterior, status_novo, criado_por)
        VALUES (NEW.id, OLD.status, NEW.status, NEW.atualizado_por);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_historico_servico ON solicitacoes_servico;
CREATE TRIGGER trg_historico_servico
    AFTER UPDATE ON solicitacoes_servico
    FOR EACH ROW
    EXECUTE FUNCTION fn_registrar_historico_servico();

-- ===================
-- FUNÇÃO: GERAR PAGAMENTO AO CONCLUIR
-- ===================
CREATE OR REPLACE FUNCTION fn_gerar_pagamento_servico()
RETURNS TRIGGER AS $$
DECLARE
    v_numero_solicitacao VARCHAR(20);
    v_solicitacao_id UUID;
    v_usuario_id UUID;
BEGIN
    -- Só executa quando muda para 'concluido'
    IF NEW.status = 'concluido' AND (OLD.status IS NULL OR OLD.status != 'concluido') THEN
        -- Busca o usuario_id do criador
        SELECT id INTO v_usuario_id
        FROM usuarios
        WHERE auth_user_id = NEW.criado_por
        LIMIT 1;

        -- Gera número da solicitação de pagamento
        SELECT 'SP-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(
            (COALESCE(MAX(CAST(SUBSTRING(numero_solicitacao FROM 13) AS INTEGER)), 0) + 1)::TEXT,
            4, '0')
        INTO v_numero_solicitacao
        FROM solicitacoes_pagamento
        WHERE numero_solicitacao LIKE 'SP-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-%';

        -- Insere solicitação de pagamento
        INSERT INTO solicitacoes_pagamento (
            numero_solicitacao,
            solicitante_id,
            projeto_id,
            beneficiario_id,
            tipo,
            descricao,
            valor,
            status,
            criado_em
        )
        VALUES (
            v_numero_solicitacao,
            v_usuario_id,
            NEW.projeto_id,
            NEW.prestador_id,
            'prestador',
            'Serviço ' || NEW.numero || ' - ' || NEW.titulo,
            NEW.valor_servico,
            'solicitado',
            NOW()
        )
        RETURNING id INTO v_solicitacao_id;

        -- Atualiza referência na solicitação de serviço
        NEW.solicitacao_pagamento_id := v_solicitacao_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_gerar_pagamento_servico ON solicitacoes_servico;
CREATE TRIGGER trg_gerar_pagamento_servico
    BEFORE UPDATE ON solicitacoes_servico
    FOR EACH ROW
    EXECUTE FUNCTION fn_gerar_pagamento_servico();

-- ===================
-- VIEW: PRESTADORES POR CATEGORIA
-- ===================
CREATE OR REPLACE VIEW vw_prestadores_por_categoria AS
SELECT
    p.id,
    p.nome,
    p.email,
    p.telefone,
    p.tipo AS tipo_pessoa,
    CASE
        WHEN p.tipo = 'FORNECEDOR' THEN 'fornecedor'
        WHEN p.tipo = 'COLABORADOR' THEN 'colaborador'
    END AS prestador_tipo,
    sc.id AS categoria_id,
    sc.codigo AS categoria_codigo,
    sc.nome AS categoria_nome,
    pcv.principal,
    p.ativo
FROM pessoas p
JOIN prestador_categoria_vinculo pcv ON pcv.prestador_id = p.id
JOIN servico_categorias sc ON sc.id = pcv.categoria_id
WHERE p.tipo IN ('FORNECEDOR', 'COLABORADOR')
  AND p.ativo = true
  AND sc.ativo = true
ORDER BY pcv.principal DESC, p.nome;

-- ===================
-- VIEW: DASHBOARD DE SERVIÇOS
-- ===================
CREATE OR REPLACE VIEW vw_dashboard_servicos AS
SELECT
    COUNT(*) FILTER (WHERE status = 'criado') AS total_criados,
    COUNT(*) FILTER (WHERE status = 'enviado') AS total_enviados,
    COUNT(*) FILTER (WHERE status = 'aceito') AS total_aceitos,
    COUNT(*) FILTER (WHERE status = 'em_andamento') AS total_em_andamento,
    COUNT(*) FILTER (WHERE status = 'concluido') AS total_concluidos,
    COUNT(*) FILTER (WHERE status = 'cancelado') AS total_cancelados,
    COALESCE(SUM(valor_servico) FILTER (WHERE status = 'concluido'), 0) AS valor_total_concluido,
    COALESCE(SUM(valor_servico) FILTER (WHERE status IN ('aceito', 'em_andamento')), 0) AS valor_em_execucao,
    COUNT(*) AS total_geral
FROM solicitacoes_servico
WHERE criado_em >= DATE_TRUNC('month', CURRENT_DATE);

-- ===================
-- RLS POLICIES
-- ===================
ALTER TABLE servico_categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE prestador_categoria_vinculo ENABLE ROW LEVEL SECURITY;
ALTER TABLE solicitacoes_servico ENABLE ROW LEVEL SECURITY;
ALTER TABLE servico_prestadores_convidados ENABLE ROW LEVEL SECURITY;
ALTER TABLE servico_historico ENABLE ROW LEVEL SECURITY;
ALTER TABLE servico_anexos ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "servico_categorias_select" ON servico_categorias;
DROP POLICY IF EXISTS "servico_categorias_all" ON servico_categorias;
DROP POLICY IF EXISTS "prestador_vinculo_select" ON prestador_categoria_vinculo;
DROP POLICY IF EXISTS "prestador_vinculo_all" ON prestador_categoria_vinculo;
DROP POLICY IF EXISTS "solicitacoes_servico_select" ON solicitacoes_servico;
DROP POLICY IF EXISTS "solicitacoes_servico_all" ON solicitacoes_servico;
DROP POLICY IF EXISTS "convidados_select" ON servico_prestadores_convidados;
DROP POLICY IF EXISTS "convidados_all" ON servico_prestadores_convidados;
DROP POLICY IF EXISTS "historico_select" ON servico_historico;
DROP POLICY IF EXISTS "historico_insert" ON servico_historico;
DROP POLICY IF EXISTS "anexos_select" ON servico_anexos;
DROP POLICY IF EXISTS "anexos_all" ON servico_anexos;
DROP POLICY IF EXISTS "solicitacoes_servico_public_token" ON solicitacoes_servico;
DROP POLICY IF EXISTS "convidados_public_token" ON servico_prestadores_convidados;
DROP POLICY IF EXISTS "convidados_public_update" ON servico_prestadores_convidados;

-- Políticas para usuários autenticados
CREATE POLICY "servico_categorias_select" ON servico_categorias FOR SELECT TO authenticated USING (true);
CREATE POLICY "servico_categorias_all" ON servico_categorias FOR ALL TO authenticated USING (true);

CREATE POLICY "prestador_vinculo_select" ON prestador_categoria_vinculo FOR SELECT TO authenticated USING (true);
CREATE POLICY "prestador_vinculo_all" ON prestador_categoria_vinculo FOR ALL TO authenticated USING (true);

CREATE POLICY "solicitacoes_servico_select" ON solicitacoes_servico FOR SELECT TO authenticated USING (true);
CREATE POLICY "solicitacoes_servico_all" ON solicitacoes_servico FOR ALL TO authenticated USING (true);

CREATE POLICY "convidados_select" ON servico_prestadores_convidados FOR SELECT TO authenticated USING (true);
CREATE POLICY "convidados_all" ON servico_prestadores_convidados FOR ALL TO authenticated USING (true);

CREATE POLICY "historico_select" ON servico_historico FOR SELECT TO authenticated USING (true);
CREATE POLICY "historico_insert" ON servico_historico FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "anexos_select" ON servico_anexos FOR SELECT TO authenticated USING (true);
CREATE POLICY "anexos_all" ON servico_anexos FOR ALL TO authenticated USING (true);

-- Política para acesso público (link de aceite)
CREATE POLICY "solicitacoes_servico_public_token" ON solicitacoes_servico
    FOR SELECT TO anon
    USING (token_aceite IS NOT NULL);

CREATE POLICY "convidados_public_token" ON servico_prestadores_convidados
    FOR SELECT TO anon
    USING (token IS NOT NULL);

CREATE POLICY "convidados_public_update" ON servico_prestadores_convidados
    FOR UPDATE TO anon
    USING (token IS NOT NULL);

-- ===================
-- GRANTS
-- ===================
GRANT SELECT ON vw_prestadores_por_categoria TO authenticated;
GRANT SELECT ON vw_dashboard_servicos TO authenticated;
