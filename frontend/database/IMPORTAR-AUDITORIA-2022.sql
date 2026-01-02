-- ============================================
-- IMPORTACAO DE LANCAMENTOS - AUDITORIA 2022
-- Gerado em: 2025-12-30
-- CONTRATOS ASSINADOS SEM REGISTROS FINANCEIROS
-- ============================================
-- TOTAL IDENTIFICADO: R$ 849.662,00+
-- ============================================

-- ============================================
-- 1. BRUNA CUNHA (CRITICO)
-- Contrato ASSINADO: R$ 256.000,00
-- Data: 15/Mar/2022
-- Projeto Arquitetonico completo
-- ============================================

-- Parcela 1 - Assinatura (30%)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-03-15'::date,
    76800.00,
    'Projeto Arquitetonico - Parcela 1 Assinatura (30%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022 [CRITICO]: Contrato assinado em 15/Mar/2022. Valor total: R$ 256.000,00. VERIFICAR STATUS DE PAGAMENTO - nenhum registro encontrado no sistema.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Bruna Cunha%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-03-15'::date
    AND fl.valor_total = 76800.00
    AND fl.pessoa_id = p.id
);

-- Parcelas subsequentes conforme contrato (verificar cronograma original)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-04-15'::date,
    179200.00,
    'Projeto Arquitetonico - Saldo Contrato (70%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022 [CRITICO]: Saldo do contrato Bruna Cunha. VERIFICAR CRONOGRAMA ORIGINAL E STATUS REAL.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Bruna Cunha%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-04-15'::date
    AND fl.valor_total = 179200.00
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 2. MAURO FRAZILI - CLINICA (CRITICO)
-- Contrato ASSINADO: R$ 35.000,00
-- Data: 01/Jul/2022
-- Pagamento a vista
-- ============================================

INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-07-01'::date,
    35000.00,
    'Projeto Arquitetonico Clinica - Pagamento a Vista',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022 [CRITICO]: Contrato assinado em 01/Jul/2022 para CLINICA MEDICA MAURO FRAZILI (CNPJ 09.069.633/0001-20). Valor: R$ 35.000,00 a vista. VERIFICAR STATUS DE PAGAMENTO.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Mauro Frazili%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-07-01'::date
    AND fl.valor_total = 35000.00
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 3. HOSPITAL CERTA (CRITICO)
-- Contrato ASSINADO: R$ 11.512,80
-- Data: 28/Jul/2022
-- Armarios vestiarios
-- ============================================

INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-07-28'::date,
    11512.80,
    'Marcenaria - Armarios Vestiarios Hospital',
    'entrada',
    'marcenaria',
    'pendente',
    p.id,
    'AUDITORIA 2022 [CRITICO]: Contrato assinado em 28/Jul/2022 para CERTA (CNPJ 19.423.465/0001-83). Valor: R$ 11.512,80 para armarios vestiarios. VERIFICAR STATUS DE PAGAMENTO.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Certa%') OR UPPER(p.nome) LIKE UPPER('%Hospital Certa%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-07-28'::date
    AND fl.valor_total = 11512.80
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 4. RAQUEL AQUINO & ARTHUR (CRITICO)
-- Contrato DocuSign ASSINADO: R$ 45.000,00
-- Data: 19/Abr/2022
-- Projeto Arquitetonico - Rua Alberto Hodge 856
-- ============================================

-- Parcela 1 - Assinatura (30%)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-04-24'::date,
    13500.00,
    'Projeto Arquitetonico - Parcela 1 Assinatura (30%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022 [CRITICO]: Contrato DocuSign assinado em 19/Abr/2022. Clientes: Arthur Antonioli de Araujo (CPF 223.069.498-75) e Jovenilde Raquel de Aquino (CPF 321.724.428-10). Local: Rua Alberto Hodge 856, Santo Amaro. Valor total: R$ 45.000,00. Responsavel Tecnica: Melina Silva Rodrigues (CAU/SP A183434-7). VERIFICAR PAGAMENTO.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Raquel%Arthur%') OR UPPER(p.nome) LIKE UPPER('%Arthur%Raquel%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-04-24'::date
    AND fl.valor_total = 13500.00
    AND fl.pessoa_id = p.id
);

