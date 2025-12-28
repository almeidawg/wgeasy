-- ============================================================
-- CRIAR FOREIGN KEYS PARA REEMBOLSOS E COBRANCAS
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================

-- ============================================================
-- PARTE 1: FKs PARA TABELA REEMBOLSOS
-- ============================================================

-- 1.1 FK reembolsos.obra_id -> obras
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_obra'
    ) THEN
        -- Limpar registros com obra_id inválidos
        UPDATE reembolsos
        SET obra_id = NULL
        WHERE obra_id IS NOT NULL
          AND obra_id NOT IN (SELECT id FROM obras);

        -- Adicionar FK
        ALTER TABLE reembolsos
        ADD CONSTRAINT fk_reembolsos_obra
        FOREIGN KEY (obra_id)
        REFERENCES obras(id)
        ON DELETE SET NULL;

        RAISE NOTICE '✅ FK reembolsos.obra_id -> obras criada!';
    ELSE
        RAISE NOTICE '⚠️ FK fk_reembolsos_obra já existe';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK obra_id: %', SQLERRM;
END $$;

-- 1.2 FK reembolsos.categoria_id -> fin_categories
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_categoria'
    ) THEN
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
        RAISE NOTICE '⚠️ FK fk_reembolsos_categoria já existe';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK categoria_id: %', SQLERRM;
END $$;

-- 1.3 FK reembolsos.contrato_id -> contratos
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_reembolsos_contrato'
    ) THEN
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
        RAISE NOTICE '⚠️ FK fk_reembolsos_contrato já existe';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK contrato_id: %', SQLERRM;
END $$;

-- ============================================================
-- PARTE 2: FKs PARA TABELA COBRANCAS
-- ============================================================

-- 2.1 FK cobrancas.obra_id -> obras
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_cobrancas_obra'
    ) THEN
        UPDATE cobrancas
        SET obra_id = NULL
        WHERE obra_id IS NOT NULL
          AND obra_id NOT IN (SELECT id FROM obras);

        ALTER TABLE cobrancas
        ADD CONSTRAINT fk_cobrancas_obra
        FOREIGN KEY (obra_id)
        REFERENCES obras(id)
        ON DELETE SET NULL;

        RAISE NOTICE '✅ FK cobrancas.obra_id -> obras criada!';
    ELSE
        RAISE NOTICE '⚠️ FK fk_cobrancas_obra já existe';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK cobrancas.obra_id: %', SQLERRM;
END $$;

-- 2.2 FK cobrancas.contrato_id -> contratos
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_cobrancas_contrato'
    ) THEN
        UPDATE cobrancas
        SET contrato_id = NULL
        WHERE contrato_id IS NOT NULL
          AND contrato_id NOT IN (SELECT id FROM contratos);

        ALTER TABLE cobrancas
        ADD CONSTRAINT fk_cobrancas_contrato
        FOREIGN KEY (contrato_id)
        REFERENCES contratos(id)
        ON DELETE SET NULL;

        RAISE NOTICE '✅ FK cobrancas.contrato_id -> contratos criada!';
    ELSE
        RAISE NOTICE '⚠️ FK fk_cobrancas_contrato já existe';
    END IF;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '⚠️ Erro ao criar FK cobrancas.contrato_id: %', SQLERRM;
END $$;

-- ============================================================
-- PARTE 3: ÍNDICES PARA PERFORMANCE
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_reembolsos_obra ON reembolsos(obra_id) WHERE obra_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reembolsos_categoria ON reembolsos(categoria_id) WHERE categoria_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reembolsos_contrato ON reembolsos(contrato_id) WHERE contrato_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_reembolsos_data ON reembolsos(data);
CREATE INDEX IF NOT EXISTS idx_reembolsos_status ON reembolsos(status);

CREATE INDEX IF NOT EXISTS idx_cobrancas_obra ON cobrancas(obra_id) WHERE obra_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_cobrancas_contrato ON cobrancas(contrato_id) WHERE contrato_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_cobrancas_vencimento ON cobrancas(vencimento);
CREATE INDEX IF NOT EXISTS idx_cobrancas_status ON cobrancas(status);

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
DECLARE
    v_fk_reembolsos INT;
    v_fk_cobrancas INT;
BEGIN
    SELECT COUNT(*) INTO v_fk_reembolsos
    FROM pg_constraint
    WHERE conname LIKE 'fk_reembolsos_%';

    SELECT COUNT(*) INTO v_fk_cobrancas
    FROM pg_constraint
    WHERE conname LIKE 'fk_cobrancas_%';

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CORREÇÃO DE FKs CONCLUÍDA!';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'FKs em reembolsos: %', v_fk_reembolsos;
    RAISE NOTICE 'FKs em cobrancas: %', v_fk_cobrancas;
    RAISE NOTICE '============================================================';
END $$;

-- Testar query de reembolsos
SELECT
    r.id,
    r.valor,
    r.data,
    r.status,
    o.nome as obra_nome,
    c.numero as contrato_numero,
    cat.name as categoria_nome
FROM reembolsos r
LEFT JOIN obras o ON o.id = r.obra_id
LEFT JOIN contratos c ON c.id = r.contrato_id
LEFT JOIN fin_categories cat ON cat.id = r.categoria_id
LIMIT 5;

-- Testar query de cobrancas
SELECT
    cob.id,
    cob.cliente,
    cob.valor,
    cob.vencimento,
    cob.status,
    o.nome as obra_nome,
    c.numero as contrato_numero
FROM cobrancas cob
LEFT JOIN obras o ON o.id = cob.obra_id
LEFT JOIN contratos c ON c.id = cob.contrato_id
LIMIT 5;
