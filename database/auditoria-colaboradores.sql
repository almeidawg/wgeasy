-- ============================================================
-- AUDITORIA DE COLABORADORES - WG Easy
-- Script para análise de datas de início e duplicatas
-- ============================================================

-- ============================================================
-- PARTE 1: ANÁLISE DE DATAS DE INÍCIO DOS COLABORADORES
-- ============================================================

-- 1.1 Listar todos os colaboradores com suas datas atuais
SELECT
    p.id,
    p.nome,
    p.email,
    p.cpf,
    p.criado_em AS data_cadastro_sistema,
    p.ativo
FROM pessoas p
WHERE p.tipo = 'COLABORADOR'
ORDER BY p.nome;

-- 1.2 Buscar primeiro pagamento de cada colaborador em colaborador_valores_receber
SELECT
    p.id AS pessoa_id,
    p.nome,
    MIN(cvr.data_pagamento) AS primeiro_pagamento_recebido,
    MIN(cvr.criado_em) AS primeiro_registro_valor,
    COUNT(cvr.id) AS total_pagamentos
FROM pessoas p
LEFT JOIN colaborador_valores_receber cvr ON cvr.colaborador_id = p.id
WHERE p.tipo = 'COLABORADOR'
GROUP BY p.id, p.nome
ORDER BY primeiro_pagamento_recebido NULLS LAST;

-- 1.3 Buscar primeiro lançamento financeiro relacionado a cada colaborador
SELECT
    p.id AS pessoa_id,
    p.nome,
    MIN(fl.data_pagamento) AS primeiro_pagamento_financeiro,
    MIN(fl.created_at) AS primeiro_lancamento_criado,
    MIN(fl.data_competencia) AS primeira_competencia,
    COUNT(fl.id) AS total_lancamentos
FROM pessoas p
LEFT JOIN financeiro_lancamentos fl ON fl.pessoa_id = p.id
WHERE p.tipo = 'COLABORADOR'
GROUP BY p.id, p.nome
ORDER BY primeiro_pagamento_financeiro NULLS LAST;

-- 1.4 Buscar primeira solicitação de pagamento como beneficiário
SELECT
    p.id AS pessoa_id,
    p.nome,
    MIN(sp.data_pagamento) AS primeiro_pagamento_solicitacao,
    MIN(sp.criado_em) AS primeira_solicitacao_criada,
    COUNT(sp.id) AS total_solicitacoes
FROM pessoas p
LEFT JOIN solicitacoes_pagamento sp ON sp.beneficiario_id = p.id
WHERE p.tipo = 'COLABORADOR'
GROUP BY p.id, p.nome
ORDER BY primeiro_pagamento_solicitacao NULLS LAST;

-- 1.5 Buscar primeira entrada no log de auditoria
SELECT
    p.id AS pessoa_id,
    p.nome,
    MIN(al.criado_em) AS primeira_acao_auditoria,
    COUNT(al.id) AS total_acoes
FROM pessoas p
LEFT JOIN auditoria_logs al ON al.pessoa_id = p.id
WHERE p.tipo = 'COLABORADOR'
GROUP BY p.id, p.nome
ORDER BY primeira_acao_auditoria NULLS LAST;

-- 1.6 CONSOLIDADO: Data de início mais antiga para cada colaborador
-- Esta query combina todas as fontes para encontrar a primeira interação
WITH primeira_interacao AS (
    SELECT
        p.id AS pessoa_id,
        p.nome,
        p.email,
        p.cpf,
        p.criado_em AS data_cadastro,

        -- Primeiro pagamento em valores a receber
        (SELECT MIN(cvr.data_pagamento)
         FROM colaborador_valores_receber cvr
         WHERE cvr.colaborador_id = p.id) AS primeiro_valor_receber,

        -- Primeiro lançamento financeiro
        (SELECT MIN(COALESCE(fl.data_pagamento, fl.data_competencia))
         FROM financeiro_lancamentos fl
         WHERE fl.pessoa_id = p.id) AS primeiro_financeiro,

        -- Primeira solicitação de pagamento
        (SELECT MIN(COALESCE(sp.data_pagamento, sp.criado_em::date))
         FROM solicitacoes_pagamento sp
         WHERE sp.beneficiario_id = p.id) AS primeira_solicitacao,

        -- Primeiro projeto associado
        (SELECT MIN(cp.data_inicio)
         FROM colaborador_projetos cp
         WHERE cp.colaborador_id = p.id) AS primeiro_projeto,

        -- Primeira auditoria
        (SELECT MIN(al.criado_em)::date
         FROM auditoria_logs al
         WHERE al.pessoa_id = p.id) AS primeira_auditoria

    FROM pessoas p
    WHERE p.tipo = 'COLABORADOR'
)
SELECT
    pessoa_id,
    nome,
    email,
    cpf,
    data_cadastro,
    primeiro_valor_receber,
    primeiro_financeiro,
    primeira_solicitacao,
    primeiro_projeto,
    primeira_auditoria,
    -- Data de início sugerida (a mais antiga entre todas)
    LEAST(
        COALESCE(data_cadastro::date, '2099-12-31'),
        COALESCE(primeiro_valor_receber, '2099-12-31'),
        COALESCE(primeiro_financeiro, '2099-12-31'),
        COALESCE(primeira_solicitacao, '2099-12-31'),
        COALESCE(primeiro_projeto, '2099-12-31'),
        COALESCE(primeira_auditoria, '2099-12-31')
    ) AS data_inicio_sugerida
