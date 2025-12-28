-- ==============================================================================
-- VINCULAR ITENS DAS COMPOSIÇÕES AO PRICELIST IMPORTADO
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ==============================================================================
-- Este SQL vincula os itens das composições aos materiais importados
-- usando os códigos e descrições para fazer o match.
-- ==============================================================================

-- ==============================================================================
-- PARTE 1: VINCULAR MATERIAIS ELÉTRICOS
-- ==============================================================================

-- Tomada 2P+T 10A
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-TOM-001')
WHERE descricao_generica ILIKE '%tomada%2p%t%10a%'
   OR descricao_generica ILIKE '%tomada%2p+t%'
   AND pricelist_item_id IS NULL;

-- Interruptor Simples
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-INT-001')
WHERE descricao_generica ILIKE '%interruptor%simples%'
  AND pricelist_item_id IS NULL;

-- Interruptor Paralelo
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-INT-002')
WHERE descricao_generica ILIKE '%interruptor%paralelo%'
  AND pricelist_item_id IS NULL;

-- Placa 4x2
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-PLC-001')
WHERE descricao_generica ILIKE '%placa%4x2%'
  AND pricelist_item_id IS NULL;

-- Caixa 4x2
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-CX-001')
WHERE descricao_generica ILIKE '%caixa%4x2%'
  AND pricelist_item_id IS NULL;

-- Caixa 4x4
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-CX-002')
WHERE descricao_generica ILIKE '%caixa%4x4%'
  AND pricelist_item_id IS NULL;

-- Caixa Octogonal
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-CX-003')
WHERE descricao_generica ILIKE '%caixa%octogonal%'
  AND pricelist_item_id IS NULL;

-- Eletroduto Corrugado
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-ELET-001')
WHERE descricao_generica ILIKE '%eletroduto%corrugado%'
  AND pricelist_item_id IS NULL;

-- Fio 2,5mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-FIO-001')
WHERE (descricao_generica ILIKE '%fio%2,5%' OR descricao_generica ILIKE '%fio%2.5%')
  AND pricelist_item_id IS NULL;

-- Fio 4mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-FIO-002')
WHERE (descricao_generica ILIKE '%fio%4%mm%' OR descricao_generica ILIKE '%fio%4mm%')
  AND pricelist_item_id IS NULL;

-- Fita Isolante
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-FIT-001')
WHERE descricao_generica ILIKE '%fita%isolante%'
  AND pricelist_item_id IS NULL;

-- Abraçadeira Nylon
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'ELE-ABR-001')
WHERE descricao_generica ILIKE '%abra%adeira%nylon%'
  AND pricelist_item_id IS NULL;

-- ==============================================================================
-- PARTE 2: VINCULAR MATERIAIS HIDRÁULICOS
-- ==============================================================================

-- Tubo PVC Soldável 25mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-TUB-001')
WHERE descricao_generica ILIKE '%tubo%pvc%sold%vel%25%'
  AND pricelist_item_id IS NULL;

-- Tubo PVC Esgoto 50mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-TUB-002')
WHERE descricao_generica ILIKE '%tubo%esgoto%50%'
  AND pricelist_item_id IS NULL;

-- Tubo PVC Esgoto 100mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-TUB-003')
WHERE descricao_generica ILIKE '%tubo%esgoto%100%'
  AND pricelist_item_id IS NULL;

-- Tubo PPR Água Quente
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-TUB-004')
WHERE descricao_generica ILIKE '%tubo%ppr%'
  AND pricelist_item_id IS NULL;

-- Joelho 90 Soldável 25mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CON-001')
WHERE descricao_generica ILIKE '%joelho%90%sold%vel%25%'
  AND pricelist_item_id IS NULL;

-- Tê Soldável 25mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CON-002')
WHERE descricao_generica ILIKE '%te%sold%vel%25%'
  AND pricelist_item_id IS NULL;

-- Luva Soldável 25mm
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CON-003')
WHERE descricao_generica ILIKE '%luva%sold%vel%25%'
  AND pricelist_item_id IS NULL;

-- Cola PVC
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CON-004')
WHERE descricao_generica ILIKE '%cola%pvc%'
  AND pricelist_item_id IS NULL;

-- Fita Veda Rosca
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CON-005')
WHERE descricao_generica ILIKE '%fita%veda%rosca%'
  AND pricelist_item_id IS NULL;

-- Abraçadeira Metálica
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'HID-CON-006')
WHERE (descricao_generica ILIKE '%abra%adeira%3/4%' OR descricao_generica ILIKE '%abra%adeira%metal%')
  AND pricelist_item_id IS NULL;

-- ==============================================================================
-- PARTE 3: VINCULAR MATERIAIS DE PINTURA
-- ==============================================================================

-- Tinta Acrílica Premium 18L
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-TIN-001')
WHERE descricao_generica ILIKE '%tinta%acr%lica%premium%'
  AND pricelist_item_id IS NULL;

