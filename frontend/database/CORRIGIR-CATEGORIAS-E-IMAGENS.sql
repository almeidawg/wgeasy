-- ============================================================
-- CORRIGIR CATEGORIAS E ADICIONAR IMAGENS RESTANTES
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================

-- ============================================================
-- PARTE 1: ATRIBUIR CATEGORIAS AOS PRODUTOS SEM CATEGORIA
-- ============================================================

-- Primeiro, vamos listar as categorias existentes para referência
-- SELECT id, nome, tipo FROM pricelist_categorias ORDER BY nome;

-- Louças e Metais (banheiros, cubas, torneiras)
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Lou%as%' OR nome ILIKE '%Metais%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%banheiro%luxo%' OR
    nome ILIKE '%cuba%inox%' OR
    nome ILIKE '%cuba%pia%' OR
    nome ILIKE '%torneira%' OR
    nome ILIKE '%misturador%' OR
    nome ILIKE '%monocomando%' OR
    nome ILIKE '%ducha%' OR
    nome ILIKE '%chuveiro%' OR
    nome ILIKE '%vaso%sanit%' OR
    nome ILIKE '%bacia%sanit%' OR
    nome ILIKE '%lavat%rio%'
  );

-- Elétrica
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%El%trica%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%cabo%flex%vel%' OR
    nome ILIKE '%cabo%rede%' OR
    nome ILIKE '%condu%te%' OR
    nome ILIKE '%disjuntor%' OR
    nome ILIKE '%dps%' OR
    nome ILIKE '%tomada%' OR
    nome ILIKE '%interruptor%' OR
    nome ILIKE '%usb%' OR
    nome ILIKE '%double%usb%' OR
    nome ILIKE '%disco%corte%' OR
    nome ILIKE '%fio%' OR
    nome ILIKE '%quadro%' OR
    nome ILIKE '%sensor%' OR
    nome ILIKE '%dimmer%'
  );

-- Hidráulica
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Hidr%ulica%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%cano%' OR
    nome ILIKE '%tubo%pvc%' OR
    nome ILIKE '%tubo%ppr%' OR
    nome ILIKE '%tubo%cpvc%' OR
    nome ILIKE '%cotovelo%' OR
    nome ILIKE '%joelho%' OR
    nome ILIKE '%te %sold%' OR
    nome ILIKE '%tê%' OR
    nome ILIKE '%luva%sold%' OR
    nome ILIKE '%registro%' OR
    nome ILIKE '%v%lvula%' OR
    nome ILIKE '%sif%o%' OR
    nome ILIKE '%flex%vel%' OR
    nome ILIKE '%pex%' OR
    nome ILIKE '%aquecedor%'
  );

-- Pisos e Revestimentos
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Piso%' OR nome ILIKE '%Revestimento%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%porcelanato%' OR
    nome ILIKE '%cer%mico%' OR
    nome ILIKE '%piso%' OR
    nome ILIKE '%revestimento%' OR
    nome ILIKE '%pastilha%' OR
    nome ILIKE '%rejunte%' OR
    nome ILIKE '%argamassa%' OR
    nome ILIKE '%espa%ador%' OR
    nome ILIKE '%cunha%azulejo%' OR
    nome ILIKE '%nivelador%' OR
    nome ILIKE '%rodap%' OR
    nome ILIKE '%soleira%' OR
    nome ILIKE '%peitoril%'
  );

-- Pintura
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Pintura%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%tinta%' OR
    nome ILIKE '%massa%corrida%' OR
    nome ILIKE '%massa%acr%' OR
    nome ILIKE '%selador%' OR
    nome ILIKE '%primer%' OR
    nome ILIKE '%lixa%' OR
    nome ILIKE '%rolo%' OR
    nome ILIKE '%pincel%' OR
    nome ILIKE '%fita%crepe%' OR
    nome ILIKE '%lona%' OR
    nome ILIKE '%bobina%papel%'
  );

-- Gesso e Forros
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Gesso%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%gesso%' OR
    nome ILIKE '%drywall%' OR
    nome ILIKE '%placa%gesso%' OR
    nome ILIKE '%perfil%forro%' OR
    nome ILIKE '%perfil%sanca%'
  );

