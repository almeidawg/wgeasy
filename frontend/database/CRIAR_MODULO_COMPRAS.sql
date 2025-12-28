-- ============================================================
-- CRIAR MODULO DE COMPRAS
-- Sistema WG Easy - Grupo WG Almeida
-- Cria todas as tabelas e funcoes necessarias para o modulo de compras
-- ============================================================

-- 1. CRIAR TABELA PEDIDOS_COMPRA (se nao existir)
CREATE TABLE IF NOT EXISTS pedidos_compra (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero VARCHAR(50) NOT NULL UNIQUE,
    contrato_id UUID REFERENCES contratos(id) ON DELETE SET NULL,
    fornecedor_id UUID REFERENCES pessoas(id) ON DELETE SET NULL,
    data_pedido DATE NOT NULL DEFAULT CURRENT_DATE,
    data_previsao_entrega DATE,
    data_entrega_real DATE,
    status VARCHAR(50) NOT NULL DEFAULT 'pendente',
    valor_total NUMERIC(15,2) DEFAULT 0,
    condicoes_pagamento TEXT,
    observacoes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    created_by UUID REFERENCES auth.users(id),
    updated_at TIMESTAMPTZ DEFAULT now(),
    updated_by UUID REFERENCES auth.users(id),

    CONSTRAINT pedidos_compra_status_check CHECK (
        status IN ('pendente', 'aprovado', 'em_transito', 'entregue', 'cancelado', 'rejeitado')
    )
);

