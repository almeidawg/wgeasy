-- ============================================================
-- COMPOSIÇÃO: PRÉ-OBRA E PROTEÇÃO + MATERIAL CINZA
-- Sistema WG Easy - Grupo WG Almeida
-- Materiais básicos de construção e proteção de obra
-- ============================================================

-- 1. Criar tabela de composições (se não existir)
CREATE TABLE IF NOT EXISTS modelos_composicao (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,
  disciplina VARCHAR(50) NOT NULL DEFAULT 'ALVENARIA',
  categoria VARCHAR(100),
  unidade_base VARCHAR(20) NOT NULL DEFAULT 'un',
  ativo BOOLEAN NOT NULL DEFAULT true,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ
);

-- 2. Criar tabela de itens da composição (se não existir)
CREATE TABLE IF NOT EXISTS modelos_composicao_itens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  composicao_id UUID NOT NULL REFERENCES modelos_composicao(id) ON DELETE CASCADE,
  classificacao VARCHAR(50) NOT NULL DEFAULT 'INSUMO',
  categoria_material VARCHAR(100),
  descricao_generica VARCHAR(300) NOT NULL,
  calculo_tipo VARCHAR(50) NOT NULL DEFAULT 'POR_UNIDADE',
  coeficiente DECIMAL(12,4) NOT NULL DEFAULT 1,
  unidade VARCHAR(20) NOT NULL,
  arredondar_para DECIMAL(12,2),
  minimo DECIMAL(12,2),
  pricelist_item_id UUID,
  obrigatorio BOOLEAN NOT NULL DEFAULT true,
  observacao TEXT,
  ordem INTEGER NOT NULL DEFAULT 0
);

-- 3. Criar índices
CREATE INDEX IF NOT EXISTS idx_composicao_disciplina ON modelos_composicao(disciplina);
CREATE INDEX IF NOT EXISTS idx_composicao_ativo ON modelos_composicao(ativo);
CREATE INDEX IF NOT EXISTS idx_composicao_itens_composicao ON modelos_composicao_itens(composicao_id);

-- 4. Habilitar RLS
ALTER TABLE modelos_composicao ENABLE ROW LEVEL SECURITY;
ALTER TABLE modelos_composicao_itens ENABLE ROW LEVEL SECURITY;

