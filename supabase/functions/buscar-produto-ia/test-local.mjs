// ============================================================
// TESTE LOCAL - Buscar Produto (Node.js)
// Execute com: node test-local.mjs
// ============================================================

// Teste 1: Buscar via Mercado Livre API (funciona sem OpenAI)
async function testarMercadoLivre(termo) {
  console.log("\n=== TESTE: Mercado Livre API ===");
  console.log(`Buscando: "${termo}"`);

  try {
    const url = `https://api.mercadolibre.com/sites/MLB/search?q=${encodeURIComponent(termo)}&limit=5`;
    const response = await fetch(url);

    if (!response.ok) {
      console.log("❌ Erro na API do Mercado Livre:", response.status);
      return;
    }

    const data = await response.json();
    const produtos = (data.results || []).map((item) => ({
      titulo: item.title,
      preco: item.price,
      marca: item.attributes?.find((a) => a.id === "BRAND")?.value_name,
      sku: item.id,
      imagem_url: item.thumbnail?.replace("http:", "https:"),
      url_origem: item.permalink,
    }));

    console.log(`✅ Encontrados: ${produtos.length} produtos`);
    produtos.forEach((p, i) => {
      console.log(`\n${i + 1}. ${p.titulo}`);
      console.log(`   Preço: R$ ${p.preco?.toFixed(2)}`);
      console.log(`   Marca: ${p.marca || "N/A"}`);
      console.log(`   SKU: ${p.sku}`);
    });

    return produtos;
  } catch (e) {
    console.log("❌ Erro:", e.message);
  }
}

// Teste 2: Extrair produto de URL via proxy CORS
async function testarExtrairURL(url) {
  console.log("\n=== TESTE: Extrair de URL via Proxy ===");
  console.log(`URL: ${url}`);

  const proxies = [
    `https://api.allorigins.win/raw?url=${encodeURIComponent(url)}`,
    `https://corsproxy.io/?${encodeURIComponent(url)}`,
  ];

  for (const proxyUrl of proxies) {
    try {
      const proxyName = proxyUrl.includes("allorigins") ? "allorigins" : "corsproxy";
      console.log(`\nTentando proxy: ${proxyName}...`);

      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 15000);

      const response = await fetch(proxyUrl, {
        headers: { Accept: "text/html" },
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        console.log(`❌ Proxy retornou: ${response.status}`);
        continue;
      }

      const html = await response.text();
      console.log(`✅ HTML obtido: ${html.length} caracteres`);

      // Extrair dados
      const produto = extrairProdutoDoHTML(html, url);
      console.log("\n📦 Produto extraído:");
      console.log(`   Título: ${produto.titulo}`);
      console.log(`   Preço: R$ ${produto.preco?.toFixed(2)}`);
      console.log(`   Marca: ${produto.marca || "N/A"}`);
      console.log(`   SKU: ${produto.sku || "N/A"}`);
      console.log(`   Imagem: ${produto.imagem_url ? "✅ " + produto.imagem_url.substring(0, 60) + "..." : "❌"}`);

      return produto;
    } catch (e) {
      if (e.name === "AbortError") {
        console.log(`❌ Timeout após 15s`);
      } else {
        console.log(`❌ Erro: ${e.message}`);
      }
    }
  }

  console.log("❌ Todos os proxies falharam");
}

// Função de extração do HTML
function extrairProdutoDoHTML(html, url) {
  const hostname = new URL(url).hostname.toLowerCase();
  let titulo = "";
  let preco = 0;
  let imagem_url;
  let sku;
  let marca;

  // JSON-LD
  const jsonLdRegex = /<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi;
  let match;
  while ((match = jsonLdRegex.exec(html)) !== null) {
    try {
      const jsonData = JSON.parse(match[1]);
      const product = Array.isArray(jsonData)
        ? jsonData.find((item) => item["@type"] === "Product")
        : jsonData["@type"] === "Product"
        ? jsonData
        : null;

      if (product) {
        titulo = product.name || titulo;
        preco = parseFloat(product.offers?.price || product.offers?.[0]?.price) || preco;
        imagem_url = product.image || product.image?.[0] || imagem_url;
        sku = product.sku || product.productID || sku;
        marca = product.brand?.name || product.brand || marca;
      }
    } catch (e) {
      continue;
    }
  }

  // Meta tags Open Graph
  if (!titulo) {
    const ogTitle = html.match(/<meta[^>]*property="og:title"[^>]*content="([^"]*)"/i);
    if (ogTitle) titulo = ogTitle[1];
  }

  if (!preco) {
    const ogPrice = html.match(/<meta[^>]*property="product:price:amount"[^>]*content="([^"]*)"/i);
    if (ogPrice) preco = parseFloat(ogPrice[1]) || 0;
  }

  if (!imagem_url) {
    const ogImage = html.match(/<meta[^>]*property="og:image"[^>]*content="([^"]*)"/i);
    if (ogImage) imagem_url = ogImage[1];
  }

  // Fallback título
  if (!titulo) {
    const titleTag = html.match(/<title>([^<|]+)/i);
    if (titleTag) titulo = titleTag[1].trim().split("|")[0].trim();
  }

  // Fallback preço
  if (!preco) {
    const precoGenerico = html.match(/R\$\s*([0-9.,]+)/i);
    if (precoGenerico) {
      preco = parseFloat(precoGenerico[1].replace(/\./g, "").replace(",", "."));
    }
  }

  return {
    titulo: titulo || `Produto de ${hostname}`,
    preco,
    marca,
    sku,
    imagem_url,
    url_origem: url,
  };
}

// Executar testes
async function main() {
  console.log("🚀 INICIANDO TESTES DE BUSCA DE PRODUTOS\n");
  console.log("=".repeat(50));

  // Teste Mercado Livre
  await testarMercadoLivre("viaplus 5000 18kg");

  console.log("\n" + "=".repeat(50));

  // Teste extração Leroy Merlin - Viaplus
  await testarExtrairURL(
    "https://www.leroymerlin.com.br/argamassa-polimerica-impermeabilizante-viapol-viaplus-5000-18kg-cinza_87511886"
  );

  console.log("\n" + "=".repeat(50));

  // Teste extração Leroy Merlin - Cabo
  await testarExtrairURL(
    "https://www.leroymerlin.com.br/cabo-flexivel-6mm-50m-vermelho-750v-cobrecom_91923146"
  );

  console.log("\n" + "=".repeat(50));
  console.log("✅ TESTES CONCLUÍDOS\n");
}

main().catch(console.error);
