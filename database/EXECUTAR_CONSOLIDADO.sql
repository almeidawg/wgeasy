-- ============================================================
-- EXECUTAR NO SUPABASE SQL EDITOR
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/sql/new
-- ============================================================
-- ATUALIZAÇÃO CONSOLIDADA: Data de Início dos Colaboradores
-- Data: 2026-01-02
-- ============================================================

-- 1. Criar coluna data_inicio (se não existir)
ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;

-- ============================================================
-- 2. COLABORADORES - DATAS BASEADAS EM PRIMEIRO PAGAMENTO
-- (21 colaboradores identificados via financeiro_lancamentos)
-- ============================================================

UPDATE pessoas SET data_inicio = '2020-06-10' WHERE id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'; -- Josemar
UPDATE pessoas SET data_inicio = '2020-06-17' WHERE id = '5b4af090-8e6a-4b10-80c5-6686d5e63d3a'; -- William
UPDATE pessoas SET data_inicio = '2020-06-26' WHERE id = 'c7222975-5aef-4326-b726-a36bed9612f1'; -- MARCOS
UPDATE pessoas SET data_inicio = '2020-07-07' WHERE id = '28a7472a-e849-4bc3-8780-214c04a7c54f'; -- Antônio
UPDATE pessoas SET data_inicio = '2020-07-07' WHERE id = '50b8a7b2-2686-4cfe-8d05-d708de312020'; -- José Vinicius
UPDATE pessoas SET data_inicio = '2023-06-25' WHERE id = '04e75742-c53c-4b52-8138-fb953a30755b'; -- CARLOS
UPDATE pessoas SET data_inicio = '2024-01-31' WHERE id = '35693a08-3424-4ba3-bc71-5a1c49e00311'; -- JOSENILDO
UPDATE pessoas SET data_inicio = '2024-03-07' WHERE id = 'd3d0c75d-aa6e-43e3-b042-23a30a179dc0'; -- FABIO
UPDATE pessoas SET data_inicio = '2024-07-07' WHERE id = '853b3f28-6fbf-4696-8294-023c5045414b'; -- GLEBER
UPDATE pessoas SET data_inicio = '2024-07-23' WHERE id = '4d2c4cb0-c8af-4ea3-a2aa-030faa1f1a5b'; -- WELLINGTON
UPDATE pessoas SET data_inicio = '2024-07-30' WHERE id = 'b784f700-356f-4038-90f0-6de21f60cd93'; -- Leandro
UPDATE pessoas SET data_inicio = '2025-02-04' WHERE id = '766be75c-41f8-4aa7-a5c6-0c96705e96c9'; -- VALDINEI
UPDATE pessoas SET data_inicio = '2025-04-24' WHERE id = 'aac151c2-6c9c-44cb-9fb0-3ba2abf9cdc0'; -- RODRIGO
UPDATE pessoas SET data_inicio = '2025-06-08' WHERE id = 'c6cbb3a9-6f7c-4d6a-8ee5-f7a866845b24'; -- VENANCIO
UPDATE pessoas SET data_inicio = '2025-07-04' WHERE id = '15e70e4f-a77f-4843-a6f7-c8eb73b2b772'; -- LOURIVAL
UPDATE pessoas SET data_inicio = '2025-07-22' WHERE id = '569afe4a-18df-45db-ac2e-9a94550b3cae'; -- JESSIKA
UPDATE pessoas SET data_inicio = '2025-08-30' WHERE id = '335f7d3c-84e7-46b8-bc07-9e2ff4f68207'; -- GERARDO
UPDATE pessoas SET data_inicio = '2025-09-13' WHERE id = 'dffe88d7-e4da-4f6f-961d-e62436c7914e'; -- Valdir
UPDATE pessoas SET data_inicio = '2025-10-14' WHERE id = 'eab94604-f118-41a8-ba7d-087212806b98'; -- Julia
UPDATE pessoas SET data_inicio = '2025-10-18' WHERE id = 'd3d6a25f-b68d-4f3d-bfac-29158310c83d'; -- JOSEILTON
UPDATE pessoas SET data_inicio = '2025-10-18' WHERE id = '2636c23d-53da-4336-b7a3-0af5fb8c0ee1'; -- JOÃO PAULO

-- ============================================================
-- 3. COLABORADOR ADICIONAL - DATA BASEADA EM DOCUMENTO
-- (Identificado via pasta de documentos pessoais)
-- ============================================================

UPDATE pessoas SET data_inicio = '2023-08-29' WHERE id = '6d40482f-899e-41ca-b5de-79a795978728'; -- Rogério Aparecido Michelini

-- ============================================================
-- 4. VERIFICAR RESULTADO
-- ============================================================

SELECT
    nome,
    data_inicio,
    criado_em::date as cadastro,
    CASE
        WHEN data_inicio IS NOT NULL THEN '✅ Com data'
        ELSE '⏳ Sem data'
    END as status
FROM pessoas
WHERE tipo = 'COLABORADOR' AND ativo = true
ORDER BY data_inicio NULLS LAST;
