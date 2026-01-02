// Execute SQL directly via Supabase SQL API
const SUPABASE_URL = 'https://ahlqzzkxuutwoepirpzr.supabase.co';
const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo';

const SQL = `
-- 1. Criar coluna data_inicio
ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;

-- 2. Atualizar 21 colaboradores com data de primeiro pagamento
UPDATE pessoas SET data_inicio = '2020-06-10' WHERE id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94';
UPDATE pessoas SET data_inicio = '2020-06-17' WHERE id = '5b4af090-8e6a-4b10-80c5-6686d5e63d3a';
UPDATE pessoas SET data_inicio = '2020-06-26' WHERE id = 'c7222975-5aef-4326-b726-a36bed9612f1';
UPDATE pessoas SET data_inicio = '2020-07-07' WHERE id = '28a7472a-e849-4bc3-8780-214c04a7c54f';
UPDATE pessoas SET data_inicio = '2020-07-07' WHERE id = '50b8a7b2-2686-4cfe-8d05-d708de312020';
UPDATE pessoas SET data_inicio = '2023-06-25' WHERE id = '04e75742-c53c-4b52-8138-fb953a30755b';
UPDATE pessoas SET data_inicio = '2024-01-31' WHERE id = '35693a08-3424-4ba3-bc71-5a1c49e00311';
UPDATE pessoas SET data_inicio = '2024-03-07' WHERE id = 'd3d0c75d-aa6e-43e3-b042-23a30a179dc0';
UPDATE pessoas SET data_inicio = '2024-07-07' WHERE id = '853b3f28-6fbf-4696-8294-023c5045414b';
UPDATE pessoas SET data_inicio = '2024-07-23' WHERE id = '4d2c4cb0-c8af-4ea3-a2aa-030faa1f1a5b';
UPDATE pessoas SET data_inicio = '2024-07-30' WHERE id = 'b784f700-356f-4038-90f0-6de21f60cd93';
UPDATE pessoas SET data_inicio = '2025-02-04' WHERE id = '766be75c-41f8-4aa7-a5c6-0c96705e96c9';
UPDATE pessoas SET data_inicio = '2025-04-24' WHERE id = 'aac151c2-6c9c-44cb-9fb0-3ba2abf9cdc0';
UPDATE pessoas SET data_inicio = '2025-06-08' WHERE id = 'c6cbb3a9-6f7c-4d6a-8ee5-f7a866845b24';
UPDATE pessoas SET data_inicio = '2025-07-04' WHERE id = '15e70e4f-a77f-4843-a6f7-c8eb73b2b772';
UPDATE pessoas SET data_inicio = '2025-07-22' WHERE id = '569afe4a-18df-45db-ac2e-9a94550b3cae';
UPDATE pessoas SET data_inicio = '2025-08-30' WHERE id = '335f7d3c-84e7-46b8-bc07-9e2ff4f68207';
UPDATE pessoas SET data_inicio = '2025-09-13' WHERE id = 'dffe88d7-e4da-4f6f-961d-e62436c7914e';
UPDATE pessoas SET data_inicio = '2025-10-14' WHERE id = 'eab94604-f118-41a8-ba7d-087212806b98';
UPDATE pessoas SET data_inicio = '2025-10-18' WHERE id = 'd3d6a25f-b68d-4f3d-bfac-29158310c83d';
UPDATE pessoas SET data_inicio = '2025-10-18' WHERE id = '2636c23d-53da-4336-b7a3-0af5fb8c0ee1';
`;

async function executar() {
  console.log('Executando SQL via Supabase API...\n');

  try {
    // Tentar via endpoint de query SQL (se disponível)
    const response = await fetch(`${SUPABASE_URL}/rest/v1/rpc/exec_sql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${SERVICE_ROLE_KEY}`
      },
      body: JSON.stringify({ sql: SQL })
    });

    if (response.ok) {
      console.log('✅ SQL executado com sucesso!');
      const result = await response.json();
      console.log(result);
    } else {
      const error = await response.text();
      console.log('Tentando método alternativo...\n');

      // Método alternativo: usar pg diretamente
      const { Client } = await import('pg');

      // Connection string do Supabase
      const connectionString = `postgresql://postgres.ahlqzzkxuutwoepirpzr:${process.env.SUPABASE_DB_PASSWORD || 'SUA_SENHA_DO_BANCO'}@aws-0-sa-east-1.pooler.supabase.com:6543/postgres`;

      console.log('Conectando diretamente ao PostgreSQL...');
      console.log('⚠️  Precisa da senha do banco. Defina SUPABASE_DB_PASSWORD ou execute o SQL manualmente no Supabase.');
    }
  } catch (err) {
    console.log('Erro:', err.message);
    console.log('\n⚠️  Execute o SQL manualmente no Supabase SQL Editor.');
  }
}

executar();
