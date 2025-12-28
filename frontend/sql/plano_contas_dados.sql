-- =====================================================
-- DADOS INICIAIS DO PLANO DE CONTAS
-- Executar APOS criar as tabelas (plano_contas.sql)
-- =====================================================

-- INSERIR NUCLEOS
INSERT INTO fin_nucleos (codigo, nome, icone, cor, ordem) VALUES
  ('01', 'Arquitetura', 'Building2', '#F25C26', 1),
  ('02', 'Engenharia', 'Settings', '#3B82F6', 2),
  ('03', 'Marcenaria', 'Hammer', '#8B5CF6', 3),
  ('04', 'Compra e Venda de Produtos', 'ShoppingCart', '#10B981', 4),
  ('05', 'Compra e Venda de Materiais', 'Package', '#F59E0B', 5)
ON CONFLICT (codigo) DO NOTHING;

-- INSERIR PLANO DE CONTAS - ARQUITETURA
WITH nucleo AS (SELECT id FROM fin_nucleos WHERE codigo = '01')
INSERT INTO fin_plano_contas (codigo, nome, classe, nucleo_id, tipo, ordem) VALUES
  ('4.1.01', 'Projetos arquitetonicos terceirizados', 'custo', (SELECT id FROM nucleo), 'variavel', 1),
  ('4.1.02', 'Freelancers de arquitetura', 'custo', (SELECT id FROM nucleo), 'variavel', 2),
  ('4.1.03', 'Maquetes eletronicas / renderizacao', 'custo', (SELECT id FROM nucleo), 'variavel', 3),
  ('4.1.04', 'Impressoes e plotagens', 'custo', (SELECT id FROM nucleo), 'variavel', 4),
  ('4.1.05', 'Visitas tecnicas por projeto', 'custo', (SELECT id FROM nucleo), 'variavel', 5),
  ('4.1.06', 'Revisoes e ajustes extraordinarios', 'custo', (SELECT id FROM nucleo), 'variavel', 6),
  ('4.1.07', 'Compatibilizacao de projetos', 'custo', (SELECT id FROM nucleo), 'variavel', 7),
  ('5.1.01', 'Salarios - Arquitetura', 'despesa', (SELECT id FROM nucleo), 'fixo', 8),
  ('5.1.02', 'Encargos sociais - Arquitetura', 'despesa', (SELECT id FROM nucleo), 'fixo', 9),
  ('5.1.03', 'Pro-labore - Arquitetura', 'despesa', (SELECT id FROM nucleo), 'fixo', 10),
  ('5.1.04', 'Softwares e licencas', 'despesa', (SELECT id FROM nucleo), 'fixo', 11),
  ('5.1.05', 'Equipamentos e informatica', 'despesa', (SELECT id FROM nucleo), 'variavel', 12),
  ('5.1.06', 'Internet e telefonia', 'despesa', (SELECT id FROM nucleo), 'fixo', 13),
  ('5.1.07', 'Aluguel / rateio de estrutura', 'despesa', (SELECT id FROM nucleo), 'fixo', 14),
  ('5.1.08', 'Marketing institucional', 'despesa', (SELECT id FROM nucleo), 'variavel', 15),
  ('5.1.09', 'Cursos e treinamentos', 'despesa', (SELECT id FROM nucleo), 'variavel', 16),
  ('5.1.10', 'Despesas administrativas do nucleo', 'despesa', (SELECT id FROM nucleo), 'variavel', 17)
ON CONFLICT (codigo) DO NOTHING;