-- Vedação e Fixação
UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Veda%o%' OR nome ILIKE '%Fixa%o%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%silicone%' OR
    nome ILIKE '%cola%' OR
    nome ILIKE '%adesivo%' OR
    nome ILIKE '%veda%' OR
    nome ILIKE '%fita%' OR
    nome ILIKE '%parafuso%' OR
    nome ILIKE '%bucha%' OR
    nome ILIKE '%prego%'
  );

-- Construção / Materiais Básicos (criar se não existir)
INSERT INTO pricelist_categorias (nome, tipo, descricao, ordem, ativo)
SELECT 'Construção', 'material', 'Materiais básicos de construção', 9, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE nome ILIKE '%Constru%o%');

UPDATE pricelist_itens
SET categoria_id = (SELECT id FROM pricelist_categorias WHERE nome ILIKE '%Constru%o%' LIMIT 1)
WHERE categoria_id IS NULL
  AND (
    nome ILIKE '%cimento%' OR
    nome ILIKE '%areia%' OR
    nome ILIKE '%argila%' OR
    nome ILIKE '%bloco%cer%mico%' OR
    nome ILIKE '%tijolo%' OR
    nome ILIKE '%brita%' OR
    nome ILIKE '%concreto%' OR
    nome ILIKE '%compensado%' OR
    nome ILIKE '%chapa%madeira%' OR
    nome ILIKE '%manta%asf%ltica%' OR
    nome ILIKE '%impermeabil%'
  );

-- ============================================================
-- PARTE 2: IMAGENS PARA PRODUTOS RESTANTES
-- ============================================================

-- Banheiro Luxo Deca
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/kit_banheiro_completo_deca_89527763_0001_600x600.jpg'
WHERE nome ILIKE '%banheiro%luxo%' AND (imagem_url IS NULL OR imagem_url = '');

-- Bloco Cerâmico
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/bloco_ceramico_vedacao_14x19x29_89354738_0001_600x600.jpg'
WHERE nome ILIKE '%bloco%cer%mico%' AND (imagem_url IS NULL OR imagem_url = '');

-- Bobina Papel Ondulado
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/bobina_papel_ondulado_50m_89388307_0001_600x600.jpg'
WHERE nome ILIKE '%bobina%papel%ondulado%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cotovelo/Conexão PEX
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cotovelo_pex_20mm_tigre_89354746_0001_600x600.jpg'
WHERE nome ILIKE '%cotovelo%pex%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cuba Dupla Inox
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cuba_dupla_inox_gourmet_89527771_0001_600x600.jpg'
WHERE nome ILIKE '%cuba%dupla%inox%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cuba Pia Cozinha Gourmet
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cuba_pia_cozinha_gourmet_inox_304_89527779_0001_600x600.jpg'
WHERE nome ILIKE '%cuba%pia%cozinha%gourmet%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cunha para Azulejo / Nivelador
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cunha_niveladora_piso_revestimento_100pcs_89388315_0001_600x600.jpg'
WHERE (nome ILIKE '%cunha%azulejo%' OR nome ILIKE '%nivelador%piso%') AND (imagem_url IS NULL OR imagem_url = '');

-- Disco de Corte
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/disco_corte_fino_ferro_aco_esmerilhadeira_89388323_0001_600x600.jpg'
WHERE nome ILIKE '%disco%corte%' AND (imagem_url IS NULL OR imagem_url = '');

-- Tomada USB Dupla
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tomada_dupla_usb_a_usb_c_glass_89354754_0001_600x600.jpg'
WHERE nome ILIKE '%double%usb%' OR nome ILIKE '%usb%a%usb%c%' AND (imagem_url IS NULL OR imagem_url = '');

-- DPS
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/dps_monopolar_clamper_89354762_0001_600x600.jpg'
WHERE nome ILIKE '%dps%' AND (imagem_url IS NULL OR imagem_url = '');

-- Box para banheiro
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/box_para_banheiro_vidro_incolor_89527619_0001_600x600.jpg'
WHERE nome ILIKE '%box%' AND nome NOT ILIKE '%caixa%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cortineiro
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cortineiro_gesso_89527787_0001_600x600.jpg'
WHERE nome ILIKE '%cortineiro%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- PARTE 3: IMAGENS GENÉRICAS PARA SERVIÇOS
-- ============================================================

-- Documentos/ART
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/documento_projeto_art_89527795_0001_600x600.jpg'
WHERE (nome ILIKE '%art%' OR nome ILIKE '%anota%o%responsabilidade%') AND (imagem_url IS NULL OR imagem_url = '');

