// src/lib/pessoasApi.ts
// API principal para manipulação da tabela pessoas
// Usa tipos centralizados de @/types/pessoas

import { supabase } from "./supabaseClient";
import type {
  Pessoa,
  PessoaTipo,
  PessoaInput,
  PessoaDocumento,
  PessoaAvaliacao,
  PessoaObra,
} from "@/types/pessoas";

// Re-exportar tipos para compatibilidade com componentes antigos
export type {
  Pessoa,
  PessoaTipo,
  PessoaInput,
  PessoaDocumento,
  PessoaAvaliacao,
  PessoaObra,
} from "@/types/pessoas";

const TABLE = "pessoas";

function mapFromDb(row: any): Pessoa {
  return {
    id: row.id,
    nome: row.nome,
    email: row.email,
    telefone: row.telefone,
    // Campos opcionais (podem não existir no banco ainda)
    cpf: row.cpf ?? null,
    cnpj: row.cnpj ?? null,
    rg: row.rg ?? null,
    nacionalidade: row.nacionalidade ?? null,
    estado_civil: row.estado_civil ?? null,
    profissao: row.profissao ?? null,
    cargo: row.cargo ?? null,
    empresa: row.empresa ?? null,
    unidade: row.unidade ?? null,
    tipo: row.tipo,
    // Endereço
    cep: row.cep ?? null,
    logradouro: row.logradouro ?? null,
    numero: row.numero ?? null,
    complemento: row.complemento ?? null,
    bairro: row.bairro ?? null,
    cidade: row.cidade ?? null,
    estado: row.estado ?? null,
    pais: row.pais ?? null,
    // Endereço da obra
    obra_endereco_diferente: row.obra_endereco_diferente ?? false,
    obra_cep: row.obra_cep ?? null,
    obra_logradouro: row.obra_logradouro ?? null,
    obra_numero: row.obra_numero ?? null,
    obra_complemento: row.obra_complemento ?? null,
    obra_bairro: row.obra_bairro ?? null,
    obra_cidade: row.obra_cidade ?? null,
    obra_estado: row.obra_estado ?? null,
    // Dados bancários
    banco: row.banco ?? null,
    agencia: row.agencia ?? null,
    conta: row.conta ?? null,
    tipo_conta: row.tipo_conta ?? null,
    pix: row.pix ?? null,
    // Comissionamento (especificadores)
    categoria_comissao_id: row.categoria_comissao_id ?? null,
    is_master: row.is_master ?? null,
    indicado_por_id: row.indicado_por_id ?? null,
    // Informações adicionais
    contato_responsavel: row.contato_responsavel ?? null,
    observacoes: row.observacoes ?? null,
    avatar: row.avatar ?? null,
    avatar_url: row.avatar_url ?? null,
    foto_url: row.foto_url ?? null,
    ativo: row.ativo ?? true,
    criado_em: row.criado_em,
    atualizado_em: row.atualizado_em,
  };
}

function mapDocumentoFromDb(row: any): PessoaDocumento {
  return {
    id: row.id,
    pessoa_id: row.pessoa_id,
    nome: row.nome ?? row.tipo ?? "Documento",
    tipo: row.tipo ?? "DOCUMENTO",
    url: row.url ?? row.arquivo_url ?? "",
    arquivo_url: row.arquivo_url ?? row.url ?? null,
    descricao: row.descricao ?? null,
    validade: row.validade ?? null,
    criado_em: row.criado_em ?? row.created_at ?? new Date().toISOString(),
  };
}

export async function listarPessoas(params?: {
  tipo?: PessoaTipo;
  ativo?: boolean;
  search?: string;
}): Promise<Pessoa[]> {
  let query = supabase.from(TABLE).select("*");

  if (params?.tipo) {
    query = query.eq("tipo", params.tipo);
  }

  if (typeof params?.ativo === "boolean") {
    query = query.eq("ativo", params.ativo);
  }

  if (params?.search && params.search.trim()) {
    const term = `%${params.search.trim()}%`;
    query = query.or(
      `nome.ilike.${term},email.ilike.${term},telefone.ilike.${term}`
    );
  }

  const { data, error } = await query.order("criado_em", {
    ascending: false,
  });

  if (error) {
    console.error("[listarPessoas] erro:", error);
    throw error;
  }

  return (data ?? []).map(mapFromDb);
}

