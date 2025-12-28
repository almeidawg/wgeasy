-- ============================================================
-- SUPABASE PLANO PAGO - PARTE 6: Point-in-Time Recovery (PITR)
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- PITR permite restaurar o banco para qualquer momento no tempo
-- dentro da janela de retenção (até 7 dias no plano Pro).
--
-- IMPORTANTE: PITR é configurado automaticamente no plano pago.
-- Este arquivo contém scripts auxiliares e boas práticas.
--
-- DOCUMENTAÇÃO: https://supabase.com/docs/guides/platform/backups
-- ============================================================

-- ============================================================
-- 1. COMO FUNCIONA O PITR
-- ============================================================
--
-- O PITR usa WAL (Write-Ahead Logging) do PostgreSQL para
-- registrar todas as mudanças no banco. Isso permite:
--
-- - Restaurar para qualquer segundo dos últimos 7 dias
-- - Recuperar dados deletados acidentalmente
-- - Criar snapshots antes de operações arriscadas
-- - Clonar o banco para análise forense
--
-- PROCESSO DE RESTAURAÇÃO:
-- 1. Acesse Dashboard > Database > Backups
-- 2. Selecione a data/hora desejada
-- 3. Clique em "Restore" para restaurar in-place OU
-- 4. Clique em "Clone" para criar um novo projeto com os dados

-- ============================================================
-- 2. TABELA: audit_trail (Trilha de auditoria detalhada)
-- ============================================================
--
-- Mesmo com PITR, é útil ter uma trilha de auditoria no app

CREATE TABLE IF NOT EXISTS audit_trail (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tabela VARCHAR(100) NOT NULL,
  registro_id UUID,
  operacao VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
  dados_antes JSONB,
  dados_depois JSONB,
  campos_alterados TEXT[],
  usuario_id UUID,
  usuario_email VARCHAR(255),
  ip_address VARCHAR(45),
  user_agent TEXT,
  sessao_id VARCHAR(100),
  criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para consultas frequentes
CREATE INDEX IF NOT EXISTS idx_audit_tabela ON audit_trail(tabela);
CREATE INDEX IF NOT EXISTS idx_audit_registro ON audit_trail(registro_id);
CREATE INDEX IF NOT EXISTS idx_audit_usuario ON audit_trail(usuario_id);
CREATE INDEX IF NOT EXISTS idx_audit_data ON audit_trail(criado_em DESC);
CREATE INDEX IF NOT EXISTS idx_audit_operacao ON audit_trail(operacao);

-- Particionar por data para performance (opcional)
-- CREATE TABLE audit_trail_2024_12 PARTITION OF audit_trail
--   FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');

-- ============================================================
-- 3. FUNÇÃO: Registrar auditoria automaticamente
-- ============================================================

CREATE OR REPLACE FUNCTION fn_audit_trigger()
RETURNS TRIGGER AS $$
DECLARE
  v_dados_antes JSONB;
  v_dados_depois JSONB;
  v_campos_alterados TEXT[];
  v_usuario_id UUID;
  v_usuario_email VARCHAR;
BEGIN
  -- Capturar dados
  IF TG_OP = 'DELETE' THEN
    v_dados_antes := to_jsonb(OLD);
    v_dados_depois := NULL;
  ELSIF TG_OP = 'INSERT' THEN
    v_dados_antes := NULL;
    v_dados_depois := to_jsonb(NEW);
  ELSE -- UPDATE
    v_dados_antes := to_jsonb(OLD);
    v_dados_depois := to_jsonb(NEW);

    -- Identificar campos alterados
    SELECT ARRAY_AGG(key)
    INTO v_campos_alterados
    FROM jsonb_each(v_dados_antes) old_data
    WHERE old_data.value IS DISTINCT FROM (v_dados_depois->old_data.key);
  END IF;

  -- Tentar obter usuário atual
  BEGIN
    v_usuario_id := auth.uid();
    SELECT email INTO v_usuario_email FROM auth.users WHERE id = v_usuario_id;
  EXCEPTION WHEN OTHERS THEN
    v_usuario_id := NULL;
    v_usuario_email := 'system';
  END;

  -- Inserir registro de auditoria
  INSERT INTO audit_trail (
    tabela,
    registro_id,
    operacao,
    dados_antes,
    dados_depois,
    campos_alterados,
    usuario_id,
    usuario_email
  ) VALUES (
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    TG_OP,
    v_dados_antes,
    v_dados_depois,
    v_campos_alterados,
    v_usuario_id,
    v_usuario_email
  );

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 4. APLICAR AUDITORIA NAS TABELAS CRÍTICAS
-- ============================================================

-- Auditoria em contratos
DROP TRIGGER IF EXISTS audit_contratos ON contratos;
CREATE TRIGGER audit_contratos
  AFTER INSERT OR UPDATE OR DELETE ON contratos
  FOR EACH ROW EXECUTE FUNCTION fn_audit_trigger();

-- Auditoria em oportunidades
DROP TRIGGER IF EXISTS audit_oportunidades ON oportunidades;
CREATE TRIGGER audit_oportunidades
  AFTER INSERT OR UPDATE OR DELETE ON oportunidades
  FOR EACH ROW EXECUTE FUNCTION fn_audit_trigger();

-- Auditoria em pessoas
DROP TRIGGER IF EXISTS audit_pessoas ON pessoas;
CREATE TRIGGER audit_pessoas
  AFTER INSERT OR UPDATE OR DELETE ON pessoas
  FOR EACH ROW EXECUTE FUNCTION fn_audit_trigger();

-- Auditoria em usuarios
DROP TRIGGER IF EXISTS audit_usuarios ON usuarios;
CREATE TRIGGER audit_usuarios
  AFTER INSERT OR UPDATE OR DELETE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION fn_audit_trigger();

-- ============================================================
-- 5. TABELA: recovery_points (Pontos de recuperação)
-- ============================================================
--
-- Marcar momentos importantes para facilitar restauração

CREATE TABLE IF NOT EXISTS recovery_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  timestamp_marcado TIMESTAMPTZ DEFAULT NOW(),
  tipo VARCHAR(50) DEFAULT 'manual', -- manual, pre_deploy, pre_migration
  ambiente VARCHAR(50) DEFAULT 'production',
  criado_por UUID REFERENCES usuarios(id),
  dados_contexto JSONB DEFAULT '{}'
);

