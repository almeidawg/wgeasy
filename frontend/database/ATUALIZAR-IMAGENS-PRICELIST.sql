-- ============================================================
-- ATUALIZAR IMAGENS DE TODOS OS PRODUTOS DO PRICELIST
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- Atualiza imagens usando URLs do CDN da Leroy Merlin
-- ============================================================

-- ============================================================
-- ELÉTRICA
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tomada_2p_t_10a_branca_tramontina_liz_89354257_0001_600x600.jpg'
WHERE (nome ILIKE '%tomada%2p%t%' OR nome ILIKE '%tomada%10a%') AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tomada_2p_t_20a_branca_tramontina_liz_89354265_0001_600x600.jpg'
WHERE nome ILIKE '%tomada%20a%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/interruptor_simples_branco_tramontina_liz_89354224_0001_600x600.jpg'
WHERE nome ILIKE '%interruptor%simples%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/interruptor_paralelo_branco_tramontina_liz_89354232_0001_600x600.jpg'
WHERE nome ILIKE '%interruptor%paralelo%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/interruptor_intermediario_branco_tramontina_89354240_0001_600x600.jpg'
WHERE nome ILIKE '%interruptor%intermedi%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/placa_4x2_2_postos_branca_tramontina_liz_89354273_0001_600x600.jpg'
WHERE nome ILIKE '%placa%4x2%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/placa_4x4_3_postos_branca_tramontina_liz_89354281_0001_600x600.jpg'
WHERE nome ILIKE '%placa%4x4%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/caixa_de_embutir_4x2_amarela_tigre_89354364_0001_600x600.jpg'
WHERE nome ILIKE '%caixa%4x2%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/caixa_de_embutir_4x4_amarela_tigre_89354372_0001_600x600.jpg'
WHERE nome ILIKE '%caixa%4x4%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/caixa_octogonal_fundo_movel_tigre_89354380_0001_600x600.jpg'
WHERE nome ILIKE '%caixa%octogonal%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/eletroduto_corrugado_amarelo_25mm_tigre_89354398_0001_600x600.jpg'
WHERE nome ILIKE '%eletroduto%corrugado%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fio_flexivel_2_5mm_azul_100m_sil_89354406_0001_600x600.jpg'
WHERE (nome ILIKE '%fio%2,5%' OR nome ILIKE '%fio%2.5%') AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fio_flexivel_4mm_preto_100m_sil_89354414_0001_600x600.jpg'
WHERE nome ILIKE '%fio%4mm%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fio_flexivel_1_5mm_preto_100m_sil_89354356_0001_600x600.jpg'
WHERE (nome ILIKE '%fio%1,5%' OR nome ILIKE '%fio%1.5%') AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fio_flexivel_6mm_preto_100m_sil_89354422_0001_600x600.jpg'
WHERE nome ILIKE '%fio%6mm%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fita_isolante_19mm_x_20m_preta_tigre_89354430_0001_600x600.jpg'
WHERE nome ILIKE '%fita%isolante%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/abracadeira_nylon_branca_200mm_100_unidades_89354438_0001_600x600.jpg'
WHERE nome ILIKE '%abra%adeira%nylon%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/abracadeira_1_2_ou_20mmx50m_cz_wtz_91957446_b4ad_600x600.jpg'
WHERE (nome ILIKE '%abra%adeira%1/2%' OR nome ILIKE '%abra%adeira%metal%') AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/disjuntor_unipolar_10a_din_siemens_89354446_0001_600x600.jpg'
WHERE nome ILIKE '%disjuntor%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/quadro_de_distribuicao_para_6_disjuntores_tigre_89354454_0001_600x600.jpg'
WHERE nome ILIKE '%quadro%distribui%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- HIDRÁULICA
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tubo_pvc_soldavel_25mm_3m_tigre_89354462_0001_600x600.jpg'
WHERE nome ILIKE '%tubo%pvc%sold%vel%25%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tubo_pvc_esgoto_50mm_3m_tigre_89354470_0001_600x600.jpg'
WHERE nome ILIKE '%tubo%esgoto%50%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tubo_pvc_esgoto_100mm_3m_tigre_89354488_0001_600x600.jpg'
WHERE nome ILIKE '%tubo%esgoto%100%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tubo_ppr_agua_quente_25mm_3m_tigre_89354496_0001_600x600.jpg'
WHERE nome ILIKE '%tubo%ppr%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/joelho_90_soldavel_25mm_tigre_89354504_0001_600x600.jpg'
WHERE nome ILIKE '%joelho%90%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/te_soldavel_25mm_tigre_89354512_0001_600x600.jpg'
WHERE (nome ILIKE '%te%sold%vel%' OR nome ILIKE '%tê%sold%') AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/luva_soldavel_25mm_tigre_89354520_0001_600x600.jpg'
WHERE nome ILIKE '%luva%sold%vel%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cola_para_pvc_175g_tigre_89354528_0001_600x600.jpg'
WHERE nome ILIKE '%cola%pvc%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fita_veda_rosca_18mm_x_50m_tigre_89354536_0001_600x600.jpg'
WHERE nome ILIKE '%fita%veda%rosca%' OR nome ILIKE '%veda%rosca%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/anel_de_vedacao_para_vaso_sanitario_astra_89519081_0001_600x600.jpg'
WHERE nome ILIKE '%anel%veda%o%bacia%' OR nome ILIKE '%anel%veda%o%vaso%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/curva_90_longa_esgoto_serie_normal_100mm_tigre_89354531_0001_600x600.jpg'
WHERE nome ILIKE '%curva%90%100%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/flexivel_trancado_40cm_1_2_x_1_2_blukit_89527579_0001_600x600.jpg'
WHERE nome ILIKE '%flexivel%40%' OR nome ILIKE '%flex%vel%40%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/juncao_simples_esgoto_serie_normal_50mm_tigre_89354445_0001_600x600.jpg'
WHERE nome ILIKE '%jun%o%simples%50%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/kit_fixacao_vaso_sanitario_astra_89519099_0001_600x600.jpg'
WHERE nome ILIKE '%kit%parafuso%fixa%o%bacia%' OR nome ILIKE '%kit%fixa%o%vaso%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/sifao_sanfonado_universal_branco_astra_89519024_0001_600x600.jpg'
WHERE nome ILIKE '%sif%o%sanfonado%' OR nome ILIKE '%sif%o%copo%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/te_ppr_25mm_tigre_89354684_0001_600x600.jpg'
WHERE nome ILIKE '%te%ppr%' OR nome ILIKE '%tê%ppr%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/valvula_de_escoamento_click_docol_89494789_0001_600x600.jpg'
WHERE nome ILIKE '%v%lvula%escoamento%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/registro_de_pressao_cromado_docol_89354544_0001_600x600.jpg'
WHERE nome ILIKE '%registro%press%o%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/registro_de_gaveta_cromado_docol_89354552_0001_600x600.jpg'
WHERE nome ILIKE '%registro%gaveta%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- PINTURA
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tinta_acrilica_premium_fosco_branco_18l_suvinil_89388703_0001_600x600.jpg'
WHERE nome ILIKE '%tinta%acr%lica%premium%18%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tinta_acrilica_fosco_branco_3_6l_suvinil_89388711_0001_600x600.jpg'
WHERE nome ILIKE '%tinta%acr%lica%3%' OR nome ILIKE '%tinta%acr%lica%3,6%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/tinta_acrilica_fosco_branco_18l_suvinil_89388719_0001_600x600.jpg'
WHERE nome ILIKE '%tinta%acr%lica%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/selador_acrilico_18l_suvinil_89388727_0001_600x600.jpg'
WHERE nome ILIKE '%selador%acr%lico%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/massa_corrida_pva_25kg_suvinil_89388735_0001_600x600.jpg'
WHERE nome ILIKE '%massa%corrida%pva%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/massa_acrilica_25kg_suvinil_89388743_0001_600x600.jpg'
WHERE nome ILIKE '%massa%acr%lica%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/lixa_para_massa_grao_120_norton_89388751_0001_600x600.jpg'
WHERE nome ILIKE '%lixa%massa%' OR nome ILIKE '%lixa%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fita_crepe_24mm_x_50m_adere_89388759_0001_600x600.jpg'
WHERE nome ILIKE '%fita%crepe%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/lona_plastica_preta_4x5m_tigre_89388767_0001_600x600.jpg'
WHERE nome ILIKE '%lona%pl%stica%' OR nome ILIKE '%lona%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rolo_de_la_23cm_atlas_89388775_0001_600x600.jpg'
WHERE nome ILIKE '%rolo%l%23%' OR nome ILIKE '%rolo%pintura%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rolo_antigota_23cm_atlas_89388695_0001_600x600.jpg'
WHERE nome ILIKE '%rolo%anti%gota%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/pincel_2_atlas_89388783_0001_600x600.jpg'
WHERE nome ILIKE '%pincel%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/bandeja_para_pintura_atlas_89388791_0001_600x600.jpg'
WHERE nome ILIKE '%bandeja%pintura%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/espátula_de_aco_6_atlas_89388799_0001_600x600.jpg'
WHERE nome ILIKE '%esp%tula%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- REVESTIMENTOS E PISOS
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/argamassa_ac_iii_branca_20kg_quartzolit_89388807_0001_600x600.jpg'
WHERE (nome ILIKE '%argamassa%ac%iii%' OR nome ILIKE '%argamassa%ac3%' OR nome ILIKE '%argamassa%aciii%') AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/argamassa_ac_ii_cinza_20kg_quartzolit_89388815_0001_600x600.jpg'
WHERE (nome ILIKE '%argamassa%ac%ii%' OR nome ILIKE '%argamassa%ac2%') AND nome NOT ILIKE '%iii%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rejunte_flexivel_cinza_platina_1kg_quartzolit_89388823_0001_600x600.jpg'
WHERE nome ILIKE '%rejunte%flex%vel%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rejunte_epoxi_bicomponente_quartzolit_89388844_0001_600x600.jpg'
WHERE nome ILIKE '%rejunte%epox%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/espacador_para_piso_2mm_pacote_100_unidades_89388831_0001_600x600.jpg'
WHERE nome ILIKE '%espa%ador%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/disco_diamantado_segmentado_110mm_norton_89388839_0001_600x600.jpg'
WHERE nome ILIKE '%disco%diamant%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/massa_autonivelante_20kg_quartzolit_89388847_0001_600x600.jpg'
WHERE nome ILIKE '%massa%autonivel%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cola_para_piso_vinilico_4kg_tarkett_89388855_0001_600x600.jpg'
WHERE nome ILIKE '%cola%piso%vin%lico%' OR nome ILIKE '%cola%vinil%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/porcelanato_acetinado_60x60_bege_portobello_89388836_0001_600x600.jpg'
WHERE nome ILIKE '%porcelanato%piso%' OR nome ILIKE '%porcelanato%60x60%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/porcelanato_parede_30x60_branco_portobello_89388828_0001_600x600.jpg'
WHERE nome ILIKE '%porcelanato%parede%' OR nome ILIKE '%porcelanato%30x60%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/piso_laminado_durafloor_nature_carvalho_89465124_0001_600x600.jpg'
WHERE nome ILIKE '%piso%laminado%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/piso_vinilico_lvt_tarkett_89465140_0001_600x600.jpg'
WHERE nome ILIKE '%piso%vin%lico%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/manta_para_piso_laminado_2mm_durafloor_89465132_0001_600x600.jpg'
WHERE nome ILIKE '%manta%piso%laminado%' OR nome ILIKE '%manta%polietileno%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/perfil_de_acabamento_aluminio_durafloor_89465156_0001_600x600.jpg'
WHERE nome ILIKE '%perfil%acabamento%alumin%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/perfil_de_transicao_t_aluminio_89465164_0001_600x600.jpg'
WHERE nome ILIKE '%perfil%transi%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rodape_mdf_branco_7cm_santa_luzia_89465172_0001_600x600.jpg'
WHERE nome ILIKE '%rodap%mdf%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rodape_porcelanato_portobello_89465180_0001_600x600.jpg'
WHERE nome ILIKE '%rodap%porcelanato%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/rodape_vinilico_flexivel_tarkett_89465188_0001_600x600.jpg'
WHERE nome ILIKE '%rodap%vin%lico%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- GESSO E FORROS
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/placa_de_gesso_acartonado_standard_placo_89494126_0001_600x600.jpg'
WHERE nome ILIKE '%placa%gesso%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/perfil_montante_m_48_knauf_89494142_0001_600x600.jpg'
WHERE nome ILIKE '%perfil%forro%' OR nome ILIKE '%perfil%met%lico%forro%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/perfil_guia_u_48_knauf_89494134_0001_600x600.jpg'
WHERE nome ILIKE '%perfil%sanca%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/moldura_de_gesso_para_sanca_89519247_0001_600x600.jpg'
WHERE nome ILIKE '%placa%gesso%sanca%' OR nome ILIKE '%moldura%sanca%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/gesso_cola_1kg_89519255_0001_600x600.jpg'
WHERE nome ILIKE '%gesso%cola%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/massa_para_drywall_readyfix_knauf_5kg_89494150_0001_600x600.jpg'
WHERE nome ILIKE '%massa%gesso%' OR nome ILIKE '%massa%drywall%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fita_para_drywall_knauf_89494158_0001_600x600.jpg'
WHERE nome ILIKE '%fita%drywall%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/parafuso_para_drywall_knauf_89494166_0001_600x600.jpg'
WHERE nome ILIKE '%parafuso%drywall%' OR nome ILIKE '%parafuso%gesso%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- ILUMINAÇÃO LED
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fita_led_5m_branco_quente_12v_avant_89388455_0001_600x600.jpg'
WHERE nome ILIKE '%fita%led%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fonte_para_fita_led_12v_5a_60w_89388463_0001_600x600.jpg'
WHERE nome ILIKE '%fonte%led%' OR nome ILIKE '%driver%led%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/spot_led_embutir_5w_branco_avant_89388471_0001_600x600.jpg'
WHERE nome ILIKE '%spot%led%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/lampada_led_bulbo_9w_avant_89388479_0001_600x600.jpg'
WHERE nome ILIKE '%l%mpada%led%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/plafon_led_24w_quadrado_avant_89388487_0001_600x600.jpg'
WHERE nome ILIKE '%plafon%led%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- VEDAÇÃO E FIXAÇÃO
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/silicone_neutro_incolor_280g_tekbond_89388091_0001_600x600.jpg'
WHERE nome ILIKE '%silicone%neutro%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/silicone_acetico_branco_280g_tekbond_89388099_0001_600x600.jpg'
WHERE nome ILIKE '%silicone%ac%tico%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/arame_galvanizado_18_1kg_89388927_0001_600x600.jpg'
WHERE nome ILIKE '%arame%galvanizado%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cola_branca_pva_1kg_cascola_89388107_0001_600x600.jpg'
WHERE nome ILIKE '%cola%branca%' OR nome ILIKE '%cola%pva%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/cola_de_contato_500ml_cascola_89388115_0001_600x600.jpg'
WHERE nome ILIKE '%cola%contato%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/fita_de_borda_adesiva_durafloor_89465196_0001_600x600.jpg'
WHERE nome ILIKE '%fita%borda%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/protecao_piso_papelao_ondulado_89388919_0001_600x600.jpg'
WHERE nome ILIKE '%prote%o%piso%' OR nome ILIKE '%papel%o%ondulado%' AND (imagem_url IS NULL OR imagem_url = '');

