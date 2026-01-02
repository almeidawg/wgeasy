import { createClient } from '@supabase/supabase-js';

// Service Role Key para permissões admin
const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo'
);

async function atualizarDataInicio() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   ATUALIZAÇÃO DE DATA DE INÍCIO - BASEADO EM PAGAMENTOS      ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Primeiro, adicionar coluna data_inicio se não existir (via RPC ou raw SQL)
  console.log('📋 Verificando/criando coluna data_inicio...');

  // Tentar adicionar coluna via SQL direto
  const { error: alterError } = await supabase.rpc('exec_sql', {
    sql: 'ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;'
  }).maybeSingle();

  // Se RPC não existir, vamos prosseguir e tentar atualizar diretamente
  // A coluna pode já existir ou precisar ser criada manualmente

  // 2. Buscar todos os colaboradores ativos
  console.log('📋 Buscando colaboradores...');
  const { data: colaboradores, error: e1 } = await supabase
    .from('pessoas')
    .select('id, nome, cpf')
    .eq('tipo', 'COLABORADOR')
    .eq('ativo', true)
    .order('nome');

  if (e1) {
    console.error('Erro ao buscar colaboradores:', e1.message);
    return;
  }

  console.log(`   Encontrados: ${colaboradores.length} colaboradores\n`);

  // 3. Buscar todos os lançamentos financeiros
  console.log('📋 Buscando lançamentos financeiros...');
  const { data: lancamentos, error: e2 } = await supabase
    .from('financeiro_lancamentos')
    .select('pessoa_id, data_pagamento, data_competencia, created_at, descricao')
    .not('pessoa_id', 'is', null)
    .order('created_at', { ascending: true });

  if (e2) {
    console.error('Erro ao buscar lançamentos:', e2.message);
    return;
  }

  console.log(`   Encontrados: ${lancamentos?.length || 0} lançamentos\n`);

  // 4. Buscar valores a receber de colaboradores
  console.log('📋 Buscando valores a receber...');
  const { data: valoresReceber, error: e3 } = await supabase
    .from('colaborador_valores_receber')
    .select('colaborador_id, data_pagamento, data_prevista, criado_em')
    .order('criado_em', { ascending: true });

  console.log(`   Encontrados: ${valoresReceber?.length || 0} registros\n`);

  // 5. Buscar projetos de colaboradores
  console.log('📋 Buscando projetos de colaboradores...');
  const { data: projetos, error: e4 } = await supabase
    .from('colaborador_projetos')
    .select('colaborador_id, data_inicio, criado_em')
    .order('data_inicio', { ascending: true, nullsFirst: false });

  console.log(`   Encontrados: ${projetos?.length || 0} registros\n`);

  // 6. Consolidar primeira data para cada colaborador
  console.log('🔍 Analisando primeira interação de cada colaborador...\n');

  const datasInicio = {};

  // Processar lançamentos financeiros
  lancamentos?.forEach(l => {
    if (!l.pessoa_id) return;
    const data = l.data_pagamento || l.data_competencia || l.created_at?.split('T')[0];
    if (data && (!datasInicio[l.pessoa_id] || data < datasInicio[l.pessoa_id].data)) {
      datasInicio[l.pessoa_id] = { data, fonte: 'financeiro' };
    }
  });

  // Processar valores a receber
  valoresReceber?.forEach(v => {
    if (!v.colaborador_id) return;
    const data = v.data_pagamento || v.data_prevista || v.criado_em?.split('T')[0];
    if (data && (!datasInicio[v.colaborador_id] || data < datasInicio[v.colaborador_id].data)) {
      datasInicio[v.colaborador_id] = { data, fonte: 'valores_receber' };
    }
  });

  // Processar projetos
  projetos?.forEach(p => {
    if (!p.colaborador_id) return;
    const data = p.data_inicio || p.criado_em?.split('T')[0];
    if (data && (!datasInicio[p.colaborador_id] || data < datasInicio[p.colaborador_id].data)) {
      datasInicio[p.colaborador_id] = { data, fonte: 'projeto' };
    }
  });

  // 7. Atualizar cada colaborador
  console.log('📝 ATUALIZANDO DATA DE INÍCIO:');
  console.log('─'.repeat(80));

  let atualizados = 0;
  let semDados = 0;

  for (const colab of colaboradores) {
    const info = datasInicio[colab.id];

    if (info) {
      // Tentar atualizar
      const { error: updateError } = await supabase
        .from('pessoas')
        .update({ data_inicio: info.data })
        .eq('id', colab.id);

      if (updateError) {
        // Se coluna não existe, mostrar o que seria atualizado
        if (updateError.message.includes('data_inicio')) {
          console.log(`⚠️  ${colab.nome.padEnd(40)} | ${info.data} | ${info.fonte} | COLUNA NÃO EXISTE`);
        } else {
          console.log(`❌ ${colab.nome.padEnd(40)} | Erro: ${updateError.message}`);
        }
      } else {
        console.log(`✅ ${colab.nome.padEnd(40)} | ${info.data} | ${info.fonte}`);
        atualizados++;
      }
    } else {
      console.log(`⏳ ${colab.nome.padEnd(40)} | SEM HISTÓRICO DE PAGAMENTOS`);
      semDados++;
    }
  }

  // 8. Resumo
  console.log('\n' + '═'.repeat(60));
  console.log('📊 RESUMO');
  console.log('═'.repeat(60));
  console.log(`Total de colaboradores: ${colaboradores.length}`);
  console.log(`Atualizados com data de início: ${atualizados}`);
  console.log(`Sem histórico de pagamentos: ${semDados}`);

  if (atualizados === 0 && semDados > 0) {
    console.log('\n⚠️  ATENÇÃO: Nenhum colaborador foi atualizado.');
    console.log('   Possíveis causas:');
    console.log('   1. Coluna data_inicio não existe (precisa criar via SQL)');
    console.log('   2. Não há lançamentos financeiros vinculados aos colaboradores');
    console.log('\n   Para criar a coluna, execute no Supabase:');
    console.log('   ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;');
  }

  console.log('\n' + '═'.repeat(60));
  console.log('FIM DA ATUALIZAÇÃO');
  console.log('═'.repeat(60));
}

atualizarDataInicio().catch(err => {
  console.error('Erro:', err);
  process.exit(1);
});
