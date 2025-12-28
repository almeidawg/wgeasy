-- ============================================================
-- IMPLEMENTAR COMISSÃO MASTER SOBRE INDICADOS
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Este script implementa a lógica para que Masters recebam
-- comissão adicional sobre vendas realizadas por seus indicados
-- ============================================================

-- ============================================================
-- PARTE 0: CRIAR TABELAS BASE SE NÃO EXISTIREM
-- ============================================================

-- Tabela de faixas de VGV
CREATE TABLE IF NOT EXISTS faixas_vgv (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cota INTEGER NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    valor_minimo DECIMAL(15,2) NOT NULL DEFAULT 0,
    valor_maximo DECIMAL(15,2),
    descricao TEXT,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Inserir faixas padrão se não existirem
INSERT INTO faixas_vgv (cota, nome, valor_minimo, valor_maximo, descricao)
SELECT * FROM (VALUES
    (1, 'Faixa 1 - Até R$ 500k', 0::DECIMAL, 500000::DECIMAL, 'Projetos de pequeno porte'),
    (2, 'Faixa 2 - R$ 500k a R$ 1M', 500000.01::DECIMAL, 1000000::DECIMAL, 'Projetos de médio porte'),
    (3, 'Faixa 3 - R$ 1M a R$ 2M', 1000000.01::DECIMAL, 2000000::DECIMAL, 'Projetos de grande porte'),
    (4, 'Faixa 4 - Acima de R$ 2M', 2000000.01::DECIMAL, NULL::DECIMAL, 'Mega projetos')
) AS v(cota, nome, valor_minimo, valor_maximo, descricao)
WHERE NOT EXISTS (SELECT 1 FROM faixas_vgv LIMIT 1);

-- Tabela de categorias de comissão
CREATE TABLE IF NOT EXISTS categorias_comissao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo_pessoa VARCHAR(50) NOT NULL CHECK (tipo_pessoa IN ('VENDEDOR', 'ESPECIFICADOR', 'COLABORADOR', 'EQUIPE_INTERNA')),
    is_master BOOLEAN DEFAULT false,
    is_indicacao BOOLEAN DEFAULT false,
    ordem INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Inserir categorias padrão se não existirem
INSERT INTO categorias_comissao (codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem, descricao)
SELECT * FROM (VALUES
    ('VEND_DIRETO', 'Vendedor Direto', 'VENDEDOR', false, false, 1, 'Vendedor que atende diretamente o cliente'),
    ('VEND_MASTER', 'Vendedor Master', 'VENDEDOR', true, false, 2, 'Vendedor líder com comissão sobre equipe'),
    ('ESPEC_ARQUITETO', 'Arquiteto Especificador', 'ESPECIFICADOR', false, false, 10, 'Arquiteto que especificou o projeto'),
    ('ESPEC_DESIGNER', 'Designer Especificador', 'ESPECIFICADOR', false, false, 11, 'Designer que especificou o projeto'),
    ('ESPEC_MASTER', 'Especificador Master', 'ESPECIFICADOR', true, false, 12, 'Especificador com comissão reduzida sobre indicações'),
    ('ESPEC_INDICACAO', 'Especificador Indicação', 'ESPECIFICADOR', false, true, 13, 'Comissão sobre indicação de outro profissional'),
    ('COLAB_DIRETO', 'Colaborador Direto', 'COLABORADOR', false, false, 15, 'Colaborador com comissão direta'),
    ('COLAB_MASTER', 'Colaborador Master', 'COLABORADOR', true, false, 16, 'Colaborador Master com bônus sobre indicados'),
    ('EQUIPE_COORDENADOR', 'Coordenador de Projeto', 'EQUIPE_INTERNA', false, false, 20, 'Coordenador interno do projeto'),
    ('EQUIPE_GERENTE', 'Gerente Comercial', 'EQUIPE_INTERNA', true, false, 21, 'Gerente comercial com comissão sobre vendas')
) AS v(codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem, descricao)
WHERE NOT EXISTS (SELECT 1 FROM categorias_comissao LIMIT 1);

-- Tabela de percentuais de comissão
CREATE TABLE IF NOT EXISTS percentuais_comissao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria_id UUID NOT NULL REFERENCES categorias_comissao(id) ON DELETE CASCADE,
    faixa_id UUID NOT NULL REFERENCES faixas_vgv(id) ON DELETE CASCADE,
    percentual DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (percentual >= 0 AND percentual <= 100),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(categoria_id, faixa_id)
);

