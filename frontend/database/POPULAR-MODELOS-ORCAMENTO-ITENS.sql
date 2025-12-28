-- ============================================================
-- POPULAR CATEGORIAS E ITENS DOS MODELOS DE ORCAMENTO
-- Data: 2024-12-27
-- Itens base para cada modelo (vinculaveis ao Pricelist)
-- ============================================================

-- ============================================================
-- 1. REFORMA COMPLETA
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat_demolicao UUID;
  v_cat_alvenaria UUID;
  v_cat_eletrica UUID;
  v_cat_hidraulica UUID;
  v_cat_acabamentos UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'REFORMA-COMPLETA';

  -- Categorias
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Demolição', '#EF4444', 1) RETURNING id INTO v_cat_demolicao;

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Alvenaria', '#F59E0B', 2) RETURNING id INTO v_cat_alvenaria;

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Elétrica', '#3B82F6', 3) RETURNING id INTO v_cat_eletrica;

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Hidráulica', '#06B6D4', 4) RETURNING id INTO v_cat_hidraulica;

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Acabamentos', '#10B981', 5) RETURNING id INTO v_cat_acabamentos;

  -- Itens Demolição
  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat_demolicao, 'Demolição de alvenaria com retirada de entulho', 'm²', 'servico', 1),
  (v_modelo_id, v_cat_demolicao, 'Remoção de revestimento cerâmico', 'm²', 'servico', 2),
  (v_modelo_id, v_cat_demolicao, 'Remoção de piso existente', 'm²', 'servico', 3),
  (v_modelo_id, v_cat_demolicao, 'Caçamba de entulho 5m³', 'un', 'servico', 4);

  -- Itens Alvenaria
  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat_alvenaria, 'Execução de alvenaria bloco 14cm', 'm²', 'servico', 1),
  (v_modelo_id, v_cat_alvenaria, 'Execução de alvenaria bloco 9cm', 'm²', 'servico', 2),
  (v_modelo_id, v_cat_alvenaria, 'Chapisco para reboco', 'm²', 'servico', 3),
  (v_modelo_id, v_cat_alvenaria, 'Reboco interno', 'm²', 'servico', 4),
  (v_modelo_id, v_cat_alvenaria, 'Contrapiso regularização', 'm²', 'servico', 5);

  -- Itens Elétrica
  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat_eletrica, 'Ponto de tomada 2P+T', 'un', 'servico', 1),
  (v_modelo_id, v_cat_eletrica, 'Ponto de iluminação', 'un', 'servico', 2),
  (v_modelo_id, v_cat_eletrica, 'Ponto de interruptor simples', 'un', 'servico', 3),
  (v_modelo_id, v_cat_eletrica, 'Quadro de distribuição 12 disjuntores', 'un', 'material', 4),
  (v_modelo_id, v_cat_eletrica, 'Eletroduto corrugado 25mm', 'ml', 'material', 5);

  -- Itens Hidráulica
  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat_hidraulica, 'Ponto de água fria', 'un', 'servico', 1),
  (v_modelo_id, v_cat_hidraulica, 'Ponto de água quente', 'un', 'servico', 2),
  (v_modelo_id, v_cat_hidraulica, 'Ponto de esgoto 100mm', 'un', 'servico', 3),
  (v_modelo_id, v_cat_hidraulica, 'Ponto de esgoto 50mm', 'un', 'servico', 4),
  (v_modelo_id, v_cat_hidraulica, 'Instalação de registro de gaveta', 'un', 'servico', 5);

  -- Itens Acabamentos
  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat_acabamentos, 'Assentamento de piso cerâmico/porcelanato', 'm²', 'servico', 1),
  (v_modelo_id, v_cat_acabamentos, 'Assentamento de revestimento cerâmico parede', 'm²', 'servico', 2),
  (v_modelo_id, v_cat_acabamentos, 'Pintura látex PVA 2 demãos', 'm²', 'servico', 3),
  (v_modelo_id, v_cat_acabamentos, 'Instalação de rodapé', 'ml', 'servico', 4),
  (v_modelo_id, v_cat_acabamentos, 'Forro de gesso liso', 'm²', 'servico', 5);
