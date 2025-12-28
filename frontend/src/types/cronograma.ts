// ============================================================
// TYPES: Módulo de Cronograma - ATUALIZADO 13/12/2025
// Sistema WG Easy - Grupo WG Almeida
// Corresponde às tabelas: projetos, cronograma_tarefas, projeto_equipes
// ============================================================

// ============================================================
// Tipos Enum
// ============================================================

export type StatusProjeto =
  | "pendente"
  | "em_andamento"
  | "concluido"
  | "cancelado"
  | "pausado";

export type StatusTarefa =
  | "pendente"
  | "em_andamento"
  | "concluido"
  | "atrasado"
  | "pausado"
  | "cancelado";

export type PrioridadeTarefa =
  | "baixa"
  | "media"
  | "alta"
  | "critica";

export type TipoPessoa =
  | "colaborador"
  | "fornecedor";

export type Nucleo =
  | "engenharia"
  | "arquitetura"
  | "marcenaria";

// ============================================================
// Interface: Projeto (tabela: projetos)
// ============================================================
export interface Projeto {
  id: string;

  // Relacionamentos
  contrato_id: string | null;
  cliente_id: string | null;

  // Informações básicas
  nome: string;
  descricao: string | null;
  nucleo: Nucleo | string;

  // Datas
  data_inicio: string | null; // DATE
  data_termino: string | null; // DATE

  // Status e progresso
  status: StatusProjeto;
  progresso: number; // 0-100

  // Auditoria
  created_at: string; // TIMESTAMPTZ
  updated_at: string; // TIMESTAMPTZ
}

// ============================================================
// Interface: Projeto Completo (com dados agregados)
// ============================================================
export interface ProjetoCompleto extends Projeto {
  // Dados do cliente (via JOIN)
  cliente_nome?: string;
  cliente_cpf?: string;
  cliente_telefone?: string;
  cliente_email?: string;

  // Dados do contrato (via JOIN)
  contrato_numero?: string;
  contrato_valor_total?: number;

  // Estatísticas calculadas
  total_tarefas?: number;
  tarefas_concluidas?: number;
  tarefas_em_andamento?: number;
  tarefas_pendentes?: number;
  tarefas_atrasadas?: number;

  // Tarefas (carregadas separadamente)
  tarefas?: CronogramaTarefa[];

  // Equipe (carregada separadamente)
  equipe?: ProjetoEquipe[];
}

// ============================================================
// Interface: Tarefa do Cronograma (tabela: cronograma_tarefas)
// ============================================================
export interface CronogramaTarefa {
  id: string;

  // Relacionamentos
  projeto_id: string;
  item_contrato_id: string | null;

  // Informações básicas
  titulo: string;
  descricao: string | null;
  categoria: string | null;
  nucleo: Nucleo | string | null;

  // Datas e duração
  data_inicio: string | null; // DATE
  data_termino: string | null; // DATE
  duracao_dias: number | null; // Calculado automaticamente pelo trigger

  // Dependências
  dependencias: string[] | null; // UUID[] - array de IDs de tarefas

  // Ordem e organização
  ordem: number;

  // Progresso e status
  progresso: number; // 0-100
  status: StatusTarefa;
  prioridade: PrioridadeTarefa;

  // Auditoria
  created_at: string; // TIMESTAMPTZ
  updated_at: string; // TIMESTAMPTZ
}

// ============================================================
// Interface: Tarefa Completa (com dados agregados)
// ============================================================
export interface CronogramaTarefaCompleta extends CronogramaTarefa {
  // Dados do item do contrato (via JOIN)
  item_descricao?: string;
  item_quantidade?: number;
  item_valor_unitario?: number;
  item_valor_total?: number;

  // Dados da equipe responsável
  responsaveis?: ProjetoEquipe[];

  // Indicadores calculados
  dias_restantes?: number | null;
  esta_atrasada?: boolean;
  percentual_tempo_decorrido?: number;
}

// ============================================================
// Interface: Equipe do Projeto (tabela: projeto_equipes)
// ============================================================
export interface ProjetoEquipe {
  id: string;

  // Relacionamentos
  projeto_id: string;
  tarefa_id: string | null; // Opcional - pode ser alocado só no projeto
  pessoa_id: string;

  // Informações do membro
  tipo_pessoa: TipoPessoa; // Preenchido automaticamente pelo trigger
  funcao: string | null; // Ex: pedreiro, eletricista, arquiteto
  is_responsavel: boolean;