-- 5. Criar políticas RLS (permite acesso a todos usuários autenticados)
DO $$
BEGIN
  -- Políticas para modelos_composicao
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao' AND policyname = 'composicao_select') THEN
    CREATE POLICY composicao_select ON modelos_composicao FOR SELECT TO authenticated USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao' AND policyname = 'composicao_insert') THEN
    CREATE POLICY composicao_insert ON modelos_composicao FOR INSERT TO authenticated WITH CHECK (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao' AND policyname = 'composicao_update') THEN
    CREATE POLICY composicao_update ON modelos_composicao FOR UPDATE TO authenticated USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao' AND policyname = 'composicao_delete') THEN
    CREATE POLICY composicao_delete ON modelos_composicao FOR DELETE TO authenticated USING (true);
  END IF;

  -- Políticas para modelos_composicao_itens
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao_itens' AND policyname = 'composicao_itens_select') THEN
    CREATE POLICY composicao_itens_select ON modelos_composicao_itens FOR SELECT TO authenticated USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao_itens' AND policyname = 'composicao_itens_insert') THEN
    CREATE POLICY composicao_itens_insert ON modelos_composicao_itens FOR INSERT TO authenticated WITH CHECK (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao_itens' AND policyname = 'composicao_itens_update') THEN
    CREATE POLICY composicao_itens_update ON modelos_composicao_itens FOR UPDATE TO authenticated USING (true);
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'modelos_composicao_itens' AND policyname = 'composicao_itens_delete') THEN
    CREATE POLICY composicao_itens_delete ON modelos_composicao_itens FOR DELETE TO authenticated USING (true);
  END IF;
END $$;

-- ============================================================
-- INSERIR COMPOSIÇÃO: PRÉ-OBRA E PROTEÇÃO
-- ============================================================

-- Verificar se a composição já existe
DO $$
DECLARE
  v_composicao_id UUID;
BEGIN
  -- Verificar se já existe
  SELECT id INTO v_composicao_id FROM modelos_composicao WHERE codigo = 'PREOBRA-001';

  -- Se não existe, criar
  IF v_composicao_id IS NULL THEN
    INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
    VALUES (
      'PREOBRA-001',
      'Pré-Obra e Proteção',
      'Materiais básicos para proteção da obra e insumos de construção (material cinza): areia, cimento, gesso, impermeabilizante, proteções',
      'ALVENARIA',
      'PRE-OBRA',
      'un'
    )
    RETURNING id INTO v_composicao_id;

    -- ========== MATERIAIS DE PROTEÇÃO ==========

    INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
    VALUES
    -- Proteção de Pisos e Superfícies
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Protetor de Quina 1,20m x 5cm Salva Quina', 'POR_UNIDADE', 1, 'un', false, 'Para proteção de quinas durante obra', 1),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Protetor de Ralo e Tubulações 10cm Salva Ralo', 'POR_UNIDADE', 6, 'un', true, 'Proteger ralos contra entulho', 2),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Protetor de Piso 25m x 1m Salva Piso', 'POR_UNIDADE', 1, 'rolo', false, 'Rolo para proteção de pisos existentes', 3),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Papelão Reforçado Salva Obra 1,2m x 25m 300g', 'POR_UNIDADE', 1, 'rolo', false, 'Proteção de pisos e bancadas', 4),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Bobina Papel Ondulado 50 metros', 'POR_UNIDADE', 2, 'un', true, 'Para embalar e proteger superfícies', 5),

    -- Fitas e Acessórios
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Fita Crepe Branca 48mm x 50m', 'POR_UNIDADE', 4, 'un', true, 'Para marcação e proteção', 6),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Fita Crepe Branca 24mm x 50m', 'POR_UNIDADE', 4, 'un', false, 'Para acabamentos e detalhes', 7),

    -- Limpeza
    (v_composicao_id, 'CONSUMIVEL', 'LIMPEZA', 'Saco Alvejado de Pano', 'POR_UNIDADE', 5, 'un', true, 'Para limpeza durante obra', 8),
    (v_composicao_id, 'FERRAMENTA', 'LIMPEZA', 'Vassoura Noviça Concept', 'POR_UNIDADE', 1, 'un', true, 'Para limpeza diária', 9),
    (v_composicao_id, 'CONSUMIVEL', 'LIMPEZA', 'Sacos para Entulho', 'POR_UNIDADE', 100, 'un', true, 'Para descarte de entulho', 10),

    -- ========== MATERIAL CINZA - IMPERMEABILIZAÇÃO ==========

    (v_composicao_id, 'INSUMO', 'IMPERMEABILIZANTE', 'Argamassa Polimérica Impermeabilizante Viaplus 5000 Fibras 18kg', 'POR_UNIDADE', 3, 'un', true, 'Para áreas molhadas - box, cozinha', 11),
    (v_composicao_id, 'INSUMO', 'IMPERMEABILIZANTE', 'Argamassa Polimérica Impermeabilizante Viaplus 7000 Fibras 18kg', 'POR_UNIDADE', 1, 'un', false, 'Para áreas externas ou mais expostas', 12),
    (v_composicao_id, 'INSUMO', 'IMPERMEABILIZANTE', 'Aditivo para Chapisco Bianco 18kg Vedacit', 'POR_UNIDADE', 1, 'un', true, 'Para aderência de chapisco', 13),

    -- ========== MATERIAL CINZA - BÁSICOS ==========

    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Areia Fina/Média Saco 20kg', 'POR_UNIDADE', 5, 'sc', true, 'Para argamassa e contrapiso', 14),
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Cimento CP II F 32 Todas as Obras 50kg Votoran', 'POR_UNIDADE', 3, 'sc', true, 'Cimento para uso geral', 15),
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Gesso em Pó 40kg', 'POR_UNIDADE', 1, 'sc', true, 'Para retoques e acabamentos', 16),
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Pedra Britada 1 Saco 20kg', 'POR_UNIDADE', 2, 'sc', false, 'Para contrapiso ou base', 17),
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Argila Expandida 50 Litros', 'POR_UNIDADE', 1, 'sc', false, 'Para enchimento leve', 18),

    -- ========== MATERIAL CINZA - ALVENARIA ==========

    (v_composicao_id, 'INSUMO', 'ALVENARIA', 'Tijolo Comum de Barro 4,3x9,1x18cm', 'POR_UNIDADE', 40, 'un', false, 'Para pequenas alvenarias', 19),
    (v_composicao_id, 'INSUMO', 'ALVENARIA', 'Bloco Cerâmico Vedação 11,5x14x24cm', 'POR_UNIDADE', 20, 'un', false, 'Para fechamentos', 20),

    -- ========== CAIXAS ELÉTRICAS ==========

    (v_composicao_id, 'INSUMO', 'ELETRICA', 'Caixa de Luz Quadrada 4x4', 'POR_UNIDADE', 15, 'un', true, 'Para pontos elétricos', 21),
    (v_composicao_id, 'INSUMO', 'ELETRICA', 'Caixa de Luz Quadrada 4x2', 'POR_UNIDADE', 30, 'un', true, 'Para tomadas e interruptores', 22),
    (v_composicao_id, 'INSUMO', 'ELETRICA', 'Caixa de Luz Quadrada 4x2 Drywall', 'POR_UNIDADE', 10, 'un', false, 'Para paredes de gesso', 23),

    -- ========== MADEIRA ==========

    (v_composicao_id, 'INSUMO', 'MADEIRA', 'Chapa de Madeira Compensado Resinado 9mm', 'POR_UNIDADE', 1, 'un', false, 'Para formas e proteções', 24);

    RAISE NOTICE 'Composição PREOBRA-001 criada com sucesso com % itens', 24;
  ELSE
    RAISE NOTICE 'Composição PREOBRA-001 já existe (id: %)', v_composicao_id;
  END IF;
