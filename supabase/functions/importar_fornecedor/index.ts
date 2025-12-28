// supabase/functions/importar_fornecedor/index.ts
import cheerio from "npm:cheerio@1.0.0-rc.12";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { url } = await req.json();

    if (!url) {
      return new Response(
        JSON.stringify({ error: "URL é obrigatória" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const html = await (await fetch(url)).text();
    const $ = cheerio.load(html);

    // Extrair nome da empresa
    const nome =
      $('meta[property="og:site_name"]').attr("content") ||
      $('meta[property="og:title"]').attr("content") ||
      $("title").text().trim() ||
      $("h1").first().text().trim() ||
      null;

    // Extrair descrição
    const descricao =
      $('meta[name="description"]').attr("content") ||
      $('meta[property="og:description"]').attr("content") ||
      null;

    // Extrair logo/imagem
    const logo =
      $('meta[property="og:image"]').attr("content") ||
      $('link[rel="icon"]').attr("href") ||
      $('link[rel="shortcut icon"]').attr("href") ||
      $("img").first().attr("src") ||
      null;

    // Extrair email (busca em links mailto e texto)
    const emailMatch = html.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/);
    const email = emailMatch ? emailMatch[0] : null;

    // Extrair telefone (padrões brasileiros)
    const telefoneMatch = html.match(
      /(?:\+55\s?)?(?:\(?\d{2}\)?\s?)?(?:9?\d{4}[-.\s]?\d{4})/
    );
    const telefone = telefoneMatch ? telefoneMatch[0].replace(/\D/g, "") : null;

    // Extrair CNPJ
    const cnpjMatch = html.match(
      /\d{2}\.?\d{3}\.?\d{3}\/?\d{4}-?\d{2}/
    );
    const cnpj = cnpjMatch ? cnpjMatch[0].replace(/\D/g, "") : null;

    // Extrair endereço (busca comum em rodapés)
    const enderecoSelectors = [
      '[itemprop="address"]',
      '.endereco',
      '.address',
      'address',
      '[class*="endereco"]',
      '[class*="address"]',
    ];
    let endereco = null;
    for (const selector of enderecoSelectors) {
      const found = $(selector).first().text().trim();
      if (found && found.length > 10) {
        endereco = found;
        break;
      }
    }

    // Extrair redes sociais
    const redesSociais: Record<string, string> = {};
    $('a[href*="instagram.com"]').each((_, el) => {
      redesSociais.instagram = $(el).attr("href") || "";
    });
    $('a[href*="facebook.com"]').each((_, el) => {
      redesSociais.facebook = $(el).attr("href") || "";
    });
    $('a[href*="linkedin.com"]').each((_, el) => {
      redesSociais.linkedin = $(el).attr("href") || "";
    });
    $('a[href*="whatsapp"]').each((_, el) => {
      redesSociais.whatsapp = $(el).attr("href") || "";
    });

    const fornecedor = {
      nome,
      descricao,
      logo_url: logo,
      email,
      telefone,
      cnpj,
      endereco,
      redes_sociais: Object.keys(redesSociais).length > 0 ? redesSociais : null,
      site: url,
    };

    return new Response(JSON.stringify(fornecedor), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
