import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo'
);

// Normalizar nome para comparação
function normalizarNome(nome) {
  return (nome || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '') // remove acentos
    .replace(/[^a-z\s]/g, '') // remove caracteres especiais
    .trim();
}

async function matchPagamentos() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   MATCH DE PAGAMENTOS POR NOME - BUSCAR DATA DE INÍCIO       ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Buscar colaboradores
  const { data: colaboradores } = await supabase
    .from('pessoas')
    .select('id, nome')
    .eq('tipo', 'COLABORADOR')
    .eq('ativo', true);

  console.log(`📋 ${colaboradores.length} colaboradores para analisar\n`);

  // 2. Buscar TODOS os lançamentos de saída com data
  const { data: lancamentos } = await supabase
    .from('financeiro_lancamentos')
    .select('descricao, favorecido_nome, data_pagamento, data_competencia, data_emissao, criado_em')
    .eq('tipo', 'saida')
    .order('data_pagamento', { ascending: true, nullsFirst: false });

  console.log(`📋 ${lancamentos?.length || 0} lançamentos de saída para analisar\n`);

  // 3. Criar mapa de colaboradores normalizados
  const colabMap = {};
  colaboradores.forEach(c => {
    colabMap[normalizarNome(c.nome)] = c;
  });

  // 4. Para cada lançamento, verificar se menciona algum colaborador
  const matches = {};

  lancamentos?.forEach(l => {
    const textoDescricao = normalizarNome(l.descricao);
    const textoFavorecido = normalizarNome(l.favorecido_nome);
    const data = l.data_pagamento || l.data_competencia || l.data_emissao || l.criado_em?.split('T')[0];

    if (!data) return;

    // Verificar cada colaborador
    for (const [nomeNorm, colab] of Object.entries(colabMap)) {
      // Verificar se o nome do colaborador aparece na descrição ou favorecido
      if (textoDescricao.includes(nomeNorm) || textoFavorecido.includes(nomeNorm)) {
        // Primeiro match encontrado para este colaborador
        if (!matches[colab.id] || data < matches[colab.id].data) {
          matches[colab.id] = {
            colab: colab,
            data: data,
            descricao: l.descricao?.substring(0, 60),
            favorecido: l.favorecido_nome
          };
        }
      }
    }
  });

  // 5. Mostrar resultados
  console.log('🎯 MATCHES ENCONTRADOS (colaborador -> primeiro pagamento):');
  console.log('─'.repeat(90));

  const matchList = Object.values(matches).sort((a, b) => a.data.localeCompare(b.data));

  if (matchList.length === 0) {
    console.log('Nenhum match encontrado pelo nome completo.');
    console.log('\nTentando match parcial (primeiro + último nome)...\n');

    // Tentar match parcial
    lancamentos?.forEach(l => {
      const texto = normalizarNome(l.descricao) + ' ' + normalizarNome(l.favorecido_nome);
      const data = l.data_pagamento || l.data_competencia || l.data_emissao || l.criado_em?.split('T')[0];

      if (!data) return;

      for (const colab of colaboradores) {
        const partes = normalizarNome(colab.nome).split(/\s+/);
        if (partes.length < 2) continue;

        const primeiro = partes[0];
        const ultimo = partes[partes.length - 1];

        // Verificar se primeiro E último nome aparecem
        if (primeiro.length > 2 && ultimo.length > 2 &&
            texto.includes(primeiro) && texto.includes(ultimo)) {
          if (!matches[colab.id] || data < matches[colab.id].data) {
            matches[colab.id] = {
              colab: colab,
              data: data,
              descricao: l.descricao?.substring(0, 60),
              favorecido: l.favorecido_nome,
              matchType: 'parcial'
            };
          }
        }
      }
    });
  }

  const matchListFinal = Object.values(matches).sort((a, b) => a.data.localeCompare(b.data));

  matchListFinal.forEach(m => {
    const tipo = m.matchType === 'parcial' ? '(parcial)' : '';
    console.log(`✅ ${m.colab.nome.padEnd(40)} | ${m.data} ${tipo}`);
    console.log(`   └─ "${m.descricao || m.favorecido}"`);
  });

  console.log('\n' + '═'.repeat(60));
  console.log(`📊 TOTAL: ${matchListFinal.length} colaboradores com pagamentos encontrados`);
  console.log(`   Sem match: ${colaboradores.length - matchListFinal.length} colaboradores`);
  console.log('═'.repeat(60));

  // 6. Se encontrou matches, perguntar se quer atualizar
  if (matchListFinal.length > 0) {
    console.log('\n📝 Gerando script de UPDATE...\n');

    console.log('-- SQL para atualizar data_inicio:');
    console.log('-- Primeiro, criar a coluna:');
    console.log('ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;\n');

    matchListFinal.forEach(m => {
      console.log(`UPDATE pessoas SET data_inicio = '${m.data}' WHERE id = '${m.colab.id}'; -- ${m.colab.nome}`);
    });
  }
}

matchPagamentos().catch(console.error);
