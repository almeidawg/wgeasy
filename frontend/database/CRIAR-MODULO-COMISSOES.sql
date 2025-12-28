-- ============================================================
-- MÓDULO DE COMISSIONAMENTO - EASY SYSTEM
-- Cria todas as tabelas necessárias para o fluxo de comissões
-- ============================================================

-- 1. TABELA DE FAIXAS DE VGV (Valor Geral de Vendas)
-- Define os intervalos de valores para cálculo de comissão
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
    (1, 'Faixa 1 - Até R$ 500k', 0, 500000, 'Projetos de pequeno porte'),
    (2, 'Faixa 2 - R$ 500k a R$ 1M', 500000.01, 1000000, 'Projetos de médio porte'),
    (3, 'Faixa 3 - R$ 1M a R$ 2M', 1000000.01, 2000000, 'Projetos de grande porte'),
    (4, 'Faixa 4 - Acima de R$ 2M', 2000000.01, NULL, 'Mega projetos')
) AS v(cota, nome, valor_minimo, valor_maximo, descricao)
WHERE NOT EXISTS (SELECT 1 FROM faixas_vgv LIMIT 1);

-- 2. TABELA DE CATEGORIAS DE COMISSÃO
-- Define os tipos de profissionais que recebem comissão
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
    -- Vendedores
    ('VEND_DIRETO', 'Vendedor Direto', 'VENDEDOR', false, false, 1, 'Vendedor que atende diretamente o cliente'),
    ('VEND_MASTER', 'Vendedor Master', 'VENDEDOR', true, false, 2, 'Vendedor líder com comissão sobre equipe'),

    -- Especificadores
    ('ESPEC_ARQUITETO', 'Arquiteto Especificador', 'ESPECIFICADOR', false, false, 10, 'Arquiteto que especificou o projeto'),
    ('ESPEC_DESIGNER', 'Designer Especificador', 'ESPECIFICADOR', false, false, 11, 'Designer que especificou o projeto'),
    ('ESPEC_MASTER', 'Especificador Master', 'ESPECIFICADOR', true, false, 12, 'Especificador com comissão reduzida sobre indicações'),
    ('ESPEC_INDICACAO', 'Especificador Indicação', 'ESPECIFICADOR', false, true, 13, 'Comissão sobre indicação de outro profissional'),

    -- Equipe Interna
    ('EQUIPE_COORDENADOR', 'Coordenador de Projeto', 'EQUIPE_INTERNA', false, false, 20, 'Coordenador interno do projeto'),
    ('EQUIPE_GERENTE', 'Gerente Comercial', 'EQUIPE_INTERNA', true, false, 21, 'Gerente comercial com comissão sobre vendas'),
    ('EQUIPE_ASSISTENTE', 'Assistente Comercial', 'EQUIPE_INTERNA', false, false, 22, 'Assistente de vendas')
) AS v(codigo, nome, tipo_pessoa, is_master, is_indicacao, ordem, descricao)
WHERE NOT EXISTS (SELECT 1 FROM categorias_comissao LIMIT 1);

-- 3. TABELA DE PERCENTUAIS DE COMISSÃO
-- Relaciona categoria com faixa para definir o percentual
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

-- Inserir percentuais padrão (tabela cruzada)
DO $$
DECLARE
    cat RECORD;
    fx RECORD;
    perc DECIMAL;
BEGIN
    -- Só inserir se não houver dados
    IF NOT EXISTS (SELECT 1 FROM percentuais_comissao LIMIT 1) THEN
        FOR cat IN SELECT id, codigo, tipo_pessoa, is_master, is_indicacao FROM categorias_comissao WHERE ativo = true LOOP
            FOR fx IN SELECT id, cota FROM faixas_vgv WHERE ativo = true ORDER BY cota LOOP
                -- Calcular percentual base por tipo
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
                VALUES (cat.id, fx.id, perc);
            END LOOP;
        END LOOP;
    END IF;
END $$;

-- 4. VIEW CONSOLIDADA DA TABELA DE COMISSÕES
-- Junta todas as informações para exibição no frontend
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

-- 5. ADICIONAR CAMPO DE CATEGORIA AO CADASTRO DE ESPECIFICADORES
-- Na tabela pessoas, adicionar campo para categoria de comissão
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'pessoas' AND column_name = 'categoria_comissao_id') THEN
        ALTER TABLE pessoas ADD COLUMN categoria_comissao_id UUID REFERENCES categorias_comissao(id);
    END IF;
END $$;

