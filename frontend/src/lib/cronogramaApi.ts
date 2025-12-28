// ============================================================
// API: Módulo de Cronograma
// Sistema WG Easy - Grupo WG Almeida
// ============================================================

import { supabaseRaw } from "./supabaseClient";
import type {
  Projeto,
  ProjetoCompleto,
  CronogramaTarefa,
  CronogramaTarefaCompleta,
  ProjetoFormData,
  CronogramaTarefaFormData,
  FiltrosProjetos,
  FiltrosTarefas,
  EstatisticasCronograma,
} from "@/types/cronograma";

// Tipos para comentários de tarefas
interface ComentarioTarefa {
  id: string;
  tarefa_id: string;
  comentario: string;
  created_by: string;
  created_at: string;
  updated_at: string;
  usuario_nome?: string;
  usuario_email?: string;
  usuario_avatar?: string;
}

interface ComentarioTarefaFormData {
  tarefa_id: string;
  comentario: string;
  created_by: string;
}

// ============================================================
// PROJETOS
// ============================================================

/**
 * Listar todos os projetos do cronograma
 */
export async function listarProjetosCronograma(
  filtros?: FiltrosProjetos
): Promise<ProjetoCompleto[]> {
  let query = supabaseRaw
    .from("vw_projetos_cronograma")
    .select("*")
    .order("created_at", { ascending: false });

  // Aplicar filtros
  if (filtros?.status && filtros.status.length > 0) {
    query = query.in("status", filtros.status);
  }

  if (filtros?.nucleo && filtros.nucleo.length > 0) {
    query = query.in("nucleo", filtros.nucleo);
  }

  if (filtros?.cliente_id) {
    query = query.eq("cliente_id", filtros.cliente_id);
  }

  if (filtros?.busca) {
    query = query.or(
      `titulo.ilike.%${filtros.busca}%,contrato_numero.ilike.%${filtros.busca}%,cliente_nome.ilike.%${filtros.busca}%`
    );
  }

  const { data, error } = await query;

  if (error) {
    console.error("Erro ao listar projetos:", error);
    throw error;
  }

  return data || [];
}

/**
 * Buscar projeto por ID
 */
export async function buscarProjetoCronograma(
  id: string
): Promise<ProjetoCompleto | null> {
  const { data, error } = await supabaseRaw
    .from("vw_projetos_cronograma")
    .select("*")
    .eq("id", id)
    .single();

  if (error) {
    console.error("Erro ao buscar projeto:", error);
    return null;
  }

  return data;
}

/**
 * Criar novo projeto
 */
export async function criarProjetoCronograma(
  projeto: ProjetoFormData
): Promise<Projeto> {
  const { data, error } = await supabaseRaw
    .from("projetos")
    .insert([projeto])
    .select()
    .single();

  if (error) {
    console.error("Erro ao criar projeto:", error);
    throw error;
  }

  return data;
}

/**
 * Atualizar projeto
 */
export async function atualizarProjetoCronograma(
  id: string,
  projeto: Partial<ProjetoFormData>
): Promise<Projeto> {
  const { data, error } = await supabaseRaw
    .from("projetos")
    .update(projeto)
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("Erro ao atualizar projeto:", error);
    throw error;
  }

  return data;
}

/**
 * Deletar projeto
 */
export async function deletarProjetoCronograma(id: string): Promise<void> {
  const { error } = await supabaseRaw.from("projetos").delete().eq("id", id);

  if (error) {
    console.error("Erro ao deletar projeto:", error);
    throw error;
  }
}

/**
 * Criar projeto a partir de um contrato
 */
export async function criarProjetoDoContrato(
  contratoId: string
): Promise<string> {
  const { data, error } = await supabaseRaw.rpc("criar_projeto_do_contrato", {
    p_contrato_id: contratoId,
  });

  if (error) {
    console.error("Erro ao criar projeto do contrato:", error);
    throw error;
  }

  return data; // Retorna o ID do projeto criado
}

// ============================================================
// TAREFAS
// ============================================================

/**
 * Listar tarefas de um projeto
 */
export async function listarTarefasProjeto(
  projetoId: string,
  filtros?: FiltrosTarefas
): Promise<CronogramaTarefa[]> {
  let query = supabaseRaw
    .from("cronograma_tarefas")
    .select("*")
    .eq("projeto_id", projetoId);

  // Ordenar por ordem
  query = query.order("ordem", { ascending: true, nullsFirst: false });

  // Aplicar filtros
  if (filtros?.status && filtros.status.length > 0) {
    query = query.in("status", filtros.status);
  }

  if (filtros?.categoria && filtros.categoria.length > 0) {
    query = query.in("categoria", filtros.categoria);
  }

  if (filtros?.mostrar_concluidas === false) {
    query = query.neq("status", "concluido");
  }

  const { data, error } = await query;

  if (error) {
    console.error("Erro ao listar tarefas:", error);
    throw error;
  }

  return data || [];
}

