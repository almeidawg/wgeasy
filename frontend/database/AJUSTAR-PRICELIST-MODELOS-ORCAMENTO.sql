-- ============================================================
-- AJUSTE ESTRUTURAL: PRICELIST + MODELOS DE ORCAMENTO
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================
-- OBJETIVO: Alinhar categorias, tipos e subcategorias do Pricelist
-- com o sistema de Modelos de Orcamento para geracao automatica
-- de lista de materiais a partir da Analise de Projeto.
-- ============================================================

-- ============================================================
-- PARTE 1: TIPOS DE ITEM PADRONIZADOS
-- ============================================================
-- O pricelist atual usa: mao_obra, material, servico, produto
-- Os prompts definem: ACABAMENTO, INSUMO, CONSUMIVEL, MATERIAL
--
-- DECISAO: Manter os tipos atuais do pricelist, mas adicionar
-- um campo "classificacao_orcamento" para mapeamento automatico
-- ============================================================

-- Adicionar campo de classificacao para orcamento
ALTER TABLE pricelist_itens
ADD COLUMN IF NOT EXISTS classificacao_orcamento VARCHAR(30);

COMMENT ON COLUMN pricelist_itens.classificacao_orcamento IS
'Classificacao para orcamento: ACABAMENTO (cliente escolhe), INSUMO (instalacao), CONSUMIVEL (argamassa, rejunte, etc), FERRAMENTA';

-- Criar enum/constraint para validacao
ALTER TABLE pricelist_itens
DROP CONSTRAINT IF EXISTS chk_classificacao_orcamento;

ALTER TABLE pricelist_itens
ADD CONSTRAINT chk_classificacao_orcamento
CHECK (classificacao_orcamento IS NULL OR classificacao_orcamento IN (
  'ACABAMENTO',  -- O que o cliente escolhe (tomadas, porcelanatos, metais)
  'INSUMO',      -- Necessario para instalacao (caixas, fios, tubos, conexoes)
  'CONSUMIVEL',  -- Argamassa, rejunte, cola, fita, tinta
  'FERRAMENTA'   -- Disco diamantado, rolo, pincel
));

-- ============================================================
-- PARTE 2: CATEGORIAS PADRONIZADAS POR DISCIPLINA
-- ============================================================

-- Adicionar constraint UNIQUE no codigo se nao existir
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'pricelist_categorias_codigo_key'
  ) THEN
    -- Primeiro remover duplicatas se houver
    DELETE FROM pricelist_categorias a
    USING pricelist_categorias b
    WHERE a.id > b.id AND a.codigo = b.codigo AND a.codigo IS NOT NULL;

    -- Adicionar constraint
    ALTER TABLE pricelist_categorias ADD CONSTRAINT pricelist_categorias_codigo_key UNIQUE (codigo);
  END IF;
EXCEPTION WHEN others THEN
  RAISE NOTICE 'Constraint ja existe ou erro ao criar: %', SQLERRM;
END $$;

