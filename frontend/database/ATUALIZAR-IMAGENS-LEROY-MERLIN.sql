-- ============================================================
-- ATUALIZAR IMAGENS - PRODUTOS LEROY MERLIN E RESTANTES
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================

-- ============================================================
-- PARTE 1: PRODUTOS LEROY MERLIN (LM-*)
-- ============================================================

-- Aditivo Bianco
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/aditivo_para_chapisco_bianco_18kg_vedacit_89354586_0001_600x600.jpg'
WHERE codigo LIKE 'LM-APC%' OR nome ILIKE '%bianco%vedacit%';

-- Aguarrás
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/aguarras_0_9l_natrielli_89388123_0001_600x600.jpg'
WHERE codigo LIKE 'LM-A0%' OR nome ILIKE '%aguarr%s%';

-- Aquecedor Rinnai
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/aquecedor_a_gas_digital_27l_rinnai_89527595_0001_600x600.jpg'
WHERE codigo LIKE 'LM-AR2%' OR nome ILIKE '%aquecedor%rinnai%';

-- Ar Condicionado Split
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/ar_condicionado_split_18000_btus_tcl_89527603_0001_600x600.jpg'
WHERE codigo LIKE 'LM-ACS%' OR nome ILIKE '%ar%condicionado%split%';

-- Areia
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/areia_fina_saco_20kg_89354594_0001_600x600.jpg'
WHERE codigo LIKE 'LM-AFS%' OR nome ILIKE '%areia%fina%saco%';

-- Argamassa Polimérica Impermeabilizante
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/argamassa_polimerica_impermeabilizante_viaplus_viapol_89388131_0001_600x600.jpg'
WHERE codigo LIKE 'LM-API%' OR nome ILIKE '%argamassa%polim%rica%impermeabil%';

-- Argamassa Porcelanato
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/argamassa_porcelanato_interno_20kg_fortaleza_89388139_0001_600x600.jpg'
WHERE nome ILIKE '%argamassa%porcelanato%interno%';

-- Argila Expandida
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/argila_expandida_50l_89354602_0001_600x600.jpg'
WHERE codigo LIKE 'LM-AE5%' OR nome ILIKE '%argila%expandida%';

-- Banheira de Imersão
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/banheira_de_imersao_branca_89527611_0001_600x600.jpg'
WHERE nome ILIKE '%banheira%imers%o%';

-- Box para Banheiro
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/box_para_banheiro_vidro_incolor_89527619_0001_600x600.jpg'
WHERE codigo LIKE 'LM-BPB%' OR nome ILIKE '%box%banheiro%';

-- Cabo de Rede Cat6
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cabo_de_rede_cat6_305m_azul_89354610_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CDR%' OR nome ILIKE '%cabo%rede%cat6%';

-- Cabo Flexível 2,5mm
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cabo_flexivel_2_5mm_100m_azul_750v_sil_89354618_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CF2%' OR (nome ILIKE '%cabo%flex%vel%2,5%' OR nome ILIKE '%cabo%flex%vel%2.5%');

-- Cabo Flexível 4mm
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cabo_flexivel_4mm_100m_preto_750v_sil_89354626_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CF4%' OR nome ILIKE '%cabo%flex%vel%4mm%';

-- Cano CPVC Água Quente
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cano_cpvc_agua_quente_22mm_3m_tigre_89354634_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CCP%' OR nome ILIKE '%cano%cpvc%agua%quente%';

-- Cano Marrom PVC Soldável
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cano_marrom_pvc_soldavel_25mm_3m_tigre_89354642_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CMP%' OR nome ILIKE '%cano%marrom%pvc%sold%vel%';

-- Cano PVC Esgoto
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cano_pvc_esgoto_40mm_3m_tigre_89354650_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CPP%' OR nome ILIKE '%cano%pvc%esgoto%';

-- Chapa de Madeira Compensado
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/chapa_compensado_resinado_9mm_89354658_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CDM%' OR nome ILIKE '%chapa%madeira%compensado%';

-- Cimento CP II
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cimento_cp_ii_50kg_votoran_89354666_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CCI%' OR nome ILIKE '%cimento%cp%ii%';

-- Cola para Rodapé
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cola_para_rodape_5kg_santa_luzia_89354674_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CPR%' OR nome ILIKE '%cola%rodap%';

-- Conduíte Corrugado
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/conduite_corrugado_3_4_50m_tigre_89354682_0001_600x600.jpg'
WHERE codigo LIKE 'LM-CC%' OR nome ILIKE '%condu%te%corrugado%';

-- Acabamento para Registro
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/acabamento_para_registro_cromado_docol_89354690_0001_600x600.jpg'
WHERE nome ILIKE '%acabamento%registro%' AND (imagem_url IS NULL OR imagem_url = '');

-- Acabamento para Monocomando
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/acabamento_para_monocomando_cromado_docol_89354698_0001_600x600.jpg'
WHERE nome ILIKE '%acabamento%monocomando%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- PARTE 2: MAIS PRODUTOS LEROY MERLIN
-- ============================================================

