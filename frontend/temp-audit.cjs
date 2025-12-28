const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1NzEyNDMsImV4cCI6MjA3NjE0NzI0M30.gLz5lpB5YlQpTfxzJjmILZwGp_H_XsT81nM2vXDbs7Y'
);

async function main() {
  console.log('============================================');
  console.log('      AUDITORIA GERAL DO BANCO - WGEASY    ');
  console.log('============================================\n');

  // Pessoas
  const { data: pessoas, error: e1 } = await supabase.from('pessoas').select('id, tipo');
  console.log('PESSOAS:', pessoas?.length || 0);
  if (pessoas && pessoas.length > 0) {
    const tipos = pessoas.reduce((acc, p) => {
      acc[p.tipo || 'sem_tipo'] = (acc[p.tipo || 'sem_tipo'] || 0) + 1;
      return acc;
    }, {});
    console.log('  Por tipo:', JSON.stringify(tipos));
  }

  // Oportunidades
  const { data: oportunidades } = await supabase.from('oportunidades').select('id, status');
  console.log('\nOPORTUNIDADES:', oportunidades?.length || 0);
  if (oportunidades && oportunidades.length > 0) {
    const status = oportunidades.reduce((acc, o) => {
      acc[o.status || 'sem_status'] = (acc[o.status || 'sem_status'] || 0) + 1;
      return acc;
    }, {});
    console.log('  Por status:', JSON.stringify(status));
  }

  // Propostas
  const { data: propostas } = await supabase.from('propostas').select('id, status, oportunidade_id');
  console.log('\nPROPOSTAS:', propostas?.length || 0);
  if (propostas && propostas.length > 0) {
    const semOportunidade = propostas.filter(p => p.oportunidade_id === null).length;
    console.log('  Sem oportunidade vinculada:', semOportunidade);
  }

  // Contratos
  const { data: contratos } = await supabase.from('contratos').select('id, status, proposta_id');
  console.log('\nCONTRATOS:', contratos?.length || 0);
  if (contratos && contratos.length > 0) {
    const semProposta = contratos.filter(c => c.proposta_id === null).length;
    console.log('  Sem proposta vinculada:', semProposta);
  }

  // Projetos
  const { data: projetos } = await supabase.from('projetos').select('id, status, contrato_id');
  console.log('\nPROJETOS:', projetos?.length || 0);

  // Lançamentos financeiros
  const { data: lancamentos } = await supabase.from('lancamentos').select('id, cliente_id, tipo, categoria');
  console.log('\nLANCAMENTOS:', lancamentos?.length || 0);
  if (lancamentos && lancamentos.length > 0) {
    const semCliente = lancamentos.filter(l => l.cliente_id === null).length;
    console.log('  Sem cliente:', semCliente);
    console.log('  Com cliente:', lancamentos.length - semCliente);

    const tipos = lancamentos.reduce((acc, l) => {
      acc[l.tipo || 'sem_tipo'] = (acc[l.tipo || 'sem_tipo'] || 0) + 1;
      return acc;
    }, {});
    console.log('  Por tipo:', JSON.stringify(tipos));
  }

  // Usuários
  const { data: usuarios } = await supabase.from('usuarios').select('id, auth_user_id, tipo_usuario, ativo');
  console.log('\nUSUARIOS:', usuarios?.length || 0);
  if (usuarios && usuarios.length > 0) {
    const semAuth = usuarios.filter(u => u.auth_user_id === null).length;
    const inativos = usuarios.filter(u => u.ativo === false).length;
    console.log('  Sem auth (problema):', semAuth);
    console.log('  Inativos:', inativos);
    console.log('  Ativos com auth:', usuarios.length - semAuth - inativos);
  }

  // Centros de Custo
  const { data: centros } = await supabase.from('centros_custo').select('id, nome');
  console.log('\nCENTROS DE CUSTO:', centros?.length || 0);

  // Núcleos
  const { data: nucleos } = await supabase.from('nucleos').select('id, nome');
  console.log('NUCLEOS:', nucleos?.length || 0);
  if (nucleos) {
    console.log('  Nomes:', nucleos.map(n => n.nome).join(', '));
  }

  console.log('\n============================================');
  console.log('           FIM DA AUDITORIA                 ');
  console.log('============================================');
}

main().catch(err => {
  console.error('ERRO:', err.message);
  process.exit(1);
});
