-- ============================================================
-- CORRIGIR FOREIGN KEYS REEMBOLSOS E CRIAR VIEW COMISSÕES
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- Versão 2 - Com verificação de colunas existentes
-- ============================================================

-- ============================================================
-- PARTE 1: VERIFICAR ESTRUTURA DA TABELA REEMBOLSOS
-- ============================================================

-- Primeiro, vamos ver quais colunas existem na tabela reembolsos
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'reembolsos'
ORDER BY ordinal_position;

-- ============================================================
-- PARTE 2: CRIAR FKs APENAS PARA COLUNAS QUE EXISTEM
-- ============================================================

-- FK para pessoa_id (se existir)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'reembolsos' AND column_name = 'pessoa_id'
    ) THEN
        -- Remover FK existente se houver
        IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_pessoa') THEN
            ALTER TABLE reembolsos DROP CONSTRAINT fk_reembolsos_pessoa;
        END IF;

        -- Limpar registros inválidos
        UPDATE reembolsos
        SET pessoa_id = NULL
        WHERE pessoa_id IS NOT NULL
          AND pessoa_id NOT IN (SELECT id FROM pessoas);

        -- Adicionar FK
        ALTER TABLE reembolsos
        ADD CONSTRAINT fk_reembolsos_pessoa
        FOREIGN KEY (pessoa_id)
        REFERENCES pessoas(id)
        ON DELETE SET NULL;

        RAISE NOTICE '✅ FK reembolsos.pessoa_id -> pessoas criada!';
    ELSE
        RAISE NOTICE '⚠️ Coluna pessoa_id não existe em reembolsos';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK pessoa_id: %', SQLERRM;
END $$;

-- FK para contrato_id (se existir)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'reembolsos' AND column_name = 'contrato_id'
    ) THEN
        IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_contrato') THEN
            ALTER TABLE reembolsos DROP CONSTRAINT fk_reembolsos_contrato;
        END IF;

        UPDATE reembolsos
        SET contrato_id = NULL
        WHERE contrato_id IS NOT NULL
          AND contrato_id NOT IN (SELECT id FROM contratos);

        ALTER TABLE reembolsos
        ADD CONSTRAINT fk_reembolsos_contrato
        FOREIGN KEY (contrato_id)
        REFERENCES contratos(id)
        ON DELETE SET NULL;

        RAISE NOTICE '✅ FK reembolsos.contrato_id -> contratos criada!';
    ELSE
        RAISE NOTICE '⚠️ Coluna contrato_id não existe em reembolsos';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK contrato_id: %', SQLERRM;
END $$;

-- FK para obra_id (se existir)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'reembolsos' AND column_name = 'obra_id'
    ) THEN
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
    ELSE
        RAISE NOTICE '⚠️ Coluna obra_id não existe em reembolsos';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK obra_id: %', SQLERRM;
END $$;

-- FK para categoria_id (se existir)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'reembolsos' AND column_name = 'categoria_id'
    ) THEN
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
    ELSE
        RAISE NOTICE '⚠️ Coluna categoria_id não existe em reembolsos';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK categoria_id: %', SQLERRM;
END $$;

-- ============================================================
-- PARTE 3: CRIAR TABELAS DO MÓDULO DE COMISSÕES (se não existirem)
-- ============================================================

-- 3.1 Tabela de Categorias de Comissão
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

-- 3.2 Tabela de Faixas de VGV
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

-- 3.3 Tabela de Percentuais de Comissão
CREATE TABLE IF NOT EXISTS percentuais_comissao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria_id UUID NOT NULL REFERENCES categorias_comissao(id) ON DELETE CASCADE,
    faixa_id UUID NOT NULL REFERENCES faixas_vgv(id) ON DELETE CASCADE,
    percentual DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(categoria_id, faixa_id)
);

-- 3.4 Inserir dados padrão nas categorias (se vazias)
INSERT INTO categorias_comissao (codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem)
SELECT * FROM (VALUES
    ('ESP', 'Especificador', 'especificador', false, false, 1),
    ('ARQ', 'Arquiteto', 'arquiteto', false, false, 2),
    ('ENG', 'Engenheiro', 'engenheiro', false, false, 3),
    ('MAS', 'Master', 'master', true, false, 4),
    ('IND', 'Indicação', 'indicacao', false, true, 5)
) AS v(codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem)
WHERE NOT EXISTS (SELECT 1 FROM categorias_comissao LIMIT 1);

-- 3.5 Inserir faixas padrão (se vazias)
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
-- PARTE 4: CRIAR VIEW vw_tabela_comissoes
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
    v_view_exists BOOLEAN;
    v_cat_count INT;
    v_faixa_count INT;
BEGIN
    -- Verificar se view existe
    SELECT EXISTS (
        SELECT 1 FROM information_schema.views
        WHERE table_name = 'vw_tabela_comissoes'
    ) INTO v_view_exists;

    -- Contar registros
    SELECT COUNT(*) INTO v_cat_count FROM categorias_comissao;
    SELECT COUNT(*) INTO v_faixa_count FROM faixas_vgv;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CORREÇÃO CONCLUÍDA!';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'View vw_tabela_comissoes existe: %', v_view_exists;
    RAISE NOTICE 'Categorias de comissão: %', v_cat_count;
    RAISE NOTICE 'Faixas de VGV: %', v_faixa_count;
    RAISE NOTICE '============================================================';
END $$;

-- Testar view de comissões
SELECT * FROM vw_tabela_comissoes LIMIT 10;