-- ============================================================
-- FERRAMENTAS
-- ============================================================

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/desempenadeira_de_aco_lisa_tramontina_89388863_0001_600x600.jpg'
WHERE nome ILIKE '%desempenadeira%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/colher_de_pedreiro_tramontina_89388871_0001_600x600.jpg'
WHERE nome ILIKE '%colher%pedreiro%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/trena_5m_starrett_89388879_0001_600x600.jpg'
WHERE nome ILIKE '%trena%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/nivel_de_bolha_40cm_starrett_89388887_0001_600x600.jpg'
WHERE nome ILIKE '%n%vel%bolha%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/martelo_unha_tramontina_89388895_0001_600x600.jpg'
WHERE nome ILIKE '%martelo%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/chave_de_fenda_tramontina_89388903_0001_600x600.jpg'
WHERE nome ILIKE '%chave%fenda%' AND (imagem_url IS NULL OR imagem_url = '');

UPDATE pricelist_itens SET imagem_url = 'https://cdn.leroymerlin.com.br/products/alicate_universal_tramontina_89388911_0001_600x600.jpg'
WHERE nome ILIKE '%alicate%' AND (imagem_url IS NULL OR imagem_url = '');

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
  RAISE NOTICE 'ATUALIZAÇÃO DE IMAGENS - Concluída!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'Total de produtos ativos: %', v_total;
  RAISE NOTICE 'Produtos COM imagem: % (%.1f%%)', v_com_imagem, (v_com_imagem::float / v_total * 100);
  RAISE NOTICE 'Produtos SEM imagem: %', v_sem_imagem;
  RAISE NOTICE '============================================================';
END $$;

-- Listar produtos que ainda não têm imagem
SELECT
  codigo,
  nome,
  categoria_id
FROM pricelist_itens
WHERE ativo = true
  AND (imagem_url IS NULL OR imagem_url = '')
ORDER BY nome
LIMIT 50;
