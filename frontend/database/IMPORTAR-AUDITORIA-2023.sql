-- ============================================
-- IMPORTACAO DE LANCAMENTOS - AUDITORIA 2023
-- Clientes auditados com contratos/recibos
-- Gerado em: 2025-12-30
-- ============================================

-- ============================================
-- 1. RENATA LIZAS VERPA
-- Contrato ZapSign assinado: R$ 6.500,00
-- Projeto Arquitetonico - 3 parcelas
-- ============================================

-- Parcela 1/3 - Assinatura
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
    '2023-02-17'::date,
    2166.67,
    'Projeto Arquitetonico - Parcela 1/3 (Assinatura)',
    'entrada',
    'arquitetura',
    'pago',
    p.id,
    'AUDITORIA 2023: Contrato assinado via ZapSign em 17-20/02/2023. Cliente: Renata Lizas Verpa (CPF: 326.767.678-95). Local: Rua Franco Paulista 143, Sao Paulo. Responsavel Tecnica: Luana Ferraz Angelin da Silva (CAU/SP A273675-6). Valor total contrato: R$ 6.500,00 em 3x. RRT registrada. Projeto executivo completo com fotos pre-obra.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Renata Lizas Verpa')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-02-17'::date
    AND fl.valor_total = 2166.67
    AND fl.pessoa_id = p.id
);

-- Parcela 2/3 - 30 dias
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
    '2023-03-17'::date,
    2166.67,
    'Projeto Arquitetonico - Parcela 2/3 (+30 dias)',
    'entrada',
    'arquitetura',
    'pago',
    p.id,
    'AUDITORIA 2023: Parcela 2/3 do contrato ZapSign. Valor total: R$ 6.500,00.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Renata Lizas Verpa')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-03-17'::date
    AND fl.valor_total = 2166.67
    AND fl.pessoa_id = p.id
);

-- Parcela 3/3 - Entrega
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
    '2023-04-17'::date,
    2166.66,
    'Projeto Arquitetonico - Parcela 3/3 (Entrega)',
    'entrada',
    'arquitetura',
    'pago',
    p.id,
    'AUDITORIA 2023: Parcela final 3/3 do contrato ZapSign. Projeto entregue.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Renata Lizas Verpa')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-04-17'::date
    AND fl.valor_total = 2166.66
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 2. TATIANA NYSP (CRITICO)
-- Contrato ASSINADO: R$ 8.812,42
-- Obra executada: Ar condicionado, Drywall, Pintura
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
    '2023-11-06'::date,
    8812.42,
    'Execucao de Obra - Ar Condicionado, Drywall e Pintura (Unidade 251B)',
    'entrada',
    'engenharia',
    'pago',
    p.id,
    'AUDITORIA 2023 [CRITICO]: Contrato ASSINADO para execucao de obra em 06/11/2023. Servicos: Ar Condicionado (R$ 6.393,92 - tubulacao, drenos, acoplamento), Drywall (R$ 569,86 - fechamento buracos), Pintura (R$ 1.424,64 - emassar e preparacao). RRT Tatiana FINAL registrada. Projeto Promob: Fechamento 251B. Pedido ar-condicionado CentralAr confirmado.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Tatiana Nysp')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-11-06'::date
    AND fl.valor_total = 8812.42
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 3. CAMILA NYSP 102 A
-- Proposta: R$ 5.171,95
-- Staff, Ar Condicionado, Hidrosanitario, Finalizacoes
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
    '2023-12-10'::date,
    5171.95,
    'Execucao de Obra - Hidrosanitario, Ar Condicionado e Finalizacoes (Unidade 102A)',
    'entrada',
    'engenharia',
    'pendente',
    p.id,
    'AUDITORIA 2023 [ALERTA]: Proposta 20231210 de R$ 5.171,95. Servicos: Staff (R$ 339,20), Ar Condicionado (R$ 915,84 - tubulacao 9-24mil BTUs), Hidrosanitario (R$ 3.014,64 - deslocamento esgoto, drenos, ponto agua), Finalizacoes (R$ 902,27 - deck elevacao piso). Condicao: 60% entrada. Projeto Promob presente. SEM CONTRATO ASSINADO LOCALIZADO - verificar execucao e recebimento.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Camila Nysp 102 A')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2023-12-10'::date
    AND fl.valor_total = 5171.95
    AND fl.pessoa_id = p.id
);

