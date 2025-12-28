-- ============================================================
-- SUPABASE PLANO PAGO - PARTE 2: Database Webhooks
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- Database Webhooks permitem disparar HTTP requests quando
-- ocorrem mudanças no banco de dados.
--
-- IMPORTANTE: Webhooks são configurados via Dashboard do Supabase
-- Este arquivo contém as funções e triggers de suporte.
-- ============================================================

-- ============================================================
-- 1. TABELA: webhook_logs (Registrar disparos de webhook)
-- ============================================================

CREATE TABLE IF NOT EXISTS webhook_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  evento VARCHAR(50) NOT NULL, -- insert, update, delete
  tabela VARCHAR(100) NOT NULL,
  registro_id UUID,
  payload JSONB DEFAULT '{}',
  webhook_url TEXT,
  status VARCHAR(20) DEFAULT 'pendente', -- pendente, enviado, erro
  resposta JSONB,
  tentativas INT DEFAULT 0,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  enviado_em TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_webhook_logs_tabela ON webhook_logs(tabela);
CREATE INDEX IF NOT EXISTS idx_webhook_logs_status ON webhook_logs(status) WHERE status = 'pendente';
CREATE INDEX IF NOT EXISTS idx_webhook_logs_data ON webhook_logs(criado_em DESC);

-- ============================================================
-- 2. TABELA: webhook_configs (Configuração de webhooks)
-- ============================================================

CREATE TABLE IF NOT EXISTS webhook_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(100) NOT NULL UNIQUE,
  tabela VARCHAR(100) NOT NULL,
  eventos VARCHAR[] DEFAULT ARRAY['INSERT', 'UPDATE', 'DELETE'],
  url TEXT NOT NULL,
  headers JSONB DEFAULT '{}',
  ativo BOOLEAN DEFAULT TRUE,
  filtro_condicao TEXT, -- Ex: "status = 'ativo'"
  campos_incluir VARCHAR[], -- NULL = todos
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_webhook_configs_tabela ON webhook_configs(tabela);
CREATE INDEX IF NOT EXISTS idx_webhook_configs_ativo ON webhook_configs(ativo) WHERE ativo = TRUE;

-- ============================================================
-- 3. FUNÇÃO: Preparar payload para webhook
-- ============================================================

CREATE OR REPLACE FUNCTION preparar_webhook_payload(
  p_tabela VARCHAR,
  p_evento VARCHAR,
  p_old JSONB,
  p_new JSONB
)
RETURNS JSONB AS $$
DECLARE
  v_payload JSONB;
BEGIN
  v_payload := jsonb_build_object(
    'evento', p_evento,
    'tabela', p_tabela,
    'timestamp', NOW(),
    'dados_antigos', CASE WHEN p_evento IN ('UPDATE', 'DELETE') THEN p_old ELSE NULL END,
    'dados_novos', CASE WHEN p_evento IN ('INSERT', 'UPDATE') THEN p_new ELSE NULL END
  );

  RETURN v_payload;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 4. TRIGGERS PARA EVENTOS IMPORTANTES
-- ============================================================

-- 4.1 Trigger: Mudança de status em contratos
CREATE OR REPLACE FUNCTION trigger_contrato_status_changed()
RETURNS TRIGGER AS $$
DECLARE
  v_cliente_nome VARCHAR;
  v_notif_titulo VARCHAR;
  v_notif_msg TEXT;
