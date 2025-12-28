// ============================================================
// SCRIPT: Executar Correcao do Trigger de Oportunidade
// WGeasy - Grupo WG Almeida
// Data: 2025-12-28
// ============================================================
// Executa a correcao do trigger trigger_nova_oportunidade
// via conexao PostgreSQL direta
// ============================================================
//
// COMO EXECUTAR:
// 1. Defina a variavel DATABASE_URL ou SUPABASE_DB_URL
// 2. Execute: npx tsx executar-correcao-trigger.ts
//
// A connection string pode ser encontrada em:
// Supabase Dashboard > Settings > Database > Connection string > URI
// ============================================================

import { Client } from 'pg';

// Configuracao do PostgreSQL
// Connection string format: postgresql://postgres:[PASSWORD]@db.ahlqzzkxuutwoepirpzr.supabase.co:5432/postgres
const DATABASE_URL = process.env.DATABASE_URL || process.env.SUPABASE_DB_URL || '';

if (!DATABASE_URL) {
  console.error('=============================================');
  console.error('ERRO: DATABASE_URL ou SUPABASE_DB_URL nao definida!');
  console.error('=============================================');
  console.log('');
  console.log('Para executar este script, defina a variavel de ambiente:');
  console.log('');
  console.log('  Windows (PowerShell):');
  console.log('    $env:DATABASE_URL = "postgresql://postgres:SENHA@db.ahlqzzkxuutwoepirpzr.supabase.co:5432/postgres"');
  console.log('');
  console.log('  Windows (CMD):');
  console.log('    set DATABASE_URL=postgresql://postgres:SENHA@db.ahlqzzkxuutwoepirpzr.supabase.co:5432/postgres');
  console.log('');
  console.log('Voce pode encontrar a connection string em:');
  console.log('  Supabase Dashboard > Settings > Database > Connection string > URI');
  console.log('');
  console.log('ALTERNATIVA: Execute o SQL manualmente:');
  console.log('  1. Acesse: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr');
  console.log('  2. Va em SQL Editor');
  console.log('  3. Cole o conteudo de CORRECAO_TRIGGER_OPORTUNIDADE.sql');
  console.log('  4. Execute');
  console.log('');
  process.exit(1);
}

const client = new Client({
  connectionString: DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// SQL para corrigir o trigger
const SQL_CORRECAO = `
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

async function executarCorrecao() {
  console.log('=============================================');
  console.log('CORRECAO DO TRIGGER: trigger_nova_oportunidade');
  console.log('=============================================');
  console.log('');

  try {
    // Conectar ao banco
    console.log('[1/4] Conectando ao banco de dados...');
    await client.connect();
    console.log('  Conectado com sucesso!');

    // Verificar trigger atual
    console.log('');
    console.log('[2/4] Verificando trigger atual...');
    const triggerResult = await client.query(`
      SELECT trigger_name, event_object_table, action_timing
      FROM information_schema.triggers
      WHERE trigger_name = 'trigger_oportunidade_nova'
    `);

    if (triggerResult.rows.length > 0) {
      console.log('  Trigger encontrado:', triggerResult.rows[0]);
    } else {
      console.log('  Trigger nao encontrado (sera criado)');
    }

    // Executar correcao
    console.log('');
    console.log('[3/4] Aplicando correcao...');
    await client.query(SQL_CORRECAO);
    console.log('  Funcao do trigger recriada com sucesso!');

    // Testar criando uma oportunidade
    console.log('');
    console.log('[4/4] Testando trigger...');

    // Buscar um cliente para teste
    const clienteResult = await client.query(`
      SELECT id, nome FROM pessoas WHERE tipo = 'CLIENTE' LIMIT 1
    `);

    if (clienteResult.rows.length > 0) {
      const cliente = clienteResult.rows[0];
      const testTitulo = 'TESTE_CORRECAO_TRIGGER_' + Date.now();

      // Criar oportunidade de teste
      const insertResult = await client.query(`
        INSERT INTO oportunidades (titulo, cliente_id, status, estagio, valor)
        VALUES ($1, $2, 'novo', 'qualificacao', 1000)
        RETURNING id
      `, [testTitulo, cliente.id]);

      const oportunidadeId = insertResult.rows[0].id;
      console.log('  Oportunidade de teste criada:', oportunidadeId);

      // Remover oportunidade de teste
      await client.query('DELETE FROM oportunidades WHERE id = $1', [oportunidadeId]);
      console.log('  Oportunidade de teste removida.');
      console.log('  TESTE PASSOU! O trigger esta funcionando corretamente.');
    } else {
      console.log('  Nenhum cliente encontrado para teste.');
      console.log('  Correcao aplicada, mas nao foi possivel testar.');
    }

    console.log('');
    console.log('=============================================');
    console.log('CORRECAO CONCLUIDA COM SUCESSO!');
    console.log('=============================================');

  } catch (error) {
    console.error('');
    console.error('=============================================');
    console.error('ERRO AO APLICAR CORRECAO');
    console.error('=============================================');
    console.error('Detalhes:', error);
    console.error('');
    console.error('ALTERNATIVA: Execute o SQL manualmente no Supabase Dashboard:');
    console.error('  1. Acesse: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr');
    console.error('  2. Va em SQL Editor');
    console.error('  3. Cole o conteudo de CORRECAO_TRIGGER_OPORTUNIDADE.sql');
    console.error('  4. Execute');
    process.exit(1);
  } finally {
    await client.end();
  }
}

// Executar
executarCorrecao();
