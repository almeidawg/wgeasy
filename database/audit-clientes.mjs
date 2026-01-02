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

function normalizarCPF(cpf) {
  return (cpf || '').replace(/\D/g, '');
}

async function auditarClientes() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   AUDITORIA DE CLIENTES - DUPLICIDADES E DATAS               ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Buscar todos os clientes
  console.log('📋 Buscando clientes...');
  const { data: clientes, error } = await supabase
    .from('pessoas')
    .select('id, nome, cpf, cnpj, email, telefone, ativo, criado_em')
    .eq('tipo', 'CLIENTE')
    .order('nome');

  if (error) {
    console.error('Erro:', error.message);
    return;
  }

  console.log(`   Total: ${clientes.length} clientes\n`);

  // 2. Verificar duplicidades por NOME
  console.log('🔍 VERIFICANDO DUPLICIDADES POR NOME:');
  console.log('─'.repeat(70));

  const porNome = {};
  clientes.forEach(c => {
    const nomeNorm = normalizarNome(c.nome);
    if (!porNome[nomeNorm]) porNome[nomeNorm] = [];
    porNome[nomeNorm].push(c);
  });

  let dupNomes = 0;
  for (const [nome, lista] of Object.entries(porNome)) {
    if (lista.length > 1) {
      dupNomes++;
      console.log(`\n⚠️  DUPLICADO: "${lista[0].nome}"`);
      lista.forEach(c => {
        const status = c.ativo ? '✅ Ativo' : '❌ Inativo';
        console.log(`   ID: ${c.id}`);
        console.log(`      CPF/CNPJ: ${c.cpf || c.cnpj || 'N/A'} | ${status}`);
        console.log(`      Email: ${c.email || 'N/A'} | Tel: ${c.telefone || 'N/A'}`);
        console.log(`      Cadastro: ${c.criado_em?.split('T')[0] || 'N/A'}`);
      });
    }
  }

  if (dupNomes === 0) {
    console.log('✅ Nenhum nome duplicado encontrado!');
  } else {
    console.log(`\n📊 Total de nomes duplicados: ${dupNomes}`);
  }

  // 3. Verificar duplicidades por CPF/CNPJ
  console.log('\n\n🔍 VERIFICANDO DUPLICIDADES POR CPF/CNPJ:');
  console.log('─'.repeat(70));

  const porDoc = {};
  clientes.forEach(c => {
    const doc = normalizarCPF(c.cpf) || normalizarCPF(c.cnpj);
    if (doc && doc.length >= 11) {
      if (!porDoc[doc]) porDoc[doc] = [];
      porDoc[doc].push(c);
    }
  });

  let dupDocs = 0;
  for (const [doc, lista] of Object.entries(porDoc)) {
    if (lista.length > 1) {
      dupDocs++;
      console.log(`\n⚠️  DOCUMENTO DUPLICADO: ${doc}`);
      lista.forEach(c => {
        console.log(`   - ${c.nome} (ID: ${c.id}) | ${c.ativo ? 'Ativo' : 'Inativo'}`);
      });
    }
  }

  if (dupDocs === 0) {
    console.log('✅ Nenhum CPF/CNPJ duplicado encontrado!');
  } else {
    console.log(`\n📊 Total de documentos duplicados: ${dupDocs}`);
  }

  // 4. Buscar contratos para datas
  console.log('\n\n🔍 BUSCANDO DATAS EM CONTRATOS:');
  console.log('─'.repeat(70));

  const { data: contratos, error: errContratos } = await supabase
    .from('contratos')
    .select('id, cliente_id, data_inicio, data_fim, numero, descricao, criado_em')
    .order('data_inicio', { ascending: true, nullsFirst: false });

  if (errContratos) {
    console.log('   Tabela contratos não encontrada ou erro:', errContratos.message);
  } else if (contratos && contratos.length > 0) {
    console.log(`   Encontrados ${contratos.length} contratos\n`);

    // Agrupar por cliente
    const contratosPorCliente = {};
    contratos.forEach(ct => {
      if (ct.cliente_id) {
        if (!contratosPorCliente[ct.cliente_id]) {
          contratosPorCliente[ct.cliente_id] = [];
        }
        contratosPorCliente[ct.cliente_id].push(ct);
      }
    });

    // Mostrar primeiro contrato de cada cliente
    for (const [clienteId, cts] of Object.entries(contratosPorCliente)) {
      const cliente = clientes.find(c => c.id === clienteId);
      if (cliente) {
        const primeiroContrato = cts[0];
        const data = primeiroContrato.data_inicio || primeiroContrato.criado_em?.split('T')[0];
        console.log(`✅ ${cliente.nome.padEnd(40)} | ${data} (contrato)`);
      }
    }
  } else {
    console.log('   Nenhum contrato encontrado');
  }

  // 5. Buscar projetos/obras com clientes
  console.log('\n\n🔍 BUSCANDO DATAS EM PROJETOS/OBRAS:');
  console.log('─'.repeat(70));

  const { data: projetos, error: errProjetos } = await supabase
    .from('projetos')
    .select('id, cliente_id, nome, data_inicio, data_fim, criado_em')
    .order('data_inicio', { ascending: true, nullsFirst: false });

  if (errProjetos) {
    console.log('   Tabela projetos não encontrada ou erro:', errProjetos.message);
  } else if (projetos && projetos.length > 0) {
    console.log(`   Encontrados ${projetos.length} projetos\n`);

    const projetosPorCliente = {};
    projetos.forEach(p => {
      if (p.cliente_id) {
        if (!projetosPorCliente[p.cliente_id]) {
          projetosPorCliente[p.cliente_id] = [];
        }
        projetosPorCliente[p.cliente_id].push(p);
      }
    });

    for (const [clienteId, prjs] of Object.entries(projetosPorCliente)) {
      const cliente = clientes.find(c => c.id === clienteId);
      if (cliente) {
        const primeiroProjeto = prjs[0];
        const data = primeiroProjeto.data_inicio || primeiroProjeto.criado_em?.split('T')[0];
        console.log(`✅ ${cliente.nome.padEnd(40)} | ${data} (projeto: ${primeiroProjeto.nome || 'N/A'})`);
      }
    }
  } else {
    console.log('   Nenhum projeto encontrado');
  }

  // 6. Buscar lançamentos financeiros (entrada = pagamento do cliente)
  console.log('\n\n🔍 BUSCANDO PRIMEIRO PAGAMENTO RECEBIDO (ENTRADA):');
  console.log('─'.repeat(70));

  const { data: lancamentos, error: errLanc } = await supabase
    .from('financeiro_lancamentos')
    .select('id, pessoa_id, tipo, descricao, favorecido_nome, data_pagamento, data_competencia, criado_em')
    .eq('tipo', 'entrada')
    .order('data_pagamento', { ascending: true, nullsFirst: false });

  if (errLanc) {
    console.log('   Erro ao buscar lançamentos:', errLanc.message);
  } else if (lancamentos && lancamentos.length > 0) {
    console.log(`   Encontrados ${lancamentos.length} lançamentos de entrada\n`);

    // Por pessoa_id
    const lancPorCliente = {};
    lancamentos.forEach(l => {
      if (l.pessoa_id) {
        const data = l.data_pagamento || l.data_competencia || l.criado_em?.split('T')[0];
        if (!lancPorCliente[l.pessoa_id] || data < lancPorCliente[l.pessoa_id].data) {
          lancPorCliente[l.pessoa_id] = { data, descricao: l.descricao };
        }
      }
    });

    let countLanc = 0;
    for (const [clienteId, info] of Object.entries(lancPorCliente)) {
      const cliente = clientes.find(c => c.id === clienteId);
      if (cliente) {
        countLanc++;
        console.log(`✅ ${cliente.nome.padEnd(40)} | ${info.data}`);
      }
    }

    if (countLanc === 0) {
      console.log('   Nenhum lançamento vinculado a cliente por pessoa_id');
    }

    // Tentar match por nome
    console.log('\n   Tentando match por nome/favorecido...');
    const clienteMap = {};
    clientes.forEach(c => {
      clienteMap[normalizarNome(c.nome)] = c;
    });

    const matchesNome = {};
    lancamentos.forEach(l => {
      const texto = normalizarNome(l.descricao) + ' ' + normalizarNome(l.favorecido_nome);
      const data = l.data_pagamento || l.data_competencia || l.criado_em?.split('T')[0];

      for (const [nomeNorm, cliente] of Object.entries(clienteMap)) {
        if (texto.includes(nomeNorm) && nomeNorm.length > 5) {
          if (!matchesNome[cliente.id] || data < matchesNome[cliente.id].data) {
            matchesNome[cliente.id] = { data, descricao: l.descricao, cliente };
          }
        }
      }
    });

    const matchList = Object.values(matchesNome).sort((a, b) => a.data.localeCompare(b.data));
    if (matchList.length > 0) {
      console.log(`\n   Encontrados ${matchList.length} matches por nome:`);
      matchList.forEach(m => {
        console.log(`   ✅ ${m.cliente.nome.padEnd(40)} | ${m.data}`);
      });
    }
  } else {
    console.log('   Nenhum lançamento de entrada encontrado');
  }

  // 7. Verificar outras tabelas que podem ter informações de clientes
  console.log('\n\n🔍 VERIFICANDO OUTRAS TABELAS:');
  console.log('─'.repeat(70));

  // Verificar obras
  const { data: obras, error: errObras } = await supabase
    .from('obras')
    .select('id, cliente_id, nome, endereco, data_inicio, criado_em')
    .order('data_inicio', { ascending: true, nullsFirst: false });

  if (!errObras && obras && obras.length > 0) {
    console.log(`\n📋 OBRAS: ${obras.length} registros`);

    const obrasPorCliente = {};
    obras.forEach(o => {
      if (o.cliente_id) {
        const data = o.data_inicio || o.criado_em?.split('T')[0];
        if (!obrasPorCliente[o.cliente_id] || data < obrasPorCliente[o.cliente_id].data) {
          obrasPorCliente[o.cliente_id] = { data, nome: o.nome };
        }
      }
    });

    for (const [clienteId, info] of Object.entries(obrasPorCliente)) {
      const cliente = clientes.find(c => c.id === clienteId);
      if (cliente) {
        console.log(`   ✅ ${cliente.nome.padEnd(40)} | ${info.data} (obra: ${info.nome || 'N/A'})`);
      }
    }
  }

  // Verificar orçamentos
  const { data: orcamentos, error: errOrc } = await supabase
    .from('orcamentos')
    .select('id, cliente_id, numero, data, criado_em')
    .order('data', { ascending: true, nullsFirst: false });

  if (!errOrc && orcamentos && orcamentos.length > 0) {
    console.log(`\n📋 ORÇAMENTOS: ${orcamentos.length} registros`);

    const orcPorCliente = {};
    orcamentos.forEach(o => {
      if (o.cliente_id) {
        const data = o.data || o.criado_em?.split('T')[0];
        if (!orcPorCliente[o.cliente_id] || data < orcPorCliente[o.cliente_id].data) {
          orcPorCliente[o.cliente_id] = { data, numero: o.numero };
        }
      }
    });

    for (const [clienteId, info] of Object.entries(orcPorCliente)) {
      const cliente = clientes.find(c => c.id === clienteId);
      if (cliente) {
        console.log(`   ✅ ${cliente.nome.padEnd(40)} | ${info.data} (orçamento: ${info.numero || 'N/A'})`);
      }
    }
  }

  // 8. Resumo final
  console.log('\n\n' + '═'.repeat(70));
  console.log('📊 RESUMO DA AUDITORIA DE CLIENTES');
  console.log('═'.repeat(70));
  console.log(`Total de clientes: ${clientes.length}`);
  console.log(`Nomes duplicados: ${dupNomes}`);
  console.log(`Documentos duplicados: ${dupDocs}`);
  console.log('═'.repeat(70));
}

auditarClientes().catch(console.error);