BEGIN
  -- Só dispara se status mudou
  IF OLD.status IS DISTINCT FROM NEW.status THEN

    -- Buscar nome do cliente
    SELECT nome INTO v_cliente_nome
    FROM pessoas WHERE id = NEW.cliente_id;

    -- Definir mensagem baseada no novo status
    CASE NEW.status
      WHEN 'ativo' THEN
        v_notif_titulo := 'Contrato Ativado';
        v_notif_msg := 'Seu contrato foi ativado! Bem-vindo ao projeto WG Almeida.';
      WHEN 'concluido' THEN
        v_notif_titulo := 'Projeto Concluído';
        v_notif_msg := 'Parabéns! Seu projeto foi concluído com sucesso.';
      WHEN 'suspenso' THEN
        v_notif_titulo := 'Contrato Suspenso';
        v_notif_msg := 'Seu contrato foi suspenso. Entre em contato conosco.';
      WHEN 'cancelado' THEN
        v_notif_titulo := 'Contrato Cancelado';
        v_notif_msg := 'Seu contrato foi cancelado.';
      ELSE
        v_notif_titulo := 'Status do Contrato Atualizado';
        v_notif_msg := 'O status do seu contrato foi alterado para: ' || NEW.status;
    END CASE;

    -- Criar notificação interna
    INSERT INTO notificacoes (
      tipo,
      titulo,
      mensagem,
      destinatario_id,
      referencia_tipo,
      referencia_id,
      dados
    ) VALUES (
      'CONTRATO_STATUS',
      v_notif_titulo,
      v_notif_msg,
      NEW.cliente_id,
      'contrato',
      NEW.id,
      jsonb_build_object(
        'status_anterior', OLD.status,
        'status_novo', NEW.status,
        'contrato_numero', NEW.numero
      )
    );

    -- Registrar para webhook externo
    INSERT INTO webhook_logs (
      evento, tabela, registro_id, payload
    ) VALUES (
      'status_changed',
      'contratos',
      NEW.id,
      jsonb_build_object(
        'contrato_id', NEW.id,
        'contrato_numero', NEW.numero,
        'cliente_id', NEW.cliente_id,
        'cliente_nome', v_cliente_nome,
        'status_anterior', OLD.status,
        'status_novo', NEW.status,
        'valor_total', NEW.valor_total
      )
    );

    -- Registrar na timeline da oportunidade
    IF EXISTS (SELECT 1 FROM oportunidades WHERE contrato_id = NEW.id) THEN
      INSERT INTO oportunidade_timeline (
        oportunidade_id,
        contrato_id,
        origem,
        tipo,
        titulo,
        descricao,
        visivel_cliente,
        dados
      )
      SELECT
        o.id,
        NEW.id,
        'contrato',
        'status',
        v_notif_titulo,
        v_notif_msg,
        TRUE,
        jsonb_build_object('status_anterior', OLD.status, 'status_novo', NEW.status)
      FROM oportunidades o
      WHERE o.contrato_id = NEW.id;
    END IF;

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_contrato_status ON contratos;
CREATE TRIGGER trigger_contrato_status
  AFTER UPDATE ON contratos
  FOR EACH ROW
  EXECUTE FUNCTION trigger_contrato_status_changed();

-- 4.2 Trigger: Pagamento recebido (para tabela lancamentos - criar após tabela existir)
-- NOTA: Execute este bloco após criar a tabela lancamentos
/*
CREATE OR REPLACE FUNCTION trigger_pagamento_recebido()
RETURNS TRIGGER AS $$
DECLARE
  v_cliente_id UUID;
  v_cliente_nome VARCHAR;
  v_contrato_numero VARCHAR;
BEGIN
  -- Só dispara se status mudou para 'pago'
  IF NEW.status = 'pago' AND OLD.status != 'pago' AND NEW.tipo = 'RECEBER' THEN

    -- Buscar dados do contrato e cliente
    SELECT c.cliente_id, p.nome, c.numero
    INTO v_cliente_id, v_cliente_nome, v_contrato_numero
    FROM contratos c
    JOIN pessoas p ON p.id = c.cliente_id
    WHERE c.id = NEW.contrato_id;

    -- Criar notificação interna
    INSERT INTO notificacoes (
      tipo,
      titulo,
      mensagem,
      destinatario_id,
      referencia_tipo,
      referencia_id,
      dados
    ) VALUES (
      'PAGAMENTO_CONFIRMADO',
      'Pagamento Confirmado',
      'Seu pagamento de R$ ' || TO_CHAR(NEW.valor, 'FM999G999D00') || ' foi confirmado. Obrigado!',
      v_cliente_id,
      'lancamento',
      NEW.id,
      jsonb_build_object(
        'valor', NEW.valor,
        'data_pagamento', NEW.data_pagamento,
        'contrato_numero', v_contrato_numero
      )
    );

    -- Registrar para webhook externo
    INSERT INTO webhook_logs (
      evento, tabela, registro_id, payload
    ) VALUES (
      'pagamento_confirmado',
      'lancamentos',
      NEW.id,
      jsonb_build_object(
        'lancamento_id', NEW.id,
        'contrato_id', NEW.contrato_id,
        'contrato_numero', v_contrato_numero,
        'cliente_id', v_cliente_id,
        'cliente_nome', v_cliente_nome,
        'valor', NEW.valor,
        'data_pagamento', NEW.data_pagamento
      )
    );

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_lancamento_pago ON lancamentos;
CREATE TRIGGER trigger_lancamento_pago
  AFTER UPDATE ON lancamentos
  FOR EACH ROW
  EXECUTE FUNCTION trigger_pagamento_recebido();
*/

