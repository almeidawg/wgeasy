-- ============================================================
-- MERGE: JOSEMAR JOAQUIM DE SOUZA
-- Manter: 2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94 (tem email e CPF)
-- Remover: 5f88992c-cb32-4e86-80cc-c171eb8da867 (sem dados)
-- ============================================================

-- IDs
-- MANTER (principal): 2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94
-- REMOVER (duplicata): 5f88992c-cb32-4e86-80cc-c171eb8da867

BEGIN;

-- 1. Verificar registros antes do merge
SELECT 'ANTES DO MERGE' AS status;
SELECT id, nome, email, cpf, criado_em FROM pessoas
WHERE id IN ('2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94', '5f88992c-cb32-4e86-80cc-c171eb8da867');

-- 2. Transferir colaborador_valores_receber
UPDATE colaborador_valores_receber
SET colaborador_id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'
WHERE colaborador_id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 3. Transferir colaborador_projetos
UPDATE colaborador_projetos
SET colaborador_id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'
WHERE colaborador_id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 4. Transferir financeiro_lancamentos
UPDATE financeiro_lancamentos
SET pessoa_id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'
WHERE pessoa_id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 5. Transferir solicitacoes_pagamento (beneficiário)
UPDATE solicitacoes_pagamento
SET beneficiario_id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'
WHERE beneficiario_id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 6. Transferir solicitacoes_pagamento (solicitante)
UPDATE solicitacoes_pagamento
SET solicitante_id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'
WHERE solicitante_id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 7. Transferir auditoria_logs
UPDATE auditoria_logs
SET pessoa_id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'
WHERE pessoa_id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 8. Marcar duplicata como inativa (preservar histórico)
UPDATE pessoas
SET
    ativo = false,
    observacoes = COALESCE(observacoes, '') || '[DUPLICATA MESCLADA] Registros transferidos para ID 2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94 em ' || NOW()::text
WHERE id = '5f88992c-cb32-4e86-80cc-c171eb8da867';

-- 9. Verificar resultado
SELECT 'DEPOIS DO MERGE' AS status;
SELECT id, nome, email, cpf, ativo, observacoes FROM pessoas
WHERE id IN ('2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94', '5f88992c-cb32-4e86-80cc-c171eb8da867');

COMMIT;

-- ============================================================
-- OPCIONAL: DELETAR registro duplicado (só após confirmar merge)
-- ============================================================
-- DELETE FROM pessoas WHERE id = '5f88992c-cb32-4e86-80cc-c171eb8da867';
