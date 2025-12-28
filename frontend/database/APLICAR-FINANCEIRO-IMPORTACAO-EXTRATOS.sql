-- ============================================================================
-- SQL UNIFICADO: SISTEMA FINANCEIRO - IMPORTAÇÃO DE EXTRATOS
-- ============================================================================
-- Versão corrigida - verifica se tabelas já existem antes de criar
-- ============================================================================

-- ============================================================================
-- PARTE 1: VERIFICAR SE financeiro_categorias É TABELA OU VIEW
-- Se for tabela, mantemos ela. Se não existir, criamos view.
-- ============================================================================

DO $$
BEGIN
  -- Verificar se financeiro_categorias existe como tabela
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'financeiro_categorias'
    AND table_type = 'BASE TABLE'
  ) THEN
    -- Se não existe como tabela, dropar view se existir e criar nova
    DROP VIEW IF EXISTS financeiro_categorias CASCADE;

    EXECUTE '
      CREATE VIEW financeiro_categorias AS
      SELECT
        id,
        name as nome,
        CASE kind
          WHEN ''income'' THEN ''receita''
          WHEN ''expense'' THEN ''despesa''
          ELSE kind
        END as tipo,
        parent_id,
        COALESCE(codigo, '''') as codigo,
        COALESCE(grupo, '''') as grupo,
        COALESCE(cor, '''') as cor,
        COALESCE(icone, '''') as icone,
        ordem,
        ativo,
        created_at,
        updated_at
      FROM fin_categories
    ';

    RAISE NOTICE 'View financeiro_categorias criada';
  ELSE
    RAISE NOTICE 'Tabela financeiro_categorias já existe - mantida';
  END IF;
END $$;

-- ============================================================================
-- PARTE 2: EXPANDIR TABELA fin_categories (adicionar campos se não existirem)
-- ============================================================================

ALTER TABLE fin_categories ADD COLUMN IF NOT EXISTS codigo VARCHAR(30);
ALTER TABLE fin_categories ADD COLUMN IF NOT EXISTS grupo VARCHAR(50);
ALTER TABLE fin_categories ADD COLUMN IF NOT EXISTS cor VARCHAR(7);
ALTER TABLE fin_categories ADD COLUMN IF NOT EXISTS icone VARCHAR(50);

CREATE INDEX IF NOT EXISTS idx_fin_categories_codigo ON fin_categories(codigo);
CREATE INDEX IF NOT EXISTS idx_fin_categories_grupo ON fin_categories(grupo);

-- ============================================================================
-- PARTE 3: TABELA financeiro_importacoes (histórico de importações)
-- ============================================================================

CREATE TABLE IF NOT EXISTS financeiro_importacoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome_arquivo TEXT NOT NULL,
    tipo_arquivo TEXT NOT NULL,
    tamanho_bytes INTEGER,
    conta_bancaria TEXT,
    nucleo VARCHAR(50),
    status TEXT DEFAULT 'pendente' CHECK (status IN ('pendente', 'processando', 'revisao', 'concluido', 'erro')),
    total_linhas INTEGER DEFAULT 0,
    linhas_importadas INTEGER DEFAULT 0,
    linhas_duplicadas INTEGER DEFAULT 0,
    linhas_erro INTEGER DEFAULT 0,
    linhas_a_definir INTEGER DEFAULT 0,
    data_inicio DATE,
    data_fim DATE,
    criado_por UUID,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processado_em TIMESTAMP WITH TIME ZONE,
    erro_mensagem TEXT
);

-- ============================================================================
-- PARTE 4: TABELA financeiro_importacao_itens
-- ============================================================================

CREATE TABLE IF NOT EXISTS financeiro_importacao_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    importacao_id UUID REFERENCES financeiro_importacoes(id) ON DELETE CASCADE,
    data_transacao DATE NOT NULL,
    descricao_original TEXT NOT NULL,
    valor NUMERIC(15,2) NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('entrada', 'saida')),
    descricao_formatada TEXT,
    categoria_sugerida TEXT,
    categoria_id UUID,
    projeto_sugerido TEXT,
    projeto_id UUID,
    contrato_sugerido TEXT,
    contrato_id UUID,
    pessoa_sugerida TEXT,
    pessoa_id UUID,
    confianca INTEGER DEFAULT 0,
    status TEXT DEFAULT 'pendente' CHECK (status IN ('pendente', 'aprovado', 'rejeitado', 'duplicado', 'a_definir')),
    duplicata_de UUID,
    observacoes TEXT,
    lancamento_id UUID,
    revisado_por UUID,
    revisado_em TIMESTAMP WITH TIME ZONE
);

