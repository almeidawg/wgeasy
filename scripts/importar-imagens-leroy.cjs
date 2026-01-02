/**
 * Script para importar imagens dos produtos da Leroy Merlin
 * Busca no site da Leroy e extrai URLs das imagens
 */

const fs = require('fs');
const path = require('path');

// Caminho dos arquivos
const PRODUTOS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos.json');
const PRODUTOS_COM_IMAGENS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos-com-imagens.json');

// Função para criar slug de busca a partir da descrição
function criarSlugBusca(descricao) {
  return descricao
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '') // Remove acentos
    .replace(/[^\w\s-]/g, '') // Remove caracteres especiais
    .replace(/\s+/g, '-') // Substitui espaços por hífens
    .replace(/-+/g, '-') // Remove hífens duplicados
    .trim();
}

// Função para extrair palavras-chave principais
function extrairPalavrasChave(descricao) {
  // Remove palavras comuns e mantém as principais
  const palavrasIgnorar = ['com', 'para', 'de', 'do', 'da', 'dos', 'das', 'em', 'ou', 'e', 'a', 'o', 'um', 'uma', 'por'];

  return descricao
    .split(/\s+/)
    .filter(p => p.length > 2 && !palavrasIgnorar.includes(p.toLowerCase()))
    .slice(0, 5) // Pega as 5 primeiras palavras significativas
    .join(' ');
}

// Função principal
async function main() {
  console.log('=== Importador de Imagens Leroy Merlin ===\n');

  // Carrega os produtos
  const produtos = JSON.parse(fs.readFileSync(PRODUTOS_JSON, 'utf-8'));
  console.log(`Total de produtos: ${produtos.length}\n`);

  // Adiciona campo de busca para cada produto
  const produtosComBusca = produtos.map((produto, index) => {
    const palavrasChave = extrairPalavrasChave(produto.descricao);
    const urlBusca = `https://www.leroymerlin.com.br/search?term=${encodeURIComponent(palavrasChave)}`;

    return {
      ...produto,
      id: index + 1,
      palavrasChave,
      urlBusca,
      imagem: null // Será preenchido depois
    };
  });

  // Salva arquivo intermediário com URLs de busca
  fs.writeFileSync(
    path.join(__dirname, '../frontend/database/leroy-produtos-busca.json'),
    JSON.stringify(produtosComBusca, null, 2),
    'utf-8'
  );

  console.log('Arquivo leroy-produtos-busca.json criado com URLs de busca!\n');
  console.log('Para buscar as imagens, execute cada URL manualmente ou use o browser automation.\n');

  // Exemplo de como buscar manualmente
  console.log('Exemplo de URLs de busca:');
  produtosComBusca.slice(0, 5).forEach(p => {
    console.log(`- [${p.id}] ${p.descricao.substring(0, 50)}...`);
    console.log(`  Busca: ${p.urlBusca}\n`);
  });

  console.log('\n=== Instruções ===');
  console.log('1. Acesse cada URL de busca no navegador');
  console.log('2. Encontre o produto correto');
  console.log('3. Copie a URL da imagem do CDN da Leroy');
  console.log('4. Atualize o arquivo leroy-produtos-com-imagens.json');
}

main().catch(console.error);
