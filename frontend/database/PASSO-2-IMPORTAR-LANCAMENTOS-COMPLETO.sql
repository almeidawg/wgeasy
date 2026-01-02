-- ============================================
-- PASSO 2: IMPORTAR LANCAMENTOS DA AUDITORIA
-- ============================================
-- Data: 2025-12-30
-- Pre-requisito: Executar PASSO-1 primeiro!
-- Total: R$ 879.585,17 (2022 + 2023)
-- ============================================

-- ============================================
-- AUDITORIA 2023 - R$ 29.922,37
-- ============================================

-- RENATA LIZAS VERPA - R$ 6.500,00 (3 parcelas)
-- Contrato ZapSign 17-20/02/2023

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2023-02-17'::date, 2166.67,
    'Projeto Arquitetonico - Parcela 1/3 (Assinatura)', 'entrada', 'arquitetura', 'pago',
    p.id, 'AUDITORIA 2023: Contrato ZapSign R$ 6.500,00 em 3x. CPF: 326.767.678-95. Local: Rua Franco Paulista 143, SP.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Renata Lizas Verpa')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2023-02-17' AND fl.valor_total = 2166.67 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2023-03-17'::date, 2166.67,
    'Projeto Arquitetonico - Parcela 2/3', 'entrada', 'arquitetura', 'pago',
    p.id, 'AUDITORIA 2023: Parcela 2/3 contrato ZapSign.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Renata Lizas Verpa')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2023-03-17' AND fl.valor_total = 2166.67 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2023-04-17'::date, 2166.66,
    'Projeto Arquitetonico - Parcela 3/3 (Entrega)', 'entrada', 'arquitetura', 'pago',
    p.id, 'AUDITORIA 2023: Parcela final 3/3. Projeto entregue.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Renata Lizas Verpa')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2023-04-17' AND fl.valor_total = 2166.66 AND fl.pessoa_id = p.id);

-- TATIANA NYSP - R$ 8.812,42
-- Contrato assinado 06/11/2023

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2023-11-06'::date, 8812.42,
    'Execucao de Obra - Ar Condicionado, Drywall e Pintura (Unidade 251B)', 'entrada', 'engenharia', 'pago',
    p.id, 'AUDITORIA 2023 [CRITICO]: Contrato ASSINADO. Ar Condicionado R$6.393,92 + Drywall R$569,86 + Pintura R$1.424,64.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Tatiana Nysp')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2023-11-06' AND fl.valor_total = 8812.42 AND fl.pessoa_id = p.id);

-- CAMILA NYSP 102 A - R$ 5.171,95
-- Proposta 20231210 (sem contrato assinado localizado)

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2023-12-10'::date, 5171.95,
    'Execucao de Obra - Hidrosanitario, Ar Condicionado e Finalizacoes (Unidade 102A)', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2023 [ALERTA]: Proposta R$ 5.171,95. SEM CONTRATO ASSINADO - verificar execucao.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Camila Nysp 102 A')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2023-12-10' AND fl.valor_total = 5171.95 AND fl.pessoa_id = p.id);

-- RENATO NYSP - R$ 9.438,00 (3 parcelas)
-- Recibo emitido 06/02/2024

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2024-02-06'::date, 4577.43,
    'Ar Condicionado e Vidros Sacada - Entrada 50% (Unidade 95B)', 'entrada', 'engenharia', 'pago',
    p.id, 'AUDITORIA 2023 [CRITICO]: RECIBO EMITIDO. Indiana Participacoes CNPJ 33.486.701/0001-31. Total R$9.438,00.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Renato NYSP')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-02-06' AND fl.valor_total = 4577.43 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2024-03-06'::date, 2430.29,
    'Ar Condicionado e Vidros Sacada - Parcela 30 dias (Unidade 95B)', 'entrada', 'engenharia', 'pago',
    p.id, 'AUDITORIA 2023: Parcela 2/3 conforme recibo.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Renato NYSP')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-03-06' AND fl.valor_total = 2430.29 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2024-04-06'::date, 2430.28,
    'Ar Condicionado e Vidros Sacada - Parcela 60 dias (Unidade 95B)', 'entrada', 'engenharia', 'pago',
    p.id, 'AUDITORIA 2023: Parcela final 3/3. Obra executada com fotos.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Renato NYSP')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2024-04-06' AND fl.valor_total = 2430.28 AND fl.pessoa_id = p.id);