-- ============================================================================
-- PARTE 5: TABELA financeiro_padroes_aprendidos
-- ============================================================================

CREATE TABLE IF NOT EXISTS financeiro_padroes_aprendidos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    padrao_texto TEXT NOT NULL,
    tipo_match TEXT DEFAULT 'contains' CHECK (tipo_match IN ('contains', 'starts_with', 'regex', 'exact')),
    categoria_id UUID,
    projeto_id UUID,
    contrato_id UUID,
    pessoa_id UUID,
    categoria_nome TEXT,
    projeto_nome TEXT,
    vezes_usado INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    criado_por UUID,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar unique constraint se não existir
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'financeiro_padroes_aprendidos_padrao_texto_key'
  ) THEN
    ALTER TABLE financeiro_padroes_aprendidos ADD CONSTRAINT financeiro_padroes_aprendidos_padrao_texto_key UNIQUE (padrao_texto);
  END IF;
EXCEPTION WHEN duplicate_object THEN
  NULL;
END $$;

-- ============================================================================
-- PARTE 6: EXPANDIR TABELA pessoas
-- ============================================================================

ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS cpf_parcial VARCHAR(20);
ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS nome_normalizado VARCHAR(255);
ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS apelido VARCHAR(100);

-- Adicionar FK apenas se fin_categories existir e coluna não tiver FK
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'pessoas' AND column_name = 'categoria_padrao_id'
  ) THEN
    ALTER TABLE pessoas ADD COLUMN categoria_padrao_id UUID;
  END IF;
END $$;

ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS centro_custo_padrao VARCHAR(200);

CREATE INDEX IF NOT EXISTS idx_pessoas_cpf_parcial ON pessoas(cpf_parcial);
CREATE INDEX IF NOT EXISTS idx_pessoas_nome_normalizado ON pessoas(nome_normalizado);
CREATE INDEX IF NOT EXISTS idx_pessoas_apelido ON pessoas(apelido);

-- ============================================================================
-- PARTE 7: EXPANDIR TABELA nucleos
-- ============================================================================

ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS razao_social VARCHAR(200);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS cnpj VARCHAR(18);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS banco VARCHAR(100);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS banco_codigo VARCHAR(5);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS agencia VARCHAR(10);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS conta VARCHAR(20);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS pix_chave VARCHAR(100);
ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS pix_tipo VARCHAR(20);

-- ============================================================================
-- PARTE 8: EXPANDIR TABELA financeiro_lancamentos
-- ============================================================================

ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS natureza VARCHAR(30);
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS favorecido_nome VARCHAR(200);
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS favorecido_documento VARCHAR(20);
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS descricao_extrato TEXT;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS mensagem_pix TEXT;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS extrato_id UUID;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS conciliado BOOLEAN DEFAULT false;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS conciliado_em TIMESTAMPTZ;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS classificado_auto BOOLEAN DEFAULT false;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS requer_revisao BOOLEAN DEFAULT false;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS confianca_classificacao INT DEFAULT 0;
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS origem VARCHAR(50) DEFAULT 'manual';
ALTER TABLE financeiro_lancamentos ADD COLUMN IF NOT EXISTS data_pagamento DATE;

CREATE INDEX IF NOT EXISTS idx_fin_lanc_extrato ON financeiro_lancamentos(extrato_id);
CREATE INDEX IF NOT EXISTS idx_fin_lanc_conciliado ON financeiro_lancamentos(conciliado);
CREATE INDEX IF NOT EXISTS idx_fin_lanc_revisao ON financeiro_lancamentos(requer_revisao);
CREATE INDEX IF NOT EXISTS idx_fin_lanc_origem ON financeiro_lancamentos(origem);

-- ============================================================================
-- PARTE 9: ÍNDICES PARA TABELAS DE IMPORTAÇÃO
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_importacao_itens_importacao ON financeiro_importacao_itens(importacao_id);
CREATE INDEX IF NOT EXISTS idx_importacao_itens_status ON financeiro_importacao_itens(status);
CREATE INDEX IF NOT EXISTS idx_padroes_texto ON financeiro_padroes_aprendidos(padrao_texto);
CREATE INDEX IF NOT EXISTS idx_importacoes_status ON financeiro_importacoes(status);