-- Parcela 2 - Conclusao Etapa 2 (20%)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-06-01'::date,
    9000.00,
    'Projeto Arquitetonico - Parcela 2 Etapa 2 (20%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 2/5 contrato Raquel & Arthur. 20% na conclusao Etapa 2 (Anteprojeto).'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Raquel%Arthur%') OR UPPER(p.nome) LIKE UPPER('%Arthur%Raquel%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-06-01'::date
    AND fl.valor_total = 9000.00
    AND fl.pessoa_id = p.id
);

-- Parcela 3 - Conclusao Etapa 3 (20%)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-07-01'::date,
    9000.00,
    'Projeto Arquitetonico - Parcela 3 Etapa 3 (20%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 3/5 contrato Raquel & Arthur. 20% na conclusao Etapa 3 (Projeto Legal).'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Raquel%Arthur%') OR UPPER(p.nome) LIKE UPPER('%Arthur%Raquel%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-07-01'::date
    AND fl.valor_total = 9000.00
    AND fl.pessoa_id = p.id
);

-- Parcela 4 - Conclusao Etapa 4 (20%)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-08-01'::date,
    9000.00,
    'Projeto Arquitetonico - Parcela 4 Etapa 4 (20%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 4/5 contrato Raquel & Arthur. 20% na conclusao Etapa 4 (Projeto Executivo).'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Raquel%Arthur%') OR UPPER(p.nome) LIKE UPPER('%Arthur%Raquel%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-08-01'::date
    AND fl.valor_total = 9000.00
    AND fl.pessoa_id = p.id
);

-- Parcela 5 - Aprovacao Prefeitura (10%)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-09-01'::date,
    4500.00,
    'Projeto Arquitetonico - Parcela 5 Aprovacao PMSP (10%)',
    'entrada',
    'arquitetura',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela final 5/5 contrato Raquel & Arthur. 10% na aprovacao do projeto na Prefeitura.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Raquel%Arthur%') OR UPPER(p.nome) LIKE UPPER('%Arthur%Raquel%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-09-01'::date
    AND fl.valor_total = 4500.00
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 5. DENIS SZEJNFELD - NEBRASKA 871 (CRITICO)
-- Contrato ZapSign ASSINADO: R$ 500.000,00
-- Data: 29/Ago/2022
-- Execucao de Obra - Mao de Obra
-- ============================================

-- Entrada 22% - Fases 1-5 (Set-Dez/2022)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-09-01'::date,
    110000.00,
    'Execucao Obra Nebraska 871 - Entrada 22% (Fases 1-5)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022 [CRITICO]: Contrato ZapSign assinado em 29/Ago/2022. Cliente: DENIS SZEJNFELD (CPF 284.584.398-40). Local: Rua Nebraska 871, Brooklin. Valor total contrato: R$ 500.000,00. Empreitada global - mao de obra para 23 fases de construcao. Entrada 22% = R$ 110.000 para Fases 1-5 (Set-Dez/2022). VERIFICAR PAGAMENTOS.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-09-01'::date
    AND fl.valor_total = 110000.00
    AND fl.pessoa_id = p.id
);

-- 10% Fases 6-7 (Jan/2023)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2023-01-15'::date,
    50000.00,
    'Execucao Obra Nebraska 871 - Fases 6-7 (10%)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 2 contrato Denis Szejnfeld Nebraska. 10% Fases 6-7 cronograma Jan/2023.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-01-15'::date
    AND fl.valor_total = 50000.00
    AND fl.pessoa_id = p.id
);

-- 10% Fases 8-11 (Fev-Abr/2023)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2023-03-15'::date,
    50000.00,
    'Execucao Obra Nebraska 871 - Fases 8-11 (10%)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 3 contrato Denis Szejnfeld Nebraska. 10% Fases 8-11 cronograma Fev-Abr/2023.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-03-15'::date
    AND fl.valor_total = 50000.00
    AND fl.pessoa_id = p.id
);

