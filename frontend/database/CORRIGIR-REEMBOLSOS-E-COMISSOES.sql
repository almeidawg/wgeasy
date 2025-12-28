-- ============================================================
-- CORRIGIR FOREIGN KEYS REEMBOLSOS E CRIAR VIEW COMISSÕES
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================

-- ============================================================
-- PARTE 1: CORRIGIR FOREIGN KEYS NA TABELA REEMBOLSOS
-- ============================================================

-- O erro 400 ocorre porque o Supabase/PostgREST não encontra as FKs
-- para fazer os joins automáticos nas queries

-- 1.1 Verificar e adicionar FK para favorecido_id -> pessoas
DO $$
BEGIN
    -- Remover FK existente se houver
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_favorecido') THEN
        ALTER TABLE reembolsos DROP CONSTRAINT fk_reembolsos_favorecido;
    END IF;

    -- Limpar registros com favorecido_id inválidos
    UPDATE reembolsos
    SET favorecido_id = NULL
    WHERE favorecido_id IS NOT NULL
      AND favorecido_id NOT IN (SELECT id FROM pessoas);

    -- Adicionar FK
    ALTER TABLE reembolsos
    ADD CONSTRAINT fk_reembolsos_favorecido
    FOREIGN KEY (favorecido_id)
    REFERENCES pessoas(id)
    ON DELETE SET NULL;

    RAISE NOTICE '✅ FK reembolsos.favorecido_id -> pessoas criada!';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK favorecido_id: %', SQLERRM;
END $$;

-- 1.2 Verificar e adicionar FK para centro_custo_id -> contratos
DO $$
BEGIN
    -- Remover FK existente se houver
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_centro_custo') THEN
        ALTER TABLE reembolsos DROP CONSTRAINT fk_reembolsos_centro_custo;
    END IF;

    -- Limpar registros com centro_custo_id inválidos
    UPDATE reembolsos
    SET centro_custo_id = NULL
    WHERE centro_custo_id IS NOT NULL
      AND centro_custo_id NOT IN (SELECT id FROM contratos);

    -- Adicionar FK
    ALTER TABLE reembolsos
    ADD CONSTRAINT fk_reembolsos_centro_custo
    FOREIGN KEY (centro_custo_id)
    REFERENCES contratos(id)
    ON DELETE SET NULL;

    RAISE NOTICE '✅ FK reembolsos.centro_custo_id -> contratos criada!';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK centro_custo_id: %', SQLERRM;
END $$;

-- 1.3 Verificar e adicionar FK para obra_id -> obras
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_obra') THEN
        ALTER TABLE reembolsos DROP CONSTRAINT fk_reembolsos_obra;
    END IF;

    UPDATE reembolsos
    SET obra_id = NULL
    WHERE obra_id IS NOT NULL
      AND obra_id NOT IN (SELECT id FROM obras);

    ALTER TABLE reembolsos
    ADD CONSTRAINT fk_reembolsos_obra
    FOREIGN KEY (obra_id)
    REFERENCES obras(id)
    ON DELETE SET NULL;

    RAISE NOTICE '✅ FK reembolsos.obra_id -> obras criada!';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK obra_id: %', SQLERRM;
END $$;

-- 1.4 Verificar e adicionar FK para categoria_id -> fin_categories
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_categoria') THEN
        ALTER TABLE reembolsos DROP CONSTRAINT fk_reembolsos_categoria;
    END IF;

    UPDATE reembolsos
    SET categoria_id = NULL
    WHERE categoria_id IS NOT NULL
      AND categoria_id NOT IN (SELECT id FROM fin_categories);

    ALTER TABLE reembolsos
    ADD CONSTRAINT fk_reembolsos_categoria
    FOREIGN KEY (categoria_id)
    REFERENCES fin_categories(id)
    ON DELETE SET NULL;

    RAISE NOTICE '✅ FK reembolsos.categoria_id -> fin_categories criada!';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK categoria_id: %', SQLERRM;
END $$;

-- 1.5 Criar índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_reembolsos_favorecido ON reembolsos(favorecido_id) WHERE favorecido_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reembolsos_centro_custo ON reembolsos(centro_custo_id) WHERE centro_custo_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reembolsos_obra ON reembolsos(obra_id) WHERE obra_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reembolsos_categoria ON reembolsos(categoria_id) WHERE categoria_id IS NOT NULL;

-- ============================================================
-- PARTE 2: CRIAR TABELAS DO MÓDULO DE COMISSÕES (se não existirem)
-- ============================================================