  // Disponibilidade e custos
  horas_alocadas: number | null; // NUMERIC(10,2)
  custo_hora: number | null; // NUMERIC(10,2)

  // Período de alocação
  data_inicio_alocacao: string | null; // DATE
  data_fim_alocacao: string | null; // DATE

  // Auditoria
  data_atribuicao: string; // TIMESTAMPTZ
  created_at: string; // TIMESTAMPTZ
  updated_at: string; // TIMESTAMPTZ
}

// ============================================================
// Interface: Equipe Completa (via VIEW vw_projeto_equipes_completa)
// ============================================================
export interface ProjetoEquipeCompleta extends ProjetoEquipe {
  // Dados do projeto
  projeto_nome: string | null;

  // Dados da tarefa
  tarefa_titulo: string | null;

  // Dados da pessoa
  pessoa_nome: string | null;
  pessoa_tipo: string | null; // Do campo tipo da tabela pessoas
  pessoa_telefone?: string;
  pessoa_email?: string;
  pessoa_profissao?: string | null; // Profissão original da pessoa (pode diferir da funcao)

  // Cálculos
  custo_total?: number; // horas_alocadas * custo_hora
}

// ============================================================
// Interface: Formulário de Projeto
// ============================================================
export interface ProjetoFormData {
  contrato_id?: string;
  cliente_id?: string;
  nome: string;
  descricao?: string;
  nucleo: Nucleo | string;
  data_inicio?: string;
  data_termino?: string;
  status?: StatusProjeto;
}

// ============================================================
// Interface: Formulário de Tarefa
// ============================================================
export interface CronogramaTarefaFormData {
  projeto_id: string;
  item_contrato_id?: string;
  titulo: string;
  descricao?: string;
  categoria?: string;
  nucleo?: Nucleo | string;
  data_inicio?: string;
  data_termino?: string;
  dependencias?: string[];
  ordem?: number;
  progresso?: number;
  status?: StatusTarefa;
  prioridade?: PrioridadeTarefa;
}

// ============================================================
// Interface: Formulário de Equipe
// ============================================================
export interface ProjetoEquipeFormData {
  projeto_id: string;
  tarefa_id?: string;
  pessoa_id: string;
  tipo_pessoa?: TipoPessoa; // Opcional, será preenchido automaticamente
  funcao?: string;
  is_responsavel?: boolean;
  horas_alocadas?: number;
  custo_hora?: number;
  data_inicio_alocacao?: string;
  data_fim_alocacao?: string;
}

// ============================================================
// Interface: Filtros de Projetos
// ============================================================
export interface FiltrosProjetos {
  status?: StatusProjeto[];
  nucleo?: Nucleo[];
  cliente_id?: string;
  data_inicio?: string;
  data_fim?: string;
  busca?: string;
  mostrar_concluidos?: boolean;
}

// ============================================================
// Interface: Filtros de Tarefas
// ============================================================
export interface FiltrosTarefas {
  status?: StatusTarefa[];
  prioridade?: PrioridadeTarefa[];
  nucleo?: Nucleo[];
  categoria?: string[];
  mostrar_concluidas?: boolean;
  apenas_atrasadas?: boolean;
  data_inicio?: string;
  data_fim?: string;
}

// ============================================================
// Interface: Estatísticas do Cronograma
// ============================================================
export interface EstatisticasCronograma {
  // Projetos
  total_projetos: number;
  projetos_pendentes: number;
  projetos_em_andamento: number;
  projetos_concluidos: number;
  projetos_pausados: number;
  projetos_cancelados: number;

  // Tarefas
  total_tarefas: number;
  tarefas_pendentes: number;
  tarefas_em_andamento: number;
  tarefas_concluidas: number;
  tarefas_atrasadas: number;

  // Progresso geral
  progresso_medio_geral: number;

  // Por núcleo
  por_nucleo?: {
    nucleo: Nucleo | string;
    total_projetos: number;
    progresso_medio: number;
  }[];
}

// ============================================================
// Helpers e Labels
// ============================================================

export const STATUS_PROJETO_LABELS: Record<StatusProjeto, string> = {
  pendente: "Pendente",
  em_andamento: "Em Andamento",
  concluido: "Concluído",
  pausado: "Pausado",
  cancelado: "Cancelado",
};

export const STATUS_PROJETO_COLORS: Record<StatusProjeto, string> = {
  pendente: "#9CA3AF",
  em_andamento: "#3B82F6",
  concluido: "#10B981",
  pausado: "#F59E0B",
  cancelado: "#EF4444",
};

