// ============================================================
// IMPORTADOR DE IMAGENS PARA PRICELIST
// Sistema WG Easy - Busca automática de imagens para produtos
// ============================================================

import { supabase } from "./supabaseClient";

export interface ProdutoSemImagem {
  id: string;
  nome: string;
  codigo?: string;
  fabricante?: string;
  categoria_nome?: string;
  link_produto?: string;
}

export interface ResultadoBuscaImagem {
  id: string;
  nome: string;
  imagem_url: string | null;
  fonte: string | null;
  sucesso: boolean;
  erro?: string;
}

// URL da Edge Function
const EDGE_FUNCTION_URL = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/buscar-produto-ia`;

/**
 * Busca produtos da pricelist que não possuem imagem
 */
export async function buscarProdutosSemImagem(
  limite: number = 100,
  offset: number = 0,
  filtroCategoria?: string
): Promise<{ produtos: ProdutoSemImagem[]; total: number }> {
  let query = supabase
    .from("pricelist_itens")
    .select(`
      id,
      nome,
      codigo,
      fabricante,
      link_produto,
      pricelist_categorias!pricelist_itens_categoria_id_fkey(nome)
    `, { count: 'exact' })
    .or("imagem_url.is.null,imagem_url.eq.")
    .eq("ativo", true)
    .order("nome");

  if (filtroCategoria) {
    query = query.eq("categoria_id", filtroCategoria);
  }

  const { data, error, count } = await query.range(offset, offset + limite - 1);

  if (error) {
    console.error("Erro ao buscar produtos sem imagem:", error);
    throw new Error("Erro ao buscar produtos sem imagem");
  }

  const produtos = (data || []).map((item: any) => ({
    id: item.id,
    nome: item.nome,
    codigo: item.codigo,
    fabricante: item.fabricante,
    link_produto: item.link_produto,
    categoria_nome: item.pricelist_categorias?.nome,
  }));

  return { produtos, total: count || 0 };
}

/**
 * Busca imagem para um produto específico usando IA
 */
export async function buscarImagemProduto(
  produto: ProdutoSemImagem
): Promise<ResultadoBuscaImagem> {
  try {
    // Obter token de autenticação
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    if (!token) {
      throw new Error("Usuário não autenticado");
    }

    // Primeiro tentar extrair imagem do link do produto, se existir
    if (produto.link_produto) {
      const resultadoExtracao = await extrairImagemDeUrl(produto.link_produto, token);
      if (resultadoExtracao.imagem_url) {
        return {
          id: produto.id,
          nome: produto.nome,
          imagem_url: resultadoExtracao.imagem_url,
          fonte: resultadoExtracao.fonte || "link_produto",
          sucesso: true,
        };
      }
    }

    // Fallback: buscar imagem via IA
    const termoBusca = JSON.stringify({
      nome: produto.nome,
      fabricante: produto.fabricante,
      url_referencia: produto.link_produto,
    });

    const response = await fetch(EDGE_FUNCTION_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        termoBusca,
        tipo: "buscar_imagem",
      }),
    });

    if (!response.ok) {
      throw new Error("Falha na busca de imagem");
    }

    const data = await response.json();

    return {
      id: produto.id,
      nome: produto.nome,
      imagem_url: data.imagem_url || null,
      fonte: data.fonte || "ia",
      sucesso: !!data.imagem_url,
    };
  } catch (error: any) {
    console.error(`Erro ao buscar imagem para ${produto.nome}:`, error);
    return {
      id: produto.id,
      nome: produto.nome,
      imagem_url: null,
      fonte: null,
      sucesso: false,
      erro: error.message,
    };
  }
}

/**
 * Extrai imagem diretamente de uma URL de produto
 */
async function extrairImagemDeUrl(
  url: string,
  token: string
): Promise<{ imagem_url: string | null; fonte: string | null }> {
  try {
    const response = await fetch(EDGE_FUNCTION_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        termoBusca: url,
        tipo: "extrair_imagem_url",
      }),
    });

    if (!response.ok) {
      return { imagem_url: null, fonte: null };
    }

    return await response.json();
  } catch {
    return { imagem_url: null, fonte: null };
  }
}

/**
 * Atualiza a imagem de um produto no banco de dados
 */
export async function atualizarImagemProduto(
  produtoId: string,
  imagemUrl: string
): Promise<boolean> {
  const { error } = await supabase
    .from("pricelist_itens")
    .update({ imagem_url: imagemUrl, updated_at: new Date().toISOString() })
    .eq("id", produtoId);

  if (error) {
    console.error("Erro ao atualizar imagem:", error);
    return false;
  }

  return true;
}

/**
 * Busca imagens para múltiplos produtos em lote
 * Retorna um AsyncGenerator para processar progressivamente
 */
export async function* buscarImagensEmLote(
  produtos: ProdutoSemImagem[],
  delayMs: number = 1000
): AsyncGenerator<ResultadoBuscaImagem & { progresso: number }> {
  for (let i = 0; i < produtos.length; i++) {
    const produto = produtos[i];
    const resultado = await buscarImagemProduto(produto);

    // Se encontrou imagem, atualiza no banco
    if (resultado.sucesso && resultado.imagem_url) {
      await atualizarImagemProduto(produto.id, resultado.imagem_url);
    }

    yield {
      ...resultado,
      progresso: Math.round(((i + 1) / produtos.length) * 100),
    };

    // Delay entre requisições para não sobrecarregar
    if (i < produtos.length - 1) {
      await new Promise((resolve) => setTimeout(resolve, delayMs));
    }
  }
}

/**
 * Busca imagem na internet via Google Images (usando IA)
 */
export async function buscarImagemNaInternet(
  termoBusca: string
): Promise<string | null> {
  try {
    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    if (!token) {
      throw new Error("Usuário não autenticado");
    }

    // Usar buscar_imagem com termo simples
    const response = await fetch(EDGE_FUNCTION_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        termoBusca: JSON.stringify({ nome: termoBusca }),
        tipo: "buscar_imagem",
      }),
    });

    if (!response.ok) {
      return null;
    }

    const data = await response.json();
    return data.imagem_url || null;
  } catch {
    return null;
  }
}

/**
 * Valida se uma URL de imagem é válida e acessível
 */
export async function validarUrlImagem(url: string): Promise<boolean> {
  try {
    const response = await fetch(url, { method: "HEAD" });
    const contentType = response.headers.get("content-type") || "";
    return response.ok && contentType.startsWith("image/");
  } catch {
    return false;
  }
}

/**
 * Busca imagem do produto na Leroy Merlin
 */
export async function buscarImagemLeroy(
  nomeProduto: string
): Promise<string | null> {
  try {
    // Construir URL de busca na Leroy Merlin
    const termoBusca = encodeURIComponent(nomeProduto);
    const url = `https://www.leroymerlin.com.br/busca?term=${termoBusca}`;

    const { data: { session } } = await supabase.auth.getSession();
    const token = session?.access_token;

    if (!token) return null;

    // Usar Edge Function para extrair imagem da página de busca
    const response = await fetch(EDGE_FUNCTION_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        termoBusca: url,
        tipo: "extrair_imagem_url",
      }),
    });

    if (!response.ok) return null;

    const data = await response.json();
    return data.imagem_url || null;
  } catch {
    return null;
  }
}