-- ============================================
-- 4. RENATO NYSP (CRITICO)
-- RECIBO EMITIDO: R$ 9.438,00
-- Ar Condicionado e Vidros Sacada
-- ============================================

-- Entrada 50%
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
    '2024-02-06'::date,
    4577.43,
    'Ar Condicionado e Vidros Sacada - Entrada 50% (Unidade 95B)',
    'entrada',
    'engenharia',
    'pago',
    p.id,
    'AUDITORIA 2023 [CRITICO]: RECIBO EMITIDO em 06/02/2024 para Indiana Participacoes Imobiliarias Ltda (CNPJ 33.486.701/0001-31). Local: Rua Guararapes 305, Unidade 95 Bloco B. Proposta REV04 de R$ 9.438,00 (desc. R$ 283,14). Servicos: Clausura condensadoras marcenaria (R$ 4.576,00), Deslocamento 3 condensadoras (R$ 2.340,00), Manutencao envidracamento sacada (R$ 2.522,00). Pagamento via PIX BTG Pactual. Fotos execucao Mar/2024.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Renato NYSP')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2024-02-06'::date
    AND fl.valor_total = 4577.43
    AND fl.pessoa_id = p.id
);

-- Parcela 30 dias
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
    '2024-03-06'::date,
    2430.29,
    'Ar Condicionado e Vidros Sacada - Parcela 30 dias (Unidade 95B)',
    'entrada',
    'engenharia',
    'pago',
    p.id,
    'AUDITORIA 2023: Parcela 2/3 conforme recibo. Total contrato: R$ 9.438,00.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Renato NYSP')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2024-03-06'::date
    AND fl.valor_total = 2430.29
    AND fl.pessoa_id = p.id
);

-- Parcela 60 dias
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
    '2024-04-06'::date,
    2430.28,
    'Ar Condicionado e Vidros Sacada - Parcela 60 dias (Unidade 95B)',
    'entrada',
    'engenharia',
    'pago',
    p.id,
    'AUDITORIA 2023: Parcela final 3/3 conforme recibo. Obra executada - fotos disponiveis.'
FROM pessoas p
WHERE UPPER(p.nome) = UPPER('Renato NYSP')
AND NOT EXISTS (
    SELECT 1 FROM financeiro_lancamentos fl
    WHERE fl.data_competencia = '2024-04-06'::date
    AND fl.valor_total = 2430.28
    AND fl.pessoa_id = p.id
);

-- ============================================
-- VERIFICACAO FINAL
-- ============================================

SELECT
    p.nome as cliente,
    COUNT(fl.id) as qtd_lancamentos,
    SUM(fl.valor_total) as total_lancado,
    STRING_AGG(fl.status, ', ') as status
FROM pessoas p
LEFT JOIN financeiro_lancamentos fl ON fl.pessoa_id = p.id
WHERE p.nome IN ('Renata Lizas Verpa', 'Tatiana Nysp', 'Camila Nysp 102 A', 'Renato NYSP')
GROUP BY p.nome
ORDER BY p.nome;

-- ============================================
-- RESUMO IMPORTACAO
-- ============================================
-- Cliente                | Valor Total  | Parcelas | Status
-- -----------------------|--------------|----------|--------
-- Renata Lizas Verpa     | R$ 6.500,00  | 3        | pago
-- Tatiana Nysp           | R$ 8.812,42  | 1        | pago
-- Camila Nysp 102 A      | R$ 5.171,95  | 1        | pendente
-- Renato NYSP            | R$ 9.438,00  | 3        | pago
-- -----------------------|--------------|----------|--------
-- TOTAL                  | R$ 29.922,37 | 8        |
-- ============================================
