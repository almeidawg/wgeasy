-- ============================================================
-- SUPABASE PLANO PAGO - PARTE 4: Realtime Subscriptions
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- Realtime permite receber atualizações instantâneas do banco
-- via WebSocket. Ideal para notificações, chat, dashboards.
--
-- DOCUMENTAÇÃO: https://supabase.com/docs/guides/realtime
-- ============================================================

-- ============================================================
-- 1. HABILITAR REALTIME NAS TABELAS
-- ============================================================
--
-- Para habilitar Realtime em uma tabela, você precisa:
-- 1. Adicionar a tabela à publicação 'supabase_realtime'
-- 2. Garantir que RLS está habilitado
-- 3. O cliente usa o canal correto

-- Habilitar Realtime para notificações (essencial para UX)
ALTER PUBLICATION supabase_realtime ADD TABLE notificacoes;

-- Habilitar Realtime para oportunidades (CRM em tempo real)
ALTER PUBLICATION supabase_realtime ADD TABLE oportunidades;

-- Habilitar Realtime para contratos (atualizações de status)
ALTER PUBLICATION supabase_realtime ADD TABLE contratos;

-- Habilitar Realtime para timeline (histórico ao vivo)
ALTER PUBLICATION supabase_realtime ADD TABLE oportunidade_timeline;

-- Habilitar Realtime para mensagens/comentários
-- (Adicione quando criar tabela de mensagens)
-- ALTER PUBLICATION supabase_realtime ADD TABLE mensagens;

-- ============================================================
-- 2. CONFIGURAR REPLICA IDENTITY
-- ============================================================
--
-- REPLICA IDENTITY determina quais dados são enviados no evento
-- FULL = envia registro completo (OLD e NEW)
-- DEFAULT = envia apenas PRIMARY KEY

-- Notificações: enviar registro completo
ALTER TABLE notificacoes REPLICA IDENTITY FULL;

-- Oportunidades: enviar registro completo
ALTER TABLE oportunidades REPLICA IDENTITY FULL;

-- Contratos: enviar registro completo
ALTER TABLE contratos REPLICA IDENTITY FULL;

-- Timeline: enviar registro completo
ALTER TABLE oportunidade_timeline REPLICA IDENTITY FULL;

-- ============================================================
-- 3. TABELA: realtime_presence (Presença de usuários)
-- ============================================================
--
-- Rastrear usuários online e sua localização no sistema

