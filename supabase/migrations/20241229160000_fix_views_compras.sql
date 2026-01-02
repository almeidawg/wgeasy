-- ============================================================
-- FIX: Views de Compras
-- Sistema WG Easy - Grupo WG Almeida
-- ============================================================

-- Dropar views existentes para evitar conflitos
DROP VIEW IF EXISTS v_lista_compras_completa CASCADE;
DROP VIEW IF EXISTS v_resumo_financeiro_compras CASCADE;

-- View: Resumo Financeiro por Projeto
CREATE OR REPLACE VIEW v_resumo_financeiro_compras AS
SELECT
  p.id AS projeto_id,
  p.nome AS projeto_nome,
  p.cliente_nome,
  COUNT(lc.id) AS total_itens,
  COALESCE(SUM(CASE WHEN lc.tipo_compra = 'WG_COMPRA' THEN lc.valor_total ELSE 0 END), 0) AS valor_wg_compra,
  COALESCE(SUM(CASE WHEN lc.tipo_compra = 'CLIENTE_DIRETO' THEN lc.valor_total ELSE 0 END), 0) AS valor_cliente_direto,
  COALESCE(SUM(lc.valor_fee), 0) AS total_fee,
  COALESCE(SUM(CASE WHEN lc.tipo_conta = 'REAL' THEN lc.valor_total ELSE 0 END), 0) AS valor_conta_real,
  COALESCE(SUM(CASE WHEN lc.tipo_conta = 'VIRTUAL' THEN lc.valor_total ELSE 0 END), 0) AS valor_conta_virtual
FROM projetos_compras p
LEFT JOIN projeto_lista_compras lc ON lc.projeto_id = p.id
GROUP BY p.id, p.nome, p.cliente_nome;

-- View: Lista de Compras Completa
CREATE OR REPLACE VIEW v_lista_compras_completa AS
SELECT
  lc.*,
  p.codigo AS projeto_codigo,
  p.nome AS projeto_nome,
  p.cliente_nome,
  c.codigo AS categoria_codigo,
  c.nome AS categoria_nome
FROM projeto_lista_compras lc
LEFT JOIN projetos_compras p ON p.id = lc.projeto_id
LEFT JOIN categorias_compras c ON c.id = lc.categoria_id;

DO $$ BEGIN
  RAISE NOTICE '=== VIEWS DE COMPRAS CRIADAS COM SUCESSO ===';
END $$;
