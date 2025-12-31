-- ============================================
-- BATCH 12 de 12 (CORRIGIDO)
-- Tabela: financeiro_lancamentos
-- Núcleo: arquitetura (WG Designer)
-- Total: 13 registros (2 ignorados com valor zero)
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
    '2025-08-05',
    'saida',
    250,
    'Lourivaldo - Pintura',
    'pago',
    'arquitetura',
    'Centro: Marina Wickbold | Conta: Dinheiro | Categoria: Pintor'
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
    '2025-08-05',
    'saida',
    250,
    'Lourivaldo - Pintura',
    'pago',
    'arquitetura',
    'Centro: Luli e Cabeto | Conta: Dinheiro | Categoria: Pintor'
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
    '2025-08-05',
    'saida',
    300,
    'Lourivaldo - Pintura',
    'pago',
    'arquitetura',
    'Centro: Mari Wickbold | Conta: Btg | Categoria: Pintor'
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
    '2025-08-08',
    'saida',
    425,
    'Josemar - assentamento pisos',
    'pago',
    'arquitetura',
    'Centro: Luli & Cabeto | Conta: Btg | Categoria: Coordenador'
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
    '2025-08-08',
    'saida',
    280,
    'Venancio - assentamento pisos',
    'pago',
    'arquitetura',
    'Centro: Mari Wickbold | Conta: Btg | Categoria: Azulegista'
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
    '2025-08-08',
    'saida',
    280,
    'Venancio - assentamento pisos - extra para descontar de saldo de 2500,00 saldo',
    'pago',
    'arquitetura',
    'Centro: Mari Wickbold | Conta: Btg | Categoria: Azulegista'
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
    '2025-08-08',
    'saida',
    280,
    'Wellington Melo - -',
    'pago',
    'arquitetura',
    'Centro: Mari Wickbold | Conta: Btg | Categoria: Coordenador'
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
    '2025-08-15',
    'saida',
    484,
    'Ney - frete porta de vidro para showroom',
    'pago',
    'arquitetura',
    'Centro: Moma | Conta: Btg | Categoria: Frete'
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
    '2025-08-15',
    'saida',
    425,
    'Josemar - Obra Luli e Cabeto',
    'pago',
    'arquitetura',
    'Centro: Luli e Cabeto | Conta: Btg | Categoria: Coordenador'
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
    '2025-08-15',
    'saida',
    300,
    'David - frete peças de assitencia marcenaria',
    'pago',
    'arquitetura',
    'Centro: Wg Marcenaria | Conta: Btg | Categoria: Frete'
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
    '2025-08-15',
    'saida',
    2000,
    'Marcos - infra de ar cliente MOMA',
    'pago',
    'arquitetura',
    'Centro: Eliana e Edu | Conta: Btg | Categoria: Ar Condicionado'
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
    '2025-08-15',
    'saida',
    300,
    'Wellington Melo - -',
    'pago',
    'arquitetura',
    'Centro: Mari Wickbold | Conta: Btg | Categoria: Coordenador'
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
    '2025-08-15',
    'saida',
    300,
    'Wellington Melo - -',
    'pago',
    'arquitetura',
    'Centro: Moma | Conta: Btg | Categoria: Coordenador'
);

COMMIT;

-- Total de registros neste batch: 13
-- Ignorados (valor zero): 2