END $$;

-- ============================================================
-- 2. PROJETO DE INTERIORES
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'PROJETO-INTERIORES';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto', '#8B5CF6', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Mobiliário', '#EC4899', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Iluminação', '#F59E0B', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Decoração', '#10B981', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Acompanhamento', '#6366F1', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Projeto de layout e circulação', 'm²', 'servico', 1),
  (v_modelo_id, v_cat1, 'Projeto 3D renderizado', 'un', 'servico', 2),
  (v_modelo_id, v_cat1, 'Detalhamento executivo', 'prancha', 'servico', 3),
  (v_modelo_id, v_cat2, 'Especificação de mobiliário', 'ambiente', 'servico', 1),
  (v_modelo_id, v_cat2, 'Cotação com fornecedores', 'un', 'servico', 2),
  (v_modelo_id, v_cat3, 'Projeto luminotécnico', 'ambiente', 'servico', 1),
  (v_modelo_id, v_cat3, 'Especificação de luminárias', 'un', 'servico', 2),
  (v_modelo_id, v_cat4, 'Curadoria de objetos decorativos', 'ambiente', 'servico', 1),
  (v_modelo_id, v_cat4, 'Personal shopper decoração', 'visita', 'servico', 2),
  (v_modelo_id, v_cat5, 'Visita técnica de acompanhamento', 'visita', 'servico', 1),
  (v_modelo_id, v_cat5, 'Reunião de alinhamento', 'un', 'servico', 2);
END $$;

