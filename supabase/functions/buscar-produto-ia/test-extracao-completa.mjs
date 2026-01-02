// ============================================================
// TESTE COMPLETO DE EXTRAÇÃO - Leroy Merlin
// Execute com: node test-extracao-completa.mjs
// ============================================================

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";

async function extrairProdutoLeroy(url) {
  console.log("🔍 Extraindo produto da Leroy Merlin...");
  console.log(`URL: ${url}\n`);

  const response = await fetch(url, {
    headers: {
      "User-Agent": USER_AGENT,
      "Accept": "text/html,application/xhtml+xml",
      "Accept-Language": "pt-BR,pt;q=0.9",
    }
  });

  if (!response.ok) {
    console.log(`❌ Erro HTTP: ${response.status}`);
    return null;
  }

  const html = await response.text();
  console.log(`✅ HTML obtido: ${html.length} caracteres\n`);

  // Extrair dados
  let produto = {
    titulo: null,
    preco: null,
    preco_original: null,
    desconto: null,
    marca: null,
    sku: null,
    ean: null,
    imagem_url: null,
    descricao: null,
    especificacoes: {},
    disponibilidade: null,
  };

  // 1. JSON-LD (mais confiável)
  console.log("📦 Extraindo via JSON-LD...");
  const jsonLdRegex = /<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi;
  let match;
  while ((match = jsonLdRegex.exec(html)) !== null) {
    try {
      const jsonData = JSON.parse(match[1]);

      // Pode ser array ou objeto único
      const items = Array.isArray(jsonData) ? jsonData : [jsonData];

      for (const item of items) {
        if (item["@type"] === "Product") {
          produto.titulo = item.name || produto.titulo;
          produto.marca = item.brand?.name || item.brand || produto.marca;
          produto.sku = item.sku || produto.sku;
          produto.descricao = item.description || produto.descricao;

          // Imagem
          if (item.image) {
            produto.imagem_url = Array.isArray(item.image) ? item.image[0] : item.image;
          }

          // Preço
          if (item.offers) {
            const offer = Array.isArray(item.offers) ? item.offers[0] : item.offers;
            produto.preco = parseFloat(offer.price) || produto.preco;
            produto.disponibilidade = offer.availability?.includes("InStock") ? "Em estoque" : "Indisponível";
          }

          // GTIN/EAN
          if (item.gtin13) produto.ean = item.gtin13;
          if (item.gtin) produto.ean = item.gtin;

          console.log("   ✅ Produto encontrado no JSON-LD");
        }
      }
    } catch (e) {
      // Ignorar JSON inválido
    }
  }

  // 2. Meta tags Open Graph (fallback)
  if (!produto.titulo) {
    const ogTitle = html.match(/<meta[^>]*property="og:title"[^>]*content="([^"]*)"/i);
    if (ogTitle) produto.titulo = ogTitle[1];
  }

  if (!produto.imagem_url) {
    const ogImage = html.match(/<meta[^>]*property="og:image"[^>]*content="([^"]*)"/i);
    if (ogImage) produto.imagem_url = ogImage[1];
  }

  // 3. Preço com desconto (buscar no HTML)
  const precoDesconto = html.match(/"price":\s*(\d+\.?\d*)/);
  if (precoDesconto) {
    produto.preco = parseFloat(precoDesconto[1]);
  }

  const precoOriginal = html.match(/"listPrice":\s*(\d+\.?\d*)/);
  if (precoOriginal) {
    produto.preco_original = parseFloat(precoOriginal[1]);
  }

  // Calcular desconto
  if (produto.preco && produto.preco_original && produto.preco_original > produto.preco) {
    produto.desconto = Math.round((1 - produto.preco / produto.preco_original) * 100);
  }

  // 4. SKU da URL
  if (!produto.sku) {
    const skuMatch = url.match(/_(\d+)$/);
    if (skuMatch) produto.sku = skuMatch[1];
  }

  // 5. Especificações técnicas
  console.log("📋 Extraindo especificações...");

  // Tentar extrair do JSON embutido
  const specsJsonMatch = html.match(/"specifications":\s*(\[[\s\S]*?\])/);
  if (specsJsonMatch) {
    try {
      const specs = JSON.parse(specsJsonMatch[1]);
      specs.forEach(spec => {
        if (spec.name && spec.values?.[0]) {
          produto.especificacoes[spec.name] = spec.values[0];
        }
      });
    } catch (e) {}
  }

  // Tentar extrair de tabelas HTML
  const specTableRegex = /<tr[^>]*>\s*<t[hd][^>]*>([^<]+)<\/t[hd]>\s*<t[hd][^>]*>([^<]+)<\/t[hd]>\s*<\/tr>/gi;
  while ((match = specTableRegex.exec(html)) !== null) {
    const key = match[1].trim();
    const value = match[2].trim();
    if (key && value && key.length < 50 && value.length < 200) {
      produto.especificacoes[key] = value;
    }
  }

  // Resultado
  console.log("\n" + "=".repeat(60));
  console.log("📦 PRODUTO EXTRAÍDO:");
  console.log("=".repeat(60));
  console.log(`Título:        ${produto.titulo}`);
  console.log(`Preço:         R$ ${produto.preco?.toFixed(2)}`);
  if (produto.preco_original) {
    console.log(`Preço orig.:   R$ ${produto.preco_original?.toFixed(2)} (${produto.desconto}% OFF)`);
  }
  console.log(`Marca:         ${produto.marca || "N/A"}`);
  console.log(`SKU:           ${produto.sku || "N/A"}`);
  console.log(`EAN:           ${produto.ean || "N/A"}`);
  console.log(`Disponível:    ${produto.disponibilidade || "N/A"}`);
  console.log(`Imagem:        ${produto.imagem_url ? "✅ " + produto.imagem_url.substring(0, 50) + "..." : "❌"}`);

  if (Object.keys(produto.especificacoes).length > 0) {
    console.log("\n📋 Especificações:");
    Object.entries(produto.especificacoes).slice(0, 10).forEach(([k, v]) => {
      console.log(`   ${k}: ${v}`);
    });
  }

  console.log("=".repeat(60));

  return produto;
}

// Executar testes
async function main() {
  console.log("🚀 TESTE DE EXTRAÇÃO COMPLETA\n");

  // Teste 1: Viaplus 5000
  await extrairProdutoLeroy(
    "https://www.leroymerlin.com.br/argamassa-polimerica-impermeabilizante-viapol-viaplus-5000-18kg-cinza_87511886"
  );

  console.log("\n\n");

  // Teste 2: Cabo elétrico
  await extrairProdutoLeroy(
    "https://www.leroymerlin.com.br/cabo-flexivel-6mm-50m-vermelho-750v-cobrecom_91923146"
  );

  console.log("\n✅ TESTES CONCLUÍDOS");
}

main().catch(console.error);
