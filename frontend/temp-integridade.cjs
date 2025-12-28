const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1NzEyNDMsImV4cCI6MjA3NjE0NzI0M30.gLz5lpB5YlQpTfxzJjmILZwGp_H_XsT81nM2vXDbs7Y'
);

async function main() {
  // Buscar todos usuários
  const { data: usuarios, error: uErr } = await supabase.from('usuarios').select('id, pessoa_id, tipo_usuario, auth_user_id');

  if (uErr) {
    console.log('ERRO buscando usuarios:', uErr.message);
    return;
  }

  console.log('============================================');
  console.log('    VERIFICACAO DE INTEGRIDADE             ');
  console.log('============================================\n');
  console.log('Total de usuarios:', usuarios.length);

  const orfaos = [];
  const ok = [];

  for (const u of usuarios) {
    const { data: pessoa } = await supabase.from('pessoas').select('id, nome, email').eq('id', u.pessoa_id);

    if (!pessoa || pessoa.length === 0) {
      orfaos.push(u);
    } else {
      ok.push({ ...u, pessoa: pessoa[0] });
    }
  }

  console.log('\n--- USUARIOS COM PESSOA VALIDA: ' + ok.length + ' ---');
  ok.forEach(u => {
    const status = u.auth_user_id ? 'OK' : 'SEM_AUTH';
    console.log('  [' + status + '] ' + u.pessoa.nome + ' <' + u.pessoa.email + '>');
  });

  console.log('\n--- USUARIOS ORFAOS (pessoa nao existe): ' + orfaos.length + ' ---');
  orfaos.forEach(u => {
    const status = u.auth_user_id ? 'TEM_AUTH' : 'SEM_AUTH';
    console.log('  [' + status + '] tipo:' + u.tipo_usuario + ' pessoa_id:' + u.pessoa_id);
  });

  console.log('\n============================================');
  console.log('    RESUMO                                  ');
  console.log('============================================');
  console.log('Usuarios validos:', ok.length);
  console.log('Usuarios orfaos (para deletar):', orfaos.length);
  console.log('Usuarios sem auth (para corrigir):', ok.filter(u => !u.auth_user_id).length);
}

main().catch(err => console.error('ERRO:', err.message));
