// ============================================================
// API: Checklist Diário do CEO/Founder
// Sistema WG Easy - Grupo WG Almeida
// ============================================================
//
// SUPABASE STUDIO - TABELAS:
// - ceo_checklist_diario: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/ceo_checklist_diario
// - ceo_checklist_itens:  https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/ceo_checklist_itens
// - Menções (comentários): https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/project_tasks_comentarios
//
// ============================================================

import { supabase } from "./supabaseClient";

// ============================================================
// TIPOS
// ============================================================

export type PrioridadeItem = "alta" | "media" | "baixa";
export type FonteItem = "manual" | "mencao" | "automatico" | "recorrente";

export interface CEOChecklistItem {
  id: string;
  checklist_id: string;
  texto: string;
  prioridade: PrioridadeItem;
  concluido: boolean;
  concluido_em: string | null;
  ordem: number;
  fonte: FonteItem;
  referencia_id: string | null;
  created_at: string;
}

export interface CEOChecklist {
  id: string;
  data: string;
  usuario_id: string;
  observacoes: string | null;
  created_at: string;
  updated_at: string;
  itens?: CEOChecklistItem[];
}

export interface NovoItemInput {
  texto: string;
  prioridade?: PrioridadeItem;
  ordem?: number;
  fonte?: FonteItem;
  referencia_id?: string;
}

// ============================================================
// FUNÇÕES
// ============================================================

/**
 * Obter ou criar o checklist do dia atual
 * Se não existir, copia itens não concluídos do dia anterior
 */
export async function obterChecklistDiario(usuarioId: string): Promise<CEOChecklist | null> {
  const hoje = new Date().toISOString().split("T")[0];
  const ontem = new Date(Date.now() - 86400000).toISOString().split("T")[0];

  // Tentar buscar checklist de hoje
  let { data: checklist, error } = await supabase
    .from("ceo_checklist_diario")
    .select("*, itens:ceo_checklist_itens(*)")
    .eq("usuario_id", usuarioId)
    .eq("data", hoje)
    .single();

  if (error && error.code !== "PGRST116") {
    console.error("[obterChecklistDiario] Erro ao buscar:", error);
    throw error;
  }

  // Se não existe, criar novo checklist
  if (!checklist) {
    // Primeiro, criar o checklist de hoje
    const { data: novoChecklist, error: createError } = await supabase
      .from("ceo_checklist_diario")
      .insert({ data: hoje, usuario_id: usuarioId })
      .select()
      .single();

    if (createError) {
      console.error("[obterChecklistDiario] Erro ao criar:", createError);
      throw createError;
    }

    checklist = { ...novoChecklist, itens: [] };

    // Copiar itens não concluídos do dia anterior
    await copiarItensNaoConcluidos(usuarioId, ontem, hoje);

    // Buscar novamente com os itens copiados
    const { data: checklistAtualizado } = await supabase
      .from("ceo_checklist_diario")
      .select("*, itens:ceo_checklist_itens(*)")
      .eq("id", checklist.id)
      .single();

    if (checklistAtualizado) {
      checklist = checklistAtualizado;
    }
  }

  // Ordenar itens por ordem
  if (checklist?.itens) {
    checklist.itens.sort((a: CEOChecklistItem, b: CEOChecklistItem) => a.ordem - b.ordem);
  }

  return checklist;
}

/**
 * Copiar itens não concluídos de um dia para outro
 */
async function copiarItensNaoConcluidos(
  usuarioId: string,
  dataOrigem: string,
  dataDestino: string
): Promise<void> {
  // Buscar checklist de origem
  const { data: checklistOrigem } = await supabase
    .from("ceo_checklist_diario")
    .select("id")
    .eq("usuario_id", usuarioId)
    .eq("data", dataOrigem)
    .single();

  if (!checklistOrigem) return;

  // Buscar checklist de destino
  const { data: checklistDestino } = await supabase
    .from("ceo_checklist_diario")
    .select("id")
    .eq("usuario_id", usuarioId)
    .eq("data", dataDestino)
    .single();

  if (!checklistDestino) return;

  // Buscar itens não concluídos do dia anterior
  const { data: itensNaoConcluidos } = await supabase
    .from("ceo_checklist_itens")
    .select("texto, prioridade, ordem")
    .eq("checklist_id", checklistOrigem.id)
    .eq("concluido", false);

  if (!itensNaoConcluidos || itensNaoConcluidos.length === 0) return;

  // Buscar itens já existentes no destino para evitar duplicatas
  const { data: itensExistentes } = await supabase
    .from("ceo_checklist_itens")
    .select("texto")
    .eq("checklist_id", checklistDestino.id);

  const textosExistentes = new Set(itensExistentes?.map((i) => i.texto) || []);

  // Filtrar apenas itens que não existem no destino
  const itensParaCopiar = itensNaoConcluidos.filter(
    (item) => !textosExistentes.has(item.texto)
  );

  if (itensParaCopiar.length === 0) return;

  // Inserir itens copiados
  const { error } = await supabase.from("ceo_checklist_itens").insert(
    itensParaCopiar.map((item) => ({
      checklist_id: checklistDestino.id,
      texto: item.texto,
      prioridade: item.prioridade,
      ordem: item.ordem,
      fonte: "recorrente" as FonteItem,
    }))
  );

  if (error) {
    console.error("[copiarItensNaoConcluidos] Erro:", error);
  }
}

