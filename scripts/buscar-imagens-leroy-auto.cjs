/**
 * Script automatizado para buscar imagens dos produtos da Leroy Merlin
 * Usa web scraping para encontrar URLs de imagens de cada produto
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// Caminhos dos arquivos
const PRODUTOS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos.json');
const PRODUTOS_COM_IMAGENS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos-com-imagens.json');

// Delay entre requisições para não sobrecarregar o servidor
const DELAY_MS = 2000;

// Função para fazer delay
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Função para fazer request HTTPS
function fetchUrl(url) {
  return new Promise((resolve, reject) => {
    const options = {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7'
      }
    };

    https.get(url, options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve({ status: res.statusCode, data }));
    }).on('error', reject);
  });
}

// Função para extrair URL da imagem do HTML
function extractImageUrl(html, productCode) {
  // Padrões de URL de imagem da Leroy Merlin
  const patterns = [
    /https:\/\/cdn\.leroymerlin\.com\.br\/products\/[^"'\s]+_\d+_\d+_600x600\.(jpg|png|webp)/gi,
    /https:\/\/cdn\.leroymerlin\.com\.br\/products\/[^"'\s]+_\d+_\d+_\d+x\d+\.(jpg|png|webp)/gi
  ];

  for (const pattern of patterns) {
    const matches = html.match(pattern);
    if (matches && matches.length > 0) {
      // Pegar a primeira imagem 600x600 ou a maior disponível
      const image600 = matches.find(m => m.includes('600x600'));
      return image600 || matches[0];
    }
  }

  return null;
}

// Função para criar URL de busca
function createSearchUrl(descricao) {
  const palavras = descricao
    .split(/\s+/)
    .filter(p => p.length > 2)
    .slice(0, 5)
    .join(' ');

  return `https://www.leroymerlin.com.br/search?term=${encodeURIComponent(palavras)}`;
}

// Função para gerar URL de imagem baseada no código do produto
function generateImageUrl(productCode, productName) {
  // Padrão da Leroy: nome_do_produto_codigo_0001_600x600.jpg
  const slug = productName
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^\w\s]/g, '')
    .replace(/\s+/g, '_')
    .substring(0, 50);

  return `https://cdn.leroymerlin.com.br/products/${slug}_${productCode}_0001_600x600.jpg`;
}

// Mapeamento manual de produtos conhecidos (baseado nos testes)
const IMAGENS_CONHECIDAS = {
  "Protetor de Quina 1,20mx5cm Salva Quina": {
    codigo: "91877961",
    imagem: "https://cdn.leroymerlin.com.br/products/protecao_para_quina_salva_obra_0,80_x_25_91877961_0001_600x600.jpg"
  },
  "Argamassa Polimérica Impermeabilizante Viapol Viaplus 5000 Fibras 18kg Cinza": {
    codigo: "87511886",
    imagem: "https://cdn.leroymerlin.com.br/products/argamassa_polimerica_viapol_viaplus_5000_18kg_87511886_1260_600x600.png"
  }
};

// Função principal
async function main() {
  console.log('=== Importador de Imagens Leroy Merlin ===\n');

  // Carrega os produtos
  const produtos = JSON.parse(fs.readFileSync(PRODUTOS_JSON, 'utf-8'));
  console.log(`Total de produtos: ${produtos.length}\n`);

  // Carrega produtos já processados se existir
  let produtosComImagens = [];
  if (fs.existsSync(PRODUTOS_COM_IMAGENS_JSON)) {
    produtosComImagens = JSON.parse(fs.readFileSync(PRODUTOS_COM_IMAGENS_JSON, 'utf-8'));
    console.log(`Produtos já processados: ${produtosComImagens.length}\n`);
  }

  // Cria mapa de produtos já processados
  const processados = new Map(produtosComImagens.map(p => [p.descricao, p]));

  // Processa cada produto
  for (let i = 0; i < produtos.length; i++) {
    const produto = produtos[i];

    // Verifica se já foi processado
    if (processados.has(produto.descricao) && processados.get(produto.descricao).imagem) {
      console.log(`[${i + 1}/${produtos.length}] ✓ Já processado: ${produto.descricao.substring(0, 50)}...`);
      continue;
    }

    console.log(`[${i + 1}/${produtos.length}] Processando: ${produto.descricao.substring(0, 50)}...`);

    // Verifica se temos mapeamento manual
    if (IMAGENS_CONHECIDAS[produto.descricao]) {
      const info = IMAGENS_CONHECIDAS[produto.descricao];
      produtosComImagens.push({
        ...produto,
        id: i + 1,
        codigo_leroy: info.codigo,
        imagem: info.imagem,
        imagem_thumb: info.imagem.replace('600x600', '140x140')
      });

      // Salva progresso
      fs.writeFileSync(PRODUTOS_COM_IMAGENS_JSON, JSON.stringify(produtosComImagens, null, 2), 'utf-8');
      console.log(`  ✓ Imagem encontrada (mapeamento manual)`);
      continue;
    }

    // Para produtos sem mapeamento, adiciona sem imagem por enquanto
    produtosComImagens.push({
      ...produto,
      id: i + 1,
      codigo_leroy: null,
      imagem: null,
      imagem_thumb: null,
      urlBusca: createSearchUrl(produto.descricao)
    });

    // Salva progresso
    fs.writeFileSync(PRODUTOS_COM_IMAGENS_JSON, JSON.stringify(produtosComImagens, null, 2), 'utf-8');

    // Delay entre produtos
    if (i < produtos.length - 1) {
      await delay(100);
    }
  }

  // Estatísticas finais
  const comImagem = produtosComImagens.filter(p => p.imagem).length;
  const semImagem = produtosComImagens.filter(p => !p.imagem).length;

  console.log('\n=== Resumo ===');
  console.log(`Total de produtos: ${produtosComImagens.length}`);
  console.log(`Com imagem: ${comImagem}`);
  console.log(`Sem imagem: ${semImagem}`);
  console.log(`\nArquivo salvo em: ${PRODUTOS_COM_IMAGENS_JSON}`);

  // Gera arquivo com URLs de busca para produtos sem imagem
  const produtosSemImagem = produtosComImagens.filter(p => !p.imagem);
  if (produtosSemImagem.length > 0) {
    const urlsParaBuscar = produtosSemImagem.map(p => ({
      id: p.id,
      descricao: p.descricao,
      urlBusca: p.urlBusca
    }));

    const urlsPath = path.join(__dirname, '../frontend/database/leroy-urls-pendentes.json');
    fs.writeFileSync(urlsPath, JSON.stringify(urlsParaBuscar, null, 2), 'utf-8');
    console.log(`\nURLs para busca manual salvas em: ${urlsPath}`);
  }
}

main().catch(console.error);
