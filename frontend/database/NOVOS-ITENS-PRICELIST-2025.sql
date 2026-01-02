-- ============================================================================
-- NOVOS ITENS PARA O PRICELIST - BASEADO EM AUDITORIA 2025
-- Sistema WG Easy - Grupo WG Almeida
-- Data: Dezembro 2025
-- ============================================================================
-- Execute este script APOS criar as categorias necessarias
-- ============================================================================

-- ============================================================================
-- 1. CRIAR NOVAS CATEGORIAS (se nao existirem)
-- ============================================================================

-- Categoria: Serralheria
INSERT INTO pricelist_categorias (codigo, nome, tipo, descricao, ordem, ativo)
SELECT 'SER', 'Serralheria', 'material', 'Grades, guarda-corpos, escadas metalicas, portoes', 20, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE codigo = 'SER');

-- Categoria: Impermeabilizacao
INSERT INTO pricelist_categorias (codigo, nome, tipo, descricao, ordem, ativo)
SELECT 'IMP', 'Impermeabilizacao', 'material', 'Mantas, impermeabilizantes, tratamentos', 21, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE codigo = 'IMP');

-- Categoria: Climatizacao
INSERT INTO pricelist_categorias (codigo, nome, tipo, descricao, ordem, ativo)
SELECT 'CLI', 'Climatizacao', 'material', 'Ar condicionado, ventilacao, exaustao', 22, true
WHERE NOT EXISTS (SELECT 1 FROM pricelist_categorias WHERE codigo = 'CLI');

