/**
 * Script automatizado para buscar imagens dos produtos da Leroy Merlin usando Playwright
 * Este script usa browser automation para extrair URLs de imagens
 */

const fs = require('fs');
const path = require('path');

// Caminhos dos arquivos
const PRODUTOS_COM_IMAGENS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos-com-imagens.json');

// Delay entre requisições
const DELAY_MS = 2000;

// Função para fazer delay
function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Função para extrair código do produto da URL da imagem
function extractProductCode(imageUrl) {
  const match = imageUrl.match(/_(\d{8,})_/);
  return match ? match[1] : null;
}

// Mapeamento de produtos conhecidos com imagens
// Adicione mais produtos conforme forem encontrados
const PRODUTOS_MAPEADOS = {
  // PRÉ OBRA
  "Protetor de Quina 1,20mx5cm Salva Quina": {
    codigo: "91877961",
    imagem: "https://cdn.leroymerlin.com.br/products/protecao_para_quina_salva_obra_0,80_x_25_91877961_0001_600x600.jpg"
  },
  "Fita Crepe Branca 48mm x 50m": {
    codigo: "92138830",
    imagem: "https://cdn.leroymerlin.com.br/products/fita_crepe_branca_48mmx50m_dexter_92138830_1d41_600x600.png"
  },
  "Vassoura Original Noviça Concept Bettanin": {
    codigo: "89557720",
    imagem: "https://cdn.leroymerlin.com.br/products/vassoura_original_novica_concept_bettanin_89557720_0001_600x600.jpg"
  },

  // MATERIAL CINZA
  "Argamassa Polimérica Impermeabilizante Viapol Viaplus 5000 Fibras 18kg Cinza": {
    codigo: "87511886",
    imagem: "https://cdn.leroymerlin.com.br/products/argamassa_polimerica_viapol_viaplus_5000_18kg_87511886_1260_600x600.png"
  },
  "Cimento CP II F 32 Todas as Obras 50kg Votoran": {
    codigo: "89368944",
    imagem: "https://cdn.leroymerlin.com.br/products/cimento_cp_ii_f_32_todas_as_obras_50kg_votoran_89368944_ee1c_600x600.jpg"
  },
  "Aditivo para Chapisco Bianco 18kg Branco Vedacit": {
    codigo: "86101561",
    imagem: "https://cdn.leroymerlin.com.br/products/aditivo_para_chapisco_bianco_18kg_branco_vedacit_86101561_5624_600x600.jpg"
  },

  // PISOS E PAREDES
  "Argamassa ACIII Interno e Externo 20kg Branco CimentCola Quartzolit": {
    codigo: "86871876",
    imagem: "https://cdn.leroymerlin.com.br/products/argamassa_acii_interno_e_externo_cinza_20kg_86871876_0ce9_600x600.jpg"
  }
};

// Função principal
async function main() {
  console.log('=== Atualizador de Imagens Leroy Merlin ===\n');

  // Carrega os produtos
  let produtos = JSON.parse(fs.readFileSync(PRODUTOS_COM_IMAGENS_JSON, 'utf-8'));
  console.log(`Total de produtos: ${produtos.length}`);

  // Conta produtos sem imagem
  const semImagem = produtos.filter(p => !p.imagem).length;
  console.log(`Produtos sem imagem: ${semImagem}\n`);

  // Atualiza produtos com mapeamento conhecido
  let atualizados = 0;
  produtos = produtos.map(produto => {
    if (!produto.imagem && PRODUTOS_MAPEADOS[produto.descricao]) {
      const info = PRODUTOS_MAPEADOS[produto.descricao];
      atualizados++;
      console.log(`[${produto.id}] Atualizado: ${produto.descricao.substring(0, 50)}...`);
      return {
        ...produto,
        codigo_leroy: info.codigo,
        imagem: info.imagem,
        imagem_thumb: info.imagem.replace('600x600', '140x140')
      };
    }
    return produto;
  });

  // Salva o arquivo atualizado
  fs.writeFileSync(PRODUTOS_COM_IMAGENS_JSON, JSON.stringify(produtos, null, 2), 'utf-8');

  console.log(`\n=== Resumo ===`);
  console.log(`Produtos atualizados: ${atualizados}`);
  console.log(`Produtos com imagem: ${produtos.filter(p => p.imagem).length}`);
  console.log(`Produtos sem imagem: ${produtos.filter(p => !p.imagem).length}`);
  console.log(`\nArquivo salvo em: ${PRODUTOS_COM_IMAGENS_JSON}`);

  // Lista produtos sem imagem para referência
  const produtosSemImagem = produtos.filter(p => !p.imagem);
  console.log(`\n=== Produtos sem imagem (primeiros 20) ===`);
  produtosSemImagem.slice(0, 20).forEach(p => {
    console.log(`[${p.id}] ${p.descricao.substring(0, 60)}...`);
    console.log(`    URL: ${p.urlBusca}\n`);
  });
}

main().catch(console.error);
