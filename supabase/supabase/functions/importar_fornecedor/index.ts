// supabase/functions/importar_fornecedor/index.ts
import cheerio from "npm:cheerio@1.0.0-rc.12";

Deno.serve(async (req) => {
  try {
    const { url } = await req.json();
    if (!url) {
      throw new Error("URL não enviada.");
    }

    const html = await (await fetch(url)).text();
    const $ = cheerio.load(html);

    const title = $("title").text().trim() || null;

    const logo =
      $('link[rel="icon"]').attr("href") ||
      $('link[rel="shortcut icon"]').attr("href") ||
      $('meta[property="og:image"]').attr("content") ||
      null;

    /* Detectar categoria automaticamente pelo domínio */
    const dominio = new URL(url).hostname;

    let categoria = "Fornecedor Geral";

    if (dominio.includes("portobello")) categoria = "Revestimentos";
    if (dominio.includes("telhanorte")) categoria = "Material de Construção";
    if (dominio.includes("moldurama")) categoria = "Molduras";
    if (dominio.includes("interlight")) categoria = "Iluminação";
    if (dominio.includes("coral")) categoria = "Tintas";
    if (dominio.includes("suvinil")) categoria = "Tintas";
    if (dominio.includes("decorcolors")) categoria = "Tintas / Acabamento";
    if (dominio.includes("elettromec")) categoria = "Eletrodomésticos Premium";
    if (dominio.includes("electrolux")) categoria = "Eletrodomésticos";
    if (dominio.includes("brastemp")) categoria = "Eletrodomésticos";
    if (dominio.includes("tramontina")) categoria = "Cozinha / Utensílios";
    if (dominio.includes("mickey")) categoria = "Infantil / Temático";
    if (dominio.includes("spicy")) categoria = "Cozinha / Decoração";
    if (dominio.includes("casaalmeida")) categoria = "Enxoval / Casa";
    if (dominio.includes("aliexpress")) categoria = "Marketplace Importado";
    if (dominio.includes("leroymerlin")) categoria = "Construção / Ferramentas";

    const fornecedor = {
      nome: title?.replace(" | ", " ") || "Fornecedor",
      site: url,
      logo_url: logo,
      categoria,
      link_origem: url,
    };

    return new Response(JSON.stringify(fornecedor), {
      headers: { "Content-Type": "application/json" },
    });

  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
    });
  }
});
