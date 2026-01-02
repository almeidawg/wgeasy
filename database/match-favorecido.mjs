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
    .replace(/[^a-z\s]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

async function matchFavorecido() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   MATCH POR FAVORECIDO_NOME - DATA DE INÍCIO                 ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Buscar colaboradores
  const { data: colaboradores } = await supabase
    .from('pessoas')
    .select('id, nome')
    .eq('tipo', 'COLABORADOR')
    .eq('ativo', true);

  console.log(`📋 ${colaboradores.length} colaboradores\n`);

  // 2. Buscar lançamentos com favorecido_nome preenchido
  const { data: lancamentos } = await supabase
    .from('financeiro_lancamentos')
    .select('favorecido_nome, descricao, data_pagamento, data_competencia, criado_em')
    .not('favorecido_nome', 'is', null)
    .order('data_pagamento', { ascending: true, nullsFirst: false });

  console.log(`📋 ${lancamentos?.length || 0} lançamentos com favorecido_nome\n`);

  // 3. Criar índice de lançamentos por nome normalizado
  const lancamentoPorNome = {};
  lancamentos?.forEach(l => {
    const nomeNorm = normalizarNome(l.favorecido_nome);
    const data = l.data_pagamento || l.data_competencia || l.criado_em?.split('T')[0];

    if (!data || !nomeNorm) return;

    if (!lancamentoPorNome[nomeNorm] || data < lancamentoPorNome[nomeNorm].data) {
      lancamentoPorNome[nomeNorm] = {
        nome: l.favorecido_nome,
        data: data,
        descricao: l.descricao
      };
    }
  });

  // 4. Fazer match com colaboradores
  const matches = [];
  const semMatch = [];

  for (const colab of colaboradores) {
    const nomeColab = normalizarNome(colab.nome);

    // Tentar match exato primeiro
    if (lancamentoPorNome[nomeColab]) {
      matches.push({
        colab: colab,
        data: lancamentoPorNome[nomeColab].data,
        fonte: lancamentoPorNome[nomeColab].nome,
        tipo: 'exato'
      });
      continue;
    }

    // Tentar match parcial (primeiro + último nome)
    const partes = nomeColab.split(' ');
    if (partes.length >= 2) {
      const primeiro = partes[0];
      const ultimo = partes[partes.length - 1];

      let melhorMatch = null;

      for (const [nomeNorm, info] of Object.entries(lancamentoPorNome)) {
        if (nomeNorm.includes(primeiro) && nomeNorm.includes(ultimo)) {
          if (!melhorMatch || info.data < melhorMatch.data) {
            melhorMatch = { ...info, nomeNorm };
          }
        }
      }

      if (melhorMatch) {
        matches.push({
          colab: colab,
          data: melhorMatch.data,
          fonte: melhorMatch.nome,
          tipo: 'parcial'
        });
        continue;
      }
    }

    semMatch.push(colab);
  }

  // 5. Ordenar por data
  matches.sort((a, b) => a.data.localeCompare(b.data));

  // 6. Mostrar resultados
  console.log('🎯 MATCHES ENCONTRADOS:');
  console.log('─'.repeat(90));

  matches.forEach(m => {
    const tipo = m.tipo === 'parcial' ? ' (parcial)' : '';
    console.log(`✅ ${m.colab.nome.padEnd(40)} | ${m.data}${tipo}`);
    console.log(`   └─ Favorecido: "${m.fonte}"`);
  });

  console.log('\n⏳ SEM MATCH (colaboradores novos ou sem pagamentos):');
  console.log('─'.repeat(60));
  semMatch.forEach(c => {
    console.log(`   ${c.nome}`);
  });

  // 7. Gerar SQL
  console.log('\n' + '═'.repeat(70));
  console.log('📝 SQL PARA EXECUTAR NO SUPABASE:');
  console.log('═'.repeat(70) + '\n');

  console.log('-- 1. Criar coluna (se não existir):');
  console.log('ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;\n');

  console.log('-- 2. Atualizar datas de início:');
  matches.forEach(m => {
    console.log(`UPDATE pessoas SET data_inicio = '${m.data}' WHERE id = '${m.colab.id}';`);
    console.log(`-- ${m.colab.nome} (${m.tipo})`);
  });

  console.log('\n' + '═'.repeat(70));
  console.log(`📊 RESUMO: ${matches.length} com match, ${semMatch.length} sem match`);
  console.log('═'.repeat(70));
}

matchFavorecido().catch(console.error);
