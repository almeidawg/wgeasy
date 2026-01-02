import { createClient } from '@supabase/supabase-js';
import { readdirSync, statSync } from 'fs';
import { join, extname, basename } from 'path';

const supabase = createClient(
  'https://ahlqzzkxuutwoepirpzr.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo'
);

const PASTA_DOCUMENTOS = 'D:\\Grupo WG Almeida\\5 . Adm\\1 . Admistrativo\\Listagem de Equipe\\DOCUMENTOS PESSOAIS COLABORADORES';

function normalizarNome(nome) {
  return (nome || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z\s]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

// Extrair nome do colaborador do nome do arquivo
function extrairNomeDoArquivo(nomeArquivo) {
  // Remover extensão
  let nome = nomeArquivo.replace(/\.[^/.]+$/, '');

  // Padrões comuns: "NOME - DOCUMENTO", "NOME (cargo)", "RG - NOME", etc.
  // Remover prefixos comuns
  nome = nome.replace(/^(RG|CPF|CNH|DOCUMENTO|DOC)\s*[-–]\s*/i, '');

  // Remover sufixos comuns
  nome = nome.replace(/\s*[-–]\s*(FRENTE|VERSO|HABILITAÇÃO|RG|CPF|ARQUITETO|AJUDANTE.*|MARCENARIA.*)$/i, '');
  nome = nome.replace(/\s*\([^)]+\)\s*$/i, ''); // Remove (cargo) no final
  nome = nome.replace(/\s*[-–]\s*$/, ''); // Remove traço solto no final

  return nome.trim();
}

// Extrair data do nome do arquivo
function extrairDataDoNome(nomeArquivo) {
  const match = nomeArquivo.match(/(\d{4})-(\d{2})-(\d{2})/);
  if (match) {
    return `${match[1]}-${match[2]}-${match[3]}`;
  }
  return null;
}

