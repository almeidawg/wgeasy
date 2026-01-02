import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1NzEyNDMsImV4cCI6MjA3NjE0NzI0M30.gLz5lpB5YlQpTfxzJjmILZwGp_H_XsT81nM2vXDbs7Y'
);

async function buscarDatasInicio() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║     BUSCA DE DATAS DE INÍCIO - PRIMEIRA INTERAÇÃO            ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Listar colaboradores
  const { data: colaboradores, error: e1 } = await supabase
    .from('pessoas')
    .select('id, nome, cpf, criado_em')
    .eq('tipo', 'COLABORADOR')
    .eq('ativo', true)
    .order('nome');

  if (e1) {
    console.error('Erro ao buscar colaboradores:', e1.message);
    return;
  }

  console.log(`📊 Analisando ${colaboradores.length} colaboradores...\n`);

  // 2. Para cada colaborador, buscar primeira interação
  const resultados = [];

  for (const colab of colaboradores) {
    let primeiraData = null;
    let fonte = null;

    // 2.1 Buscar primeiro valor a receber
    const { data: valores } = await supabase
      .from('colaborador_valores_receber')
      .select('data_pagamento, criado_em')
      .eq('colaborador_id', colab.id)
      .order('criado_em', { ascending: true })
      .limit(1);

    if (valores?.length > 0) {
      const d = valores[0].data_pagamento || valores[0].criado_em?.split('T')[0];
      if (d && (!primeiraData || d < primeiraData)) {
        primeiraData = d;
        fonte = 'valores_receber';
      }
    }

    // 2.2 Buscar primeiro projeto
    const { data: projetos } = await supabase
      .from('colaborador_projetos')
      .select('data_inicio, criado_em')
      .eq('colaborador_id', colab.id)
      .order('data_inicio', { ascending: true, nullsFirst: false })
      .limit(1);

    if (projetos?.length > 0) {
      const d = projetos[0].data_inicio || projetos[0].criado_em?.split('T')[0];
      if (d && (!primeiraData || d < primeiraData)) {
        primeiraData = d;
        fonte = 'projeto';
      }
    }

    // 2.3 Buscar primeiro lançamento financeiro
    const { data: lancamentos } = await supabase
      .from('financeiro_lancamentos')
      .select('data_pagamento, data_competencia, created_at')
      .eq('pessoa_id', colab.id)
      .order('created_at', { ascending: true })
      .limit(1);

    if (lancamentos?.length > 0) {
      const d = lancamentos[0].data_pagamento || lancamentos[0].data_competencia || lancamentos[0].created_at?.split('T')[0];
      if (d && (!primeiraData || d < primeiraData)) {
        primeiraData = d;
        fonte = 'financeiro';
      }
    }

    // 2.4 Buscar primeira solicitação de pagamento
    const { data: solicitacoes } = await supabase
      .from('solicitacoes_pagamento')
      .select('data_pagamento, criado_em')
      .eq('beneficiario_id', colab.id)
      .order('criado_em', { ascending: true })
      .limit(1);

    if (solicitacoes?.length > 0) {
      const d = solicitacoes[0].data_pagamento || solicitacoes[0].criado_em?.split('T')[0];
      if (d && (!primeiraData || d < primeiraData)) {
        primeiraData = d;
        fonte = 'solicitacao';
      }
    }

    resultados.push({
      id: colab.id,
      nome: colab.nome,
      cpf: colab.cpf,
      data_cadastro: colab.criado_em?.split('T')[0],
      primeira_interacao: primeiraData,
      fonte: fonte,
      data_sugerida: primeiraData || colab.criado_em?.split('T')[0]
    });
  }

  // 3. Exibir resultados
  console.log('📋 RESULTADOS - DATA DE INÍCIO SUGERIDA');
  console.log('─'.repeat(100));
  console.log('Nome                                      | Cadastro   | 1ª Interação | Fonte        | Sugerida');
  console.log('─'.repeat(100));

  // Ordenar por data sugerida
  resultados.sort((a, b) => (a.data_sugerida || '9999') > (b.data_sugerida || '9999') ? 1 : -1);

  resultados.forEach(r => {
    const nome = (r.nome || '').substring(0, 40).padEnd(41);
    const cadastro = (r.data_cadastro || 'N/A').padEnd(10);
    const interacao = (r.primeira_interacao || 'N/A').padEnd(12);
    const fonte = (r.fonte || '-').padEnd(12);
    const sugerida = r.data_sugerida || 'N/A';
    console.log(`${nome} | ${cadastro} | ${interacao} | ${fonte} | ${sugerida}`);
  });

  // 4. Resumo
  const comInteracao = resultados.filter(r => r.primeira_interacao);
  const semInteracao = resultados.filter(r => !r.primeira_interacao);

  console.log('\n' + '═'.repeat(60));
  console.log('📊 RESUMO');
  console.log('═'.repeat(60));
  console.log(`Com histórico de interação: ${comInteracao.length}`);
  console.log(`Sem histórico (usar cadastro): ${semInteracao.length}`);

  if (comInteracao.length > 0) {
    console.log('\n✅ COLABORADORES COM HISTÓRICO DE PAGAMENTOS/PROJETOS:');
    comInteracao.forEach(r => {
      console.log(`   ${r.nome} → ${r.primeira_interacao} (${r.fonte})`);
    });
  }

  if (semInteracao.length > 0) {
    console.log('\n⚠️  COLABORADORES SEM HISTÓRICO (precisam verificar manualmente):');
    semInteracao.slice(0, 20).forEach(r => {
      console.log(`   ${r.nome}`);
    });
    if (semInteracao.length > 20) {
      console.log(`   ... e mais ${semInteracao.length - 20} colaboradores`);
    }
  }

  console.log('\n' + '═'.repeat(60));
  console.log('FIM DA ANÁLISE');
  console.log('═'.repeat(60));
}

buscarDatasInicio().catch(err => {
  console.error('Erro na execução:', err);
  process.exit(1);
});
