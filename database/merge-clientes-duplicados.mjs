import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo'
);

// Clientes duplicados encontrados na auditoria
// Formato: [ID_MANTER (mais antigo/completo), ID_REMOVER]
const DUPLICADOS = [
  // Alexandre de Souza Cavalcante - manter o de 29/12, remover o de 31/12
  {
    manter: 'd9a7d4d0-2245-49bb-9ea8-b7ddb246dac8',
    remover: '2b3f3860-8e57-4032-9c9b-2c85612cff2f',
    nome: 'Alexandre de Souza Cavalcante'
  },
  // Andre Luis - manter o que tem email
  {
    manter: 'faa5eb75-84cb-4d92-8942-c48a45e0844d',
    remover: '826b8dd2-e6e3-4562-8b2c-c1879a3d8a19',
    nome: 'Andre Luis'
  },
  // Felipe Diorio - manter o que tem email
  {
    manter: 'eec66d5c-ff14-4ec6-b99f-30735daef2f4',
    remover: 'b966dfd0-eaea-4298-8a8c-817424887bd4',
    nome: 'Felipe Diorio'
  },
  // Helio Pereira Reboucas - manter o que tem email
  {
    manter: '863d918b-51e6-45c2-ab1e-10ffc7779086',
    remover: 'f710e076-b308-4d8a-8af7-76c4a2d26a26',
    nome: 'Helio Pereira Reboucas'
  },
  // Igor - Surubiju 1930 - manter o que tem email
  {
    manter: 'd8a6255e-809a-49df-8306-ccf5f5b0b407',
    remover: '840aaf37-342c-4c63-81ea-70c6aadb6044',
    nome: 'Igor - Surubiju 1930'
  },
  // Maria Aparecida - manter o que tem email
  {
    manter: 'a7b45b92-9245-48a8-b9f9-8afbf29531af',
    remover: 'ed5cc35b-1d81-4135-aaf8-5f8047482040',
    nome: 'Maria Aparecida'
  },
  // Mauricio Barbarulo - manter o que tem email
  {
    manter: 'e835f7da-bc47-440f-92d7-a19edf9936aa',
    remover: 'c5e1d892-be98-4117-bf69-16698246a59d',
    nome: 'Mauricio Barbarulo'
  },
  // Paloma Medeiros - manter o que tem email
  {
    manter: 'cf460724-5dc1-4b86-a83a-eaeb1e73117d',
    remover: '528f34dc-f1f4-45a3-9c9f-1923adf16a64',
    nome: 'Paloma Medeiros'
  }
];

// Tabelas que podem ter referência a pessoa_id ou cliente_id
const TABELAS_REFERENCIA = [
  { tabela: 'financeiro_lancamentos', coluna: 'pessoa_id' },
  { tabela: 'contratos', coluna: 'cliente_id' },
  { tabela: 'obras', coluna: 'cliente_id' },
  { tabela: 'orcamentos', coluna: 'cliente_id' },
  { tabela: 'projetos', coluna: 'cliente_id' },
  { tabela: 'colaborador_valores_receber', coluna: 'colaborador_id' },
  { tabela: 'colaborador_projetos', coluna: 'colaborador_id' }
];

async function mergeClientes() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   MERGE DE CLIENTES DUPLICADOS                               ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  let mergeados = 0;
  let erros = 0;

  for (const dup of DUPLICADOS) {
    console.log(`\n📋 Processando: ${dup.nome}`);
    console.log('─'.repeat(60));

    // 1. Verificar se ambos IDs existem
    const { data: manter } = await supabase
      .from('pessoas')
      .select('id, nome, email, ativo')
      .eq('id', dup.manter)
      .single();

    const { data: remover } = await supabase
      .from('pessoas')
      .select('id, nome, email, ativo')
      .eq('id', dup.remover)
      .single();

    if (!manter) {
      console.log(`   ⚠️ Registro principal não encontrado: ${dup.manter}`);
      continue;
    }

    if (!remover) {
      console.log(`   ✅ Duplicado já foi removido anteriormente`);
      continue;
    }

    console.log(`   Mantendo: ${manter.nome} (${manter.email || 'sem email'})`);
    console.log(`   Removendo: ${remover.nome} (${remover.email || 'sem email'})`);

    // 2. Transferir referências de todas as tabelas
    let transferencias = 0;
    for (const ref of TABELAS_REFERENCIA) {
      try {
        const { data: registros, error: errBusca } = await supabase
          .from(ref.tabela)
          .select('id')
          .eq(ref.coluna, dup.remover);

        if (!errBusca && registros && registros.length > 0) {
          console.log(`   📝 ${ref.tabela}: ${registros.length} registros para transferir`);

          const { error: errUpdate } = await supabase
            .from(ref.tabela)
            .update({ [ref.coluna]: dup.manter })
            .eq(ref.coluna, dup.remover);

          if (errUpdate) {
            console.log(`      ❌ Erro ao transferir: ${errUpdate.message}`);
          } else {
            console.log(`      ✅ Transferidos com sucesso`);
            transferencias += registros.length;
          }
        }
      } catch (err) {
        // Tabela pode não existir ou não ter a coluna
      }
    }

    // 3. Marcar o duplicado como inativo (ou deletar)
    const { error: errInativar } = await supabase
      .from('pessoas')
      .update({
        ativo: false,
        observacoes: `[DUPLICADO] Mesclado com ID ${dup.manter} em ${new Date().toISOString().split('T')[0]}`
      })
      .eq('id', dup.remover);

    if (errInativar) {
      console.log(`   ❌ Erro ao inativar: ${errInativar.message}`);
      erros++;
    } else {
      console.log(`   ✅ Duplicado marcado como inativo`);
      console.log(`   📊 Total de referências transferidas: ${transferencias}`);
      mergeados++;
    }
  }

  // Resumo final
  console.log('\n\n' + '═'.repeat(60));
  console.log('📊 RESUMO DO MERGE');
  console.log('═'.repeat(60));
  console.log(`Total de duplicados processados: ${DUPLICADOS.length}`);
  console.log(`Merges realizados com sucesso: ${mergeados}`);
  console.log(`Erros: ${erros}`);
  console.log('═'.repeat(60));
}

mergeClientes().catch(console.error);