-- ============================================================================
-- PARTE 10: EXTENSÃO DE SIMILARIDADE DE TEXTO
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ============================================================================
-- PARTE 11: RLS PARA NOVAS TABELAS
-- ============================================================================

ALTER TABLE financeiro_importacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_importacao_itens ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro_padroes_aprendidos ENABLE ROW LEVEL SECURITY;

-- Políticas permissivas
DROP POLICY IF EXISTS "Importacoes visíveis para autenticados" ON financeiro_importacoes;
CREATE POLICY "Importacoes visíveis para autenticados" ON financeiro_importacoes
    FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Itens importação visíveis para autenticados" ON financeiro_importacao_itens;
CREATE POLICY "Itens importação visíveis para autenticados" ON financeiro_importacao_itens
    FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Padrões visíveis para autenticados" ON financeiro_padroes_aprendidos;
CREATE POLICY "Padrões visíveis para autenticados" ON financeiro_padroes_aprendidos
    FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ============================================================================
-- PARTE 12: FUNÇÃO PARA NORMALIZAR NOMES
-- ============================================================================

CREATE OR REPLACE FUNCTION normalizar_nome(p_nome TEXT)
RETURNS TEXT AS $$
BEGIN
  IF p_nome IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN UPPER(
    TRANSLATE(
      TRIM(p_nome),
      'áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ',
      'AAAAAEEEEIIIIOOOOOUUUUCNAAAAAEEEEIIIIOOOOOUUUUCN'
    )
  );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================================================
-- PARTE 13: FUNÇÃO PARA GERAR CPF PARCIAL
-- ============================================================================

CREATE OR REPLACE FUNCTION gerar_cpf_parcial(p_cpf TEXT)
RETURNS TEXT AS $$
DECLARE
  v_cpf_limpo TEXT;
BEGIN
  IF p_cpf IS NULL THEN
    RETURN NULL;
  END IF;
  v_cpf_limpo := REGEXP_REPLACE(p_cpf, '[^0-9]', '', 'g');
  IF p_cpf LIKE '%*%' THEN
    RETURN UPPER(REGEXP_REPLACE(p_cpf, '[^0-9*-]', '', 'g'));
  END IF;
  IF LENGTH(v_cpf_limpo) = 11 THEN
    RETURN '***.' || SUBSTRING(v_cpf_limpo, 4, 3) || '.' || SUBSTRING(v_cpf_limpo, 7, 3) || '-**';
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================================================
-- PARTE 14: TRIGGER PARA ATUALIZAR CAMPOS NORMALIZADOS
-- ============================================================================

CREATE OR REPLACE FUNCTION atualizar_campos_normalizados()
RETURNS TRIGGER AS $$
BEGIN
  NEW.nome_normalizado := normalizar_nome(NEW.nome);
  IF NEW.cpf IS NOT NULL AND NEW.cpf != '' THEN
    NEW.cpf_parcial := gerar_cpf_parcial(NEW.cpf);
  END IF;
  NEW.atualizado_em := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_pessoas_normalizar ON pessoas;
CREATE TRIGGER trg_pessoas_normalizar
  BEFORE INSERT OR UPDATE ON pessoas
  FOR EACH ROW
  EXECUTE FUNCTION atualizar_campos_normalizados();

-- ============================================================================
-- PARTE 15: FUNÇÃO PARA BUSCAR FAVORECIDO
-- ============================================================================

CREATE OR REPLACE FUNCTION buscar_favorecido(
  p_nome TEXT,
  p_cpf_parcial TEXT DEFAULT NULL,
  p_cnpj TEXT DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  tipo VARCHAR,
  nome VARCHAR,
  categoria_padrao_id UUID,
  centro_custo_padrao VARCHAR,
  score INT
) AS $$
DECLARE
  v_nome_norm TEXT;