async function matchDocumentos() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   MATCH DOCUMENTOS -> COLABORADORES                          ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  // 1. Buscar colaboradores do banco
  console.log('📋 Buscando colaboradores do banco...');
  const { data: colaboradores, error } = await supabase
    .from('pessoas')
    .select('id, nome, data_inicio, criado_em')
    .eq('tipo', 'COLABORADOR')
    .eq('ativo', true)
    .order('nome');

  if (error) {
    console.error('Erro:', error.message);
    return;
  }

  console.log(`   ${colaboradores.length} colaboradores encontrados\n`);

  // Criar mapa de colaboradores normalizados
  const colabMap = {};
  colaboradores.forEach(c => {
    colabMap[normalizarNome(c.nome)] = c;
  });

  // 2. Ler arquivos da pasta
  console.log('📁 Lendo arquivos da pasta de documentos...');
  let arquivos;
  try {
    arquivos = readdirSync(PASTA_DOCUMENTOS);
  } catch (err) {
    console.error('Erro ao ler pasta:', err.message);
    return;
  }

  console.log(`   ${arquivos.length} arquivos encontrados\n`);

  // 3. Extrair nomes e datas dos arquivos
  const documentos = [];
  for (const arquivo of arquivos) {
    const caminhoCompleto = join(PASTA_DOCUMENTOS, arquivo);

    try {
      const stat = statSync(caminhoCompleto);
      if (!stat.isFile()) continue;

      const nomeExtraido = extrairNomeDoArquivo(arquivo);
      const dataNoNome = extrairDataDoNome(arquivo);
      const dataCriacao = stat.birthtime || stat.ctime;
      const dataModificacao = stat.mtime;

      documentos.push({
        arquivo: arquivo,
        nomeExtraido: nomeExtraido,
        nomeNormalizado: normalizarNome(nomeExtraido),
        dataNoNome: dataNoNome,
        dataCriacao: dataCriacao.toISOString().split('T')[0],
        dataModificacao: dataModificacao.toISOString().split('T')[0]
      });
    } catch (err) {
      // Ignorar erros de arquivos individuais
    }
  }

  // 4. Fazer match entre documentos e colaboradores
  console.log('🔍 FAZENDO MATCH COM COLABORADORES:');
  console.log('─'.repeat(90));

  const matches = [];
  const semMatch = [];
  const jaProcessado = new Set();

  for (const doc of documentos) {
    // Pular arquivos que são apenas datas (sem nome)
    if (!doc.nomeExtraido || doc.nomeExtraido.match(/^\d/)) {
      continue;
    }

    // Pular se já processou este nome
    if (jaProcessado.has(doc.nomeNormalizado)) {
      continue;
    }
    jaProcessado.add(doc.nomeNormalizado);

    // Tentar match exato
    let matchEncontrado = colabMap[doc.nomeNormalizado];

    // Se não encontrou, tentar match parcial (primeiro + último nome)
    if (!matchEncontrado) {
      const partes = doc.nomeNormalizado.split(' ').filter(p => p.length > 2);

      if (partes.length >= 2) {
        const primeiro = partes[0];
        const ultimo = partes[partes.length - 1];

        for (const [nomeNorm, colab] of Object.entries(colabMap)) {
          if (nomeNorm.includes(primeiro) && nomeNorm.includes(ultimo)) {
            matchEncontrado = colab;
            break;
          }
        }
      }
    }

    if (matchEncontrado) {
      // Determinar a data mais antiga disponível
      let dataMaisAntiga = doc.dataCriacao;
      if (doc.dataNoNome && doc.dataNoNome < dataMaisAntiga) {
        dataMaisAntiga = doc.dataNoNome;
      }

      matches.push({
        documento: doc.nomeExtraido,
        arquivo: doc.arquivo,
        colaborador: matchEncontrado,
        dataNoNome: doc.dataNoNome,
        dataCriacao: doc.dataCriacao,
        dataMaisAntiga: dataMaisAntiga
      });

      const dataInfo = doc.dataNoNome ? ` | Data foto: ${doc.dataNoNome}` : '';
      console.log(`✅ ${doc.nomeExtraido.padEnd(45)} -> ${matchEncontrado.nome}`);
      console.log(`   └─ Arquivo: ${doc.dataCriacao}${dataInfo}`);
    } else {
      semMatch.push(doc);
      console.log(`⏳ ${doc.nomeExtraido.padEnd(45)} -> SEM MATCH NO BANCO`);
    }
  }

  // 5. Mostrar resumo
  console.log('\n' + '═'.repeat(70));
  console.log('📊 RESUMO DO MATCH');
  console.log('═'.repeat(70));
  console.log(`Documentos processados: ${jaProcessado.size}`);
  console.log(`Matches encontrados: ${matches.length}`);
  console.log(`Sem match: ${semMatch.length}`);

  // 6. Comparar com datas existentes no banco
  console.log('\n\n🔍 COMPARAÇÃO COM DATAS EXISTENTES NO BANCO:');
  console.log('─'.repeat(90));

  const atualizacoes = [];

  for (const m of matches) {
    const dataAtual = m.colaborador.data_inicio;
    const dataCriado = m.colaborador.criado_em?.split('T')[0];
    const dataDocumento = m.dataMaisAntiga;

    // Se não tem data de início ou a data do documento é mais antiga
    if (!dataAtual || dataDocumento < dataAtual) {
      atualizacoes.push({
        id: m.colaborador.id,
        nome: m.colaborador.nome,
        dataAtual: dataAtual,
        dataNova: dataDocumento,
        fonte: m.dataNoNome ? 'foto' : 'arquivo'
      });

      console.log(`📝 ${m.colaborador.nome}`);
      console.log(`   Atual: ${dataAtual || 'N/A'} -> Nova: ${dataDocumento} (${m.dataNoNome ? 'data da foto' : 'data do arquivo'})`);
    } else {
      console.log(`✅ ${m.colaborador.nome} - Data OK (${dataAtual})`);
    }
  }

  // 7. Gerar SQL de atualização
  if (atualizacoes.length > 0) {
    console.log('\n\n' + '═'.repeat(70));
    console.log('📝 SQL PARA ATUALIZAR DATAS DE INÍCIO:');
    console.log('═'.repeat(70) + '\n');

    for (const a of atualizacoes) {
      console.log(`UPDATE pessoas SET data_inicio = '${a.dataNova}' WHERE id = '${a.id}';`);
      console.log(`-- ${a.nome} (${a.fonte}): ${a.dataAtual || 'N/A'} -> ${a.dataNova}`);
    }
  }

  console.log('\n' + '═'.repeat(70));
  console.log('FIM DO PROCESSAMENTO');
  console.log('═'.repeat(70));
}

matchDocumentos().catch(console.error);
