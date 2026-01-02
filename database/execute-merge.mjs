import { createClient } from '@supabase/supabase-js';

// Usando SERVICE ROLE KEY para permissões de admin
const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo'
);

// IDs para o merge
const ID_MANTER = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94';  // Tem email e CPF
const ID_REMOVER = '5f88992c-cb32-4e86-80cc-c171eb8da867'; // Sem dados

async function executarMerge() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║           MERGE DE DUPLICATA - JOSEMAR JOAQUIM DE SOUZA      ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Verificar registros antes
  console.log('📋 ANTES DO MERGE:');
  const { data: antes } = await supabase
    .from('pessoas')
    .select('id, nome, email, cpf, ativo, criado_em')
    .in('id', [ID_MANTER, ID_REMOVER]);

  antes?.forEach(p => {
    console.log(`   ${p.nome}`);
    console.log(`   ID: ${p.id}`);
    console.log(`   Email: ${p.email || 'N/A'}`);
    console.log(`   CPF: ${p.cpf || 'N/A'}`);
    console.log(`   Ativo: ${p.ativo}`);
    console.log('');
  });

  // 2. Transferir colaborador_valores_receber
  console.log('🔄 Transferindo colaborador_valores_receber...');
  const { error: e1, count: c1 } = await supabase
    .from('colaborador_valores_receber')
    .update({ colaborador_id: ID_MANTER })
    .eq('colaborador_id', ID_REMOVER);
  console.log(e1 ? `   ❌ Erro: ${e1.message}` : `   ✅ OK`);

  // 3. Transferir colaborador_projetos
  console.log('🔄 Transferindo colaborador_projetos...');
  const { error: e2 } = await supabase
    .from('colaborador_projetos')
    .update({ colaborador_id: ID_MANTER })
    .eq('colaborador_id', ID_REMOVER);
  console.log(e2 ? `   ❌ Erro: ${e2.message}` : `   ✅ OK`);

  // 4. Transferir financeiro_lancamentos
  console.log('🔄 Transferindo financeiro_lancamentos...');
  const { error: e3 } = await supabase
    .from('financeiro_lancamentos')
    .update({ pessoa_id: ID_MANTER })
    .eq('pessoa_id', ID_REMOVER);
  console.log(e3 ? `   ❌ Erro: ${e3.message}` : `   ✅ OK`);

  // 5. Transferir solicitacoes_pagamento (beneficiário)
  console.log('🔄 Transferindo solicitacoes_pagamento (beneficiário)...');
  const { error: e4 } = await supabase
    .from('solicitacoes_pagamento')
    .update({ beneficiario_id: ID_MANTER })
    .eq('beneficiario_id', ID_REMOVER);
  console.log(e4 ? `   ❌ Erro: ${e4.message}` : `   ✅ OK`);

  // 6. Transferir solicitacoes_pagamento (solicitante)
  console.log('🔄 Transferindo solicitacoes_pagamento (solicitante)...');
  const { error: e5 } = await supabase
    .from('solicitacoes_pagamento')
    .update({ solicitante_id: ID_MANTER })
    .eq('solicitante_id', ID_REMOVER);
  console.log(e5 ? `   ❌ Erro: ${e5.message}` : `   ✅ OK`);

  // 7. Transferir auditoria_logs
  console.log('🔄 Transferindo auditoria_logs...');
  const { error: e6 } = await supabase
    .from('auditoria_logs')
    .update({ pessoa_id: ID_MANTER })
    .eq('pessoa_id', ID_REMOVER);
  console.log(e6 ? `   ❌ Erro: ${e6.message}` : `   ✅ OK`);

  // 8. Marcar duplicata como inativa
  console.log('🔄 Marcando duplicata como inativa...');
  const { error: e7 } = await supabase
    .from('pessoas')
    .update({
      ativo: false,
      observacoes: `[DUPLICATA MESCLADA] Registros transferidos para ID ${ID_MANTER} em ${new Date().toISOString()}`
    })
    .eq('id', ID_REMOVER);
  console.log(e7 ? `   ❌ Erro: ${e7.message}` : `   ✅ OK`);

  // 9. Verificar resultado
  console.log('\n📋 DEPOIS DO MERGE:');
  const { data: depois } = await supabase
    .from('pessoas')
    .select('id, nome, email, cpf, ativo, observacoes')
    .in('id', [ID_MANTER, ID_REMOVER]);

  depois?.forEach(p => {
    const status = p.ativo ? '✅ ATIVO (PRINCIPAL)' : '❌ INATIVO (MESCLADO)';
    console.log(`   ${p.nome} - ${status}`);
    console.log(`   ID: ${p.id}`);
    console.log(`   Email: ${p.email || 'N/A'}`);
    console.log(`   CPF: ${p.cpf || 'N/A'}`);
    if (p.observacoes) console.log(`   Obs: ${p.observacoes.substring(0, 80)}...`);
    console.log('');
  });

  console.log('═'.repeat(60));
  console.log('✅ MERGE CONCLUÍDO COM SUCESSO!');
  console.log('═'.repeat(60));
}

executarMerge().catch(err => {
  console.error('❌ Erro na execução:', err);
  process.exit(1);
});