/**
 * Adicionar novo item ao checklist
 */
export async function adicionarItem(
  checklistId: string,
  item: NovoItemInput
): Promise<CEOChecklistItem> {
  // Buscar próxima ordem
  const { data: ultimoItem } = await supabase
    .from("ceo_checklist_itens")
    .select("ordem")
    .eq("checklist_id", checklistId)
    .order("ordem", { ascending: false })
    .limit(1)
    .single();

  const proximaOrdem = (ultimoItem?.ordem || 0) + 1;

  const { data, error } = await supabase
    .from("ceo_checklist_itens")
    .insert({
      checklist_id: checklistId,
      texto: item.texto,
      prioridade: item.prioridade || "media",
      ordem: item.ordem ?? proximaOrdem,
      fonte: item.fonte || "manual",
      referencia_id: item.referencia_id || null,
    })
    .select()
    .single();

  if (error) {
    console.error("[adicionarItem] Erro:", error);
    throw error;
  }

  return data;
}

/**
 * Marcar item como concluído/não concluído
 */
export async function toggleItemConcluido(
  itemId: string,
  concluido: boolean
): Promise<CEOChecklistItem> {
  const { data, error } = await supabase
    .from("ceo_checklist_itens")
    .update({
      concluido,
      concluido_em: concluido ? new Date().toISOString() : null,
    })
    .eq("id", itemId)
    .select()
    .single();

  if (error) {
    console.error("[toggleItemConcluido] Erro:", error);
    throw error;
  }

  return data;
}

/**
 * Atualizar texto ou prioridade de um item
 */
export async function atualizarItem(
  itemId: string,
  updates: Partial<Pick<CEOChecklistItem, "texto" | "prioridade" | "ordem">>
): Promise<CEOChecklistItem> {
  const { data, error } = await supabase
    .from("ceo_checklist_itens")
    .update(updates)
    .eq("id", itemId)
    .select()
    .single();

  if (error) {
    console.error("[atualizarItem] Erro:", error);
    throw error;
  }

  return data;
}

/**
 * Remover item do checklist
 */
export async function removerItem(itemId: string): Promise<void> {
  const { error } = await supabase
    .from("ceo_checklist_itens")
    .delete()
    .eq("id", itemId);

  if (error) {
    console.error("[removerItem] Erro:", error);
    throw error;
  }
}

/**
 * Calcular progresso do checklist (percentual de itens concluídos)
 */
export function calcularProgresso(itens: CEOChecklistItem[]): number {
  if (!itens || itens.length === 0) return 0;
  const concluidos = itens.filter((i) => i.concluido).length;
  return Math.round((concluidos / itens.length) * 100);
}

/**
 * Buscar menções do usuário em comentários de tarefas
 * Retorna tarefas onde o usuário foi @mencionado
 *
 * NOTA: Funcionalidade de menções ainda não implementada no sistema.
 * O sistema atual usa task_comments que não possui campo de menções.
 * Esta função retorna array vazio até que a funcionalidade seja implementada.
 */
export async function buscarMencoesUsuario(
  _usuarioId: string,
  _dias: number = 7
): Promise<any[]> {
  // Funcionalidade de menções não implementada no sistema atual
  // O sistema usa task_comments (cronogramaApi) que não tem campo "mencoes"
  // Retornar vazio até implementação futura
  return [];
}

/**
 * Importar menção como item do checklist
 */
export async function importarMencaoParaChecklist(
  checklistId: string,
  mencaoId: string,
  texto: string
): Promise<CEOChecklistItem> {
  return adicionarItem(checklistId, {
    texto,
    prioridade: "alta",
    fonte: "mencao",
    referencia_id: mencaoId,
  });
}