END $$;

-- ============================================================
-- INSERIR COMPOSIÇÃO: MATERIAL CINZA AVULSO (só insumos)
-- ============================================================

DO $$
DECLARE
  v_composicao_id UUID;
BEGIN
  -- Verificar se já existe
  SELECT id INTO v_composicao_id FROM modelos_composicao WHERE codigo = 'CINZA-001';

  -- Se não existe, criar
  IF v_composicao_id IS NULL THEN
    INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
    VALUES (
      'CINZA-001',
      'Material Cinza - Básico',
      'Kit básico de material cinza: areia, cimento, gesso para pequenas obras e reparos',
      'ALVENARIA',
      'MATERIAL_CINZA',
      'un'
    )
    RETURNING id INTO v_composicao_id;

    INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
    VALUES
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Areia Fina/Média Saco 20kg', 'POR_UNIDADE', 3, 'sc', true, 'Para argamassa', 1),
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Cimento CP II F 32 50kg', 'POR_UNIDADE', 2, 'sc', true, 'Uso geral', 2),
    (v_composicao_id, 'INSUMO', 'MATERIAL_CINZA', 'Gesso em Pó 40kg', 'POR_UNIDADE', 1, 'sc', true, 'Para acabamentos', 3);

    RAISE NOTICE 'Composição CINZA-001 criada com sucesso';
  ELSE
    RAISE NOTICE 'Composição CINZA-001 já existe (id: %)', v_composicao_id;
  END IF;
END $$;

-- ============================================================
-- INSERIR COMPOSIÇÃO: PROTEÇÃO DE OBRA
-- ============================================================

DO $$
DECLARE
  v_composicao_id UUID;
