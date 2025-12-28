-- ============================================================================
-- SISTEMA WGEASY - ÁREA DO COLABORADOR E FORNECEDOR
-- Esquema completo de banco de dados
-- ============================================================================

-- ============================================================================
-- PARTE 1: PERFIS DE COLABORADOR (RBAC GRANULAR)
-- ============================================================================

-- Tabela de perfis de colaborador
CREATE TABLE IF NOT EXISTS colaborador_perfis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    nivel_hierarquico INTEGER DEFAULT 1, -- 1=operacional, 2=coordenacao, 3=gerencia, 4=diretoria
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir perfis padrão
INSERT INTO colaborador_perfis (codigo, nome, descricao, nivel_hierarquico) VALUES
('DIRETORIA', 'Diretoria / Administração', 'Acesso total ao sistema, aprovações finais', 4),
('COORDENADOR', 'Coordenador de Projetos / Obras', 'Gestão de projetos e equipes, aprovações intermediárias', 3),
('ARQUITETO', 'Arquiteto / Projetista', 'Desenvolvimento de projetos, acompanhamento técnico', 2),
('COMERCIAL', 'Comercial', 'Prospecção, propostas, relacionamento com clientes', 2),
('FINANCEIRO', 'Financeiro', 'Gestão financeira, pagamentos, cobranças', 2),
('APOIO', 'Apoio Operacional', 'Suporte administrativo e operacional', 1)
ON CONFLICT (codigo) DO NOTHING;

-- Vincular colaborador a perfil
ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS colaborador_perfil_id UUID REFERENCES colaborador_perfis(id);

-- ============================================================================
-- PARTE 2: VINCULAÇÃO DE COLABORADORES A PROJETOS
-- ============================================================================

-- Tabela de vínculo colaborador-projeto
CREATE TABLE IF NOT EXISTS colaborador_projetos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    colaborador_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,
    projeto_id UUID NOT NULL REFERENCES contratos(id) ON DELETE CASCADE, -- contrato = projeto
    funcao VARCHAR(100), -- 'Arquiteto Responsável', 'Coordenador', etc.
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id),
    UNIQUE(colaborador_id, projeto_id)
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_colab_proj_colaborador ON colaborador_projetos(colaborador_id);
CREATE INDEX IF NOT EXISTS idx_colab_proj_projeto ON colaborador_projetos(projeto_id);

-- ============================================================================
-- PARTE 3: SOLICITAÇÕES DE PAGAMENTO
-- ============================================================================