BEGIN
  v_nome_norm := normalizar_nome(p_nome);
  RETURN QUERY
  SELECT
    p.id,
    p.tipo,
    p.nome,
    p.categoria_padrao_id,
    p.centro_custo_padrao,
    CASE
      WHEN p_cpf_parcial IS NOT NULL AND p.cpf_parcial = p_cpf_parcial THEN 100
      WHEN p_cnpj IS NOT NULL AND REPLACE(REPLACE(REPLACE(p.cnpj, '.', ''), '-', ''), '/', '') =
           REPLACE(REPLACE(REPLACE(p_cnpj, '.', ''), '-', ''), '/', '') THEN 100
      WHEN p.nome_normalizado = v_nome_norm THEN 90
      WHEN p.nome_normalizado LIKE '%' || v_nome_norm || '%' THEN 70
      WHEN v_nome_norm LIKE '%' || p.nome_normalizado || '%' THEN 70
      WHEN p.apelido IS NOT NULL AND normalizar_nome(p.apelido) = v_nome_norm THEN 60
      ELSE 0
    END as score
  FROM pessoas p
  WHERE p.ativo = true
  AND (
    (p_cpf_parcial IS NOT NULL AND p.cpf_parcial = p_cpf_parcial)
    OR (p_cnpj IS NOT NULL AND p.cnpj IS NOT NULL AND LENGTH(p.cnpj) > 0)
    OR (v_nome_norm IS NOT NULL AND LENGTH(v_nome_norm) > 2 AND (
      p.nome_normalizado LIKE '%' || v_nome_norm || '%'
      OR v_nome_norm LIKE '%' || p.nome_normalizado || '%'
    ))
    OR (p.apelido IS NOT NULL AND normalizar_nome(p.apelido) LIKE '%' || v_nome_norm || '%')
  )
  ORDER BY score DESC
  LIMIT 5;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- PARTE 16: VIEW DE CENTROS DE CUSTO
-- ============================================================================

DROP VIEW IF EXISTS vw_centros_custo CASCADE;

CREATE OR REPLACE VIEW vw_centros_custo AS
SELECT
  p.id,
  p.nome as nome_cliente,
  p.nome_normalizado,
  COALESCE(
    NULLIF(CONCAT_WS(', ', p.obra_logradouro, p.obra_numero, p.obra_bairro), ''),
    NULLIF(CONCAT_WS(', ', p.logradouro, p.numero, p.bairro), '')
  ) as endereco_obra,
  COALESCE(p.obra_cidade, p.cidade) as cidade,
  pr.id as projeto_id,
  pr.nome as projeto_nome,
  c.id as contrato_id,
  c.numero as contrato_numero,
  p.ativo
FROM pessoas p
LEFT JOIN contratos c ON c.cliente_id = p.id
LEFT JOIN projetos pr ON pr.cliente_id = p.id
WHERE p.tipo = 'CLIENTE';

-- ============================================================================
-- PARTE 17: ATUALIZAR DADOS EXISTENTES
-- ============================================================================

UPDATE pessoas
SET
  nome_normalizado = normalizar_nome(nome),
  cpf_parcial = gerar_cpf_parcial(cpf)
WHERE nome_normalizado IS NULL
   OR (cpf IS NOT NULL AND cpf != '' AND cpf_parcial IS NULL);

-- ============================================================================
-- PARTE 18: INSERIR CATEGORIAS PADRÃO
-- ============================================================================

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'REC-PROJ', 'Receita de Projeto', 'income', 'PROJETOS', '#22C55E'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'REC-PROJ');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'REC-OBRA', 'Receita de Obra', 'income', 'OBRAS', '#10B981'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'REC-OBRA');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'REC-MARC', 'Receita Marcenaria', 'income', 'MARCENARIA', '#059669'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'REC-MARC');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'REC-OUTROS', 'Outras Receitas', 'income', 'OUTROS', '#84CC16'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'REC-OUTROS');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'DESP-MO-COLAB', 'Pagamento Colaborador', 'expense', 'MAO_DE_OBRA', '#EF4444'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'DESP-MO-COLAB');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'DESP-MO-FORN', 'Pagamento Fornecedor', 'expense', 'MAO_DE_OBRA', '#F87171'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'DESP-MO-FORN');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'DESP-MAT', 'Material', 'expense', 'MATERIAIS', '#F97316'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'DESP-MAT');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'DESP-OPER', 'Operacional', 'expense', 'OPERACIONAL', '#F59E0B'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'DESP-OPER');

INSERT INTO fin_categories (codigo, name, kind, grupo, cor)
SELECT 'DESP-OUTROS', 'Outras Despesas', 'expense', 'OUTROS', '#6B7280'
WHERE NOT EXISTS (SELECT 1 FROM fin_categories WHERE codigo = 'DESP-OUTROS');

-- ============================================================================
-- VERIFICAÇÃO FINAL
-- ============================================================================

SELECT 'Modulo financeiro importacao configurado com sucesso!' as resultado;
