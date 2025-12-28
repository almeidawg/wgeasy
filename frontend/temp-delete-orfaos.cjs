const { createClient } = require('@supabase/supabase-js');

// Usar service_role key para poder deletar sem RLS
const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1NzEyNDMsImV4cCI6MjA3NjE0NzI0M30.gLz5lpB5YlQpTfxzJjmILZwGp_H_XsT81nM2vXDbs7Y'
);

async function main() {
  console.log('============================================');
  console.log('    LIMPEZA DE USUARIOS ORFAOS             ');
  console.log('============================================\n');

  // 1. Buscar todos usuarios
  const { data: usuarios, error: uErr } = await supabase.from('usuarios').select('id, pessoa_id, tipo_usuario, auth_user_id');

  if (uErr) {
    console.log('ERRO buscando usuarios:', uErr.message);
    return;
  }

  console.log('Total de usuarios ANTES:', usuarios.length);

  // 2. Identificar orfaos
  const orfaos = [];
  for (const u of usuarios) {
    const { data: pessoa } = await supabase.from('pessoas').select('id').eq('id', u.pessoa_id);
    if (!pessoa || pessoa.length === 0) {
      orfaos.push(u);
    }
  }

  console.log('Usuarios orfaos encontrados:', orfaos.length);

  if (orfaos.length === 0) {
    console.log('\nNenhum usuario orfao para deletar.');
    return;
  }

  // 3. Deletar orfaos um por um
  console.log('\nDeletando usuarios orfaos...');
  let deletados = 0;
  let erros = 0;

  for (const u of orfaos) {
    const { error } = await supabase.from('usuarios').delete().eq('id', u.id);

    if (error) {
      console.log('  ERRO deletando ' + u.tipo_usuario + ': ' + error.message);
      erros++;
    } else {
      console.log('  Deletado: ' + u.tipo_usuario + ' (' + u.id.substring(0, 8) + '...)');
      deletados++;
    }
  }

  // 4. Resultado final
  const { data: restantes } = await supabase.from('usuarios').select('id');

  console.log('\n============================================');
  console.log('    RESULTADO                               ');
  console.log('============================================');
  console.log('Deletados:', deletados);
  console.log('Erros:', erros);
  console.log('Usuarios restantes:', restantes?.length || 0);
}

main().catch(err => console.error('ERRO:', err.message));
