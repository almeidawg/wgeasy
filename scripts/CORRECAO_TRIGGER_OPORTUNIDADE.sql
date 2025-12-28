-- =============================================
-- CORRECAO BUG: trigger_nova_oportunidade
-- WGeasy - Grupo WG Almeida
-- Data: 2025-12-28
-- =============================================
--
-- PROBLEMA IDENTIFICADO:
-- O trigger 'trigger_nova_oportunidade' definido em
-- SUPABASE-PLANO-PAGO-02-WEBHOOKS.sql tem os seguintes bugs:
--
-- 1. Tenta buscar 'nome' diretamente da tabela 'usuarios',
--    mas essa coluna nao existe (nome esta em 'pessoas')
--
-- 2. Referencia NEW.etapa mas a coluna correta e 'estagio'
--
-- NOTA: valor_estimado EXISTE na tabela oportunidades e esta correto
--
-- COMO EXECUTAR:
-- 1. Acesse o Supabase Dashboard
-- 2. Va em SQL Editor
-- 3. Cole este script e execute
-- =============================================

-- Primeiro, verificar o trigger atual
SELECT
    trigger_name,
    event_object_table,
    action_timing
FROM information_schema.triggers
WHERE trigger_name = 'trigger_oportunidade_nova';

-- Recriar a funcao do trigger com as correcoes
CREATE OR REPLACE FUNCTION trigger_nova_oportunidade()
RETURNS TRIGGER AS $$
DECLARE
  v_cliente_nome VARCHAR;
  v_responsavel_nome VARCHAR;
BEGIN
  -- Buscar nome do cliente
  SELECT nome INTO v_cliente_nome
  FROM pessoas
  WHERE id = NEW.cliente_id;

  -- Buscar nome do responsavel via JOIN com pessoas
  -- CORRECAO: usuarios nao tem coluna 'nome', precisa do JOIN
  IF NEW.responsavel_id IS NOT NULL THEN
    SELECT p.nome INTO v_responsavel_nome
    FROM usuarios u
    JOIN pessoas p ON p.id = u.pessoa_id
    WHERE u.id = NEW.responsavel_id;
  ELSE
    v_responsavel_nome := NULL;
  END IF;

  -- Verificar se tabela webhook_logs existe antes de inserir
  -- Isso evita erro se a tabela nao existir
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_name = 'webhook_logs'
  ) THEN
    INSERT INTO webhook_logs (
      evento, tabela, registro_id, payload
    ) VALUES (
      'nova_oportunidade',
      'oportunidades',
      NEW.id,
      jsonb_build_object(
        'oportunidade_id', NEW.id,
        'titulo', NEW.titulo,
        'cliente_id', NEW.cliente_id,
        'cliente_nome', v_cliente_nome,
        'responsavel_id', NEW.responsavel_id,
        'responsavel_nome', v_responsavel_nome,
        'valor_estimado', NEW.valor_estimado,
        -- CORRECAO: era 'etapa', agora e 'estagio'
        'estagio', NEW.estagio
      )
    );
  END IF;

  RETURN NEW;
EXCEPTION
  -- Se der qualquer erro, nao bloquear o INSERT na oportunidade
  WHEN OTHERS THEN
    RAISE WARNING 'Erro no trigger_nova_oportunidade: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Verificar se a correcao foi aplicada
DO $$
BEGIN
  RAISE NOTICE '=============================================';
  RAISE NOTICE 'CORRECAO APLICADA COM SUCESSO!';
  RAISE NOTICE '=============================================';
  RAISE NOTICE 'O trigger trigger_nova_oportunidade foi corrigido.';
  RAISE NOTICE 'Agora voce pode criar oportunidades sem erro.';
  RAISE NOTICE '=============================================';
END $$;

-- Teste rapido: tentar criar uma oportunidade de teste
-- (descomente para testar)
/*
DO $$
DECLARE
  v_cliente_id UUID;
  v_oportunidade_id UUID;
BEGIN
  -- Buscar um cliente existente
  SELECT id INTO v_cliente_id FROM pessoas WHERE tipo = 'CLIENTE' LIMIT 1;

  IF v_cliente_id IS NOT NULL THEN
    -- Tentar criar oportunidade
    INSERT INTO oportunidades (titulo, cliente_id, status, estagio, valor)
    VALUES ('TESTE_CORRECAO_TRIGGER', v_cliente_id, 'novo', 'qualificacao', 1000)
    RETURNING id INTO v_oportunidade_id;

    RAISE NOTICE 'Oportunidade de teste criada: %', v_oportunidade_id;

    -- Limpar
    DELETE FROM oportunidades WHERE id = v_oportunidade_id;
    RAISE NOTICE 'Oportunidade de teste removida.';
    RAISE NOTICE 'TESTE PASSOU! O trigger esta funcionando corretamente.';
  ELSE
    RAISE NOTICE 'Nenhum cliente encontrado para teste.';
  END IF;
END $$;
*/
