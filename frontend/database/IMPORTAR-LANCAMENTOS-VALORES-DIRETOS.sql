-- ============================================
-- IMPORTAR LANCAMENTOS - VALORES DIRETOS
-- ============================================
-- Data: 2025-12-30
-- Total: R$ 879.585,17 (23 lancamentos)
-- ============================================

-- ============================================
-- AUDITORIA 2023 - R$ 29.922,37
-- ============================================

-- RENATA LIZAS VERPA - R$ 6.500,00 (3 parcelas)
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2023-02-17', 2166.67, 'Projeto Arquitetonico - Parcela 1/3 (Assinatura)', 'entrada', 'arquitetura', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Renata Lizas Verpa' LIMIT 1),
    'AUDITORIA 2023: Contrato ZapSign R$ 6.500,00 em 3x. CPF: 326.767.678-95.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2023-03-17', 2166.67, 'Projeto Arquitetonico - Parcela 2/3', 'entrada', 'arquitetura', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Renata Lizas Verpa' LIMIT 1),
    'AUDITORIA 2023: Parcela 2/3 contrato ZapSign.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2023-04-17', 2166.66, 'Projeto Arquitetonico - Parcela 3/3 (Entrega)', 'entrada', 'arquitetura', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Renata Lizas Verpa' LIMIT 1),
    'AUDITORIA 2023: Parcela final. Projeto entregue.');

-- TATIANA NYSP - R$ 8.812,42
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2023-11-06', 8812.42, 'Execucao de Obra - Ar Condicionado, Drywall e Pintura (Unidade 251B)', 'entrada', 'engenharia', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Tatiana Nysp' LIMIT 1),
    'AUDITORIA 2023 [CRITICO]: Contrato ASSINADO. Ar Condicionado + Drywall + Pintura.');

-- CAMILA NYSP 102 A - R$ 5.171,95
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2023-12-10', 5171.95, 'Execucao de Obra - Hidrosanitario, Ar Condicionado e Finalizacoes (Unidade 102A)', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Camila Nysp 102 A' LIMIT 1),
    'AUDITORIA 2023 [ALERTA]: Proposta R$ 5.171,95. SEM CONTRATO ASSINADO - verificar.');

-- RENATO NYSP - R$ 9.438,00 (3 parcelas)
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2024-02-06', 4577.43, 'Ar Condicionado e Vidros Sacada - Entrada 50% (Unidade 95B)', 'entrada', 'engenharia', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Renato NYSP' LIMIT 1),
    'AUDITORIA 2023 [CRITICO]: RECIBO EMITIDO. Total R$9.438,00.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2024-03-06', 2430.29, 'Ar Condicionado e Vidros Sacada - Parcela 30 dias (Unidade 95B)', 'entrada', 'engenharia', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Renato NYSP' LIMIT 1),
    'AUDITORIA 2023: Parcela 2/3 conforme recibo.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2024-04-06', 2430.28, 'Ar Condicionado e Vidros Sacada - Parcela 60 dias (Unidade 95B)', 'entrada', 'engenharia', 'pago',
    (SELECT id FROM pessoas WHERE nome = 'Renato NYSP' LIMIT 1),
    'AUDITORIA 2023: Parcela final 3/3. Obra executada.');

-- ============================================
-- AUDITORIA 2022 - R$ 849.662,80
-- ============================================

-- BRUNA CUNHA - R$ 256.000,00 (3 parcelas)
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-03-15', 76800.00, 'Reforma Completa Apartamento - Entrada 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Bruna Cunha' LIMIT 1),
    'AUDITORIA 2022 [CRITICO]: Contrato ASSINADO R$256.000,00. VERIFICAR PAGAMENTO.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-05-15', 102400.00, 'Reforma Completa Apartamento - Parcela 40%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Bruna Cunha' LIMIT 1),
    'AUDITORIA 2022: Parcela 2/3 contrato assinado.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-07-15', 76800.00, 'Reforma Completa Apartamento - Parcela Final 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Bruna Cunha' LIMIT 1),
    'AUDITORIA 2022: Parcela final 3/3. VERIFICAR CONCLUSAO.');