-- Status de solicitação de pagamento
DO $$ BEGIN
    CREATE TYPE status_solicitacao_pagamento AS ENUM (
        'rascunho',
        'solicitado',
        'em_analise',
        'aprovado',
        'rejeitado',
        'pago',
        'cancelado'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Tipo de solicitação
DO $$ BEGIN
    CREATE TYPE tipo_solicitacao_pagamento AS ENUM (
        'prestador',
        'fornecedor',
        'reembolso',
        'comissao',
        'honorario',
        'outros'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Tabela de solicitações de pagamento
CREATE TABLE IF NOT EXISTS solicitacoes_pagamento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_solicitacao VARCHAR(20) UNIQUE, -- SP-2024-0001

    -- Solicitante
    solicitante_id UUID NOT NULL REFERENCES pessoas(id),

    -- Projeto/Contrato relacionado (opcional)
    projeto_id UUID REFERENCES contratos(id),

    -- Beneficiário
    beneficiario_id UUID REFERENCES pessoas(id), -- fornecedor ou prestador
    beneficiario_nome VARCHAR(200), -- caso não esteja cadastrado
    beneficiario_documento VARCHAR(20), -- CPF ou CNPJ

    -- Dados do pagamento
    tipo tipo_solicitacao_pagamento NOT NULL,
    descricao TEXT NOT NULL,
    valor DECIMAL(15,2) NOT NULL,

    -- Dados bancários
    banco VARCHAR(100),
    agencia VARCHAR(20),
    conta VARCHAR(30),
    tipo_conta VARCHAR(20), -- corrente, poupança, pix
    chave_pix VARCHAR(100),

    -- Datas
    data_vencimento DATE,
    data_pagamento DATE,

    -- Status e fluxo
    status status_solicitacao_pagamento DEFAULT 'rascunho',

    -- Aprovações
    aprovado_por UUID REFERENCES auth.users(id),
    data_aprovacao TIMESTAMP WITH TIME ZONE,
    motivo_rejeicao TEXT,

    -- Vínculo com lançamento financeiro (após aprovação)
    lancamento_id UUID, -- REFERENCES fin_lancamentos(id) se existir

    -- Auditoria
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_por UUID REFERENCES auth.users(id)
);

-- Sequência para número de solicitação
CREATE SEQUENCE IF NOT EXISTS seq_solicitacao_pagamento START 1;

-- Função para gerar número de solicitação
CREATE OR REPLACE FUNCTION gerar_numero_solicitacao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.numero_solicitacao IS NULL THEN
        NEW.numero_solicitacao := 'SP-' || EXTRACT(YEAR FROM NOW()) || '-' ||
            LPAD(nextval('seq_solicitacao_pagamento')::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger apenas se a coluna numero_solicitacao existir
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'solicitacoes_pagamento' AND column_name = 'numero_solicitacao'
    ) THEN
        DROP TRIGGER IF EXISTS trg_gerar_numero_solicitacao ON solicitacoes_pagamento;
        CREATE TRIGGER trg_gerar_numero_solicitacao
            BEFORE INSERT ON solicitacoes_pagamento
            FOR EACH ROW
            EXECUTE FUNCTION gerar_numero_solicitacao();
    END IF;
END $$;

-- Anexos de solicitação
CREATE TABLE IF NOT EXISTS solicitacoes_pagamento_anexos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitacao_id UUID NOT NULL REFERENCES solicitacoes_pagamento(id) ON DELETE CASCADE,
    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(50), -- 'nota_fiscal', 'recibo', 'contrato', 'comprovante', 'outros'
    arquivo_url TEXT NOT NULL,
    tamanho_bytes INTEGER,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id)
);

-- Histórico de aprovações
CREATE TABLE IF NOT EXISTS solicitacoes_pagamento_historico (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitacao_id UUID NOT NULL REFERENCES solicitacoes_pagamento(id) ON DELETE CASCADE,
    status_anterior status_solicitacao_pagamento,
    status_novo status_solicitacao_pagamento NOT NULL,
    observacao TEXT,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id)
);

-- Trigger para histórico automático
CREATE OR REPLACE FUNCTION registrar_historico_solicitacao()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO solicitacoes_pagamento_historico (solicitacao_id, status_anterior, status_novo, criado_por)
        VALUES (NEW.id, OLD.status, NEW.status, NEW.atualizado_por);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger apenas se a estrutura da tabela for compatível
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'solicitacoes_pagamento' AND column_name = 'solicitante_id'
    ) THEN
        DROP TRIGGER IF EXISTS trg_historico_solicitacao ON solicitacoes_pagamento;
        CREATE TRIGGER trg_historico_solicitacao
            AFTER UPDATE ON solicitacoes_pagamento
            FOR EACH ROW
            EXECUTE FUNCTION registrar_historico_solicitacao();
    END IF;
END $$;

-- ============================================================================
-- PARTE 4: VALORES A RECEBER DO COLABORADOR
-- ============================================================================