-- ============================================================================
-- 2. NOVOS ITENS - SERRALHERIA (SER)
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('SER-001', 'Guarda-corpo inox escovado', 'Guarda-corpo em aco inox 304 escovado, altura 1,10m, com vidro laminado 8mm', 'material', 'm', 650.00, true),
('SER-002', 'Guarda-corpo inox polido', 'Guarda-corpo em aco inox 304 polido, altura 1,10m, com vidro laminado 8mm', 'material', 'm', 750.00, true),
('SER-003', 'Guarda-corpo aluminio', 'Guarda-corpo em aluminio anodizado, altura 1,10m, com vidro temperado 8mm', 'material', 'm', 450.00, true),
('SER-004', 'Corrimao inox 2"', 'Corrimao em tubo inox 304 diametro 2", fixacao lateral ou superior', 'material', 'm', 320.00, true),
('SER-005', 'Corrimao madeira c/ inox', 'Corrimao em madeira macica com suportes em inox', 'material', 'm', 280.00, true),
('SER-006', 'Escada metalica reta', 'Escada em estrutura metalica com degraus em madeira ou porcelanato', 'material', 'm2', 1200.00, true),
('SER-007', 'Escada metalica caracol', 'Escada caracol em estrutura metalica com degraus em madeira', 'material', 'un', 8500.00, true),
('SER-008', 'Portao automatico deslizante', 'Portao deslizante em aluminio com motor e controle remoto', 'material', 'un', 5500.00, true),
('SER-009', 'Portao automatico basculante', 'Portao basculante em aluminio com motor e controle remoto', 'material', 'un', 4500.00, true),
('SER-010', 'Grade de protecao janela', 'Grade em tubo metalico quadrado com pintura eletrostatica', 'material', 'm2', 280.00, true),
('SER-011', 'Pergolado metalico', 'Estrutura em metalon com pintura eletrostatica', 'material', 'm2', 350.00, true),
('SER-012', 'Cobertura metalica c/ telha', 'Estrutura metalica com telha termoacustica', 'material', 'm2', 280.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 3. NOVOS ITENS - IMPERMEABILIZACAO (IMP)
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('IMP-001', 'Manta asfaltica 3mm', 'Impermeabilizacao com manta asfaltica 3mm, inclui primer', 'material', 'm2', 95.00, true),
('IMP-002', 'Manta asfaltica 4mm', 'Impermeabilizacao com manta asfaltica 4mm aluminio, inclui primer', 'material', 'm2', 130.00, true),
('IMP-003', 'Impermeabilizante acrilico', 'Impermeabilizacao flexivel acrilica, 3 demaos', 'material', 'm2', 55.00, true),
('IMP-004', 'Impermeabilizante box', 'Impermeabilizacao de box banheiro com argamassa polimerica', 'material', 'm2', 85.00, true),
('IMP-005', 'Impermeabilizacao laje', 'Sistema completo laje exposta: regularizacao + manta + protecao', 'material', 'm2', 180.00, true),
('IMP-006', 'Impermeabilizacao viga baldrame', 'Impermeabilizacao de fundacao com emulsao asfaltica', 'material', 'm2', 45.00, true),
('IMP-007', 'Tratamento trinca/fissura', 'Tratamento de trincas e fissuras em laje/parede', 'material', 'm', 35.00, true),
('IMP-008', 'Impermeabilizacao piscina', 'Sistema completo para piscina com manta liquida', 'material', 'm2', 120.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 4. NOVOS ITENS - CLIMATIZACAO (CLI)
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('CLI-001', 'Ar condicionado split 9.000 BTU', 'Fornecimento e instalacao completa, inclui infra 3m', 'material', 'un', 2800.00, true),
('CLI-002', 'Ar condicionado split 12.000 BTU', 'Fornecimento e instalacao completa, inclui infra 3m', 'material', 'un', 3200.00, true),
('CLI-003', 'Ar condicionado split 18.000 BTU', 'Fornecimento e instalacao completa, inclui infra 3m', 'material', 'un', 4500.00, true),
('CLI-004', 'Ar condicionado split 24.000 BTU', 'Fornecimento e instalacao completa, inclui infra 3m', 'material', 'un', 5800.00, true),
('CLI-005', 'Ar condicionado cassete 24.000 BTU', 'Fornecimento e instalacao completa de cassete', 'material', 'un', 8500.00, true),
('CLI-006', 'Ar condicionado cassete 36.000 BTU', 'Fornecimento e instalacao completa de cassete', 'material', 'un', 12000.00, true),
('CLI-007', 'Ar condicionado piso-teto 36.000 BTU', 'Fornecimento e instalacao de piso-teto', 'material', 'un', 9500.00, true),
('CLI-008', 'Instalacao split (so mao de obra)', 'Instalacao de split ate 18.000 BTU, infra existente', 'mao_obra', 'un', 550.00, true),
('CLI-009', 'Instalacao split grande (mao obra)', 'Instalacao de split 24.000+ BTU, infra existente', 'mao_obra', 'un', 850.00, true),
('CLI-010', 'Infra ar condicionado', 'Pre-instalacao: tubulacao cobre, dreno, eletrica', 'material', 'ponto', 450.00, true),
('CLI-011', 'Tubulacao adicional', 'Metro adicional de tubulacao cobre + isolamento', 'material', 'm', 85.00, true),
('CLI-012', 'Exaustor banheiro', 'Exaustor silencioso com timer, inclui instalacao', 'material', 'un', 380.00, true),
('CLI-013', 'Ventilacao forcada', 'Sistema de ventilacao forcada com duto flexivel', 'material', 'ponto', 550.00, true),
('CLI-014', 'Aquecedor a gas digital', 'Aquecedor de passagem digital, vazao 20L/min', 'material', 'un', 2800.00, true),
('CLI-015', 'Aquecedor a gas mecanico', 'Aquecedor de passagem mecanico, vazao 15L/min', 'material', 'un', 1800.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 5. NOVOS ITENS - AUTOMACAO (AUT) - Complementar
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('AUT-010', 'Fechadura digital biometrica', 'Fechadura digital com biometria, senha e app', 'material', 'un', 1800.00, true),
('AUT-011', 'Fechadura digital senha', 'Fechadura digital com senha e cartao', 'material', 'un', 850.00, true),
('AUT-012', 'Persiana motorizada', 'Motorizacao de persiana com controle RF e app', 'material', 'm2', 580.00, true),
('AUT-013', 'Cortina motorizada', 'Motorizacao de cortina com controle RF e app', 'material', 'm', 450.00, true),
('AUT-014', 'Sistema alarme residencial', 'Central + sensores + sirene + controle app', 'material', 'kit', 2800.00, true),
('AUT-015', 'Camera CFTV IP', 'Camera IP full HD com infravermelho, interna/externa', 'material', 'un', 450.00, true),
('AUT-016', 'Kit CFTV 4 cameras + DVR', 'Sistema completo 4 cameras + DVR + HD 1TB + instalacao', 'material', 'kit', 3500.00, true),
('AUT-017', 'Kit CFTV 8 cameras + DVR', 'Sistema completo 8 cameras + DVR + HD 2TB + instalacao', 'material', 'kit', 5800.00, true),
('AUT-018', 'Som ambiente zona', 'Sistema de som ambiente por zona com caixas embutidas', 'material', 'zona', 3200.00, true),
('AUT-019', 'Video porteiro', 'Video porteiro com tela 7" e abertura remota', 'material', 'un', 1200.00, true),
('AUT-020', 'Controle cenas iluminacao', 'Modulo controle de cenas, ate 6 circuitos', 'material', 'un', 1500.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 6. NOVOS ITENS - ELETRICA (ELE) - Complementar
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('ELE-024', 'Quadro distribuicao 12 disjuntores', 'Quadro de distribuicao embutir com barramento', 'material', 'un', 450.00, true),
('ELE-025', 'Quadro distribuicao 24 disjuntores', 'Quadro de distribuicao embutir com barramento', 'material', 'un', 650.00, true),
('ELE-026', 'Quadro distribuicao 36 disjuntores', 'Quadro de distribuicao sobrepor com barramento', 'material', 'un', 850.00, true),
('ELE-027', 'DPS protetor surto classe II', 'Dispositivo protecao contra surto, 40kA', 'material', 'un', 180.00, true),
('ELE-028', 'DPS protetor surto classe I+II', 'Dispositivo protecao contra surto, 60kA', 'material', 'un', 350.00, true),
('ELE-029', 'Aterramento SPDA', 'Sistema de aterramento com hastes e conexoes', 'material', 'un', 650.00, true),
('ELE-030', 'Ponto carro eletrico', 'Instalacao ponto para carregador veiculo eletrico', 'material', 'ponto', 2500.00, true),
('ELE-031', 'Carregador veiculo eletrico', 'Wallbox carregador 7kW com instalacao', 'material', 'un', 4500.00, true),
('ELE-032', 'Nobreak 1500VA', 'Nobreak senoidal 1500VA com instalacao', 'material', 'un', 1800.00, true),
('ELE-033', 'Gerador diesel emergencia', 'Gerador diesel 10kVA automatico', 'material', 'un', 25000.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 7. NOVOS ITENS - HIDRAULICA (HID) - Complementar
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('HID-022', 'Pressurizador 1/2 CV', 'Pressurizador de agua 1/2 CV com instalacao', 'material', 'un', 1200.00, true),
('HID-023', 'Pressurizador 1 CV', 'Pressurizador de agua 1 CV com instalacao', 'material', 'un', 1800.00, true),
('HID-024', 'Sistema reuso agua cinza', 'Sistema completo captacao e reuso agua cinza', 'material', 'un', 5500.00, true),
('HID-025', 'Caixa dagua 500L + inst', 'Caixa dagua polietileno 500L com instalacao', 'material', 'un', 650.00, true),
('HID-026', 'Caixa dagua 1000L + inst', 'Caixa dagua polietileno 1000L com instalacao', 'material', 'un', 950.00, true),
('HID-027', 'Bomba submersa poco', 'Bomba submersa 1CV para poco artesiano', 'material', 'un', 2800.00, true),
('HID-028', 'Filtro central agua', 'Filtro central retrolavavel 1000L/h', 'material', 'un', 1500.00, true),
('HID-029', 'Softener abrandador', 'Sistema abrandador de agua residencial', 'material', 'un', 3500.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 8. NOVOS ITENS - GESSO (GES) - Complementar
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('GES-020', 'Sanca aberta iluminada', 'Sanca aberta em drywall para fita LED', 'material', 'm', 165.00, true),
('GES-021', 'Sanca fechada', 'Sanca fechada em drywall para spots', 'material', 'm', 120.00, true),
('GES-022', 'Nicho embutido pequeno', 'Nicho em drywall 30x30cm com acabamento', 'material', 'un', 280.00, true),
('GES-023', 'Nicho embutido grande', 'Nicho em drywall 60x30cm com acabamento', 'material', 'un', 380.00, true),
('GES-024', 'Parede curva drywall', 'Execucao de parede curva em drywall', 'material', 'm2', 220.00, true),
('GES-025', 'Rebaixo teto tabicado', 'Forro tabicado com diferentes niveis', 'material', 'm2', 180.00, true),
('GES-026', 'Rasgo iluminacao indireta', 'Rasgo para iluminacao indireta em forro existente', 'material', 'm', 85.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 9. NOVOS ITENS - VIDRACARIA (VID) - Complementar
-- ============================================================================

INSERT INTO pricelist_itens (codigo, nome, descricao, tipo, unidade, preco, ativo) VALUES
('VID-009', 'Box blindex 8mm frontal', 'Box frontal vidro temperado 8mm incolor, ate 1,5m', 'material', 'un', 1200.00, true),
('VID-010', 'Box blindex 8mm canto', 'Box de canto vidro temperado 8mm incolor', 'material', 'un', 1800.00, true),
('VID-011', 'Porta pivotante vidro', 'Porta pivotante vidro temperado 10mm, ate 2,20m', 'material', 'un', 2500.00, true),
('VID-012', 'Guarda-corpo vidro + inox', 'Guarda-corpo vidro laminado 10mm com corrimao inox', 'material', 'm', 850.00, true),
('VID-013', 'Espelho bisotado', 'Espelho 4mm com bisote, inclui instalacao', 'material', 'm2', 280.00, true),
('VID-014', 'Espelho decorativo', 'Espelho bronze ou fume 4mm', 'material', 'm2', 350.00, true),
('VID-015', 'Fechamento sacada', 'Sistema de fechamento sacada cortina de vidro', 'material', 'm2', 550.00, true),
('VID-016', 'Divisoria vidro escritorio', 'Divisoria vidro temperado 8mm com porta', 'material', 'm2', 420.00, true)
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome,
  preco = EXCLUDED.preco,
  updated_at = NOW();

-- ============================================================================
-- 10. VERIFICACAO FINAL
-- ============================================================================

-- Contar novos itens por categoria (apenas os novos inseridos)
SELECT
  SUBSTRING(codigo, 1, 3) as categoria,
  COUNT(*) as total_itens
FROM pricelist_itens
WHERE codigo LIKE 'SER-%'
   OR codigo LIKE 'IMP-%'
   OR codigo LIKE 'CLI-%'
   OR codigo IN ('AUT-010','AUT-011','AUT-012','AUT-013','AUT-014','AUT-015','AUT-016','AUT-017','AUT-018','AUT-019','AUT-020')
   OR codigo IN ('ELE-024','ELE-025','ELE-026','ELE-027','ELE-028','ELE-029','ELE-030','ELE-031','ELE-032','ELE-033')
   OR codigo IN ('HID-022','HID-023','HID-024','HID-025','HID-026','HID-027','HID-028','HID-029')
   OR codigo IN ('GES-020','GES-021','GES-022','GES-023','GES-024','GES-025','GES-026')
   OR codigo IN ('VID-009','VID-010','VID-011','VID-012','VID-013','VID-014','VID-015','VID-016')
GROUP BY 1
ORDER BY 1;

-- Total geral de itens no pricelist
SELECT COUNT(*) as total_itens_pricelist FROM pricelist_itens WHERE ativo = true;