CREATE INDEX IF NOT EXISTS idx_recovery_timestamp ON recovery_points(timestamp_marcado DESC);
CREATE INDEX IF NOT EXISTS idx_recovery_tipo ON recovery_points(tipo);

-- ============================================================
-- 6. FUNÇÃO: Criar ponto de recuperação
-- ============================================================

CREATE OR REPLACE FUNCTION criar_ponto_recuperacao(
  p_nome VARCHAR,
  p_descricao TEXT DEFAULT NULL,
  p_tipo VARCHAR DEFAULT 'manual'
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
  v_stats JSONB;
BEGIN
  -- Capturar estatísticas atuais
  SELECT jsonb_build_object(
    'total_pessoas', (SELECT COUNT(*) FROM pessoas),
    'total_contratos', (SELECT COUNT(*) FROM contratos),
    'total_oportunidades', (SELECT COUNT(*) FROM oportunidades),
    'ultimo_contrato', (SELECT MAX(criado_em) FROM contratos),
    'ultima_oportunidade', (SELECT MAX(criado_em) FROM oportunidades)
  ) INTO v_stats;

  INSERT INTO recovery_points (
    nome, descricao, tipo, criado_por, dados_contexto
  ) VALUES (
    p_nome, p_descricao, p_tipo, auth.uid(), v_stats
  )
  RETURNING id INTO v_id;

  RAISE NOTICE 'Ponto de recuperação criado: % em %', p_nome, NOW();

  RETURN v_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 7. FUNÇÃO: Listar histórico de alterações de um registro
-- ============================================================

CREATE OR REPLACE FUNCTION historico_registro(
  p_tabela VARCHAR,
  p_registro_id UUID
)
RETURNS TABLE (
  operacao VARCHAR,
  quando TIMESTAMPTZ,
  quem VARCHAR,
  campos_alterados TEXT[],
  dados_antes JSONB,
  dados_depois JSONB
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    a.operacao,
    a.criado_em,
    a.usuario_email,
    a.campos_alterados,
    a.dados_antes,
    a.dados_depois
  FROM audit_trail a
  WHERE a.tabela = p_tabela
    AND a.registro_id = p_registro_id
  ORDER BY a.criado_em DESC;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================
-- 8. VIEW: Atividades recentes (para dashboard admin)
-- ============================================================

CREATE OR REPLACE VIEW view_atividades_recentes AS
SELECT
  a.tabela,
  a.operacao,
  a.registro_id,
  a.usuario_email,
  a.campos_alterados,
  a.criado_em,
  CASE
    WHEN a.tabela = 'contratos' THEN (a.dados_depois->>'numero')
    WHEN a.tabela = 'pessoas' THEN (a.dados_depois->>'nome')
    WHEN a.tabela = 'oportunidades' THEN (a.dados_depois->>'titulo')
    ELSE a.registro_id::text
  END as descricao_registro
FROM audit_trail a
WHERE a.criado_em > NOW() - INTERVAL '24 hours'
ORDER BY a.criado_em DESC
LIMIT 100;

-- ============================================================
-- 9. FUNÇÃO: Comparar dois pontos no tempo
-- ============================================================

CREATE OR REPLACE FUNCTION comparar_periodos(
  p_tabela VARCHAR,
  p_inicio TIMESTAMPTZ,
  p_fim TIMESTAMPTZ
)
RETURNS TABLE (
  total_inserts BIGINT,
  total_updates BIGINT,
  total_deletes BIGINT,
  registros_afetados BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*) FILTER (WHERE operacao = 'INSERT'),
    COUNT(*) FILTER (WHERE operacao = 'UPDATE'),
    COUNT(*) FILTER (WHERE operacao = 'DELETE'),
    COUNT(DISTINCT registro_id)
  FROM audit_trail
  WHERE tabela = p_tabela
    AND criado_em BETWEEN p_inicio AND p_fim;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================
-- 10. LIMPEZA DE DADOS ANTIGOS
-- ============================================================

CREATE OR REPLACE FUNCTION limpar_audit_antigo(
  p_dias_manter INT DEFAULT 90
)
RETURNS INT AS $$
DECLARE
  v_count INT;
BEGIN
  -- Manter apenas últimos N dias de auditoria
  DELETE FROM audit_trail
  WHERE criado_em < NOW() - (p_dias_manter || ' days')::INTERVAL;

  GET DIAGNOSTICS v_count = ROW_COUNT;

  RAISE NOTICE 'Removidos % registros de auditoria com mais de % dias', v_count, p_dias_manter;

  RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 11. RLS POLICIES
-- ============================================================

ALTER TABLE audit_trail ENABLE ROW LEVEL SECURITY;
ALTER TABLE recovery_points ENABLE ROW LEVEL SECURITY;

-- Apenas admins podem ver auditoria
DROP POLICY IF EXISTS "audit_admin_select" ON audit_trail;
CREATE POLICY "audit_admin_select" ON audit_trail
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.auth_user_id = auth.uid()
      AND u.tipo_usuario IN ('MASTER', 'ADMIN')
    )
  );