-- Tipos de valor a receber
DO $$ BEGIN
    CREATE TYPE tipo_valor_receber AS ENUM (
        'comissao',
        'honorario',
        'fee_projeto',
        'bonus',
        'repasse',
        'outros'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Status do valor a receber
DO $$ BEGIN
    CREATE TYPE status_valor_receber AS ENUM (
        'previsto',
        'aprovado',
        'liberado',
        'pago',
        'cancelado'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Tabela de valores a receber
CREATE TABLE IF NOT EXISTS colaborador_valores_receber (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    colaborador_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,

    -- Origem do valor
    projeto_id UUID REFERENCES contratos(id),
    parcela_id UUID, -- REFERENCES fin_parcelas(id) se existir

    -- Dados do valor
    tipo tipo_valor_receber NOT NULL,
    descricao TEXT,
    valor DECIMAL(15,2) NOT NULL,
    percentual DECIMAL(5,2), -- se for baseado em %

    -- Condições de liberação
    condicao_liberacao TEXT, -- 'Após recebimento da parcela X', etc.
    data_prevista DATE,
    data_liberacao DATE,
    data_pagamento DATE,

    -- Status
    status status_valor_receber DEFAULT 'previsto',

    -- Vínculo com pagamento
    solicitacao_pagamento_id UUID REFERENCES solicitacoes_pagamento(id),

    -- Auditoria
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- PARTE 5: REGISTROS DE OBRA (COLABORADOR)
-- ============================================================================

-- Registro diário de obra
CREATE TABLE IF NOT EXISTS obra_registros (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    projeto_id UUID NOT NULL REFERENCES contratos(id) ON DELETE CASCADE,
    colaborador_id UUID NOT NULL REFERENCES pessoas(id),

    data_registro DATE NOT NULL DEFAULT CURRENT_DATE,

    -- Informações do registro
    titulo VARCHAR(200),
    descricao TEXT,

    -- Etapa relacionada
    etapa_cronograma_id UUID, -- REFERENCES cronograma_tarefas se existir
    percentual_avanco DECIMAL(5,2),

    -- Condições
    clima VARCHAR(50), -- 'ensolarado', 'nublado', 'chuvoso'
    equipe_presente INTEGER,

    -- Observações
    observacoes TEXT,
    pendencias TEXT,

    -- Auditoria
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Fotos de registro de obra
CREATE TABLE IF NOT EXISTS obra_registros_fotos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    registro_id UUID NOT NULL REFERENCES obra_registros(id) ON DELETE CASCADE,

    arquivo_url TEXT NOT NULL,
    descricao VARCHAR(255),
    ordem INTEGER DEFAULT 0,

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Checklist de obra
CREATE TABLE IF NOT EXISTS obra_checklists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    projeto_id UUID NOT NULL REFERENCES contratos(id) ON DELETE CASCADE,
    etapa VARCHAR(100), -- 'fundacao', 'estrutura', 'acabamento', etc.

    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id)
);

-- Itens do checklist
CREATE TABLE IF NOT EXISTS obra_checklist_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    checklist_id UUID NOT NULL REFERENCES obra_checklists(id) ON DELETE CASCADE,

    descricao VARCHAR(255) NOT NULL,
    ordem INTEGER DEFAULT 0,
    obrigatorio BOOLEAN DEFAULT false,

    -- Status
    concluido BOOLEAN DEFAULT false,
    data_conclusao TIMESTAMP WITH TIME ZONE,
    concluido_por UUID REFERENCES auth.users(id),
    observacao TEXT,

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- PARTE 6: ÁREA DO FORNECEDOR - COTAÇÕES
-- ============================================================================

-- Categorias de fornecedor
CREATE TABLE IF NOT EXISTS fornecedor_categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    icone VARCHAR(50),
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inserir categorias padrão
INSERT INTO fornecedor_categorias (codigo, nome, descricao, icone) VALUES
('ELETRICA', 'Elétrica', 'Instalações elétricas e iluminação', 'Zap'),
('HIDRAULICA', 'Hidráulica', 'Instalações hidráulicas e sanitárias', 'Droplets'),
('ALVENARIA', 'Alvenaria / Pedreiro', 'Construção civil, alvenaria', 'Brick'),
('GESSO', 'Gesso / Drywall', 'Forros e divisórias', 'Square'),
('PINTURA', 'Pintura', 'Pintura residencial e comercial', 'Paintbrush'),
('MARCENARIA', 'Marcenaria', 'Móveis sob medida', 'Armchair'),
('MARMORARIA', 'Marmoraria', 'Mármores e granitos', 'Mountain'),
('VIDRACARIA', 'Vidraçaria', 'Vidros e espelhos', 'Frame'),
('ARCONDICIONADO', 'Ar Condicionado', 'Climatização', 'Wind'),
('SERRALHERIA', 'Serralheria', 'Estruturas metálicas', 'Hammer'),
('AUTOMACAO', 'Automação', 'Automação residencial', 'Cpu'),
('PAISAGISMO', 'Paisagismo', 'Jardins e áreas externas', 'TreeDeciduous'),
('PISCINA', 'Piscina', 'Construção e manutenção de piscinas', 'Waves'),
('OUTROS', 'Outros', 'Outras categorias', 'MoreHorizontal')
ON CONFLICT (codigo) DO NOTHING;

-- Vincular fornecedor a categorias (muitos para muitos)
CREATE TABLE IF NOT EXISTS fornecedor_categoria_vinculo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fornecedor_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,
    categoria_id UUID NOT NULL REFERENCES fornecedor_categorias(id) ON DELETE CASCADE,
    principal BOOLEAN DEFAULT false, -- categoria principal
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(fornecedor_id, categoria_id)
);

-- Status da cotação
DO $$ BEGIN
    CREATE TYPE status_cotacao AS ENUM (
        'aberta',
        'em_andamento',
        'encerrada',
        'cancelada'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Solicitação de cotação (criada pela WG)
CREATE TABLE IF NOT EXISTS cotacoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_cotacao VARCHAR(20) UNIQUE, -- COT-2024-0001

    -- Projeto relacionado
    projeto_id UUID REFERENCES contratos(id),
    projeto_nome VARCHAR(200), -- nome do projeto (visível ao fornecedor)

    -- Categoria da cotação
    categoria_id UUID NOT NULL REFERENCES fornecedor_categorias(id),

    -- Informações gerais
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,

    -- Datas
    data_abertura TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    data_limite TIMESTAMP WITH TIME ZONE NOT NULL, -- prazo para envio de propostas
    prazo_execucao_dias INTEGER, -- prazo esperado de execução

    -- Status
    status status_cotacao DEFAULT 'aberta',

    -- Configurações
    permite_proposta_parcial BOOLEAN DEFAULT false, -- fornecedor pode cotar apenas alguns itens
    exige_visita_tecnica BOOLEAN DEFAULT false,

    -- Resultado
    fornecedor_vencedor_id UUID REFERENCES pessoas(id),
    data_fechamento TIMESTAMP WITH TIME ZONE,
    observacao_fechamento TEXT,

    -- Auditoria
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sequência para número de cotação
CREATE SEQUENCE IF NOT EXISTS seq_cotacao START 1;

-- Função para gerar número de cotação
CREATE OR REPLACE FUNCTION gerar_numero_cotacao()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.numero_cotacao IS NULL THEN
        NEW.numero_cotacao := 'COT-' || EXTRACT(YEAR FROM NOW()) || '-' ||
            LPAD(nextval('seq_cotacao')::TEXT, 4, '0');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_gerar_numero_cotacao ON cotacoes;
CREATE TRIGGER trg_gerar_numero_cotacao
    BEFORE INSERT ON cotacoes
    FOR EACH ROW
    EXECUTE FUNCTION gerar_numero_cotacao();

-- Itens da cotação (o que precisa ser cotado)
CREATE TABLE IF NOT EXISTS cotacao_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cotacao_id UUID NOT NULL REFERENCES cotacoes(id) ON DELETE CASCADE,

    descricao VARCHAR(500) NOT NULL,
    unidade VARCHAR(20), -- 'un', 'm²', 'ml', 'verba', etc.
    quantidade DECIMAL(15,3),

    -- Especificações técnicas
    especificacao TEXT,
    referencia VARCHAR(200), -- modelo/marca de referência

    ordem INTEGER DEFAULT 0,

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Fornecedores convidados para cotação
CREATE TABLE IF NOT EXISTS cotacao_fornecedores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cotacao_id UUID NOT NULL REFERENCES cotacoes(id) ON DELETE CASCADE,
    fornecedor_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,

    -- Status do convite
    data_convite TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    visualizado BOOLEAN DEFAULT false,
    data_visualizacao TIMESTAMP WITH TIME ZONE,

    -- Resposta
    participando BOOLEAN, -- null = não respondeu, true = vai participar, false = declinou
    motivo_declinio TEXT,

    UNIQUE(cotacao_id, fornecedor_id)
);

-- Status da proposta do fornecedor
DO $$ BEGIN
    CREATE TYPE status_proposta_fornecedor AS ENUM (
        'rascunho',
        'enviada',
        'em_analise',
        'aprovada',
        'rejeitada',
        'vencedora'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Proposta do fornecedor
CREATE TABLE IF NOT EXISTS cotacao_propostas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cotacao_id UUID NOT NULL REFERENCES cotacoes(id) ON DELETE CASCADE,
    fornecedor_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,

    -- Dados da proposta
    valor_total DECIMAL(15,2) NOT NULL,
    prazo_execucao_dias INTEGER,
    validade_proposta_dias INTEGER DEFAULT 30,

    -- Condições
    condicoes_pagamento TEXT,
    observacoes TEXT,

    -- Garantia oferecida
    garantia_meses INTEGER,
    descricao_garantia TEXT,

    -- Status
    status status_proposta_fornecedor DEFAULT 'rascunho',
    data_envio TIMESTAMP WITH TIME ZONE,

    -- Avaliação interna (não visível ao fornecedor)
    nota_interna INTEGER CHECK (nota_interna >= 1 AND nota_interna <= 5),
    comentario_interno TEXT,

    -- Auditoria
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(cotacao_id, fornecedor_id)
);

-- Itens da proposta do fornecedor
CREATE TABLE IF NOT EXISTS cotacao_proposta_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposta_id UUID NOT NULL REFERENCES cotacao_propostas(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES cotacao_itens(id) ON DELETE CASCADE,

    valor_unitario DECIMAL(15,2) NOT NULL,
    valor_total DECIMAL(15,2) NOT NULL,

    -- Detalhes
    marca_modelo VARCHAR(200),
    observacao TEXT,

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(proposta_id, item_id)
);

-- Anexos da proposta
CREATE TABLE IF NOT EXISTS cotacao_proposta_anexos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposta_id UUID NOT NULL REFERENCES cotacao_propostas(id) ON DELETE CASCADE,

    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(50), -- 'proposta_pdf', 'catalogo', 'certificado', 'outros'
    arquivo_url TEXT NOT NULL,
    tamanho_bytes INTEGER,

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- PARTE 7: VÍNCULO FORNECEDOR-PROJETO (SERVIÇOS CONTRATADOS)
-- ============================================================================

-- Status do serviço contratado
DO $$ BEGIN
    CREATE TYPE status_servico_contratado AS ENUM (
        'contratado',
        'em_execucao',
        'pausado',
        'concluido',
        'cancelado'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Serviços contratados com fornecedores
CREATE TABLE IF NOT EXISTS fornecedor_servicos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    fornecedor_id UUID NOT NULL REFERENCES pessoas(id) ON DELETE CASCADE,
    projeto_id UUID NOT NULL REFERENCES contratos(id) ON DELETE CASCADE,

    -- Origem (se veio de cotação)
    cotacao_id UUID REFERENCES cotacoes(id),
    proposta_id UUID REFERENCES cotacao_propostas(id),

    -- Dados do serviço
    descricao TEXT NOT NULL,
    categoria_id UUID REFERENCES fornecedor_categorias(id),

    valor_contratado DECIMAL(15,2) NOT NULL,

    -- Datas
    data_contratacao DATE NOT NULL DEFAULT CURRENT_DATE,
    data_inicio_prevista DATE,
    data_fim_prevista DATE,
    data_conclusao DATE,

    -- Status
    status status_servico_contratado DEFAULT 'contratado',
    percentual_execucao DECIMAL(5,2) DEFAULT 0,

    -- Condições
    condicoes_pagamento TEXT,
    garantia_meses INTEGER,

    -- Auditoria
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    criado_por UUID REFERENCES auth.users(id),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Parcelas de pagamento do fornecedor
CREATE TABLE IF NOT EXISTS fornecedor_servico_parcelas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    servico_id UUID NOT NULL REFERENCES fornecedor_servicos(id) ON DELETE CASCADE,

    numero_parcela INTEGER NOT NULL,
    descricao VARCHAR(200), -- 'Sinal', '30 dias', 'Conclusão', etc.

    valor DECIMAL(15,2) NOT NULL,
    data_vencimento DATE,

    -- Condição de liberação
    condicao VARCHAR(200), -- 'Após aprovação etapa X', etc.

    -- Pagamento
    data_pagamento DATE,
    valor_pago DECIMAL(15,2),
    comprovante_url TEXT,

    -- Vínculo com financeiro
    lancamento_id UUID, -- REFERENCES fin_lancamentos se existir

    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- PARTE 8: LOGS E AUDITORIA
-- ============================================================================

-- Tipos de ação para auditoria
DO $$ BEGIN
    CREATE TYPE tipo_acao_auditoria AS ENUM (
        'criar',
        'editar',
        'excluir',
        'aprovar',
        'rejeitar',
        'enviar',
        'visualizar',
        'download',
        'upload',
        'login',
        'logout'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Tabela de auditoria geral
CREATE TABLE IF NOT EXISTS auditoria_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Usuário que executou
    usuario_id UUID REFERENCES auth.users(id),
    pessoa_id UUID REFERENCES pessoas(id),

    -- Ação
    acao tipo_acao_auditoria NOT NULL,

    -- Entidade afetada
    tabela VARCHAR(100) NOT NULL,
    registro_id UUID,

    -- Dados
    dados_anteriores JSONB,
    dados_novos JSONB,

    -- Contexto
    ip_address INET,
    user_agent TEXT,

    -- Timestamp
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para auditoria
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario ON auditoria_logs(usuario_id);
CREATE INDEX IF NOT EXISTS idx_auditoria_tabela ON auditoria_logs(tabela);
CREATE INDEX IF NOT EXISTS idx_auditoria_criado ON auditoria_logs(criado_em);

-- ============================================================================
-- PARTE 9: VIEWS ÚTEIS
-- ============================================================================

-- View de colaboradores com perfil
CREATE OR REPLACE VIEW vw_colaboradores_completo AS
SELECT
    p.id,
    p.nome,
    p.email,
    p.telefone,
    p.cpf,
    p.cargo,
    p.avatar_url,
    p.ativo,
    cp.codigo as perfil_codigo,
    cp.nome as perfil_nome,
    cp.nivel_hierarquico,
    u.auth_user_id,
    u.tipo_usuario,
    (SELECT COUNT(*) FROM colaborador_projetos cp2 WHERE cp2.colaborador_id = p.id AND cp2.ativo) as total_projetos,
    (SELECT COALESCE(SUM(cvr.valor), 0) FROM colaborador_valores_receber cvr WHERE cvr.colaborador_id = p.id AND cvr.status = 'previsto') as valor_previsto,
    (SELECT COALESCE(SUM(cvr.valor), 0) FROM colaborador_valores_receber cvr WHERE cvr.colaborador_id = p.id AND cvr.status = 'pago') as valor_recebido
FROM pessoas p
LEFT JOIN colaborador_perfis cp ON p.colaborador_perfil_id = cp.id
LEFT JOIN usuarios u ON u.pessoa_id = p.id
WHERE p.tipo = 'COLABORADOR';

-- View de fornecedores com categorias
CREATE OR REPLACE VIEW vw_fornecedores_completo AS
SELECT
    p.id,
    p.nome,
    p.email,
    p.telefone,
    p.cpf,
    p.empresa,
    p.avatar_url,
    p.ativo,
    u.auth_user_id,
    ARRAY_AGG(DISTINCT fc.nome) FILTER (WHERE fc.nome IS NOT NULL) as categorias,
    (SELECT COUNT(*) FROM fornecedor_servicos fs WHERE fs.fornecedor_id = p.id) as total_servicos,
    (SELECT COALESCE(SUM(fs.valor_contratado), 0) FROM fornecedor_servicos fs WHERE fs.fornecedor_id = p.id) as valor_total_contratado,
    (SELECT COALESCE(SUM(fsp.valor_pago), 0) FROM fornecedor_servico_parcelas fsp
        JOIN fornecedor_servicos fs2 ON fsp.servico_id = fs2.id
        WHERE fs2.fornecedor_id = p.id) as valor_total_pago
FROM pessoas p
LEFT JOIN usuarios u ON u.pessoa_id = p.id
LEFT JOIN fornecedor_categoria_vinculo fcv ON fcv.fornecedor_id = p.id
LEFT JOIN fornecedor_categorias fc ON fcv.categoria_id = fc.id
WHERE p.tipo = 'FORNECEDOR'
GROUP BY p.id, p.nome, p.email, p.telefone, p.cpf, p.empresa, p.avatar_url, p.ativo, u.auth_user_id;

-- View de cotações abertas para fornecedor
CREATE OR REPLACE VIEW vw_cotacoes_fornecedor AS
SELECT
    c.id,
    c.numero_cotacao,
    c.projeto_nome,
    c.titulo,
    c.descricao,
    c.data_limite,
    c.prazo_execucao_dias,
    c.status,
    c.permite_proposta_parcial,
    c.exige_visita_tecnica,
    fc.nome as categoria,
    cf.fornecedor_id,
    cf.visualizado,
    cf.participando,
    cp.id as proposta_id,
    cp.status as proposta_status,
    cp.valor_total as proposta_valor
FROM cotacoes c
JOIN fornecedor_categorias fc ON c.categoria_id = fc.id
JOIN cotacao_fornecedores cf ON cf.cotacao_id = c.id
LEFT JOIN cotacao_propostas cp ON cp.cotacao_id = c.id AND cp.fornecedor_id = cf.fornecedor_id
WHERE c.status IN ('aberta', 'em_andamento');

-- ============================================================================
-- PARTE 10: RLS POLICIES
-- ============================================================================

-- Habilitar RLS nas tabelas (ignorar erros se já habilitado)
ALTER TABLE colaborador_projetos ENABLE ROW LEVEL SECURITY;
ALTER TABLE colaborador_valores_receber ENABLE ROW LEVEL SECURITY;
ALTER TABLE obra_registros ENABLE ROW LEVEL SECURITY;
ALTER TABLE cotacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE cotacao_fornecedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE cotacao_propostas ENABLE ROW LEVEL SECURITY;
ALTER TABLE fornecedor_servicos ENABLE ROW LEVEL SECURITY;

-- Remover políticas existentes antes de recriar
DROP POLICY IF EXISTS colaborador_projetos_select ON colaborador_projetos;
DROP POLICY IF EXISTS solicitacoes_pagamento_select ON solicitacoes_pagamento;
DROP POLICY IF EXISTS valores_receber_select ON colaborador_valores_receber;
DROP POLICY IF EXISTS cotacoes_fornecedor_select ON cotacoes;
DROP POLICY IF EXISTS propostas_fornecedor_select ON cotacao_propostas;
DROP POLICY IF EXISTS servicos_fornecedor_select ON fornecedor_servicos;

-- Policy: Colaborador vê apenas seus projetos
CREATE POLICY colaborador_projetos_select ON colaborador_projetos
    FOR SELECT USING (
        colaborador_id IN (
            SELECT p.id FROM pessoas p
            JOIN usuarios u ON u.pessoa_id = p.id
            WHERE u.auth_user_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'DIRETORIA')
        )
    );

-- Policy: Colaborador vê apenas suas solicitações (ou admin vê todas)
-- Nota: Esta política só será criada se a coluna solicitante_id existir
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'solicitacoes_pagamento' AND column_name = 'solicitante_id'
    ) THEN
        ALTER TABLE solicitacoes_pagamento ENABLE ROW LEVEL SECURITY;
        EXECUTE '
            CREATE POLICY solicitacoes_pagamento_select ON solicitacoes_pagamento
            FOR SELECT USING (
                solicitante_id IN (
                    SELECT p.id FROM pessoas p
                    JOIN usuarios u ON u.pessoa_id = p.id
                    WHERE u.auth_user_id = auth.uid()
                )
                OR EXISTS (
                    SELECT 1 FROM usuarios u
                    WHERE u.auth_user_id = auth.uid()
                    AND u.tipo_usuario IN (''MASTER'', ''ADMIN'', ''FINANCEIRO'', ''DIRETORIA'')
                )
            )
        ';
    END IF;
END $$;

-- Policy: Colaborador vê apenas seus valores a receber
CREATE POLICY valores_receber_select ON colaborador_valores_receber
    FOR SELECT USING (
        colaborador_id IN (
            SELECT p.id FROM pessoas p
            JOIN usuarios u ON u.pessoa_id = p.id
            WHERE u.auth_user_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'FINANCEIRO', 'DIRETORIA')
        )
    );