export const STATUS_PROJETO_ICONS: Record<StatusProjeto, string> = {
  pendente: "⏳",
  em_andamento: "🚀",
  concluido: "✅",
  pausado: "⏸️",
  cancelado: "❌",
};

export const STATUS_TAREFA_LABELS: Record<StatusTarefa, string> = {
  pendente: "Pendente",
  em_andamento: "Em Andamento",
  concluido: "Concluída",
  atrasado: "Atrasada",
  pausado: "Pausada",
  cancelado: "Cancelada",
};

export const STATUS_TAREFA_COLORS: Record<StatusTarefa, string> = {
  pendente: "#9CA3AF",
  em_andamento: "#3B82F6",
  concluido: "#10B981",
  atrasado: "#EF4444",
  pausado: "#F59E0B",
  cancelado: "#6B7280",
};

export const STATUS_TAREFA_ICONS: Record<StatusTarefa, string> = {
  pendente: "⏳",
  em_andamento: "🔄",
  concluido: "✅",
  atrasado: "🚨",
  pausado: "⏸️",
  cancelado: "❌",
};

export const PRIORIDADE_LABELS: Record<PrioridadeTarefa, string> = {
  baixa: "Baixa",
  media: "Média",
  alta: "Alta",
  critica: "Crítica",
};

export const PRIORIDADE_COLORS: Record<PrioridadeTarefa, string> = {
  baixa: "#9CA3AF",
  media: "#3B82F6",
  alta: "#F59E0B",
  critica: "#EF4444",
};

export const PRIORIDADE_ICONS: Record<PrioridadeTarefa, string> = {
  baixa: "⬇️",
  media: "➡️",
  alta: "⬆️",
  critica: "🔥",
};

export const NUCLEO_LABELS: Record<string, string> = {
  engenharia: "Engenharia",
  arquitetura: "Arquitetura",
  marcenaria: "Marcenaria",
};

export const NUCLEO_COLORS: Record<string, string> = {
  engenharia: "#3B82F6",
  arquitetura: "#8B5CF6",
  marcenaria: "#F59E0B",
};

export const NUCLEO_ICONS: Record<string, string> = {
  engenharia: "🏗️",
  arquitetura: "🏛️",
  marcenaria: "🪚",
};

export const TIPO_PESSOA_LABELS: Record<TipoPessoa, string> = {
  colaborador: "Colaborador",
  fornecedor: "Fornecedor",
};

export const TIPO_PESSOA_ICONS: Record<TipoPessoa, string> = {
  colaborador: "👷",
  fornecedor: "🏢",
};

// ============================================================
// Funções Utilitárias
// ============================================================

export function calcularProgressoProjeto(projeto: ProjetoCompleto): number {
  if (!projeto.total_tarefas || projeto.total_tarefas === 0) {
    return projeto.progresso || 0;
  }
  return Math.round((projeto.tarefas_concluidas || 0) / projeto.total_tarefas * 100);
}

export function calcularDiasRestantes(tarefa: CronogramaTarefa): number | null {
  if (!tarefa.data_termino) return null;
  if (tarefa.status === "concluido" || tarefa.status === "cancelado") return null;

  const hoje = new Date();
  const dataTermino = new Date(tarefa.data_termino);
  const diff = dataTermino.getTime() - hoje.getTime();

  return Math.ceil(diff / (1000 * 60 * 60 * 24));
}

export function tarefaEstaAtrasada(tarefa: CronogramaTarefa): boolean {
  if (!tarefa.data_termino) return false;
  if (tarefa.status === "concluido" || tarefa.status === "cancelado") return false;

  const hoje = new Date();
  const dataTermino = new Date(tarefa.data_termino);

  return hoje > dataTermino;
}

export function calcularPercentualTempoDecorrido(tarefa: CronogramaTarefa): number | null {
  if (!tarefa.data_inicio || !tarefa.data_termino) return null;

  const hoje = new Date();
  const inicio = new Date(tarefa.data_inicio);
  const termino = new Date(tarefa.data_termino);

  if (hoje < inicio) return 0;
  if (hoje > termino) return 100;

  const totalDias = (termino.getTime() - inicio.getTime()) / (1000 * 60 * 60 * 24);
  const diasDecorridos = (hoje.getTime() - inicio.getTime()) / (1000 * 60 * 60 * 24);

  return Math.round((diasDecorridos / totalDias) * 100);
}

