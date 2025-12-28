-- ============================================
-- VER LANÇAMENTOS DA ELIANA (modelo correto)
-- ============================================

SELECT
    id,
    descricao,
    observacoes,
    pessoa_id,
    contrato_id,
    nucleo,
    valor_total,
    tipo
FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura'
   OR descricao LIKE '%ELIANA%'
   OR descricao LIKE '%ARQ-2025%'
ORDER BY data_competencia;
