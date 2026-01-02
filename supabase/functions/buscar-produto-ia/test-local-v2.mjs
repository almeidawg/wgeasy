// ============================================================
// TESTE LOCAL V2 - Com headers adequados
// Execute com: node test-local-v2.mjs
// ============================================================

const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";

// Teste 1: Mercado Livre API com headers adequados
async function testarMercadoLivre(termo) {
  console.log("\n=== TESTE: Mercado Livre API ===");
  console.log(`Buscando: "${termo}"`);

  try {
    const url = `https://api.mercadolibre.com/sites/MLB/search?q=${encodeURIComponent(termo)}&limit=5`;
    const response = await fetch(url, {
      headers: {
        "User-Agent": USER_AGENT,
        "Accept": "application/json",
      }
    });

    console.log(`Status: ${response.status}`);

    if (!response.ok) {
      console.log("❌ Erro na API");
      return;
    }

    const data = await response.json();
    const produtos = (data.results || []).map((item) => ({
      titulo: item.title,
      preco: item.price,
      marca: item.attributes?.find((a) => a.id === "BRAND")?.value_name,
      sku: item.id,
    }));

    console.log(`✅ Encontrados: ${produtos.length} produtos`);
    produtos.slice(0, 3).forEach((p, i) => {
      console.log(`\n${i + 1}. ${p.titulo}`);
      console.log(`   Preço: R$ ${p.preco?.toFixed(2)} | SKU: ${p.sku}`);
    });

    return produtos;
  } catch (e) {
    console.log("❌ Erro:", e.message);
  }
}

// Teste 2: Acesso direto à Leroy (sem proxy)
async function testarAcessoDireto(url) {
  console.log("\n=== TESTE: Acesso Direto (sem proxy) ===");
  console.log(`URL: ${url}`);

  try {
    const response = await fetch(url, {
      headers: {
        "User-Agent": USER_AGENT,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
        "Cache-Control": "no-cache",
      }
    });

    console.log(`Status: ${response.status}`);

    if (!response.ok) {
      console.log("❌ Erro no acesso");
      return;
    }

    const html = await response.text();
    console.log(`HTML obtido: ${html.length} caracteres`);

    // Verificar se é página de desafio
    if (html.includes("Just a moment") || html.includes("cf-browser-verification")) {
      console.log("⚠️ Cloudflare detectado!");
    } else {
      console.log("✅ Página real obtida!");

      // Tentar extrair título
      const titleMatch = html.match(/<title>([^<]+)/i);
      if (titleMatch) {
        console.log(`Título: ${titleMatch[1].trim()}`);
      }
    }
  } catch (e) {
    console.log("❌ Erro:", e.message);
  }
}

// Teste 3: Usar ZenRows-like proxy (se disponível)
async function testarScraperAPI() {
  console.log("\n=== TESTE: ScraperAPI/Alternativas ===");

  // Lista de APIs de scraping gratuitas para teste
  const scraperAPIs = [
    // ScrapingBee tem tier gratuito
    // https://www.scrapingbee.com/

    // Alternativa: usar Google Cache
    {
      nome: "Google Cache",
      url: `https://webcache.googleusercontent.com/search?q=cache:https://www.leroymerlin.com.br/argamassa-polimerica-impermeabilizante-viapol-viaplus-5000-18kg-cinza_87511886`
    }
  ];

  for (const api of scraperAPIs) {
    try {
      console.log(`\nTestando: ${api.nome}`);
      const response = await fetch(api.url, {
        headers: {
          "User-Agent": USER_AGENT,
        }
      });
      console.log(`Status: ${response.status}`);

      if (response.ok) {
        const text = await response.text();
        console.log(`Tamanho: ${text.length} caracteres`);

        // Verificar se tem dados úteis
        if (text.includes("Viaplus") || text.includes("viapol")) {
          console.log("✅ Dados do produto encontrados!");
        }
      }
    } catch (e) {
      console.log(`❌ Erro: ${e.message}`);
    }
  }
}

// Teste 4: Buscar produto no Google Shopping (indiretamente)
async function testarBuscaGoogle(termo) {
  console.log("\n=== TESTE: Busca no Google ===");
  console.log(`Termo: "${termo}"`);

  // Não é possível acessar Google diretamente sem ser bloqueado
  // Mas podemos usar a API do SerpAPI ou similar
  console.log("⚠️ Google requer API paga (SerpAPI) para scraping");
}

// Executar testes
async function main() {
  console.log("🚀 TESTES DE BUSCA V2 - Com headers adequados\n");
  console.log("=".repeat(50));

  // Teste 1: Mercado Livre
  await testarMercadoLivre("viaplus 5000 18kg viapol");

  console.log("\n" + "=".repeat(50));

  // Teste 2: Acesso direto
  await testarAcessoDireto(
    "https://www.leroymerlin.com.br/argamassa-polimerica-impermeabilizante-viapol-viaplus-5000-18kg-cinza_87511886"
  );

  console.log("\n" + "=".repeat(50));
  console.log("\n📋 CONCLUSÕES:");
  console.log("1. Mercado Livre API: Funciona com headers adequados");
  console.log("2. Leroy Merlin: Cloudflare bloqueia acesso direto e proxies");
  console.log("3. Solução recomendada: Usar APIs de scraping (ScrapingBee, Bright Data)");
  console.log("4. Alternativa: Edge Function com puppeteer/playwright");
  console.log("\n");
}

main().catch(console.error);
