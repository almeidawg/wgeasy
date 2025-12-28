// supabase/functions/buscar-produto-ia/index.ts
// Edge Function para buscar produtos usando OpenAI (evita CORS)

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
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

          // Extrair imagem do JSON-LD
          let imagemUrl = null;

          const jsonLdMatch = html.match(/<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/i);
          if (jsonLdMatch) {
            try {
              const jsonData = JSON.parse(jsonLdMatch[1]);
              if (jsonData.image) {
                imagemUrl = Array.isArray(jsonData.image) ? jsonData.image[0] : jsonData.image;
              }
            } catch {}
          }

          // Fallback: meta og:image
          if (!imagemUrl) {
            const ogImage = html.match(/<meta[^>]*property="og:image"[^>]*content="([^"]*)"/i);
            if (ogImage) imagemUrl = ogImage[1];
          }

          // Fallback: primeira imagem de produto
          if (!imagemUrl) {
            const imgMatch = html.match(/<img[^>]*src="([^"]*(?:product|produto|item)[^"]*)"/i);
            if (imgMatch) imagemUrl = imgMatch[1];
          }

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
