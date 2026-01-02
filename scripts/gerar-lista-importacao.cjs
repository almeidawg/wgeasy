/**
 * Script para gerar lista de produtos para importação no sistema
 * Gera um arquivo de texto com os nomes dos produtos para colar na página de importação em lote
 */

const fs = require('fs');
const path = require('path');

// Caminho do arquivo JSON com produtos
const PRODUTOS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos-com-imagens.json');

// Carregar produtos
const produtos = JSON.parse(fs.readFileSync(PRODUTOS_JSON, 'utf-8'));

console.log('=== Gerador de Lista para Importação ===\n');
console.log(`Total de produtos: ${produtos.length}\n`);

// Agrupar por categoria
const porCategoria = {};
produtos.forEach(p => {
  const cat = p.categoria || 'SEM CATEGORIA';
  if (!porCategoria[cat]) {
    porCategoria[cat] = [];
  }
  porCategoria[cat].push(p);
});

// Gerar arquivo de texto para colar na importação em lote
let textoImportacao = '';

Object.entries(porCategoria).forEach(([categoria, itens]) => {
  textoImportacao += `\n=== ${categoria} ===\n`;
  itens.forEach(p => {
    textoImportacao += `${p.descricao}\n`;
  });
});

// Salvar arquivo
const arquivoTexto = path.join(__dirname, '../frontend/database/leroy-lista-importacao.txt');
fs.writeFileSync(arquivoTexto, textoImportacao, 'utf-8');
console.log(`Lista de importação salva em: ${arquivoTexto}\n`);

// Resumo por categoria
console.log('=== Resumo por Categoria ===');
Object.entries(porCategoria).forEach(([cat, itens]) => {
  const comImagem = itens.filter(p => p.imagem).length;
  console.log(`${cat}: ${itens.length} produtos (${comImagem} com imagem)`);
});

// Gerar também estatísticas
const comImagem = produtos.filter(p => p.imagem).length;
const semImagem = produtos.filter(p => !p.imagem).length;

console.log(`\n=== Estatísticas ===`);
console.log(`Total: ${produtos.length}`);
console.log(`Com imagem: ${comImagem}`);
console.log(`Sem imagem: ${semImagem}`);