-- 2. CRIAR TABELA PEDIDOS_COMPRA_ITENS (se nao existir)
CREATE TABLE IF NOT EXISTS pedidos_compra_itens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pedido_id UUID NOT NULL REFERENCES pedidos_compra(id) ON DELETE CASCADE,
    pricelist_item_id UUID REFERENCES pricelist(id) ON DELETE SET NULL,
    descricao TEXT NOT NULL,
    quantidade NUMERIC(15,4) NOT NULL DEFAULT 1,
    unidade VARCHAR(20) DEFAULT 'un',
    preco_unitario NUMERIC(15,2) NOT NULL DEFAULT 0,
    preco_total NUMERIC(15,2) NOT NULL DEFAULT 0,
    observacoes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. CRIAR INDICES PARA PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_status ON pedidos_compra(status);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_fornecedor ON pedidos_compra(fornecedor_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_contrato ON pedidos_compra(contrato_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_data ON pedidos_compra(data_pedido);
CREATE INDEX IF NOT EXISTS idx_pedidos_compra_itens_pedido ON pedidos_compra_itens(pedido_id);

-- 4. CRIAR FUNCAO PARA GERAR NUMERO DO PEDIDO
CREATE OR REPLACE FUNCTION gerar_numero_pedido_compra()
RETURNS TEXT AS $$
DECLARE
    ano TEXT;
    sequencia INTEGER;
    numero TEXT;
BEGIN
    ano := to_char(CURRENT_DATE, 'YYYY');

    -- Buscar ultimo numero do ano atual
    SELECT COALESCE(MAX(
        CAST(SUBSTRING(p.numero FROM 'PC-' || ano || '-(\d+)') AS INTEGER)
    ), 0) + 1
    INTO sequencia
    FROM pedidos_compra p
    WHERE p.numero LIKE 'PC-' || ano || '-%';

    numero := 'PC-' || ano || '-' || LPAD(sequencia::TEXT, 5, '0');

    RETURN numero;
END;
$$ LANGUAGE plpgsql;

-- 5. CRIAR TRIGGER PARA ATUALIZAR updated_at
CREATE OR REPLACE FUNCTION update_pedido_compra_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_pedido_compra_updated_at ON pedidos_compra;
CREATE TRIGGER trigger_update_pedido_compra_updated_at
    BEFORE UPDATE ON pedidos_compra
    FOR EACH ROW
    EXECUTE FUNCTION update_pedido_compra_updated_at();

-- 6. HABILITAR RLS (Row Level Security)
ALTER TABLE pedidos_compra ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos_compra_itens ENABLE ROW LEVEL SECURITY;

-- 7. CRIAR POLITICAS RLS PERMISSIVAS (todos usuarios autenticados podem ver)
DO $$
BEGIN
    -- Politicas para pedidos_compra
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_select') THEN
        CREATE POLICY pedidos_compra_select ON pedidos_compra
            FOR SELECT TO authenticated USING (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_insert') THEN
        CREATE POLICY pedidos_compra_insert ON pedidos_compra
            FOR INSERT TO authenticated WITH CHECK (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_update') THEN
        CREATE POLICY pedidos_compra_update ON pedidos_compra
            FOR UPDATE TO authenticated USING (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra' AND policyname = 'pedidos_compra_delete') THEN
        CREATE POLICY pedidos_compra_delete ON pedidos_compra
            FOR DELETE TO authenticated USING (true);
    END IF;

    -- Politicas para pedidos_compra_itens
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra_itens' AND policyname = 'pedidos_compra_itens_select') THEN
        CREATE POLICY pedidos_compra_itens_select ON pedidos_compra_itens
            FOR SELECT TO authenticated USING (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra_itens' AND policyname = 'pedidos_compra_itens_insert') THEN
        CREATE POLICY pedidos_compra_itens_insert ON pedidos_compra_itens
            FOR INSERT TO authenticated WITH CHECK (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra_itens' AND policyname = 'pedidos_compra_itens_update') THEN
        CREATE POLICY pedidos_compra_itens_update ON pedidos_compra_itens
            FOR UPDATE TO authenticated USING (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'pedidos_compra_itens' AND policyname = 'pedidos_compra_itens_delete') THEN
        CREATE POLICY pedidos_compra_itens_delete ON pedidos_compra_itens
            FOR DELETE TO authenticated USING (true);
    END IF;
END $$;

-- 8. COMENTARIOS NAS TABELAS
COMMENT ON TABLE pedidos_compra IS 'Tabela de pedidos de compra para fornecedores';
COMMENT ON COLUMN pedidos_compra.numero IS 'Numero sequencial do pedido no formato PC-YYYY-NNNNN';
COMMENT ON COLUMN pedidos_compra.status IS 'Status: pendente, aprovado, em_transito, entregue, cancelado, rejeitado';

COMMENT ON TABLE pedidos_compra_itens IS 'Itens dos pedidos de compra';

-- 9. CRIAR TABELA FINANCEIRO_SOLICITACOES (se nao existir)
CREATE TABLE IF NOT EXISTS financeiro_solicitacoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitante_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
    descricao TEXT NOT NULL,
    valor NUMERIC(15,2) NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'pendente',
    observacoes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),

    CONSTRAINT financeiro_solicitacoes_status_check CHECK (
        status IN ('pendente', 'aprovado', 'rejeitado', 'pago')
    )
);

-- 10. HABILITAR RLS E POLITICAS PARA FINANCEIRO_SOLICITACOES
ALTER TABLE financeiro_solicitacoes ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'financeiro_solicitacoes' AND policyname = 'financeiro_solicitacoes_select') THEN
        CREATE POLICY financeiro_solicitacoes_select ON financeiro_solicitacoes
            FOR SELECT TO authenticated USING (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'financeiro_solicitacoes' AND policyname = 'financeiro_solicitacoes_insert') THEN
        CREATE POLICY financeiro_solicitacoes_insert ON financeiro_solicitacoes
            FOR INSERT TO authenticated WITH CHECK (true);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'financeiro_solicitacoes' AND policyname = 'financeiro_solicitacoes_update') THEN
        CREATE POLICY financeiro_solicitacoes_update ON financeiro_solicitacoes
            FOR UPDATE TO authenticated USING (true);
    END IF;
END $$;

SELECT '=== MODULO DE COMPRAS CRIADO COM SUCESSO ===' as resultado;
