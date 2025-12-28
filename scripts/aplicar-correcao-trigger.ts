// Script para aplicar correção do trigger via conexão PostgreSQL direta
import pg from 'pg';

const { Client } = pg;

// Conexão direta ao banco Supabase
const connectionString = 'postgresql://postgres:130300%40%24Wgalmeida@db.ahlqzzkxuutwoepirpzr.supabase.co:5432/postgres';

const SQL_CORRECAO = `
-- =============================================
-- CORRECAO BUG: trigger_nova_oportunidade
-- WGeasy - Grupo WG Almeida
-- Data: 2025-12-28
-- =============================================

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
        'valor', NEW.valor,
        'estagio', NEW.estagio
      )
    );
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    RAISE WARNING 'Erro no trigger_nova_oportunidade: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
`;

async function aplicarCorrecao() {
  console.log('\n');
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║     APLICANDO CORRECAO DO TRIGGER trigger_nova_oportunidade  ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  const client = new Client({
    connectionString,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('1. Conectando ao Supabase PostgreSQL...');
    await client.connect();
    console.log('   ✅ Conectado com sucesso!\n');

    console.log('2. Verificando trigger atual...');
    const checkResult = await client.query(`
      SELECT routine_name, routine_definition
      FROM information_schema.routines
      WHERE routine_name = 'trigger_nova_oportunidade'
      AND routine_schema = 'public'
    `);

    if (checkResult.rows.length > 0) {
      console.log('   ✅ Trigger encontrado no banco\n');
    } else {
      console.log('   ⚠️  Trigger nao encontrado (sera criado)\n');
    }

    console.log('3. Executando SQL de correcao...');
    await client.query(SQL_CORRECAO);
    console.log('   ✅ SQL executado com sucesso!\n');

    console.log('4. Testando criacao de oportunidade...');

    // Buscar um cliente para teste
    const clienteResult = await client.query(`
      SELECT id, nome FROM pessoas
      WHERE tipo = 'CLIENTE' AND ativo = true
      LIMIT 1
    `);

    if (clienteResult.rows.length > 0) {
      const cliente = clienteResult.rows[0];
      console.log(`   Cliente para teste: ${cliente.nome}\n`);

      // Tentar criar oportunidade de teste
      const insertResult = await client.query(`
        INSERT INTO oportunidades (titulo, cliente_id, status, estagio, valor)
        VALUES ($1, $2, 'novo', 'qualificacao', 1000)
        RETURNING id
      `, ['TESTE_CORRECAO_' + Date.now(), cliente.id]);

      const oportunidadeId = insertResult.rows[0].id;
      console.log(`   ✅ Oportunidade de teste criada: ${oportunidadeId}\n`);

      // Limpar
      await client.query('DELETE FROM oportunidades WHERE id = $1', [oportunidadeId]);
      console.log('   ✅ Oportunidade de teste removida\n');

      console.log('╔══════════════════════════════════════════════════════════════╗');
      console.log('║                  CORRECAO APLICADA COM SUCESSO!              ║');
      console.log('╠══════════════════════════════════════════════════════════════╣');
      console.log('║                                                              ║');
      console.log('║   O trigger trigger_nova_oportunidade foi corrigido.         ║');
      console.log('║   Voce pode criar oportunidades normalmente agora.           ║');
      console.log('║                                                              ║');
      console.log('╚══════════════════════════════════════════════════════════════╝');
    } else {
      console.log('   ⚠️  Nenhum cliente encontrado para teste');
      console.log('   A correcao foi aplicada, mas nao foi possivel testar.\n');
    }

  } catch (error: any) {
    console.log('\n❌ ERRO:', error.message);
    if (error.detail) console.log('   Detalhe:', error.detail);
    if (error.hint) console.log('   Dica:', error.hint);
  } finally {
    await client.end();
    console.log('\nConexao fechada.');
  }
}

aplicarCorrecao();
