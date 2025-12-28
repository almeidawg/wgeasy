-- ============================================
-- CADASTRAR CLIENTES (CENTROS DE CUSTO)
-- Total: 38 clientes
-- ============================================

INSERT INTO pessoas (nome, tipo)
SELECT 'W.G. DE ALMEIDA DESIGNER DE INTERIORES', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('W.G. DE ALMEIDA DESIGNER DE INTERIORES'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Consultório Dra. Thais', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Consultório Dra. Thais'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Roberto Grejo', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Roberto Grejo'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Monica Sampaio', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Monica Sampaio'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Fernando Macedo', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Fernando Macedo'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Casa', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Casa'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Lumen It', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Lumen It'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Michele Caldeira', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Michele Caldeira'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Rafael Teles', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Rafael Teles'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Laerson Phol Borre', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Laerson Phol Borre'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Davi Beck e Fabiana', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Davi Beck e Fabiana'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Alameda Surubiju - 1930', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Alameda Surubiju - 1930'));

INSERT INTO pessoas (nome, tipo)
SELECT 'MARIO MARIUTTI', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('MARIO MARIUTTI'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Fábio Luis Moreira', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Fábio Luis Moreira'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Caita', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Caita'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Bruna Spezia', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Bruna Spezia'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Denis Szejnfeld', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Denis Szejnfeld'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Danilo e Renata', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Danilo e Renata'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Pedro Ruiz', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Pedro Ruiz'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Regis 194', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Regis 194'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Ronaldo Bueno (Projeto Arquitetonico )', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Ronaldo Bueno (Projeto Arquitetonico )'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Squash', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Squash'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Consultório', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Consultório'));

INSERT INTO pessoas (nome, tipo)
SELECT 'PORTOBELLO', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('PORTOBELLO'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Eduardo Escaleira', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Eduardo Escaleira'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Sasha e Livia', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Sasha e Livia'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Time''s Burger e Sueli', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Time''s Burger e Sueli'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Rubens e Amanda', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Rubens e Amanda'));

INSERT INTO pessoas (nome, tipo)
SELECT 'José Carlos', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('José Carlos'));

INSERT INTO pessoas (nome, tipo)
SELECT 'José Ricardo', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('José Ricardo'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Favorita Pompeia', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Favorita Pompeia'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Favorita Panamby', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Favorita Panamby'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Reinaldo', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Reinaldo'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Stephanie Carvalho', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Stephanie Carvalho'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Mate Doce', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Mate Doce'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Fernando Cunha', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Fernando Cunha'));

INSERT INTO pessoas (nome, tipo)
SELECT 'André e Flávia', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('André e Flávia'));

INSERT INTO pessoas (nome, tipo)
SELECT 'Escritório Woods', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Escritório Woods'));

