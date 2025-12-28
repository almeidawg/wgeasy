-- ========================================
-- MÓDULO DE IMPORTAÇÃO INTELIGENTE DE EXTRATOS (V2)
-- Versão simplificada sem dependências problemáticas
-- ========================================

-- 1. Tabela de importações (histórico)
CREATE TABLE IF NOT EXISTS financeiro_importacoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Arquivo original
    nome_arquivo TEXT NOT NULL,
    tipo_arquivo TEXT NOT NULL, -- pdf, xlsx, csv, ofx
    tamanho_bytes INTEGER,

    -- Conta bancária (texto simples por agora)
    conta_bancaria TEXT,

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
    categoria_id UUID,
    projeto_sugerido TEXT,
    projeto_id UUID,
    contrato_sugerido TEXT,
    contrato_id UUID,
    pessoa_sugerida TEXT,
    pessoa_id UUID,

    -- Confiança da IA (0-100)
    confianca INTEGER DEFAULT 0,

    -- Status do item
    status TEXT DEFAULT 'pendente' CHECK (status IN ('pendente', 'aprovado', 'rejeitado', 'duplicado', 'a_definir')),

    -- Se foi encontrado como duplicata
    duplicata_de UUID,

    -- Observações do usuário
    observacoes TEXT,

    -- Se já foi importado para lançamentos
    lancamento_id UUID,

    -- Auditoria
    revisado_por UUID,
    revisado_em TIMESTAMP WITH TIME ZONE
);

-- 3. Tabela de padrões aprendidos (para melhorar IA com o tempo)
CREATE TABLE IF NOT EXISTS financeiro_padroes_aprendidos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Padrão de texto (pode ser regex ou texto parcial)
    padrao_texto TEXT NOT NULL UNIQUE,
    tipo_match TEXT DEFAULT 'contains' CHECK (tipo_match IN ('contains', 'starts_with', 'regex', 'exact')),

    -- O que esse padrão significa
    categoria_id UUID,
    projeto_id UUID,
    contrato_id UUID,
    pessoa_id UUID,
    categoria_nome TEXT,
    projeto_nome TEXT,

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
CREATE INDEX IF NOT EXISTS idx_importacoes_status ON financeiro_importacoes(status);

-- 5. Habilitar extensão de similaridade de texto (se não existir)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 6. RLS
ALTER TABLE financeiro_importacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_importacao_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_padroes_aprendidos ENABLE ROW LEVEL SECURITY;

-- Políticas permissivas
DROP POLICY IF EXISTS "Importacoes visíveis para autenticados" ON financeiro_importacoes;
CREATE POLICY "Importacoes visíveis para autenticados" ON financeiro_importacoes
    FOR ALL USING (true);

DROP POLICY IF EXISTS "Itens importação visíveis para autenticados" ON financeiro_importacao_itens;
CREATE POLICY "Itens importação visíveis para autenticados" ON financeiro_importacao_itens
    FOR ALL USING (true);

DROP POLICY IF EXISTS "Padrões visíveis para autenticados" ON financeiro_padroes_aprendidos;
CREATE POLICY "Padrões visíveis para autenticados" ON financeiro_padroes_aprendidos
    FOR ALL USING (true);

-- 7. Adicionar coluna data_pagamento se não existir
ALTER TABLE financeiro_lancamentos
ADD COLUMN IF NOT EXISTS data_pagamento DATE;

-- 8. Verificar criação
SELECT 'Módulo de importação criado com sucesso!' as resultado;
