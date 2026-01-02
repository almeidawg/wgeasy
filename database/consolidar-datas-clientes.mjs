import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo'
);

function normalizarNome(nome) {
  return (nome || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

async function consolidarDatasClientes() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   CONSOLIDAÇÃO DE DATAS DE INÍCIO - CLIENTES                 ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Buscar todos os clientes ativos
  console.log('📋 Buscando clientes...');
  const { data: clientes, error } = await supabase
    .from('pessoas')
    .select('id, nome, criado_em, data_inicio')
    .eq('tipo', 'CLIENTE')
    .eq('ativo', true)
    .order('nome');

  if (error) {
    console.error('Erro:', error.message);
    return;
  }

  console.log(`   ${clientes.length} clientes ativos\n`);

  // Mapa para consolidar datas por cliente
  const datasCliente = {};
  clientes.forEach(c => {
    datasCliente[c.id] = {
      cliente: c,
      fontes: [],
      dataMaisAntiga: c.criado_em?.split('T')[0] || '9999-12-31'
    };
  });

  // 2. Buscar contratos
  console.log('📋 Buscando contratos...');
  const { data: contratos } = await supabase
    .from('contratos')
    .select('id, cliente_id, data_inicio, criado_em')
    .order('data_inicio', { ascending: true, nullsFirst: false });

  if (contratos && contratos.length > 0) {
    console.log(`   ${contratos.length} contratos encontrados`);
    contratos.forEach(ct => {
      if (ct.cliente_id && datasCliente[ct.cliente_id]) {
        const data = ct.data_inicio || ct.criado_em?.split('T')[0];
        if (data && data < datasCliente[ct.cliente_id].dataMaisAntiga) {
          datasCliente[ct.cliente_id].dataMaisAntiga = data;
          datasCliente[ct.cliente_id].fontes.push({ tipo: 'contrato', data });
        }
      }
    });
  }

  // 3. Buscar obras
  console.log('📋 Buscando obras...');
  const { data: obras } = await supabase
    .from('obras')
    .select('id, cliente_id, data_inicio, criado_em')
    .order('data_inicio', { ascending: true, nullsFirst: false });

  if (obras && obras.length > 0) {
    console.log(`   ${obras.length} obras encontradas`);
    obras.forEach(ob => {
      if (ob.cliente_id && datasCliente[ob.cliente_id]) {
        const data = ob.data_inicio || ob.criado_em?.split('T')[0];
        if (data && data < datasCliente[ob.cliente_id].dataMaisAntiga) {
          datasCliente[ob.cliente_id].dataMaisAntiga = data;
          datasCliente[ob.cliente_id].fontes.push({ tipo: 'obra', data });
        }
      }
    });
  }

  // 4. Buscar lançamentos financeiros (entrada = pagamento do cliente)
  console.log('📋 Buscando lançamentos financeiros (entrada)...');
  const { data: lancamentos } = await supabase
    .from('financeiro_lancamentos')
    .select('id, pessoa_id, data_pagamento, data_competencia, criado_em')
    .eq('tipo', 'entrada')
    .not('pessoa_id', 'is', null)
    .order('data_pagamento', { ascending: true, nullsFirst: false });

  if (lancamentos && lancamentos.length > 0) {
    console.log(`   ${lancamentos.length} lançamentos de entrada`);
    lancamentos.forEach(l => {
      if (l.pessoa_id && datasCliente[l.pessoa_id]) {
        const data = l.data_pagamento || l.data_competencia || l.criado_em?.split('T')[0];
        if (data && data < datasCliente[l.pessoa_id].dataMaisAntiga) {
          datasCliente[l.pessoa_id].dataMaisAntiga = data;
          datasCliente[l.pessoa_id].fontes.push({ tipo: 'pagamento', data });
        }
      }
    });
  }

  // 5. Consolidar resultados
  console.log('\n\n🔍 DATAS DE INÍCIO CONSOLIDADAS:');
  console.log('─'.repeat(90));

  const clientesComData = [];
  const clientesSemData = [];

  for (const [id, info] of Object.entries(datasCliente)) {
    if (info.fontes.length > 0) {
      clientesComData.push(info);
    } else {
      clientesSemData.push(info);
    }
  }

  // Ordenar por data mais antiga
  clientesComData.sort((a, b) => a.dataMaisAntiga.localeCompare(b.dataMaisAntiga));

  console.log(`\n✅ CLIENTES COM DATA IDENTIFICADA (${clientesComData.length}):`);
  console.log('─'.repeat(90));

  for (const info of clientesComData) {
    const fonte = info.fontes[0]?.tipo || 'cadastro';
    console.log(`${info.cliente.nome.padEnd(45)} | ${info.dataMaisAntiga} (${fonte})`);
  }

  console.log(`\n⏳ CLIENTES SEM DATA IDENTIFICADA (${clientesSemData.length}):`);
  console.log('─'.repeat(90));

  for (const info of clientesSemData.slice(0, 20)) {
    const dataCadastro = info.cliente.criado_em?.split('T')[0] || 'N/A';
    console.log(`${info.cliente.nome.padEnd(45)} | Cadastro: ${dataCadastro}`);
  }

  if (clientesSemData.length > 20) {
    console.log(`   ... e mais ${clientesSemData.length - 20} clientes`);
  }

  // 6. Gerar SQL de atualização
  if (clientesComData.length > 0) {
    console.log('\n\n' + '═'.repeat(70));
    console.log('📝 SQL PARA ATUALIZAR DATA_INICIO DOS CLIENTES:');
    console.log('═'.repeat(70) + '\n');

    console.log('-- Criar coluna se não existir');
    console.log('ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;\n');

    console.log('-- Atualizar datas de início dos clientes');
    for (const info of clientesComData) {
      console.log(`UPDATE pessoas SET data_inicio = '${info.dataMaisAntiga}' WHERE id = '${info.cliente.id}';`);
      console.log(`-- ${info.cliente.nome} (${info.fontes[0]?.tipo || 'cadastro'})`);
    }
  }

  // Resumo
  console.log('\n\n' + '═'.repeat(70));
  console.log('📊 RESUMO');
  console.log('═'.repeat(70));
  console.log(`Total de clientes: ${clientes.length}`);
  console.log(`Com data identificada: ${clientesComData.length}`);
  console.log(`Sem data (usar data de cadastro): ${clientesSemData.length}`);
  console.log('═'.repeat(70));
}

consolidarDatasClientes().catch(console.error);