-- INSERIR PLANO DE CONTAS - ENGENHARIA
WITH nucleo AS (SELECT id FROM fin_nucleos WHERE codigo = '02')
INSERT INTO fin_plano_contas (codigo, nome, classe, nucleo_id, tipo, ordem) VALUES
  ('4.2.01', 'Projetos estruturais terceirizados', 'custo', (SELECT id FROM nucleo), 'variavel', 1),
  ('4.2.02', 'Projetos complementares (eletrica, hidraulica, gas etc.)', 'custo', (SELECT id FROM nucleo), 'variavel', 2),
  ('4.2.03', 'ART / RRT por obra', 'custo', (SELECT id FROM nucleo), 'variavel', 3),
  ('4.2.04', 'Laudos tecnicos', 'custo', (SELECT id FROM nucleo), 'variavel', 4),
  ('4.2.05', 'Ensaios e testes', 'custo', (SELECT id FROM nucleo), 'variavel', 5),
  ('4.2.06', 'Consultorias tecnicas', 'custo', (SELECT id FROM nucleo), 'variavel', 6),
  ('4.2.07', 'Vistorias tecnicas', 'custo', (SELECT id FROM nucleo), 'variavel', 7),
  ('5.2.01', 'Salarios - Engenharia', 'despesa', (SELECT id FROM nucleo), 'fixo', 8),
  ('5.2.02', 'Encargos sociais - Engenharia', 'despesa', (SELECT id FROM nucleo), 'fixo', 9),
  ('5.2.03', 'Pro-labore - Engenharia', 'despesa', (SELECT id FROM nucleo), 'fixo', 10),
  ('5.2.04', 'Softwares tecnicos', 'despesa', (SELECT id FROM nucleo), 'fixo', 11),
  ('5.2.05', 'Equipamentos', 'despesa', (SELECT id FROM nucleo), 'variavel', 12),
  ('5.2.06', 'Seguros profissionais', 'despesa', (SELECT id FROM nucleo), 'fixo', 13),
  ('5.2.07', 'Veiculos e deslocamentos', 'despesa', (SELECT id FROM nucleo), 'variavel', 14),
  ('5.2.08', 'Internet e telefonia', 'despesa', (SELECT id FROM nucleo), 'fixo', 15),
  ('5.2.09', 'Cursos e certificacoes', 'despesa', (SELECT id FROM nucleo), 'variavel', 16),
  ('5.2.10', 'Despesas administrativas do nucleo', 'despesa', (SELECT id FROM nucleo), 'variavel', 17)
ON CONFLICT (codigo) DO NOTHING;

-- INSERIR PLANO DE CONTAS - MARCENARIA
WITH nucleo AS (SELECT id FROM fin_nucleos WHERE codigo = '03')
INSERT INTO fin_plano_contas (codigo, nome, classe, nucleo_id, tipo, ordem) VALUES
  ('4.3.01', 'MDF, madeiras e chapas', 'custo', (SELECT id FROM nucleo), 'variavel', 1),
  ('4.3.02', 'Ferragens', 'custo', (SELECT id FROM nucleo), 'variavel', 2),
  ('4.3.03', 'Insumos (cola, fita, verniz, tinta)', 'custo', (SELECT id FROM nucleo), 'variavel', 3),
  ('4.3.04', 'Vidros, espelhos e pedras', 'custo', (SELECT id FROM nucleo), 'variavel', 4),
  ('4.3.05', 'Mao de obra terceirizada', 'custo', (SELECT id FROM nucleo), 'variavel', 5),
  ('4.3.06', 'Transporte e instalacao', 'custo', (SELECT id FROM nucleo), 'variavel', 6),
  ('4.3.07', 'Embalagens e protecao', 'custo', (SELECT id FROM nucleo), 'variavel', 7),
  ('4.3.08', 'Retrabalhos e ajustes', 'custo', (SELECT id FROM nucleo), 'variavel', 8),
  ('5.3.01', 'Salarios - Marcenaria', 'despesa', (SELECT id FROM nucleo), 'fixo', 9),
  ('5.3.02', 'Encargos sociais - Marcenaria', 'despesa', (SELECT id FROM nucleo), 'fixo', 10),
  ('5.3.03', 'Pro-labore - Marcenaria', 'despesa', (SELECT id FROM nucleo), 'fixo', 11),
  ('5.3.04', 'Aluguel de galpao', 'despesa', (SELECT id FROM nucleo), 'fixo', 12),
  ('5.3.05', 'Energia eletrica', 'despesa', (SELECT id FROM nucleo), 'variavel', 13),
  ('5.3.06', 'Manutencao de maquinas', 'despesa', (SELECT id FROM nucleo), 'variavel', 14),
  ('5.3.07', 'Ferramentas e EPIs', 'despesa', (SELECT id FROM nucleo), 'variavel', 15),
  ('5.3.08', 'Seguro patrimonial', 'despesa', (SELECT id FROM nucleo), 'fixo', 16),
  ('5.3.09', 'Internet e telefonia', 'despesa', (SELECT id FROM nucleo), 'fixo', 17),
  ('5.3.10', 'Despesas administrativas', 'despesa', (SELECT id FROM nucleo), 'variavel', 18)
ON CONFLICT (codigo) DO NOTHING;