-- Tabela de comissões calculadas
CREATE TABLE IF NOT EXISTS comissoes_calculadas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,
    pessoa_id UUID REFERENCES pessoas(id) ON DELETE SET NULL,
    categoria_id UUID REFERENCES categorias_comissao(id) ON DELETE SET NULL,
    faixa_id UUID REFERENCES faixas_vgv(id) ON DELETE SET NULL,
    valor_base DECIMAL(15,2) NOT NULL,
    percentual DECIMAL(5,2) NOT NULL,
    valor_comissao DECIMAL(15,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN ('pendente', 'aprovado', 'pago', 'cancelado')),
    data_calculo TIMESTAMPTZ DEFAULT NOW(),
    data_pagamento TIMESTAMPTZ,
    observacoes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Inserir percentuais padrão se não existirem
DO $$
DECLARE
    cat RECORD;
    fx RECORD;
    perc DECIMAL;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM percentuais_comissao LIMIT 1) THEN
        FOR cat IN SELECT id, codigo, tipo_pessoa, is_master, is_indicacao FROM categorias_comissao WHERE ativo = true LOOP
            FOR fx IN SELECT id, cota FROM faixas_vgv WHERE ativo = true ORDER BY cota LOOP
                CASE cat.tipo_pessoa
                    WHEN 'VENDEDOR' THEN
                        IF cat.is_master THEN
                            perc := CASE fx.cota WHEN 1 THEN 1.5 WHEN 2 THEN 1.25 WHEN 3 THEN 1.0 ELSE 0.75 END;
                        ELSE
                            perc := CASE fx.cota WHEN 1 THEN 3.0 WHEN 2 THEN 2.5 WHEN 3 THEN 2.0 ELSE 1.5 END;
                        END IF;
                    WHEN 'ESPECIFICADOR' THEN
                        IF cat.is_master THEN
                            perc := CASE fx.cota WHEN 1 THEN 0.75 WHEN 2 THEN 0.5 WHEN 3 THEN 0.5 ELSE 0.25 END;
                        ELSIF cat.is_indicacao THEN
                            perc := CASE fx.cota WHEN 1 THEN 0.5 WHEN 2 THEN 0.5 WHEN 3 THEN 0.25 ELSE 0.25 END;
                        ELSE
                            perc := CASE fx.cota WHEN 1 THEN 2.0 WHEN 2 THEN 1.5 WHEN 3 THEN 1.5 ELSE 1.0 END;
                        END IF;
                    WHEN 'COLABORADOR' THEN
                        IF cat.is_master THEN
                            perc := CASE fx.cota WHEN 1 THEN 0.5 WHEN 2 THEN 0.5 WHEN 3 THEN 0.25 ELSE 0.25 END;
                        ELSE
                            perc := CASE fx.cota WHEN 1 THEN 1.0 WHEN 2 THEN 0.75 WHEN 3 THEN 0.5 ELSE 0.5 END;
                        END IF;
                    WHEN 'EQUIPE_INTERNA' THEN
                        IF cat.is_master THEN
                            perc := CASE fx.cota WHEN 1 THEN 0.5 WHEN 2 THEN 0.5 WHEN 3 THEN 0.25 ELSE 0.25 END;
                        ELSE
                            perc := CASE fx.cota WHEN 1 THEN 0.25 WHEN 2 THEN 0.25 WHEN 3 THEN 0.25 ELSE 0.25 END;
                        END IF;
                    ELSE
                        perc := 0;
                END CASE;

                INSERT INTO percentuais_comissao (categoria_id, faixa_id, percentual)
                VALUES (cat.id, fx.id, perc)
                ON CONFLICT (categoria_id, faixa_id) DO NOTHING;
            END LOOP;
        END LOOP;
    END IF;
END $$;

-- View da tabela de comissões
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
-- PARTE 1: ADICIONAR CAMPOS NA TABELA PESSOAS (se não existirem)
-- ============================================================

-- 1.1 Campo is_master (se o especificador/colaborador é um Master)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'pessoas' AND column_name = 'is_master'
    ) THEN
        ALTER TABLE pessoas ADD COLUMN is_master BOOLEAN DEFAULT FALSE;
        RAISE NOTICE 'Campo is_master adicionado na tabela pessoas!';
    ELSE
        RAISE NOTICE 'Campo is_master já existe';
    END IF;
END $$;

