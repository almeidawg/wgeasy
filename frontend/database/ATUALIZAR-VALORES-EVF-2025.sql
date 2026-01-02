-- ============================================================================
-- ATUALIZACAO DE VALORES EVF - BASEADO EM PESQUISA DE MERCADO 2025
-- Sistema WG Easy - Grupo WG Almeida
-- Data: Dezembro 2025
-- Fontes: SINAPI, CUB, Cronoshare, MySide, WebArCondicionado
-- ============================================================================

-- ============================================================================
-- 1. ATUALIZAR VALORES DAS 18 CATEGORIAS EVF
-- ============================================================================

UPDATE evf_categorias_config SET
  valor_m2_padrao = 55.00,
  updated_at = NOW()
WHERE codigo = 'aquecedor_gas';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 120.00,
  updated_at = NOW()
WHERE codigo = 'arquitetura';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 170.00,
  updated_at = NOW()
WHERE codigo = 'infra_ar_condicionado';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 200.00,
  updated_at = NOW()
WHERE codigo = 'automacao';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 120.00,
  updated_at = NOW()
WHERE codigo = 'cubas_loucas_metais';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 250.00,
  updated_at = NOW()
WHERE codigo = 'eletros';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 280.00,
  updated_at = NOW()
WHERE codigo = 'envidracamento';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 140.00,
  updated_at = NOW()
WHERE codigo = 'gesso';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 100.00,
  updated_at = NOW()
WHERE codigo = 'iluminacao';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 950.00,
  updated_at = NOW()
WHERE codigo = 'mao_obra';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 1800.00,
  updated_at = NOW()
WHERE codigo = 'marcenaria';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 350.00,
  updated_at = NOW()
WHERE codigo = 'marmoraria';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 250.00,
  updated_at = NOW()
WHERE codigo = 'material_basico';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 280.00,
  updated_at = NOW()
WHERE codigo = 'acabamentos';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 70.00,
  updated_at = NOW()
WHERE codigo = 'material_pintura';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 55.00,
  updated_at = NOW()
WHERE codigo = 'tomadas_interruptores';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 250.00,
  updated_at = NOW()
WHERE codigo = 'vidracaria';

UPDATE evf_categorias_config SET
  valor_m2_padrao = 280.00,
  updated_at = NOW()
WHERE codigo = 'ar_condicionado';

-- ============================================================================
-- 2. VERIFICAR ATUALIZACAO
-- ============================================================================

SELECT
  codigo,
  nome,
  valor_m2_padrao,
  ordem
FROM evf_categorias_config
ORDER BY ordem;

-- ============================================================================
-- 3. CALCULAR NOVO TOTAL POR M2
-- ============================================================================

SELECT
  'Total por m2 (padrao medio/alto)' as descricao,
  SUM(valor_m2_padrao) as valor_total_m2
FROM evf_categorias_config
WHERE ativo = true;