-- 4.3 Trigger: Nova oportunidade criada
-- CORRIGIDO em 2025-12-28: Bugs de referencia a colunas inexistentes
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

  -- CORRECAO: usuarios nao tem coluna 'nome', precisa do JOIN com pessoas
  IF NEW.responsavel_id IS NOT NULL THEN
    SELECT p.nome INTO v_responsavel_nome
    FROM usuarios u
    JOIN pessoas p ON p.id = u.pessoa_id
    WHERE u.id = NEW.responsavel_id;
  ELSE
    v_responsavel_nome := NULL;
  END IF;

  -- Verificar se tabela webhook_logs existe antes de inserir
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

DROP TRIGGER IF EXISTS trigger_oportunidade_nova ON oportunidades;
CREATE TRIGGER trigger_oportunidade_nova
  AFTER INSERT ON oportunidades
  FOR EACH ROW
  EXECUTE FUNCTION trigger_nova_oportunidade();

-- 4.4 Trigger: Etapa do cronograma concluída (para tabela cronograma_etapas - criar após tabela existir)
-- NOTA: Execute este bloco após criar a tabela cronograma_etapas
/*
CREATE OR REPLACE FUNCTION trigger_etapa_concluida()
RETURNS TRIGGER AS $$
DECLARE
  v_cliente_id UUID;
  v_cliente_nome VARCHAR;
  v_contrato_numero VARCHAR;
BEGIN
  -- Só dispara se status mudou para 'concluido'
  IF NEW.status = 'concluido' AND OLD.status != 'concluido' THEN

    -- Buscar dados do contrato
    SELECT c.cliente_id, p.nome, c.numero
    INTO v_cliente_id, v_cliente_nome, v_contrato_numero
    FROM contratos c
    JOIN pessoas p ON p.id = c.cliente_id
    WHERE c.id = NEW.contrato_id;

    -- Criar notificação para cliente
    INSERT INTO notificacoes (
      tipo,
      titulo,
      mensagem,
      destinatario_id,
      referencia_tipo,
      referencia_id,
      dados
    ) VALUES (
      'ETAPA_CONCLUIDA',
      'Etapa Concluída: ' || NEW.nome,
      'A etapa "' || NEW.nome || '" do seu projeto foi concluída!',
      v_cliente_id,
      'cronograma_etapa',
      NEW.id,
      jsonb_build_object(
        'etapa_nome', NEW.nome,
        'contrato_numero', v_contrato_numero
      )
    );

    -- Registrar para webhook
    INSERT INTO webhook_logs (
      evento, tabela, registro_id, payload
    ) VALUES (
      'etapa_concluida',
      'cronograma_etapas',
      NEW.id,
      jsonb_build_object(
        'etapa_id', NEW.id,
        'etapa_nome', NEW.nome,
        'contrato_id', NEW.contrato_id,
        'contrato_numero', v_contrato_numero,
        'cliente_id', v_cliente_id,
        'cliente_nome', v_cliente_nome,
        'data_conclusao', NOW()
      )
    );

  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_cronograma_etapa_concluida ON cronograma_etapas;
CREATE TRIGGER trigger_cronograma_etapa_concluida
  AFTER UPDATE ON cronograma_etapas
  FOR EACH ROW
  EXECUTE FUNCTION trigger_etapa_concluida();
*/

-- ============================================================
-- 5. FUNÇÃO: Processar webhooks pendentes (para Edge Function)
-- ============================================================