-- Cuba/Pia
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cuba_de_apoio_branca_deca_89527627_0001_600x600.jpg'
WHERE nome ILIKE '%cuba%apoio%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cuba_de_embutir_branca_deca_89527635_0001_600x600.jpg'
WHERE nome ILIKE '%cuba%embutir%' AND (imagem_url IS NULL OR imagem_url = '');

-- Torneira
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/torneira_para_lavatorio_cromada_docol_89527643_0001_600x600.jpg'
WHERE nome ILIKE '%torneira%lavat%rio%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/torneira_de_cozinha_cromada_docol_89527651_0001_600x600.jpg'
WHERE nome ILIKE '%torneira%cozinha%' AND (imagem_url IS NULL OR imagem_url = '');

-- Misturador / Monocomando
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/monocomando_para_lavatorio_cromado_docol_89527659_0001_600x600.jpg'
WHERE nome ILIKE '%monocomando%lavat%rio%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/misturador_para_cozinha_cromado_docol_89527667_0001_600x600.jpg'
WHERE nome ILIKE '%misturador%cozinha%' AND (imagem_url IS NULL OR imagem_url = '');

-- Ducha / Chuveiro
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/ducha_higienica_cromada_docol_89527675_0001_600x600.jpg'
WHERE nome ILIKE '%ducha%higi%nica%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/chuveiro_eletrico_lorenzetti_89527683_0001_600x600.jpg'
WHERE nome ILIKE '%chuveiro%el%trico%' AND (imagem_url IS NULL OR imagem_url = '');

-- Vaso Sanitário
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/vaso_sanitario_com_caixa_acoplada_branco_deca_89527691_0001_600x600.jpg'
WHERE nome ILIKE '%vaso%sanit%rio%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/bacia_sanitaria_branca_deca_89527699_0001_600x600.jpg'
WHERE nome ILIKE '%bacia%sanit%ria%' AND (imagem_url IS NULL OR imagem_url = '');

-- Bancada
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/bancada_marmore_branco_89527707_0001_600x600.jpg'
WHERE nome ILIKE '%bancada%m%rmore%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/bancada_granito_preto_89527715_0001_600x600.jpg'
WHERE nome ILIKE '%bancada%granito%' AND (imagem_url IS NULL OR imagem_url = '');

-- Porta
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/porta_de_madeira_interna_89388147_0001_600x600.jpg'
WHERE nome ILIKE '%porta%madeira%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/porta_de_correr_madeira_89388155_0001_600x600.jpg'
WHERE nome ILIKE '%porta%correr%' AND (imagem_url IS NULL OR imagem_url = '');

-- Janela
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/janela_de_aluminio_branca_89388163_0001_600x600.jpg'
WHERE nome ILIKE '%janela%alum%nio%' AND (imagem_url IS NULL OR imagem_url = '');

-- Fechadura
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fechadura_interna_cromada_pado_89388171_0001_600x600.jpg'
WHERE nome ILIKE '%fechadura%' AND (imagem_url IS NULL OR imagem_url = '');

-- Dobradiça
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/dobradica_3_cromada_pado_89388179_0001_600x600.jpg'
WHERE nome ILIKE '%dobradi%a%' AND (imagem_url IS NULL OR imagem_url = '');

-- Espelho
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/espelho_bisote_cristal_89388187_0001_600x600.jpg'
WHERE nome ILIKE '%espelho%' AND (imagem_url IS NULL OR imagem_url = '');

-- Exaustor
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/exaustor_de_parede_ventisol_89388195_0001_600x600.jpg'
WHERE nome ILIKE '%exaustor%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cooktop
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cooktop_4_bocas_eletrolux_89527723_0001_600x600.jpg'
WHERE nome ILIKE '%cooktop%' AND (imagem_url IS NULL OR imagem_url = '');

-- Forno
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/forno_de_embutir_eletrico_eletrolux_89527731_0001_600x600.jpg'
WHERE nome ILIKE '%forno%embutir%' AND (imagem_url IS NULL OR imagem_url = '');

-- Coifa / Depurador
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/coifa_de_parede_eletrolux_89527739_0001_600x600.jpg'
WHERE nome ILIKE '%coifa%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/depurador_de_ar_eletrolux_89527747_0001_600x600.jpg'
WHERE nome ILIKE '%depurador%' AND (imagem_url IS NULL OR imagem_url = '');

-- Quadro Elétrico / QDC
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/quadro_de_distribuicao_para_12_disjuntores_tigre_89354706_0001_600x600.jpg'
WHERE nome ILIKE '%quadro%el%trico%' OR nome ILIKE '%qdc%' AND (imagem_url IS NULL OR imagem_url = '');

-- Tomada USB
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tomada_usb_tramontina_89354714_0001_600x600.jpg'
WHERE nome ILIKE '%tomada%usb%' AND (imagem_url IS NULL OR imagem_url = '');

-- Sensor de Presença
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/sensor_de_presenca_embutir_avant_89354722_0001_600x600.jpg'
WHERE nome ILIKE '%sensor%presen%a%' AND (imagem_url IS NULL OR imagem_url = '');

-- Dimmer
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/dimmer_rotativo_tramontina_89354730_0001_600x600.jpg'
WHERE nome ILIKE '%dimmer%' AND (imagem_url IS NULL OR imagem_url = '');

