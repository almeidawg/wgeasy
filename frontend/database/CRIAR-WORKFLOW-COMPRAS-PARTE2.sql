-- PARTE 2: DADOS INICIAIS E INDICES

-- Indices
CREATE INDEX IF NOT EXISTS idx_projetos_compras_codigo ON projetos_compras(codigo);
CREATE INDEX IF NOT EXISTS idx_projetos_compras_status ON projetos_compras(status);
CREATE INDEX IF NOT EXISTS idx_quantitativo_projeto ON projeto_quantitativo(projeto_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_projeto ON projeto_lista_compras(projeto_id);
CREATE INDEX IF NOT EXISTS idx_lista_compras_status ON projeto_lista_compras(status);
CREATE INDEX IF NOT EXISTS idx_fluxo_projeto ON fluxo_financeiro_compras(projeto_id);

-- Dados de Categorias
INSERT INTO categorias_compras (codigo, nome, tipo, etapa_obra, ordem_execucao) VALUES
('PRE', 'PRE OBRA', 'PROTECAO', '1-PREPARACAO', 1),
('CIN', 'MATERIAL CINZA', 'CONSTRUCAO', '2-ESTRUTURA', 10),
('HID', 'HIDRAULICA', 'HIDRAULICO', '3-INFRAESTRUTURA', 20),
('GAS', 'GAS', 'GAS', '3-INFRAESTRUTURA', 25),
('ELE', 'ELETRICA', 'ELETRICO', '3-INFRAESTRUTURA', 30),
('AUT', 'AUTOMACAO', 'AUTOMACAO', '3-INFRAESTRUTURA', 35),
('REV', 'PISOS E PAREDES', 'REVESTIMENTO', '4-REVESTIMENTO', 40),
('PIN', 'PINTURA', 'PINTURA', '4-REVESTIMENTO', 45),
('ILU', 'ILUMINACAO', 'ILUMINACAO', '5-ACABAMENTO', 50),
('TRI', 'TRILHOS MAGNETICOS', 'ILUMINACAO', '5-ACABAMENTO', 51),
('LOU', 'CUBAS LOUCAS E METAIS', 'LOUCA', '5-ACABAMENTO', 55),
('INT', 'INTERRUPTORES SMART', 'AUTOMACAO', '5-ACABAMENTO', 60),
('CLI', 'AR CONDICIONADO', 'CLIMATIZACAO', '6-INSTALACOES', 70),
('AQU', 'AQUECEDORES', 'CLIMATIZACAO', '6-INSTALACOES', 71),
('VID', 'VIDRACARIA', 'VIDRO', '6-INSTALACOES', 75),
('ENV', 'ENVIDRACAMENTO SACADA', 'VIDRO', '6-INSTALACOES', 76),
('ELD', 'ELETRODOMESTICOS', 'EQUIPAMENTO', '7-EQUIPAMENTOS', 80),
('ELT', 'ELETRONICOS', 'EQUIPAMENTO', '7-EQUIPAMENTOS', 81),
('SEG', 'SEGURANCA', 'AUTOMACAO', '7-EQUIPAMENTOS', 85),
('FIN', 'FINALIZACOES', 'ACABAMENTO', '8-FINALIZACAO', 90),
('INS', 'INSUMOS', 'INSUMO', 'CONTINUO', 99)
ON CONFLICT (codigo) DO NOTHING;

-- Dados de Complementares
INSERT INTO produtos_complementares (codigo, produto_base, categoria_base, complemento, categoria_complemento, quantidade_por_unidade, unidade_calculo, tipo, preco_referencia) VALUES
('COMP001', 'PORCELANATO', 'REVESTIMENTOS', 'Argamassa AC-III 20kg', 'ARGAMASSAS', 5, 'kg/m2', 'OBRIGATORIO', 42.90),
('COMP002', 'PORCELANATO', 'REVESTIMENTOS', 'Rejunte Porcelanato 1kg', 'REJUNTES', 0.5, 'kg/m2', 'OBRIGATORIO', 18.90),
('COMP003', 'PORCELANATO', 'REVESTIMENTOS', 'Espacador Nivelador 1mm', 'FERRAMENTAS', 8, 'un/m2', 'OBRIGATORIO', 0.35),
('COMP004', 'PORCELANATO', 'REVESTIMENTOS', 'Cunha Nivelador', 'FERRAMENTAS', 8, 'un/m2', 'RECOMENDADO', 0.15),
('COMP005', 'PORCELANATO', 'REVESTIMENTOS', 'Disco Corte Porcelanato', 'FERRAMENTAS', 0.02, 'un/m2', 'RECOMENDADO', 45.00),
('COMP006', 'BACIA SANITARIA', 'LOUCAS', 'Anel Vedacao', 'ACESSORIOS', 1, 'un', 'OBRIGATORIO', 12.50),
('COMP007', 'BACIA SANITARIA', 'LOUCAS', 'Parafuso Fixacao', 'ACESSORIOS', 2, 'un', 'OBRIGATORIO', 8.90),
('COMP008', 'BACIA SANITARIA', 'LOUCAS', 'Engate Flexivel 40cm', 'HIDRAULICO', 1, 'un', 'OBRIGATORIO', 28.90),
('COMP009', 'BACIA SANITARIA', 'LOUCAS', 'Assento Sanitario', 'ACESSORIOS', 1, 'un', 'OBRIGATORIO', 89.90),
('COMP010', 'BACIA SANITARIA', 'LOUCAS', 'Ducha Higienica Kit', 'METAIS', 1, 'un', 'RECOMENDADO', 285.00),
('COMP011', 'PINTURA', 'TINTAS', 'Selador Acrilico 18L', 'PREPARACAO', 0.2, 'L/m2', 'OBRIGATORIO', 165.00),
('COMP012', 'PINTURA', 'TINTAS', 'Massa Corrida PVA 25kg', 'PREPARACAO', 0.5, 'kg/m2', 'OBRIGATORIO', 86.90),
('COMP013', 'PINTURA', 'TINTAS', 'Lixa 220', 'FERRAMENTAS', 0.1, 'folha/m2', 'OBRIGATORIO', 1.59),
('COMP014', 'PINTURA', 'TINTAS', 'Fita Crepe 48mm', 'FERRAMENTAS', 0.3, 'm/m2', 'RECOMENDADO', 13.95),
('COMP015', 'PINTURA', 'TINTAS', 'Lona Plastica', 'PROTECAO', 1.1, 'm2/m2', 'RECOMENDADO', 3.30),
('COMP016', 'CUBA', 'LOUCAS', 'Valvula Click Clack', 'ACESSORIOS', 1, 'un', 'OBRIGATORIO', 45.00),
('COMP017', 'CUBA', 'LOUCAS', 'Sifao Cromado', 'HIDRAULICO', 1, 'un', 'OBRIGATORIO', 89.90),
('COMP018', 'CUBA', 'LOUCAS', 'Engate Flexivel 30cm', 'HIDRAULICO', 1, 'un', 'OBRIGATORIO', 24.90),
('COMP019', 'CUBA', 'LOUCAS', 'Torneira Lavatorio', 'METAIS', 1, 'un', 'RECOMENDADO', 520.00)
ON CONFLICT (codigo) DO NOTHING;
