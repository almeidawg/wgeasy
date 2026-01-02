-- ============================================
-- AUDITORIA 2021 - LANCAMENTOS FINANCEIROS
-- ============================================
-- Data: 2025-12-31
-- Total: R$ 696.282,00 (11 contratos)
-- ============================================

-- ============================================
-- 1. MAURICIO BARBARULO - R$ 75.000,00
-- Contrato 05/07/2021 - Execucao de Obra
-- Local: Rua Henri Dunant 792, Sao Paulo
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-05', 22500.00, 'Execucao de Obra Henri Dunant 792 - Entrada 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Mauricio Barbarulo' LIMIT 1),
    'AUDITORIA 2021 [CRITICO]: Contrato ASSINADO R$75.000,00. Local: Rua Henri Dunant 792. VERIFICAR PAGAMENTO.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-08-05', 30000.00, 'Execucao de Obra Henri Dunant 792 - Parcela 40%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Mauricio Barbarulo' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/3 contrato assinado.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-09-05', 22500.00, 'Execucao de Obra Henri Dunant 792 - Parcela Final 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Mauricio Barbarulo' LIMIT 1),
    'AUDITORIA 2021: Parcela final 3/3. VERIFICAR CONCLUSAO.');

-- ============================================
-- 2. FELIPE DIORIO - R$ 31.000,00
-- Contrato 07/06/2021 - Projeto Arquitetonico
-- Local: Rua Michigan 531, Sao Paulo
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-06-07', 10333.33, 'Projeto Arquitetonico Michigan 531 - Entrada', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Felipe Diorio' LIMIT 1),
    'AUDITORIA 2021 [CRITICO]: Contrato ASSINADO R$31.000,00. Local: Rua Michigan 531. VERIFICAR.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-07', 10333.33, 'Projeto Arquitetonico Michigan 531 - Parcela 2/3', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Felipe Diorio' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/3 contrato assinado.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-08-07', 10333.34, 'Projeto Arquitetonico Michigan 531 - Parcela Final', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Felipe Diorio' LIMIT 1),
    'AUDITORIA 2021: Parcela final 3/3. VERIFICAR ENTREGA.');

-- ============================================
-- 3. REBECCA E ANDRE - R$ 71.482,00
-- Contrato 26/07/2021 - Execucao de Obra
-- Local: Av. Alberto de Zagottis 897, Sao Paulo
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-26', 21444.60, 'Execucao de Obra Alberto Zagottis 897 - Entrada 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Rebecca e Andre' LIMIT 1),
    'AUDITORIA 2021 [CRITICO]: Contrato ASSINADO R$71.482,00. Local: Av. Alberto de Zagottis 897. VERIFICAR.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-08-26', 28592.80, 'Execucao de Obra Alberto Zagottis 897 - Parcela 40%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Rebecca e Andre' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/3 contrato assinado.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-09-26', 21444.60, 'Execucao de Obra Alberto Zagottis 897 - Parcela Final 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Rebecca e Andre' LIMIT 1),
    'AUDITORIA 2021: Parcela final 3/3. VERIFICAR CONCLUSAO.');

-- ============================================
-- 4. DIANA ZIMMER E RODRIGO - R$ 58.000,00
-- Contrato 13/05/2021 - Execucao de Obra
-- Local: Rua Princesa Isabel 17, Brooklin - Apto 53 Bloco A
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-05-14', 23200.00, 'Execucao de Obra Princesa Isabel 17 - Entrada 40%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021 [CRITICO]: Contrato ASSINADO R$58.000,00. Local: Rua Princesa Isabel 17, Apto 53 Bloco A. Pagamento: 40% entrada + 6 parcelas quinzenais.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-05-28', 5800.00, 'Execucao de Obra Princesa Isabel 17 - Parcela 1/6', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021: Parcela quinzenal 1/6.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-06-11', 5800.00, 'Execucao de Obra Princesa Isabel 17 - Parcela 2/6', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021: Parcela quinzenal 2/6.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-06-25', 5800.00, 'Execucao de Obra Princesa Isabel 17 - Parcela 3/6', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021: Parcela quinzenal 3/6.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-09', 5800.00, 'Execucao de Obra Princesa Isabel 17 - Parcela 4/6', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021: Parcela quinzenal 4/6.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-23', 5800.00, 'Execucao de Obra Princesa Isabel 17 - Parcela 5/6', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021: Parcela quinzenal 5/6.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-08-06', 5800.00, 'Execucao de Obra Princesa Isabel 17 - Parcela Final 6/6', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Diana Zimmer e Rodrigo' LIMIT 1),
    'AUDITORIA 2021: Parcela quinzenal final 6/6. VERIFICAR CONCLUSAO.');

