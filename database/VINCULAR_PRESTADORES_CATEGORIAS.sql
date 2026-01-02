-- ============================================================
-- VINCULAR PRESTADORES ÀS CATEGORIAS DE SERVIÇO
-- EXECUTAR NO SUPABASE SQL EDITOR
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/sql/new
-- ============================================================

-- 1. VERIFICAR SE AS CATEGORIAS EXISTEM
SELECT id, codigo, nome FROM servico_categorias ORDER BY ordem;

-- 2. VERIFICAR SE EXISTEM PESSOAS QUE PODEM SER PRESTADORES
SELECT id, nome, tipo, profissao, telefone
FROM pessoas
WHERE tipo IN ('COLABORADOR', 'FORNECEDOR')
  AND ativo = true
ORDER BY tipo, nome;

-- 3. VERIFICAR VÍNCULOS EXISTENTES
SELECT
    p.nome AS prestador,
    p.tipo,
    sc.nome AS categoria,
    pcv.principal
FROM prestador_categoria_vinculo pcv
JOIN pessoas p ON p.id = pcv.prestador_id
JOIN servico_categorias sc ON sc.id = pcv.categoria_id
ORDER BY p.nome;

-- ============================================================
-- 4. VINCULAR TODOS OS COLABORADORES E FORNECEDORES À CATEGORIA 'frete' (exemplo)
-- Descomente e execute separadamente
-- ============================================================

-- Vincular todos colaboradores ativos à categoria 'frete' (transporte)
INSERT INTO prestador_categoria_vinculo (prestador_id, categoria_id, principal)
SELECT
    p.id AS prestador_id,
    sc.id AS categoria_id,
    false AS principal
FROM pessoas p
CROSS JOIN servico_categorias sc
WHERE p.tipo = 'COLABORADOR'
  AND p.ativo = true
  AND sc.codigo = 'frete'
  AND NOT EXISTS (
    SELECT 1 FROM prestador_categoria_vinculo pcv
    WHERE pcv.prestador_id = p.id AND pcv.categoria_id = sc.id
  );

-- Vincular todos fornecedores ativos à categoria 'frete' (transporte)
INSERT INTO prestador_categoria_vinculo (prestador_id, categoria_id, principal)
SELECT
    p.id AS prestador_id,
    sc.id AS categoria_id,
    false AS principal
FROM pessoas p
CROSS JOIN servico_categorias sc
WHERE p.tipo = 'FORNECEDOR'
  AND p.ativo = true
  AND sc.codigo = 'frete'
  AND NOT EXISTS (
    SELECT 1 FROM prestador_categoria_vinculo pcv
    WHERE pcv.prestador_id = p.id AND pcv.categoria_id = sc.id
  );

-- ============================================================
-- 5. VINCULAR A TODAS AS CATEGORIAS DE UMA VEZ (alternativa)
-- Descomente e execute separadamente
-- ============================================================

-- Vincular todos colaboradores a TODAS categorias
INSERT INTO prestador_categoria_vinculo (prestador_id, categoria_id, principal)
SELECT
    p.id AS prestador_id,
    sc.id AS categoria_id,
    false AS principal
FROM pessoas p
CROSS JOIN servico_categorias sc
WHERE p.tipo = 'COLABORADOR'
  AND p.ativo = true
  AND sc.ativo = true
  AND NOT EXISTS (
    SELECT 1 FROM prestador_categoria_vinculo pcv
    WHERE pcv.prestador_id = p.id AND pcv.categoria_id = sc.id
  );

-- Vincular todos fornecedores a TODAS categorias
INSERT INTO prestador_categoria_vinculo (prestador_id, categoria_id, principal)
SELECT
    p.id AS prestador_id,
    sc.id AS categoria_id,
    false AS principal
FROM pessoas p
CROSS JOIN servico_categorias sc
WHERE p.tipo = 'FORNECEDOR'
  AND p.ativo = true
  AND sc.ativo = true
  AND NOT EXISTS (
    SELECT 1 FROM prestador_categoria_vinculo pcv
    WHERE pcv.prestador_id = p.id AND pcv.categoria_id = sc.id
  );

-- ============================================================
-- 6. VERIFICAR RESULTADO NA VIEW
-- ============================================================

SELECT * FROM vw_prestadores_por_categoria ORDER BY nome;

-- ============================================================
-- 7. TESTAR BUSCA POR CATEGORIA ESPECÍFICA
-- ============================================================

-- Buscar prestadores da categoria 'frete'
SELECT * FROM vw_prestadores_por_categoria
WHERE categoria_codigo = 'frete'
ORDER BY nome;