-- ============================================
-- AUDITORIA 2022 - R$ 849.662,80
-- ============================================

-- BRUNA CUNHA - R$ 256.000,00 (3 parcelas)
-- Contrato ZapSign assinado

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-03-15'::date, 76800.00,
    'Reforma Completa Apartamento - Entrada 30%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022 [CRITICO]: Contrato ASSINADO R$256.000,00. VERIFICAR PAGAMENTO.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Bruna Cunha')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-03-15' AND fl.valor_total = 76800.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-05-15'::date, 102400.00,
    'Reforma Completa Apartamento - Parcela 40%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela 2/3 do contrato assinado.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Bruna Cunha')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-05-15' AND fl.valor_total = 102400.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-07-15'::date, 76800.00,
    'Reforma Completa Apartamento - Parcela Final 30%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela final 3/3. VERIFICAR CONCLUSAO.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Bruna Cunha')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-07-15' AND fl.valor_total = 76800.00 AND fl.pessoa_id = p.id);

-- DENIS SZEJNFELD NEBRASKA 871 - R$ 500.000,00 (4 parcelas)
-- Contrato ZapSign 29/08/2022

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-08-29'::date, 100000.00,
    'Execucao de Obra Nebraska 871 - Entrada 20%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022 [CRITICO]: Contrato ZapSign ASSINADO R$500.000,00. Rua Nebraska 871. VERIFICAR.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld Nebraska 871')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-08-29' AND fl.valor_total = 100000.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-09-29'::date, 150000.00,
    'Execucao de Obra Nebraska 871 - Parcela 30%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela 2/4 contrato Nebraska 871.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld Nebraska 871')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-09-29' AND fl.valor_total = 150000.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-10-29'::date, 150000.00,
    'Execucao de Obra Nebraska 871 - Parcela 30%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela 3/4 contrato Nebraska 871.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld Nebraska 871')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-10-29' AND fl.valor_total = 150000.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-11-29'::date, 100000.00,
    'Execucao de Obra Nebraska 871 - Parcela Final 20%', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela final 4/4. VERIFICAR CONCLUSAO OBRA.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld Nebraska 871')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-11-29' AND fl.valor_total = 100000.00 AND fl.pessoa_id = p.id);

-- RAQUEL AQUINO E ARTHUR - R$ 45.000,00 (3 parcelas)
-- Contrato DocuSign 19/04/2022

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-04-19'::date, 15000.00,
    'Projeto Arquitetonico Alberto Hodge 856 - Entrada', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022 [CRITICO]: Contrato DocuSign ASSINADO R$45.000,00. Rua Alberto Hodge 856. VERIFICAR.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Raquel Aquino e Arthur')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-04-19' AND fl.valor_total = 15000.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-05-19'::date, 15000.00,
    'Projeto Arquitetonico Alberto Hodge 856 - Parcela 2/3', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela 2/3 contrato DocuSign.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Raquel Aquino e Arthur')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-05-19' AND fl.valor_total = 15000.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-06-19'::date, 15000.00,
    'Projeto Arquitetonico Alberto Hodge 856 - Parcela Final', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela final 3/3. VERIFICAR ENTREGA.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Raquel Aquino e Arthur')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-06-19' AND fl.valor_total = 15000.00 AND fl.pessoa_id = p.id);

