import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1NzEyNDMsImV4cCI6MjA3NjE0NzI0M30.gLz5lpB5YlQpTfxzJjmILZwGp_H_XsT81nM2vXDbs7Y'
);

async function analisar() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║           AUDITORIA DE COLABORADORES - WG EASY               ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Listar colaboradores
  const { data: colaboradores, error: e1 } = await supabase
    .from('pessoas')
    .select('id, nome, email, cpf, criado_em, ativo')
    .eq('tipo', 'COLABORADOR')
    .order('nome');

  if (e1) {
    console.error('Erro ao buscar colaboradores:', e1.message);
    return;
  }

  console.log('📊 RESUMO GERAL');
  console.log('─'.repeat(50));
  console.log(`Total de Colaboradores: ${colaboradores.length}`);
  console.log(`Ativos: ${colaboradores.filter(c => c.ativo).length}`);
  console.log(`Inativos: ${colaboradores.filter(c => !c.ativo).length}`);
  console.log(`Com CPF: ${colaboradores.filter(c => c.cpf).length}`);
  console.log(`Sem CPF: ${colaboradores.filter(c => !c.cpf).length}`);

  console.log('\n📋 LISTA COMPLETA DE COLABORADORES');
  console.log('─'.repeat(80));
  console.log('Nº  | Nome                                    | CPF           | Cadastro   | Ativo');
  console.log('─'.repeat(80));

  colaboradores.forEach((c, i) => {
    const nome = (c.nome || '').substring(0, 40).padEnd(40);
    const cpf = (c.cpf || 'N/A').padEnd(14);
    const data = c.criado_em ? c.criado_em.split('T')[0] : 'N/A';
    const ativo = c.ativo ? '✓' : '✗';
    console.log(`${String(i+1).padStart(3)} | ${nome} | ${cpf} | ${data} | ${ativo}`);
  });

  // 2. Buscar duplicatas por nome
  console.log('\n\n🔍 DUPLICATAS POR NOME (EXATO)');
  console.log('─'.repeat(50));

  const nomeCount = {};
  colaboradores.forEach(c => {
    const key = (c.nome || '').toLowerCase().trim();
    if (!nomeCount[key]) nomeCount[key] = [];
    nomeCount[key].push(c);
  });

  const duplicatasNome = Object.entries(nomeCount).filter(([k, v]) => v.length > 1);
  if (duplicatasNome.length === 0) {
    console.log('✅ Nenhuma duplicata exata por nome encontrada.');
  } else {
    console.log(`⚠️  ${duplicatasNome.length} grupo(s) de duplicatas encontrado(s):\n`);
    duplicatasNome.forEach(([nome, pessoas]) => {
      console.log(`📌 "${nome.toUpperCase()}" - ${pessoas.length} registros:`);
      pessoas.forEach(p => {
        console.log(`   └─ ID: ${p.id}`);
        console.log(`      Email: ${p.email || 'N/A'}`);
        console.log(`      CPF: ${p.cpf || 'N/A'}`);
        console.log(`      Cadastro: ${p.criado_em?.split('T')[0] || 'N/A'}`);
        console.log(`      Ativo: ${p.ativo ? 'Sim' : 'Não'}`);
      });
      console.log();
    });
  }

  // 3. Buscar duplicatas por CPF
  console.log('\n🔍 DUPLICATAS POR CPF');
  console.log('─'.repeat(50));

  const cpfCount = {};
  colaboradores.filter(c => c.cpf).forEach(c => {
    const key = c.cpf.replace(/\D/g, '');
    if (key.length >= 11) {
      if (!cpfCount[key]) cpfCount[key] = [];
      cpfCount[key].push(c);
    }
  });

  const duplicatasCpf = Object.entries(cpfCount).filter(([k, v]) => v.length > 1);
  if (duplicatasCpf.length === 0) {
    console.log('✅ Nenhuma duplicata por CPF encontrada.');
  } else {
    console.log(`⚠️  ${duplicatasCpf.length} CPF(s) duplicado(s):\n`);
    duplicatasCpf.forEach(([cpf, pessoas]) => {
      console.log(`📌 CPF: ${cpf}`);
      pessoas.forEach(p => {
        console.log(`   └─ ${p.nome} (ID: ${p.id})`);
      });
      console.log();
    });
  }

  // 4. Buscar nomes similares (primeiro + último nome iguais)
  console.log('\n🔍 POSSÍVEIS DUPLICATAS (MESMO PRIMEIRO E ÚLTIMO NOME)');
  console.log('─'.repeat(50));

  const nomeParts = {};
  colaboradores.forEach(c => {
    const partes = (c.nome || '').toLowerCase().trim().split(/\s+/);
    if (partes.length >= 2) {
      const key = `${partes[0]}|${partes[partes.length - 1]}`;
      if (!nomeParts[key]) nomeParts[key] = [];
      nomeParts[key].push(c);
    }
  });

  const similares = Object.entries(nomeParts)
    .filter(([k, v]) => v.length > 1)
    .filter(([k, v]) => {
      // Excluir se já é duplicata exata
      const nomes = v.map(p => (p.nome || '').toLowerCase().trim());
      return new Set(nomes).size > 1;
    });

  if (similares.length === 0) {
    console.log('✅ Nenhum nome similar encontrado.');
  } else {
    console.log(`⚠️  ${similares.length} grupo(s) de nomes similares:\n`);
    similares.forEach(([key, pessoas]) => {
      const [primeiro, ultimo] = key.split('|');
      console.log(`📌 Primeiro nome: "${primeiro}" / Último nome: "${ultimo}"`);
      pessoas.forEach(p => {
        console.log(`   └─ ${p.nome}`);
        console.log(`      ID: ${p.id} | CPF: ${p.cpf || 'N/A'}`);
      });
      console.log();
    });
  }

  // 5. Colaboradores sem data de cadastro definida
  console.log('\n📅 COLABORADORES SEM DATA DE CADASTRO');
  console.log('─'.repeat(50));

  const semData = colaboradores.filter(c => !c.criado_em);
  if (semData.length === 0) {
    console.log('✅ Todos os colaboradores têm data de cadastro.');
  } else {
    console.log(`⚠️  ${semData.length} colaborador(es) sem data:\n`);
    semData.forEach(p => {
      console.log(`   └─ ${p.nome} (ID: ${p.id})`);
    });
  }

  console.log('\n' + '═'.repeat(60));
  console.log('FIM DA AUDITORIA');
  console.log('═'.repeat(60));
}

analisar().catch(err => {
  console.error('Erro na execução:', err);
  process.exit(1);
});