-- Inserir categorias principais se nao existirem
INSERT INTO pricelist_categorias (nome, codigo, tipo, descricao, ordem, ativo)
VALUES
  -- ELETRICA
  ('Eletrica - Acabamentos', 'ELE-ACAB', 'material', 'Tomadas, interruptores, placas, espelhos', 100, true),
  ('Eletrica - Infraestrutura', 'ELE-INFRA', 'material', 'Caixas, eletrodutos, fios, cabos', 101, true),

  -- HIDRAULICA
  ('Hidraulica - Loucas e Metais', 'HID-LOUC', 'produto', 'Bacias, cubas, torneiras, registros de acabamento', 200, true),
  ('Hidraulica - Tubulacao', 'HID-TUBO', 'material', 'Tubos PVC, PPR, conexoes, registros base', 201, true),

  -- REVESTIMENTOS
  ('Revestimentos - Porcelanatos', 'REV-PORC', 'produto', 'Porcelanatos piso e parede', 300, true),
  ('Revestimentos - Ceramicas', 'REV-CER', 'produto', 'Ceramicas e azulejos', 301, true),
  ('Revestimentos - Pisos Especiais', 'REV-PISO', 'produto', 'Piso vinilico, laminado, madeira', 302, true),
  ('Revestimentos - Consumiveis', 'REV-CONS', 'material', 'Argamassas, rejuntes, espassadores', 303, true),

  -- PINTURA
  ('Pintura - Tintas', 'PINT-TINT', 'material', 'Tintas acrilicas, latex, esmalte', 400, true),
  ('Pintura - Preparacao', 'PINT-PREP', 'material', 'Massas, seladores, fundos', 401, true),
  ('Pintura - Consumiveis', 'PINT-CONS', 'material', 'Lixas, fita crepe, lona', 402, true),

  -- MARCENARIA
  ('Marcenaria - Moveis Planejados', 'MARC-MOV', 'produto', 'Moveis sob medida', 500, true),
  ('Marcenaria - Ferragens', 'MARC-FERR', 'material', 'Corredicas, dobradicas, puxadores', 501, true),

  -- GESSO E FORRO
  ('Gesso - Forros e Sancas', 'GESS-FORR', 'material', 'Placas de gesso, perfis, sancas', 600, true),

  -- SERVICOS DE MAO DE OBRA
  ('Servicos - Eletrica', 'SERV-ELE', 'mao_obra', 'Mao de obra eletrica', 700, true),
  ('Servicos - Hidraulica', 'SERV-HID', 'mao_obra', 'Mao de obra hidraulica', 701, true),
  ('Servicos - Revestimentos', 'SERV-REV', 'mao_obra', 'Mao de obra assentamento', 702, true),
  ('Servicos - Pintura', 'SERV-PINT', 'mao_obra', 'Mao de obra pintura', 703, true),
  ('Servicos - Gesso', 'SERV-GESS', 'mao_obra', 'Mao de obra gesso', 704, true),
  ('Servicos - Marcenaria', 'SERV-MARC', 'mao_obra', 'Mao de obra marcenaria/montagem', 705, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  descricao = EXCLUDED.descricao,
  ordem = EXCLUDED.ordem;

-- ============================================================
-- PARTE 3: SUBCATEGORIAS DETALHADAS
-- ============================================================

-- Funcao auxiliar para inserir subcategorias
CREATE OR REPLACE FUNCTION inserir_subcategoria(
  p_categoria_codigo VARCHAR,
  p_nome VARCHAR,
  p_ordem INT
) RETURNS VOID AS $$
DECLARE
  v_categoria_id UUID;
  v_tipo VARCHAR;
BEGIN
  SELECT id, tipo INTO v_categoria_id, v_tipo
  FROM pricelist_categorias
  WHERE codigo = p_categoria_codigo;

  IF v_categoria_id IS NOT NULL THEN
    INSERT INTO pricelist_subcategorias (categoria_id, nome, tipo, ordem, ativo)
    VALUES (v_categoria_id, p_nome, v_tipo, p_ordem, true)
    ON CONFLICT DO NOTHING;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- ELETRICA - Acabamentos
SELECT inserir_subcategoria('ELE-ACAB', 'Tomadas 2P+T', 10);
SELECT inserir_subcategoria('ELE-ACAB', 'Tomadas USB', 20);
SELECT inserir_subcategoria('ELE-ACAB', 'Interruptores', 30);
SELECT inserir_subcategoria('ELE-ACAB', 'Placas e Espelhos', 40);
SELECT inserir_subcategoria('ELE-ACAB', 'Sensores e Dimmers', 50);

-- ELETRICA - Infraestrutura
SELECT inserir_subcategoria('ELE-INFRA', 'Caixas 4x2 e 4x4', 10);
SELECT inserir_subcategoria('ELE-INFRA', 'Caixas Octogonais', 20);
SELECT inserir_subcategoria('ELE-INFRA', 'Eletrodutos', 30);
SELECT inserir_subcategoria('ELE-INFRA', 'Fios e Cabos', 40);
SELECT inserir_subcategoria('ELE-INFRA', 'Disjuntores e Quadros', 50);
SELECT inserir_subcategoria('ELE-INFRA', 'Conectores e Abracadeiras', 60);

-- HIDRAULICA - Loucas e Metais
SELECT inserir_subcategoria('HID-LOUC', 'Bacias Sanitarias', 10);
SELECT inserir_subcategoria('HID-LOUC', 'Cubas', 20);
SELECT inserir_subcategoria('HID-LOUC', 'Torneiras e Misturadores', 30);
SELECT inserir_subcategoria('HID-LOUC', 'Chuveiros e Duchas', 40);
SELECT inserir_subcategoria('HID-LOUC', 'Registros Acabamento', 50);
SELECT inserir_subcategoria('HID-LOUC', 'Acessorios de Banheiro', 60);

-- HIDRAULICA - Tubulacao
SELECT inserir_subcategoria('HID-TUBO', 'Tubos PVC Soldavel', 10);
SELECT inserir_subcategoria('HID-TUBO', 'Tubos PPR Agua Quente', 20);
SELECT inserir_subcategoria('HID-TUBO', 'Tubos Esgoto', 30);
SELECT inserir_subcategoria('HID-TUBO', 'Conexoes PVC', 40);
SELECT inserir_subcategoria('HID-TUBO', 'Conexoes PPR', 50);
SELECT inserir_subcategoria('HID-TUBO', 'Registros Base', 60);
SELECT inserir_subcategoria('HID-TUBO', 'Sifoes e Valvulas', 70);
SELECT inserir_subcategoria('HID-TUBO', 'Flexiveis', 80);

-- REVESTIMENTOS - Porcelanatos
SELECT inserir_subcategoria('REV-PORC', 'Porcelanato Piso 60x60', 10);
SELECT inserir_subcategoria('REV-PORC', 'Porcelanato Piso 80x80', 20);
SELECT inserir_subcategoria('REV-PORC', 'Porcelanato Piso 120x120', 30);
SELECT inserir_subcategoria('REV-PORC', 'Porcelanato Parede', 40);
SELECT inserir_subcategoria('REV-PORC', 'Rodapes Porcelanato', 50);
SELECT inserir_subcategoria('REV-PORC', 'Soleiras e Filetes', 60);

-- REVESTIMENTOS - Pisos Especiais
SELECT inserir_subcategoria('REV-PISO', 'Piso Vinilico Click', 10);
SELECT inserir_subcategoria('REV-PISO', 'Piso Vinilico Colado', 20);
SELECT inserir_subcategoria('REV-PISO', 'Piso Laminado', 30);
SELECT inserir_subcategoria('REV-PISO', 'Rodapes Vinilico/Laminado', 40);
SELECT inserir_subcategoria('REV-PISO', 'Perfis de Transicao', 50);

-- REVESTIMENTOS - Consumiveis
SELECT inserir_subcategoria('REV-CONS', 'Argamassa AC-I', 10);
SELECT inserir_subcategoria('REV-CONS', 'Argamassa AC-II', 20);
SELECT inserir_subcategoria('REV-CONS', 'Argamassa AC-III', 30);
SELECT inserir_subcategoria('REV-CONS', 'Rejunte Flexivel', 40);
SELECT inserir_subcategoria('REV-CONS', 'Rejunte Epoxi', 50);
SELECT inserir_subcategoria('REV-CONS', 'Espassadores', 60);
SELECT inserir_subcategoria('REV-CONS', 'Massa Autonivelante', 70);
SELECT inserir_subcategoria('REV-CONS', 'Cola para Piso Vinilico', 80);

-- PINTURA - Tintas
SELECT inserir_subcategoria('PINT-TINT', 'Tinta Acrilica Premium', 10);
SELECT inserir_subcategoria('PINT-TINT', 'Tinta Acrilica Standard', 20);
SELECT inserir_subcategoria('PINT-TINT', 'Tinta Latex PVA', 30);
SELECT inserir_subcategoria('PINT-TINT', 'Tinta Esmalte', 40);
SELECT inserir_subcategoria('PINT-TINT', 'Vernizes', 50);

-- PINTURA - Preparacao
SELECT inserir_subcategoria('PINT-PREP', 'Massa Corrida PVA', 10);
SELECT inserir_subcategoria('PINT-PREP', 'Massa Acrilica', 20);
SELECT inserir_subcategoria('PINT-PREP', 'Selador Acrilico', 30);
SELECT inserir_subcategoria('PINT-PREP', 'Fundo Preparador', 40);

-- PINTURA - Consumiveis
SELECT inserir_subcategoria('PINT-CONS', 'Lixas', 10);
SELECT inserir_subcategoria('PINT-CONS', 'Fita Crepe', 20);
SELECT inserir_subcategoria('PINT-CONS', 'Lona Plastica', 30);
SELECT inserir_subcategoria('PINT-CONS', 'Rolos e Pinceis', 40);
SELECT inserir_subcategoria('PINT-CONS', 'Bandejas e Extensores', 50);

-- Limpar funcao auxiliar
DROP FUNCTION IF EXISTS inserir_subcategoria(VARCHAR, VARCHAR, INT);

-- ============================================================
-- PARTE 4: EXPANDIR MODELOS DE ORCAMENTO PARA COMPOSICOES
-- ============================================================

-- Adicionar campos para calculo automatico nos itens do modelo
ALTER TABLE modelos_orcamento_itens
ADD COLUMN IF NOT EXISTS calculo_tipo VARCHAR(30) DEFAULT 'POR_UNIDADE',
ADD COLUMN IF NOT EXISTS coeficiente NUMERIC(10,4) DEFAULT 1,
ADD COLUMN IF NOT EXISTS arredondar_para NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS minimo NUMERIC(10,2),
ADD COLUMN IF NOT EXISTS classificacao VARCHAR(30);

COMMENT ON COLUMN modelos_orcamento_itens.calculo_tipo IS
'Tipo de calculo: POR_AREA, POR_PERIMETRO, POR_UNIDADE, FIXO, PROPORCIONAL';

COMMENT ON COLUMN modelos_orcamento_itens.coeficiente IS
'Multiplicador. Ex: 0.25 = 1 saco a cada 4m², 1.10 = 10% de perda';

COMMENT ON COLUMN modelos_orcamento_itens.arredondar_para IS
'Arredondar para multiplos de. Ex: 20 para sacos de 20kg, 3.6 para galoes';

COMMENT ON COLUMN modelos_orcamento_itens.minimo IS
'Quantidade minima. Ex: 1 saco mesmo para areas pequenas';

COMMENT ON COLUMN modelos_orcamento_itens.classificacao IS
'ACABAMENTO, INSUMO, CONSUMIVEL, FERRAMENTA';

-- Constraint para validacao
ALTER TABLE modelos_orcamento_itens
DROP CONSTRAINT IF EXISTS chk_calculo_tipo;

ALTER TABLE modelos_orcamento_itens
ADD CONSTRAINT chk_calculo_tipo
CHECK (calculo_tipo IN ('POR_AREA', 'POR_PERIMETRO', 'POR_UNIDADE', 'FIXO', 'PROPORCIONAL'));

-- ============================================================
-- PARTE 5: CRIAR MODELOS DE COMPOSICAO (TEMPLATES DE MATERIAIS)
-- ============================================================

-- Tabela para composicoes de servico (receitas)
CREATE TABLE IF NOT EXISTS modelos_composicao (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identificacao
  codigo VARCHAR(50) UNIQUE NOT NULL,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,

  -- Classificacao
  disciplina VARCHAR(50) NOT NULL, -- ELETRICA, HIDRAULICA, REVESTIMENTOS, PINTURA, GESSO, MARCENARIA
  categoria VARCHAR(100),

  -- Unidade base do servico
  unidade_base VARCHAR(10) NOT NULL, -- m2, ml, un, vb

  -- Status
  ativo BOOLEAN DEFAULT TRUE,

  -- Auditoria
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Itens da composicao (o que cada servico precisa)
CREATE TABLE IF NOT EXISTS modelos_composicao_itens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  composicao_id UUID REFERENCES modelos_composicao(id) ON DELETE CASCADE,

  -- Classificacao
  classificacao VARCHAR(30) NOT NULL, -- ACABAMENTO, INSUMO, CONSUMIVEL, FERRAMENTA
  categoria_material VARCHAR(100),

  -- Descricao generica (para buscar no pricelist)
  descricao_generica VARCHAR(200) NOT NULL,

  -- Calculo
  calculo_tipo VARCHAR(30) NOT NULL DEFAULT 'POR_UNIDADE', -- POR_AREA, POR_PERIMETRO, POR_UNIDADE, FIXO, PROPORCIONAL
  coeficiente NUMERIC(10,4) NOT NULL DEFAULT 1,
  unidade VARCHAR(10) NOT NULL,

  -- Arredondamento
  arredondar_para NUMERIC(10,2),
  minimo NUMERIC(10,2),

  -- Produto sugerido do pricelist
  pricelist_item_id UUID,

  -- Metadados
  obrigatorio BOOLEAN DEFAULT TRUE,
  observacao TEXT,
  ordem INT DEFAULT 0,

  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_composicao_disciplina ON modelos_composicao(disciplina);
CREATE INDEX IF NOT EXISTS idx_composicao_itens_comp ON modelos_composicao_itens(composicao_id);
CREATE INDEX IF NOT EXISTS idx_composicao_itens_class ON modelos_composicao_itens(classificacao);

-- ============================================================
-- PARTE 6: POPULAR COMPOSICOES BASE
-- ============================================================

-- PISO VINILICO
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('PISO-VINIL', 'Piso Vinilico (Click ou Colado)', 'Instalacao completa de piso vinilico com preparacao', 'REVESTIMENTOS', 'PISOS', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'PISOS', 'Piso vinilico', 'POR_AREA', 1.10, 'm2', NULL, TRUE, '10% de perda', 1
FROM modelos_composicao WHERE codigo = 'PISO-VINIL';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'PREPARACAO', 'Massa autonivelante 20kg', 'POR_AREA', 0.20, 'saco', 1, 1, TRUE, '1 saco a cada 5m2', 2
FROM modelos_composicao WHERE codigo = 'PISO-VINIL';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'ADESIVOS', 'Cola para piso vinilico', 'POR_AREA', 0.25, 'kg', 1, 1, TRUE, '1kg a cada 4m2', 3
FROM modelos_composicao WHERE codigo = 'PISO-VINIL';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'RODAPES', 'Rodape vinilico', 'POR_PERIMETRO', 1.10, 'ml', TRUE, '10% de perda', 4
FROM modelos_composicao WHERE codigo = 'PISO-VINIL';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'PROTECAO', 'Protecao para piso', 'POR_AREA', 1.00, 'm2', TRUE, 5
FROM modelos_composicao WHERE codigo = 'PISO-VINIL';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'FITAS', 'Fita crepe 48mm', 'PROPORCIONAL', 0.05, 'rolo', 1, 1, TRUE, '1 rolo a cada 20m2', 6
FROM modelos_composicao WHERE codigo = 'PISO-VINIL';

-- PISO PORCELANATO
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('PISO-PORC', 'Piso Porcelanato (ate 80x80)', 'Assentamento de porcelanato com rejunte', 'REVESTIMENTOS', 'PISOS', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'PORCELANATOS', 'Porcelanato piso', 'POR_AREA', 1.10, 'm2', TRUE, '10% de perda', 1
FROM modelos_composicao WHERE codigo = 'PISO-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'ARGAMASSAS', 'Argamassa ACIII 20kg', 'POR_AREA', 0.25, 'saco', 1, 1, TRUE, '1 saco a cada 4-5m2', 2
FROM modelos_composicao WHERE codigo = 'PISO-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'REJUNTES', 'Rejunte flexivel', 'POR_AREA', 0.30, 'kg', 1, 1, TRUE, 3
FROM modelos_composicao WHERE codigo = 'PISO-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'ESPASSADORES', 'Espassadores 2mm (pct 100un)', 'POR_AREA', 0.10, 'pct', 1, 1, TRUE, '1 pct a cada 10m2', 4
FROM modelos_composicao WHERE codigo = 'PISO-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'RODAPES', 'Rodape porcelanato', 'POR_PERIMETRO', 1.10, 'ml', TRUE, '10% de perda', 5
FROM modelos_composicao WHERE codigo = 'PISO-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'FERRAMENTA', 'FERRAMENTAS', 'Disco diamantado 110mm', 'POR_AREA', 0.02, 'un', 1, 1, FALSE, '1 disco a cada 50m2', 6
FROM modelos_composicao WHERE codigo = 'PISO-PORC';

-- PINTURA DE PAREDE
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('PINT-PAREDE', 'Pintura de Parede (2 demaos)', 'Pintura completa com preparacao e massa', 'PINTURA', 'PAREDES', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'PREPARACAO', 'Selador acrilico', 'POR_AREA', 0.10, 'L', 3.6, 3.6, TRUE, '1L a cada 10m2 | Galao 3.6L', 1
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'MASSAS', 'Massa corrida PVA', 'POR_AREA', 0.50, 'kg', 25, 25, TRUE, '0.5kg/m2 | Lata 25kg', 2
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'TINTAS', 'Tinta acrilica premium', 'POR_AREA', 0.20, 'L', 18, 3.6, TRUE, '1L a cada 5m2 (2 demaos) | Lata 18L', 3
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'LIXAS', 'Lixa massa 150', 'POR_AREA', 0.05, 'un', 1, 1, TRUE, '1 lixa a cada 20m2', 4
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'FITAS', 'Fita crepe 48mm', 'POR_AREA', 0.02, 'rolo', 1, 1, TRUE, 5
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'PROTECAO', 'Lona plastica', 'POR_AREA', 0.50, 'm2', TRUE, 6
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'FERRAMENTA', 'FERRAMENTAS', 'Rolo la 23cm', 'PROPORCIONAL', 0.01, 'un', 1, 1, TRUE, '1 rolo a cada 100m2', 7
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'FERRAMENTA', 'FERRAMENTAS', 'Pincel 2"', 'FIXO', 1, 'un', TRUE, 8
FROM modelos_composicao WHERE codigo = 'PINT-PAREDE';

-- PONTO ELETRICO TOMADA
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('ELE-TOMADA', 'Ponto de Tomada 4x2', 'Materiais para ponto de tomada completo', 'ELETRICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'TOMADAS', 'Tomada 2P+T 10A', 'POR_UNIDADE', 1, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'PLACAS', 'Placa 4x2', 'POR_UNIDADE', 1, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CAIXAS', 'Caixa 4x2 PVC', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'FIOS', 'Fio 2,5mm', 'POR_UNIDADE', 5, 'm', 100, 100, TRUE, '5m por ponto | Rolo 100m', 4
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'ELETRODUTOS', 'Eletroduto corrugado 25mm', 'POR_UNIDADE', 3, 'm', 50, 50, TRUE, '3m por ponto | Rolo 50m', 5
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'FITAS', 'Fita isolante', 'PROPORCIONAL', 0.05, 'rolo', 1, 1, TRUE, 6
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'FIXACAO', 'Abracadeira nylon', 'POR_UNIDADE', 3, 'un', TRUE, 7
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA';

-- PONTO HIDRAULICO AGUA FRIA
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('HID-AF', 'Ponto de Agua Fria', 'Materiais para ponto de agua fria PVC', 'HIDRAULICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'TUBULACOES', 'Tubo PVC soldavel 25mm', 'POR_UNIDADE', 2, 'm', TRUE, '2m por ponto', 1
FROM modelos_composicao WHERE codigo = 'HID-AF';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Joelho 90 soldavel 25mm', 'POR_UNIDADE', 2, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'HID-AF';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Te soldavel 25mm', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'HID-AF';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'ADESIVOS', 'Cola PVC 175g', 'PROPORCIONAL', 0.10, 'un', 1, 1, TRUE, '1 tubo a cada 10 pontos', 4
FROM modelos_composicao WHERE codigo = 'HID-AF';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'VEDACAO', 'Fita veda-rosca 18mm', 'POR_UNIDADE', 1, 'm', TRUE, 5
FROM modelos_composicao WHERE codigo = 'HID-AF';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'FIXACAO', 'Abracadeira 3/4"', 'POR_UNIDADE', 2, 'un', TRUE, 6
FROM modelos_composicao WHERE codigo = 'HID-AF';

-- ============================================================
-- PARTE 7: FUNCAO PARA ATUALIZAR CLASSIFICACAO AUTOMATICA
-- ============================================================

CREATE OR REPLACE FUNCTION atualizar_classificacao_pricelist()
RETURNS VOID AS $$
BEGIN
  -- ACABAMENTOS - O que o cliente escolhe
  UPDATE pricelist_itens
  SET classificacao_orcamento = 'ACABAMENTO'
  WHERE (
    nome ILIKE '%tomada%'
    OR nome ILIKE '%interruptor%'
    OR nome ILIKE '%placa%espelho%'
    OR nome ILIKE '%porcelanato%'
    OR nome ILIKE '%ceramica%'
    OR nome ILIKE '%piso vinil%'
    OR nome ILIKE '%piso laminado%'
    OR nome ILIKE '%tinta%'
    OR nome ILIKE '%torneira%'
    OR nome ILIKE '%misturador%'
    OR nome ILIKE '%registro acabamento%'
    OR nome ILIKE '%ducha%'
    OR nome ILIKE '%chuveiro%'
    OR nome ILIKE '%cuba%'
    OR nome ILIKE '%bacia%'
    OR nome ILIKE '%vaso sanitario%'
    OR nome ILIKE '%rodape%'
  )
  AND classificacao_orcamento IS NULL;

  -- INSUMOS - Infraestrutura para instalacao
  UPDATE pricelist_itens
  SET classificacao_orcamento = 'INSUMO'
  WHERE (
    nome ILIKE '%caixa 4x%'
    OR nome ILIKE '%caixa octogonal%'
    OR nome ILIKE '%eletroduto%'
    OR nome ILIKE '%fio %mm%'
    OR nome ILIKE '%cabo %mm%'
    OR nome ILIKE '%tubo pvc%'
    OR nome ILIKE '%tubo ppr%'
    OR nome ILIKE '%joelho%'
    OR nome ILIKE '%luva%'
    OR nome ILIKE '% te %'
    OR nome ILIKE '%conexao%'
    OR nome ILIKE '%registro base%'
    OR nome ILIKE '%sifao%'
    OR nome ILIKE '%valvula%'
    OR nome ILIKE '%flexivel%'
    OR nome ILIKE '%disjuntor%'
    OR nome ILIKE '%quadro%'
  )
  AND classificacao_orcamento IS NULL;

  -- CONSUMIVEIS - Materiais que se consomem
  UPDATE pricelist_itens
  SET classificacao_orcamento = 'CONSUMIVEL'
  WHERE (
    nome ILIKE '%argamassa%'
    OR nome ILIKE '%rejunte%'
    OR nome ILIKE '%cola%'
    OR nome ILIKE '%fita isolante%'
    OR nome ILIKE '%fita crepe%'
    OR nome ILIKE '%fita veda%'
    OR nome ILIKE '%massa corrida%'
    OR nome ILIKE '%massa acrilica%'
    OR nome ILIKE '%selador%'
    OR nome ILIKE '%primer%'
    OR nome ILIKE '%fundo preparador%'
    OR nome ILIKE '%lixa%'
    OR nome ILIKE '%espassador%'
    OR nome ILIKE '%silicone%'
    OR nome ILIKE '%lona%'
    OR nome ILIKE '%protecao%'
    OR nome ILIKE '%abracadeira%'
  )
  AND classificacao_orcamento IS NULL;

  -- FERRAMENTAS - Equipamentos
  UPDATE pricelist_itens
  SET classificacao_orcamento = 'FERRAMENTA'
  WHERE (
    nome ILIKE '%disco diamant%'
    OR nome ILIKE '%rolo%'
    OR nome ILIKE '%pincel%'
    OR nome ILIKE '%broxa%'
    OR nome ILIKE '%desempenadeira%'
    OR nome ILIKE '%espatula%'
    OR nome ILIKE '%bandeja%'
  )
  AND classificacao_orcamento IS NULL;

  RAISE NOTICE 'Classificacao de pricelist atualizada com sucesso!';
END;
$$ LANGUAGE plpgsql;

-- Executar atualizacao
SELECT atualizar_classificacao_pricelist();

-- ============================================================
-- VERIFICACAO FINAL
-- ============================================================
DO $$
BEGIN
  RAISE NOTICE '============================================================';
  RAISE NOTICE 'AJUSTE PRICELIST + MODELOS DE ORCAMENTO - Concluido!';
  RAISE NOTICE '============================================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Alteracoes realizadas:';
  RAISE NOTICE '  1. Campo classificacao_orcamento em pricelist_itens';
  RAISE NOTICE '  2. Categorias padronizadas por disciplina';
  RAISE NOTICE '  3. Subcategorias detalhadas';
  RAISE NOTICE '  4. Campos de calculo em modelos_orcamento_itens';
  RAISE NOTICE '  5. Tabela modelos_composicao (templates de materiais)';
  RAISE NOTICE '  6. Tabela modelos_composicao_itens (receitas)';
  RAISE NOTICE '  7. Composicoes base populadas';
  RAISE NOTICE '  8. Classificacao automatica aplicada ao pricelist';
  RAISE NOTICE '';
  RAISE NOTICE 'Composicoes criadas:';
  RAISE NOTICE '  - PISO-VINIL (Piso Vinilico)';
  RAISE NOTICE '  - PISO-PORC (Piso Porcelanato)';
  RAISE NOTICE '  - PINT-PAREDE (Pintura de Parede)';
  RAISE NOTICE '  - ELE-TOMADA (Ponto de Tomada)';
  RAISE NOTICE '  - HID-AF (Ponto de Agua Fria)';
  RAISE NOTICE '============================================================';
END $$;

-- Contagem final
SELECT 'pricelist_categorias' as tabela, COUNT(*) as registros FROM pricelist_categorias
UNION ALL
SELECT 'pricelist_subcategorias', COUNT(*) FROM pricelist_subcategorias
UNION ALL
SELECT 'modelos_composicao', COUNT(*) FROM modelos_composicao
UNION ALL
SELECT 'modelos_composicao_itens', COUNT(*) FROM modelos_composicao_itens
UNION ALL
SELECT 'pricelist_itens com classificacao', COUNT(*) FROM pricelist_itens WHERE classificacao_orcamento IS NOT NULL;
