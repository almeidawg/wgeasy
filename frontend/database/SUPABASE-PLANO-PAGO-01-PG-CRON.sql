-- ============================================================
-- SUPABASE PLANO PAGO - PARTE 1: pg_cron (Tarefas Agendadas)
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- O pg_cron permite agendar tarefas automáticas no banco de dados.
-- Isso substitui a necessidade de cron jobs externos ou workers.
--
-- IMPORTANTE: Execute no Supabase Dashboard > SQL Editor
-- ============================================================

-- ============================================================
-- 1. HABILITAR EXTENSÃO pg_cron (já vem habilitada no plano pago)
-- ============================================================

-- Verificar se pg_cron está disponível
SELECT * FROM pg_extension WHERE extname = 'pg_cron';

-- Se não estiver habilitada, habilitar:
-- CREATE EXTENSION IF NOT EXISTS pg_cron;

-- ============================================================
-- 2. TABELA: logs_cron (Registrar execuções)
-- ============================================================

CREATE TABLE IF NOT EXISTS logs_cron (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_name VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL, -- 'iniciado', 'sucesso', 'erro'
  detalhes JSONB DEFAULT '{}',
  registros_afetados INT DEFAULT 0,
  tempo_execucao_ms INT,
  erro_mensagem TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_logs_cron_job ON logs_cron(job_name);
CREATE INDEX IF NOT EXISTS idx_logs_cron_data ON logs_cron(criado_em DESC);

-- Nota: A limpeza de logs antigos é feita pela função cron_limpar_arquivos_temporarios()

-- ============================================================
-- 3. FUNÇÃO: Atualizar contratos vencidos
-- ============================================================

CREATE OR REPLACE FUNCTION cron_atualizar_contratos_vencidos()
RETURNS void AS $$
DECLARE
  v_count INT := 0;
  v_start TIMESTAMPTZ := NOW();
BEGIN
  -- Registrar início
  INSERT INTO logs_cron (job_name, status) VALUES ('contratos_vencidos', 'iniciado');

  -- Atualizar contratos com data de vigência expirada
  UPDATE contratos
  SET
    status = 'vencido',
    atualizado_em = NOW()
  WHERE
    status = 'ativo'
    AND data_vigencia_fim < CURRENT_DATE
    AND data_vigencia_fim IS NOT NULL;

  GET DIAGNOSTICS v_count = ROW_COUNT;

  -- Registrar conclusão
  UPDATE logs_cron
  SET
    status = 'sucesso',
    registros_afetados = v_count,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT,
    detalhes = jsonb_build_object('contratos_atualizados', v_count)
  WHERE job_name = 'contratos_vencidos'
    AND status = 'iniciado'
    AND criado_em >= v_start;

EXCEPTION WHEN OTHERS THEN
  UPDATE logs_cron
  SET
    status = 'erro',
    erro_mensagem = SQLERRM,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT
  WHERE job_name = 'contratos_vencidos'
    AND status = 'iniciado'
    AND criado_em >= v_start;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 4. FUNÇÃO: Atualizar parcelas vencidas
-- ============================================================

CREATE OR REPLACE FUNCTION cron_atualizar_parcelas_vencidas()
RETURNS void AS $$
DECLARE
  v_count INT := 0;
  v_start TIMESTAMPTZ := NOW();
BEGIN
  INSERT INTO logs_cron (job_name, status) VALUES ('parcelas_vencidas', 'iniciado');

  -- Marcar parcelas como vencidas
  UPDATE lancamentos
  SET
    status = 'vencido',
    atualizado_em = NOW()
  WHERE
    status = 'pendente'
    AND data_vencimento < CURRENT_DATE
    AND tipo = 'RECEBER';

  GET DIAGNOSTICS v_count = ROW_COUNT;

  UPDATE logs_cron
  SET
    status = 'sucesso',
    registros_afetados = v_count,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT,
    detalhes = jsonb_build_object('parcelas_marcadas_vencidas', v_count)
  WHERE job_name = 'parcelas_vencidas'
    AND status = 'iniciado'
    AND criado_em >= v_start;

EXCEPTION WHEN OTHERS THEN
  UPDATE logs_cron
  SET
    status = 'erro',
    erro_mensagem = SQLERRM,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT
  WHERE job_name = 'parcelas_vencidas'
    AND status = 'iniciado'
    AND criado_em >= v_start;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 5. FUNÇÃO: Limpar arquivos temporários antigos
-- ============================================================

CREATE OR REPLACE FUNCTION cron_limpar_arquivos_temporarios()
RETURNS void AS $$
DECLARE
  v_count INT := 0;
  v_start TIMESTAMPTZ := NOW();
BEGIN
  INSERT INTO logs_cron (job_name, status) VALUES ('limpar_temporarios', 'iniciado');

  -- Limpar uploads temporários com mais de 24 horas
  DELETE FROM arquivos
  WHERE
    temporario = TRUE
    AND criado_em < NOW() - INTERVAL '24 hours';

  GET DIAGNOSTICS v_count = ROW_COUNT;

  -- Limpar logs de cron antigos (mais de 30 dias)
  DELETE FROM logs_cron
  WHERE criado_em < NOW() - INTERVAL '30 days';

  UPDATE logs_cron
  SET
    status = 'sucesso',
    registros_afetados = v_count,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT,
    detalhes = jsonb_build_object('arquivos_removidos', v_count)
  WHERE job_name = 'limpar_temporarios'
    AND status = 'iniciado'
    AND criado_em >= v_start;

EXCEPTION WHEN OTHERS THEN
  UPDATE logs_cron
  SET
    status = 'erro',
    erro_mensagem = SQLERRM,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT
  WHERE job_name = 'limpar_temporarios'
    AND status = 'iniciado'
    AND criado_em >= v_start;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 6. FUNÇÃO: Consolidar métricas diárias
-- ============================================================

CREATE OR REPLACE FUNCTION cron_consolidar_metricas_diarias()
RETURNS void AS $$
DECLARE
  v_start TIMESTAMPTZ := NOW();
  v_data DATE := CURRENT_DATE - 1; -- Dia anterior
  v_metricas JSONB;
BEGIN
  INSERT INTO logs_cron (job_name, status) VALUES ('metricas_diarias', 'iniciado');

  -- Calcular métricas do dia anterior
  SELECT jsonb_build_object(
    'data', v_data,
    'oportunidades_criadas', (SELECT COUNT(*) FROM oportunidades WHERE DATE(criado_em) = v_data),
    'contratos_assinados', (SELECT COUNT(*) FROM contratos WHERE DATE(criado_em) = v_data AND status = 'ativo'),
    'valor_recebido', (SELECT COALESCE(SUM(valor), 0) FROM lancamentos WHERE DATE(data_pagamento) = v_data AND status = 'pago' AND tipo = 'RECEBER'),
    'valor_pago', (SELECT COALESCE(SUM(valor), 0) FROM lancamentos WHERE DATE(data_pagamento) = v_data AND status = 'pago' AND tipo = 'PAGAR'),
    'clientes_novos', (SELECT COUNT(*) FROM pessoas WHERE DATE(criado_em) = v_data AND tipo = 'CLIENTE')
  ) INTO v_metricas;

  -- Inserir ou atualizar métricas do dia
  INSERT INTO metricas_diarias (data, dados, criado_em)
  VALUES (v_data, v_metricas, NOW())
  ON CONFLICT (data) DO UPDATE SET dados = v_metricas, atualizado_em = NOW();

  UPDATE logs_cron
  SET
    status = 'sucesso',
    registros_afetados = 1,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT,
    detalhes = v_metricas
  WHERE job_name = 'metricas_diarias'
    AND status = 'iniciado'
    AND criado_em >= v_start;

EXCEPTION WHEN OTHERS THEN
  UPDATE logs_cron
  SET
    status = 'erro',
    erro_mensagem = SQLERRM,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT
  WHERE job_name = 'metricas_diarias'
    AND status = 'iniciado'
    AND criado_em >= v_start;
END;
$$ LANGUAGE plpgsql;

-- Criar tabela de métricas se não existir
CREATE TABLE IF NOT EXISTS metricas_diarias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data DATE UNIQUE NOT NULL,
  dados JSONB DEFAULT '{}',
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 7. FUNÇÃO: Gerar lembretes de pagamento
-- ============================================================

CREATE OR REPLACE FUNCTION cron_gerar_lembretes_pagamento()
RETURNS void AS $$
DECLARE
  v_count INT := 0;
  v_start TIMESTAMPTZ := NOW();
BEGIN
  INSERT INTO logs_cron (job_name, status) VALUES ('lembretes_pagamento', 'iniciado');

  -- Inserir lembretes para parcelas que vencem em 3 dias
  INSERT INTO notificacoes (
    tipo,
    titulo,
    mensagem,
    destinatario_id,
    referencia_tipo,
    referencia_id,
    dados
  )
  SELECT
    'LEMBRETE_PAGAMENTO',
    'Pagamento próximo do vencimento',
    'Sua parcela de R$ ' || TO_CHAR(l.valor, 'FM999G999D00') || ' vence em ' || TO_CHAR(l.data_vencimento, 'DD/MM/YYYY'),
    c.cliente_id,
    'lancamento',
    l.id,
    jsonb_build_object(
      'valor', l.valor,
      'vencimento', l.data_vencimento,
      'contrato_id', l.contrato_id
    )
  FROM lancamentos l
  JOIN contratos c ON c.id = l.contrato_id
  WHERE
    l.status = 'pendente'
    AND l.tipo = 'RECEBER'
    AND l.data_vencimento = CURRENT_DATE + INTERVAL '3 days'
    AND NOT EXISTS (
      SELECT 1 FROM notificacoes n
      WHERE n.referencia_id = l.id
        AND n.tipo = 'LEMBRETE_PAGAMENTO'
        AND DATE(n.criado_em) = CURRENT_DATE
    );

  GET DIAGNOSTICS v_count = ROW_COUNT;

  UPDATE logs_cron
  SET
    status = 'sucesso',
    registros_afetados = v_count,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT,
    detalhes = jsonb_build_object('lembretes_gerados', v_count)
  WHERE job_name = 'lembretes_pagamento'
    AND status = 'iniciado'
    AND criado_em >= v_start;

EXCEPTION WHEN OTHERS THEN
  UPDATE logs_cron
  SET
    status = 'erro',
    erro_mensagem = SQLERRM,
    tempo_execucao_ms = EXTRACT(MILLISECONDS FROM (NOW() - v_start))::INT
  WHERE job_name = 'lembretes_pagamento'
    AND status = 'iniciado'
    AND criado_em >= v_start;
END;
$$ LANGUAGE plpgsql;

-- Criar tabela de notificações se não existir
CREATE TABLE IF NOT EXISTS notificacoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tipo VARCHAR(50) NOT NULL,
  titulo VARCHAR(255) NOT NULL,
  mensagem TEXT,
  destinatario_id UUID REFERENCES pessoas(id),
  referencia_tipo VARCHAR(50),
  referencia_id UUID,
  dados JSONB DEFAULT '{}',
  lida BOOLEAN DEFAULT FALSE,
  lida_em TIMESTAMPTZ,
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notificacoes_destinatario ON notificacoes(destinatario_id);
CREATE INDEX IF NOT EXISTS idx_notificacoes_tipo ON notificacoes(tipo);
CREATE INDEX IF NOT EXISTS idx_notificacoes_lida ON notificacoes(lida) WHERE lida = FALSE;

-- ============================================================
-- 8. AGENDAR JOBS COM pg_cron
-- ============================================================

-- IMPORTANTE: Execute estes comandos separadamente no SQL Editor

-- Job: Atualizar contratos vencidos (todo dia às 00:05)
-- SELECT cron.schedule('contratos-vencidos', '5 0 * * *', 'SELECT cron_atualizar_contratos_vencidos()');

-- Job: Atualizar parcelas vencidas (todo dia às 00:10)
-- SELECT cron.schedule('parcelas-vencidas', '10 0 * * *', 'SELECT cron_atualizar_parcelas_vencidas()');

-- Job: Limpar arquivos temporários (todo dia às 03:00)
-- SELECT cron.schedule('limpar-temporarios', '0 3 * * *', 'SELECT cron_limpar_arquivos_temporarios()');

-- Job: Consolidar métricas (todo dia às 01:00)
-- SELECT cron.schedule('metricas-diarias', '0 1 * * *', 'SELECT cron_consolidar_metricas_diarias()');

-- Job: Gerar lembretes de pagamento (todo dia às 08:00)
-- SELECT cron.schedule('lembretes-pagamento', '0 8 * * *', 'SELECT cron_gerar_lembretes_pagamento()');

-- ============================================================
-- 9. COMANDOS ÚTEIS PARA GERENCIAR JOBS
-- ============================================================

-- Listar todos os jobs agendados:
-- SELECT * FROM cron.job;

-- Ver histórico de execuções:
-- SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 20;

-- Remover um job:
-- SELECT cron.unschedule('nome-do-job');

-- Executar job manualmente (para teste):
-- SELECT cron_atualizar_contratos_vencidos();

-- ============================================================
-- 10. VIEW: Monitoramento de Jobs
-- ============================================================

CREATE OR REPLACE VIEW view_cron_status AS
SELECT
  job_name,
  COUNT(*) FILTER (WHERE status = 'sucesso') as execucoes_sucesso,
  COUNT(*) FILTER (WHERE status = 'erro') as execucoes_erro,
  MAX(criado_em) FILTER (WHERE status = 'sucesso') as ultima_execucao_sucesso,
  MAX(criado_em) FILTER (WHERE status = 'erro') as ultimo_erro,
  AVG(tempo_execucao_ms) FILTER (WHERE status = 'sucesso') as tempo_medio_ms,
  SUM(registros_afetados) FILTER (WHERE status = 'sucesso') as total_registros_afetados
FROM logs_cron
WHERE criado_em > NOW() - INTERVAL '7 days'
GROUP BY job_name
ORDER BY job_name;

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

SELECT 'logs_cron' as tabela, COUNT(*) as registros FROM logs_cron
UNION ALL
SELECT 'metricas_diarias', COUNT(*) FROM metricas_diarias
UNION ALL
SELECT 'notificacoes', COUNT(*) FROM notificacoes;

-- Verificar funções criadas
SELECT proname as funcao
FROM pg_proc
WHERE proname LIKE 'cron_%'
ORDER BY proname;