-- ============================================
-- 5. MICHELE E DANILO - R$ 65.000,00
-- Contrato 14/09/2021 - Execucao de Obra
-- Local: Rua Dr. Samuel de Castro Neves 148, Vila Cruzeiro - Apto 61 Esplanada
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-09-27', 26000.00, 'Execucao de Obra Esplanada - Entrada 40%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Michele e Danilo' LIMIT 1),
    'AUDITORIA 2021 [CRITICO]: Contrato ASSINADO R$65.000,00. Local: Rua Dr. Samuel de Castro Neves 148, Apto 61. Prazo: 65 dias uteis.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-10-14', 7800.00, 'Execucao de Obra Esplanada - Parcela 2', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Michele e Danilo' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/6 conforme contrato.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-10-29', 7800.00, 'Execucao de Obra Esplanada - Parcela 3', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Michele e Danilo' LIMIT 1),
    'AUDITORIA 2021: Parcela 3/6 conforme contrato.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-11-15', 7800.00, 'Execucao de Obra Esplanada - Parcela 4', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Michele e Danilo' LIMIT 1),
    'AUDITORIA 2021: Parcela 4/6 conforme contrato.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-11-30', 7800.00, 'Execucao de Obra Esplanada - Parcela 5', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Michele e Danilo' LIMIT 1),
    'AUDITORIA 2021: Parcela 5/6 conforme contrato.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-12-09', 7800.00, 'Execucao de Obra Esplanada - Parcela Final', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Michele e Danilo' LIMIT 1),
    'AUDITORIA 2021: Parcela final 6/6. Previsao entrega 09/12/2021.');

-- ============================================
-- 6. PALOMA MEDEIROS - R$ 6.300,00
-- Proposta 20/09/2021 - Projeto Arquitetonico
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-09-20', 6300.00, 'Projeto Arquitetonico Completo', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Paloma Medeiros' LIMIT 1),
    'AUDITORIA 2021: Proposta R$6.300,00. Projeto executivo completo com modelagem 3D. VERIFICAR ASSINATURA CONTRATO.');

-- ============================================
-- 7. HELIO PEREIRA REBOUCAS - R$ 340.000,00
-- Contrato 20/07/2021 - Execucao de Obra + Marcenaria
-- Local: Estrada Sao Francisco 2701, Taboao da Serra - Torre 4 Rouxinol Apto 281
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-20', 238000.00, 'Execucao de Obra Ecos Natura Club - Entrada 70%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Helio Pereira Reboucas' LIMIT 1),
    'AUDITORIA 2021 [CRITICO]: Contrato ASSINADO R$340.000,00. Local: Estrada Sao Francisco 2701, Torre 4 Apto 281. Inclui: Marcenaria R$146.500 + Obra R$117.000 + Diversos R$76.500.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-12-10', 102000.00, 'Execucao de Obra Ecos Natura Club - Saldo Final 30%', 'entrada', 'engenharia', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Helio Pereira Reboucas' LIMIT 1),
    'AUDITORIA 2021: Saldo final 30% na entrega. Previsao: 10/12/2021. Prazo obra: 120 dias uteis.');

-- ============================================
-- 8. ALEXANDRE DE SOUZA CAVALCANTE - R$ 11.000,00
-- Contrato 17/05/2021 - Marcenaria
-- Local: Rua Felix Fagundes 389, Jardim Germania
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-05-19', 4000.00, 'Marcenaria Guarda Roupas e Comoda - Entrada', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alexandre de Souza Cavalcante' LIMIT 1),
    'AUDITORIA 2021: Contrato ASSINADO R$11.000,00. Local: Rua Felix Fagundes 389. Itens: Guarda Roupas 3 portas + Comoda.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-06-19', 1400.00, 'Marcenaria Guarda Roupas e Comoda - Parcela 2', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alexandre de Souza Cavalcante' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/6 via cartao de credito.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-19', 1400.00, 'Marcenaria Guarda Roupas e Comoda - Parcela 3', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alexandre de Souza Cavalcante' LIMIT 1),
    'AUDITORIA 2021: Parcela 3/6 via cartao de credito.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-08-19', 1400.00, 'Marcenaria Guarda Roupas e Comoda - Parcela 4', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alexandre de Souza Cavalcante' LIMIT 1),
    'AUDITORIA 2021: Parcela 4/6 via cartao de credito.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-09-19', 1400.00, 'Marcenaria Guarda Roupas e Comoda - Parcela 5', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alexandre de Souza Cavalcante' LIMIT 1),
    'AUDITORIA 2021: Parcela 5/6 via cartao de credito.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-10-19', 1400.00, 'Marcenaria Guarda Roupas e Comoda - Parcela Final', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alexandre de Souza Cavalcante' LIMIT 1),
    'AUDITORIA 2021: Parcela final 6/6 via cartao de credito.');

