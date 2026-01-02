-- ============================================================
-- ADICIONAR CAMPO DATA_INICIO PARA COLABORADORES
-- ============================================================

-- 1. Adicionar coluna data_inicio na tabela pessoas
ALTER TABLE pessoas
ADD COLUMN IF NOT EXISTS data_inicio DATE;

-- 2. Adicionar comentário explicativo
COMMENT ON COLUMN pessoas.data_inicio IS 'Data de início do colaborador na empresa (primeira interação ou contratação)';

-- 3. Verificar estrutura
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'pessoas'
AND column_name IN ('data_inicio', 'criado_em', 'nome', 'tipo');

-- 4. Listar colaboradores para preenchimento manual das datas
SELECT
    id,
    nome,
    cpf,
    criado_em::date AS data_cadastro_sistema,
    data_inicio,
    CASE
        WHEN data_inicio IS NULL THEN '⚠️ PENDENTE'
        ELSE '✅ OK'
    END AS status_data
FROM pessoas
WHERE tipo = 'COLABORADOR'
AND ativo = true
ORDER BY nome;