-- 8% Fases 12-15 (Mai-Jun/2023)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2023-05-15'::date,
    40000.00,
    'Execucao Obra Nebraska 871 - Fases 12-15 (8%)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 4 contrato Denis Szejnfeld Nebraska. 8% Fases 12-15 cronograma Mai-Jun/2023.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-05-15'::date
    AND fl.valor_total = 40000.00
    AND fl.pessoa_id = p.id
);

-- 8% Fases 16-20 (Jul-Ago/2023)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2023-07-15'::date,
    40000.00,
    'Execucao Obra Nebraska 871 - Fases 16-20 (8%)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 5 contrato Denis Szejnfeld Nebraska. 8% Fases 16-20 cronograma Jul-Ago/2023.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-07-15'::date
    AND fl.valor_total = 40000.00
    AND fl.pessoa_id = p.id
);

-- 10% Fases 16-20 (Ago-Set-Out/2023)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2023-09-15'::date,
    50000.00,
    'Execucao Obra Nebraska 871 - Fases Finalizacao (10%)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela 6 contrato Denis Szejnfeld Nebraska. 10% cronograma Ago-Set-Out/2023.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-09-15'::date
    AND fl.valor_total = 50000.00
    AND fl.pessoa_id = p.id
);

-- 32% Saldo Final (Out/2023)
INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2023-10-31'::date,
    160000.00,
    'Execucao Obra Nebraska 871 - Saldo Final 32%',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2022: Parcela FINAL contrato Denis Szejnfeld Nebraska. 32% saldo final mediante entrega da obra em Out/2023.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Denis Szejnfeld')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-10-31'::date
    AND fl.valor_total = 160000.00
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 6. DENIS VITTI (CRITICO - NAO PAGO)
-- Valor: R$ 2.150,00
-- Trabalho executado, cliente nao pagou
-- ============================================

INSERT INTO financeiro_lancamentos (
    data_competencia,
    valor_total,
    descricao,
    tipo,
    nucleo,
    status,
    pessoa_id,
    observacoes
)
SELECT
    '2022-01-17'::date,
    2150.00,
    'Projeto/Servico - NAO PAGO',
    'entrada',
    'arquitetura',
    'atrasado',
    p.id,
    'AUDITORIA 2022 [CRITICO - INADIMPLENTE]: Relatorio Controlle indica R$ 2.150,00 como "Nao pago". Trabalho foi executado mas cliente nunca pagou. COBRAR OU BAIXAR COMO PERDA.'
FROM pessoas p
WHERE UPPER(p.nome) LIKE UPPER('%Denis Vitti%')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2022-01-17'::date
    AND fl.valor_total = 2150.00
    AND fl.pessoa_id = p.id
);

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
    'Bruna Cunha',
    'Mauro Frazili [Clinica]',
    'Hospital Certa',
    'Raquel Aquino & Arthur',
    'Denis Szejnfeld',
    'Denis Vitti'
)
GROUP BY p.nome
ORDER BY p.nome;

-- ============================================
-- RESUMO IMPORTACAO AUDITORIA 2022
-- ============================================
-- Cliente                    | Valor Total   | Parcelas | Status
-- ---------------------------|---------------|----------|--------
-- Bruna Cunha                | R$ 256.000,00 | 2        | pendente
-- Mauro Frazili [Clinica]    | R$  35.000,00 | 1        | pendente
-- Hospital Certa             | R$  11.512,80 | 1        | pendente
-- Raquel Aquino & Arthur     | R$  45.000,00 | 5        | pendente
-- Denis Szejnfeld (Nebraska) | R$ 500.000,00 | 7        | pendente
-- Denis Vitti                | R$   2.150,00 | 1        | atrasado
-- ---------------------------|---------------|----------|--------
-- TOTAL                      | R$ 849.662,80 | 17       |
-- ============================================
--
-- ACOES NECESSARIAS:
-- 1. Verificar status REAL de cada pagamento
-- 2. Atualizar status para 'pago' os que foram recebidos
-- 3. Denis Vitti: decidir se cobra ou baixa como perda
-- 4. Denis Szejnfeld: verificar se obra foi concluida e pagamentos recebidos
-- ============================================

