-- ============================================================
-- ITENS ESSENCIAIS PARA INÍCIO DE OBRA
-- Sistema WG Easy - Grupo WG Almeida
-- Baseado em estruturaparamodelodelistadecomprademateriais.xlsx
-- ============================================================

-- Função helper para criar item se não existir
CREATE OR REPLACE FUNCTION criar_item_pricelist_se_nao_existir(
  p_codigo VARCHAR,
  p_nome VARCHAR,
  p_descricao TEXT,
  p_tipo VARCHAR,
  p_unidade VARCHAR,
  p_preco NUMERIC,
  p_categoria_nome VARCHAR
) RETURNS VOID AS $$
DECLARE
  v_categoria_id UUID;
BEGIN
  -- Buscar ou criar categoria
  SELECT id INTO v_categoria_id FROM pricelist_categorias WHERE nome = p_categoria_nome LIMIT 1;
  IF v_categoria_id IS NULL THEN
    INSERT INTO pricelist_categorias (nome, tipo, ativo) VALUES (p_categoria_nome, p_tipo, true)
    RETURNING id INTO v_categoria_id;
  END IF;

  -- Criar item se não existir
  INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, categoria_id, ativo)
  VALUES (p_codigo, p_nome, p_descricao, p_tipo, p_unidade, p_preco, v_categoria_id, true)
  ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    preco = EXCLUDED.preco,
    updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- PRÉ OBRA
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('PRE-001', 'Protetor de Quina 1,20mx5cm Salva Quina', 'Proteção de quinas durante obra', 'material', 'un', 12.29, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-002', 'Protetor de Ralo e Tubulações 10cm Salva Ralo', 'Proteção de ralos e tubulações', 'material', 'un', 3.89, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-003', 'Protetor de Piso 25x1m Salva Piso', 'Proteção de pisos durante obra', 'material', 'un', 189.90, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-004', 'Proteção de Pisos e Bancadas Papelão Reforçado 1,2x25m 300g', 'Papelão reforçado para proteção', 'material', 'un', 95.90, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-005', 'Bobina Papel Ondulado com 50 metros', 'Papel para proteção geral', 'material', 'un', 179.90, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-006', 'Saco alvejado de pano', 'Pano para limpeza', 'material', 'un', 10.99, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-007', 'Fita Crepe Branca 48mm x 50m', 'Fita para proteção', 'material', 'un', 13.95, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-008', 'Fita Crepe Branca 24mm x 50m', 'Fita para proteção', 'material', 'un', 8.50, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-009', 'Vassoura Original Noviça Concept Bettanin', 'Vassoura para limpeza de obra', 'material', 'un', 24.90, 'Pré Obra');
SELECT criar_item_pricelist_se_nao_existir('PRE-010', 'Lona Plástica 4x50m Preta', 'Lona para proteção', 'material', 'un', 164.90, 'Pré Obra');