export async function obterPessoa(id: string): Promise<Pessoa | null> {
  const { data, error } = await supabase
    .from(TABLE)
    .select("*")
    .eq("id", id)
    .maybeSingle();

  if (error) {
    console.error("[obterPessoa] erro:", error);
    throw error;
  }

  return data ? mapFromDb(data) : null;
}

export async function listarDocumentosPessoa(
  pessoaId: string
): Promise<PessoaDocumento[]> {
  const { data, error } = await supabase
    .from("pessoas_documentos")
    .select("*")
    .eq("pessoa_id", pessoaId)
    .order("criado_em", { ascending: false });

  if (error) {
    console.error("[listarDocumentosPessoa] erro:", error);
    throw error;
  }

  return (data ?? []).map(mapDocumentoFromDb);
}

export async function criarPessoa(input: PessoaInput): Promise<Pessoa> {
  const payload = {
    ...input,
    ativo: input.ativo ?? true,
  };

  const { data, error } = await supabase
    .from(TABLE)
    .insert(payload)
    .select("*")
    .single();

  if (error) {
    console.error("[criarPessoa] erro:", error);
    throw error;
  }

  return mapFromDb(data);
}

export async function atualizarPessoa(
  id: string,
  input: Partial<PessoaInput>
): Promise<Pessoa> {
  const { data, error } = await supabase
    .from(TABLE)
    .update(input)
    .eq("id", id)
    .select("*")
    .single();

  if (error) {
    console.error("[atualizarPessoa] erro:", error);
    throw error;
  }

  return mapFromDb(data);
}

export async function desativarPessoa(id: string): Promise<void> {
  const { error } = await supabase
    .from(TABLE)
    .update({ ativo: false })
    .eq("id", id);

  if (error) {
    console.error("[desativarPessoa] erro:", error);
    throw error;
  }
}

export async function deletarPessoa(id: string): Promise<void> {
  // Verificar se a pessoa é um cliente com oportunidades vinculadas
  const { data: oportunidades, error: oportError } = await supabase
    .from("oportunidades")
    .select("id")
    .eq("cliente_id", id);

  if (oportError) {
    console.error("[deletarPessoa] erro ao verificar oportunidades:", oportError);
    throw oportError;
  }

  if (oportunidades && oportunidades.length > 0) {
    throw new Error(
      `Não é possível deletar esta pessoa pois ela possui ${oportunidades.length} oportunidade(s) vinculada(s). ` +
      `Por favor, remova ou transfira as oportunidades antes de deletar.`
    );
  }

  // Se não tem oportunidades, pode deletar
  const { error } = await supabase
    .from(TABLE)
    .delete()
    .eq("id", id);

  if (error) {
    console.error("[deletarPessoa] erro:", error);
    throw error;
  }
}

export async function criarAvaliacao(
  pessoaId: string,
  avaliadorId: string,
  nota: number,
  comentario?: string
): Promise<PessoaAvaliacao> {
  const { data, error } = await supabase
    .from("pessoas_avaliacoes")
    .insert({
      pessoa_id: pessoaId,
      avaliador_id: avaliadorId,
      nota,
      comentario: comentario || null,
    })
    .select("*")
    .single();

  if (error) {
    console.error("[criarAvaliacao] erro:", error);
    throw error;
  }

  return {
    id: data.id,
    pessoa_id: data.pessoa_id,
    avaliador_id: data.avaliador_id,
    nota: data.nota,
    comentario: data.comentario ?? undefined,
    criado_em: data.criado_em ?? data.created_at ?? new Date().toISOString(),
  };
}