-- Policy: Fornecedor vê apenas cotações onde foi convidado
CREATE POLICY cotacoes_fornecedor_select ON cotacoes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM cotacao_fornecedores cf
            JOIN pessoas p ON p.id = cf.fornecedor_id
            JOIN usuarios u ON u.pessoa_id = p.id
            WHERE cf.cotacao_id = cotacoes.id
            AND u.auth_user_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COORDENADOR')
        )
    );

-- Policy: Fornecedor vê apenas suas propostas
CREATE POLICY propostas_fornecedor_select ON cotacao_propostas
    FOR SELECT USING (
        fornecedor_id IN (
            SELECT p.id FROM pessoas p
            JOIN usuarios u ON u.pessoa_id = p.id
            WHERE u.auth_user_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario IN ('MASTER', 'ADMIN', 'COMERCIAL', 'COORDENADOR', 'FINANCEIRO')
        )
    );

-- Policy: Fornecedor vê apenas seus serviços contratados
CREATE POLICY servicos_fornecedor_select ON fornecedor_servicos
    FOR SELECT USING (
        fornecedor_id IN (
            SELECT p.id FROM pessoas p
            JOIN usuarios u ON u.pessoa_id = p.id
            WHERE u.auth_user_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_user_id = auth.uid()
            AND u.tipo_usuario NOT IN ('CLIENTE', 'FORNECEDOR', 'ESPECIFICADOR')
        )
    );