CREATE TABLE IF NOT EXISTS realtime_presence (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'online', -- online, away, busy, offline
  pagina_atual VARCHAR(255),
  ultimo_heartbeat TIMESTAMPTZ DEFAULT NOW(),
  dados JSONB DEFAULT '{}',
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índice para buscar usuários online
CREATE INDEX IF NOT EXISTS idx_presence_user ON realtime_presence(user_id);
CREATE INDEX IF NOT EXISTS idx_presence_status ON realtime_presence(status);
CREATE INDEX IF NOT EXISTS idx_presence_heartbeat ON realtime_presence(ultimo_heartbeat);

-- Garantir apenas um registro por usuário
CREATE UNIQUE INDEX IF NOT EXISTS idx_presence_user_unique ON realtime_presence(user_id);

-- Habilitar Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE realtime_presence;
ALTER TABLE realtime_presence REPLICA IDENTITY FULL;

-- ============================================================
-- 4. FUNÇÃO: Atualizar presença do usuário
-- ============================================================

CREATE OR REPLACE FUNCTION atualizar_presenca(
  p_status VARCHAR DEFAULT 'online',
  p_pagina VARCHAR DEFAULT NULL,
  p_dados JSONB DEFAULT '{}'
)
RETURNS void AS $$
BEGIN
  INSERT INTO realtime_presence (user_id, status, pagina_atual, ultimo_heartbeat, dados)
  VALUES (auth.uid(), p_status, p_pagina, NOW(), p_dados)
  ON CONFLICT (user_id) DO UPDATE SET
    status = p_status,
    pagina_atual = COALESCE(p_pagina, realtime_presence.pagina_atual),
    ultimo_heartbeat = NOW(),
    dados = realtime_presence.dados || p_dados;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 5. FUNÇÃO: Marcar usuários inativos
-- ============================================================

CREATE OR REPLACE FUNCTION marcar_usuarios_inativos()
RETURNS void AS $$
BEGIN
  -- Marcar como away após 5 minutos sem heartbeat
  UPDATE realtime_presence
  SET status = 'away'
  WHERE status = 'online'
    AND ultimo_heartbeat < NOW() - INTERVAL '5 minutes';

  -- Marcar como offline após 15 minutos
  UPDATE realtime_presence
  SET status = 'offline'
  WHERE status IN ('online', 'away')
    AND ultimo_heartbeat < NOW() - INTERVAL '15 minutes';

  -- Remover registros muito antigos (24h)
  DELETE FROM realtime_presence
  WHERE ultimo_heartbeat < NOW() - INTERVAL '24 hours';
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 6. TABELA: realtime_typing (Indicador de digitação)
-- ============================================================

CREATE TABLE IF NOT EXISTS realtime_typing (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  canal VARCHAR(100) NOT NULL, -- Ex: 'oportunidade:uuid', 'contrato:uuid'
  iniciado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_typing_canal ON realtime_typing(canal);
CREATE INDEX IF NOT EXISTS idx_typing_user ON realtime_typing(user_id);

-- Limpar indicadores antigos (mais de 10 segundos)
CREATE OR REPLACE FUNCTION limpar_typing_antigos()
RETURNS void AS $$
BEGIN
  DELETE FROM realtime_typing
  WHERE iniciado_em < NOW() - INTERVAL '10 seconds';
END;
$$ LANGUAGE plpgsql;

-- Habilitar Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE realtime_typing;
ALTER TABLE realtime_typing REPLICA IDENTITY FULL;

-- ============================================================
-- 7. FUNÇÃO: Indicar digitação
-- ============================================================

CREATE OR REPLACE FUNCTION indicar_digitando(
  p_canal VARCHAR
)
RETURNS void AS $$
BEGIN
  -- Inserir ou atualizar indicador
  INSERT INTO realtime_typing (user_id, canal, iniciado_em)
  VALUES (auth.uid(), p_canal, NOW())
  ON CONFLICT (user_id, canal) DO UPDATE SET
    iniciado_em = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Criar índice único para upsert
CREATE UNIQUE INDEX IF NOT EXISTS idx_typing_user_canal ON realtime_typing(user_id, canal);

-- ============================================================
-- 8. VIEW: Usuários online agora
-- ============================================================

CREATE OR REPLACE VIEW view_usuarios_online AS
SELECT
  rp.user_id,
  p.email,
  p.nome,
  p.avatar_url,
  rp.status,
  rp.pagina_atual,
  rp.ultimo_heartbeat,
  EXTRACT(EPOCH FROM (NOW() - rp.ultimo_heartbeat))::INT as segundos_inativo
FROM realtime_presence rp
JOIN usuarios u ON u.id = rp.user_id
LEFT JOIN pessoas p ON p.id = u.pessoa_id
WHERE rp.status IN ('online', 'away', 'busy')
ORDER BY rp.ultimo_heartbeat DESC;

-- ============================================================
-- 9. FUNÇÃO: Broadcast de notificação
-- ============================================================

CREATE OR REPLACE FUNCTION broadcast_notificacao(
  p_tipo VARCHAR,
  p_titulo VARCHAR,
  p_mensagem TEXT,
  p_destinatario_ids UUID[],
  p_dados JSONB DEFAULT '{}'
)
RETURNS void AS $$
DECLARE
  v_destinatario_id UUID;
BEGIN
  -- Criar notificação para cada destinatário
  FOREACH v_destinatario_id IN ARRAY p_destinatario_ids
  LOOP
    INSERT INTO notificacoes (
      tipo,
      titulo,
      mensagem,
      destinatario_id,
      dados
    ) VALUES (
      p_tipo,
      p_titulo,
      p_mensagem,
      v_destinatario_id,
      p_dados
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 10. TRIGGER: Notificar equipe sobre nova oportunidade
-- ============================================================

CREATE OR REPLACE FUNCTION trigger_notificar_equipe_oportunidade()
RETURNS TRIGGER AS $$
DECLARE
  v_usuarios UUID[];
  v_cliente_nome VARCHAR;
BEGIN
  -- Buscar nome do cliente
  SELECT nome INTO v_cliente_nome FROM pessoas WHERE id = NEW.cliente_id;

  -- Buscar usuários da equipe (vendedores e admins)
  SELECT ARRAY_AGG(p.id)
  INTO v_usuarios
  FROM usuarios u
  JOIN pessoas p ON p.id = u.pessoa_id
  WHERE u.tipo_usuario IN ('MASTER', 'ADMIN', 'VENDEDOR')
    AND u.ativo = TRUE
    AND u.id != COALESCE(NEW.responsavel_id, '00000000-0000-0000-0000-000000000000'::uuid);

  -- Notificar equipe
  IF v_usuarios IS NOT NULL AND array_length(v_usuarios, 1) > 0 THEN
    PERFORM broadcast_notificacao(
      'NOVA_OPORTUNIDADE',
      'Nova Oportunidade: ' || NEW.titulo,
      'Cliente: ' || COALESCE(v_cliente_nome, 'Não informado') ||
      ' | Valor: R$ ' || COALESCE(TO_CHAR(NEW.valor_estimado, 'FM999G999D00'), '0,00'),
      v_usuarios,
      jsonb_build_object(
        'oportunidade_id', NEW.id,
        'cliente_id', NEW.cliente_id,
        'cliente_nome', v_cliente_nome,
        'valor', NEW.valor_estimado
      )
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_nova_oportunidade_notificar ON oportunidades;
CREATE TRIGGER trigger_nova_oportunidade_notificar
  AFTER INSERT ON oportunidades
  FOR EACH ROW
  EXECUTE FUNCTION trigger_notificar_equipe_oportunidade();

-- ============================================================
-- 11. RLS POLICIES
-- ============================================================

ALTER TABLE realtime_presence ENABLE ROW LEVEL SECURITY;
ALTER TABLE realtime_typing ENABLE ROW LEVEL SECURITY;

-- Presença: todos autenticados podem ver
DROP POLICY IF EXISTS "presence_select" ON realtime_presence;
CREATE POLICY "presence_select" ON realtime_presence
  FOR SELECT USING (auth.role() = 'authenticated');

-- Presença: cada usuário gerencia o seu
DROP POLICY IF EXISTS "presence_insert" ON realtime_presence;
CREATE POLICY "presence_insert" ON realtime_presence
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "presence_update" ON realtime_presence;
CREATE POLICY "presence_update" ON realtime_presence
  FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "presence_delete" ON realtime_presence;
CREATE POLICY "presence_delete" ON realtime_presence
  FOR DELETE USING (auth.uid() = user_id);

-- Typing: todos autenticados podem ver
DROP POLICY IF EXISTS "typing_select" ON realtime_typing;
CREATE POLICY "typing_select" ON realtime_typing
  FOR SELECT USING (auth.role() = 'authenticated');

-- Typing: cada usuário gerencia o seu
DROP POLICY IF EXISTS "typing_insert" ON realtime_typing;
CREATE POLICY "typing_insert" ON realtime_typing
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "typing_delete" ON realtime_typing;
CREATE POLICY "typing_delete" ON realtime_typing
  FOR DELETE USING (auth.uid() = user_id);

-- ============================================================
-- 12. AGENDAR LIMPEZA (usar pg_cron)
-- ============================================================

-- Job: Marcar usuários inativos (a cada 5 minutos)
-- SELECT cron.schedule('presenca-inativos', '*/5 * * * *', 'SELECT marcar_usuarios_inativos()');

-- Job: Limpar indicadores de digitação (a cada minuto)
-- SELECT cron.schedule('limpar-typing', '* * * * *', 'SELECT limpar_typing_antigos()');

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

-- Verificar tabelas na publicação Realtime
SELECT schemaname, tablename
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime';

-- Verificar REPLICA IDENTITY das tabelas
SELECT
  c.relname as tabela,
  CASE c.relreplident
    WHEN 'd' THEN 'DEFAULT'
    WHEN 'n' THEN 'NOTHING'
    WHEN 'f' THEN 'FULL'
    WHEN 'i' THEN 'INDEX'
  END as replica_identity
FROM pg_class c
WHERE c.relname IN ('notificacoes', 'oportunidades', 'contratos', 'oportunidade_timeline', 'realtime_presence', 'realtime_typing');

-- Contar registros
SELECT 'realtime_presence' as tabela, COUNT(*) as registros FROM realtime_presence
UNION ALL
SELECT 'realtime_typing', COUNT(*) FROM realtime_typing;
