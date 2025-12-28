-- ============================================================
-- SUPABASE PLANO PAGO - PARTE 5: Database Branching
-- Sistema WG Easy - Grupo WG Almeida
-- Data: 2024-12-27
-- ============================================================
--
-- Database Branching permite criar cópias do banco de produção
-- para desenvolvimento e testes, similar a branches do Git.
--
-- IMPORTANTE: Branching é configurado via Dashboard ou CLI
-- Este arquivo contém apenas a documentação e scripts auxiliares.
--
-- DOCUMENTAÇÃO: https://supabase.com/docs/guides/platform/branching
-- ============================================================

-- ============================================================
-- 1. COMO FUNCIONA O BRANCHING
-- ============================================================
--
-- O Supabase Branching cria uma cópia completa do seu banco:
-- - Schema (tabelas, funções, triggers, etc.)
-- - Dados (opcional - pode copiar ou começar vazio)
-- - Políticas RLS
-- - Storage buckets
--
-- CASOS DE USO:
-- - Testar migrações antes de aplicar em produção
-- - Desenvolver novas features sem afetar produção
-- - Criar ambientes de QA/staging
-- - Fazer demos para clientes
--
-- LIMITAÇÕES:
-- - Branches têm custo adicional (cobrado por hora)
-- - Dados não são sincronizados automaticamente
-- - Edge Functions precisam ser deployadas separadamente

-- ============================================================
-- 2. TABELA: migrations_log (Controle de migrações)
-- ============================================================
--
-- Registrar migrações aplicadas para controle de versão

CREATE TABLE IF NOT EXISTS migrations_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  versao VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  script_sql TEXT,
  hash_script VARCHAR(64),
  aplicado_por VARCHAR(100),
  ambiente VARCHAR(50) DEFAULT 'production', -- production, staging, development
  aplicado_em TIMESTAMPTZ DEFAULT NOW(),
  tempo_execucao_ms INT,
  sucesso BOOLEAN DEFAULT TRUE,
  erro_mensagem TEXT
);

CREATE INDEX IF NOT EXISTS idx_migrations_versao ON migrations_log(versao);
CREATE INDEX IF NOT EXISTS idx_migrations_ambiente ON migrations_log(ambiente);
CREATE INDEX IF NOT EXISTS idx_migrations_data ON migrations_log(aplicado_em DESC);

-- ============================================================
-- 3. FUNÇÃO: Registrar migração
-- ============================================================

