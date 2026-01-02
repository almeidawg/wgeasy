// ============================================================
// TESTE LOCAL - Buscar Produto
// Execute com: deno run --allow-net test-local.ts
// ============================================================

interface ProdutoEncontrado {
  titulo: string;
  preco: number;
  marca?: string;
  sku?: string;
  imagem_url?: string;
  url_origem?: string;
}

// Teste 1: Buscar via Mercado Livre API (funciona sem OpenAI)
async function testarMercadoLivre(termo: string) {
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
    const produtos = (data.results || []).map((item: any) => ({
      titulo: item.title,
      preco: item.price,
      marca: item.attributes?.find((a: any) => a.id === "BRAND")?.value_name,
      sku: item.id,
      imagem_url: item.thumbnail?.replace("http:", "https:"),
      url_origem: item.permalink,
    }));

    console.log(`✅ Encontrados: ${produtos.length} produtos`);
    produtos.forEach((p: ProdutoEncontrado, i: number) => {
      console.log(`\n${i + 1}. ${p.titulo}`);
      console.log(`   Preço: R$ ${p.preco?.toFixed(2)}`);
      console.log(`   Marca: ${p.marca || "N/A"}`);
      console.log(`   SKU: ${p.sku}`);
    });

    return produtos;
  } catch (e) {
    console.log("❌ Erro:", e);
  }
}

// Teste 2: Extrair produto de URL via proxy CORS
async function testarExtrairURL(url: string) {
  console.log("\n=== TESTE: Extrair de URL via Proxy ===");
  console.log(`URL: ${url}`);

  const proxies = [
    `https://api.allorigins.win/raw?url=${encodeURIComponent(url)}`,
    `https://corsproxy.io/?${encodeURIComponent(url)}`,
  ];

  for (const proxyUrl of proxies) {
    try {
      console.log(`\nTentando proxy: ${proxyUrl.split("?")[0]}...`);

      const response = await fetch(proxyUrl, {
        headers: { Accept: "text/html" },
      });

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
      console.log(`   Imagem: ${produto.imagem_url ? "✅" : "❌"}`);

      return produto;
    } catch (e) {
      console.log(`❌ Erro: ${e}`);
    }
  }

  console.log("❌ Todos os proxies falharam");
}

// Função de extração do HTML
function extrairProdutoDoHTML(html: string, url: string): ProdutoEncontrado {
  const hostname = new URL(url).hostname.toLowerCase();
  let titulo = "";
  let preco = 0;
  let imagem_url: string | undefined;
  let sku: string | undefined;
  let marca: string | undefined;

  // JSON-LD
  const jsonLdMatches = html.matchAll(
    /<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi
  );
  for (const match of jsonLdMatches) {
    try {
      const jsonData = JSON.parse(match[1]);
      const product = Array.isArray(jsonData)
        ? jsonData.find((item) => item["@type"] === "Product")
        : jsonData["@type"] === "Product"
        ? jsonData
        : null;

      if (product) {
        titulo = product.name || titulo;
        preco =
          parseFloat(product.offers?.price || product.offers?.[0]?.price) ||
          preco;
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
    const ogTitle = html.match(
      /<meta[^>]*property="og:title"[^>]*content="([^"]*)"/i
    );
    if (ogTitle) titulo = ogTitle[1];
  }

  if (!preco) {
    const ogPrice = html.match(
      /<meta[^>]*property="product:price:amount"[^>]*content="([^"]*)"/i
    );
    if (ogPrice) preco = parseFloat(ogPrice[1]) || 0;
  }

  if (!imagem_url) {
    const ogImage = html.match(
      /<meta[^>]*property="og:image"[^>]*content="([^"]*)"/i
    );
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
      preco = parseFloat(
        precoGenerico[1].replace(/\./g, "").replace(",", ".")
      );
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
  console.log("=" .repeat(50));

  // Teste Mercado Livre
  await testarMercadoLivre("viaplus 5000 18kg");

  console.log("\n" + "=".repeat(50));

  // Teste extração Leroy Merlin
  await testarExtrairURL(
    "https://www.leroymerlin.com.br/argamassa-polimerica-impermeabilizante-viapol-viaplus-5000-18kg-cinza_87511886"
  );

  console.log("\n" + "=".repeat(50));

  // Teste extração Leroy Merlin - Cabo
  await testarExtrairURL(
    "https://www.leroymerlin.com.br/cabo-flexivel-6mm-50m-vermelho-750v-cobrecom_91923146"
  );

  console.log("\n✅ TESTES CONCLUÍDOS");
}

main();