-- MAURO FRAZILI - R$ 35.000,00 (3 parcelas)
-- Contrato assinado

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-06-01'::date, 10500.00,
    'Projeto de Reforma - Entrada 30%', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022 [CRITICO]: Contrato ASSINADO R$35.000,00. VERIFICAR PAGAMENTO.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Mauro Frazili')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-06-01' AND fl.valor_total = 10500.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-07-01'::date, 14000.00,
    'Projeto de Reforma - Parcela 40%', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela 2/3 contrato assinado.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Mauro Frazili')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-07-01' AND fl.valor_total = 14000.00 AND fl.pessoa_id = p.id);

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-08-01'::date, 10500.00,
    'Projeto de Reforma - Parcela Final 30%', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022: Parcela final 3/3. VERIFICAR.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Mauro Frazili')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-08-01' AND fl.valor_total = 10500.00 AND fl.pessoa_id = p.id);

-- HOSPITAL CERTA - R$ 11.512,80 (1 parcela)
-- Contrato assinado

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-09-15'::date, 11512.80,
    'Projeto Comercial Hospital Certa', 'entrada', 'arquitetura', 'pendente',
    p.id, 'AUDITORIA 2022 [CRITICO]: Contrato ASSINADO R$11.512,80. VERIFICAR PAGAMENTO E ENTREGA.'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Hospital Certa')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-09-15' AND fl.valor_total = 11512.80 AND fl.pessoa_id = p.id);

-- DENIS VITTI - R$ 2.150,00 (1 parcela)
-- Servico executado, nao pago

INSERT INTO financeiro_lancamentos (
    data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes
)
SELECT '2022-10-15'::date, 2150.00,
    'Servico de Reparo Residencial', 'entrada', 'engenharia', 'pendente',
    p.id, 'AUDITORIA 2022 [CRITICO]: Servico EXECUTADO mas NAO PAGO. COBRAR CLIENTE!'
FROM pessoas p WHERE UPPER(p.nome) = UPPER('Denis Vitti')
AND NOT EXISTS (SELECT 1 FROM financeiro_lancamentos fl WHERE fl.data_competencia = '2022-10-15' AND fl.valor_total = 2150.00 AND fl.pessoa_id = p.id);

-- ============================================
-- VERIFICACAO FINAL
-- ============================================

SELECT
    p.nome as cliente,
    COUNT(fl.id) as qtd_lancamentos,
    SUM(fl.valor_total) as total_lancado,
    STRING_AGG(DISTINCT fl.status, ', ') as status
FROM pessoas p
LEFT JOIN financeiro_lancamentos fl ON fl.pessoa_id = p.id
WHERE p.nome IN (
    'Renata Lizas Verpa', 'Tatiana Nysp', 'Camila Nysp 102 A', 'Renato NYSP',
    'Bruna Cunha', 'Denis Szejnfeld Nebraska 871', 'Raquel Aquino e Arthur',
    'Mauro Frazili', 'Hospital Certa', 'Denis Vitti'
)
GROUP BY p.nome
ORDER BY total_lancado DESC;

-- ============================================
-- RESUMO DA IMPORTACAO
-- ============================================
--
-- AUDITORIA 2023:
-- - Renata Lizas Verpa:   R$   6.500,00 (3 parcelas) - pago
-- - Tatiana Nysp:         R$   8.812,42 (1 parcela)  - pago
-- - Camila Nysp 102 A:    R$   5.171,95 (1 parcela)  - pendente
-- - Renato NYSP:          R$   9.438,00 (3 parcelas) - pago
-- SUBTOTAL 2023:          R$  29.922,37 (8 lancamentos)
--
-- AUDITORIA 2022:
-- - Bruna Cunha:          R$ 256.000,00 (3 parcelas) - VERIFICAR
-- - Denis Szejnfeld:      R$ 500.000,00 (4 parcelas) - VERIFICAR
-- - Raquel Aquino:        R$  45.000,00 (3 parcelas) - VERIFICAR
-- - Mauro Frazili:        R$  35.000,00 (3 parcelas) - VERIFICAR
-- - Hospital Certa:       R$  11.512,80 (1 parcela)  - VERIFICAR
-- - Denis Vitti:          R$   2.150,00 (1 parcela)  - NAO PAGO
-- SUBTOTAL 2022:          R$ 849.662,80 (15 lancamentos)
--
-- TOTAL GERAL:            R$ 879.585,17 (23 lancamentos)
-- ============================================
