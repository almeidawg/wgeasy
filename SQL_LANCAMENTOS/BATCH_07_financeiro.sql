-- ============================================
-- BATCH 7 de 12 (CORRIGIDO)
-- Tabela: financeiro_lancamentos
-- Núcleo: arquitetura (WG Designer)
-- Total: 200 registros (0 ignorados com valor zero)
-- ============================================

BEGIN;

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-03-31',
    'saida',
    26.32,
    'Digital Ocean () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Despesas Jurídicas'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-03-31',
    'saida',
    200,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 1023720-3 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-03-31',
    'entrada',
    1660,
    'José Carlos () - TED RECEBIDA - <86841114272> - <JOSE CARLOS DA SILVA JUNIOR>',
    'pago',
    'arquitetura',
    'Centro: José Carlos | Conta: Original JURIDICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-03-31',
    'saida',
    350,
    'Transferência entre contas Original - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-03-31',
    'saida',
    350,
    'Transferência entre contas Original - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-02',
    'saida',
    23.4,
    'MARACA ELETRICA & HIDRAULICA LTDA () - COMPRA DEBITO NACIONAL - MARACA ELETRICA HIDRAU-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-02',
    'saida',
    30,
    'COMERCIAL DE COMBUSTIVEIS WALPETRO LTDA () - COMPRA DEBITO NACIONAL - COMERCIAL DE COMBUSTIV-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Combustivel'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-02',
    'saida',
    42.5,
    'LOJA DE CONVENIENCIA VALE DAS VIRTUDES LTDA. () - COMPRA DEBITO NACIONAL - CONVE VALE DAS VIRTUDE-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-02',
    'saida',
    12,
    'COMPRA DEBITO NACIONAL - OMTS EMPREENDIMENTOS S-COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-03',
    'saida',
    103.27,
    'GIKANY TRANSPORTE E DISTRIBUICAO DE HORTIFRUTI LTDA () - COMPRA DEBITO NACIONAL - GIKANY TRANSPORTE E DI-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-03',
    'saida',
    200,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 1023720-3 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-03',
    'saida',
    55,
    'William Almeida () - COMPRA DEBITO NACIONAL - NEI CABELEIREIRO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Pró-labore'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-06',
    'saida',
    181.25,
    'COMPRA DEBITO NACIONAL - URSULAO PIZZARIA -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-06',
    'saida',
    252.31,
    'William Almeida () - COMPRA DEBITO NACIONAL - PAO DE ACUCAR LJ 01 -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Pró-labore'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-06',
    'saida',
    59,
    'William Almeida () - COMPRA DEBITO NACIONAL - PAG*DUHBURGERS -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Pró-labore'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-06',
    'saida',
    200,
    'Transferência entre contas Original - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-06',
    'saida',
    200,
    'Transferência entre contas Original - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-07',
    'saida',
    9.5,
    'Tintas Leme () - Pintura',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-07',
    'saida',
    172.4,
    'Tintas Leme () - Pintura',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-07',
    'saida',
    327,
    'LONGTECH TECNOLOGIA DA INFORMACAO LTDA () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Sistema'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-07',
    'saida',
    49.9,
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 11/2019',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Taxa'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-08',
    'saida',
    256.42,
    'PET CENTER COMERCIO E PARTICIPACOES S.A. () - Despesa pessoal',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-08',
    'saida',
    9.89,
    'COMERCIO DE CARNES METRO LILAS LTDA () - COMPRA DEBITO NACIONAL - ACOUGUE NOVA METRO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-08',
    'saida',
    14,
    'COMPRA DEBITO NACIONAL - PAG*CARLINHOSMERC -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-08',
    'saida',
    80,
    'DANIELA G TODELO () - Transferência/TED - Banco - 341 - Ag - 2949 - Conta - 8846-8 - DANIELA G TODELO. Mascara de proteção',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-08',
    'saida',
    49.9,
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 12/2019',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Taxa'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-08',
    'saida',
    85,
    'Thiago de Jesus Silva () - Ida e Volta',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Uber'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-09',
    'saida',
    49.9,
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 01/2020',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Taxa'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-09',
    'saida',
    200,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 1023720-3 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-10',
    'saida',
    26.9,
    'Spotify () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-10',
    'saida',
    24.9,
    'D4S SERVICOS EM TECNOLOGIA LTDA () - Despesa Assintura Eletronica',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Sistema'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    23.96,
    'COMPRA DEBITO NACIONAL - POSTO COMERCIO GAS E C-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Combustivel'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    13.98,
    'COMPRA DEBITO NACIONAL - ARINELLA IMIGRANTES -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    13,
    'COMPRA DEBITO NACIONAL - PAG*BjBelaCintra -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    16.98,
    'DROGARIA SAO PAULO S.A. () - COMPRA DEBITO NACIONAL - DROG SAO PAULO 511 -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    7.96,
    'COMPRA DEBITO NACIONAL - SITIO VERDE -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    12.98,
    'COMPRA DEBITO NACIONAL - SITIO VERDE -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    43.3,
    'COMPRA DEBITO NACIONAL - MC DONALDS AJD -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    6.87,
    'COMPRA DEBITO NACIONAL - CARREFOUR 358 SBK -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    243.41,
    'COMPRA DEBITO NACIONAL - CARREFOUR 358 SBK -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-13',
    'saida',
    0.01,
    'CREDITO RECEBIVEIS ANT',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Aporte de Capital'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-15',
    'saida',
    989.22,
    'Revestimentos da parede cozinha + argamassa + rejunte',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-15',
    'saida',
    16.54,
    'COMPRA DEBITO NACIONAL - CASA BLANCA DO MORUMBI-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-15',
    'saida',
    49.9,
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 03/2020',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Taxa'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-15',
    'entrada',
    487.59,
    'PBTECH COM. E SERVICOS DE REVE () - TED RECEBIDA - <5876012000106> - <PBTECH COM. E SERVICOS DE REVE>',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Comissão'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-15',
    'saida',
    5000,
    'Dra. Thais (Eliel Fernandes) - Pagamento Eliel',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original FISICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    113.56,
    'NET () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Despesas com Escritório'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    124.12,
    'TIM () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Telefone Celular'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    179.9,
    'GETNINJAS ATIVIDADES DE INTERNET S.A. () - Recibo de compra de créditos para plataforma on line de orçamentos',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Publicidade e Propaganda'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    550,
    'José Rai Dos Santos Pereira () - Transferência/TED - Banco - 341 - Ag - 3130 - Conta - 49369-9 - JOSE RAI DOS SANTOS PEREIRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Pintor'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    150,
    'Vitorio (Santa Ferreira da Costa) - Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pedreiro'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    150,
    'Ailton () - Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - Aiton silva da CONCEIÇÃO',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pintor'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    250,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 104 - Ag - 1573 - Conta - 15734769-0 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    1000,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    1000,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-17',
    'saida',
    45.1,
    'Uber () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Cartão de Crédito | Categoria: Uber'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    111,
    'DANIELA G TODELO () - Transferência/TED - Banco - 341 - Ag - 2949 - Conta - 8846-8 - Daniela G Toledo. Compra de Mascaras proteção equipe',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    287.87,
    'Sabesp () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Água e Esgoto'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    162.83,
    'Luz Enel () - Referente ao mês de março',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas com Escritório'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    119.9,
    'MOBILECONT () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Contabilidade'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    63.21,
    'Havan () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    16.64,
    'PADARIA E CONFEITARIA FLOR DE COIMBRA LTDA () - COMPRA DEBITO NACIONAL - FLOR DE COIMBRA -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    23.75,
    'LOJA DE CONVENIENCIA VALE DAS VIRTUDES LTDA. () - COMPRA DEBITO NACIONAL - CONVE VALE DAS VIRTUDE-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    118.5,
    'COMPRA DEBITO NACIONAL - MADERO WASHINGTON LUIS-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    137.85,
    'D 26,00 Dolares - Compra de um layout para o sistema',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Publicidade e Propaganda'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    150.01,
    'Google () - Anúncios Google',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Publicidade e Propaganda'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    120,
    'Sandra Santos da Silva () - Crédito em conta',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Limpeza'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    27.54,
    'William Almeida () - COMPRA DEBITO NACIONAL - PAO DE ACUCAR LJ 01 -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Pró-labore'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    106.96,
    'William Almeida () - PGTO BOLETO DIVERSOS - #Havan - lançar como pró-labore',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Pró-labore'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    2762.74,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    2762.74,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-20',
    'saida',
    47.06,
    'Uber () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Cartão de Crédito | Categoria: Uber'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    5,
    'COMPRA DEBITO NACIONAL - GRANO MOOCA -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    327,
    'LONGTECH TECNOLOGIA DA INFORMACAO LTDA () - ',
    'pago',
    'arquitetura',
    'Centro: GRUPO WG ALMEIDA | Conta: Original JURIDICA | Categoria: Sistema'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    240,
    'Kleber - luminaria personalizada',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Original JURIDICA | Categoria: Geral'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    97.5,
    'Sumup () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Taxa'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    100,
    'Paulo Sergio Vaz Leite () - Obra Mário colocar tomadas',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    1322.74,
    'William Almeida () - PGTO BOLETO DIVERSOS - #Cartão de crédito pro labore',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Pró-labore'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    2500,
    'Dra. Thais (Eliel Fernandes) - RECEITA OBRA CONSULTORIO',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    5000,
    '',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Dinheiro | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-22',
    'saida',
    8.01,
    'Uber () - Obra Mooca',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Cartão de Crédito | Categoria: Uber'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-23',
    'saida',
    200,
    'Girlana () - Transferência/TED - Banco - 33 - Ag - 3372 - Conta - 1014580-4 - Girlana Floreno de Sales Silva',
    'pago',
    'arquitetura',
    'Centro: Rafael Teles | Conta: Original JURIDICA | Categoria: Comissão'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-23',
    'saida',
    195.35,
    'PGTO BOLETO DIVERSOS - #Compra quadros consultório',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Projeto'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-23',
    'saida',
    119.69,
    'Compra feita pelo Cartão de Credito - Obra Consultório',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Cartão de Crédito | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-23',
    'saida',
    10320,
    'Dra. Thais (Eliel Fernandes) - Venda de vários itens.',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original FISICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-23',
    'saida',
    10322,
    'Dra. Thais (Eliel Fernandes) - Pagamento Eliel',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original FISICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    600,
    'NOVA COMVEL () - Transferência/TED - Banco - 33 - Ag - 731 - Conta - 13001307-2 - NOVA COMVEL - ESPELHO',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    879,
    'JOSÉ ANTÔNIO DE BELLO () - Transferência/TED - Banco - 341 - Ag - 4055 - Conta - 17962-8 - JOSÉ ANTÔNIO DE BELLO - SISTEMA DE SOM',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    170,
    'ANDAIMES GAZA LTDA () - Transferência/TED - Banco - 341 - Ag - 7660 - Conta - 27262-1 - ANDAIMES GAZA LTDA',
    'pago',
    'arquitetura',
    'Centro: Casa | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    24,
    'LALAMOVE TECNOLOGIA (BRASIL) LTDA. () - Despesa com portador para retirada e entrega de equipamento de som.',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    500,
    'Ailton () - Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - Aiton silva da CONCEIÇÃO',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'entrada',
    2000,
    'ROBERTO GREJO () - DOC C RECEBIDO - Banco remet: 341Conta remet: 0000000617168Doc remet: 13557296881',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    1000,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-24',
    'saida',
    1000,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-25',
    'saida',
    200,
    'Toninho () - Obra Mooca',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Dinheiro | Categoria: Pintor'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-25',
    'saida',
    100,
    'MARCOS VIEIRA ROCHA () - Liberador Técnico da Marcenaria WG',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Dinheiro | Categoria: Marcenaria'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-25',
    'saida',
    5000,
    'Denis Szejnfeld () - Venda para novo cliente',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Dinheiro | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    750,
    'Any Gabrielli Barbosa Silva () - Compra sofá consultório com paulo tapeceiro da tapeçaria engenho arte. Parcela 1 de 2',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    120,
    'Renato Costa Ferreira () - Valor doação cesta básica',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    675,
    'Felipe Machado Teotnio () - Transferência/TED - Banco - 260 - Ag - 1 - Conta - 3498920-1 - Felipe Machado Teotnio',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Sistema'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    675,
    'Gabriel Queiroz do Nascimento () - Transferência/TED - Banco - 260 - Ag - 1 - Conta - 4460973-5 - Gabriel Queiroz do Nascimento',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Sistema'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    720,
    'EDIMAR RENATO SANTOS BARROS () - Transferência/TED - Banco - 290 - Ag - 1 - Conta - 2091293-7 - EDIMAR RENATO SANTOS BARROS',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Publicidade e Propaganda'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    400,
    'MARCOS ANTONIO S. PEREIRA () - Transferência/TED - Banco - 104 - Ag - 4072 - Conta - 35751-6 - Marcos Antonio S Pereira',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Elétrica'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    7123.09,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-27',
    'saida',
    7123.09,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    112.8,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    1394.98,
    'IMD COMERCIO DE MÓVEIS LTDA () - Transferência/TED - Banco - 341 - Ag - 207 - Conta - 17221-4 - IMD COMERCIO DE MÓVEIS LTDA Compra de cadeiras para consultório',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    300,
    'Renato de Assis Batista () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Dinheiro | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    16.99,
    '99 () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Cartão de Crédito | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    110.74,
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    20,
    'AUTO POSTO PARQUE ARARIBA II LTDA () - COMPRA DEBITO NACIONAL - POSTO PARQUE ARARIBA -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    100,
    'Simone Ferreira Das Neves () - Toninho pintor - Obra Mooca',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pintor'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    150,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 104 - Ag - 1573 - Conta - 15734769-0 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    328,
    'LUIS FERNANDO DI GEROLAMO FANGEN () - Transferência/TED - Banco - 341 - Ag - 3753 - Conta - 19858-3 - LUIS FERNANDO DI GEROLAMO FANGEN',
    'pago',
    'arquitetura',
    'Centro: Casa | Conta: Original JURIDICA | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    200,
    'MARCOS VIEIRA ROCHA () - Transferência/TED - Banco - 104 - Ag - 612 - Conta - 132446-4 - MARCOS VIEIRA ROCHA',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Original JURIDICA | Categoria: Marcenaria'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-29',
    'saida',
    59.23,
    'Uber () - Obra Mooca',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Cartão de Crédito | Categoria: Uber'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    300,
    'Renato de Assis Batista () - Transferência/TED - Banco - 104 - Ag - 4092 - Conta - 22065-6 - Renato de Assis Batista',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    121.05,
    'CARREFOUR COMERCIO E INDUSTRIA LTDA () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Dinheiro | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    74.38,
    'RAPPI BRASIL INTERMEDIACAO DE NEGOCIOS LTDA () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    300,
    'Ailton () - Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - Aiton silva da CONCEIÇÃO',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pintor'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    300,
    'Edinaldo Cosme de Arruda () - Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Caçamba'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    150,
    'Vera Lucia Miranda De Brito Andr () - Transferência/TED - Banco - 104 - Ag - 1367 - Conta - 32017-0 - Vera Lucia Miranda De Brito Andr',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    31,
    'APOIO TINTAS CENTER MATERIAIS PARA CONSTRUCAO - EIRELI () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-04-30',
    'saida',
    128.26,
    'C & C CASA E CONSTRUCAO LTDA. () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    260,
    'Renato de Assis Batista () - Transferência/TED - Banco - 104 - Ag - 4092 - Conta - 22065-6 - Renato de Assis Batista. Material e mão de obra rodapé',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    14.36,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Casa | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    798.94,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA. Pedido de reembolso solicitado',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    88.82,
    'ASTURIAS AUTO POSTO LTDA () - COMPRA DEBITO NACIONAL - ASTURIAS AUTO POSTO LT-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Combustivel'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    9,
    'OMTS EMPREENDIMENTOS SPE LTDA () - COMPRA DEBITO NACIONAL - OMTS EMPREENDIMENTOS S-COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Estacionamento'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    50,
    'ANTONIO JOSE DA SILVA PET SHOP () - COMPRA DEBITO NACIONAL - PET SHOP RACA FORTE -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    196,
    'Renew Decor Comércio e serv de móve () - Transferência/TED - Banco - 422 - Ag - 3 - Conta - 582435-2 - Renew Decor Comércio e serv de móve. Compra mercadoria marcenaria cliente Denis, pago em Ted 196,00 mais 3400,00 em espécie',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Marcenaria'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-04',
    'saida',
    3400,
    'Renew Decor Comércio e serv de móve () - Compra mercadoria marcenaria cliente Denis, pago em Ted 196,00 mais 3400,00 em espécie',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Dinheiro | Categoria: Marcenaria'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-05',
    'saida',
    13.9,
    '99 () - ',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Cartão de Crédito | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-05',
    'saida',
    13,
    'LALAMOVE TECNOLOGIA (BRASIL) LTDA. () - Despesa com portador retirada de documentos contabilidade',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-05',
    'saida',
    10.1,
    '99 () - ',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Cartão de Crédito | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-05',
    'saida',
    9.75,
    'MECTIO COMERCIO DE SALGADOS LTDA () - COMPRA DEBITO NACIONAL - PASTELARIA MECTIO -SAO PAULO-BRA. Café despesa Cleinte Denis',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-05',
    'saida',
    100,
    'MARCOS VIEIRA ROCHA () - Medição técnica',
    'pago',
    'arquitetura',
    'Centro: Monica e Paulo | Conta: Original JURIDICA | Categoria: Marcenaria'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-06',
    'saida',
    800,
    'Larissa Maria Rosrigues Bezerra () - Despesa com arquiteta do projeto',
    'pago',
    'arquitetura',
    'Centro: Ronaldo Bueno (Projeto Arquitetonico ) | Conta: Original JURIDICA | Categoria: Projeto'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-06',
    'saida',
    150,
    'David Ferreira () - Montagem banheiros',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: A definir | Categoria: Marcenaria'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-07',
    'saida',
    97.95,
    'PGTO BOLETO DIVERSOS - #Rrt Monica',
    'pago',
    'arquitetura',
    'Centro: Monica Sampaio | Conta: Original JURIDICA | Categoria: Projeto'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-07',
    'saida',
    1660,
    'José Carlos () - ',
    'pago',
    'arquitetura',
    'Centro: José Carlos | Conta: Original JURIDICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-08',
    'saida',
    300,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 104 - Ag - 1573 - Conta - 15734769-0 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-08',
    'saida',
    300,
    'Ailton () - Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - Aiton silva da CONCEIÇÃO',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-08',
    'entrada',
    45.76,
    'DOC C RECEBIDO - Banco remet: 341Conta remet: 0000000357186Doc remet: 13854786000156',
    'pago',
    'arquitetura',
    'Centro: Mario Mariutti | Conta: Original JURIDICA | Categoria: Comissão'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-09',
    'saida',
    126.33,
    'Uber () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Dinheiro | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-10',
    'saida',
    26.9,
    'Spotify () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-10',
    'saida',
    400,
    'Jessica () - Marketing digital ads e facebook',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Publicidade e Propaganda'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    80.93,
    'LEO MADEIRAS, MAQUINAS E FERRAGENS S.A. () - Transferência/TED - Banco - 341 - Ag - 912 - Conta - 2624-2 - LEO MADEIRAS MÁQUINAS E FERRAGENS',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    428.81,
    'YAPAY PAGAMENTOS ONLINE LTDA () - PGTO BOLETO DIVERSOS - #leds marcenaria Denis',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    9.5,
    'Antonio José Pereira dos Santos () - COMPRA DEBITO NACIONAL - PAG*AntonioJosePereir -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    126,
    'Uber () - COMPRA DEBITO NACIONAL - PAG*AdailtonFigueredo -SAO BERNARDO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    49.9,
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 04/2020',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Taxa'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    250,
    'Edinaldo Cosme de Arruda () - Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Caçamba'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-11',
    'saida',
    798.94,
    'Dra. Thais (Eliel Fernandes) - Pagamento Eliel',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original FISICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    64.8,
    'MARACA ELETRICA & HIDRAULICA LTDA () - COMPRA DEBITO NACIONAL - MARACA ELETRICA HIDRAU-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    192.5,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    111.78,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA - PINTURA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    52.56,
    '99 () - COMPRA DEBITO NACIONAL - PAG*appmotorista -DIADEMA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    15.7,
    '99 () - COMPRA DEBITO NACIONAL - PAG*Perfumehinode -CARAPICUIBA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    41,
    '99 () - COMPRA DEBITO NACIONAL - PAG*OtavioPaulo -OSASCO-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    31.76,
    '99 () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Transporte'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    26,
    'PATRICIA PAHOR D AVILA 22472165870 () - COMPRA DEBITO NACIONAL - LUCCI BABY IMPORTADOS -VARGEM GRANDE-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    5.9,
    'COMPRA DEBITO NACIONAL - CACAU SHOW THE SQUARE -COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    12.79,
    'CARREFOUR COMERCIO E INDUSTRIA LTDA () - COMPRA DEBITO NACIONAL - MARKET GRANJA VIANA -COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    4.39,
    'CARREFOUR COMERCIO E INDUSTRIA LTDA () - COMPRA DEBITO NACIONAL - MARKET GRANJA VIANA -COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'saida',
    17.77,
    'CARREFOUR COMERCIO E INDUSTRIA LTDA () - COMPRA DEBITO NACIONAL - MARKET GRANJA VIANA -COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-12',
    'entrada',
    2000,
    'ROBERTO GREJO () - DOC C RECEBIDO - Banco remet: 341Conta remet: 0000000617168Doc remet: 13557296881',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-13',
    'saida',
    700,
    'Ailton () - Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - Aiton silva da CONCEIÇÃO',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-13',
    'saida',
    600,
    'Josemar Joaquim de Souza () - Transferência/TED - Banco - 104 - Ag - 1573 - Conta - 15734769-0 - Josemar Joaquim de Souza',
    'pago',
    'arquitetura',
    'Centro: Roberto Grejo | Conta: Original JURIDICA | Categoria: Coordenador de obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-14',
    'saida',
    97.47,
    '',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Material Elétrica'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-14',
    'saida',
    7.5,
    '',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-14',
    'saida',
    11,
    '',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: A definir | Categoria: Estacionamento'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-14',
    'saida',
    150,
    'Diária',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-14',
    'saida',
    400,
    'MARCOS ANTONIO S. PEREIRA () - Depósito Marcos',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    20.9,
    'Telha Norte () - COMPRA DEBITO NACIONAL - TELHA NORTE -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    60,
    'ANTÔNIO CARLOS MARTIN () - Transferência/TED - Banco - 1 - Ag - 52 - Conta - 116653-0 - ANTÔNIO CARLOS MARTIN',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    770,
    'Vera Lucia Miranda De Brito Andr () - Transferência/TED - Banco - 104 - Ag - 1367 - Conta - 32017-0 - Vera Lucia Miranda De Brito Andr',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Pintura'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    3363.48,
    'Dra. Thais (Eliel Fernandes) - Pagamento Eliel',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original FISICA | Categoria: Obra'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    3363.48,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    3363.48,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    698.94,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original FISICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-15',
    'saida',
    698.94,
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Transferência'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-16',
    'saida',
    26.9,
    'Spotify () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-17',
    'saida',
    85.5,
    'A.E.H. DE MOURA RESTAURANTE () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Cartão de Crédito | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-17',
    'saida',
    74,
    'CABANA BURGER RESTAURANTE E LANCHONETE S.A () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-17',
    'saida',
    13.98,
    'EG AUTO POSTO LTDA () - ',
    'pago',
    'arquitetura',
    'Centro:  | Conta: A definir | Categoria: Despesas Pessoais'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    327.19,
    'COMPRA DEBITO NACIONAL - LEROY MERLIN MORUMBI -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    19.99,
    'DROGARIA SAO PAULO S.A. () - COMPRA DEBITO NACIONAL - DROGARIA SAO PAULO -SAO PAULO-BRA - MASCARAS',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    308,
    'MOZEC COMERCIO DE MOVEIS E FERRAGENS LTDA () - COMPRA DEBITO NACIONAL - PAG*Mozec -SAO PAULO-BRA - Obras consultório e Denis',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    22.47,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - ',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original FISICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    150.82,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - ',
    'pago',
    'arquitetura',
    'Centro: Denis Szejnfeld | Conta: Original FISICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    153.9,
    'LEROY MERLIN COMPANHIA BRASILEIRA DE BRICOLAGEM () - ',
    'pago',
    'arquitetura',
    'Centro: Casa | Conta: Original FISICA | Categoria: Material'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    27,
    'OMTS EMPREENDIMENTOS SPE LTDA () - COMPRA DEBITO NACIONAL - OMTS EMPREENDIMENTOS S-COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Estacionamento'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    68.87,
    'EG AUTO POSTO LTDA () - COMPRA DEBITO NACIONAL - EG AUTO POSTO -SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Combustivel'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    38,
    'GRANPCBN LANCHONETE EIRELI () - COMPRA DEBITO NACIONAL - GRANPCBN LANCHONETE EI-COTIA-BRA',
    'pago',
    'arquitetura',
    'Centro: Consultório Dra. Thais | Conta: Original JURIDICA | Categoria: Alimentação'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    200,
    'Ana Carolina Vilela Almeida () - Quitação de débito, um dos débitos lançados com valor de 1.000,00 pagando 200,00',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Dívida'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    175,
    'MARIANA CRISTINA DA SILVA 27384146801 () - ',
    'pago',
    'arquitetura',
    'Centro: Escritório Woods | Conta: Original JURIDICA | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    108,
    'IMPRIMAGEM SERVICOS LTDA () - COMPRA DEBITO NACIONAL - IMPRIMAGEM SERVICOS LT-SAO PAULO-BRA',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Original JURIDICA | Categoria: Gráfica'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    2.1,
    'CONCESSIONARIA DO RODOANEL OESTE S.A. () - Padroeira Interna',
    'pago',
    'arquitetura',
    'Centro:  | Conta: Dinheiro | Categoria: Diversos'
);

INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '2020-05-18',
    'saida',
    2.1,
    'CONCESSIONARIA DO RODOANEL OESTE S.A. () - Regis Externa',
    'pago',
    'arquitetura',
    'Centro: Regis 194 | Conta: Dinheiro | Categoria: Diversos'
);

COMMIT;

-- Total de registros neste batch: 200
-- Ignorados (valor zero): 0