BEGIN
  -- Verificar se já existe
  SELECT id INTO v_composicao_id FROM modelos_composicao WHERE codigo = 'PROT-001';

  -- Se não existe, criar
  IF v_composicao_id IS NULL THEN
    INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
    VALUES (
      'PROT-001',
      'Proteção de Obra',
      'Kit completo de proteção: protetores de piso, quina, ralo, fitas e limpeza',
      'ALVENARIA',
      'PROTECAO',
      'un'
    )
    RETURNING id INTO v_composicao_id;

    INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
    VALUES
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Protetor de Quina Salva Quina 1,20m', 'POR_UNIDADE', 4, 'un', false, 'Para quinas expostas', 1),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Protetor de Ralo Salva Ralo 10cm', 'POR_UNIDADE', 6, 'un', true, 'Para todos os ralos', 2),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Protetor de Piso Salva Piso 25m x 1m', 'POR_UNIDADE', 1, 'rolo', true, 'Para pisos existentes', 3),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Papelão Reforçado Salva Obra 1,2m x 25m', 'POR_UNIDADE', 1, 'rolo', true, 'Proteção geral', 4),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Bobina Papel Ondulado 50m', 'POR_UNIDADE', 2, 'un', true, 'Para embalar', 5),
    (v_composicao_id, 'CONSUMIVEL', 'PROTECAO', 'Fita Crepe 48mm x 50m', 'POR_UNIDADE', 4, 'un', true, 'Para marcação', 6),
    (v_composicao_id, 'CONSUMIVEL', 'LIMPEZA', 'Saco Alvejado de Pano', 'POR_UNIDADE', 5, 'un', true, 'Limpeza', 7),
    (v_composicao_id, 'FERRAMENTA', 'LIMPEZA', 'Vassoura', 'POR_UNIDADE', 1, 'un', true, 'Limpeza diária', 8),
    (v_composicao_id, 'CONSUMIVEL', 'LIMPEZA', 'Sacos para Entulho', 'POR_UNIDADE', 50, 'un', true, 'Descarte', 9);

    RAISE NOTICE 'Composição PROT-001 criada com sucesso';
  ELSE
    RAISE NOTICE 'Composição PROT-001 já existe (id: %)', v_composicao_id;
  END IF;
END $$;

-- ============================================================
-- INSERIR COMPOSIÇÃO: IMPERMEABILIZAÇÃO
-- ============================================================

DO $$
DECLARE
  v_composicao_id UUID;
BEGIN
  -- Verificar se já existe
  SELECT id INTO v_composicao_id FROM modelos_composicao WHERE codigo = 'IMPER-001';

  -- Se não existe, criar
  IF v_composicao_id IS NULL THEN
    INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
    VALUES (
      'IMPER-001',
      'Impermeabilização - Áreas Molhadas',
      'Kit de impermeabilização para box, banheiros e cozinhas',
      'ALVENARIA',
      'IMPERMEABILIZACAO',
      'm2'
    )
    RETURNING id INTO v_composicao_id;

    INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, obrigatorio, observacao, ordem)
    VALUES
    (v_composicao_id, 'INSUMO', 'IMPERMEABILIZANTE', 'Argamassa Polimérica Viaplus 5000 Fibras 18kg', 'POR_AREA', 0.15, 'un', 1, true, 'Rendimento: 1kg/m² por demão, 2 demãos, 18kg rende ~6m²', 1),
    (v_composicao_id, 'INSUMO', 'IMPERMEABILIZANTE', 'Aditivo Bianco 18kg Vedacit', 'POR_AREA', 0.02, 'un', 1, true, 'Para chapisco de aderência', 2),
    (v_composicao_id, 'CONSUMIVEL', 'IMPERMEABILIZANTE', 'Tela de Poliéster para Impermeabilização', 'POR_AREA', 1.1, 'm', null, true, 'Para reforço em cantos e ralos', 3);

    RAISE NOTICE 'Composição IMPER-001 criada com sucesso';
  ELSE
    RAISE NOTICE 'Composição IMPER-001 já existe (id: %)', v_composicao_id;
  END IF;
END $$;

-- Adicionar comentários nas tabelas
COMMENT ON TABLE modelos_composicao IS 'Modelos de composição de materiais para orçamentos';
COMMENT ON TABLE modelos_composicao_itens IS 'Itens que compõem cada modelo de composição';
COMMENT ON COLUMN modelos_composicao.codigo IS 'Código único da composição (ex: PREOBRA-001)';
COMMENT ON COLUMN modelos_composicao.disciplina IS 'ELETRICA, HIDRAULICA, REVESTIMENTOS, PINTURA, GESSO, ALVENARIA, FORRO, MARCENARIA';
COMMENT ON COLUMN modelos_composicao_itens.classificacao IS 'ACABAMENTO, INSUMO, CONSUMIVEL, FERRAMENTA';
COMMENT ON COLUMN modelos_composicao_itens.calculo_tipo IS 'POR_AREA, POR_PERIMETRO, POR_UNIDADE, FIXO, PROPORCIONAL';

-- Composições criadas: PREOBRA-001, CINZA-001, PROT-001, IMPER-001
