// Script para converter os batches para estrutura correta
const fs = require('fs');
const path = require('path');

const dir = __dirname;

// Mapeamento de status
// Valores válidos na tabela: pago, pendente, atrasado, cancelado, parcialmente_pago
const STATUS_MAP = {
  'realizado': 'pago',
  'pago': 'pago',
  'pendente': 'pendente',
  'previsto': 'pendente', // 'previsto' não é válido - mapeado para 'pendente'
  'atrasado': 'atrasado',
  'cancelado': 'cancelado',
  'parcialmente pago': 'parcialmente_pago',
};

// Mapeamento de tipo
const TIPO_MAP = {
  'saida': 'saida',
  'entrada': 'entrada',
};

// Escape de strings para SQL
function escapeSql(str) {
  if (!str) return '';
  return str.replace(/'/g, "''");
}

// Parse um arquivo SQL e extrai os valores
function parseInserts(content) {
  const inserts = [];

  // Dividir por INSERT INTO
  const parts = content.split(/INSERT INTO lancamentos\s*\(/i);

  for (let i = 1; i < parts.length; i++) {
    const part = parts[i];

    // Encontrar VALUES
    const valuesMatch = part.match(/\)\s*VALUES\s*\(([\s\S]*?)\);/i);
    if (!valuesMatch) continue;

    const valuesStr = valuesMatch[1];

    // Extrair valores individualmente (lidando com aspas escapadas)
    const values = [];
    let current = '';
    let inQuote = false;
    let i2 = 0;

    while (i2 < valuesStr.length) {
      const char = valuesStr[i2];

      if (char === "'" && !inQuote) {
        inQuote = true;
        i2++;
        continue;
      }

      if (char === "'" && inQuote) {
        // Verificar se é escape ''
        if (i2 + 1 < valuesStr.length && valuesStr[i2 + 1] === "'") {
          current += "'";
          i2 += 2;
          continue;
        }
        // Fim da string
        inQuote = false;
        i2++;
        continue;
      }

      if (char === ',' && !inQuote) {
        values.push(current.trim());
        current = '';
        i2++;
        continue;
      }

      if (inQuote || char.match(/[0-9.-]/)) {
        current += char;
      }

      i2++;
    }

    // Último valor
    if (current.trim()) {
      values.push(current.trim());
    }

    if (values.length >= 10) {
      inserts.push({
        data_lancamento: values[0],
        tipo: values[1],
        natureza: values[2],
        conta_nome: values[3],
        centro_custo: values[4],
        categoria_nome: values[5],
        favorecido_nome: values[6],
        valor: parseFloat(values[7]) || 0,
        descricao: values[8],
        status: values[9],
      });
    }
  }

  return inserts;
}

// Lê um arquivo batch e converte para estrutura correta
function converterBatch(batchNum) {
  const inputFile = path.join(dir, `BATCH_${String(batchNum).padStart(2, '0')}_lancamentos.sql`);
  const outputFile = path.join(dir, `BATCH_${String(batchNum).padStart(2, '0')}_financeiro.sql`);

  if (!fs.existsSync(inputFile)) {
    console.log(`❌ Arquivo não encontrado: ${inputFile}`);
    return 0;
  }

  const content = fs.readFileSync(inputFile, 'utf-8');
  const inserts = parseInserts(content);

  if (inserts.length === 0) {
    console.log(`⚠️ Nenhum INSERT encontrado em: ${inputFile}`);
    return 0;
  }

  // Cabeçalho do novo arquivo
  let output = `-- ============================================
-- BATCH ${batchNum} de 12 (CORRIGIDO)
-- Tabela: financeiro_lancamentos
-- Núcleo: designer (W.G. DE ALMEIDA DESIGNER DE INTERIORES)
-- Total: ${inserts.length} registros
-- ============================================

BEGIN;

`;

  let ignorados = 0;
  let inseridos = 0;

  for (const row of inserts) {
    // Ignorar registros com valor zero (constraint não permite)
    if (row.valor === 0) {
      console.log(`  ⚠️ Ignorando valor zero: ${row.descricao || row.favorecido_nome}`);
      ignorados++;
      continue;
    }

    // Converter para estrutura correta
    let tipoConvertido = TIPO_MAP[row.tipo.toLowerCase()] || 'saida';
    const statusConvertido = STATUS_MAP[row.status.toLowerCase()] || 'pago';

    // Tratar valores negativos - inverter tipo e usar valor absoluto
    let valorFinal = row.valor;
    if (valorFinal < 0) {
      valorFinal = Math.abs(valorFinal);
      // Inverter tipo: saida vira entrada (estorno/devolução)
      tipoConvertido = tipoConvertido === 'saida' ? 'entrada' : 'saida';
    }

    // Construir descrição completa com contexto
    let descricaoCompleta = row.descricao;
    if (row.favorecido_nome && row.favorecido_nome.toLowerCase() !== row.descricao.toLowerCase()) {
      descricaoCompleta = `${row.favorecido_nome} - ${row.descricao}`;
    }

    const obs = `Centro: ${row.centro_custo} | Conta: ${row.conta_nome} | Categoria: ${row.categoria_nome}`;

    output += `INSERT INTO financeiro_lancamentos (
    data_competencia,
    tipo,
    valor_total,
    descricao,
    status,
    nucleo,
    observacoes
) VALUES (
    '${row.data_lancamento}',
    '${tipoConvertido}',
    ${valorFinal},
    '${escapeSql(descricaoCompleta)}',
    '${statusConvertido}',
    'designer',
    '${escapeSql(obs)}'
);

`;
    inseridos++;
  }

  output += `COMMIT;

-- Total de registros neste batch: ${inseridos}
-- Ignorados (valor zero): ${ignorados}
`;

  // Atualizar cabeçalho com contagem correta
  output = output.replace(`-- Total: ${inserts.length} registros`, `-- Total: ${inseridos} registros (${ignorados} ignorados com valor zero)`);

  fs.writeFileSync(outputFile, output, 'utf-8');
  console.log(`✅ Batch ${batchNum} convertido: ${inseridos} registros (${ignorados} ignorados) → ${outputFile}`);
  return inseridos;
}

// Converter todos os batches
console.log('🔄 Convertendo batches...\n');
let total = 0;
for (let i = 1; i <= 12; i++) {
  const count = converterBatch(i);
  total += count;
}
console.log(`\n✅ Total convertido: ${total} registros`);

// Criar arquivo de preparação atualizado
const prepFile = `-- ============================================
-- PREPARAÇÃO ANTES DE IMPORTAR OS LANÇAMENTOS
-- Execute ANTES dos BATCH_01 a BATCH_12
-- ============================================

-- 1. Verificar quantos lançamentos existem atualmente
SELECT
    'ANTES DA IMPORTAÇÃO' as fase,
    COUNT(*) as total_lancamentos,
    SUM(CASE WHEN tipo = 'entrada' THEN 1 ELSE 0 END) as entradas,
    SUM(CASE WHEN tipo = 'saida' THEN 1 ELSE 0 END) as saidas
FROM financeiro_lancamentos;

-- 2. Verificar distribuição por núcleo
SELECT
    nucleo,
    COUNT(*) as total,
    SUM(valor_total) as valor_total,
    MIN(data_competencia) as data_mais_antiga,
    MAX(data_competencia) as data_mais_recente
FROM financeiro_lancamentos
GROUP BY nucleo
ORDER BY nucleo;

-- 3. LIMPAR lançamentos antigos do núcleo arquitetura (WG Designer)
-- DESCOMENTE e execute APENAS se precisar substituir:

-- DELETE FROM financeiro_lancamentos
-- WHERE nucleo = 'designer';

-- ============================================
-- APÓS VERIFICAR:
-- 1. Decida se precisa limpar registros existentes
-- 2. Execute os BATCH_01_financeiro a BATCH_12_financeiro
-- ============================================
`;

fs.writeFileSync(path.join(dir, '00_PREPARACAO.sql'), prepFile);
console.log('\n📝 Arquivo 00_PREPARACAO.sql atualizado');