-- Apenas sistema pode inserir auditoria
DROP POLICY IF EXISTS "audit_system_insert" ON audit_trail;
CREATE POLICY "audit_system_insert" ON audit_trail
  FOR INSERT WITH CHECK (true);

-- Recovery points: admins podem ver e criar
DROP POLICY IF EXISTS "recovery_admin_all" ON recovery_points;
CREATE POLICY "recovery_admin_all" ON recovery_points
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.auth_user_id = auth.uid()
      AND u.tipo_usuario IN ('MASTER', 'ADMIN')
    )
  );

-- ============================================================
-- 12. AGENDAR LIMPEZA (pg_cron)
-- ============================================================

-- Job: Limpar auditoria antiga (todo domingo às 04:00)
-- SELECT cron.schedule('limpar-audit', '0 4 * * 0', 'SELECT limpar_audit_antigo(90)');

-- ============================================================
-- 13. CRIAR PONTO DE RECUPERAÇÃO INICIAL
-- ============================================================

SELECT criar_ponto_recuperacao(
  'Configuração PITR',
  'Ponto de recuperação após configuração de PITR e auditoria',
  'post_config'
);

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

-- Contar registros
SELECT 'audit_trail' as tabela, COUNT(*) as registros FROM audit_trail
UNION ALL
SELECT 'recovery_points', COUNT(*) FROM recovery_points;

-- Listar triggers de auditoria
SELECT
  trigger_name,
  event_object_table as tabela,
  action_timing || ' ' || event_manipulation as evento
FROM information_schema.triggers
WHERE trigger_schema = 'public'
  AND trigger_name LIKE 'audit_%'
ORDER BY event_object_table;

-- Listar pontos de recuperação
SELECT nome, timestamp_marcado, tipo FROM recovery_points ORDER BY timestamp_marcado DESC;

-- ============================================================
-- RESUMO: BOAS PRÁTICAS DE BACKUP
-- ============================================================
--
-- 1. ANTES DE GRANDES MUDANÇAS:
--    SELECT criar_ponto_recuperacao('Pre-Deploy v1.5', 'Antes do deploy da versão 1.5', 'pre_deploy');
--
-- 2. ANTES DE MIGRAÇÕES:
--    SELECT criar_ponto_recuperacao('Pre-Migration', 'Antes de alterar schema', 'pre_migration');
--
-- 3. VERIFICAR HISTÓRICO:
--    SELECT * FROM historico_registro('contratos', 'uuid-do-contrato');
--
-- 4. VER ATIVIDADES RECENTES:
--    SELECT * FROM view_atividades_recentes;
--
-- 5. PARA RESTAURAR:
--    - Acesse Dashboard > Database > Backups
--    - Encontre o ponto de recuperação desejado
--    - Use Clone para criar novo projeto ou Restore para restaurar