-- ============================================================================
-- PARTE 11: FUNÇÕES AUXILIARES
-- ============================================================================

-- Função para obter resumo financeiro do colaborador
CREATE OR REPLACE FUNCTION fn_resumo_financeiro_colaborador(p_colaborador_id UUID)
RETURNS TABLE (
    valor_previsto DECIMAL,
    valor_aprovado DECIMAL,
    valor_liberado DECIMAL,
    valor_pago DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(SUM(CASE WHEN cvr.status = 'previsto' THEN cvr.valor ELSE 0 END), 0) as valor_previsto,
        COALESCE(SUM(CASE WHEN cvr.status = 'aprovado' THEN cvr.valor ELSE 0 END), 0) as valor_aprovado,
        COALESCE(SUM(CASE WHEN cvr.status = 'liberado' THEN cvr.valor ELSE 0 END), 0) as valor_liberado,
        COALESCE(SUM(CASE WHEN cvr.status = 'pago' THEN cvr.valor ELSE 0 END), 0) as valor_pago
    FROM colaborador_valores_receber cvr
    WHERE cvr.colaborador_id = p_colaborador_id;
END;
$$ LANGUAGE plpgsql;

-- Função para obter resumo financeiro do fornecedor
CREATE OR REPLACE FUNCTION fn_resumo_financeiro_fornecedor(p_fornecedor_id UUID)
RETURNS TABLE (
    valor_contratado DECIMAL,
    valor_pago DECIMAL,
    valor_pendente DECIMAL,
    total_servicos INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(SUM(fs.valor_contratado), 0) as valor_contratado,
        COALESCE(SUM(fsp.valor_pago), 0) as valor_pago,
        COALESCE(SUM(fs.valor_contratado), 0) - COALESCE(SUM(fsp.valor_pago), 0) as valor_pendente,
        COUNT(DISTINCT fs.id)::INTEGER as total_servicos
    FROM fornecedor_servicos fs
    LEFT JOIN fornecedor_servico_parcelas fsp ON fsp.servico_id = fs.id
    WHERE fs.fornecedor_id = p_fornecedor_id;
END;
$$ LANGUAGE plpgsql;

-- Função para convidar fornecedores para cotação por categoria
CREATE OR REPLACE FUNCTION fn_convidar_fornecedores_cotacao(p_cotacao_id UUID)
RETURNS INTEGER AS $$
DECLARE
    v_categoria_id UUID;
    v_total INTEGER := 0;
BEGIN
    -- Obter categoria da cotação
    SELECT categoria_id INTO v_categoria_id FROM cotacoes WHERE id = p_cotacao_id;

    -- Inserir convites para todos fornecedores da categoria
    INSERT INTO cotacao_fornecedores (cotacao_id, fornecedor_id)
    SELECT p_cotacao_id, fcv.fornecedor_id
    FROM fornecedor_categoria_vinculo fcv
    JOIN pessoas p ON p.id = fcv.fornecedor_id AND p.ativo = true
    WHERE fcv.categoria_id = v_categoria_id
    ON CONFLICT (cotacao_id, fornecedor_id) DO NOTHING;

    GET DIAGNOSTICS v_total = ROW_COUNT;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================