CREATE OR REPLACE FUNCTION registrar_migracao(
  p_versao VARCHAR,
  p_nome VARCHAR,
  p_descricao TEXT DEFAULT NULL,
  p_script_sql TEXT DEFAULT NULL,
  p_ambiente VARCHAR DEFAULT 'production'
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO migrations_log (
    versao, nome, descricao, script_sql,
    hash_script, ambiente, aplicado_por
  ) VALUES (
    p_versao, p_nome, p_descricao, p_script_sql,
    CASE WHEN p_script_sql IS NOT NULL THEN encode(sha256(p_script_sql::bytea), 'hex') ELSE NULL END,
    p_ambiente,
    current_user
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 4. TABELA: branch_config (Configuração por ambiente)
-- ============================================================

CREATE TABLE IF NOT EXISTS branch_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chave VARCHAR(100) NOT NULL,
  valor TEXT,
  ambiente VARCHAR(50) NOT NULL DEFAULT 'production',
  descricao TEXT,
  criado_em TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(chave, ambiente)
);

-- Inserir configurações padrão
INSERT INTO branch_config (chave, valor, ambiente, descricao) VALUES
  ('app_name', 'WG Easy', 'production', 'Nome da aplicação'),
  ('debug_mode', 'false', 'production', 'Modo debug'),
  ('log_level', 'error', 'production', 'Nível de log'),
  ('maintenance_mode', 'false', 'production', 'Modo manutenção'),
  ('feature_nova_timeline', 'true', 'production', 'Feature flag: Nova timeline'),
  ('feature_chat', 'false', 'production', 'Feature flag: Chat em tempo real'),
  ('max_upload_size_mb', '50', 'production', 'Tamanho máximo de upload em MB'),
  ('email_provider', 'resend', 'production', 'Provedor de email')
ON CONFLICT (chave, ambiente) DO NOTHING;

-- ============================================================
-- 5. FUNÇÃO: Obter configuração
-- ============================================================

CREATE OR REPLACE FUNCTION get_config(
  p_chave VARCHAR,
  p_ambiente VARCHAR DEFAULT 'production'
)
RETURNS TEXT AS $$
DECLARE
  v_valor TEXT;
BEGIN
  SELECT valor INTO v_valor
  FROM branch_config
  WHERE chave = p_chave
    AND ambiente = p_ambiente;

  RETURN v_valor;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================
-- 6. FUNÇÃO: Definir configuração
-- ============================================================

CREATE OR REPLACE FUNCTION set_config(
  p_chave VARCHAR,
  p_valor TEXT,
  p_ambiente VARCHAR DEFAULT 'production'
)
RETURNS void AS $$
BEGIN
  INSERT INTO branch_config (chave, valor, ambiente)
  VALUES (p_chave, p_valor, p_ambiente)
  ON CONFLICT (chave, ambiente) DO UPDATE SET
    valor = p_valor,
    atualizado_em = NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 7. TABELA: seed_data_log (Controle de dados de seed)
-- ============================================================

CREATE TABLE IF NOT EXISTS seed_data_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tabela VARCHAR(100) NOT NULL,
  quantidade INT NOT NULL,
  ambiente VARCHAR(50) NOT NULL,
  executado_em TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 8. SCRIPT: Gerar dados de teste (para branches de dev)
-- ============================================================
--
-- IMPORTANTE: Execute apenas em branches de desenvolvimento!
-- Nunca execute em produção!

-- Função para gerar dados de teste
CREATE OR REPLACE FUNCTION seed_dados_teste(
  p_quantidade_pessoas INT DEFAULT 10,
  p_quantidade_oportunidades INT DEFAULT 20
)
RETURNS void AS $$
DECLARE
  v_pessoa_id UUID;
  v_i INT;
  v_nomes TEXT[] := ARRAY['João Silva', 'Maria Santos', 'Pedro Oliveira', 'Ana Costa', 'Carlos Souza', 'Lucia Ferreira', 'Roberto Lima', 'Patricia Alves', 'Fernando Pereira', 'Claudia Rodrigues'];
  v_tipos TEXT[] := ARRAY['CLIENTE', 'CLIENTE', 'CLIENTE', 'LEAD', 'LEAD'];
BEGIN
  -- Verificar se estamos em ambiente de teste
  IF NOT EXISTS (SELECT 1 FROM branch_config WHERE chave = 'is_test_branch' AND valor = 'true') THEN
    RAISE EXCEPTION 'Esta função só pode ser executada em branches de teste. Configure is_test_branch = true primeiro.';
  END IF;

  -- Gerar pessoas
  FOR v_i IN 1..p_quantidade_pessoas LOOP
    INSERT INTO pessoas (
      nome,
      tipo,
      email,
      telefone,
      cpf_cnpj,
      endereco_logradouro,
      endereco_cidade,
      endereco_uf
    ) VALUES (
      v_nomes[(v_i % 10) + 1] || ' ' || v_i,
      v_tipos[(v_i % 5) + 1],
      'teste' || v_i || '@example.com',
      '11999' || LPAD(v_i::TEXT, 6, '0'),
      LPAD((11111111111 + v_i)::TEXT, 11, '0'),
      'Rua Teste, ' || v_i,
      'São Paulo',
      'SP'
    )
    RETURNING id INTO v_pessoa_id;
  END LOOP;

  -- Registrar seed
  INSERT INTO seed_data_log (tabela, quantidade, ambiente)
  VALUES ('pessoas', p_quantidade_pessoas, current_database());

  RAISE NOTICE 'Criados % registros de teste em pessoas', p_quantidade_pessoas;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 9. SCRIPT: Limpar dados de teste
-- ============================================================

CREATE OR REPLACE FUNCTION limpar_dados_teste()
RETURNS void AS $$
BEGIN
  -- Verificar se estamos em ambiente de teste
  IF NOT EXISTS (SELECT 1 FROM branch_config WHERE chave = 'is_test_branch' AND valor = 'true') THEN
    RAISE EXCEPTION 'Esta função só pode ser executada em branches de teste.';
  END IF;

  -- Limpar dados de teste (emails com @example.com)
  DELETE FROM pessoas WHERE email LIKE '%@example.com';

  -- Limpar log de seeds
  DELETE FROM seed_data_log WHERE ambiente = current_database();

  RAISE NOTICE 'Dados de teste removidos';
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 10. VIEW: Status das migrações
-- ============================================================

CREATE OR REPLACE VIEW view_migrations_status AS
SELECT
  versao,
  nome,
  ambiente,
  aplicado_em,
  tempo_execucao_ms,
  sucesso,
  CASE WHEN erro_mensagem IS NOT NULL THEN 'Erro: ' || LEFT(erro_mensagem, 50) || '...' ELSE 'OK' END as status
FROM migrations_log
ORDER BY aplicado_em DESC;

-- ============================================================
-- 11. COMANDOS CLI PARA BRANCHING
-- ============================================================
--
-- Criar branch:
-- npx supabase branches create feature-nova-timeline --region=sa-east-1
--
-- Listar branches:
-- npx supabase branches list
--
-- Deletar branch:
-- npx supabase branches delete feature-nova-timeline
--
-- Aplicar migrações em branch específico:
-- npx supabase db push --branch=feature-nova-timeline
--
-- Conectar ao branch via conexão string:
-- Usar a connection string fornecida pelo CLI

-- ============================================================
-- 12. REGISTRAR MIGRAÇÕES ATUAIS
-- ============================================================

-- Registrar migrações já aplicadas
SELECT registrar_migracao('001', 'Schema inicial', 'Criação das tabelas base do sistema');
SELECT registrar_migracao('002', 'pg_cron', 'Funções de tarefas agendadas', NULL, 'production');
SELECT registrar_migracao('003', 'Webhooks', 'Infraestrutura de webhooks', NULL, 'production');
SELECT registrar_migracao('004', 'Storage', 'Transformações de imagem', NULL, 'production');
SELECT registrar_migracao('005', 'Realtime', 'Configuração de Realtime', NULL, 'production');
SELECT registrar_migracao('006', 'Branching', 'Configuração de Branching', NULL, 'production');

-- ============================================================
-- VERIFICAÇÃO
-- ============================================================

SELECT 'migrations_log' as tabela, COUNT(*) as registros FROM migrations_log
UNION ALL
SELECT 'branch_config', COUNT(*) FROM branch_config
UNION ALL
SELECT 'seed_data_log', COUNT(*) FROM seed_data_log;

-- Listar configurações
SELECT chave, valor, ambiente FROM branch_config ORDER BY chave;
