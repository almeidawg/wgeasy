import { readdirSync, statSync, readFileSync } from 'fs';
import { join, extname, basename, dirname } from 'path';

// Pasta de documentos pessoais dos colaboradores
const PASTA_DOCUMENTOS = 'D:\\Grupo WG Almeida\\5 . Adm\\1 . Admistrativo\\Listagem de Equipe\\DOCUMENTOS PESSOAIS COLABORADORES';

// Extensões de imagem suportadas
const EXTENSOES_IMAGEM = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp', '.pdf'];

function normalizarNome(nome) {
  return (nome || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z\s]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

// Extrair data do nome da pasta ou arquivo (formato AAAA-MM-DD, DD-MM-AAAA, AAAA_MM_DD, etc.)
function extrairDataDeNome(nome) {
  // Padrões comuns de data em nomes de arquivos/pastas
  const padroes = [
    /(\d{4})[_\-\s]?(\d{2})[_\-\s]?(\d{2})/,  // AAAA-MM-DD ou AAAA_MM_DD
    /(\d{2})[_\-\s]?(\d{2})[_\-\s]?(\d{4})/,  // DD-MM-AAAA ou DD_MM_AAAA
    /(\d{2})(\d{2})(\d{4})/,                    // DDMMAAAA
    /(\d{4})(\d{2})(\d{2})/,                    // AAAAMMDD
  ];

  for (const padrao of padroes) {
    const match = nome.match(padrao);
    if (match) {
      let ano, mes, dia;

      // Detectar formato
      if (parseInt(match[1]) > 1900) {
        // Começa com ano (AAAA-MM-DD)
        ano = match[1];
        mes = match[2];
        dia = match[3];
      } else if (parseInt(match[3]) > 1900) {
        // Termina com ano (DD-MM-AAAA)
        dia = match[1];
        mes = match[2];
        ano = match[3];
      } else {
        continue;
      }

      // Validar
      const anoNum = parseInt(ano);
      const mesNum = parseInt(mes);
      const diaNum = parseInt(dia);

      if (anoNum >= 2000 && anoNum <= 2030 && mesNum >= 1 && mesNum <= 12 && diaNum >= 1 && diaNum <= 31) {
        return `${ano}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`;
      }
    }
  }

  return null;
}

// Verificar se a pasta existe e listar conteúdo
function listarPasta(caminho, nivel = 0) {
  const resultados = [];

  try {
    const itens = readdirSync(caminho);

    for (const item of itens) {
      const caminhoCompleto = join(caminho, item);

      try {
        const stat = statSync(caminhoCompleto);

        if (stat.isDirectory()) {
          // É uma pasta - pode ser nome de colaborador
          const nomeColaborador = item;
          const dataModificacao = stat.mtime;
          const dataCriacao = stat.birthtime || stat.ctime;

          // Verificar se tem data no nome da pasta
          const dataNoNome = extrairDataDeNome(item);

          resultados.push({
            tipo: 'pasta',
            nome: nomeColaborador,
            caminho: caminhoCompleto,
            dataModificacao: dataModificacao.toISOString().split('T')[0],
            dataCriacao: dataCriacao.toISOString().split('T')[0],
            dataNoNome: dataNoNome,
            nivel: nivel
          });

          // Listar conteúdo da subpasta (até 2 níveis)
          if (nivel < 2) {
            const subResultados = listarPasta(caminhoCompleto, nivel + 1);
            resultados.push(...subResultados);
          }
        } else if (stat.isFile()) {
          const ext = extname(item).toLowerCase();

          // Se for imagem ou PDF, coletar informações
          if (EXTENSOES_IMAGEM.includes(ext)) {
            const dataModificacao = stat.mtime;
            const dataCriacao = stat.birthtime || stat.ctime;
            const dataNoNome = extrairDataDeNome(item);

            resultados.push({
              tipo: 'arquivo',
              nome: item,
              caminho: caminhoCompleto,
              pasta: basename(dirname(caminhoCompleto)),
              tamanho: stat.size,
              dataModificacao: dataModificacao.toISOString().split('T')[0],
              dataCriacao: dataCriacao.toISOString().split('T')[0],
              dataNoNome: dataNoNome,
              nivel: nivel
            });
          }
        }
      } catch (errItem) {
        // Ignorar erros de acesso a itens individuais
      }
    }
  } catch (err) {
    console.error(`Erro ao ler pasta: ${caminho}`, err.message);
  }

  return resultados;
}

async function scanDocumentos() {
  console.log('╔══════════════════════════════════════════════════════════════╗');
  console.log('║   SCAN DE DOCUMENTOS - BUSCA DE DATAS EM METADADOS           ║');
  console.log('╚══════════════════════════════════════════════════════════════╝\n');

  console.log(`📁 Pasta: ${PASTA_DOCUMENTOS}\n`);

  // Verificar se a pasta existe
  try {
    statSync(PASTA_DOCUMENTOS);
  } catch (err) {
    console.error('❌ Pasta não encontrada:', PASTA_DOCUMENTOS);
    console.log('\n   Verifique se o caminho está correto e se você tem acesso à pasta.');
    return;
  }

  // Listar conteúdo
  console.log('🔍 Escaneando pasta...\n');
  const resultados = listarPasta(PASTA_DOCUMENTOS);

  // Separar pastas (possíveis nomes de colaboradores) e arquivos
  const pastas = resultados.filter(r => r.tipo === 'pasta' && r.nivel === 0);
  const arquivos = resultados.filter(r => r.tipo === 'arquivo');

  console.log(`📋 Encontradas ${pastas.length} pastas (possíveis colaboradores)`);
  console.log(`📋 Encontrados ${arquivos.length} arquivos de imagem/documento\n`);

  // Analisar pastas principais (nomes de colaboradores)
  console.log('👥 PASTAS PRINCIPAIS (NOMES DE COLABORADORES):');
  console.log('─'.repeat(80));

  const colaboradoresEncontrados = [];

  for (const pasta of pastas) {
    // A data mais antiga é provavelmente quando o colaborador começou
    let dataMaisAntiga = pasta.dataCriacao;

    // Verificar arquivos dentro desta pasta
    const arquivosDaPasta = arquivos.filter(a => a.caminho.startsWith(pasta.caminho));

    for (const arq of arquivosDaPasta) {
      if (arq.dataCriacao < dataMaisAntiga) {
        dataMaisAntiga = arq.dataCriacao;
      }
      if (arq.dataNoNome && arq.dataNoNome < dataMaisAntiga) {
        dataMaisAntiga = arq.dataNoNome;
      }
    }

    colaboradoresEncontrados.push({
      nome: pasta.nome,
      dataCriacao: pasta.dataCriacao,
      dataModificacao: pasta.dataModificacao,
      dataNoNome: pasta.dataNoNome,
      dataMaisAntiga: dataMaisAntiga,
      qtdArquivos: arquivosDaPasta.length
    });

    const dataInfo = pasta.dataNoNome ? ` (data no nome: ${pasta.dataNoNome})` : '';
    console.log(`📁 ${pasta.nome.padEnd(40)} | Criação: ${pasta.dataCriacao} | Modif: ${pasta.dataModificacao}${dataInfo}`);
    console.log(`   └─ ${arquivosDaPasta.length} arquivos | Data mais antiga: ${dataMaisAntiga}`);
  }

  // Resumo de arquivos com datas no nome
  const arquivosComData = arquivos.filter(a => a.dataNoNome);
  if (arquivosComData.length > 0) {
    console.log('\n\n📅 ARQUIVOS COM DATA NO NOME:');
    console.log('─'.repeat(80));

    for (const arq of arquivosComData) {
      console.log(`   ${arq.nome}`);
      console.log(`   └─ Data no nome: ${arq.dataNoNome} | Pasta: ${arq.pasta}`);
    }
  }

  // Gerar SQL de atualização sugerido
  console.log('\n\n' + '═'.repeat(70));
  console.log('📝 MAPEAMENTO COLABORADOR -> DATA MAIS ANTIGA');
  console.log('═'.repeat(70) + '\n');

  // Ordenar por data mais antiga
  colaboradoresEncontrados.sort((a, b) => a.dataMaisAntiga.localeCompare(b.dataMaisAntiga));

  for (const colab of colaboradoresEncontrados) {
    console.log(`${colab.nome.padEnd(45)} | ${colab.dataMaisAntiga}`);
  }

  console.log('\n' + '═'.repeat(70));
  console.log('📊 RESUMO');
  console.log('═'.repeat(70));
  console.log(`Total de pastas (colaboradores): ${pastas.length}`);
  console.log(`Total de arquivos: ${arquivos.length}`);
  console.log(`Arquivos com data no nome: ${arquivosComData.length}`);
  console.log('═'.repeat(70));
}

scanDocumentos().catch(console.error);
