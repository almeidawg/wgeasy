// Script para extrair CENTRO_CUSTO do Excel e atualizar lançamentos
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

// Extrair centros de custo únicos
const centrosCusto = new Map();

data.forEach(row => {
  const centro = row['CENTRO_CUSTO'] || row['Centro_Custo'] || row['centro_custo'] || row['F'];
  if (centro && centro.trim()) {
    const nome = centro.trim().toUpperCase();
    if (!centrosCusto.has(nome)) {
      centrosCusto.set(nome, { nome: centro.trim(), count: 0 });
    }
    centrosCusto.get(nome).count++;
  }
});

console.log(`\n👥 Total de centros de custo únicos: ${centrosCusto.size}\n`);

// Mostrar lista de centros de custo
console.log('Lista de Centros de Custo (Clientes):');
console.log('=====================================');
const centrosArray = Array.from(centrosCusto.values()).sort((a, b) => b.count - a.count);
centrosArray.forEach((c, i) => {
  console.log(`${String(i + 1).padStart(3)}. ${c.nome} (${c.count} lançamentos)`);
});

// Gerar SQL para criar clientes
let sqlClientes = `-- ============================================
-- CADASTRAR CLIENTES (CENTROS DE CUSTO)
-- Total: ${centrosCusto.size} clientes
-- ============================================

`;

centrosArray.forEach(c => {
  const nomeEscapado = c.nome.replace(/'/g, "''");
  sqlClientes += `INSERT INTO pessoas (nome, tipo)
SELECT '${nomeEscapado}', 'CLIENTE'
WHERE NOT EXISTS (SELECT 1 FROM pessoas WHERE UPPER(nome) = UPPER('${nomeEscapado}'));

`;
});

// Salvar SQL de clientes
const sqlClientesPath = path.join(__dirname, 'CADASTRAR-CLIENTES-CENTRO-CUSTO.sql');
fs.writeFileSync(sqlClientesPath, sqlClientes);
console.log(`\n✅ SQL para cadastrar clientes salvo em: ${sqlClientesPath}`);

// Gerar SQL para vincular lançamentos aos clientes
// Precisamos criar um mapeamento baseado na descrição ou outro campo
let sqlVincular = `-- ============================================
-- VINCULAR LANÇAMENTOS AOS CLIENTES
-- Baseado no CENTRO_CUSTO do Excel
-- ============================================

`;

// Criar mapeamento por descrição (se possível identificar)
// Por enquanto, vamos criar um arquivo CSV com os dados para análise
let csvContent = 'ID,DATA,TIPO,DESCRICAO,VALOR,CENTRO_CUSTO\n';
data.forEach(row => {
  const id = row['ID'] || '';
  const dataLanc = row['DATA'] || '';
  const tipo = row['TIPO'] || '';
  const descricao = (row['DESCRICAO'] || row['DESCRIÇÃO'] || '').replace(/"/g, '""');
  const valor = row['VALOR'] || row['VALOR_TOTAL'] || '';
  const centro = row['CENTRO_CUSTO'] || '';
  csvContent += `"${id}","${dataLanc}","${tipo}","${descricao}","${valor}","${centro}"\n`;
});

const csvPath = path.join(__dirname, 'lancamentos-com-centro-custo.csv');
fs.writeFileSync(csvPath, csvContent, 'utf-8');
console.log(`✅ CSV com dados salvos em: ${csvPath}`);

// Mostrar colunas disponíveis
console.log('\n📋 Colunas disponíveis no Excel:');
if (data.length > 0) {
  Object.keys(data[0]).forEach(col => {
    console.log(`   - ${col}`);
  });
}

// Mostrar amostra dos dados
console.log('\n📝 Amostra dos dados (primeiras 5 linhas):');
data.slice(0, 5).forEach((row, i) => {
  console.log(`\nLinha ${i + 1}:`);
  Object.entries(row).forEach(([key, value]) => {
    console.log(`   ${key}: ${value}`);
  });
});
