// supabase/functions/buscar-produto-ia/index.ts
// Edge Function para buscar produtos usando OpenAI (evita CORS)

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  try {
    const { termoBusca, tipo } = await req.json();

    const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

    if (!OPENAI_API_KEY) {
      return new Response(
        JSON.stringify({ error: 'Chave OpenAI não configurada no servidor' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Tipo 1: Buscar produtos na internet
    if (tipo === 'buscar') {
      const prompt = `Você é um assistente especializado em buscar produtos de construção civil em lojas brasileiras.

Produto buscado: "${termoBusca}"

INSTRUÇÕES:
1. Retorne até 5 produtos relevantes de lojas brasileiras (Leroy Merlin, Telha Norte, C&C, Mercado Livre, Amazon Brasil, Magazine Luiza)
2. Use preços médios de mercado atualizados para 2024/2025
3. Forneça URLs reais de produtos quando possível
4. Para imagens, use URLs diretas de CDNs conhecidos quando disponíveis

Retorne EXATAMENTE neste formato JSON:
[
  {
    "titulo": "Nome completo do produto com marca e especificações",
    "preco": 299.90,
    "marca": "Nome da marca",
    "categoria": "Categoria do produto (ex: Pintura, Hidráulica, Elétrica)",
    "descricao": "Descrição curta do produto",
    "url_origem": "https://www.leroymerlin.com.br/...",
    "imagem_url": "https://cdn.leroymerlin.com.br/products/..."
  }
]

IMPORTANTE:
- Preços devem ser números (sem R$ ou formatação)
- URLs devem ser válidas e começar com https://
- Se não souber a imagem exata, omita o campo imagem_url
- Responda APENAS com o array JSON, sem explicações`;

      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${OPENAI_API_KEY}`,
        },
        body: JSON.stringify({
          model: 'gpt-4o',
          messages: [
            {
              role: 'system',
              content: 'Você é um assistente de busca de produtos de construção civil. Sempre responda em JSON válido. Use preços realistas do mercado brasileiro.'
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.2,
          max_tokens: 2000,
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('OpenAI Error:', errorText);
        return new Response(
          JSON.stringify({ error: 'Falha na busca com IA', details: errorText }),
          { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const data = await response.json();
      const content = data.choices?.[0]?.message?.content || '[]';

      const jsonMatch = content.match(/\[[\s\S]*\]/);
      if (!jsonMatch) {
        return new Response(
          JSON.stringify({ error: 'Resposta inválida da IA', produtos: [] }),
          { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const produtos = JSON.parse(jsonMatch[0]);

      return new Response(
        JSON.stringify({ produtos }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Tipo 2: Extrair dados de URL
    if (tipo === 'extrair') {
      const url = termoBusca;
      const hostname = new URL(url).hostname.toLowerCase();
      const siteName = getSiteName(hostname);

      const prompt = `Você é um assistente que extrai informações de produtos de e-commerce.

Analise esta URL de produto: ${url}

Site: ${siteName}

Por favor, acesse a URL e extraia as seguintes informações do produto em formato JSON:
{
  "titulo": "nome completo do produto",
  "preco": número (apenas o valor, sem R$),
  "marca": "marca do produto se disponível",
  "categoria": "categoria do produto",
  "descricao": "descrição curta do produto",
  "sku": "código/SKU do produto se disponível",
  "avaliacao": número de 0 a 5 (nota média se disponível),
  "total_avaliacoes": número total de avaliações
}

Responda APENAS com o JSON, sem explicações adicionais.`;

      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${OPENAI_API_KEY}`,
        },
        body: JSON.stringify({
          model: 'gpt-4o',
          messages: [
            {
              role: 'system',
              content: 'Você é um assistente especializado em extrair dados de produtos de sites de e-commerce. Sempre responda em JSON válido.'
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.1,
          max_tokens: 1000,
        }),
      });

      if (!response.ok) {
        return new Response(
          JSON.stringify({ error: 'Falha na extração com IA' }),
          { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const data = await response.json();
      const content = data.choices?.[0]?.message?.content || '{}';

      const jsonMatch = content.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        return new Response(
          JSON.stringify({ error: 'Resposta inválida da IA', produto: null }),
          { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const produto = JSON.parse(jsonMatch[0]);
      produto.url_origem = url;

      return new Response(
        JSON.stringify({ produto }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Tipo 3: Buscar imagem de um produto
    if (tipo === 'buscar_imagem') {
      const { nome, url_referencia, fabricante } = JSON.parse(termoBusca);

      const prompt = `Você é um assistente que encontra URLs de imagens de produtos.

Preciso da URL de imagem para este produto:
- Nome: ${nome}
- Fabricante: ${fabricante || 'Não especificado'}
${url_referencia ? `- URL de referência: ${url_referencia}` : ''}

INSTRUÇÕES:
1. Busque a URL da imagem principal deste produto
2. Priorize CDNs de lojas brasileiras conhecidas (Leroy Merlin, Amazon, Mercado Livre, etc.)
3. A URL deve ser direta para a imagem (terminar em .jpg, .png, .webp ou ser de CDN conhecido)
4. Se encontrar a imagem na URL de referência, use essa
5. Se não encontrar imagem específica, retorne null

Retorne APENAS neste formato JSON:
{
  "imagem_url": "https://cdn.exemplo.com/produto.jpg",
  "fonte": "Nome da loja de onde veio a imagem"
}

Se não encontrar imagem válida, retorne:
{
  "imagem_url": null,
  "fonte": null
}

Responda APENAS com o JSON, sem explicações.`;

      const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${OPENAI_API_KEY}`,
        },
        body: JSON.stringify({
          model: 'gpt-4o',
          messages: [
            {
              role: 'system',
              content: 'Você é um assistente especializado em encontrar imagens de produtos. Use web search para encontrar URLs de imagens válidas. Sempre responda em JSON válido.'
            },
            {
              role: 'user',
              content: prompt
            }
          ],
          temperature: 0.1,
          max_tokens: 500,
        }),
      });

      if (!response.ok) {
        return new Response(
          JSON.stringify({ error: 'Falha na busca de imagem' }),
          { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const data = await response.json();
      const content = data.choices?.[0]?.message?.content || '{}';

      const jsonMatch = content.match(/\{[\s\S]*\}/);
      if (!jsonMatch) {
        return new Response(
          JSON.stringify({ imagem_url: null, fonte: null }),
          { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const resultado = JSON.parse(jsonMatch[0]);

      return new Response(
        JSON.stringify(resultado),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Tipo 4: Buscar imagens em lote usando scraping da URL de referência
    if (tipo === 'extrair_imagem_url') {
      const url = termoBusca;

      // Tentar extrair imagem diretamente da página via proxy
      try {
        const proxyUrl = `https://api.allorigins.win/raw?url=${encodeURIComponent(url)}`;
        const pageResponse = await fetch(proxyUrl, {
          headers: { 'Accept': 'text/html' },
        });

        if (pageResponse.ok) {
          const html = await pageResponse.text();
          const imagemUrl = extrairImagemDoHTML(html, url);

          if (imagemUrl) {
            return new Response(
              JSON.stringify({ imagem_url: imagemUrl, fonte: 'scraping' }),
              { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
            );
          }
        }
      } catch (e) {
        console.log('Scraping falhou:', e);
      }

      return new Response(
        JSON.stringify({ imagem_url: null, fonte: null }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Tipo 5: Buscar produto na Leroy Merlin por termo de busca
    if (tipo === 'buscar_leroy') {
      const termoBuscaLeroy = encodeURIComponent(termoBusca);
      const urlBusca = `https://www.leroymerlin.com.br/busca?term=${termoBuscaLeroy}`;

      try {
        // Tentar buscar na pagina de resultados da Leroy
        const proxyUrl = `https://api.allorigins.win/raw?url=${encodeURIComponent(urlBusca)}`;
        const pageResponse = await fetch(proxyUrl, {
          headers: {
            'Accept': 'text/html',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
          },
        });

        if (pageResponse.ok) {
          const html = await pageResponse.text();

          // Extrair dados do primeiro produto dos resultados
          const produtos = extrairProdutosLeroyDaLista(html);

          if (produtos.length > 0) {
            return new Response(
              JSON.stringify({ produtos, fonte: 'leroy_scraping' }),
              { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
            );
          }
        }
      } catch (e) {
        console.log('Busca Leroy falhou:', e);
      }

      // Fallback para IA
      return new Response(
        JSON.stringify({ produtos: [], fonte: null }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({ error: 'Tipo de operação inválido' }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (err) {
    console.error('Edge Function Error:', err);
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});

function getSiteName(hostname: string): string {
  if (hostname.includes('leroymerlin')) return 'Leroy Merlin';
  if (hostname.includes('amazon')) return 'Amazon';
  if (hostname.includes('mercadolivre') || hostname.includes('mercadolibre')) return 'Mercado Livre';
  if (hostname.includes('magazineluiza') || hostname.includes('magalu')) return 'Magazine Luiza';
  if (hostname.includes('casasbahia')) return 'Casas Bahia';
  if (hostname.includes('pontofrio')) return 'Ponto Frio';
  if (hostname.includes('extra')) return 'Extra';
  if (hostname.includes('americanas')) return 'Americanas';
  if (hostname.includes('submarino')) return 'Submarino';
  if (hostname.includes('shoptime')) return 'Shoptime';
  return hostname.split('.')[0];
}

// Funcao auxiliar para extrair imagem do HTML
function extrairImagemDoHTML(html: string, url: string): string | null {
  const hostname = new URL(url).hostname.toLowerCase();
  let imagemUrl: string | null = null;

  // 1. Tentar JSON-LD (mais confiavel)
  const jsonLdMatches = html.matchAll(/<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi);
  for (const match of jsonLdMatches) {
    try {
      const jsonData = JSON.parse(match[1]);
      // Pode ser array ou objeto
      const products = Array.isArray(jsonData) ? jsonData : [jsonData];
      for (const item of products) {
        if (item['@type'] === 'Product' && item.image) {
          imagemUrl = Array.isArray(item.image) ? item.image[0] : item.image;
          if (typeof imagemUrl === 'object' && imagemUrl.url) {
            imagemUrl = imagemUrl.url;
          }
          if (imagemUrl) break;
        }
      }
    } catch {}
  }

  // 2. Meta og:image
  if (!imagemUrl) {
    const ogImage = html.match(/<meta[^>]*property="og:image"[^>]*content="([^"]*)"/i);
    if (ogImage) imagemUrl = ogImage[1];
  }

  // 3. Padroes especificos por site
  if (!imagemUrl && hostname.includes('leroymerlin')) {
    // Leroy Merlin usa CDN especifico
    const leroyImg = html.match(/https:\/\/cdn\.leroymerlin\.com\.br\/[^"'\s]+\.(jpg|png|webp)/i);
    if (leroyImg) imagemUrl = leroyImg[0];
  }

  if (!imagemUrl && hostname.includes('amazon')) {
    const amazonImg = html.match(/"hiRes":"([^"]+)"|"large":"([^"]+)"/i);
    if (amazonImg) imagemUrl = amazonImg[1] || amazonImg[2];
  }

  if (!imagemUrl && (hostname.includes('mercadolivre') || hostname.includes('mercadolibre'))) {
    const mlImg = html.match(/https:\/\/http2\.mlstatic\.com\/[^"'\s]+\.(jpg|png|webp)/i);
    if (mlImg) imagemUrl = mlImg[0];
  }

  // 4. Fallback: primeira imagem com palavras-chave
  if (!imagemUrl) {
    const imgMatch = html.match(/<img[^>]*src="(https?:\/\/[^"]*(?:product|produto|item|goods)[^"]*)"/i);
    if (imgMatch) imagemUrl = imgMatch[1];
  }

  // 5. Fallback: qualquer imagem grande (provavelmente produto)
  if (!imagemUrl) {
    const imgMatch = html.match(/<img[^>]*src="(https?:\/\/[^"]+\.(?:jpg|png|webp))"/i);
    if (imgMatch) imagemUrl = imgMatch[1];
  }

  return imagemUrl;
}

// Funcao para extrair produtos da pagina de resultados da Leroy Merlin
function extrairProdutosLeroyDaLista(html: string): Array<{
  titulo: string;
  preco: number;
  imagem_url: string | null;
  url_origem: string | null;
}> {
  const produtos: Array<{
    titulo: string;
    preco: number;
    imagem_url: string | null;
    url_origem: string | null;
  }> = [];

  // Tentar extrair do JSON embutido na pagina
  const jsonDataMatch = html.match(/window\.__PRELOADED_STATE__\s*=\s*(\{[\s\S]*?\});/);
  if (jsonDataMatch) {
    try {
      const data = JSON.parse(jsonDataMatch[1]);
      if (data.search?.products) {
        for (const p of data.search.products.slice(0, 5)) {
          produtos.push({
            titulo: p.name || p.title,
            preco: parseFloat(p.price?.value || p.price) || 0,
            imagem_url: p.image?.url || p.images?.[0]?.url || null,
            url_origem: p.url ? `https://www.leroymerlin.com.br${p.url}` : null,
          });
        }
      }
    } catch {}
  }

  // Fallback: regex para extrair cards de produto
  if (produtos.length === 0) {
    // Padroes comuns de listagem de produtos
    const cardMatches = html.matchAll(/<div[^>]*class="[^"]*product-card[^"]*"[^>]*>([\s\S]*?)<\/div>/gi);
    for (const match of cardMatches) {
      const cardHtml = match[1];

      const titulo = cardHtml.match(/<[^>]*class="[^"]*product-name[^"]*"[^>]*>([^<]+)/i);
      const preco = cardHtml.match(/R\$\s*([0-9.,]+)/i);
      const imagem = cardHtml.match(/src="(https:\/\/cdn\.leroymerlin\.com\.br[^"]+)"/i);
      const link = cardHtml.match(/href="([^"]+)"/i);

      if (titulo) {
        produtos.push({
          titulo: titulo[1].trim(),
          preco: preco ? parseFloat(preco[1].replace(/\./g, '').replace(',', '.')) : 0,
          imagem_url: imagem ? imagem[1] : null,
          url_origem: link ? `https://www.leroymerlin.com.br${link[1]}` : null,
        });
      }

      if (produtos.length >= 5) break;
    }
  }

  return produtos;
}