/**
 * Listar tarefas com comentários
 * Usa a tabela cronograma_tarefas diretamente
 */
export async function listarTarefasComComentarios(
  projetoId: string,
  filtros?: FiltrosTarefas
): Promise<CronogramaTarefaCompleta[]> {
  let query = supabaseRaw
    .from("cronograma_tarefas")
    .select("*")
    .eq("projeto_id", projetoId);

  // Ordenar por ordem
  query = query.order("ordem", { ascending: true, nullsFirst: false });

  // Aplicar filtros
  if (filtros?.status && filtros.status.length > 0) {
    query = query.in("status", filtros.status);
  }

  if (filtros?.categoria && filtros.categoria.length > 0) {
    query = query.in("categoria", filtros.categoria);
  }

  if (filtros?.mostrar_concluidas === false) {
    query = query.neq("status", "concluido");
  }

  const { data, error } = await query;

  if (error) {
    console.error("Erro ao listar tarefas com comentários:", error);
    throw error;
  }

  return data || [];
}

/**
 * Buscar tarefa por ID
 */
export async function buscarTarefa(id: string): Promise<CronogramaTarefa | null> {
  const { data, error } = await supabaseRaw
    .from("cronograma_tarefas")
    .select("*")
    .eq("id", id)
    .single();

  if (error) {
    console.error("Erro ao buscar tarefa:", error);
    return null;
  }

  return data;
}

/**
 * Criar nova tarefa
 */
export async function criarTarefa(
  projetoId: string,
  tarefa: CronogramaTarefaFormData
): Promise<CronogramaTarefa> {
  // Omit projeto_id from tarefa to avoid duplicate property
  const { projeto_id: _, ...tarefaSemProjetoId } = tarefa;
  const { data, error } = await supabaseRaw
    .from("cronograma_tarefas")
    .insert([
      {
        projeto_id: projetoId,
        ...tarefaSemProjetoId,
      },
    ])
    .select()
    .single();

  if (error) {
    console.error("Erro ao criar tarefa:", error);
    throw error;
  }

  return data;
}

/**
 * Atualizar tarefa
 */
export async function atualizarTarefa(
  id: string,
  tarefa: Partial<CronogramaTarefaFormData>
): Promise<CronogramaTarefa> {
  const { data, error } = await supabaseRaw
    .from("cronograma_tarefas")
    .update(tarefa)
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("Erro ao atualizar tarefa:", error);
    throw error;
  }

  return data;
}

/**
 * Atualizar ordem das tarefas (drag-and-drop)
 */
export async function atualizarOrdemTarefas(
  tarefas: { id: string; ordem: number }[]
): Promise<void> {
  const promises = tarefas.map((tarefa) =>
    supabaseRaw
      .from("cronograma_tarefas")
      .update({ ordem: tarefa.ordem })
      .eq("id", tarefa.id)
  );

  const results = await Promise.all(promises);

  const errors = results.filter((r) => r.error);
  if (errors.length > 0) {
    console.error("Erro ao atualizar ordem das tarefas:", errors);
    throw new Error("Erro ao atualizar ordem das tarefas");
  }
}

/**
 * Atualizar descrição da tarefa (inline)
 */
export async function atualizarDescricaoTarefa(
  id: string,
  descricao: string
): Promise<void> {
  const { error } = await supabaseRaw
    .from("cronograma_tarefas")
    .update({ descricao: descricao })
    .eq("id", id);

  if (error) {
    console.error("Erro ao atualizar descrição:", error);
    throw error;
  }
}

/**
 * Deletar tarefa
 */
export async function deletarTarefa(id: string): Promise<void> {
  const { error } = await supabaseRaw.from("cronograma_tarefas").delete().eq("id", id);

  if (error) {
    console.error("Erro ao deletar tarefa:", error);
    throw error;
  }
}

// ============================================================
// COMENTÁRIOS
// ============================================================

/**
 * Listar comentários de uma tarefa
 */
export async function listarComentariosTarefa(
  taskId: string
): Promise<ComentarioTarefa[]> {
  const { data, error } = await supabaseRaw
    .from("task_comments")
    .select(
      `
      *,
      usuario:created_by (
        nome,
        email,
        avatar_url
      )
    `
    )
    .eq("task_id", taskId)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Erro ao listar comentários:", error);
    throw error;
  }

  // Mapear dados do usuário
  const comentarios = (data || []).map((c: any) => ({
    ...c,
    usuario_nome: c.usuario?.nome,
    usuario_email: c.usuario?.email,
    usuario_avatar: c.usuario?.avatar_url,
  }));

  return comentarios;
}