-- 2.1 Tabela de Categorias de Comissão
CREATE TABLE IF NOT EXISTS categorias_comissao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    tipo_pessoa VARCHAR(50) DEFAULT 'especificador',
    is_master BOOLEAN DEFAULT FALSE,
    is_indicacao BOOLEAN DEFAULT FALSE,
    ordem INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.2 Tabela de Faixas de VGV
CREATE TABLE IF NOT EXISTS faixas_vgv (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cota INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    valor_minimo DECIMAL(15,2) DEFAULT 0,
    valor_maximo DECIMAL(15,2),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2.3 Tabela de Percentuais de Comissão
CREATE TABLE IF NOT EXISTS percentuais_comissao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria_id UUID NOT NULL REFERENCES categorias_comissao(id) ON DELETE CASCADE,
    faixa_id UUID NOT NULL REFERENCES faixas_vgv(id) ON DELETE CASCADE,
    percentual DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(categoria_id, faixa_id)
);

-- 2.4 Inserir dados padrão nas categorias (se vazias)
INSERT INTO categorias_comissao (codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem)
SELECT * FROM (VALUES
    ('ESP', 'Especificador', 'especificador', false, false, 1),
    ('ARQ', 'Arquiteto', 'arquiteto', false, false, 2),
    ('ENG', 'Engenheiro', 'engenheiro', false, false, 3),
    ('MAS', 'Master', 'master', true, false, 4),
    ('IND', 'Indicação', 'indicacao', false, true, 5)
) AS v(codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem)
WHERE NOT EXISTS (SELECT 1 FROM categorias_comissao LIMIT 1);

-- 2.5 Inserir faixas padrão (se vazias)
INSERT INTO faixas_vgv (cota, nome, valor_minimo, valor_maximo)
SELECT * FROM (VALUES
    (1, 'Até R$ 100.000', 0, 100000),
    (2, 'R$ 100.001 a R$ 200.000', 100001, 200000),
    (3, 'R$ 200.001 a R$ 300.000', 200001, 300000),
    (4, 'R$ 300.001 a R$ 500.000', 300001, 500000),
    (5, 'Acima de R$ 500.000', 500001, NULL)
) AS v(cota, nome, valor_minimo, valor_maximo)
WHERE NOT EXISTS (SELECT 1 FROM faixas_vgv LIMIT 1);

-- ============================================================
-- PARTE 3: CRIAR VIEW vw_tabela_comissoes
-- ============================================================

CREATE OR REPLACE VIEW vw_tabela_comissoes AS
SELECT
    c.id AS categoria_id,
    c.codigo,
    c.nome AS categoria_nome,
    c.tipo_pessoa,
    c.is_master,
    c.is_indicacao,
    c.ordem,
    f.id AS faixa_id,
    f.cota,
    f.nome AS faixa_nome,
    f.valor_minimo,
    f.valor_maximo,
    COALESCE(p.percentual, 0) AS percentual
FROM categorias_comissao c
CROSS JOIN faixas_vgv f
LEFT JOIN percentuais_comissao p ON p.categoria_id = c.id AND p.faixa_id = f.id
WHERE c.ativo = true AND f.ativo = true
ORDER BY c.ordem, c.nome, f.cota;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
DECLARE
    v_fk_count INT;
    v_view_exists BOOLEAN;
BEGIN
    -- Contar FKs criadas
    SELECT COUNT(*) INTO v_fk_count
    FROM pg_constraint
    WHERE conname LIKE 'fk_reembolsos_%';

    -- Verificar se view existe
    SELECT EXISTS (
        SELECT 1 FROM information_schema.views
        WHERE table_name = 'vw_tabela_comissoes'
    ) INTO v_view_exists;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CORREÇÃO CONCLUÍDA!';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'FKs criadas na tabela reembolsos: %', v_fk_count;
    RAISE NOTICE 'View vw_tabela_comissoes existe: %', v_view_exists;
    RAISE NOTICE '============================================================';
END $$;

-- Testar query de reembolsos
SELECT
    r.id,
    r.valor,
    r.data,
    o.nome as obra_nome,
    p.nome as favorecido_nome,
    c.numero as contrato_numero
FROM reembolsos r
LEFT JOIN obras o ON o.id = r.obra_id
LEFT JOIN pessoas p ON p.id = r.favorecido_id
LEFT JOIN contratos c ON c.id = r.centro_custo_id
LIMIT 3;

-- Testar view de comissões
SELECT * FROM vw_tabela_comissoes LIMIT 10;
