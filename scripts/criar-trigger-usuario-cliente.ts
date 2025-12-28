// Script para criar trigger que cria usuario do cliente automaticamente
// quando um contrato e ativado
import pg from 'pg';

const { Client } = pg;

const connectionString = 'postgresql://postgres:130300%40%24Wgalmeida@db.ahlqzzkxuutwoepirpzr.supabase.co:5432/postgres';

const SQL_TRIGGER = `
-- =============================================
-- TRIGGER: Criar usuario do cliente automaticamente
-- quando contrato for ativado
-- WGeasy - Grupo WG Almeida
-- Data: 2025-12-28 (Versao corrigida)
-- =============================================

-- Remover funcao e triggers antigos
DROP TRIGGER IF EXISTS trigger_contrato_criar_usuario_cliente ON contratos;
DROP TRIGGER IF EXISTS trigger_contrato_criar_usuario_cliente_insert ON contratos;
DROP FUNCTION IF EXISTS trigger_criar_usuario_cliente();

-- Funcao corrigida que cria o usuario do cliente
CREATE OR REPLACE FUNCTION trigger_criar_usuario_cliente()
RETURNS TRIGGER AS $$
DECLARE
  v_cpf VARCHAR;
  v_email VARCHAR;
  v_usuario_existente UUID;
  v_novo_usuario_id UUID;
BEGIN
  -- Verificar se o contrato esta ativo ou em execucao
  IF NEW.status IN ('ativo', 'em_execucao') THEN

    -- Verificar se ja existe usuario para este cliente
    SELECT id INTO v_usuario_existente
    FROM usuarios
    WHERE pessoa_id = NEW.cliente_id;

    IF v_usuario_existente IS NULL THEN
      -- Buscar dados do cliente (pessoa)
      SELECT cpf, email INTO v_cpf, v_email
      FROM pessoas
      WHERE id = NEW.cliente_id;

      -- Criar usuario para o cliente
      INSERT INTO usuarios (
        pessoa_id,
        cpf,
        tipo_usuario,
        ativo,
        primeiro_acesso,
        cliente_pode_ver_cronograma,
        cliente_pode_ver_documentos,
        cliente_pode_ver_proposta,
        cliente_pode_ver_contratos,
        cliente_pode_fazer_upload,
        cliente_pode_comentar
      ) VALUES (
        NEW.cliente_id,
        COALESCE(v_cpf, ''),
        'CLIENTE',
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true
      )
      RETURNING id INTO v_novo_usuario_id;

      -- Log para webhook
      IF EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'webhook_logs'
      ) THEN
        INSERT INTO webhook_logs (
          evento, tabela, registro_id, payload
        ) VALUES (
          'usuario_cliente_criado',
          'usuarios',
          v_novo_usuario_id,
          jsonb_build_object(
            'contrato_id', NEW.id,
            'cliente_id', NEW.cliente_id,
            'usuario_id', v_novo_usuario_id,
            'email', v_email,
            'mensagem', 'Usuario criado automaticamente ao ativar contrato'
          )
        );
      END IF;
    END IF;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'Erro ao criar usuario do cliente: % - %', SQLSTATE, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para UPDATE
CREATE TRIGGER trigger_contrato_criar_usuario_cliente
  AFTER UPDATE ON contratos
  FOR EACH ROW
  EXECUTE FUNCTION trigger_criar_usuario_cliente();

-- Criar trigger para INSERT
CREATE TRIGGER trigger_contrato_criar_usuario_cliente_insert
  AFTER INSERT ON contratos
  FOR EACH ROW
  EXECUTE FUNCTION trigger_criar_usuario_cliente();
`;

async function criarTrigger() {
  console.log('\n');
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║  CRIANDO TRIGGER PARA USUARIO DO CLIENTE AUTOMATICO          ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  const client = new Client({
    connectionString,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('1. Conectando ao Supabase PostgreSQL...');
    await client.connect();
    console.log('   ✅ Conectado com sucesso!\n');

    console.log('2. Verificando estrutura da tabela usuarios...');
    const colunasResult = await client.query(`
      SELECT column_name, data_type
      FROM information_schema.columns
      WHERE table_name = 'usuarios'
      AND table_schema = 'public'
      ORDER BY ordinal_position
    `);

    console.log('   Colunas encontradas:', colunasResult.rows.map(r => r.column_name).join(', '));
    console.log('');

    console.log('3. Executando SQL do trigger...');
    await client.query(SQL_TRIGGER);
    console.log('   ✅ Trigger criado com sucesso!\n');

    console.log('4. Verificando se trigger foi criado...');
    const triggerCheck = await client.query(`
      SELECT trigger_name, event_manipulation, action_timing
      FROM information_schema.triggers
      WHERE trigger_name LIKE 'trigger_contrato_criar_usuario%'
    `);

    if (triggerCheck.rows.length > 0) {
      console.log('   ✅ Triggers encontrados:');
      triggerCheck.rows.forEach(t => {
        console.log(`      - ${t.trigger_name} (${t.action_timing} ${t.event_manipulation})`);
      });
    }

    console.log('\n╔══════════════════════════════════════════════════════════════╗');
    console.log('║              TRIGGER CRIADO COM SUCESSO!                     ║');
    console.log('╠══════════════════════════════════════════════════════════════╣');
    console.log('║                                                              ║');
    console.log('║  Agora, quando um contrato for ativado (status = ativo       ║');
    console.log('║  ou em_execucao), o sistema criara automaticamente um        ║');
    console.log('║  usuario para o cliente acessar a Area do Cliente.           ║');
    console.log('║                                                              ║');
    console.log('╚══════════════════════════════════════════════════════════════╝');

  } catch (error: any) {
    console.log('\n❌ ERRO:', error.message);
    if (error.detail) console.log('   Detalhe:', error.detail);
    if (error.hint) console.log('   Dica:', error.hint);
    if (error.position) console.log('   Posicao:', error.position);
  } finally {
    await client.end();
    console.log('\nConexao fechada.');
  }
}

criarTrigger();
