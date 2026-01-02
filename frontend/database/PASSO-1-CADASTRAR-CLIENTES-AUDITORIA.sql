-- ============================================
-- PASSO 1: CADASTRAR CLIENTES DA AUDITORIA
-- ============================================
-- Data: 2025-12-30
-- Objetivo: Criar clientes necessarios para importacao de lancamentos
-- ============================================

-- ============================================
-- AUDITORIA 2023 - CLIENTES
-- ============================================

-- 1. Renata Lizas Verpa
INSERT INTO pessoas (nome, tipo)
SELECT 'Renata Lizas Verpa', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Renata Lizas Verpa')
);

-- 2. Tatiana Nysp
INSERT INTO pessoas (nome, tipo)
SELECT 'Tatiana Nysp', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Tatiana Nysp')
);

-- 3. Camila Nysp 102 A
INSERT INTO pessoas (nome, tipo)
SELECT 'Camila Nysp 102 A', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Camila Nysp 102 A')
);

-- 4. Renato NYSP
INSERT INTO pessoas (nome, tipo)
SELECT 'Renato NYSP', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Renato NYSP')
);

-- ============================================
-- AUDITORIA 2022 - CLIENTES
-- ============================================

-- 5. Bruna Cunha
INSERT INTO pessoas (nome, tipo)
SELECT 'Bruna Cunha', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Bruna Cunha')
);

-- 6. Denis Szejnfeld Nebraska 871
INSERT INTO pessoas (nome, tipo)
SELECT 'Denis Szejnfeld Nebraska 871', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Denis Szejnfeld Nebraska 871')
);

-- 7. Raquel Aquino e Arthur
INSERT INTO pessoas (nome, tipo)
SELECT 'Raquel Aquino e Arthur', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Raquel Aquino e Arthur')
);

-- 8. Mauro Frazili
INSERT INTO pessoas (nome, tipo)
SELECT 'Mauro Frazili', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Mauro Frazili')
);

-- 9. Hospital Certa
INSERT INTO pessoas (nome, tipo)
SELECT 'Hospital Certa', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Hospital Certa')
);

-- 10. Denis Vitti
INSERT INTO pessoas (nome, tipo)
SELECT 'Denis Vitti', 'CLIENTE'
WHERE NOT EXISTS (
    SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('Denis Vitti')
);

-- ============================================
-- VERIFICACAO
-- ============================================
SELECT nome, tipo, created_at
FROM pessoas
WHERE nome IN (
    'Renata Lizas Verpa',
    'Tatiana Nysp',
    'Camila Nysp 102 A',
    'Renato NYSP',
    'Bruna Cunha',
    'Denis Szejnfeld Nebraska 871',
    'Raquel Aquino e Arthur',
    'Mauro Frazili',
    'Hospital Certa',
    'Denis Vitti'
)
ORDER BY nome;

-- ============================================
-- RESUMO
-- ============================================
-- Auditoria 2023: 4 clientes
-- Auditoria 2022: 6 clientes
-- Total: 10 clientes
-- ============================================