-- 1.2 Campo indicado_por_id (quem indicou este profissional)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'pessoas' AND column_name = 'indicado_por_id'
    ) THEN
        ALTER TABLE pessoas ADD COLUMN indicado_por_id UUID REFERENCES pessoas(id) ON DELETE SET NULL;
        RAISE NOTICE 'Campo indicado_por_id adicionado na tabela pessoas!';
    ELSE
        RAISE NOTICE 'Campo indicado_por_id já existe';
    END IF;
END $$;

-- 1.3 Índices para performance
CREATE INDEX IF NOT EXISTS idx_pessoas_is_master ON pessoas(is_master) WHERE is_master = true;
CREATE INDEX IF NOT EXISTS idx_pessoas_indicado_por ON pessoas(indicado_por_id) WHERE indicado_por_id IS NOT NULL;

-- ============================================================
-- PARTE 2: ADICIONAR CAMPO tipo_comissao NA COMISSOES_CALCULADAS
-- Para diferenciar comissão direta de comissão sobre indicado
-- ============================================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'comissoes_calculadas' AND column_name = 'tipo_comissao'
    ) THEN
        ALTER TABLE comissoes_calculadas
        ADD COLUMN tipo_comissao VARCHAR(30) DEFAULT 'direta'
        CHECK (tipo_comissao IN ('direta', 'sobre_indicado', 'bonus_master'));
        RAISE NOTICE 'Campo tipo_comissao adicionado!';
    ELSE
        RAISE NOTICE 'Campo tipo_comissao já existe';
    END IF;
END $$;

-- Campo para referenciar a comissão principal (para comissões sobre indicado)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'comissoes_calculadas' AND column_name = 'comissao_origem_id'
    ) THEN
        ALTER TABLE comissoes_calculadas
        ADD COLUMN comissao_origem_id UUID REFERENCES comissoes_calculadas(id) ON DELETE SET NULL;
        RAISE NOTICE 'Campo comissao_origem_id adicionado!';
    ELSE
        RAISE NOTICE 'Campo comissao_origem_id já existe';
    END IF;
END $$;

-- ============================================================
-- PARTE 3: FUNÇÃO PARA LISTAR ESPECIFICADORES MASTER
-- ============================================================

