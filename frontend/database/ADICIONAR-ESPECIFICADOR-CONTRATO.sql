-- ============================================================
-- ADICIONAR CAMPO ESPECIFICADOR NO CONTRATO
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Este campo permite vincular um especificador/parceiro ao contrato
-- para rastreamento de indicações e cálculo de comissões

-- ============================================================
-- PARTE 1: ADICIONAR CAMPOS NA TABELA CONTRATOS
-- ============================================================

-- 1.1 Adicionar campo especificador_id (quem indicou este contrato)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'contratos' AND column_name = 'especificador_id'
    ) THEN
        ALTER TABLE contratos
        ADD COLUMN especificador_id UUID REFERENCES pessoas(id) ON DELETE SET NULL;

        RAISE NOTICE '✅ Campo especificador_id adicionado na tabela contratos!';
    ELSE
        RAISE NOTICE '⚠️ Campo especificador_id já existe';
    END IF;
END $$;

-- 1.2 Adicionar campo para indicar se tem especificador (para filtros rápidos)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'contratos' AND column_name = 'tem_especificador'
    ) THEN
        ALTER TABLE contratos
        ADD COLUMN tem_especificador BOOLEAN DEFAULT FALSE;

        RAISE NOTICE '✅ Campo tem_especificador adicionado!';
    ELSE
        RAISE NOTICE '⚠️ Campo tem_especificador já existe';
    END IF;
END $$;

-- 1.3 Adicionar campo para código de rastreamento (link rastreável)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'contratos' AND column_name = 'codigo_rastreamento'
    ) THEN
        ALTER TABLE contratos
        ADD COLUMN codigo_rastreamento VARCHAR(50);

        RAISE NOTICE '✅ Campo codigo_rastreamento adicionado!';
    ELSE
        RAISE NOTICE '⚠️ Campo codigo_rastreamento já existe';
    END IF;
END $$;

-- 1.4 Adicionar campo para percentual de comissão customizado (se diferente da tabela padrão)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'contratos' AND column_name = 'percentual_comissao'
    ) THEN
        ALTER TABLE contratos
        ADD COLUMN percentual_comissao DECIMAL(5,2);

        RAISE NOTICE '✅ Campo percentual_comissao adicionado!';
    ELSE
        RAISE NOTICE '⚠️ Campo percentual_comissao já existe';
    END IF;
END $$;

-- 1.5 Adicionar campo para observações sobre a indicação
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'contratos' AND column_name = 'observacoes_indicacao'
    ) THEN
        ALTER TABLE contratos
        ADD COLUMN observacoes_indicacao TEXT;

        RAISE NOTICE '✅ Campo observacoes_indicacao adicionado!';
    ELSE
        RAISE NOTICE '⚠️ Campo observacoes_indicacao já existe';
    END IF;
END $$;

-- ============================================================
-- PARTE 2: ÍNDICES PARA PERFORMANCE
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_contratos_especificador ON contratos(especificador_id) WHERE especificador_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_contratos_tem_especificador ON contratos(tem_especificador) WHERE tem_especificador = true;
CREATE INDEX IF NOT EXISTS idx_contratos_codigo_rastreamento ON contratos(codigo_rastreamento) WHERE codigo_rastreamento IS NOT NULL;

-- ============================================================
-- PARTE 3: TRIGGER PARA ATUALIZAR tem_especificador
-- ============================================================

CREATE OR REPLACE FUNCTION fn_atualizar_tem_especificador()
RETURNS TRIGGER AS $$
BEGIN
    NEW.tem_especificador := (NEW.especificador_id IS NOT NULL);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_atualizar_tem_especificador ON contratos;
CREATE TRIGGER trg_atualizar_tem_especificador
    BEFORE INSERT OR UPDATE OF especificador_id ON contratos
    FOR EACH ROW
    EXECUTE FUNCTION fn_atualizar_tem_especificador();

-- ============================================================
-- PARTE 4: VIEW PARA RELATÓRIO DE COMISSÕES
-- ============================================================