-- ============================================
-- 9. MARIA APARECIDA - R$ 13.500,00
-- Contrato 24/05/2021 - Marcenaria Cozinha
-- Local: Rua Fernandes Moreira 1113, Chacara Santo Antonio
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-05-26', 5000.00, 'Marcenaria Cozinha - Entrada', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Maria Aparecida' LIMIT 1),
    'AUDITORIA 2021: Contrato ASSINADO R$13.500,00. Local: Rua Fernandes Moreira 1113. Item: Cozinha completa.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-06-05', 2000.00, 'Marcenaria Cozinha - Parcela 2', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Maria Aparecida' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/3.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-07-28', 6500.00, 'Marcenaria Cozinha - Parcela Final', 'entrada', 'marcenaria', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Maria Aparecida' LIMIT 1),
    'AUDITORIA 2021: Parcela final 3/3 via cartao de credito.');

-- ============================================
-- 10. ANDRE LUIS - R$ 5.000,00
-- Contrato 13/05/2021 - Projeto Arquitetonico
-- Local: Rua Sao Jose 36, Alto da Boa Vista - Apto 0187 Landscape
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-05-13', 2500.00, 'Projeto Arquitetonico Landscape - Entrada', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Andre Luis' LIMIT 1),
    'AUDITORIA 2021: Contrato ASSINADO R$5.000,00. Local: Rua Sao Jose 36, Apto 0187 - Empreendimento Landscape Alto da Boa Vista. Area: 80m2.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2021-06-13', 2500.00, 'Projeto Arquitetonico Landscape - Parcela Final', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Andre Luis' LIMIT 1),
    'AUDITORIA 2021: Parcela final 2/2 na entrega do projeto executivo.');

-- ============================================
-- 11. ALZIRO DA SILVEIRA (VAVA RAFAELA) - R$ 20.000,00
-- Contrato 08/12/2021 - Projeto Arquitetonico
-- Local: Av. Jabaquara 2940, Sala 106
-- ============================================
INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-01-15', 5000.00, 'Projeto Arquitetonico Casa - Parcela 1/4', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alziro da Silveira' LIMIT 1),
    'AUDITORIA 2021: Contrato ASSINADO 08/12/2021 R$20.000,00. Cliente: Alziro da Silveira. Pagamento em 4 parcelas de Jan a Abr 2022.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-02-15', 5000.00, 'Projeto Arquitetonico Casa - Parcela 2/4', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alziro da Silveira' LIMIT 1),
    'AUDITORIA 2021: Parcela 2/4 conforme contrato.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-03-15', 5000.00, 'Projeto Arquitetonico Casa - Parcela 3/4', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alziro da Silveira' LIMIT 1),
    'AUDITORIA 2021: Parcela 3/4 conforme contrato.');

INSERT INTO financeiro_lancamentos (data_competencia, valor_total, descricao, tipo, nucleo, status, pessoa_id, observacoes)
VALUES ('2022-04-15', 5000.00, 'Projeto Arquitetonico Casa - Parcela Final 4/4', 'entrada', 'arquitetura', 'pendente',
    (SELECT id FROM pessoas WHERE nome = 'Alziro da Silveira' LIMIT 1),
    'AUDITORIA 2021: Parcela final 4/4. VERIFICAR ENTREGA PROJETO.');

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
WHERE fl.observacoes LIKE '%AUDITORIA 2021%'
ORDER BY fl.data_competencia;

-- RESUMO
SELECT
    'Total Auditoria 2021' as resumo,
    COUNT(*) as qtd_lancamentos,
    SUM(valor_total) as valor_total
FROM financeiro_lancamentos
WHERE observacoes LIKE '%AUDITORIA 2021%';