CREATE OR REPLACE FUNCTION processar_webhooks_pendentes()
RETURNS TABLE (
  webhook_id UUID,
  evento VARCHAR,
  tabela VARCHAR,
  payload JSONB,
  webhook_url TEXT
) AS $$
BEGIN
  -- Retorna webhooks pendentes para processamento externo
  RETURN QUERY
  SELECT
    wl.id,
    wl.evento,
    wl.tabela,
    wl.payload,
    wc.url
  FROM webhook_logs wl
  JOIN webhook_configs wc ON wc.tabela = wl.tabela AND wc.ativo = TRUE
  WHERE wl.status = 'pendente'
    AND wl.tentativas < 3
  ORDER BY wl.criado_em
  LIMIT 50;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 6. FUNÇÃO: Marcar webhook como enviado
-- ============================================================

CREATE OR REPLACE FUNCTION marcar_webhook_enviado(
  p_webhook_id UUID,
  p_resposta JSONB DEFAULT NULL
)
RETURNS void AS $$
BEGIN
  UPDATE webhook_logs
  SET
    status = 'enviado',
    enviado_em = NOW(),
    resposta = p_resposta
  WHERE id = p_webhook_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 7. FUNÇÃO: Marcar webhook com erro
-- ============================================================

CREATE OR REPLACE FUNCTION marcar_webhook_erro(
  p_webhook_id UUID,
  p_erro TEXT
)
RETURNS void AS $$
BEGIN
  UPDATE webhook_logs
  SET
    status = CASE WHEN tentativas >= 2 THEN 'erro' ELSE 'pendente' END,
    tentativas = tentativas + 1,
    resposta = jsonb_build_object('erro', p_erro, 'tentativa', tentativas + 1)
  WHERE id = p_webhook_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 8. VIEW: Status dos webhooks
-- ============================================================

CREATE OR REPLACE VIEW view_webhook_status AS
SELECT
  tabela,
  evento,
  COUNT(*) FILTER (WHERE status = 'enviado') as enviados,
  COUNT(*) FILTER (WHERE status = 'pendente') as pendentes,
  COUNT(*) FILTER (WHERE status = 'erro') as erros,
  MAX(criado_em) as ultimo_evento,
  MAX(enviado_em) as ultimo_envio
FROM webhook_logs
WHERE criado_em > NOW() - INTERVAL '7 days'
GROUP BY tabela, evento
ORDER BY tabela, evento;

-- ============================================================
-- 9. CONFIGURAÇÕES INICIAIS DE WEBHOOK
-- ============================================================

-- Exemplo de configuração (ajuste as URLs conforme necessário)
INSERT INTO webhook_configs (nome, tabela, eventos, url, ativo) VALUES
('slack-novos-contratos', 'contratos', ARRAY['INSERT'], 'https://hooks.slack.com/services/xxx', FALSE),
('whatsapp-pagamentos', 'lancamentos', ARRAY['UPDATE'], 'https://api.whatsapp.com/xxx', FALSE),
('email-etapas', 'cronograma_etapas', ARRAY['UPDATE'], 'https://api.sendgrid.com/xxx', FALSE)
ON CONFLICT (nome) DO NOTHING;

-- ============================================================
-- 10. RLS POLICIES
-- ============================================================

ALTER TABLE webhook_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE webhook_configs ENABLE ROW LEVEL SECURITY;

-- Apenas admins podem ver logs de webhook
DROP POLICY IF EXISTS "webhook_logs_admin" ON webhook_logs;
CREATE POLICY "webhook_logs_admin" ON webhook_logs FOR ALL USING (true);

DROP POLICY IF EXISTS "webhook_configs_admin" ON webhook_configs;
CREATE POLICY "webhook_configs_admin" ON webhook_configs FOR ALL USING (true);

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

SELECT 'webhook_logs' as tabela, COUNT(*) as registros FROM webhook_logs
UNION ALL
SELECT 'webhook_configs', COUNT(*) FROM webhook_configs
UNION ALL
SELECT 'notificacoes', COUNT(*) FROM notificacoes;

-- Verificar triggers criados
SELECT
  trigger_name,
  event_object_table as tabela,
  action_timing || ' ' || event_manipulation as evento
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name LIKE 'trigger_%'
ORDER BY event_object_table;