CREATE OR REPLACE FUNCTION listar_especificadores_master(p_nucleo_id UUID DEFAULT NULL)
RETURNS TABLE (
    id UUID,
    nome VARCHAR,
    email VARCHAR,
    tipo VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.nome::VARCHAR,
        p.email::VARCHAR,
        p.tipo::VARCHAR
    FROM pessoas p
    WHERE p.is_master = true
      AND p.ativo = true
      AND p.tipo IN ('ESPECIFICADOR', 'COLABORADOR')
      AND (p_nucleo_id IS NULL OR p.nucleo_id = p_nucleo_id)
    ORDER BY p.nome;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- PARTE 4: FUNÇÃO PARA LISTAR INDICADOS POR UM MASTER
-- ============================================================

CREATE OR REPLACE FUNCTION listar_indicados_por_master(p_master_id UUID)
RETURNS TABLE (
    id UUID,
    nome VARCHAR,
    email VARCHAR,
    tipo VARCHAR,
    categoria_nome VARCHAR,
    data_inicio TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.nome::VARCHAR,
        p.email::VARCHAR,
        p.tipo::VARCHAR,
        cc.nome::VARCHAR AS categoria_nome,
        p.created_at AS data_inicio
    FROM pessoas p
    LEFT JOIN categorias_comissao cc ON cc.id = p.categoria_comissao_id
    WHERE p.indicado_por_id = p_master_id
      AND p.ativo = true
    ORDER BY p.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- PARTE 5: FUNÇÃO PRINCIPAL - CALCULAR COMISSÕES DO CONTRATO
-- Calcula comissão do especificador E do Master (se houver)
-- ============================================================

CREATE OR REPLACE FUNCTION calcular_comissoes_contrato(
    p_contrato_id UUID
) RETURNS TABLE (
    pessoa_id UUID,
    pessoa_nome VARCHAR,
    tipo_comissao VARCHAR,
    categoria_nome VARCHAR,
    valor_base DECIMAL,
    percentual DECIMAL,
    valor_comissao DECIMAL
) AS $$
DECLARE
    v_contrato RECORD;
    v_especificador RECORD;
    v_master RECORD;
    v_faixa RECORD;
    v_percentual_esp DECIMAL;
    v_percentual_master DECIMAL;
    v_comissao_esp DECIMAL;
    v_comissao_master DECIMAL;
BEGIN
    -- Buscar dados do contrato
    SELECT
        c.id,
        c.valor_total,
        c.especificador_id,
        c.tem_especificador
    INTO v_contrato
    FROM contratos c
    WHERE c.id = p_contrato_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Contrato não encontrado: %', p_contrato_id;
    END IF;

    -- Se não tem especificador, retornar vazio
    IF NOT v_contrato.tem_especificador OR v_contrato.especificador_id IS NULL THEN
        RETURN;
    END IF;

    -- Buscar dados do especificador
    SELECT
        p.id,
        p.nome,
        p.categoria_comissao_id,
        p.is_master,
        p.indicado_por_id,
        cc.nome AS categoria_nome
    INTO v_especificador
    FROM pessoas p
    LEFT JOIN categorias_comissao cc ON cc.id = p.categoria_comissao_id
    WHERE p.id = v_contrato.especificador_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    -- Encontrar a faixa de VGV aplicável
    SELECT f.id, f.nome
    INTO v_faixa
    FROM faixas_vgv f
    WHERE f.ativo = true
      AND v_contrato.valor_total >= f.valor_minimo
      AND (f.valor_maximo IS NULL OR v_contrato.valor_total <= f.valor_maximo)
    LIMIT 1;

    -- Buscar percentual do especificador
    SELECT pc.percentual
    INTO v_percentual_esp
    FROM percentuais_comissao pc
    WHERE pc.categoria_id = v_especificador.categoria_comissao_id
      AND pc.faixa_id = v_faixa.id
      AND pc.ativo = true;

    v_percentual_esp := COALESCE(v_percentual_esp, 0);
    v_comissao_esp := ROUND(v_contrato.valor_total * v_percentual_esp / 100, 2);

    -- Retornar comissão do especificador
    RETURN QUERY SELECT
        v_especificador.id,
        v_especificador.nome::VARCHAR,
        'direta'::VARCHAR,
        v_especificador.categoria_nome::VARCHAR,
        v_contrato.valor_total,
        v_percentual_esp,
        v_comissao_esp;

    -- Se o especificador foi indicado por um Master, calcular comissão do Master
    IF v_especificador.indicado_por_id IS NOT NULL THEN
        -- Buscar dados do Master
        SELECT
            p.id,
            p.nome,
            p.categoria_comissao_id,
            cc.nome AS categoria_nome
        INTO v_master
        FROM pessoas p
        LEFT JOIN categorias_comissao cc ON cc.id = p.categoria_comissao_id
        WHERE p.id = v_especificador.indicado_por_id
          AND p.is_master = true;

        IF FOUND THEN
            -- Buscar categoria de "sobre indicação" para Master
            -- Usar categoria ESPEC_INDICACAO ou similar
            SELECT pc.percentual
            INTO v_percentual_master
            FROM percentuais_comissao pc
            JOIN categorias_comissao cc ON cc.id = pc.categoria_id
            WHERE cc.is_indicacao = true
              AND cc.tipo_pessoa = 'ESPECIFICADOR'
              AND pc.faixa_id = v_faixa.id
              AND pc.ativo = true
            LIMIT 1;

            v_percentual_master := COALESCE(v_percentual_master, 0);
            v_comissao_master := ROUND(v_contrato.valor_total * v_percentual_master / 100, 2);

            -- Retornar comissão do Master sobre indicado
            RETURN QUERY SELECT
                v_master.id,
                v_master.nome::VARCHAR,
                'sobre_indicado'::VARCHAR,
                ('Master sobre ' || v_especificador.nome)::VARCHAR,
                v_contrato.valor_total,
                v_percentual_master,
                v_comissao_master;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- PARTE 6: FUNÇÃO PARA REGISTRAR COMISSÕES DO CONTRATO
-- Salva as comissões calculadas na tabela
-- ============================================================

CREATE OR REPLACE FUNCTION registrar_comissoes_contrato(
    p_contrato_id UUID
) RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER := 0;
    v_comissao RECORD;
    v_categoria_id UUID;
    v_faixa_id UUID;
    v_contrato RECORD;
BEGIN
    -- Buscar dados do contrato
    SELECT valor_total INTO v_contrato FROM contratos WHERE id = p_contrato_id;

    -- Encontrar faixa
    SELECT id INTO v_faixa_id
    FROM faixas_vgv
    WHERE ativo = true
      AND v_contrato.valor_total >= valor_minimo
      AND (valor_maximo IS NULL OR v_contrato.valor_total <= valor_maximo)
    LIMIT 1;

    -- Iterar sobre comissões calculadas
    FOR v_comissao IN SELECT * FROM calcular_comissoes_contrato(p_contrato_id) LOOP
        -- Buscar categoria_id
        SELECT cc.id INTO v_categoria_id
        FROM pessoas p
        LEFT JOIN categorias_comissao cc ON cc.id = p.categoria_comissao_id
        WHERE p.id = v_comissao.pessoa_id;

        -- Inserir na tabela de comissões calculadas
        INSERT INTO comissoes_calculadas (
            contrato_id,
            pessoa_id,
            categoria_id,
            faixa_id,
            valor_base,
            percentual,
            valor_comissao,
            tipo_comissao,
            status,
            observacoes
        ) VALUES (
            p_contrato_id,
            v_comissao.pessoa_id,
            v_categoria_id,
            v_faixa_id,
            v_comissao.valor_base,
            v_comissao.percentual,
            v_comissao.valor_comissao,
            v_comissao.tipo_comissao,
            'pendente',
            v_comissao.categoria_nome
        )
        ON CONFLICT DO NOTHING;

        v_count := v_count + 1;
    END LOOP;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- PARTE 7: VIEW PARA RELATÓRIO DE COMISSÕES COM MASTERS
-- ============================================================

CREATE OR REPLACE VIEW vw_comissoes_masters AS
SELECT
    cc.id,
    cc.contrato_id,
    c.numero AS contrato_numero,
    c.valor_total AS contrato_valor,
    cc.pessoa_id,
    p.nome AS pessoa_nome,
    p.email AS pessoa_email,
    p.tipo AS pessoa_tipo,
    p.is_master,
    cc.tipo_comissao,
    cat.nome AS categoria_nome,
    cat.codigo AS categoria_codigo,
    f.nome AS faixa_nome,
    cc.valor_base,
    cc.percentual,
    cc.valor_comissao,
    cc.status,
    cc.data_calculo,
    cc.data_pagamento,
    -- Dados do Master (se for comissão de indicado)
    master.id AS master_id,
    master.nome AS master_nome,
    -- Dados do indicador original
    ind.id AS indicador_id,
    ind.nome AS indicador_nome
FROM comissoes_calculadas cc
JOIN contratos c ON c.id = cc.contrato_id
JOIN pessoas p ON p.id = cc.pessoa_id
LEFT JOIN categorias_comissao cat ON cat.id = cc.categoria_id
LEFT JOIN faixas_vgv f ON f.id = cc.faixa_id
LEFT JOIN pessoas master ON master.id = p.indicado_por_id AND master.is_master = true
LEFT JOIN pessoas ind ON ind.id = p.indicado_por_id
ORDER BY cc.data_calculo DESC;

-- ============================================================
-- PARTE 8: VIEW RESUMO DE COMISSÕES POR MASTER
-- ============================================================

CREATE OR REPLACE VIEW vw_resumo_comissoes_master AS
SELECT
    m.id AS master_id,
    m.nome AS master_nome,
    m.email AS master_email,
    m.tipo AS master_tipo,
    COUNT(DISTINCT i.id) AS total_indicados,
    COUNT(DISTINCT cc.contrato_id) AS total_contratos_indicados,
    SUM(CASE WHEN cc.tipo_comissao = 'sobre_indicado' THEN cc.valor_comissao ELSE 0 END) AS total_comissao_indicados,
    SUM(CASE WHEN cc.tipo_comissao = 'direta' AND cc.pessoa_id = m.id THEN cc.valor_comissao ELSE 0 END) AS total_comissao_direta,
    SUM(COALESCE(cc.valor_comissao, 0)) AS total_geral
FROM pessoas m
LEFT JOIN pessoas i ON i.indicado_por_id = m.id AND i.ativo = true
LEFT JOIN comissoes_calculadas cc ON (
    cc.pessoa_id = m.id OR
    (cc.pessoa_id = i.id AND EXISTS (
        SELECT 1 FROM comissoes_calculadas cc2
        WHERE cc2.pessoa_id = m.id
        AND cc2.contrato_id = cc.contrato_id
        AND cc2.tipo_comissao = 'sobre_indicado'
    ))
)
WHERE m.is_master = true AND m.ativo = true
GROUP BY m.id, m.nome, m.email, m.tipo
ORDER BY total_geral DESC;

-- ============================================================
-- PARTE 9: TRIGGER PARA AUTO-CALCULAR COMISSÕES
-- Quando um contrato é marcado como ativo/em_execução
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auto_calcular_comissoes()
RETURNS TRIGGER AS $$
BEGIN
    -- Se o contrato está sendo ativado e tem especificador
    IF NEW.status IN ('ativo', 'em_execucao')
       AND OLD.status NOT IN ('ativo', 'em_execucao')
       AND NEW.tem_especificador = true
       AND NEW.especificador_id IS NOT NULL THEN
        -- Calcular e registrar comissões
        PERFORM registrar_comissoes_contrato(NEW.id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_calcular_comissoes ON contratos;
CREATE TRIGGER trg_auto_calcular_comissoes
    AFTER UPDATE ON contratos
    FOR EACH ROW
    EXECUTE FUNCTION fn_auto_calcular_comissoes();

-- ============================================================
-- PARTE 10: POLÍTICAS RLS (Row Level Security)
-- ============================================================

ALTER TABLE faixas_vgv ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias_comissao ENABLE ROW LEVEL SECURITY;
ALTER TABLE percentuais_comissao ENABLE ROW LEVEL SECURITY;
ALTER TABLE comissoes_calculadas ENABLE ROW LEVEL SECURITY;

-- Remover políticas existentes
DROP POLICY IF EXISTS "faixas_vgv_select" ON faixas_vgv;
DROP POLICY IF EXISTS "categorias_comissao_select" ON categorias_comissao;
DROP POLICY IF EXISTS "percentuais_comissao_select" ON percentuais_comissao;
DROP POLICY IF EXISTS "comissoes_calculadas_select" ON comissoes_calculadas;
DROP POLICY IF EXISTS "faixas_vgv_all" ON faixas_vgv;
DROP POLICY IF EXISTS "categorias_comissao_all" ON categorias_comissao;
DROP POLICY IF EXISTS "percentuais_comissao_all" ON percentuais_comissao;
DROP POLICY IF EXISTS "comissoes_calculadas_all" ON comissoes_calculadas;

-- Políticas de leitura para todos autenticados
CREATE POLICY "faixas_vgv_select" ON faixas_vgv FOR SELECT TO authenticated USING (true);
CREATE POLICY "categorias_comissao_select" ON categorias_comissao FOR SELECT TO authenticated USING (true);
CREATE POLICY "percentuais_comissao_select" ON percentuais_comissao FOR SELECT TO authenticated USING (true);
CREATE POLICY "comissoes_calculadas_select" ON comissoes_calculadas FOR SELECT TO authenticated USING (true);

-- Políticas de modificação para admins
CREATE POLICY "faixas_vgv_all" ON faixas_vgv FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

CREATE POLICY "categorias_comissao_all" ON categorias_comissao FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

CREATE POLICY "percentuais_comissao_all" ON percentuais_comissao FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

CREATE POLICY "comissoes_calculadas_all" ON comissoes_calculadas FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
BEGIN
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'COMISSÃO MASTER SOBRE INDICADOS - Configuração Concluída!';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Funções criadas:';
    RAISE NOTICE '  - listar_especificadores_master(nucleo_id)';
    RAISE NOTICE '  - listar_indicados_por_master(master_id)';
    RAISE NOTICE '  - calcular_comissoes_contrato(contrato_id)';
    RAISE NOTICE '  - registrar_comissoes_contrato(contrato_id)';
    RAISE NOTICE '';
    RAISE NOTICE 'Views criadas:';
    RAISE NOTICE '  - vw_comissoes_masters (relatório detalhado)';
    RAISE NOTICE '  - vw_resumo_comissoes_master (resumo por master)';
    RAISE NOTICE '';
    RAISE NOTICE 'Trigger:';
    RAISE NOTICE '  - trg_auto_calcular_comissoes (auto-calcula ao ativar contrato)';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'FLUXO:';
    RAISE NOTICE '1. Especificador X é cadastrado com indicado_por_id = Master Y';
    RAISE NOTICE '2. Cliente fecha contrato com Especificador X';
    RAISE NOTICE '3. Ao ativar contrato, sistema calcula:';
    RAISE NOTICE '   - Comissão direta do Especificador X';
    RAISE NOTICE '   - Comissão sobre indicado para Master Y';
    RAISE NOTICE '============================================================';
END $$;

-- Mostrar estrutura das funções
SELECT
    routine_name,
    routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name IN (
    'listar_especificadores_master',
    'listar_indicados_por_master',
    'calcular_comissoes_contrato',
    'registrar_comissoes_contrato'
  )
ORDER BY routine_name;
