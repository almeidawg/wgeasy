-- =====================================================
-- WNO MAS - DADOS DOS VINHOS (POPULAÇÃO AUTOMÁTICA)
-- Executar APÓS o wnomas_database.sql
-- =====================================================

-- =====================================================
-- INSERIR VINHOS TINTOS
-- =====================================================

INSERT INTO vinhos (slug, nome, categoria_id, regiao_id, safra, corpo, acidez, taninos, teor_alcoolico, temperatura_ideal, metodo_producao, potencial_guarda, descricao, nota_wnomas, dica_sommelier, custo_base, margem_percentual, preco_venda, imagem_url, ativo, destaque) VALUES

-- Alamos Malbec
('alamos-malbec', 'Alamos Malbec', 1, 1, '2021', 'Médio', 'Média', 'Médio', 13.5, '16-18°C', 'Tradicional', '3-5 anos',
'Um clássico argentino. Frutas negras, toque de especiarias e violetas. Equilibrado e fácil de beber.',
'Um clássico argentino. Frutas negras, toque de especiarias e violetas. Equilibrado e fácil de beber.',
'Servir na temperatura correta para realçar os aromas.',
45.00, 40, 98, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/1b57bcbdf9138aaad32773163a87bbeb.png', TRUE, TRUE),

-- D.V. Catena Malbec-Malbec
('dv-catena-malbec', 'D.V. Catena Malbec-Malbec', 1, 1, '2019', 'Encorpado', 'Média', 'Alto', 14.0, '16-18°C', 'Tradicional', '10 anos',
'Blend de dois vinhedos premium. Complexo, com notas de ameixa, tabaco e baunilha.',
'Blend de dois vinhedos premium. Complexo, com notas de ameixa, tabaco e baunilha.',
'Decantar por 30 minutos antes de servir.',
180.00, 45, 319, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/6ae86993ac633acd0ebcb8eac98b1c7c.png', TRUE, FALSE),

-- D.V. Catena Cabernet-Malbec
('dv-catena-cab-malbec', 'D.V. Catena Cabernet-Malbec', 1, 1, '2019', 'Encorpado', 'Alta', 'Alto', 14.0, '16-18°C', 'Tradicional', '15 anos',
'A elegância do Cabernet com a fruta do Malbec. Estruturado e longo.',
'A elegância do Cabernet com a fruta do Malbec. Estruturado e longo.',
'Ideal para carnes vermelhas grelhadas.',
190.00, 50, 347, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/9892452f647a702a9c3390106da40e82.png', TRUE, TRUE),

-- El Enemigo Malbec
('el-enemigo-malbec', 'El Enemigo Malbec', 1, 1, '2018', 'Encorpado', 'Alta', 'Médio', 13.5, '16-18°C', 'Tradicional', '10 anos',
'Fresco e floral, com a assinatura de Alejandro Vigil. Um Malbec de caráter único.',
'Fresco e floral, com a assinatura de Alejandro Vigil. Um Malbec de caráter único.',
'Um dos melhores Malbecs para conhecedores.',
220.00, 45, 388, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/520722075d72f803f01890ccfd7724ab.png', TRUE, FALSE),

-- Luigi Bosca Malbec
('luigi-bosca-malbec', 'Luigi Bosca Malbec', 1, 2, '2020', 'Encorpado', 'Média', 'Macios', 14.0, '16-18°C', 'Tradicional', '5 anos',
'Um ícone de consistência. Fruta madura, especiarias doces e final agradável.',
'Um ícone de consistência. Fruta madura, especiarias doces e final agradável.',
'Excelente custo-benefício para o dia a dia.',
95.00, 40, 168, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/592b9e07fb771bc9564bcc1ff0ea5a99.png', TRUE, FALSE),

-- Saint Felicien Malbec
('saint-felicien-malbec', 'Saint Felicien Malbec', 1, 1, '2020', 'Médio', 'Média', 'Finos', 13.8, '16-18°C', 'Tradicional', '5-7 anos',
'Elegante e sofisticado. Notas de frutas vermelhas e carvalho bem integrado.',
'Elegante e sofisticado. Notas de frutas vermelhas e carvalho bem integrado.',
'Perfeito para jantares especiais.',
110.00, 40, 191, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/4bf2d2773ede8e7aadc8d4a4eec45506.png', TRUE, FALSE),

-- Rutini Malbec
('rutini-malbec', 'Rutini Malbec', 1, 1, '2019', 'Encorpado', 'Média', 'Alto', 14.2, '16-18°C', 'Tradicional', '10 anos',
'Aristocrático. Aromas intensos, madeira presente e grande estrutura.',
'Aristocrático. Aromas intensos, madeira presente e grande estrutura.',
'Para ocasiões que merecem um vinho especial.',
200.00, 50, 363, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/8625b6f0c59ce037e7645ecf9e0de9eb.png', TRUE, TRUE),

-- Bramare Malbec
('bramare-malbec', 'Bramare Malbec Luján de Cuyo', 1, 2, '2018', 'Muito Encorpado', 'Média', 'Aveludados', 14.5, '16-18°C', 'Tradicional', '15 anos',
'Opulento e concentrado. A assinatura de Paul Hobbs em um vinho memorável.',
'Opulento e concentrado. A assinatura de Paul Hobbs em um vinho memorável.',
'Um dos grandes vinhos da Argentina.',
380.00, 55, 715, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/c8306ea36312b753680448717226a87d.png', TRUE, FALSE),

-- Achaval Ferrer Quimera
('achaval-ferrer-quimera', 'Achaval Ferrer Quimera', 1, 1, '2018', 'Encorpado', 'Alta', 'Finos', 14.5, '16-18°C', 'Biodinâmico', '15+ anos',
'A busca pela perfeição. Um blend que muda a cada ano para expressar o melhor do terroir.',
'A busca pela perfeição. Um blend que muda a cada ano para expressar o melhor do terroir.',
'Vinho de colecionador.',
350.00, 60, 686, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/06d50eeb48179fb63c7ff5435b838ad0.png', TRUE, FALSE),

-- Gran Enemigo Blend
('gran-enemigo-blend', 'Gran Enemigo Blend', 1, 1, '2017', 'Encorpado', 'Alta', 'Finos', 13.9, '16-18°C', 'Tradicional', '20 anos',
'Inspirado em Pomerol, mas com alma andina. Um dos grandes vinhos da América do Sul.',
'Inspirado em Pomerol, mas com alma andina. Um dos grandes vinhos da América do Sul.',
'Guarde por anos ou aprecie agora decantado.',
450.00, 60, 880, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/99d0c6137e6cf98e455122fc5079b0fc.png', TRUE, TRUE),

-- Zuccardi Serie A Malbec
('zuccardi-serie-a-malbec', 'Zuccardi Serie A Malbec', 1, 3, '2021', 'Médio', 'Média', 'Macios', 13.5, '15-17°C', 'Tradicional', '4 anos',
'Fruta fresca e vibrante. A expressão pura do Valle de Uco.',
'Fruta fresca e vibrante. A expressão pura do Valle de Uco.',
'Ótimo para iniciantes no mundo dos vinhos.',
85.00, 40, 154, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/e86844d8ae493331bc85900765bfea7a.png', TRUE, FALSE),

-- Las Perdices Reserva Malbec
('las-perdices-reserva-malbec', 'Las Perdices Reserva Malbec', 1, 1, '2020', 'Encorpado', 'Média', 'Doces', 14.0, '16-18°C', 'Tradicional', '5 anos',
'Intenso e frutado, com notas de madeira tostada e chocolate.',
'Intenso e frutado, com notas de madeira tostada e chocolate.',
'Harmoniza bem com churrascos.',
90.00, 40, 161, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/745b4efee75d759908229efa5fffb275.png', TRUE, FALSE);

-- =====================================================
-- INSERIR VINHOS BRANCOS
-- =====================================================

INSERT INTO vinhos (slug, nome, categoria_id, regiao_id, safra, corpo, acidez, taninos, teor_alcoolico, temperatura_ideal, metodo_producao, potencial_guarda, descricao, nota_wnomas, dica_sommelier, custo_base, margem_percentual, preco_venda, imagem_url, ativo, destaque) VALUES

-- Alamos Chardonnay
('alamos-chardonnay', 'Alamos Chardonnay', 2, 1, '2021', 'Médio', 'Média', 'Inexistente', 13.0, '8-10°C', 'Tradicional', '3 anos',
'Fresco e frutado, com leve toque de madeira. Perfeito para o dia a dia.',
'Fresco e frutado, com leve toque de madeira. Perfeito para o dia a dia.',
'Servir bem gelado.',
45.00, 40, 98, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/8a5f36f7b8154fba19896430ab9eae47.png', TRUE, FALSE),

-- La Linda Chardonnay
('la-linda-chardonnay', 'La Linda Chardonnay', 2, 1, '2021', 'Leve', 'Alta', 'Inexistente', 13.5, '8-10°C', 'Tradicional', '3 anos',
'Sem madeira, foca na fruta tropical e frescor. Muito versátil.',
'Sem madeira, foca na fruta tropical e frescor. Muito versátil.',
'Ideal para peixes e frutos do mar.',
55.00, 40, 112, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/f338d01600069020176cb5cd879a1dd8.png', TRUE, TRUE),

-- D.V. Catena Chardonnay
('dv-catena-chardonnay', 'D.V. Catena Chardonnay', 2, 1, '2020', 'Encorpado', 'Média', 'Inexistente', 13.5, '10-12°C', 'Tradicional', '8 anos',
'Rico e untuoso. Notas de frutas maduras, mel e pão tostado.',
'Rico e untuoso. Notas de frutas maduras, mel e pão tostado.',
'Um branco para guardar.',
160.00, 45, 283, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/7833431f18b78c961c05d1c556c69c55.png', TRUE, FALSE),

-- Rutini Chardonnay
('rutini-chardonnay', 'Rutini Chardonnay', 2, 1, '2020', 'Encorpado', 'Média', 'Inexistente', 13.8, '10-12°C', 'Tradicional', '8 anos',
'Um branco de classe mundial. Elegante, com madeira perfeitamente integrada.',
'Um branco de classe mundial. Elegante, com madeira perfeitamente integrada.',
'Para jantares sofisticados.',
210.00, 50, 380, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/1b57bcbdf9138aaad32773163a87bbeb.png', TRUE, FALSE),

-- Zuccardi Q Chardonnay
('zuccardi-q-chardonnay', 'Zuccardi Q Chardonnay', 2, 3, '2020', 'Médio', 'Alta', 'Inexistente', 13.5, '9-11°C', 'Tradicional', '6 anos',
'Mineral e tenso. Proveniente de vinhedos de altitude.',
'Mineral e tenso. Proveniente de vinhedos de altitude.',
'Surpreende pelo frescor.',
130.00, 45, 231, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/6ae86993ac633acd0ebcb8eac98b1c7c.png', TRUE, FALSE);

-- =====================================================
-- INSERIR ESPUMANTES
-- =====================================================

INSERT INTO vinhos (slug, nome, categoria_id, regiao_id, safra, corpo, acidez, taninos, teor_alcoolico, temperatura_ideal, metodo_producao, potencial_guarda, descricao, nota_wnomas, dica_sommelier, custo_base, margem_percentual, preco_venda, imagem_url, ativo, destaque) VALUES

-- Chandon Extra Brut
('chandon-extra-brut', 'Chandon Extra Brut', 3, 4, 'NV', 'Leve', 'Alta', 'Inexistente', 11.8, '6-8°C', 'Charmat', '2 anos',
'O espumante mais amado do Brasil. Fresco, cítrico e equilibrado.',
'O espumante mais amado do Brasil. Fresco, cítrico e equilibrado.',
'Perfeito para brindes e celebrações.',
65.00, 35, 122, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/9892452f647a702a9c3390106da40e82.png', TRUE, TRUE),

-- Salentein Brut Rosé
('salentein-brut-rose', 'Salentein Brut Rosé', 3, 3, 'NV', 'Médio', 'Alta', 'Inexistente', 12.5, '6-8°C', 'Charmat Lungo', '3 anos',
'Cor salmão delicada. Aromas de frutas vermelhas e pão tostado.',
'Cor salmão delicada. Aromas de frutas vermelhas e pão tostado.',
'Elegante e versátil.',
95.00, 40, 168, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/520722075d72f803f01890ccfd7724ab.png', TRUE, FALSE),

-- Freixenet Cordon Negro
('freixenet-extra-brut', 'Freixenet Cordon Negro Extra Brut', 3, 6, 'NV', 'Leve', 'Alta', 'Inexistente', 11.5, '6-8°C', 'Método Tradicional', '3 anos',
'Um Cava icônico. Bolhas finas, maçã verde e cítricos.',
'Um Cava icônico. Bolhas finas, maçã verde e cítricos.',
'Excelente opção espanhola.',
80.00, 35, 149, 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/592b9e07fb771bc9564bcc1ff0ea5a99.png', TRUE, FALSE);

-- =====================================================
-- RELACIONAR VINHOS COM UVAS
-- =====================================================

-- Alamos Malbec -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (1, 1, 100);
-- D.V. Catena Malbec -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (2, 1, 100);
-- D.V. Catena Cab-Malbec -> Cabernet + Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (3, 2, 50), (3, 1, 50);
-- El Enemigo -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (4, 1, 100);
-- Luigi Bosca -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (5, 1, 100);
-- Saint Felicien -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (6, 1, 100);
-- Rutini -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (7, 1, 100);
-- Bramare -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (8, 1, 100);
-- Achaval Ferrer -> Blend
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (9, 1, 40), (9, 4, 30), (9, 3, 20), (9, 2, 10);
-- Gran Enemigo -> Blend
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (10, 4, 50), (10, 1, 40), (10, 5, 10);
-- Zuccardi Serie A -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (11, 1, 100);
-- Las Perdices -> Malbec
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (12, 1, 100);
-- Alamos Chardonnay -> Chardonnay
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (13, 7, 100);
-- La Linda -> Chardonnay
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (14, 7, 100);
-- D.V. Catena Chard -> Chardonnay
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (15, 7, 100);
-- Rutini Chard -> Chardonnay
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (16, 7, 100);
-- Zuccardi Q -> Chardonnay
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (17, 7, 100);
-- Chandon -> Chardonnay + Pinot Noir
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (18, 7, 60), (18, 6, 40);
-- Salentein Rosé -> Pinot Noir
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (19, 6, 100);
-- Freixenet -> Blend espanhol
INSERT INTO vinho_uvas (vinho_id, uva_id, percentual) VALUES (20, 9, 40), (20, 10, 35), (20, 11, 25);

-- =====================================================
-- CRIAR ESTOQUE INICIAL
-- =====================================================

INSERT INTO estoque (vinho_id, quantidade, quantidade_minima, localizacao) VALUES
(1, 120, 24, 'A-01'),
(2, 45, 12, 'A-02'),
(3, 30, 12, 'A-03'),
(4, 28, 6, 'A-04'),
(5, 60, 12, 'A-05'),
(6, 40, 6, 'A-06'),
(7, 35, 6, 'A-07'),
(8, 15, 3, 'A-08'),
(9, 10, 2, 'A-09'),
(10, 8, 2, 'A-10'),
(11, 55, 12, 'A-11'),
(12, 48, 6, 'A-12'),
(13, 80, 12, 'B-01'),
(14, 65, 12, 'B-02'),
(15, 25, 6, 'B-03'),
(16, 20, 4, 'B-04'),
(17, 35, 6, 'B-05'),
(18, 150, 24, 'C-01'),
(19, 40, 6, 'C-02'),
(20, 90, 12, 'C-03');

-- =====================================================
-- RELACIONAR VINHOS COM FORNECEDORES
-- =====================================================

INSERT INTO vinho_fornecedores (vinho_id, fornecedor_id, custo, ativo) VALUES
(1, 1, 45.00, TRUE),
(1, 2, 48.00, TRUE),
(2, 1, 180.00, TRUE),
(3, 1, 190.00, TRUE),
(3, 3, 205.00, TRUE),
(4, 2, 220.00, TRUE),
(5, 4, 95.00, TRUE),
(6, 1, 110.00, TRUE),
(7, 5, 200.00, TRUE),
(8, 3, 380.00, TRUE),
(9, 3, 350.00, TRUE),
(10, 2, 450.00, TRUE),
(11, 3, 85.00, TRUE),
(12, 3, 90.00, TRUE),
(13, 1, 45.00, TRUE),
(14, 4, 55.00, TRUE),
(15, 1, 160.00, TRUE),
(16, 5, 210.00, TRUE),
(17, 3, 130.00, TRUE),
(18, 6, 65.00, TRUE),
(19, 5, 95.00, TRUE),
(20, 7, 80.00, TRUE);

-- =====================================================
-- RELACIONAR VINHOS COM HARMONIZAÇÕES
-- =====================================================

-- Tintos com harmonizações de pratos
INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 1 AND h.nome IN ('Carnes vermelhas', 'Massas', 'Queijos');

-- Tintos com harmonizações de momentos
INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 1 AND v.corpo IN ('Encorpado', 'Muito Encorpado')
AND h.nome IN ('Jantares especiais', 'Celebrações', 'Noites frias');

INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 1 AND v.corpo = 'Médio'
AND h.nome IN ('Encontros casuais', 'Jantares especiais');

-- Brancos com harmonizações
INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 2 AND h.nome IN ('Peixes', 'Frutos do mar', 'Aves', 'Aperitivos');

INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 2 AND h.nome IN ('Almoços leves', 'Dias quentes', 'Happy hour');

-- Espumantes com harmonizações
INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 3 AND h.nome IN ('Aperitivos', 'Frutos do mar');

INSERT INTO vinho_harmonizacoes (vinho_id, harmonizacao_id)
SELECT v.id, h.id FROM vinhos v, harmonizacoes h
WHERE v.categoria_id = 3 AND h.nome IN ('Comemorações', 'Celebrações', 'Happy hour');

-- =====================================================
-- RELACIONAR VINHOS COM KITS
-- =====================================================

-- Kit 1 - Começar Bem
INSERT INTO kit_vinhos (kit_id, vinho_id, quantidade) VALUES
(1, 1, 1),   -- Alamos Malbec
(1, 14, 1),  -- La Linda Chardonnay
(1, 18, 1);  -- Chandon

-- Kit 2 - Jantar em Casa
INSERT INTO kit_vinhos (kit_id, vinho_id, quantidade) VALUES
(2, 3, 1),   -- D.V. Catena Cab-Malbec
(2, 6, 1),   -- Saint Felicien
(2, 16, 1);  -- Rutini Chardonnay

-- Kit 3 - Malbecs da Argentina
INSERT INTO kit_vinhos (kit_id, vinho_id, quantidade) VALUES
(3, 4, 1),   -- El Enemigo
(3, 5, 1),   -- Luigi Bosca
(3, 8, 1);   -- Bramare

-- Kit 4 - Noite Especial
INSERT INTO kit_vinhos (kit_id, vinho_id, quantidade) VALUES
(4, 9, 1),   -- Achaval Ferrer Quimera
(4, 10, 1),  -- Gran Enemigo
(4, 18, 1);  -- Chandon

-- =====================================================
-- FIM DA POPULAÇÃO DE DADOS
-- =====================================================

SELECT 'Dados inseridos com sucesso!' as resultado;
SELECT COUNT(*) as total_vinhos FROM vinhos;
SELECT COUNT(*) as total_estoque FROM estoque;
