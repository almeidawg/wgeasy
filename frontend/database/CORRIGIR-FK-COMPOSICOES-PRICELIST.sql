-- ============================================================
-- CORREÇÃO: Adicionar Foreign Key de composições para pricelist
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- PROBLEMA: A tabela modelos_composicao_itens tem a coluna
-- pricelist_item_id mas NÃO tem foreign key definida.
-- Isso impede o Supabase de fazer joins corretamente.
-- ============================================================

-- 1. Verificar se a constraint já existe e remover se existir
ALTER TABLE modelos_composicao_itens
DROP CONSTRAINT IF EXISTS fk_composicao_itens_pricelist;

-- 2. Limpar registros com pricelist_item_id inválidos (se houver)
UPDATE modelos_composicao_itens
SET pricelist_item_id = NULL
WHERE pricelist_item_id IS NOT NULL
  AND pricelist_item_id NOT IN (SELECT id FROM pricelist_itens);

-- 3. Adicionar Foreign Key
ALTER TABLE modelos_composicao_itens
ADD CONSTRAINT fk_composicao_itens_pricelist
FOREIGN KEY (pricelist_item_id)
REFERENCES pricelist_itens(id)
ON DELETE SET NULL;

-- 4. Criar índice para melhorar performance do join
CREATE INDEX IF NOT EXISTS idx_composicao_itens_pricelist
ON modelos_composicao_itens(pricelist_item_id)
WHERE pricelist_item_id IS NOT NULL;

-- 5. Verificação
DO $$
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM pg_constraint
  WHERE conname = 'fk_composicao_itens_pricelist';

  IF v_count > 0 THEN
    RAISE NOTICE '✅ Foreign key criada com sucesso!';
    RAISE NOTICE '   O join com pricelist_itens agora funcionará corretamente.';
  ELSE
    RAISE NOTICE '❌ Erro ao criar foreign key!';
  END IF;
END $$;

-- 6. Testar o select com join (deve funcionar agora)
SELECT
  mci.id,
  mci.descricao_generica,
  pi.nome as pricelist_nome,
  pi.preco
FROM modelos_composicao_itens mci
LEFT JOIN pricelist_itens pi ON pi.id = mci.pricelist_item_id
LIMIT 5;