-- ============================================================
-- MATERIAL CINZA
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('CIN-001', 'Argamassa Polimérica Impermeabilizante Viaplus 5000 Fibras 18kg', 'Impermeabilizante viapol', 'material', 'un', 169.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-002', 'Argamassa Polimérica Impermeabilizante Viaplus 7000 Fibras 18kg', 'Impermeabilizante viapol premium', 'material', 'un', 219.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-003', 'Aditivo para Chapisco Bianco 18kg Branco Vedacit', 'Aditivo para chapisco', 'material', 'un', 259.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-004', 'Areia fina/média saco 20 Kg', 'Areia para construção', 'material', 'sc', 4.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-005', 'Pedra Britada 1 Saco de 20kg', 'Pedra britada', 'material', 'sc', 4.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-006', 'Cimento CP II F 32 Todas as Obras 50kg Votoran', 'Cimento portland', 'material', 'sc', 31.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-007', 'Gesso em Pó - 40kg', 'Gesso para acabamento', 'material', 'sc', 43.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-008', 'Argila Expandida - 50 Litros', 'Argila para enchimento leve', 'material', 'sc', 37.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-009', 'Chapa de Madeira Compensado Resinado 9mm', 'Compensado para proteção', 'material', 'un', 114.90, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-010', 'Caixa De Luz Quadrada 4x4', 'Caixa de luz 4x4', 'material', 'un', 6.89, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-011', 'Caixa De Luz Quadrada 4x2', 'Caixa de luz 4x2', 'material', 'un', 2.49, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-012', 'Caixa De Luz Quadrada 4x2 Drywall', 'Caixa de luz para drywall', 'material', 'un', 3.49, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-013', 'Tijolo Comum de Barro 4,3x9,1x18cm 10 Unidades', 'Tijolo comum', 'material', 'pct', 0.89, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-014', 'Bloco Cerâmico Vedação 11,5x14x24cm', 'Bloco cerâmico para vedação', 'material', 'un', 1.69, 'Material Cinza');
SELECT criar_item_pricelist_se_nao_existir('CIN-015', 'Sacos para Entulho', 'Saco para entulho de obra', 'material', 'un', 4.50, 'Material Cinza');

-- ============================================================
-- HIDRÁULICA
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('HID-001', 'Cano Marrom PVC Soldável 25mm ou 3/4" 3m', 'Tubo PVC água fria', 'material', 'un', 15.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-002', 'Joelho 45° Marrom PVC Soldável 25mm ou 3/4"', 'Joelho 45 graus', 'material', 'un', 2.19, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-003', 'Joelho 90° Marrom PVC Soldável 25mm ou 3/4"', 'Joelho 90 graus', 'material', 'un', 1.09, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-004', 'Joelho 90° com Bucha PVC Azul Roscável e Soldável 3/4x1/2"', 'Joelho de transição', 'material', 'un', 4.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-005', 'Plug PVC Branco Roscável 1/2" 20mm', 'Plug para fechar tubulação', 'material', 'un', 0.78, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-006', 'Plug PVC Branco Roscável 3/4" 25mm', 'Plug para fechar tubulação', 'material', 'un', 1.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-007', 'Cano PVC para Esgoto 40mm ou 1.1/4" 3m Tigre', 'Tubo PVC esgoto', 'material', 'un', 21.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-008', 'Joelho 45° Branco PVC Soldável 40mm', 'Joelho esgoto 45', 'material', 'un', 2.00, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-009', 'Joelho 90° Branco PVC Soldável 40mm', 'Joelho esgoto 90', 'material', 'un', 3.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-010', 'Cano PVC para Esgoto 100mm ou 4" 3m Tigre', 'Tubo PVC esgoto 100mm', 'material', 'un', 47.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-011', 'Joelho 90° Branco PVC Soldável 100mm', 'Joelho esgoto 100mm', 'material', 'un', 14.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-012', 'Mangueira Flexível 60cm 1/2 Polegada Aço Inox', 'Engate flexível para torneira', 'material', 'un', 16.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-013', 'Fita Veda Rosca 18mmx25m Tigre', 'Fita veda rosca', 'material', 'un', 4.95, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-014', 'Cola para PVC Incolor Frasco 175g Tigre', 'Cola PVC', 'material', 'un', 22.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-015', 'Cano CPVC para Água Quente 22mm ou 3/4" 3m', 'Tubo CPVC água quente', 'material', 'un', 63.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-016', 'Joelho 90° CPVC Liso 22mm ou 3/4"', 'Joelho CPVC', 'material', 'un', 3.99, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-017', 'Joelho de Transição CPVC Roscável 22mm x 1/2"', 'Joelho transição CPVC', 'material', 'un', 11.53, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-018', 'Tê 90° CPVC Liso 22mm', 'Tê CPVC', 'material', 'un', 5.05, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-019', 'Torneira Registro Esfera Maquina Tanque 1/4 De Volta', 'Registro esfera', 'material', 'un', 34.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-020', 'Cola para CPVC Frasco 175g Aquatherm Tigre', 'Cola CPVC', 'material', 'un', 53.90, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-021', 'Abraçadeira 3/4" Cinza', 'Abraçadeira tubo', 'material', 'un', 1.29, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-022', 'Abraçadeira 1/2" Cinza', 'Abraçadeira tubo', 'material', 'un', 11.79, 'Hidráulica');
SELECT criar_item_pricelist_se_nao_existir('HID-023', 'Abracadeira Pvc Branco Pro 1"', 'Abraçadeira tubo 1"', 'material', 'un', 0.72, 'Hidráulica');

-- ============================================================
-- GÁS
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('GAS-001', 'Tubo Pex 20mm Para Gás 10 Metros Amanco', 'Tubo PEX para gás', 'material', 'm', 12.53, 'Gás');
SELECT criar_item_pricelist_se_nao_existir('GAS-002', 'Cotovelo 20mm x 20mm Para Tubo Pex 20mm De Gás', 'Cotovelo PEX gás', 'material', 'un', 31.01, 'Gás');
SELECT criar_item_pricelist_se_nao_existir('GAS-003', 'União Metálica 16 Pex Gás Amanco', 'União PEX gás', 'material', 'un', 29.05, 'Gás');
SELECT criar_item_pricelist_se_nao_existir('GAS-004', 'Cotovelo Multicamadas Pex Gás 16mm X 1/2"', 'Cotovelo transição gás', 'material', 'un', 31.80, 'Gás');
SELECT criar_item_pricelist_se_nao_existir('GAS-005', 'Cotovelo Multicamadas Pex Gás 16mm X 1/2" Com Suporte', 'Cotovelo com suporte gás', 'material', 'un', 45.30, 'Gás');
SELECT criar_item_pricelist_se_nao_existir('GAS-006', 'Tee Metálico 16 Pex Gás Amanco', 'Tê PEX gás', 'material', 'un', 38.15, 'Gás');

-- ============================================================
-- ELÉTRICA
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('ELE-001', 'Conduíte Corrugado 3/4" 50 Metros', 'Eletroduto corrugado', 'material', 'rl', 88.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-002', 'Conduíte Corrugado 1" 25 Metros', 'Eletroduto corrugado maior', 'material', 'rl', 81.75, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-003', 'Parafuso Phillips Cabeça Chata Com Bucha De Nylon 08mm 250 peças', 'Parafusos com bucha', 'material', 'cx', 47.34, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-004', 'Abraçadeira D com Cunha 3/4" Aço Zincado', 'Abraçadeira para eletroduto', 'material', 'un', 1.60, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-005', 'Abraçadeira D com Cunha 1/2" Aço Zincado', 'Abraçadeira para eletroduto', 'material', 'un', 1.30, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-006', 'Fita Isolante Antichama 20 Metros Preto 3M', 'Fita isolante', 'material', 'un', 39.99, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-007', 'Cabo Flexível 1,5mm 50 Metros Amarelo - Iluminação', 'Fio iluminação retorno', 'material', 'rl', 139.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-008', 'Cabo Flexível 1,5mm 50 Metros Branco - Iluminação', 'Fio iluminação fase', 'material', 'rl', 139.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-009', 'Cabo Flexível 1,5mm 50 Metros Cinza - Iluminação', 'Fio iluminação', 'material', 'rl', 209.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-010', 'Cabo Flexível 2,5mm 100 Metros Azul - Neutro', 'Fio neutro tomadas', 'material', 'rl', 209.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-011', 'Cabo Flexível 2,5mm 100 Metros Verde - Terra', 'Fio terra', 'material', 'rl', 209.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-012', 'Cabo Flexível 2,5mm 100 Metros Vermelho - Tomadas', 'Fio fase tomadas', 'material', 'rl', 209.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-013', 'Cabo Flexível 2,5mm 100 Metros Cinza - Tomadas', 'Fio retorno tomadas', 'material', 'rl', 209.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-014', 'Cabo Flexível 4mm 100 Metros Preto - Circuitos', 'Fio circuitos especiais', 'material', 'rl', 345.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-015', 'Cabo Flexível 4mm 100 Metros Vermelho - Circuitos', 'Fio circuitos especiais', 'material', 'rl', 345.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-016', 'Quadro De Distribuição 18/24 + Barramentos Embutir Tigre', 'QD 18/24 disjuntores', 'material', 'un', 383.00, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-017', 'Caixa de Distribuição de Embutir com Barramento 27/36 Disjuntores Tigre', 'QD 27/36 disjuntores', 'material', 'un', 669.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-018', 'Disjuntor DR Tripolar 63A/30MA Steck', 'Disjuntor DR proteção', 'material', 'un', 269.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-019', 'DPS Monopolar 45000A Front 275V Clamper', 'DPS proteção surto', 'material', 'un', 59.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-020', 'Disjuntor Din Monopolar Curva C 16A Steck', 'Disjuntor 16A', 'material', 'un', 11.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-021', 'Disjuntor Din Monopolar Curva A 20A Steck', 'Disjuntor 20A', 'material', 'un', 11.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-022', 'Disjuntor Din Monopolar Curva A 32A Steck', 'Disjuntor 32A', 'material', 'un', 11.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-023', 'Disjuntor Din Bipolar Curva A 16A Steck', 'Disjuntor bipolar 16A', 'material', 'un', 38.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-024', 'Disjuntor Din Bipolar Curva A 20A Steck', 'Disjuntor bipolar 20A', 'material', 'un', 38.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-025', 'Disjuntor Din Bipolar Curva C 25A Steck', 'Disjuntor bipolar 25A', 'material', 'un', 44.90, 'Elétrica');
SELECT criar_item_pricelist_se_nao_existir('ELE-026', 'Disjuntor Din Bipolar Curva A 32A Steck', 'Disjuntor bipolar 32A', 'material', 'un', 44.90, 'Elétrica');

-- ============================================================
-- ACABAMENTOS ELÉTRICOS (PIAL PLUS)
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('PIE-001', 'Suporte para Placa 4x2 Horizontal Plus Pial Legrand', 'Suporte 4x2 horizontal', 'material', 'un', 4.19, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-002', 'Suporte para Placa 4x2 Vertical Pial Plus Legrand', 'Suporte 4x2 vertical', 'material', 'un', 5.59, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-003', 'Suporte para Placa 4x4 Pial Plus Legrand', 'Suporte 4x4', 'material', 'un', 8.39, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-004', 'Placa sem Suporte 4x2 Horizontal 1 Módulo Branco Pial Plus', 'Placa 1 módulo', 'material', 'un', 11.29, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-005', 'Placa sem Suporte 4x2 2 Módulos Branco Pial Plus', 'Placa 2 módulos', 'material', 'un', 11.29, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-006', 'Placa sem Suporte 4x2 3 Módulos Branco Pial Plus', 'Placa 3 módulos', 'material', 'un', 11.29, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-007', 'Placa Cega 4x2 Branco Pial Plus', 'Placa cega 4x2', 'material', 'un', 11.29, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-008', 'Placa sem Suporte 4x4 2 Módulos Branco Pial Plus', 'Placa 4x4 2 módulos', 'material', 'un', 32.90, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-009', 'Placa 4 Módulos + Suporte 4x4 Pial Plus', 'Placa 4x4 4 módulos', 'material', 'un', 28.14, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-010', 'Placa 6 Módulos 4x4 Pial Plus', 'Placa 4x4 6 módulos', 'material', 'un', 22.46, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-011', 'Módulo de Interruptor Simples 10A Pial Plus', 'Interruptor simples', 'material', 'un', 19.99, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-012', 'Módulo de Interruptor Paralelo 10A Pial Plus', 'Interruptor paralelo', 'material', 'un', 29.90, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-013', 'Módulo de Interruptor Intermediário 10A Pial Plus', 'Interruptor intermediário', 'material', 'un', 99.90, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-014', 'Módulo de Tomada de Energia 10A Pial Plus', 'Tomada 10A', 'material', 'un', 21.90, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-015', 'Módulo de Tomada de Energia 20A Pial Plus', 'Tomada 20A', 'material', 'un', 21.90, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-016', 'Módulo de Tomada de Energia 20A Vermelho Pial Plus', 'Tomada 20A 220V', 'material', 'un', 21.90, 'Acabamentos Elétricos');
SELECT criar_item_pricelist_se_nao_existir('PIE-017', 'Módulo Dimmer Bivolt Branco Pial Plus', 'Dimmer bivolt', 'material', 'un', 110.83, 'Acabamentos Elétricos');

-- ============================================================
-- PISOS E PAREDES
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('REV-001', 'Cunha Para Azulejo - C/ 100 Peças Niveladora para Piso', 'Cunha niveladora', 'material', 'pct', 15.83, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-002', 'Espaçador Nivelador 1,0mm Smart Cortag Pacote com 100 Unidades', 'Espaçador nivelador', 'material', 'pct', 28.90, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-003', 'Espaçador Plástico 1,0mm 100 peças Cruzeta', 'Espaçador cruzeta', 'material', 'pct', 4.61, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-004', 'Rejunte para Porcelanato Cinza Platina 5kg Quartzolit', 'Rejunte porcelanato', 'material', 'sc', 71.35, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-005', 'Rejunte Acrílico Bege 1 Kg Quartzolit', 'Rejunte acrílico', 'material', 'kg', 43.99, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-006', 'Rejunte Epóxi Cinza Claro 1 Kg Axton', 'Rejunte epóxi', 'material', 'kg', 59.10, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-007', 'Argamassa Porcelanato Interno 20kg Cinza Fortaleza', 'Argamassa porcelanato', 'material', 'sc', 26.23, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-008', 'Argamassa ACIII Interno e Externo 20kg Branco Quartzolit', 'Argamassa ACIII branca', 'material', 'sc', 62.90, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-009', 'Kit Com 10 Barras Rodapé Liso 10cmx1,5cmx220cm Mdf Branco', 'Rodapé MDF 10cm liso', 'material', 'kit', 244.20, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-010', 'Kit Com 10 Barras Rodapé De Mdf 15cm X 15mm X 2.20m Branco', 'Rodapé MDF 15cm', 'material', 'kit', 322.00, 'Pisos e Paredes');
SELECT criar_item_pricelist_se_nao_existir('REV-011', 'Cola para Rodapé Balde 5Kg Santa Luzia', 'Cola rodapé', 'material', 'un', 299.90, 'Pisos e Paredes');

-- ============================================================
-- PINTURA
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('PIN-001', 'Tinta Acrílica Toque Premium Fosco Branco Neve 20L Suvinil', 'Tinta acrílica premium', 'material', 'un', 599.90, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-002', 'Aguarrás 0,9L', 'Solvente aguarrás', 'material', 'un', 24.90, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-003', 'Massa Corrida 25Kg', 'Massa corrida', 'material', 'lt', 86.90, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-004', 'Selador Acrílico Suvinil 18L', 'Selador acrílico', 'material', 'un', 184.90, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-005', 'Thinner 900ml', 'Solvente thinner', 'material', 'un', 22.00, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-006', 'Lixa Massa - Grão 180', 'Lixa fina', 'material', 'un', 1.59, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-007', 'Lixa Massa - Grão 150', 'Lixa média', 'material', 'un', 1.59, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-008', 'Lixa para Madeira e Massa Grão 120', 'Lixa grossa', 'material', 'un', 1.79, 'Pintura');
SELECT criar_item_pricelist_se_nao_existir('PIN-009', 'Tinta Esmalte Sintético Base Solvente Branco Acetinado 3,6L Suvinil', 'Esmalte sintético', 'material', 'un', 179.90, 'Pintura');

-- ============================================================
-- INSUMOS / FERRAMENTAS
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('INS-001', 'Disco Diamantado para Makita Segmentado Para Concreto E Alvenaria', 'Disco diamantado', 'material', 'un', 72.38, 'Insumos');
SELECT criar_item_pricelist_se_nao_existir('INS-002', 'Disco de Lixa para Mármore Grão 50 100mm', 'Disco lixa mármore', 'material', 'un', 24.90, 'Insumos');
SELECT criar_item_pricelist_se_nao_existir('INS-003', 'Disco De Corte Fino De Ferro E Aço De Esmerilhadeira 10 Pçs', 'Disco de corte', 'material', 'pct', 48.00, 'Insumos');

-- ============================================================
-- AUTOMAÇÃO
-- ============================================================

SELECT criar_item_pricelist_se_nao_existir('AUT-001', 'Cabo De Rede Cat6 Cmx Cx 305m Azul Sohoplus', 'Cabo de rede cat6', 'material', 'cx', 1219.90, 'Automação');
SELECT criar_item_pricelist_se_nao_existir('AUT-002', 'Fio Som Cristal 2x12 -2,50 100m Alum Cobreado', 'Fio de som', 'material', 'rl', 277.38, 'Automação');

-- Limpar função temporária
DROP FUNCTION IF EXISTS criar_item_pricelist_se_nao_existir;

-- ============================================================
-- RESUMO
-- ============================================================

DO $$
DECLARE
  total_itens INT;
BEGIN
  SELECT COUNT(*) INTO total_itens FROM pricelist_itens WHERE codigo LIKE 'PRE-%' OR codigo LIKE 'CIN-%' OR codigo LIKE 'HID-%' OR codigo LIKE 'GAS-%' OR codigo LIKE 'ELE-%' OR codigo LIKE 'PIE-%' OR codigo LIKE 'REV-%' OR codigo LIKE 'PIN-%' OR codigo LIKE 'INS-%' OR codigo LIKE 'AUT-%';
  RAISE NOTICE '=== ITENS ESSENCIAIS DE OBRA ADICIONADOS: % itens ===', total_itens;
END $$;