-- Tinta Acrílica 3.6L (caso precise galão menor)
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-TIN-002')
WHERE descricao_generica ILIKE '%tinta%acr%lica%'
  AND pricelist_item_id IS NULL;

-- Selador Acrílico
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-SEL-001')
WHERE descricao_generica ILIKE '%selador%acr%lico%'
  AND pricelist_item_id IS NULL;

-- Massa Corrida PVA
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-MAS-001')
WHERE descricao_generica ILIKE '%massa%corrida%pva%'
  AND pricelist_item_id IS NULL;

-- Massa Acrílica
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-MAS-002')
WHERE descricao_generica ILIKE '%massa%acr%lica%'
  AND pricelist_item_id IS NULL;

-- Lixa para Massa
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-LIX-001')
WHERE descricao_generica ILIKE '%lixa%massa%'
  AND pricelist_item_id IS NULL;

-- Fita Crepe
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-FIT-001')
WHERE descricao_generica ILIKE '%fita%crepe%'
  AND pricelist_item_id IS NULL;

-- Lona Plástica
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-LON-001')
WHERE descricao_generica ILIKE '%lona%pl%stica%'
  AND pricelist_item_id IS NULL;

-- Rolo de Lã
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-ROL-001')
WHERE descricao_generica ILIKE '%rolo%l%'
  AND pricelist_item_id IS NULL;

-- Pincel
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'PINT-PIN-001')
WHERE descricao_generica ILIKE '%pincel%'
  AND pricelist_item_id IS NULL;

-- ==============================================================================
-- PARTE 4: VINCULAR MATERIAIS DE REVESTIMENTOS
-- ==============================================================================

-- Argamassa AC-III
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-ARG-001')
WHERE (descricao_generica ILIKE '%argamassa%ac%iii%' OR descricao_generica ILIKE '%argamassa%ac3%' OR descricao_generica ILIKE '%argamassa%aciii%')
  AND pricelist_item_id IS NULL;

-- Argamassa AC-II
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-ARG-002')
WHERE (descricao_generica ILIKE '%argamassa%ac%ii%' OR descricao_generica ILIKE '%argamassa%ac2%')
  AND descricao_generica NOT ILIKE '%iii%'
  AND pricelist_item_id IS NULL;

-- Rejunte Flexível
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-REJ-001')
WHERE descricao_generica ILIKE '%rejunte%flex%vel%'
  AND pricelist_item_id IS NULL;

-- Espaçadores
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-ESP-001')
WHERE descricao_generica ILIKE '%espa%ador%'
  AND pricelist_item_id IS NULL;

-- Disco Diamantado
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-DIS-001')
WHERE descricao_generica ILIKE '%disco%diamant%'
  AND pricelist_item_id IS NULL;

-- Massa Autonivelante
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-MAS-001')
WHERE descricao_generica ILIKE '%massa%autonivel%'
  AND pricelist_item_id IS NULL;

-- Cola para Piso Vinílico
UPDATE modelos_composicao_itens
SET pricelist_item_id = (SELECT id FROM pricelist_itens WHERE codigo = 'REV-COL-001')
WHERE descricao_generica ILIKE '%cola%piso%vin%lico%'
  AND pricelist_item_id IS NULL;

-- ==============================================================================
-- PARTE 5: VERIFICAÇÃO FINAL
-- ==============================================================================

-- Resumo de vinculações
DO $$
DECLARE
  v_total INT;
  v_vinculados INT;
  v_sem_vinculo INT;
BEGIN
  SELECT COUNT(*) INTO v_total FROM modelos_composicao_itens;
  SELECT COUNT(*) INTO v_vinculados FROM modelos_composicao_itens WHERE pricelist_item_id IS NOT NULL;
  SELECT COUNT(*) INTO v_sem_vinculo FROM modelos_composicao_itens WHERE pricelist_item_id IS NULL;

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'VINCULAÇÃO DE COMPOSIÇÕES AO PRICELIST - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de itens de composição: %', v_total;
  RAISE NOTICE 'Itens vinculados ao pricelist: %', v_vinculados;
  RAISE NOTICE 'Itens sem vínculo: %', v_sem_vinculo;
  RAISE NOTICE '============================================================';
END $$;

-- Listar itens vinculados com preços
SELECT
  mc.codigo as composicao_codigo,
  mc.nome as composicao_nome,
  mci.descricao_generica as material,
  mci.classificacao,
  pi.nome as pricelist_nome,
  pi.preco,
  pi.imagem_url
FROM modelos_composicao_itens mci
JOIN modelos_composicao mc ON mc.id = mci.composicao_id
LEFT JOIN pricelist_itens pi ON pi.id = mci.pricelist_item_id
WHERE mci.pricelist_item_id IS NOT NULL
ORDER BY mc.codigo, mci.ordem;

-- Listar itens que ainda precisam de vínculo manual
SELECT DISTINCT
  mci.descricao_generica,
  mci.classificacao
FROM modelos_composicao_itens mci
WHERE pricelist_item_id IS NULL
ORDER BY mci.classificacao, mci.descricao_generica;
