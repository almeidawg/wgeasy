-- Migration: Adiciona coluna 'cor' na tabela pricelist_categorias
-- Para permitir customização de cores por categoria no sistema
-- Executar após a criação inicial da tabela pricelist_categorias

BEGIN;

-- Adiciona coluna cor (hex color) para customização visual
ALTER TABLE pricelist_categorias
  ADD COLUMN IF NOT EXISTS cor text DEFAULT '#6B7280';

-- Comentário explicativo
COMMENT ON COLUMN pricelist_categorias.cor IS 'Cor da categoria em formato hexadecimal (ex: #3B82F6)';

-- Atualiza categorias existentes com cores padrão baseadas no nome
-- Cores seguem o padrão definido em categoriasConfig.ts

UPDATE pricelist_categorias SET cor = '#78716C' WHERE nome ILIKE '%pré obra%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#EF4444' WHERE nome ILIKE '%demolições%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#F59E0B' WHERE nome ILIKE '%paredes%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#8B5CF6' WHERE nome ILIKE '%içamento%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#3B82F6' WHERE nome ILIKE '%hidrossanitária%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#EF4444' WHERE nome ILIKE '%gás%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#FBBF24' WHERE nome ILIKE '%elétrica%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#8B5CF6' WHERE nome ILIKE '%automação%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#06B6D4' WHERE nome ILIKE '%infra ar%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#60A5FA' WHERE nome ILIKE '%ar condicionado%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#F97316' WHERE nome ILIKE '%eletrodomésticos%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#A78BFA' WHERE nome ILIKE '%piso%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#6B7280' WHERE nome ILIKE '%gesso%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#14B8A6' WHERE nome ILIKE '%pintura%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#22D3EE' WHERE nome ILIKE '%vidraçaria%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#8B5E3C' WHERE nome ILIKE '%marcenaria%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#A78BFA' WHERE nome ILIKE '%marmoraria%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#06B6D4' WHERE nome ILIKE '%louças%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#FBBF24' WHERE nome ILIKE '%iluminação%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#F97316' WHERE nome ILIKE '%tomadas%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#EC4899' WHERE nome ILIKE '%acabamentos%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#22C55E' WHERE nome ILIKE '%finalização%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#14B8A6' WHERE nome ILIKE '%limpeza%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#2B4580' WHERE nome ILIKE '%mão de obra%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#78716C' WHERE nome ILIKE '%material básico%' AND cor IS NULL;
UPDATE pricelist_categorias SET cor = '#64748B' WHERE nome ILIKE '%produção%' AND cor IS NULL;

COMMIT;