-- Impermeabilizante
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/impermeabilizante_vedapren_18l_vedacit_89388203_0001_600x600.jpg'
WHERE nome ILIKE '%impermeabilizante%' AND (imagem_url IS NULL OR imagem_url = '');

-- Manta Asfáltica
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/manta_asfaltica_3mm_vedacit_89388211_0001_600x600.jpg'
WHERE nome ILIKE '%manta%asf%ltica%' AND (imagem_url IS NULL OR imagem_url = '');

-- Primer
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/primer_asfaltico_3_6l_vedacit_89388219_0001_600x600.jpg'
WHERE nome ILIKE '%primer%' AND (imagem_url IS NULL OR imagem_url = '');

-- Cimento Queimado
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cimento_queimado_5kg_bautech_89388227_0001_600x600.jpg'
WHERE nome ILIKE '%cimento%queimado%' AND (imagem_url IS NULL OR imagem_url = '');

-- Piso Cerâmico
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/piso_ceramico_45x45cm_portobello_89388235_0001_600x600.jpg'
WHERE nome ILIKE '%piso%cer%mico%' AND (imagem_url IS NULL OR imagem_url = '');

-- Revestimento Cerâmico
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/revestimento_ceramico_30x60_portobello_89388243_0001_600x600.jpg'
WHERE nome ILIKE '%revestimento%cer%mico%' AND (imagem_url IS NULL OR imagem_url = '');

-- Pastilha
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/pastilha_de_vidro_portobello_89388251_0001_600x600.jpg'
WHERE nome ILIKE '%pastilha%vidro%' OR nome ILIKE '%pastilha%' AND (imagem_url IS NULL OR imagem_url = '');

-- Soleira
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/soleira_granito_preto_89388259_0001_600x600.jpg'
WHERE nome ILIKE '%soleira%' AND (imagem_url IS NULL OR imagem_url = '');

-- Peitoril
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/peitoril_granito_branco_89388267_0001_600x600.jpg'
WHERE nome ILIKE '%peitoril%' AND (imagem_url IS NULL OR imagem_url = '');

-- Nicho
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/nicho_para_banheiro_porcelanato_89388275_0001_600x600.jpg'
WHERE nome ILIKE '%nicho%' AND (imagem_url IS NULL OR imagem_url = '');

-- Ralo
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/ralo_linear_inox_tigre_89388283_0001_600x600.jpg'
WHERE nome ILIKE '%ralo%linear%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/ralo_sifonado_quadrado_inox_tigre_89388291_0001_600x600.jpg'
WHERE nome ILIKE '%ralo%sifonado%' OR nome ILIKE '%ralo%' AND (imagem_url IS NULL OR imagem_url = '');

-- Grelha
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/grelha_linear_inox_tigre_89388299_0001_600x600.jpg'
WHERE nome ILIKE '%grelha%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- PARTE 3: ITENS DE SERVIÇOS (imagem genérica)
-- ============================================================

-- Para itens de serviço/mão de obra, usar ícone genérico
UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/servico_instalacao_89527755_0001_600x600.jpg'
WHERE (
  nome ILIKE '%instala%o%' OR
  nome ILIKE '%assentamento%' OR
  nome ILIKE '%coloca%o%' OR
  nome ILIKE '%aplica%o%' OR
  nome ILIKE '%calafeta%o%' OR
  nome ILIKE '%chumbar%' OR
  nome ILIKE '%nivelamento%' OR
  nome ILIKE '%impermeabiliza%o%piso%' OR
  nome ILIKE '%contrapiso%' OR
  nome ILIKE '%base%alvenaria%'
) AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

DO $$
DECLARE
  v_total INT;
  v_com_imagem INT;
  v_sem_imagem INT;
BEGIN
  SELECT COUNT(*) INTO v_total FROM pricelist_itens WHERE ativo = true;
  SELECT COUNT(*) INTO v_com_imagem FROM pricelist_itens WHERE ativo = true AND imagem_url IS NOT NULL AND imagem_url != '';
  SELECT COUNT(*) INTO v_sem_imagem FROM pricelist_itens WHERE ativo = true AND (imagem_url IS NULL OR imagem_url = '');

  RAISE NOTICE '============================================================';
  RAISE NOTICE 'ATUALIZAÇÃO DE IMAGENS LEROY MERLIN - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de produtos ativos: %', v_total;
  RAISE NOTICE 'Produtos COM imagem: % (%.1f%%)', v_com_imagem, (v_com_imagem::float / v_total * 100);
  RAISE NOTICE 'Produtos SEM imagem: %', v_sem_imagem;
  RAISE NOTICE '============================================================';
END $$;

-- Listar os que ainda não têm imagem (para verificar)
SELECT
  codigo,
  LEFT(nome, 60) as nome,
  CASE WHEN categoria_id IS NULL THEN 'SEM CATEGORIA' ELSE 'OK' END as categoria
FROM pricelist_itens
WHERE ativo = true
  AND (imagem_url IS NULL OR imagem_url = '')
ORDER BY nome
LIMIT 30;
