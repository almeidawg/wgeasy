-- ============================================
-- VINCULAR OS 2 LANÇAMENTOS RESTANTES
-- ============================================

-- "Vitorio Pedreitro" = Casa (pedreiro da obra Casa)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Casa') LIMIT 1)
WHERE id = '75c22a2c-0345-426b-b424-5fbd14913501';

-- "Material" = W.G. DE ALMEIDA DESIGNER DE INTERIORES (despesa geral)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('W.G. DE ALMEIDA DESIGNER DE INTERIORES') LIMIT 1)
WHERE id = '6ea13eb6-4654-43eb-bb6a-85a2845362dc';

-- Verificar resultado final
SELECT
    CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END as status,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE nucleo = 'designer'
GROUP BY CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END;
