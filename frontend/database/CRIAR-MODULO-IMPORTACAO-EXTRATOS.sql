-- ========================================
-- MÓDULO DE IMPORTAÇÃO INTELIGENTE DE EXTRATOS
-- ========================================

-- 1. Tabela de importações (histórico)
CREATE TABLE IF NOT EXISTS financeiro_importacoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Arquivo original
    nome_arquivo TEXT NOT NULL,
    tipo_arquivo TEXT NOT NULL, -- pdf, xlsx, csv, ofx
    tamanho_bytes INTEGER,

    -- Conta bancária relacionada
    conta_bancaria_id UUID REFERENCES financeiro_contas_bancarias(id),

    -- Status da importação
    status TEXT DEFAULT 'pendente' CHECK (status IN ('pendente', 'processando', 'revisao', 'concluido', 'erro')),

    -- Estatísticas
    total_linhas INTEGER DEFAULT 0,
    linhas_importadas INTEGER DEFAULT 0,
    linhas_duplicadas INTEGER DEFAULT 0,
    linhas_erro INTEGER DEFAULT 0,
    linhas_a_definir INTEGER DEFAULT 0,

    -- Período do extrato
    data_inicio DATE,
    data_fim DATE,

    -- Auditoria
    criado_por UUID,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processado_em TIMESTAMP WITH TIME ZONE,

    -- Erros
    erro_mensagem TEXT
);

-- 2. Tabela de itens da importação (antes de confirmar)
CREATE TABLE IF NOT EXISTS financeiro_importacao_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    importacao_id UUID NOT NULL REFERENCES financeiro_importacoes(id) ON DELETE CASCADE,

    -- Dados extraídos do arquivo
    data_transacao DATE NOT NULL,
    descricao_original TEXT NOT NULL,
    valor NUMERIC(15,2) NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('entrada', 'saida')),

    -- Dados identificados pela IA
    descricao_formatada TEXT,
    categoria_sugerida TEXT,
    categoria_id UUID REFERENCES financeiro_categorias(id),
    projeto_sugerido TEXT,
    projeto_id UUID REFERENCES projetos(id),
    contrato_sugerido TEXT,
    contrato_id UUID REFERENCES contratos(id),
    pessoa_sugerida TEXT,
    pessoa_id UUID REFERENCES pessoas(id),

    -- Confiança da IA (0-100)
    confianca_categoria INTEGER DEFAULT 0,
    confianca_projeto INTEGER DEFAULT 0,

    -- Status do item
    status TEXT DEFAULT 'pendente' CHECK (status IN ('pendente', 'aprovado', 'rejeitado', 'duplicado', 'a_definir')),

    -- Se foi encontrado como duplicata
    duplicata_de UUID REFERENCES financeiro_lancamentos(id),

    -- Observações do usuário
    observacoes TEXT,

    -- Se já foi importado para lançamentos
    lancamento_id UUID REFERENCES financeiro_lancamentos(id),

    -- Auditoria
    revisado_por UUID,
    revisado_em TIMESTAMP WITH TIME ZONE
);

-- 3. Tabela de padrões aprendidos (para melhorar IA com o tempo)
CREATE TABLE IF NOT EXISTS financeiro_padroes_aprendidos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Padrão de texto (pode ser regex ou texto parcial)
    padrao_texto TEXT NOT NULL,
    tipo_match TEXT DEFAULT 'contains' CHECK (tipo_match IN ('contains', 'starts_with', 'regex', 'exact')),

    -- O que esse padrão significa
    categoria_id UUID REFERENCES financeiro_categorias(id),
    projeto_id UUID REFERENCES projetos(id),
    contrato_id UUID REFERENCES contratos(id),
    pessoa_id UUID REFERENCES pessoas(id),

    -- Quantas vezes foi usado
    vezes_usado INTEGER DEFAULT 0,

    -- Se está ativo
    ativo BOOLEAN DEFAULT true,

    -- Auditoria
    criado_por UUID,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Índices para performance
CREATE INDEX IF NOT EXISTS idx_importacao_itens_importacao ON financeiro_importacao_itens(importacao_id);
CREATE INDEX IF NOT EXISTS idx_importacao_itens_status ON financeiro_importacao_itens(status);
CREATE INDEX IF NOT EXISTS idx_padroes_texto ON financeiro_padroes_aprendidos(padrao_texto);

-- 5. Função para detectar duplicatas
CREATE OR REPLACE FUNCTION verificar_duplicata_lancamento(
    p_data DATE,
    p_valor NUMERIC,
    p_descricao TEXT
) RETURNS UUID AS $$
DECLARE
    v_lancamento_id UUID;
BEGIN
    -- Busca lançamento com mesma data, valor e descrição similar
    SELECT id INTO v_lancamento_id
    FROM financeiro_lancamentos
    WHERE data_competencia = p_data
      AND ABS(valor - p_valor) < 0.01
      AND (
          descricao ILIKE '%' || p_descricao || '%'
          OR p_descricao ILIKE '%' || descricao || '%'
          OR similarity(descricao, p_descricao) > 0.6
      )
    LIMIT 1;

    RETURN v_lancamento_id;
EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 6. Habilitar extensão de similaridade de texto (se não existir)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 7. View para listar importações com estatísticas
CREATE OR REPLACE VIEW vw_importacoes_extrato AS
SELECT
    i.*,
    cb.nome as conta_bancaria_nome,
    cb.banco as banco_nome,
    p.nome as criado_por_nome
FROM financeiro_importacoes i
LEFT JOIN financeiro_contas_bancarias cb ON cb.id = i.conta_bancaria_id
LEFT JOIN pessoas p ON p.id = i.criado_por
ORDER BY i.criado_em DESC;

-- 8. RLS
ALTER TABLE financeiro_importacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_importacao_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_padroes_aprendidos ENABLE ROW LEVEL SECURITY;

-- Políticas permissivas (ajustar conforme necessidade)
CREATE POLICY "Importacoes visíveis para autenticados" ON financeiro_importacoes
    FOR ALL USING (true);

CREATE POLICY "Itens importação visíveis para autenticados" ON financeiro_importacao_itens
    FOR ALL USING (true);

CREATE POLICY "Padrões visíveis para autenticados" ON financeiro_padroes_aprendidos
    FOR ALL USING (true);

-- 9. Verificar criação
SELECT 'Tabelas criadas com sucesso!' as resultado;
