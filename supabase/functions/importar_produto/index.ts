// supabase/functions/importar_produto/index.ts
import cheerio from "npm:cheerio@1.0.0-rc.12";

Deno.serve(async (req) => {
  try {
    const { url } = await req.json();
    const html = await (await fetch(url)).text();
    const $ = cheerio.load(html);

    const titulo = $("title").text().trim();

    const preco =
      $('meta[itemprop="price"]').attr("content") ||
      $('meta[property="product:price:amount"]').attr("content") ||
      null;

    const imagem =
      $('meta[property="og:image"]').attr("content") ||
      $("img").first().attr("src") ||
      null;

    const produto = {
      titulo,
      preco,
      imagem_url: imagem,
      link_origem: url,
    };

    return new Response(JSON.stringify(produto), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
    });
  }
});