FROM primeira_interacao
ORDER BY data_inicio_sugerida;


-- ============================================================
-- PARTE 2: IDENTIFICAÇÃO DE NOMES DUPLICADOS
-- ============================================================

-- 2.1 Duplicatas EXATAS por nome (case insensitive)
SELECT
    LOWER(TRIM(nome)) AS nome_normalizado,
    COUNT(*) AS quantidade,
    STRING_AGG(id::text, ', ') AS ids,
    STRING_AGG(email, ', ') AS emails,
    STRING_AGG(cpf, ', ') AS cpfs,
    STRING_AGG(tipo, ', ') AS tipos
FROM pessoas
WHERE tipo = 'COLABORADOR'
GROUP BY LOWER(TRIM(nome))
HAVING COUNT(*) > 1
ORDER BY quantidade DESC, nome_normalizado;

-- 2.2 Duplicatas por similaridade (primeiros/últimos nomes)
-- Encontra pessoas com mesmo primeiro e último nome
WITH nomes_partes AS (
    SELECT
        id,
        nome,
        email,
        cpf,
        tipo,
        criado_em,
        SPLIT_PART(LOWER(TRIM(nome)), ' ', 1) AS primeiro_nome,
        -- Último nome (última palavra)
        REVERSE(SPLIT_PART(REVERSE(LOWER(TRIM(nome))), ' ', 1)) AS ultimo_nome
    FROM pessoas
    WHERE tipo = 'COLABORADOR'
)
SELECT
    primeiro_nome,
    ultimo_nome,
    COUNT(*) AS quantidade,
    STRING_AGG(nome, ' | ' ORDER BY criado_em) AS nomes_completos,
    STRING_AGG(id::text, ', ') AS ids,
    STRING_AGG(email, ', ') AS emails
FROM nomes_partes
GROUP BY primeiro_nome, ultimo_nome
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 2.3 Possíveis duplicatas por CPF
SELECT
    cpf,
    COUNT(*) AS quantidade,
    STRING_AGG(nome, ' | ') AS nomes,
    STRING_AGG(id::text, ', ') AS ids,
    STRING_AGG(email, ', ') AS emails
FROM pessoas
WHERE tipo = 'COLABORADOR'
  AND cpf IS NOT NULL
  AND cpf != ''
GROUP BY cpf
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 2.4 Possíveis duplicatas por email
SELECT
    LOWER(email) AS email_normalizado,
    COUNT(*) AS quantidade,
    STRING_AGG(nome, ' | ') AS nomes,
    STRING_AGG(id::text, ', ') AS ids
FROM pessoas
WHERE tipo = 'COLABORADOR'
  AND email IS NOT NULL
  AND email != ''
GROUP BY LOWER(email)
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 2.5 Lista consolidada de todas as duplicatas potenciais
WITH duplicatas AS (
    -- Por nome exato
    SELECT
        'NOME_EXATO' AS tipo_duplicata,
        LOWER(TRIM(nome)) AS chave,
        id,
        nome,
        email,
        cpf,
        criado_em
    FROM pessoas p1
    WHERE tipo = 'COLABORADOR'
      AND EXISTS (
          SELECT 1 FROM pessoas p2
          WHERE p2.tipo = 'COLABORADOR'
            AND p2.id != p1.id
            AND LOWER(TRIM(p2.nome)) = LOWER(TRIM(p1.nome))
      )

    UNION ALL

    -- Por CPF
    SELECT
        'CPF' AS tipo_duplicata,
        cpf AS chave,
        id,
        nome,
        email,
        cpf,
        criado_em
    FROM pessoas p1
    WHERE tipo = 'COLABORADOR'
      AND cpf IS NOT NULL AND cpf != ''
      AND EXISTS (
          SELECT 1 FROM pessoas p2
          WHERE p2.tipo = 'COLABORADOR'
            AND p2.id != p1.id
            AND p2.cpf = p1.cpf
      )
)
SELECT
    tipo_duplicata,
    chave,
    id,
    nome,
    email,
    cpf,
    criado_em
FROM duplicatas
ORDER BY tipo_duplicata, chave, criado_em;


-- ============================================================
-- PARTE 3: SCRIPT DE ATUALIZAÇÃO DE DATA DE INÍCIO
-- (Executar após análise manual)
-- ============================================================

-- 3.1 Adicionar coluna data_inicio se não existir
-- ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;