-- Mão de obra / Profissionais
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_mao_de_obra_89527803_0001_600x600.jpg'
WHERE (
  nome ILIKE '%ajudante%' OR
  nome ILIKE '%pedreiro%' OR
  nome ILIKE '%eletricista%' OR
  nome ILIKE '%encanador%' OR
  nome ILIKE '%pintor%' OR
  nome ILIKE '%arquiteto%' OR
  nome ILIKE '%engenheiro%' OR
  nome ILIKE '%mestre%obra%'
) AND (imagem_url IS NULL OR imagem_url = '');

-- Demolição
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_demolicao_89527811_0001_600x600.jpg'
WHERE nome ILIKE '%demoli%o%' AND (imagem_url IS NULL OR imagem_url = '');

-- Construção de Alvenaria
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_alvenaria_89527819_0001_600x600.jpg'
WHERE nome ILIKE '%constru%o%alvenaria%' AND (imagem_url IS NULL OR imagem_url = '');

-- Deslocamento de pontos hidráulicos
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_hidraulica_89527827_0001_600x600.jpg'
WHERE (nome ILIKE '%deslocamento%ponto%' OR nome ILIKE '%eliminar%ponto%') AND (imagem_url IS NULL OR imagem_url = '');

-- Emassamento
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_emassamento_89527835_0001_600x600.jpg'
WHERE nome ILIKE '%emassamento%' AND (imagem_url IS NULL OR imagem_url = '');

-- Armários
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/armario_planejado_89527843_0001_600x600.jpg'
WHERE nome ILIKE '%arm%rio%' AND (imagem_url IS NULL OR imagem_url = '');

-- Infraestrutura / Equipamentos
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_infraestrutura_89527851_0001_600x600.jpg'
WHERE nome ILIKE '%acoplamento%equipamento%' AND (imagem_url IS NULL OR imagem_url = '');

-- Quadro Elétrico
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_eletrica_89527859_0001_600x600.jpg'
WHERE nome ILIKE '%altera%o%quadro%el%trico%' AND (imagem_url IS NULL OR imagem_url = '');

-- Batentes
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/batente_porta_madeira_89388331_0001_600x600.jpg'
WHERE nome ILIKE '%batente%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
DECLARE
  v_total INT;
  v_com_cat INT;
  v_sem_cat INT;
  v_com_img INT;
  v_sem_img INT;
BEGIN
  SELECT COUNT(*) INTO v_total FROM pricelist_itens WHERE ativo = true;
  SELECT COUNT(*) INTO v_com_cat FROM pricelist_itens WHERE ativo = true AND categoria_id IS NOT NULL;
  SELECT COUNT(*) INTO v_sem_cat FROM pricelist_itens WHERE ativo = true AND categoria_id IS NULL;
  SELECT COUNT(*) INTO v_com_img FROM pricelist_itens WHERE ativo = true AND imagem_url IS NOT NULL AND imagem_url != '';
  SELECT COUNT(*) INTO v_sem_img FROM pricelist_itens WHERE ativo = true AND (imagem_url IS NULL OR imagem_url = '');

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'CORREÇÃO DE CATEGORIAS E IMAGENS - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de produtos ativos: %', v_total;
  RAISE NOTICE '';
  RAISE NOTICE 'CATEGORIAS:';
  RAISE NOTICE '  COM categoria: % (%.1f%%)', v_com_cat, (v_com_cat::float / v_total * 100);
  RAISE NOTICE '  SEM categoria: %', v_sem_cat;
  RAISE NOTICE '';
  RAISE NOTICE 'IMAGENS:';
  RAISE NOTICE '  COM imagem: % (%.1f%%)', v_com_img, (v_com_img::float / v_total * 100);
  RAISE NOTICE '  SEM imagem: %', v_sem_img;
  RAISE NOTICE '============================================================';
END $$;

-- Listar produtos que AINDA estão sem categoria
SELECT codigo, LEFT(nome, 50) as nome, 'SEM CATEGORIA' as status
FROM pricelist_itens
WHERE ativo = true AND categoria_id IS NULL
ORDER BY nome
LIMIT 20;

-- Listar produtos que AINDA estão sem imagem
SELECT codigo, LEFT(nome, 50) as nome, 'SEM IMAGEM' as status
FROM pricelist_itens
WHERE ativo = true AND (imagem_url IS NULL OR imagem_url = '')
ORDER BY nome
LIMIT 20;