export function calcularCustoTotal(equipe: ProjetoEquipe): number | null {
  if (!equipe.horas_alocadas || !equipe.custo_hora) return null;
  return equipe.horas_alocadas * equipe.custo_hora;
}

export function formatarData(data?: string | null): string {
  if (!data) return "-";
  const date = new Date(data);
  return date.toLocaleDateString("pt-BR");
}

export function formatarDataHora(data?: string | null): string {
  if (!data) return "-";
  const date = new Date(data);
  return date.toLocaleString("pt-BR");
}

export function formatarValor(valor?: number | null): string {
  if (typeof valor !== "number" || isNaN(valor)) return "R$ 0,00";
  return valor.toLocaleString("pt-BR", {
    style: "currency",
    currency: "BRL",
  });
}

export function formatarDuracao(dias?: number | null): string {
  if (typeof dias !== "number" || isNaN(dias)) return "-";
  if (dias === 1) return "1 dia";
  return `${dias} dias`;
}

export function getStatusProjetoLabel(status: StatusProjeto): string {
  return STATUS_PROJETO_LABELS[status] || status;
}

export function getStatusProjetoColor(status: StatusProjeto): string {
  return STATUS_PROJETO_COLORS[status] || "#9CA3AF";
}

export function getStatusProjetoIcon(status: StatusProjeto): string {
  return STATUS_PROJETO_ICONS[status] || "📋";
}

export function getStatusTarefaLabel(status: StatusTarefa): string {
  return STATUS_TAREFA_LABELS[status] || status;
}

export function getStatusTarefaColor(status: StatusTarefa): string {
  return STATUS_TAREFA_COLORS[status] || "#9CA3AF";
}

export function getStatusTarefaIcon(status: StatusTarefa): string {
  return STATUS_TAREFA_ICONS[status] || "📋";
}

export function getPrioridadeLabel(prioridade: PrioridadeTarefa): string {
  return PRIORIDADE_LABELS[prioridade] || prioridade;
}

export function getPrioridadeColor(prioridade: PrioridadeTarefa): string {
  return PRIORIDADE_COLORS[prioridade] || "#9CA3AF";
}

export function getPrioridadeIcon(prioridade: PrioridadeTarefa): string {
  return PRIORIDADE_ICONS[prioridade] || "➡️";
}

export function getNucleoLabel(nucleo: string): string {
  return NUCLEO_LABELS[nucleo] || nucleo;
}

export function getNucleoColor(nucleo: string): string {
  return NUCLEO_COLORS[nucleo] || "#9CA3AF";
}

export function getNucleoIcon(nucleo: string): string {
  return NUCLEO_ICONS[nucleo] || "📋";
}

export function getTipoPessoaLabel(tipo: TipoPessoa): string {
  return TIPO_PESSOA_LABELS[tipo] || tipo;
}

export function getTipoPessoaIcon(tipo: TipoPessoa): string {
  return TIPO_PESSOA_ICONS[tipo] || "👤";
}

// ============================================================
// Helpers de Categoria
// ============================================================

// Mapa de cores por categoria (genérico)
const CATEGORIA_COLORS: Record<string, string> = {
  fundacao: "#8B5CF6",
  estrutura: "#3B82F6",
  alvenaria: "#F59E0B",
  instalacoes: "#10B981",
  acabamento: "#EC4899",
  pintura: "#6366F1",
  default: "#9CA3AF",
};

// Mapa de ícones por categoria (genérico)
const CATEGORIA_ICONS: Record<string, string> = {
  fundacao: "🏗️",
  estrutura: "🏢",
  alvenaria: "🧱",
  instalacoes: "⚡",
  acabamento: "✨",
  pintura: "🎨",
  default: "📋",
};

export function getCategoriaColor(categoria: string | null | undefined): string {
  if (!categoria) return CATEGORIA_COLORS.default;
  const key = categoria.toLowerCase().replace(/\s+/g, "");
  return CATEGORIA_COLORS[key] || CATEGORIA_COLORS.default;
}

export function getCategoriaIcon(categoria: string | null | undefined): string {
  if (!categoria) return CATEGORIA_ICONS.default;
  const key = categoria.toLowerCase().replace(/\s+/g, "");
  return CATEGORIA_ICONS[key] || CATEGORIA_ICONS.default;
}

// ============================================================
// Validação
// ============================================================

