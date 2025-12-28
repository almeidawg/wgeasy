-- ============================================================
-- COMPOSIÇÕES COMPLETAS PARA ORÇAMENTO AUTOMÁTICO
-- WGeasy - Grupo WG Almeida
-- Data: 2024-12-28
-- ============================================================

-- ============================================================
-- ELÉTRICA - COMPOSIÇÕES ADICIONAIS
-- ============================================================

-- PONTO DE LUZ
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('ELE-LUZ', 'Ponto de Luz', 'Materiais para ponto de iluminação', 'ELETRICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CAIXAS', 'Caixa octogonal fundo movel', 'POR_UNIDADE', 1, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'ELE-LUZ' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'ELE-LUZ'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'FIOS', 'Fio 1,5mm', 'POR_UNIDADE', 5, 'm', 100, 100, TRUE, '5m por ponto | Rolo 100m', 2
FROM modelos_composicao WHERE codigo = 'ELE-LUZ';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'ELETRODUTOS', 'Eletroduto corrugado 20mm', 'POR_UNIDADE', 3, 'm', 50, 50, TRUE, '3m por ponto | Rolo 50m', 3
FROM modelos_composicao WHERE codigo = 'ELE-LUZ';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'FIXACAO', 'Abracadeira nylon', 'POR_UNIDADE', 2, 'un', TRUE, 4
FROM modelos_composicao WHERE codigo = 'ELE-LUZ';

-- PONTO DE INTERRUPTOR SIMPLES
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('ELE-INT-SIMPLES', 'Ponto de Interruptor Simples', 'Materiais para ponto de interruptor simples', 'ELETRICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'INTERRUPTORES', 'Interruptor simples', 'POR_UNIDADE', 1, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'ELE-INT-SIMPLES' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'ELE-INT-SIMPLES'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'PLACAS', 'Placa 4x2', 'POR_UNIDADE', 1, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'ELE-INT-SIMPLES';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CAIXAS', 'Caixa 4x2 PVC', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'ELE-INT-SIMPLES';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'FIOS', 'Fio 1,5mm', 'POR_UNIDADE', 8, 'm', 100, 100, TRUE, '8m por ponto (vai e volta)', 4
FROM modelos_composicao WHERE codigo = 'ELE-INT-SIMPLES';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'INSUMO', 'ELETRODUTOS', 'Eletroduto corrugado 20mm', 'POR_UNIDADE', 4, 'm', 50, 50, TRUE, 5
FROM modelos_composicao WHERE codigo = 'ELE-INT-SIMPLES';

-- PONTO DE INTERRUPTOR PARALELO (THREE-WAY)
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('ELE-INT-PARALELO', 'Ponto de Interruptor Paralelo', 'Materiais para interruptor three-way', 'ELETRICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'INTERRUPTORES', 'Interruptor paralelo (three-way)', 'POR_UNIDADE', 2, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'ELE-INT-PARALELO' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'ELE-INT-PARALELO'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'PLACAS', 'Placa 4x2', 'POR_UNIDADE', 2, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'ELE-INT-PARALELO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CAIXAS', 'Caixa 4x2 PVC', 'POR_UNIDADE', 2, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'ELE-INT-PARALELO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'FIOS', 'Fio 1,5mm', 'POR_UNIDADE', 15, 'm', 100, 100, TRUE, '15m por conjunto paralelo', 4
FROM modelos_composicao WHERE codigo = 'ELE-INT-PARALELO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'INSUMO', 'ELETRODUTOS', 'Eletroduto corrugado 20mm', 'POR_UNIDADE', 8, 'm', 50, 50, TRUE, 5
FROM modelos_composicao WHERE codigo = 'ELE-INT-PARALELO';

-- TOMADA 4x4 (220V / AR CONDICIONADO)
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('ELE-TOMADA-4X4', 'Ponto de Tomada 4x4 (220V)', 'Materiais para tomada de maior potencia', 'ELETRICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'TOMADAS', 'Tomada 2P+T 20A', 'POR_UNIDADE', 1, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA-4X4' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'ELE-TOMADA-4X4'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'PLACAS', 'Placa 4x4', 'POR_UNIDADE', 1, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA-4X4';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CAIXAS', 'Caixa 4x4 PVC', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA-4X4';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'FIOS', 'Fio 4,0mm', 'POR_UNIDADE', 8, 'm', 100, 100, TRUE, '8m por ponto | Rolo 100m', 4
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA-4X4';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'INSUMO', 'ELETRODUTOS', 'Eletroduto corrugado 25mm', 'POR_UNIDADE', 4, 'm', 50, 50, TRUE, 5
FROM modelos_composicao WHERE codigo = 'ELE-TOMADA-4X4';

-- ============================================================
-- HIDRÁULICA - COMPOSIÇÕES ADICIONAIS
-- ============================================================

-- PONTO DE ÁGUA QUENTE (PPR)
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('HID-AQ', 'Ponto de Agua Quente', 'Materiais para ponto de agua quente PPR', 'HIDRAULICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'TUBULACOES', 'Tubo PPR Aquatherm 25mm', 'POR_UNIDADE', 2, 'm', TRUE, '2m por ponto', 1
FROM modelos_composicao WHERE codigo = 'HID-AQ' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'HID-AQ'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Joelho 90 PPR 25mm', 'POR_UNIDADE', 2, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'HID-AQ';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Te PPR 25mm', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'HID-AQ';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'FIXACAO', 'Abracadeira PPR 25mm', 'POR_UNIDADE', 2, 'un', TRUE, 4
FROM modelos_composicao WHERE codigo = 'HID-AQ';

-- PONTO DE ESGOTO 50mm
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('HID-ESG-50', 'Ponto de Esgoto 50mm', 'Materiais para ponto de esgoto 50mm (pia, tanque)', 'HIDRAULICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'TUBULACOES', 'Tubo esgoto 50mm', 'POR_UNIDADE', 2, 'm', TRUE, 1
FROM modelos_composicao WHERE codigo = 'HID-ESG-50' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'HID-ESG-50'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Joelho 90 esgoto 50mm', 'POR_UNIDADE', 2, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'HID-ESG-50';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Juncao simples 50mm', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'HID-ESG-50';

-- PONTO DE ESGOTO 100mm
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('HID-ESG-100', 'Ponto de Esgoto 100mm', 'Materiais para ponto de esgoto 100mm (vaso sanitario)', 'HIDRAULICA', 'PONTOS', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'TUBULACOES', 'Tubo esgoto 100mm', 'POR_UNIDADE', 2, 'm', TRUE, 1
FROM modelos_composicao WHERE codigo = 'HID-ESG-100' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'HID-ESG-100'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Joelho 90 esgoto 100mm', 'POR_UNIDADE', 1, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'HID-ESG-100';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'CONEXOES', 'Curva 90 longa 100mm', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'HID-ESG-100';

-- INSTALAÇÃO DE BACIA SANITÁRIA
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('HID-INST-BACIA', 'Instalacao de Bacia Sanitaria', 'Materiais para instalacao de vaso sanitario', 'HIDRAULICA', 'INSTALACOES', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'INSTALACAO', 'Anel de vedacao para bacia', 'POR_UNIDADE', 1, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'HID-INST-BACIA' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'HID-INST-BACIA'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'INSTALACAO', 'Kit parafusos fixacao bacia', 'POR_UNIDADE', 1, 'kit', TRUE, 2
FROM modelos_composicao WHERE codigo = 'HID-INST-BACIA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'FLEXIVEIS', 'Flexivel para caixa acoplada 40cm', 'POR_UNIDADE', 1, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'HID-INST-BACIA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'VEDACAO', 'Silicone neutro', 'POR_UNIDADE', 0.1, 'tubo', TRUE, 4
FROM modelos_composicao WHERE codigo = 'HID-INST-BACIA';

-- INSTALAÇÃO DE CUBA
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('HID-INST-CUBA', 'Instalacao de Cuba', 'Materiais para instalacao de cuba', 'HIDRAULICA', 'INSTALACOES', 'un')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'SIFOES', 'Sifao sanfonado ou copo', 'POR_UNIDADE', 1, 'un', TRUE, 1
FROM modelos_composicao WHERE codigo = 'HID-INST-CUBA' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'HID-INST-CUBA'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'VALVULAS', 'Valvula de escoamento', 'POR_UNIDADE', 1, 'un', TRUE, 2
FROM modelos_composicao WHERE codigo = 'HID-INST-CUBA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'FLEXIVEIS', 'Flexivel 40cm', 'POR_UNIDADE', 2, 'un', TRUE, 3
FROM modelos_composicao WHERE codigo = 'HID-INST-CUBA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'VEDACAO', 'Fita veda-rosca 18mm', 'POR_UNIDADE', 2, 'm', TRUE, 4
FROM modelos_composicao WHERE codigo = 'HID-INST-CUBA';

-- ============================================================
-- REVESTIMENTOS - COMPOSIÇÕES ADICIONAIS
-- ============================================================

-- REVESTIMENTO PAREDE PORCELANATO
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('REV-PAREDE-PORC', 'Revestimento Parede Porcelanato', 'Assentamento de porcelanato em parede', 'REVESTIMENTOS', 'PAREDES', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'PORCELANATOS', 'Porcelanato parede', 'POR_AREA', 1.15, 'm2', TRUE, '15% de perda (mais recortes)', 1
FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'ARGAMASSAS', 'Argamassa ACIII branca 20kg', 'POR_AREA', 0.30, 'saco', 1, 1, TRUE, 'Parede usa mais argamassa', 2
FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'REJUNTES', 'Rejunte epoxi', 'POR_AREA', 0.35, 'kg', 1, 1, TRUE, 'Epoxi para areas molhadas', 3
FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'ESPASSADORES', 'Espassadores 1,5mm (pct 100un)', 'POR_AREA', 0.12, 'pct', 1, 1, TRUE, 4
FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'FERRAMENTA', 'FERRAMENTAS', 'Disco diamantado 110mm', 'POR_AREA', 0.03, 'un', 1, 1, FALSE, 'Mais cortes em parede', 5
FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'PERFIS', 'Perfil de acabamento aluminio', 'POR_PERIMETRO', 0.20, 'ml', FALSE, 'Cantos e arremates', 6
FROM modelos_composicao WHERE codigo = 'REV-PAREDE-PORC';

-- PISO LAMINADO
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('PISO-LAMINADO', 'Piso Laminado', 'Instalacao de piso laminado com manta', 'REVESTIMENTOS', 'PISOS', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'PISOS', 'Piso laminado', 'POR_AREA', 1.10, 'm2', TRUE, '10% de perda', 1
FROM modelos_composicao WHERE codigo = 'PISO-LAMINADO' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'PISO-LAMINADO'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'MANTAS', 'Manta para piso laminado', 'POR_AREA', 1.05, 'm2', TRUE, 2
FROM modelos_composicao WHERE codigo = 'PISO-LAMINADO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'RODAPES', 'Rodape MDF', 'POR_PERIMETRO', 1.10, 'ml', TRUE, '10% de perda', 3
FROM modelos_composicao WHERE codigo = 'PISO-LAMINADO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'FITAS', 'Fita de borda para manta', 'PROPORCIONAL', 0.10, 'rolo', 1, 1, TRUE, 4
FROM modelos_composicao WHERE codigo = 'PISO-LAMINADO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'PERFIS', 'Perfil de transicao', 'FIXO', 1, 'un', FALSE, 5
FROM modelos_composicao WHERE codigo = 'PISO-LAMINADO';

-- ============================================================
-- GESSO - COMPOSIÇÕES
-- ============================================================

-- FORRO DE GESSO
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('GESSO-FORRO', 'Forro de Gesso Liso', 'Forro de gesso liso ou acartonado', 'GESSO', 'FORROS', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'GESSO', 'Placa de gesso 60x60', 'POR_AREA', 1.10, 'm2', TRUE, '10% de perda', 1
FROM modelos_composicao WHERE codigo = 'GESSO-FORRO' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'GESSO-FORRO'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'ESTRUTURA', 'Perfil para forro (m)', 'POR_AREA', 3, 'm', TRUE, '3m por m2', 2
FROM modelos_composicao WHERE codigo = 'GESSO-FORRO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'FIXACAO', 'Arame galvanizado', 'POR_AREA', 0.5, 'm', TRUE, 3
FROM modelos_composicao WHERE codigo = 'GESSO-FORRO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'GESSO', 'Gesso cola 1kg', 'POR_AREA', 0.3, 'kg', 1, 1, TRUE, 4
FROM modelos_composicao WHERE codigo = 'GESSO-FORRO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'MASSAS', 'Massa para gesso', 'POR_AREA', 0.2, 'kg', 1, 1, TRUE, 5
FROM modelos_composicao WHERE codigo = 'GESSO-FORRO';

-- SANCA ABERTA (para LED)
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('GESSO-SANCA', 'Sanca Aberta para LED', 'Sanca aberta para iluminacao indireta', 'GESSO', 'SANCAS', 'ml')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, observacao, ordem)
SELECT id, 'INSUMO', 'GESSO', 'Placa de gesso para sanca', 'POR_PERIMETRO', 1.15, 'ml', TRUE, '15% de perda', 1
FROM modelos_composicao WHERE codigo = 'GESSO-SANCA' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'GESSO-SANCA'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'INSUMO', 'ESTRUTURA', 'Perfil para sanca (m)', 'POR_PERIMETRO', 2, 'm', TRUE, 2
FROM modelos_composicao WHERE codigo = 'GESSO-SANCA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'GESSO', 'Gesso cola 1kg', 'POR_PERIMETRO', 0.2, 'kg', 1, 1, TRUE, 3
FROM modelos_composicao WHERE codigo = 'GESSO-SANCA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'ILUMINACAO', 'Fita LED 5m', 'POR_PERIMETRO', 0.20, 'rolo', FALSE, 4
FROM modelos_composicao WHERE codigo = 'GESSO-SANCA';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'ACABAMENTO', 'ILUMINACAO', 'Fonte para LED 12V', 'FIXO', 1, 'un', FALSE, 5
FROM modelos_composicao WHERE codigo = 'GESSO-SANCA';

-- ============================================================
-- PINTURA - COMPOSIÇÕES ADICIONAIS
-- ============================================================

-- PINTURA DE TETO
INSERT INTO modelos_composicao (codigo, nome, descricao, disciplina, categoria, unidade_base)
VALUES ('PINT-TETO', 'Pintura de Teto', 'Pintura de teto com selador e 2 demaos', 'PINTURA', 'TETOS', 'm2')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'CONSUMIVEL', 'PREPARACAO', 'Selador acrilico', 'POR_AREA', 0.10, 'L', 3.6, 3.6, TRUE, '1L a cada 10m2', 1
FROM modelos_composicao WHERE codigo = 'PINT-TETO' AND NOT EXISTS (SELECT 1 FROM modelos_composicao_itens WHERE composicao_id = (SELECT id FROM modelos_composicao WHERE codigo = 'PINT-TETO'));

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, observacao, ordem)
SELECT id, 'ACABAMENTO', 'TINTAS', 'Tinta acrilica fosco', 'POR_AREA', 0.18, 'L', 18, 3.6, TRUE, 'Teto usa menos tinta', 2
FROM modelos_composicao WHERE codigo = 'PINT-TETO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, arredondar_para, minimo, obrigatorio, ordem)
SELECT id, 'FERRAMENTA', 'FERRAMENTAS', 'Rolo anti-gota 23cm', 'PROPORCIONAL', 0.01, 'un', 1, 1, TRUE, 3
FROM modelos_composicao WHERE codigo = 'PINT-TETO';

INSERT INTO modelos_composicao_itens (composicao_id, classificacao, categoria_material, descricao_generica, calculo_tipo, coeficiente, unidade, obrigatorio, ordem)
SELECT id, 'CONSUMIVEL', 'PROTECAO', 'Lona plastica', 'POR_AREA', 1, 'm2', TRUE, 4
FROM modelos_composicao WHERE codigo = 'PINT-TETO';

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
SELECT
  mc.codigo,
  mc.nome,
  mc.disciplina,
  mc.unidade_base,
  COUNT(mci.id) as total_itens
FROM modelos_composicao mc
LEFT JOIN modelos_composicao_itens mci ON mci.composicao_id = mc.id
GROUP BY mc.id, mc.codigo, mc.nome, mc.disciplina, mc.unidade_base
ORDER BY mc.disciplina, mc.codigo;