/**
 * Criar comentário
 */
export async function criarComentario(
  comentario: ComentarioTarefaFormData
): Promise<ComentarioTarefa> {
  const { data, error } = await supabaseRaw
    .from("task_comments")
    .insert([comentario])
    .select()
    .single();

  if (error) {
    console.error("Erro ao criar comentário:", error);
    throw error;
  }

  return data;
}

/**
 * Atualizar comentário
 */
export async function atualizarComentario(
  id: string,
  comentario: string
): Promise<ComentarioTarefa> {
  const { data, error } = await supabaseRaw
    .from("task_comments")
    .update({ comentario, updated_at: new Date().toISOString() })
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("Erro ao atualizar comentário:", error);
    throw error;
  }

  return data;
}

/**
 * Deletar comentário
 */
export async function deletarComentario(id: string): Promise<void> {
  const { error } = await supabaseRaw
    .from("task_comments")
    .delete()
    .eq("id", id);

  if (error) {
    console.error("Erro ao deletar comentário:", error);
    throw error;
  }
}

// ============================================================
// ESTATÍSTICAS
// ============================================================

/**
 * Buscar estatísticas do cronograma
 */
export async function buscarEstatisticasCronograma(): Promise<EstatisticasCronograma> {
  // Buscar projetos
  const { data: projetos } = await supabaseRaw
    .from("projetos")
    .select("status, progresso, nucleo");

  // Buscar tarefas
  const { data: tarefas } = await supabaseRaw
    .from("cronograma_tarefas")
    .select("status, data_termino");

  const totalProjetos = projetos?.length || 0;
  const projetosPendentes = projetos?.filter((p) => p.status === "pendente").length || 0;
  const projetosEmAndamento = projetos?.filter((p) => p.status === "em_andamento").length || 0;
  const projetosConcluidos = projetos?.filter((p) => p.status === "concluido").length || 0;
  const projetosPausados = projetos?.filter((p) => p.status === "pausado").length || 0;
  const projetosCancelados = projetos?.filter((p) => p.status === "cancelado").length || 0;

  const totalTarefas = tarefas?.length || 0;
  const tarefasPendentes = tarefas?.filter((t) => t.status === "pendente").length || 0;
  const tarefasEmAndamento = tarefas?.filter((t) => t.status === "em_andamento").length || 0;
  const tarefasConcluidas = tarefas?.filter((t) => t.status === "concluido").length || 0;

  // Tarefas atrasadas (data_termino < hoje e status != concluido)
  const hoje = new Date();
  const tarefasAtrasadas =
    tarefas?.filter((t) => {
      if (!t.data_termino || t.status === "concluido" || t.status === "cancelado")
        return false;
      return new Date(t.data_termino) < hoje;
    }).length || 0;

  // Progresso médio geral
  const progressoMedio = projetos?.length
    ? Math.round(projetos.reduce((acc, p) => acc + (p.progresso || 0), 0) / projetos.length)
    : 0;

  // Estatísticas por núcleo
  const nucleosMap = new Map<string, { total: number; progressoSum: number }>();
  projetos?.forEach((p) => {
    const nucleo = p.nucleo || "geral";
    const atual = nucleosMap.get(nucleo) || { total: 0, progressoSum: 0 };
    nucleosMap.set(nucleo, {
      total: atual.total + 1,
      progressoSum: atual.progressoSum + (p.progresso || 0),
    });
  });

  const porNucleo = Array.from(nucleosMap.entries()).map(([nucleo, stats]) => ({
    nucleo,
    total_projetos: stats.total,
    progresso_medio: Math.round(stats.progressoSum / stats.total),
  }));

  return {
    total_projetos: totalProjetos,
    projetos_pendentes: projetosPendentes,
    projetos_em_andamento: projetosEmAndamento,
    projetos_concluidos: projetosConcluidos,
    projetos_pausados: projetosPausados,
    projetos_cancelados: projetosCancelados,
    total_tarefas: totalTarefas,
    tarefas_pendentes: tarefasPendentes,
    tarefas_em_andamento: tarefasEmAndamento,
    tarefas_concluidas: tarefasConcluidas,
    tarefas_atrasadas: tarefasAtrasadas,
    progresso_medio_geral: progressoMedio,
    por_nucleo: porNucleo,
  };
}
