// Script para vincular lançamentos aos clientes pelo CENTRO_CUSTO
const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');

// Caminho do arquivo Excel
const excelPath = 'C:\\Users\\Atendimento\\Documents\\financeiro OLD\\LANCAMENTOS_CORRIGIDOS.xlsx';

// Ler o arquivo Excel
console.log('📂 Lendo arquivo Excel...');
const workbook = XLSX.readFile(excelPath);
const sheetName = workbook.SheetNames[0];
const sheet = workbook.Sheets[sheetName];
const data = XLSX.utils.sheet_to_json(sheet);

console.log(`📊 Total de linhas: ${data.length}`);

// Escapar strings para SQL
function escapeSql(str) {
  if (!str) return '';
  return String(str).replace(/'/g, "''");
}

// Extrair centros de custo únicos
const centrosCusto = new Set();
data.forEach(row => {
  const centro = row['CENTRO_CUSTO'];
  if (centro && centro.trim()) {
    centrosCusto.add(centro.trim());
  }
});

console.log(`👥 Total de clientes únicos: ${centrosCusto.size}\n`);

// =====================================================
// PARTE 1: SQL para cadastrar clientes
// =====================================================
let sqlClientes = `-- ============================================
-- PARTE 1: CADASTRAR CLIENTES (CENTROS DE CUSTO)
-- Total: ${centrosCusto.size} clientes
-- Execute PRIMEIRO este arquivo
-- ============================================

`;

Array.from(centrosCusto).sort().forEach(nome => {
  const nomeEscapado = escapeSql(nome);
  sqlClientes += `INSERT INTO pessoas (nome, tipo)
SELECT '${nomeEscapado}', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('${nomeEscapado}'));

`;
});

sqlClientes += `
-- Verificar clientes cadastrados:
SELECT nome FROM pessoas WHERE tipo = 'CLIENTE' ORDER BY nome;
`;

fs.writeFileSync(path.join(__dirname, '01-CADASTRAR-CLIENTES.sql'), sqlClientes);
console.log('✅ 01-CADASTRAR-CLIENTES.sql criado');

// =====================================================
// PARTE 2: SQL para vincular lançamentos
// =====================================================
// Criar mapeamento: descrição -> centro_custo
const mapeamento = new Map();
data.forEach(row => {
  const descricao = row['DESCRICAO'];
  const centro = row['CENTRO_CUSTO'];
  const valor = row['VALOR'];
  const tipo = row['TIPO'];

  if (descricao && centro) {
    // Criar chave única: descricao + valor + tipo
    const chave = `${descricao.trim()}|${valor}|${tipo}`;
    mapeamento.set(chave, centro.trim());
  }
});

console.log(`📝 Mapeamentos criados: ${mapeamento.size}`);

// Gerar SQL de UPDATE
let sqlVincular = `-- ============================================
-- PARTE 2: VINCULAR LANÇAMENTOS AOS CLIENTES
-- Execute DEPOIS de cadastrar os clientes
-- ============================================

`;

// Agrupar por centro de custo para gerar UPDATEs mais eficientes
const porCentro = new Map();
data.forEach(row => {
  const descricao = row['DESCRICAO'];
  const centro = row['CENTRO_CUSTO'];
  const valor = row['VALOR'];

  if (descricao && centro) {
    if (!porCentro.has(centro)) {
      porCentro.set(centro, []);
    }
    porCentro.get(centro).push({ descricao: descricao.trim(), valor });
  }
});

// Gerar UPDATE para cada centro de custo
Array.from(porCentro.entries()).forEach(([centro, lancamentos]) => {
  const centroEscapado = escapeSql(centro);

  sqlVincular += `-- ${centro} (${lancamentos.length} lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('${centroEscapado}') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
`;

  // Listar descrições únicas para este centro
  const descricoesUnicas = [...new Set(lancamentos.map(l => l.descricao))];
  descricoesUnicas.forEach((desc, i) => {
    const descEscapada = escapeSql(desc);
    sqlVincular += `    '${descEscapada}'${i < descricoesUnicas.length - 1 ? ',' : ''}\n`;
  });

  sqlVincular += `  );

`;
});

sqlVincular += `
-- Verificar resultado:
SELECT
    CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END as status,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE nucleo = 'designer'
GROUP BY CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END;
`;

fs.writeFileSync(path.join(__dirname, '02-VINCULAR-LANCAMENTOS.sql'), sqlVincular);
console.log('✅ 02-VINCULAR-LANCAMENTOS.sql criado');

// =====================================================
// PARTE 3: Verificação
// =====================================================
let sqlVerificar = `-- ============================================
-- PARTE 3: VERIFICAR RESULTADO
-- ============================================

-- 1. Resumo por cliente
SELECT
    p.nome as cliente,
    COUNT(*) as total_lancamentos,
    SUM(CASE WHEN fl.tipo = 'entrada' THEN fl.valor_total ELSE 0 END) as entradas,
    SUM(CASE WHEN fl.tipo = 'saida' THEN fl.valor_total ELSE 0 END) as saidas
FROM financeiro_lancamentos fl
LEFT JOIN pessoas p ON fl.pessoa_id = p.id
WHERE fl.nucleo = 'designer'
GROUP BY p.nome
ORDER BY total_lancamentos DESC;

-- 2. Lançamentos sem cliente
SELECT COUNT(*) as sem_cliente
FROM financeiro_lancamentos
WHERE nucleo = 'designer' AND pessoa_id IS NULL;
`;

fs.writeFileSync(path.join(__dirname, '03-VERIFICAR-RESULTADO.sql'), sqlVerificar);
console.log('✅ 03-VERIFICAR-RESULTADO.sql criado');

console.log('\n========================================');
console.log('📋 INSTRUÇÕES:');
console.log('========================================');
console.log('1. Execute 01-CADASTRAR-CLIENTES.sql no Supabase');
console.log('2. Execute 02-VINCULAR-LANCAMENTOS.sql no Supabase');
console.log('3. Execute 03-VERIFICAR-RESULTADO.sql para conferir');
console.log('========================================\n');