CREATE OR REPLACE VIEW vw_contratos_comissoes AS
SELECT
    c.id AS contrato_id,
    c.numero AS contrato_numero,
    c.titulo AS contrato_titulo,
    c.valor_total,
    c.status,
    c.unidade_negocio,
    c.data_inicio,
    c.tem_especificador,
    c.especificador_id,
    c.percentual_comissao,
    c.codigo_rastreamento,
    -- Dados do cliente
    cli.id AS cliente_id,
    cli.nome AS cliente_nome,
    cli.email AS cliente_email,
    -- Dados do especificador
    esp.id AS especificador_pessoa_id,
    esp.nome AS especificador_nome,
    esp.email AS especificador_email,
    esp.telefone AS especificador_telefone,
    esp.pix AS especificador_pix,
    -- Cálculo de comissão (usando percentual customizado ou busca na tabela de comissões)
    CASE
        WHEN c.percentual_comissao IS NOT NULL THEN c.percentual_comissao
        ELSE COALESCE(
            (SELECT pc.percentual
             FROM percentuais_comissao pc
             JOIN categorias_comissao cc ON cc.id = pc.categoria_id
             JOIN faixas_vgv fv ON fv.id = pc.faixa_id
             WHERE cc.codigo = 'ESP'
               AND c.valor_total >= fv.valor_minimo
               AND (fv.valor_maximo IS NULL OR c.valor_total <= fv.valor_maximo)
             LIMIT 1),
            0
        )
    END AS percentual_aplicado,
    -- Valor estimado da comissão
    ROUND(
        c.valor_total *
        CASE
            WHEN c.percentual_comissao IS NOT NULL THEN c.percentual_comissao / 100
            ELSE COALESCE(
                (SELECT pc.percentual / 100
                 FROM percentuais_comissao pc
                 JOIN categorias_comissao cc ON cc.id = pc.categoria_id
                 JOIN faixas_vgv fv ON fv.id = pc.faixa_id
                 WHERE cc.codigo = 'ESP'
                   AND c.valor_total >= fv.valor_minimo
                   AND (fv.valor_maximo IS NULL OR c.valor_total <= fv.valor_maximo)
                 LIMIT 1),
                0
            )
        END,
        2
    ) AS valor_comissao_estimado
FROM contratos c
LEFT JOIN pessoas cli ON cli.id = c.cliente_id
LEFT JOIN pessoas esp ON esp.id = c.especificador_id
WHERE c.tem_especificador = true
ORDER BY c.data_inicio DESC NULLS LAST, c.created_at DESC;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
DECLARE
    v_especificador_exists BOOLEAN;
    v_view_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'contratos' AND column_name = 'especificador_id'
    ) INTO v_especificador_exists;

    SELECT EXISTS (
        SELECT 1 FROM information_schema.views
        WHERE table_name = 'vw_contratos_comissoes'
    ) INTO v_view_exists;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CAMPOS DE ESPECIFICADOR - Configuração Concluída!';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Campo especificador_id existe: %', v_especificador_exists;
    RAISE NOTICE 'View vw_contratos_comissoes existe: %', v_view_exists;
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Campos adicionados na tabela contratos:';
    RAISE NOTICE '  - especificador_id (UUID) - FK para pessoas';
    RAISE NOTICE '  - tem_especificador (BOOLEAN) - auto-calculado';
    RAISE NOTICE '  - codigo_rastreamento (VARCHAR) - para links rastreáveis';
    RAISE NOTICE '  - percentual_comissao (DECIMAL) - customizado por contrato';
    RAISE NOTICE '  - observacoes_indicacao (TEXT) - notas sobre indicação';
    RAISE NOTICE '============================================================';
END $$;

-- Mostrar estrutura atualizada
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'contratos'
  AND column_name IN ('especificador_id', 'tem_especificador', 'codigo_rastreamento', 'percentual_comissao', 'observacoes_indicacao')
ORDER BY column_name;