-- ============================================================
-- 3. COZINHA PLANEJADA
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'COZINHA-PLANEJADA';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto', '#8B5E3C', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Armários', '#A16207', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Bancadas', '#64748B', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Eletrodomésticos', '#3B82F6', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Instalação', '#10B981', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Projeto de cozinha 3D', 'un', 'servico', 1),
  (v_modelo_id, v_cat1, 'Medição técnica in loco', 'un', 'servico', 2),
  (v_modelo_id, v_cat2, 'Armário superior MDF 18mm', 'ml', 'produto', 1),
  (v_modelo_id, v_cat2, 'Armário inferior MDF 18mm', 'ml', 'produto', 2),
  (v_modelo_id, v_cat2, 'Torre para forno/micro', 'un', 'produto', 3),
  (v_modelo_id, v_cat2, 'Gaveteiro com corrediça telescópica', 'un', 'produto', 4),
  (v_modelo_id, v_cat3, 'Bancada granito preto são gabriel', 'ml', 'material', 1),
  (v_modelo_id, v_cat3, 'Bancada quartzo branco', 'ml', 'material', 2),
  (v_modelo_id, v_cat3, 'Cuba inox de sobrepor', 'un', 'produto', 3),
  (v_modelo_id, v_cat4, 'Cooktop 5 bocas', 'un', 'produto', 1),
  (v_modelo_id, v_cat4, 'Forno elétrico embutir', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Coifa de ilha', 'un', 'produto', 3),
  (v_modelo_id, v_cat5, 'Montagem completa', 'vb', 'servico', 1),
  (v_modelo_id, v_cat5, 'Instalação de eletros', 'un', 'servico', 2);
END $$;

-- ============================================================
-- 4. REFORMA DE BANHEIRO
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'BANHEIRO-REFORMA';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Demolição', '#EF4444', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Hidráulica', '#06B6D4', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Revestimentos', '#8B5CF6', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Louças e Metais', '#F59E0B', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Marcenaria', '#8B5E3C', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Remoção de revestimento existente', 'm²', 'servico', 1),
  (v_modelo_id, v_cat1, 'Remoção de louças sanitárias', 'un', 'servico', 2),
  (v_modelo_id, v_cat1, 'Caçamba de entulho', 'un', 'servico', 3),
  (v_modelo_id, v_cat2, 'Ponto de água fria', 'un', 'servico', 1),
  (v_modelo_id, v_cat2, 'Ponto de água quente', 'un', 'servico', 2),
  (v_modelo_id, v_cat2, 'Ponto de esgoto', 'un', 'servico', 3),
  (v_modelo_id, v_cat2, 'Impermeabilização box', 'm²', 'servico', 4),
  (v_modelo_id, v_cat3, 'Piso porcelanato 60x60', 'm²', 'material', 1),
  (v_modelo_id, v_cat3, 'Revestimento parede porcelanato', 'm²', 'material', 2),
  (v_modelo_id, v_cat3, 'Mão de obra assentamento', 'm²', 'servico', 3),
  (v_modelo_id, v_cat4, 'Vaso sanitário com caixa acoplada', 'un', 'produto', 1),
  (v_modelo_id, v_cat4, 'Cuba de apoio', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Torneira monocomando', 'un', 'produto', 3),
  (v_modelo_id, v_cat4, 'Chuveiro de teto', 'un', 'produto', 4),
  (v_modelo_id, v_cat5, 'Gabinete sob medida', 'un', 'produto', 1),
  (v_modelo_id, v_cat5, 'Espelheira com LED', 'un', 'produto', 2);
END $$;

-- ============================================================
-- 5. CLOSET PLANEJADO
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'CLOSET-PLANEJADO';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto', '#8B5CF6', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Estrutura', '#8B5E3C', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Portas', '#64748B', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Acessórios', '#F59E0B', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Iluminação', '#3B82F6', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Projeto de closet 3D', 'un', 'servico', 1),
  (v_modelo_id, v_cat1, 'Medição técnica', 'un', 'servico', 2),
  (v_modelo_id, v_cat2, 'Módulo com prateleiras MDF', 'ml', 'produto', 1),
  (v_modelo_id, v_cat2, 'Módulo com cabideiro', 'ml', 'produto', 2),
  (v_modelo_id, v_cat2, 'Maleiro superior', 'ml', 'produto', 3),
  (v_modelo_id, v_cat3, 'Porta de correr com espelho', 'un', 'produto', 1),
  (v_modelo_id, v_cat3, 'Porta de abrir com puxador', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Gaveteiro interno', 'un', 'produto', 1),
  (v_modelo_id, v_cat4, 'Calceiro/sapateiro', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Cabideiro retrátil', 'un', 'produto', 3),
  (v_modelo_id, v_cat5, 'Fita LED com sensor', 'ml', 'material', 1),
  (v_modelo_id, v_cat5, 'Instalação elétrica', 'vb', 'servico', 2);
END $$;

-- ============================================================
-- 6. AREA GOURMET
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'AREA-GOURMET';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto', '#5E9B94', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Churrasqueira', '#EF4444', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Marcenaria', '#8B5E3C', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Bancadas', '#64748B', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Paisagismo', '#10B981', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Projeto arquitetônico completo', 'm²', 'servico', 1),
  (v_modelo_id, v_cat1, 'Projeto 3D renderizado', 'un', 'servico', 2),
  (v_modelo_id, v_cat2, 'Churrasqueira pré-moldada', 'un', 'produto', 1),
  (v_modelo_id, v_cat2, 'Coifa para churrasqueira', 'un', 'produto', 2),
  (v_modelo_id, v_cat2, 'Instalação de gás', 'vb', 'servico', 3),
  (v_modelo_id, v_cat3, 'Armários em MDF', 'ml', 'produto', 1),
  (v_modelo_id, v_cat3, 'Balcão com cooktop', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Bancada em granito', 'ml', 'material', 1),
  (v_modelo_id, v_cat4, 'Cuba inox dupla', 'un', 'produto', 2),
  (v_modelo_id, v_cat5, 'Projeto paisagístico', 'm²', 'servico', 1),
  (v_modelo_id, v_cat5, 'Execução de jardim', 'm²', 'servico', 2);
END $$;

-- ============================================================
-- 7. PROJETO ARQUITETONICO
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'PROJETO-ARQUITETONICO';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Estudo Preliminar', '#8B5CF6', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Anteprojeto', '#3B82F6', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto Executivo', '#10B981', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Detalhamento', '#F59E0B', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Acompanhamento', '#6366F1', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Levantamento arquitetônico', 'm²', 'servico', 1),
  (v_modelo_id, v_cat1, 'Estudo de viabilidade', 'un', 'servico', 2),
  (v_modelo_id, v_cat1, 'Programa de necessidades', 'un', 'servico', 3),
  (v_modelo_id, v_cat2, 'Planta de layout', 'prancha', 'servico', 1),
  (v_modelo_id, v_cat2, 'Fachadas e cortes', 'prancha', 'servico', 2),
  (v_modelo_id, v_cat2, 'Maquete 3D', 'un', 'servico', 3),
  (v_modelo_id, v_cat3, 'Projeto executivo completo', 'm²', 'servico', 1),
  (v_modelo_id, v_cat3, 'Memorial descritivo', 'un', 'servico', 2),
  (v_modelo_id, v_cat4, 'Detalhamento construtivo', 'prancha', 'servico', 1),
  (v_modelo_id, v_cat4, 'Quantitativo de materiais', 'un', 'servico', 2),
  (v_modelo_id, v_cat5, 'Visita técnica de obra', 'visita', 'servico', 1),
  (v_modelo_id, v_cat5, 'Reunião de alinhamento', 'un', 'servico', 2);
END $$;

-- ============================================================
-- 8. CONSTRUCAO CIVIL
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID; v_cat6 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'CONSTRUCAO-CIVIL';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Fundação', '#64748B', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Estrutura', '#2B4580', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Alvenaria', '#F59E0B', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Cobertura', '#8B5E3C', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Instalações', '#3B82F6', 5) RETURNING id INTO v_cat5;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Acabamentos', '#10B981', 6) RETURNING id INTO v_cat6;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Escavação manual', 'm³', 'servico', 1),
  (v_modelo_id, v_cat1, 'Sapata de concreto armado', 'm³', 'servico', 2),
  (v_modelo_id, v_cat1, 'Radier de concreto', 'm²', 'servico', 3),
  (v_modelo_id, v_cat2, 'Pilar de concreto armado', 'm³', 'servico', 1),
  (v_modelo_id, v_cat2, 'Viga de concreto armado', 'm³', 'servico', 2),
  (v_modelo_id, v_cat2, 'Laje pré-moldada', 'm²', 'servico', 3),
  (v_modelo_id, v_cat3, 'Alvenaria de vedação', 'm²', 'servico', 1),
  (v_modelo_id, v_cat3, 'Reboco interno', 'm²', 'servico', 2),
  (v_modelo_id, v_cat3, 'Reboco externo', 'm²', 'servico', 3),
  (v_modelo_id, v_cat4, 'Estrutura de madeira', 'm²', 'material', 1),
  (v_modelo_id, v_cat4, 'Telha cerâmica', 'm²', 'material', 2),
  (v_modelo_id, v_cat4, 'Calha e rufos', 'ml', 'material', 3),
  (v_modelo_id, v_cat5, 'Instalação elétrica completa', 'm²', 'servico', 1),
  (v_modelo_id, v_cat5, 'Instalação hidráulica completa', 'm²', 'servico', 2),
  (v_modelo_id, v_cat6, 'Piso cerâmico', 'm²', 'material', 1),
  (v_modelo_id, v_cat6, 'Pintura interna', 'm²', 'servico', 2),
  (v_modelo_id, v_cat6, 'Pintura externa', 'm²', 'servico', 3);
END $$;

-- ============================================================
-- 9. MOBILIARIO CORPORATIVO
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'MOBILIARIO-CORPORATIVO';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto', '#8B5CF6', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Mesas', '#3B82F6', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Armários', '#8B5E3C', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Recepção', '#F59E0B', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Sala de Reunião', '#10B981', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Projeto de layout corporativo', 'm²', 'servico', 1),
  (v_modelo_id, v_cat1, 'Projeto 3D renderizado', 'un', 'servico', 2),
  (v_modelo_id, v_cat2, 'Estação de trabalho individual', 'un', 'produto', 1),
  (v_modelo_id, v_cat2, 'Estação de trabalho dupla', 'un', 'produto', 2),
  (v_modelo_id, v_cat2, 'Mesa de gerência', 'un', 'produto', 3),
  (v_modelo_id, v_cat3, 'Armário baixo com portas', 'un', 'produto', 1),
  (v_modelo_id, v_cat3, 'Arquivo de aço 4 gavetas', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Balcão de recepção', 'un', 'produto', 1),
  (v_modelo_id, v_cat4, 'Sofá de espera', 'un', 'produto', 2),
  (v_modelo_id, v_cat5, 'Mesa de reunião 8 lugares', 'un', 'produto', 1),
  (v_modelo_id, v_cat5, 'Cadeira de reunião', 'un', 'produto', 2);
END $$;

-- ============================================================
-- 10. SALA PLANEJADA
-- ============================================================
DO $$
DECLARE
  v_modelo_id UUID;
  v_cat1 UUID; v_cat2 UUID; v_cat3 UUID; v_cat4 UUID; v_cat5 UUID;
BEGIN
  SELECT id INTO v_modelo_id FROM modelos_orcamento WHERE codigo = 'SALA-PLANEJADA';

  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Projeto', '#8B5CF6', 1) RETURNING id INTO v_cat1;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Painel TV', '#3B82F6', 2) RETURNING id INTO v_cat2;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Estantes', '#8B5E3C', 3) RETURNING id INTO v_cat3;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Aparador', '#F59E0B', 4) RETURNING id INTO v_cat4;
  INSERT INTO modelos_orcamento_categorias (modelo_id, nome, cor, ordem)
  VALUES (v_modelo_id, 'Home Theater', '#10B981', 5) RETURNING id INTO v_cat5;

  INSERT INTO modelos_orcamento_itens (modelo_id, categoria_id, descricao, unidade, tipo_item, ordem) VALUES
  (v_modelo_id, v_cat1, 'Projeto de sala 3D', 'un', 'servico', 1),
  (v_modelo_id, v_cat1, 'Medição técnica', 'un', 'servico', 2),
  (v_modelo_id, v_cat2, 'Painel para TV até 65"', 'un', 'produto', 1),
  (v_modelo_id, v_cat2, 'Painel com nichos laterais', 'un', 'produto', 2),
  (v_modelo_id, v_cat2, 'Suporte articulado para TV', 'un', 'produto', 3),
  (v_modelo_id, v_cat3, 'Estante modular', 'ml', 'produto', 1),
  (v_modelo_id, v_cat3, 'Prateleiras decorativas', 'un', 'produto', 2),
  (v_modelo_id, v_cat4, 'Aparador suspenso', 'un', 'produto', 1),
  (v_modelo_id, v_cat4, 'Buffet com portas', 'un', 'produto', 2),
  (v_modelo_id, v_cat5, 'Rack home theater', 'un', 'produto', 1),
  (v_modelo_id, v_cat5, 'Instalação de equipamentos', 'vb', 'servico', 2);
END $$;

-- ============================================================
-- VERIFICACAO FINAL
-- ============================================================
SELECT 'modelos_orcamento' as tabela, COUNT(*) as registros FROM modelos_orcamento
UNION ALL
SELECT 'modelos_orcamento_categorias', COUNT(*) FROM modelos_orcamento_categorias
UNION ALL
SELECT 'modelos_orcamento_itens', COUNT(*) FROM modelos_orcamento_itens;