export function validarProjeto(projeto: ProjetoFormData): string[] {
  const erros: string[] = [];

  if (!projeto.nome || projeto.nome.trim() === "") {
    erros.push("Nome do projeto é obrigatório");
  }

  if (!projeto.nucleo) {
    erros.push("Núcleo é obrigatório");
  }

  if (projeto.data_inicio && projeto.data_termino) {
    const inicio = new Date(projeto.data_inicio);
    const termino = new Date(projeto.data_termino);

    if (termino <= inicio) {
      erros.push("Data de término deve ser posterior à data de início");
    }
  }

  return erros;
}

export function validarTarefa(tarefa: CronogramaTarefaFormData): string[] {
  const erros: string[] = [];

  if (!tarefa.titulo || tarefa.titulo.trim() === "") {
    erros.push("Título da tarefa é obrigatório");
  }

  if (!tarefa.projeto_id) {
    erros.push("Projeto é obrigatório");
  }

  if (tarefa.progresso !== undefined && (tarefa.progresso < 0 || tarefa.progresso > 100)) {
    erros.push("Progresso deve estar entre 0 e 100");
  }

  if (tarefa.data_inicio && tarefa.data_termino) {
    const inicio = new Date(tarefa.data_inicio);
    const termino = new Date(tarefa.data_termino);

    if (termino <= inicio) {
      erros.push("Data de término deve ser posterior à data de início");
    }
  }

  return erros;
}

export function validarEquipe(equipe: ProjetoEquipeFormData): string[] {
  const erros: string[] = [];

  if (!equipe.projeto_id) {
    erros.push("Projeto é obrigatório");
  }

  if (!equipe.pessoa_id) {
    erros.push("Pessoa é obrigatória");
  }

  if (equipe.horas_alocadas !== undefined && equipe.horas_alocadas < 0) {
    erros.push("Horas alocadas deve ser maior ou igual a zero");
  }

  if (equipe.custo_hora !== undefined && equipe.custo_hora < 0) {
    erros.push("Custo por hora deve ser maior ou igual a zero");
  }

  if (equipe.data_inicio_alocacao && equipe.data_fim_alocacao) {
    const inicio = new Date(equipe.data_inicio_alocacao);
    const fim = new Date(equipe.data_fim_alocacao);

    if (fim <= inicio) {
      erros.push("Data de fim da alocação deve ser posterior à data de início");
    }
  }

  return erros;
}

// ============================================================
// Helpers de Ordenação para Drag and Drop
// ============================================================

export function reordenarTarefas(
  tarefas: CronogramaTarefa[],
  tarefaId: string,
  novaOrdem: number
): CronogramaTarefa[] {
  const tarefasOrdenadas = [...tarefas].sort((a, b) => a.ordem - b.ordem);

  const tarefaIndex = tarefasOrdenadas.findIndex(t => t.id === tarefaId);
  if (tarefaIndex === -1) return tarefas;

  const [tarefaMovida] = tarefasOrdenadas.splice(tarefaIndex, 1);
  tarefasOrdenadas.splice(novaOrdem, 0, tarefaMovida);

  // Atualizar ordem de todas as tarefas
  return tarefasOrdenadas.map((tarefa, index) => ({
    ...tarefa,
    ordem: index + 1,
  }));
}

// ============================================================
// Helpers para Dependências
// ============================================================

export function adicionarDependencia(
  tarefa: CronogramaTarefa,
  dependenciaId: string
): CronogramaTarefa {
  const dependencias = tarefa.dependencias || [];

  if (dependencias.includes(dependenciaId)) {
    return tarefa; // Já existe
  }

  return {
    ...tarefa,
    dependencias: [...dependencias, dependenciaId],
  };
}

export function removerDependencia(
  tarefa: CronogramaTarefa,
  dependenciaId: string
): CronogramaTarefa {
  const dependencias = tarefa.dependencias || [];

  return {
    ...tarefa,
    dependencias: dependencias.filter(id => id !== dependenciaId),
  };
}

export function verificarDependenciasConcluidas(
  tarefa: CronogramaTarefa,
  todasTarefas: CronogramaTarefa[]
): boolean {
  if (!tarefa.dependencias || tarefa.dependencias.length === 0) {
    return true; // Sem dependências
  }

  const tarefasDependentes = todasTarefas.filter(t =>
    tarefa.dependencias?.includes(t.id)
  );

  return tarefasDependentes.every(t => t.status === "concluido");
}

export function obterTarefasDependentes(
  tarefaId: string,
  todasTarefas: CronogramaTarefa[]
): CronogramaTarefa[] {
  return todasTarefas.filter(t =>
    t.dependencias?.includes(tarefaId)
  );
}