-- INSERIR PLANO DE CONTAS - PRODUTOS
WITH nucleo AS (SELECT id FROM fin_nucleos WHERE codigo = '04')
INSERT INTO fin_plano_contas (codigo, nome, classe, nucleo_id, tipo, ordem) VALUES
  ('4.4.01', 'Custo de aquisicao de produtos', 'custo', (SELECT id FROM nucleo), 'variavel', 1),
  ('4.4.02', 'Frete de compra', 'custo', (SELECT id FROM nucleo), 'variavel', 2),
  ('4.4.03', 'Frete de entrega', 'custo', (SELECT id FROM nucleo), 'variavel', 3),
  ('4.4.04', 'Montagem e instalacao', 'custo', (SELECT id FROM nucleo), 'variavel', 4),
  ('4.4.05', 'Comissoes de venda', 'custo', (SELECT id FROM nucleo), 'variavel', 5),
  ('4.4.06', 'Taxas de cartao / gateway', 'custo', (SELECT id FROM nucleo), 'variavel', 6),
  ('4.4.07', 'Garantias e assistencia', 'custo', (SELECT id FROM nucleo), 'variavel', 7),
  ('4.4.08', 'Perdas e avarias', 'custo', (SELECT id FROM nucleo), 'variavel', 8),
  ('5.4.01', 'Salarios - Comercial', 'despesa', (SELECT id FROM nucleo), 'fixo', 9),
  ('5.4.02', 'Encargos sociais', 'despesa', (SELECT id FROM nucleo), 'fixo', 10),
  ('5.4.03', 'Aluguel de showroom', 'despesa', (SELECT id FROM nucleo), 'fixo', 11),
  ('5.4.04', 'Condominio e IPTU', 'despesa', (SELECT id FROM nucleo), 'fixo', 12),
  ('5.4.05', 'Energia eletrica', 'despesa', (SELECT id FROM nucleo), 'variavel', 13),
  ('5.4.06', 'Marketing e vendas', 'despesa', (SELECT id FROM nucleo), 'variavel', 14),
  ('5.4.07', 'Sistemas / ERP', 'despesa', (SELECT id FROM nucleo), 'fixo', 15),
  ('5.4.08', 'Embalagens institucionais', 'despesa', (SELECT id FROM nucleo), 'variavel', 16),
  ('5.4.09', 'Despesas administrativas', 'despesa', (SELECT id FROM nucleo), 'variavel', 17)
ON CONFLICT (codigo) DO NOTHING;

-- INSERIR PLANO DE CONTAS - MATERIAIS
WITH nucleo AS (SELECT id FROM fin_nucleos WHERE codigo = '05')
INSERT INTO fin_plano_contas (codigo, nome, classe, nucleo_id, tipo, ordem) VALUES
  ('4.5.01', 'Compra de materiais', 'custo', (SELECT id FROM nucleo), 'variavel', 1),
  ('4.5.02', 'Frete de compra', 'custo', (SELECT id FROM nucleo), 'variavel', 2),
  ('4.5.03', 'Frete de entrega', 'custo', (SELECT id FROM nucleo), 'variavel', 3),
  ('4.5.04', 'Quebras e perdas', 'custo', (SELECT id FROM nucleo), 'variavel', 4),
  ('4.5.05', 'Armazenagem', 'custo', (SELECT id FROM nucleo), 'variavel', 5),
  ('4.5.06', 'Comissoes', 'custo', (SELECT id FROM nucleo), 'variavel', 6),
  ('4.5.07', 'Impostos sobre vendas', 'custo', (SELECT id FROM nucleo), 'variavel', 7),
  ('4.5.08', 'Devolucoes', 'custo', (SELECT id FROM nucleo), 'variavel', 8),
  ('5.5.01', 'Salarios - Materiais', 'despesa', (SELECT id FROM nucleo), 'fixo', 9),
  ('5.5.02', 'Encargos sociais', 'despesa', (SELECT id FROM nucleo), 'fixo', 10),
  ('5.5.03', 'Aluguel de deposito', 'despesa', (SELECT id FROM nucleo), 'fixo', 11),
  ('5.5.04', 'Energia eletrica', 'despesa', (SELECT id FROM nucleo), 'variavel', 12),
  ('5.5.05', 'Sistemas de estoque', 'despesa', (SELECT id FROM nucleo), 'fixo', 13),
  ('5.5.06', 'Veiculos e manutencao', 'despesa', (SELECT id FROM nucleo), 'variavel', 14),
  ('5.5.07', 'Marketing tecnico', 'despesa', (SELECT id FROM nucleo), 'variavel', 15),
  ('5.5.08', 'Despesas administrativas', 'despesa', (SELECT id FROM nucleo), 'variavel', 16)
ON CONFLICT (codigo) DO NOTHING;