-- 3.2 Atualizar data_inicio com base na primeira interação
/*
UPDATE pessoas p
SET data_inicio = sub.data_inicio_calculada
FROM (
    SELECT
        pessoa_id,
        LEAST(
            COALESCE(data_cadastro::date, '2099-12-31'),
            COALESCE((SELECT MIN(cvr.data_pagamento) FROM colaborador_valores_receber cvr WHERE cvr.colaborador_id = pessoa_id), '2099-12-31'),
            COALESCE((SELECT MIN(COALESCE(fl.data_pagamento, fl.data_competencia)) FROM financeiro_lancamentos fl WHERE fl.pessoa_id = pessoa_id), '2099-12-31'),
            COALESCE((SELECT MIN(cp.data_inicio) FROM colaborador_projetos cp WHERE cp.colaborador_id = pessoa_id), '2099-12-31')
        ) AS data_inicio_calculada
    FROM (
        SELECT id AS pessoa_id, criado_em AS data_cadastro
        FROM pessoas
        WHERE tipo = 'COLABORADOR'
    ) base
) sub
WHERE p.id = sub.pessoa_id
  AND p.tipo = 'COLABORADOR'
  AND sub.data_inicio_calculada != '2099-12-31';
*/

-- ============================================================
-- PARTE 4: SCRIPT DE MERGE DE DUPLICATAS
-- (Template - ajustar IDs manualmente após análise)
-- ============================================================

-- 4.1 Função para mesclar duas pessoas (manter a mais antiga, transferir referências)
/*
CREATE OR REPLACE FUNCTION merge_pessoas(
    p_id_manter UUID,
    p_id_remover UUID
) RETURNS void AS $$
BEGIN
    -- Transferir colaborador_valores_receber
    UPDATE colaborador_valores_receber
    SET colaborador_id = p_id_manter
    WHERE colaborador_id = p_id_remover;

    -- Transferir colaborador_projetos
    UPDATE colaborador_projetos
    SET colaborador_id = p_id_manter
    WHERE colaborador_id = p_id_remover;

    -- Transferir financeiro_lancamentos
    UPDATE financeiro_lancamentos
    SET pessoa_id = p_id_manter
    WHERE pessoa_id = p_id_remover;

    -- Transferir solicitacoes_pagamento (beneficiário)
    UPDATE solicitacoes_pagamento
    SET beneficiario_id = p_id_manter
    WHERE beneficiario_id = p_id_remover;

    -- Transferir solicitacoes_pagamento (solicitante)
    UPDATE solicitacoes_pagamento
    SET solicitante_id = p_id_manter
    WHERE solicitante_id = p_id_remover;

    -- Transferir auditoria_logs
    UPDATE auditoria_logs
    SET pessoa_id = p_id_manter
    WHERE pessoa_id = p_id_remover;

    -- Marcar registro duplicado como inativo (não deletar para histórico)
    UPDATE pessoas
    SET ativo = false,
        observacoes = COALESCE(observacoes, '') || ' [DUPLICATA MESCLADA EM ' || p_id_manter || ' em ' || NOW() || ']'
    WHERE id = p_id_remover;

    RAISE NOTICE 'Merge concluído: % -> %', p_id_remover, p_id_manter;
END;
$$ LANGUAGE plpgsql;
*/

-- 4.2 Exemplo de uso do merge (ajustar IDs)
-- SELECT merge_pessoas('uuid-do-registro-principal', 'uuid-do-registro-duplicado');


-- ============================================================
-- RELATÓRIO FINAL RESUMIDO
-- ============================================================

-- Resumo de colaboradores
SELECT
    'Total de Colaboradores' AS metrica,
    COUNT(*)::text AS valor
FROM pessoas WHERE tipo = 'COLABORADOR'
UNION ALL
SELECT
    'Colaboradores Ativos',
    COUNT(*)::text
FROM pessoas WHERE tipo = 'COLABORADOR' AND ativo = true
UNION ALL
SELECT
    'Colaboradores Inativos',
    COUNT(*)::text
FROM pessoas WHERE tipo = 'COLABORADOR' AND (ativo = false OR ativo IS NULL)
UNION ALL
SELECT
    'Com pagamentos registrados',
    COUNT(DISTINCT cvr.colaborador_id)::text
FROM colaborador_valores_receber cvr
INNER JOIN pessoas p ON p.id = cvr.colaborador_id AND p.tipo = 'COLABORADOR'
UNION ALL
SELECT
    'Com lançamentos financeiros',
    COUNT(DISTINCT fl.pessoa_id)::text
FROM financeiro_lancamentos fl
INNER JOIN pessoas p ON p.id = fl.pessoa_id AND p.tipo = 'COLABORADOR'
UNION ALL
SELECT
    'Potenciais duplicatas por nome',
    COUNT(*)::text
FROM (
    SELECT LOWER(TRIM(nome))
    FROM pessoas
    WHERE tipo = 'COLABORADOR'
    GROUP BY LOWER(TRIM(nome))
    HAVING COUNT(*) > 1
) dup;
