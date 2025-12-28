-- Cria tabela de subcategorias e coluna de vínculo em itens
BEGIN;

CREATE TABLE IF NOT EXISTS pricelist_subcategorias (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  categoria_id uuid NOT NULL REFERENCES pricelist_categorias(id),
  nome text NOT NULL,
  tipo text NOT NULL CHECK (tipo IN ('material','mao_obra','servico','produto')),
  ordem int DEFAULT 0,
  ativo boolean DEFAULT true,
  criado_em timestamptz DEFAULT now(),
  atualizado_em timestamptz DEFAULT now()
);

ALTER TABLE pricelist_itens
  ADD COLUMN IF NOT EXISTS subcategoria_id uuid REFERENCES pricelist_subcategorias(id);

CREATE INDEX IF NOT EXISTS idx_pricelist_subcategorias_categoria
  ON pricelist_subcategorias(categoria_id, tipo, ativo);

CREATE INDEX IF NOT EXISTS idx_pricelist_itens_subcategoria
  ON pricelist_itens(subcategoria_id);

COMMIT;