-- DENIS SZEJNFELD NEBRASKA 871 - R$ 500.000,00 (4 parcelas)
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-08-29', 100000.00, 'Execucao de Obra Nebraska 871 - Entrada 20%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Denis Szejnfeld Nebraska 871' LIMIT 1),
    'AUDITORIA 2022 [CRITICO]: Contrato ZapSign ASSINADO R$500.000,00. VERIFICAR.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-09-29', 150000.00, 'Execucao de Obra Nebraska 871 - Parcela 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Denis Szejnfeld Nebraska 871' LIMIT 1),
    'AUDITORIA 2022: Parcela 2/4 contrato Nebraska 871.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-10-29', 150000.00, 'Execucao de Obra Nebraska 871 - Parcela 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Denis Szejnfeld Nebraska 871' LIMIT 1),
    'AUDITORIA 2022: Parcela 3/4 contrato Nebraska 871.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-11-29', 100000.00, 'Execucao de Obra Nebraska 871 - Parcela Final 20%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Denis Szejnfeld Nebraska 871' LIMIT 1),
    'AUDITORIA 2022: Parcela final 4/4. VERIFICAR CONCLUSAO.');

-- RAQUEL AQUINO E ARTHUR - R$ 45.000,00 (3 parcelas)
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-04-19', 15000.00, 'Projeto Arquitetonico Alberto Hodge 856 - Entrada', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Raquel Aquino e Arthur' LIMIT 1),
    'AUDITORIA 2022 [CRITICO]: Contrato DocuSign ASSINADO R$45.000,00. VERIFICAR.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-05-19', 15000.00, 'Projeto Arquitetonico Alberto Hodge 856 - Parcela 2/3', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Raquel Aquino e Arthur' LIMIT 1),
    'AUDITORIA 2022: Parcela 2/3 contrato DocuSign.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-06-19', 15000.00, 'Projeto Arquitetonico Alberto Hodge 856 - Parcela Final', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Raquel Aquino e Arthur' LIMIT 1),
    'AUDITORIA 2022: Parcela final 3/3. VERIFICAR ENTREGA.');

-- MAURO FRAZILI - R$ 35.000,00 (3 parcelas)
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-06-01', 10500.00, 'Projeto de Reforma - Entrada 30%', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Mauro Frazili' LIMIT 1),
    'AUDITORIA 2022 [CRITICO]: Contrato ASSINADO R$35.000,00. VERIFICAR.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-07-01', 14000.00, 'Projeto de Reforma - Parcela 40%', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Mauro Frazili' LIMIT 1),
    'AUDITORIA 2022: Parcela 2/3 contrato assinado.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-08-01', 10500.00, 'Projeto de Reforma - Parcela Final 30%', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Mauro Frazili' LIMIT 1),
    'AUDITORIA 2022: Parcela final 3/3. VERIFICAR.');

-- HOSPITAL CERTA - R$ 11.512,80
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-09-15', 11512.80, 'Projeto Comercial Hospital Certa', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Hospital Certa' LIMIT 1),
    'AUDITORIA 2022 [CRITICO]: Contrato ASSINADO R$11.512,80. VERIFICAR.');

-- DENIS VITTI - R$ 2.150,00
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-10-15', 2150.00, 'Servico de Reparo Residencial', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Denis Vitti' LIMIT 1),
    'AUDITORIA 2022 [CRITICO]: Servico EXECUTADO mas NAO PAGO. COBRAR!');

-- ============================================
-- VERIFICACAO
-- ============================================
SELECT
    p.nome as cliente,
    fl.descricao,
    fl.valor_total,
    fl.data_competencia,
    fl.status
FROM financeiro_lancamentos fl
JOIN pessoas p ON fl.pessoa_id = p.id
WHERE fl.observacoes LIKE '%AUDITORIA%'
ORDER BY fl.valor_total DESC;

-- RESUMO
SELECT
    'Total Importado' as resumo,
    COUNT(*) as qtd_lancamentos,
    SUM(valor_total) as valor_total
FROM financeiro_lancamentos
WHERE observacoes LIKE '%AUDITORIA%';