-- 6. TABELA DE COMISSÕES CALCULADAS (Histórico)
-- Armazena comissões calculadas para cada venda/contrato
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

-- 7. ÍNDICES PARA PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_categorias_comissao_tipo ON categorias_comissao(tipo_pessoa);
CREATE INDEX IF NOT EXISTS idx_categorias_comissao_ativo ON categorias_comissao(ativo);
CREATE INDEX IF NOT EXISTS idx_faixas_vgv_cota ON faixas_vgv(cota);
CREATE INDEX IF NOT EXISTS idx_percentuais_categoria ON percentuais_comissao(categoria_id);
CREATE INDEX IF NOT EXISTS idx_percentuais_faixa ON percentuais_comissao(faixa_id);
CREATE INDEX IF NOT EXISTS idx_comissoes_calculadas_contrato ON comissoes_calculadas(contrato_id);
CREATE INDEX IF NOT EXISTS idx_comissoes_calculadas_pessoa ON comissoes_calculadas(pessoa_id);
CREATE INDEX IF NOT EXISTS idx_comissoes_calculadas_status ON comissoes_calculadas(status);

-- 8. FUNÇÃO PARA CALCULAR COMISSÃO
-- Dropar função existente para permitir alteração de tipo de retorno
DROP FUNCTION IF EXISTS calcular_comissao(DECIMAL, UUID);
CREATE OR REPLACE FUNCTION calcular_comissao(
    p_valor_venda DECIMAL,
    p_categoria_id UUID
) RETURNS TABLE (
    faixa_nome VARCHAR,
    percentual DECIMAL,
    valor_comissao DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        f.nome,
        COALESCE(pc.percentual, 0),
        ROUND(p_valor_venda * COALESCE(pc.percentual, 0) / 100, 2)
    FROM faixas_vgv f
    LEFT JOIN percentuais_comissao pc ON pc.faixa_id = f.id AND pc.categoria_id = p_categoria_id
    WHERE f.ativo = true
      AND p_valor_venda >= f.valor_minimo
      AND (f.valor_maximo IS NULL OR p_valor_venda <= f.valor_maximo)
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- 9. POLÍTICAS RLS (Row Level Security)
ALTER TABLE faixas_vgv ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias_comissao ENABLE ROW LEVEL SECURITY;
ALTER TABLE percentuais_comissao ENABLE ROW LEVEL SECURITY;
ALTER TABLE comissoes_calculadas ENABLE ROW LEVEL SECURITY;

-- Remover políticas existentes antes de criar
DROP POLICY IF EXISTS "faixas_vgv_select" ON faixas_vgv;
DROP POLICY IF EXISTS "categorias_comissao_select" ON categorias_comissao;
DROP POLICY IF EXISTS "percentuais_comissao_select" ON percentuais_comissao;
DROP POLICY IF EXISTS "comissoes_calculadas_select" ON comissoes_calculadas;
DROP POLICY IF EXISTS "faixas_vgv_all" ON faixas_vgv;
DROP POLICY IF EXISTS "categorias_comissao_all" ON categorias_comissao;
DROP POLICY IF EXISTS "percentuais_comissao_all" ON percentuais_comissao;
DROP POLICY IF EXISTS "comissoes_calculadas_all" ON comissoes_calculadas;

-- Políticas permissivas para usuários autenticados (SELECT)
CREATE POLICY "faixas_vgv_select" ON faixas_vgv FOR SELECT TO authenticated USING (true);
CREATE POLICY "categorias_comissao_select" ON categorias_comissao FOR SELECT TO authenticated USING (true);
CREATE POLICY "percentuais_comissao_select" ON percentuais_comissao FOR SELECT TO authenticated USING (true);
CREATE POLICY "comissoes_calculadas_select" ON comissoes_calculadas FOR SELECT TO authenticated USING (true);

-- Políticas de modificação para admins (INSERT, UPDATE, DELETE)
CREATE POLICY "faixas_vgv_all" ON faixas_vgv FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

CREATE POLICY "categorias_comissao_all" ON categorias_comissao FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

CREATE POLICY "percentuais_comissao_all" ON percentuais_comissao FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

CREATE POLICY "comissoes_calculadas_all" ON comissoes_calculadas FOR ALL TO authenticated
USING (EXISTS (SELECT 1 FROM usuarios WHERE auth_user_id = auth.uid() AND tipo_usuario IN ('MASTER', 'ADMIN')));

-- ============================================================
-- FIM DO SCRIPT
-- Execute este script no Supabase SQL Editor para ativar
-- o módulo de comissionamento completo
-- ============================================================
