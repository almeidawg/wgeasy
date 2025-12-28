-- ============================================
-- RECADASTRAR CLIENTES PARA O FINANCEIRO
-- Data: 2024-12-27
-- Problema: Lançamentos com pessoa_id de pessoas que não existem
-- ============================================

-- PASSO 1: Limpar pessoa_id dos lançamentos (serão revinculados depois)
UPDATE financeiro_lancamentos
SET pessoa_id = NULL
WHERE pessoa_id IS NOT NULL;

-- Verificar
SELECT 'Lançamentos com pessoa_id NULL' as status, COUNT(*) as total
FROM financeiro_lancamentos WHERE pessoa_id IS NULL;

-- PASSO 2: Cadastrar os clientes (centros de custo)
INSERT INTO pessoas (nome, tipo)
SELECT nome, 'CLIENTE'
FROM (VALUES
    ('Alameda Surubiju - 1930'),
    ('André e Flávia'),
    ('Bruna Spezia'),
    ('Caita'),
    ('Casa'),
    ('Consultório'),
    ('Consultório Dra. Thais'),
    ('Danilo e Renata'),
    ('Davi Beck e Fabiana'),
    ('Denis Szejnfeld'),
    ('Eduardo Escaleira'),
    ('Escritório Woods'),
    ('Favorita Panamby'),
    ('Favorita Pompeia'),
    ('Fernando Cunha'),
    ('Fernando Macedo'),
    ('Fábio Luis Moreira'),
    ('José Carlos'),
    ('José Ricardo'),
    ('Laerson Phol Borre'),
    ('Lumen It'),
    ('MARIO MARIUTTI'),
    ('Mate Doce'),
    ('Michele Caldeira'),
    ('Monica Sampaio'),
    ('PORTOBELLO'),
    ('Pedro Ruiz'),
    ('Rafael Teles'),
    ('Regis 194'),
    ('Reinaldo'),
    ('Roberto Grejo'),
    ('Ronaldo Bueno (Projeto Arquitetonico )'),
    ('Rubens e Amanda'),
    ('Sasha e Livia'),
    ('Squash'),
    ('Stephanie Carvalho'),
    ('Time''s Burger e Sueli'),
    ('W.G. DE ALMEIDA DESIGNER DE INTERIORES')
) AS clientes(nome)
WHERE NOT EXISTS (SELECT 1 FROM pessoas p WHERE UPPER(p.nome) = UPPER(clientes.nome));

-- Verificar clientes cadastrados
SELECT 'Clientes cadastrados' as status, COUNT(*) as total
FROM pessoas WHERE tipo = 'CLIENTE';

-- PASSO 3: Mostrar clientes para verificação
SELECT id, nome FROM pessoas WHERE tipo = 'CLIENTE' ORDER BY nome;
