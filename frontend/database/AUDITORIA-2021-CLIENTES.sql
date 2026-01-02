-- ============================================
-- AUDITORIA 2021 - CADASTRO DE CLIENTES
-- ============================================
-- Data: 2025-12-31
-- Total: 11 clientes com contratos assinados
-- ============================================

-- 1. Mauricio Barbarulo
INSERT INTO pessoas (nome, tipo)
SELECT 'Mauricio Barbarulo', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Mauricio Barbarulo')
);

-- 2. Felipe Diorio
INSERT INTO pessoas (nome, tipo)
SELECT 'Felipe Diorio', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Felipe Diorio')
);

-- 3. Rebecca e Andre
INSERT INTO pessoas (nome, tipo)
SELECT 'Rebecca e Andre', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Rebecca e Andre')
);

-- 4. Diana Zimmer e Rodrigo
INSERT INTO pessoas (nome, tipo)
SELECT 'Diana Zimmer e Rodrigo', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Diana Zimmer e Rodrigo')
);

-- 5. Michele e Danilo
INSERT INTO pessoas (nome, tipo)
SELECT 'Michele e Danilo', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Michele e Danilo')
);

-- 6. Paloma Medeiros
INSERT INTO pessoas (nome, tipo)
SELECT 'Paloma Medeiros', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Paloma Medeiros')
);

-- 7. Helio Pereira Reboucas
INSERT INTO pessoas (nome, tipo)
SELECT 'Helio Pereira Reboucas', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Helio Pereira Reboucas')
);

-- 8. Alexandre de Souza Cavalcante
INSERT INTO pessoas (nome, tipo)
SELECT 'Alexandre de Souza Cavalcante', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Alexandre de Souza Cavalcante')
);

-- 9. Maria Aparecida
INSERT INTO pessoas (nome, tipo)
SELECT 'Maria Aparecida', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Maria Aparecida')
);

-- 10. Andre Luis
INSERT INTO pessoas (nome, tipo)
SELECT 'Andre Luis', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Andre Luis')
);

-- 11. Alziro da Silveira (Vava Rafaela)
INSERT INTO pessoas (nome, tipo)
SELECT 'Alziro da Silveira', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Alziro da Silveira')
);

-- ============================================
-- VERIFICACAO
-- ============================================
SELECT nome, tipo, created_at
FROM pessoas
WHERE nome IN (
    'Mauricio Barbarulo',
    'Felipe Diorio',
    'Rebecca e Andre',
    'Diana Zimmer e Rodrigo',
    'Michele e Danilo',
    'Paloma Medeiros',
    'Helio Pereira Reboucas',
    'Alexandre de Souza Cavalcante',
    'Maria Aparecida',
    'Andre Luis',
    'Alziro da Silveira'
)
ORDER BY nome;
