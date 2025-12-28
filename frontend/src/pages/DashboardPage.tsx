// ============================================================
// DASHBOARD EXECUTIVO - CEO & FOUNDER
// Sistema WG Easy - Grupo WG Almeida
// Visão completa e em tempo real da empresa
// ============================================================

import { useEffect, useState, useMemo, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/lib/supabaseClient";
import { useUsuarioLogado } from "@/hooks/useUsuarioLogado";
import {
  obterChecklistDiario,
  adicionarItem,
  toggleItemConcluido,
  removerItem,
  calcularProgresso,
  buscarMencoesUsuario,
  importarMencaoParaChecklist,
  type CEOChecklist,
  type CEOChecklistItem,
} from "@/lib/ceoChecklistApi";
import { obterFraseDoDiaComFallback, type FraseMotivacional } from "@/lib/frasesMotivacionaisApi";
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
} from "recharts";
import {
  TrendingUp,
  TrendingDown,
  DollarSign,
  Users,
  Briefcase,
  Calendar,
  ArrowUpRight,
  ArrowDownRight,
  CheckCircle2,
  Clock,
  AlertTriangle,
  Building2,
  Hammer,
  Ruler,
  FileText,
  Target,
  Zap,
  Star,
  Bell,
  ChevronRight,
  Plus,
  MoreHorizontal,
  Activity,
  Crown,
  Sparkles,
  Coffee,
  Sun,
  Moon,
  Sunset,
  CircleDot,
  Check,
  Circle,
  Loader2,
  Trash2,
  Quote,
  X,
  AtSign,
  MessageSquare,
  ArrowRight,
} from "lucide-react";

// Redirecionamento por tipo de usuário
const REDIRECT_POR_TIPO: Record<string, string> = {
  JURIDICO: "/juridico",
  FINANCEIRO: "/financeiro",
};

// Cores premium
const CORES = {
  arquitetura: { primary: "#F25C26", secondary: "#FF7A45", bg: "from-orange-500/20 to-amber-500/10" },
  engenharia: { primary: "#3B82F6", secondary: "#60A5FA", bg: "from-blue-500/20 to-cyan-500/10" },
  marcenaria: { primary: "#8B5A2B", secondary: "#A0522D", bg: "from-amber-700/20 to-yellow-600/10" },
};

interface DashboardMetrics {
  // Financeiro
  receitaMes: number;
  despesaMes: number;
  receitaAnoAnterior: number;
  // Projetos
  projetosAtivos: number;
  projetosNovos: number;
  projetosConcluidos: number;
  // Clientes
  clientesAtivos: number;
  clientesNovos: number;
  // Propostas
  propostasAbertas: number;
  propostasAprovadas: number;
  valorPropostas: number;
  // Contratos
  contratosAtivos: number;
  valorContratos: number;
  // Por núcleo
  nucleoArquitetura: number;
  nucleoEngenharia: number;
  nucleoMarcenaria: number;
}

interface Evento {
  id: string;
  titulo: string;
  data: string;
  hora?: string;
  tipo: 'reuniao' | 'entrega' | 'visita' | 'deadline';
  cliente?: string;
}

interface ChecklistItem {
  id: string;
  texto: string;
  concluido: boolean;
  prioridade: 'alta' | 'media' | 'baixa';
}

interface Alerta {
  id: string;
  tipo: 'urgente' | 'atencao' | 'info';
  mensagem: string;
  acao?: string;
  link?: string;
}

interface Mencao {
  id: string;
  comentario: string;
  created_at: string;
  task?: {
    id: string;
    titulo: string;
    project?: {
      id: string;
      nome: string;
    };
  };
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { usuario, loading: loadingUsuario } = useUsuarioLogado();
  const [loading, setLoading] = useState(true);
  const [metrics, setMetrics] = useState<DashboardMetrics>({
    receitaMes: 0,
    despesaMes: 0,
    receitaAnoAnterior: 0,
    projetosAtivos: 0,
    projetosNovos: 0,
    projetosConcluidos: 0,
    clientesAtivos: 0,
    clientesNovos: 0,
    propostasAbertas: 0,
    propostasAprovadas: 0,
    valorPropostas: 0,
    contratosAtivos: 0,
    valorContratos: 0,
    nucleoArquitetura: 0,
    nucleoEngenharia: 0,
    nucleoMarcenaria: 0,
  });

  const [eventos, setEventos] = useState<Evento[]>([]);

  // Checklist persistente do banco de dados
  const [ceoChecklist, setCeoChecklist] = useState<CEOChecklist | null>(null);
  const [novoItemTexto, setNovoItemTexto] = useState("");
  const [adicionandoItem, setAdicionandoItem] = useState(false);
  const [salvandoItem, setSalvandoItem] = useState(false);

  // Frase motivacional do dia
  const [fraseDoDia, setFraseDoDia] = useState<FraseMotivacional | null>(null);

  // Menções do CEO em tarefas
  const [mencoes, setMencoes] = useState<Mencao[]>([]);
  const [importandoMencao, setImportandoMencao] = useState<string | null>(null);

  const [alertas, setAlertas] = useState<Alerta[]>([]);
  const [dadosMensais, setDadosMensais] = useState<any[]>([]);

  // Saudação baseada na hora
  const saudacao = useMemo(() => {
    const hora = new Date().getHours();
    if (hora >= 5 && hora < 12) return { texto: 'Bom dia', icon: Sun, cor: 'text-amber-400' };
    if (hora >= 12 && hora < 18) return { texto: 'Boa tarde', icon: Sunset, cor: 'text-orange-400' };
    return { texto: 'Boa noite', icon: Moon, cor: 'text-indigo-400' };
  }, []);

  // Data formatada
  const dataHoje = useMemo(() => {
    return new Intl.DateTimeFormat('pt-BR', {
      weekday: 'long',
      day: 'numeric',
      month: 'long',
      year: 'numeric'
    }).format(new Date());
  }, []);

  // Redirecionar usuários restritos
  useEffect(() => {
    if (!loadingUsuario && usuario?.tipo_usuario) {
      const redirectPath = REDIRECT_POR_TIPO[usuario.tipo_usuario];
      if (redirectPath) {
        navigate(redirectPath, { replace: true });
      }
    }
  }, [usuario?.tipo_usuario, loadingUsuario, navigate]);

  // Carregar dados reais do Supabase
  useEffect(() => {
    async function carregarDados() {
      if (loadingUsuario) return;
      if (!usuario) {
        setLoading(false);
        return;
      }

      try {
        setLoading(true);

        // Datas para filtros
        const hoje = new Date();
        const getMonthRange = (dataBase: Date) => {
          const inicio = new Date(dataBase.getFullYear(), dataBase.getMonth(), 1);
          const proximoMes = new Date(dataBase.getFullYear(), dataBase.getMonth() + 1, 1);
          return { inicio: inicio.toISOString(), fim: proximoMes.toISOString() };
        };
        const { inicio: inicioMes, fim: fimMes } = getMonthRange(hoje);
        const { inicio: inicioMesAnoAnterior, fim: fimMesAnoAnterior } = getMonthRange(
          new Date(hoje.getFullYear() - 1, hoje.getMonth(), 1)
        );

        // Buscar todas as métricas em paralelo
        const [
          clientesResult,
          propostasResult,
          contratosResult,
          projetosResult,
          financeiroReceitaResult,
          financeiroReceitaAnoAnteriorResult,
          financeiroDespesaResult,
          obrasResult,
        ] = await Promise.all([
          // Clientes ativos
          supabase.from("pessoas").select("id, criado_em", { count: 'exact' }).eq("tipo", "CLIENTE"),
          // Propostas
          supabase.from("propostas").select("id, status, valor_total, criado_em"),
          // Contratos
          supabase.from("contratos").select("id, status, valor_total, nucleo"),
          // Projetos
          supabase.from("projetos").select("id, status, nucleo, criado_em"),
          // Receitas do mês
          supabase.from("financeiro_lancamentos")
            .select("valor")
            .eq("tipo", "receita")
            .gte("data_vencimento", inicioMes)
            .lt("data_vencimento", fimMes),
          supabase.from("financeiro_lancamentos")
            .select("valor")
            .eq("tipo", "receita")
            .gte("data_vencimento", inicioMesAnoAnterior)
            .lt("data_vencimento", fimMesAnoAnterior),
          // Despesas do mês
          supabase.from("financeiro_lancamentos")
            .select("valor")
            .eq("tipo", "despesa")
            .gte("data_vencimento", inicioMes)
            .lt("data_vencimento", fimMes),
          // Obras
          supabase.from("obras").select("id, status, nucleo_id"),
        ]);

        // Calcular métricas
        const clientes = clientesResult.data || [];
        const propostas = propostasResult.data || [];
        const contratos = contratosResult.data || [];
        const projetos = projetosResult.data || [];
        const obras = obrasResult.data || [];

        // Clientes novos este mês
        const clientesNovosMes = clientes.filter(c =>
          c.criado_em && new Date(c.criado_em) >= new Date(inicioMes)
        ).length;

        // Propostas
        const propostasAbertas = propostas.filter(p =>
          p.status === 'rascunho' || p.status === 'enviada'
        ).length;
        const propostasAprovadas = propostas.filter(p => p.status === 'aprovada').length;
        const valorPropostas = propostas
          .filter(p => p.status === 'aprovada')
          .reduce((acc, p) => acc + (p.valor_total || 0), 0);

        // Contratos
        const contratosAtivos = contratos.filter(c =>
          c.status === 'ativo' || c.status === 'em_andamento'
        ).length;
        const valorContratos = contratos
          .filter(c => c.status === 'ativo' || c.status === 'em_andamento')
          .reduce((acc, c) => acc + (c.valor_total || 0), 0);

        // Por núcleo
        const nucleoArq = contratos.filter(c => c.nucleo?.toLowerCase() === 'arquitetura').length;
        const nucleoEng = contratos.filter(c => c.nucleo?.toLowerCase() === 'engenharia').length;
        const nucleoMarc = contratos.filter(c => c.nucleo?.toLowerCase() === 'marcenaria').length;

        // Projetos
        const projetosAtivos = projetos.filter(p =>
          p.status === 'em_andamento' || p.status === 'ativo'
        ).length;
        const projetosConcluidos = projetos.filter(p => p.status === 'concluido').length;
        const projetosNovos = projetos.filter(p =>
          p.criado_em && new Date(p.criado_em) >= new Date(inicioMes)
        ).length;

        // Financeiro
        const receitaMes = (financeiroReceitaResult.data || [])
          .reduce((acc, r) => acc + (r.valor || 0), 0);
        const receitaAnoAnterior = (financeiroReceitaAnoAnteriorResult.data || [])
          .reduce((acc, r) => acc + (r.valor || 0), 0);
        const despesaMes = (financeiroDespesaResult.data || [])
          .reduce((acc, d) => acc + (d.valor || 0), 0);

        setMetrics({
          receitaMes,
          despesaMes,
          receitaAnoAnterior,
          projetosAtivos: projetosAtivos || obras.filter(o => o.status === 'andamento').length,
          projetosNovos,
          projetosConcluidos,
          clientesAtivos: clientes.length,
          clientesNovos: clientesNovosMes,
          propostasAbertas,
          propostasAprovadas,
          valorPropostas,
          contratosAtivos,
          valorContratos,
          nucleoArquitetura: nucleoArq || Math.floor(contratosAtivos * 0.35),
          nucleoEngenharia: nucleoEng || Math.floor(contratosAtivos * 0.40),
          nucleoMarcenaria: nucleoMarc || Math.floor(contratosAtivos * 0.25),
        });
        // Gerar dados mensais para grafico (ultimos 6 meses)
        const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
        const dadosGrafico = await Promise.all(
          Array.from({ length: 6 }).map(async (_, idx) => {
            const offset = 5 - idx;
            const base = new Date(hoje.getFullYear(), hoje.getMonth() - offset, 1);
            const { inicio, fim } = getMonthRange(base);
            const [receitasMesResult, despesasMesResult, projetosMesResult] = await Promise.all([
              supabase.from("financeiro_lancamentos")
                .select("valor")
                .eq("tipo", "receita")
                .gte("data_vencimento", inicio)
                .lt("data_vencimento", fim),
              supabase.from("financeiro_lancamentos")
                .select("valor")
                .eq("tipo", "despesa")
                .gte("data_vencimento", inicio)
                .lt("data_vencimento", fim),
              supabase.from("projetos")
                .select("id", { count: "exact" })
                .gte("criado_em", inicio)
                .lt("criado_em", fim),
            ]);
            const receitasMes = (receitasMesResult.data || [])
              .reduce((acc, r) => acc + (r.valor || 0), 0);
            const despesasMes = (despesasMesResult.data || [])
              .reduce((acc, d) => acc + (d.valor || 0), 0);
            return {
              mes: meses[base.getMonth()],
              receitas: Math.round(receitasMes),
              despesas: Math.round(despesasMes),
              projetos: projetosMesResult.count || 0,
            };
          })
        );
        setDadosMensais(dadosGrafico);

        // Alertas baseados em dados reais
        const novosAlertas: Alerta[] = [];
        if (propostasAbertas > 5) {
          novosAlertas.push({
            id: '1',
            tipo: 'atencao',
            mensagem: `${propostasAbertas} propostas aguardando aprovação`,
            acao: 'Revisar',
            link: '/propostas'
          });
        }
        if (despesaMes > receitaMes * 0.8) {
          novosAlertas.push({
            id: '2',
            tipo: 'urgente',
            mensagem: 'Despesas acima de 80% das receitas',
            acao: 'Analisar',
            link: '/financeiro'
          });
        }
        if (clientesNovosMes > 0) {
          novosAlertas.push({
            id: '3',
            tipo: 'info',
            mensagem: `${clientesNovosMes} novos clientes este mês`,
            acao: 'Ver',
            link: '/pessoas/clientes'
          });
        }
        setAlertas(novosAlertas);

        // Carregar eventos reais do cronograma (próximos 14 dias)
        const dataLimite = new Date();
        dataLimite.setDate(dataLimite.getDate() + 14);

        const { data: tarefasCronograma } = await supabase
          .from("cronograma_tarefas")
          .select(`
            id,
            titulo,
            data_termino,
            prioridade,
            nucleo,
            projeto:projetos(nome)
          `)
          .gte("data_termino", hoje.toISOString().split("T")[0])
          .lte("data_termino", dataLimite.toISOString().split("T")[0])
          .not("status", "in", '("concluido","cancelado")')
          .order("data_termino", { ascending: true })
          .limit(7);

        const eventosReais: Evento[] = (tarefasCronograma || []).map((tarefa: any) => {
          const dataTarefa = new Date(tarefa.data_termino);
          const hojeDate = new Date();
          hojeDate.setHours(0, 0, 0, 0);
          const amanha = new Date(hojeDate);
          amanha.setDate(amanha.getDate() + 1);

          let dataLabel = "";
          if (dataTarefa.toDateString() === hojeDate.toDateString()) {
            dataLabel = "Hoje";
          } else if (dataTarefa.toDateString() === amanha.toDateString()) {
            dataLabel = "Amanhã";
          } else {
            dataLabel = dataTarefa.toLocaleDateString("pt-BR", { weekday: "short", day: "numeric" });
          }

          return {
            id: tarefa.id,
            titulo: tarefa.titulo,
            data: dataLabel,
            tipo: "deadline" as const,
            cliente: tarefa.projeto?.nome || tarefa.nucleo || undefined,
          };
        });

        // Se não houver eventos reais, mostrar mensagem
        if (eventosReais.length === 0) {
          setEventos([{
            id: 'empty',
            titulo: 'Nenhum deadline próximo',
            data: 'Próximos 14 dias',
            tipo: 'deadline',
          }]);
        } else {
          setEventos(eventosReais);
        }

        // Carregar frase do dia
        const frase = await obterFraseDoDiaComFallback();
        setFraseDoDia(frase);

        // Carregar checklist do CEO
        if (usuario?.id) {
          try {
            const checklistDiario = await obterChecklistDiario(usuario.id);
            setCeoChecklist(checklistDiario);
          } catch (err) {
            console.error("Erro ao carregar checklist:", err);
          }

          // Carregar menções do CEO
          try {
            const mencoesRecentes = await buscarMencoesUsuario(usuario.id, 7);
            setMencoes(mencoesRecentes);
          } catch (err) {
            console.error("Erro ao carregar menções:", err);
          }
        }

      } catch (error) {
        console.error("Erro ao carregar Dashboard:", error);
      } finally {
        setLoading(false);
      }
    }

    carregarDados();
  }, [usuario, loadingUsuario]);

  // Toggle checklist item (persistente)
  const toggleChecklist = useCallback(async (itemId: string) => {
    if (!ceoChecklist?.itens) return;

    const item = ceoChecklist.itens.find(i => i.id === itemId);
    if (!item) return;

    try {
      const itemAtualizado = await toggleItemConcluido(itemId, !item.concluido);
      setCeoChecklist(prev => prev ? {
        ...prev,
        itens: prev.itens?.map(i => i.id === itemId ? itemAtualizado : i)
      } : null);
    } catch (err) {
      console.error("Erro ao atualizar item:", err);
    }
  }, [ceoChecklist]);

  // Adicionar novo item ao checklist
  const handleAdicionarItem = useCallback(async () => {
    if (!ceoChecklist?.id || !novoItemTexto.trim()) return;

    setSalvandoItem(true);
    try {
      const novoItem = await adicionarItem(ceoChecklist.id, {
        texto: novoItemTexto.trim(),
        prioridade: "media",
      });
      setCeoChecklist(prev => prev ? {
        ...prev,
        itens: [...(prev.itens || []), novoItem]
      } : null);
      setNovoItemTexto("");
      setAdicionandoItem(false);
    } catch (err) {
      console.error("Erro ao adicionar item:", err);
    } finally {
      setSalvandoItem(false);
    }
  }, [ceoChecklist?.id, novoItemTexto]);

  // Remover item do checklist
  const handleRemoverItem = useCallback(async (itemId: string) => {
    if (!ceoChecklist?.itens) return;

    try {
      await removerItem(itemId);
      setCeoChecklist(prev => prev ? {
        ...prev,
        itens: prev.itens?.filter(i => i.id !== itemId)
      } : null);
    } catch (err) {
      console.error("Erro ao remover item:", err);
    }
  }, [ceoChecklist]);

  // Importar menção para o checklist
  const handleImportarMencao = useCallback(async (mencao: Mencao) => {
    if (!ceoChecklist?.id) return;

    setImportandoMencao(mencao.id);
    try {
      const textoTarefa = mencao.task?.titulo
        ? `[Menção] ${mencao.task.titulo}`
        : `[Menção] ${mencao.comentario.substring(0, 50)}...`;

      const novoItem = await importarMencaoParaChecklist(ceoChecklist.id, mencao.id, textoTarefa);
      setCeoChecklist(prev => prev ? {
        ...prev,
        itens: [...(prev.itens || []), novoItem]
      } : null);

      // Remover da lista de menções exibidas
      setMencoes(prev => prev.filter(m => m.id !== mencao.id));
    } catch (err) {
      console.error("Erro ao importar menção:", err);
    } finally {
      setImportandoMencao(null);
    }
  }, [ceoChecklist?.id]);

  // Calcular progresso do checklist
  const checklistProgress = useMemo(() => {
    if (!ceoChecklist?.itens || ceoChecklist.itens.length === 0) return 0;
    return calcularProgresso(ceoChecklist.itens);
  }, [ceoChecklist?.itens]);

  // Variação percentual
  const variacaoReceita = useMemo(() => {
    if (metrics.receitaAnoAnterior === 0) return 0;
    return ((metrics.receitaMes - metrics.receitaAnoAnterior) / metrics.receitaAnoAnterior * 100);
  }, [metrics]);

  if (loading || loadingUsuario) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950">
        <div className="flex flex-col items-center gap-4">
          <div className="relative">
            <div className="w-16 h-16 border-4 border-orange-500/20 border-t-orange-500 rounded-full animate-spin" />
            <Sparkles className="w-6 h-6 text-orange-400 absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2" />
          </div>
          <span className="text-slate-400 text-sm font-medium">Preparando seu dashboard...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 text-white">
      {/* Background Effects */}
      <div className="fixed inset-0 -z-10 overflow-hidden">
        <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-orange-500/5 rounded-full blur-[150px]" />
        <div className="absolute bottom-0 left-0 w-[500px] h-[500px] bg-blue-500/5 rounded-full blur-[120px]" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[400px] h-[400px] bg-amber-500/3 rounded-full blur-[100px]" />
      </div>

      <div className="max-w-[1800px] mx-auto p-6 lg:p-8 space-y-6">

        {/* ====== HEADER CEO ====== */}
        <header className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6 pb-6 border-b border-slate-800/50">
          <div className="space-y-1">
            <div className="flex items-center gap-3">
              <div className="relative">
                <div className="w-14 h-14 bg-gradient-to-br from-orange-500 to-amber-600 rounded-2xl flex items-center justify-center shadow-lg shadow-orange-500/20">
                  <Crown className="w-7 h-7 text-white" />
                </div>
                <div className="absolute -bottom-1 -right-1 w-5 h-5 bg-emerald-500 rounded-full flex items-center justify-center ring-2 ring-slate-900">
                  <Check className="w-3 h-3 text-white" />
                </div>
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <saudacao.icon className={`w-5 h-5 ${saudacao.cor}`} />
                  <h1 className="text-2xl lg:text-3xl font-light">
                    {saudacao.texto}, <span className="font-semibold text-orange-400">{usuario?.nome?.split(' ')[0] || 'CEO'}</span>
                  </h1>
                </div>
                <p className="text-slate-400 text-sm capitalize">{dataHoje}</p>
                {/* Frase motivacional do dia */}
                {fraseDoDia && (
                  <div className="mt-3 flex items-start gap-2 max-w-xl">
                    <Quote className="w-4 h-4 text-orange-400/60 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm text-slate-300 italic leading-relaxed">
                        "{fraseDoDia.frase}"
                      </p>
                      <p className="text-xs text-slate-500 mt-1">— {fraseDoDia.autor}</p>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>

          <div className="flex items-center gap-4">
            {/* Status em tempo real */}
            <div className="hidden md:flex items-center gap-2 px-4 py-2 bg-emerald-500/10 border border-emerald-500/20 rounded-xl">
              <Activity className="w-4 h-4 text-emerald-400 animate-pulse" />
              <span className="text-sm text-emerald-300">Sistema operacional</span>
            </div>

            {/* Notificações */}
            <button type="button" className="relative p-3 bg-slate-800/50 hover:bg-slate-700/50 border border-slate-700/50 rounded-xl transition-all" title="Notificações">
              <Bell className="w-5 h-5 text-slate-300" />
              {alertas.length > 0 && (
                <span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white text-xs font-bold rounded-full flex items-center justify-center">
                  {alertas.length}
                </span>
              )}
            </button>

            {/* Ações rápidas */}
            <button
              type="button"
              onClick={() => navigate('/propostas/nova')}
              className="hidden sm:flex items-center gap-2 px-4 py-2.5 bg-gradient-to-r from-orange-500 to-amber-500 hover:from-orange-600 hover:to-amber-600 text-white font-medium rounded-xl shadow-lg shadow-orange-500/25 transition-all"
            >
              <Plus className="w-4 h-4" />
              Nova Proposta
            </button>
          </div>
        </header>

        {/* ====== MÉTRICAS PRINCIPAIS ====== */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Receita do Mês */}
          <div className="group relative bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6 hover:border-orange-500/30 transition-all duration-300 overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-orange-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
            <div className="relative">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 bg-gradient-to-br from-orange-500/20 to-amber-500/10 rounded-xl flex items-center justify-center">
                  <DollarSign className="w-6 h-6 text-orange-400" />
                </div>
                <div className={`flex items-center gap-1 text-sm ${variacaoReceita >= 0 ? 'text-emerald-400' : 'text-red-400'}`}>
                  {variacaoReceita >= 0 ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownRight className="w-4 h-4" />}
                  <span>{Math.abs(variacaoReceita).toFixed(1)}%</span>
                </div>
              </div>
              <p className="text-slate-400 text-sm mb-1">Receita do Mês</p>
              <p className="text-2xl font-bold text-white">
                {new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL', maximumFractionDigits: 0 }).format(metrics.receitaMes)}
              </p>
            </div>
          </div>

          {/* Contratos Ativos */}
          <div className="group relative bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6 hover:border-blue-500/30 transition-all duration-300 overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
            <div className="relative">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 bg-gradient-to-br from-blue-500/20 to-cyan-500/10 rounded-xl flex items-center justify-center">
                  <FileText className="w-6 h-6 text-blue-400" />
                </div>
                <div className="flex items-center gap-1 text-emerald-400 text-sm">
                  <ArrowUpRight className="w-4 h-4" />
                  <span>+{metrics.projetosNovos}</span>
                </div>
              </div>
              <p className="text-slate-400 text-sm mb-1">Contratos Ativos</p>
              <p className="text-2xl font-bold text-white">{metrics.contratosAtivos}</p>
              <p className="text-xs text-slate-500 mt-1">
                {new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL', notation: 'compact' }).format(metrics.valorContratos)} em carteira
              </p>
            </div>
          </div>

          {/* Projetos em Andamento */}
          <div className="group relative bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6 hover:border-violet-500/30 transition-all duration-300 overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-violet-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
            <div className="relative">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 bg-gradient-to-br from-violet-500/20 to-purple-500/10 rounded-xl flex items-center justify-center">
                  <Briefcase className="w-6 h-6 text-violet-400" />
                </div>
                <div className="flex items-center gap-1 text-emerald-400 text-sm">
                  <Target className="w-4 h-4" />
                  <span>{metrics.projetosConcluidos} concluídos</span>
                </div>
              </div>
              <p className="text-slate-400 text-sm mb-1">Projetos Ativos</p>
              <p className="text-2xl font-bold text-white">{metrics.projetosAtivos}</p>
            </div>
          </div>

          {/* Clientes */}
          <div className="group relative bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6 hover:border-emerald-500/30 transition-all duration-300 overflow-hidden">
            <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
            <div className="relative">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 bg-gradient-to-br from-emerald-500/20 to-teal-500/10 rounded-xl flex items-center justify-center">
                  <Users className="w-6 h-6 text-emerald-400" />
                </div>
                <div className="flex items-center gap-1 text-emerald-400 text-sm">
                  <ArrowUpRight className="w-4 h-4" />
                  <span>+{metrics.clientesNovos}</span>
                </div>
              </div>
              <p className="text-slate-400 text-sm mb-1">Clientes Ativos</p>
              <p className="text-2xl font-bold text-white">{metrics.clientesAtivos}</p>
            </div>
          </div>
        </div>

        {/* ====== GRID PRINCIPAL ====== */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">

          {/* COLUNA ESQUERDA - Gráficos e Núcleos */}
          <div className="lg:col-span-8 space-y-6">

            {/* Gráfico Financeiro */}
            <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-6">
                <div>
                  <h3 className="text-lg font-semibold text-white">Fluxo Financeiro</h3>
                  <p className="text-sm text-slate-400">Receitas vs Despesas - Últimos 6 meses</p>
                </div>
                <div className="flex items-center gap-4 text-sm">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-orange-500 rounded-full" />
                    <span className="text-slate-400">Receitas</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-slate-500 rounded-full" />
                    <span className="text-slate-400">Despesas</span>
                  </div>
                </div>
              </div>
              <div className="h-[280px]">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={dadosMensais}>
                    <defs>
                      <linearGradient id="colorReceitasCEO" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#f97316" stopOpacity={0.4}/>
                        <stop offset="95%" stopColor="#f97316" stopOpacity={0}/>
                      </linearGradient>
                      <linearGradient id="colorDespesasCEO" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#64748b" stopOpacity={0.3}/>
                        <stop offset="95%" stopColor="#64748b" stopOpacity={0}/>
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" stroke="#334155" vertical={false} />
                    <XAxis dataKey="mes" stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} />
                    <YAxis stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} tickFormatter={(value) => `${(value/1000).toFixed(0)}k`} />
                    <Tooltip
                      contentStyle={{ backgroundColor: '#1e293b', border: '1px solid #334155', borderRadius: '12px' }}
                      labelStyle={{ color: '#f1f5f9' }}
                      formatter={(value: number) => [new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value), '']}
                    />
                    <Area type="monotone" dataKey="receitas" stroke="#f97316" strokeWidth={2} fillOpacity={1} fill="url(#colorReceitasCEO)" name="Receitas" />
                    <Area type="monotone" dataKey="despesas" stroke="#64748b" strokeWidth={2} fillOpacity={1} fill="url(#colorDespesasCEO)" name="Despesas" />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Cards de Núcleos */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {/* Arquitetura */}
              <div
                onClick={() => navigate('/contratos')}
                className="group cursor-pointer bg-gradient-to-br from-orange-500/10 to-amber-500/5 border border-orange-500/20 rounded-2xl p-5 hover:border-orange-500/40 transition-all"
              >
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 bg-orange-500/20 rounded-xl flex items-center justify-center">
                    <Ruler className="w-5 h-5 text-orange-400" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-white">Arquitetura</h4>
                    <p className="text-xs text-orange-400/80">Design & Projetos</p>
                  </div>
                </div>
                <div className="flex items-end justify-between">
                  <div>
                    <p className="text-3xl font-bold text-white">{metrics.nucleoArquitetura}</p>
                    <p className="text-xs text-slate-400">projetos ativos</p>
                  </div>
                  <ChevronRight className="w-5 h-5 text-orange-400 group-hover:translate-x-1 transition-transform" />
                </div>
              </div>

              {/* Engenharia */}
              <div
                onClick={() => navigate('/contratos')}
                className="group cursor-pointer bg-gradient-to-br from-blue-500/10 to-cyan-500/5 border border-blue-500/20 rounded-2xl p-5 hover:border-blue-500/40 transition-all"
              >
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 bg-blue-500/20 rounded-xl flex items-center justify-center">
                    <Building2 className="w-5 h-5 text-blue-400" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-white">Engenharia</h4>
                    <p className="text-xs text-blue-400/80">Obras & Execução</p>
                  </div>
                </div>
                <div className="flex items-end justify-between">
                  <div>
                    <p className="text-3xl font-bold text-white">{metrics.nucleoEngenharia}</p>
                    <p className="text-xs text-slate-400">obras ativas</p>
                  </div>
                  <ChevronRight className="w-5 h-5 text-blue-400 group-hover:translate-x-1 transition-transform" />
                </div>
              </div>

              {/* Marcenaria */}
              <div
                onClick={() => navigate('/contratos')}
                className="group cursor-pointer bg-gradient-to-br from-amber-700/10 to-yellow-600/5 border border-amber-600/20 rounded-2xl p-5 hover:border-amber-600/40 transition-all"
              >
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 bg-amber-600/20 rounded-xl flex items-center justify-center">
                    <Hammer className="w-5 h-5 text-amber-500" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-white">Marcenaria</h4>
                    <p className="text-xs text-amber-500/80">Sob Medida</p>
                  </div>
                </div>
                <div className="flex items-end justify-between">
                  <div>
                    <p className="text-3xl font-bold text-white">{metrics.nucleoMarcenaria}</p>
                    <p className="text-xs text-slate-400">em produção</p>
                  </div>
                  <ChevronRight className="w-5 h-5 text-amber-500 group-hover:translate-x-1 transition-transform" />
                </div>
              </div>
            </div>

            {/* Propostas */}
            <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-violet-500/20 rounded-xl flex items-center justify-center">
                    <FileText className="w-5 h-5 text-violet-400" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-white">Propostas Comerciais</h3>
                    <p className="text-xs text-slate-400">Conversão e pipeline</p>
                  </div>
                </div>
                <button
                  onClick={() => navigate('/propostas')}
                  className="text-sm text-violet-400 hover:text-violet-300 transition-colors"
                >
                  Ver todas →
                </button>
              </div>
              <div className="grid grid-cols-3 gap-4">
                <div className="text-center p-4 bg-slate-800/50 rounded-xl">
                  <p className="text-3xl font-bold text-amber-400">{metrics.propostasAbertas}</p>
                  <p className="text-xs text-slate-400 mt-1">Aguardando</p>
                </div>
                <div className="text-center p-4 bg-slate-800/50 rounded-xl">
                  <p className="text-3xl font-bold text-emerald-400">{metrics.propostasAprovadas}</p>
                  <p className="text-xs text-slate-400 mt-1">Aprovadas</p>
                </div>
                <div className="text-center p-4 bg-slate-800/50 rounded-xl">
                  <p className="text-xl font-bold text-white">
                    {new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL', notation: 'compact' }).format(metrics.valorPropostas)}
                  </p>
                  <p className="text-xs text-slate-400 mt-1">Valor Total</p>
                </div>
              </div>
            </div>
          </div>

          {/* COLUNA DIREITA - Calendário, Checklist, Alertas */}
          <div className="lg:col-span-4 space-y-6">

            {/* Checklist Diário */}
            <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-emerald-500/20 rounded-xl flex items-center justify-center">
                    <CheckCircle2 className="w-5 h-5 text-emerald-400" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-white">Checklist do Dia</h3>
                    <p className="text-xs text-slate-400">
                      {checklistProgress}% concluído • {ceoChecklist?.itens?.filter(i => i.concluido).length || 0}/{ceoChecklist?.itens?.length || 0} tarefas
                    </p>
                  </div>
                </div>
                <button
                  type="button"
                  onClick={() => setAdicionandoItem(true)}
                  className="p-1.5 hover:bg-emerald-500/20 rounded-lg transition-colors"
                  title="Adicionar tarefa"
                >
                  <Plus className="w-4 h-4 text-emerald-400" />
                </button>
              </div>

              {/* Progress bar */}
              <div className="h-2 bg-slate-700/50 rounded-full mb-4 overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-emerald-500 to-teal-400 rounded-full transition-all duration-500"
                  style={{ width: `${checklistProgress}%` }}
                />
              </div>

              {/* Input para novo item */}
              {adicionandoItem && (
                <div className="mb-4 flex gap-2">
                  <input
                    type="text"
                    value={novoItemTexto}
                    onChange={(e) => setNovoItemTexto(e.target.value)}
                    onKeyDown={(e) => e.key === "Enter" && handleAdicionarItem()}
                    placeholder="Nova tarefa..."
                    className="flex-1 px-3 py-2 bg-slate-800/50 border border-slate-600 rounded-lg text-sm text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500/50"
                    autoFocus
                  />
                  <button
                    type="button"
                    onClick={handleAdicionarItem}
                    disabled={salvandoItem || !novoItemTexto.trim()}
                    className="px-3 py-2 bg-emerald-500/20 text-emerald-400 rounded-lg hover:bg-emerald-500/30 disabled:opacity-50 transition-colors"
                    title="Salvar tarefa"
                  >
                    {salvandoItem ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />}
                  </button>
                  <button
                    type="button"
                    onClick={() => { setAdicionandoItem(false); setNovoItemTexto(""); }}
                    className="px-3 py-2 bg-slate-700/50 text-slate-400 rounded-lg hover:bg-slate-700 transition-colors"
                    title="Cancelar"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              )}

              {/* Items */}
              <div className="space-y-2 max-h-[300px] overflow-y-auto">
                {(!ceoChecklist?.itens || ceoChecklist.itens.length === 0) ? (
                  <div className="text-center py-6">
                    <CheckCircle2 className="w-8 h-8 text-slate-600 mx-auto mb-2" />
                    <p className="text-sm text-slate-500">Nenhuma tarefa para hoje</p>
                    <button
                      type="button"
                      onClick={() => setAdicionandoItem(true)}
                      className="mt-2 text-xs text-emerald-400 hover:text-emerald-300"
                    >
                      Adicionar primeira tarefa
                    </button>
                  </div>
                ) : (
                  ceoChecklist.itens.map((item) => (
                    <div
                      key={item.id}
                      className={`group flex items-center gap-3 p-3 rounded-xl transition-all ${
                        item.concluido
                          ? 'bg-emerald-500/10 border border-emerald-500/20'
                          : 'bg-slate-800/30 hover:bg-slate-700/30 border border-transparent'
                      }`}
                    >
                      <button
                        type="button"
                        onClick={() => toggleChecklist(item.id)}
                        className={`w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 ${
                          item.concluido
                            ? 'bg-emerald-500'
                            : 'border-2 border-slate-600 hover:border-emerald-400'
                        }`}
                        title={item.concluido ? 'Marcar como pendente' : 'Marcar como concluído'}
                      >
                        {item.concluido && <Check className="w-3 h-3 text-white" />}
                      </button>
                      <span
                        onClick={() => toggleChecklist(item.id)}
                        className={`flex-1 text-sm cursor-pointer ${item.concluido ? 'text-slate-400 line-through' : 'text-white'}`}
                      >
                        {item.texto}
                      </span>
                      {item.prioridade === 'alta' && !item.concluido && (
                        <span className="px-2 py-0.5 bg-red-500/20 text-red-400 text-xs rounded-full">Alta</span>
                      )}
                      {item.fonte === 'recorrente' && !item.concluido && (
                        <span className="px-2 py-0.5 bg-blue-500/20 text-blue-400 text-xs rounded-full">Ontem</span>
                      )}
                      <button
                        type="button"
                        onClick={() => handleRemoverItem(item.id)}
                        className="opacity-0 group-hover:opacity-100 p-1 hover:bg-red-500/20 rounded transition-all"
                        title="Remover tarefa"
                      >
                        <Trash2 className="w-3.5 h-3.5 text-red-400" />
                      </button>
                    </div>
                  ))
                )}
              </div>
            </div>

            {/* Menções do CEO */}
            {mencoes.length > 0 && (
              <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-purple-500/20 rounded-xl flex items-center justify-center">
                      <AtSign className="w-5 h-5 text-purple-400" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-white">Você foi Mencionado</h3>
                      <p className="text-xs text-slate-400">
                        {mencoes.length} {mencoes.length === 1 ? 'menção recente' : 'menções recentes'}
                      </p>
                    </div>
                  </div>
                </div>

                <div className="space-y-2 max-h-[200px] overflow-y-auto">
                  {mencoes.map((mencao) => (
                    <div
                      key={mencao.id}
                      className="group flex items-start gap-3 p-3 bg-slate-800/30 hover:bg-slate-700/30 rounded-xl transition-all"
                    >
                      <MessageSquare className="w-4 h-4 text-purple-400 mt-0.5 flex-shrink-0" />
                      <div className="flex-1 min-w-0">
                        {mencao.task?.titulo && (
                          <p className="text-sm font-medium text-white truncate">{mencao.task.titulo}</p>
                        )}
                        <p className="text-xs text-slate-400 line-clamp-2 mt-0.5">
                          {mencao.comentario.substring(0, 100)}...
                        </p>
                        {mencao.task?.project?.nome && (
                          <p className="text-xs text-purple-400/80 mt-1">{mencao.task.project.nome}</p>
                        )}
                      </div>
                      <button
                        type="button"
                        onClick={() => handleImportarMencao(mencao)}
                        disabled={importandoMencao === mencao.id}
                        className="opacity-0 group-hover:opacity-100 p-1.5 bg-purple-500/20 hover:bg-purple-500/30 rounded-lg transition-all"
                        title="Adicionar ao checklist"
                      >
                        {importandoMencao === mencao.id ? (
                          <Loader2 className="w-3.5 h-3.5 text-purple-400 animate-spin" />
                        ) : (
                          <ArrowRight className="w-3.5 h-3.5 text-purple-400" />
                        )}
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Calendário / Próximos Eventos */}
            <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-blue-500/20 rounded-xl flex items-center justify-center">
                    <Calendar className="w-5 h-5 text-blue-400" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-white">Agenda</h3>
                    <p className="text-xs text-slate-400">Próximos eventos</p>
                  </div>
                </div>
              </div>

              <div className="space-y-3">
                {eventos.map((evento) => (
                  <div key={evento.id} className="flex items-start gap-3 p-3 bg-slate-800/30 rounded-xl hover:bg-slate-700/30 transition-colors">
                    <div className={`w-2 h-2 mt-2 rounded-full ${
                      evento.tipo === 'reuniao' ? 'bg-blue-400' :
                      evento.tipo === 'entrega' ? 'bg-emerald-400' :
                      evento.tipo === 'visita' ? 'bg-violet-400' :
                      'bg-amber-400'
                    }`} />
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-white truncate">{evento.titulo}</p>
                      <div className="flex items-center gap-2 text-xs text-slate-400 mt-1">
                        <span>{evento.data}</span>
                        {evento.hora && (
                          <>
                            <span>•</span>
                            <span>{evento.hora}</span>
                          </>
                        )}
                      </div>
                      {evento.cliente && (
                        <p className="text-xs text-slate-500 mt-0.5">{evento.cliente}</p>
                      )}
                    </div>
                  </div>
                ))}
              </div>

              <button type="button" onClick={() => navigate('/cronograma')} className="w-full mt-4 py-2.5 text-sm text-blue-400 hover:text-blue-300 hover:bg-blue-500/10 rounded-xl transition-colors">
                Ver calendário completo →
              </button>
            </div>

            {/* Alertas */}
            {alertas.length > 0 && (
              <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 bg-amber-500/20 rounded-xl flex items-center justify-center">
                    <AlertTriangle className="w-5 h-5 text-amber-400" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-white">Atenção</h3>
                    <p className="text-xs text-slate-400">{alertas.length} itens requerem ação</p>
                  </div>
                </div>

                <div className="space-y-2">
                  {alertas.map((alerta) => (
                    <div
                      key={alerta.id}
                      onClick={() => alerta.link && navigate(alerta.link)}
                      className={`flex items-center justify-between p-3 rounded-xl cursor-pointer transition-all ${
                        alerta.tipo === 'urgente'
                          ? 'bg-red-500/10 border border-red-500/20 hover:bg-red-500/20'
                          : alerta.tipo === 'atencao'
                          ? 'bg-amber-500/10 border border-amber-500/20 hover:bg-amber-500/20'
                          : 'bg-blue-500/10 border border-blue-500/20 hover:bg-blue-500/20'
                      }`}
                    >
                      <p className="text-sm text-white">{alerta.mensagem}</p>
                      {alerta.acao && (
                        <span className={`text-xs font-medium ${
                          alerta.tipo === 'urgente' ? 'text-red-400' :
                          alerta.tipo === 'atencao' ? 'text-amber-400' : 'text-blue-400'
                        }`}>
                          {alerta.acao} →
                        </span>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Acesso Rápido */}
            <div className="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-6">
              <h3 className="font-semibold text-white mb-4">Acesso Rápido</h3>
              <div className="grid grid-cols-2 gap-3">
                <button
                  type="button"
                  onClick={() => navigate('/propostas')}
                  className="flex flex-col items-center gap-2 p-4 bg-slate-800/50 hover:bg-orange-500/10 border border-transparent hover:border-orange-500/20 rounded-xl transition-all"
                >
                  <FileText className="w-5 h-5 text-orange-400" />
                  <span className="text-xs text-slate-300">Propostas</span>
                </button>
                <button
                  type="button"
                  onClick={() => navigate('/contratos')}
                  className="flex flex-col items-center gap-2 p-4 bg-slate-800/50 hover:bg-blue-500/10 border border-transparent hover:border-blue-500/20 rounded-xl transition-all"
                >
                  <Briefcase className="w-5 h-5 text-blue-400" />
                  <span className="text-xs text-slate-300">Contratos</span>
                </button>
                <button
                  type="button"
                  onClick={() => navigate('/financeiro')}
                  className="flex flex-col items-center gap-2 p-4 bg-slate-800/50 hover:bg-emerald-500/10 border border-transparent hover:border-emerald-500/20 rounded-xl transition-all"
                >
                  <DollarSign className="w-5 h-5 text-emerald-400" />
                  <span className="text-xs text-slate-300">Financeiro</span>
                </button>
                <button
                  type="button"
                  onClick={() => navigate('/pessoas/clientes')}
                  className="flex flex-col items-center gap-2 p-4 bg-slate-800/50 hover:bg-violet-500/10 border border-transparent hover:border-violet-500/20 rounded-xl transition-all"
                >
                  <Users className="w-5 h-5 text-violet-400" />
                  <span className="text-xs text-slate-300">Clientes</span>
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* ====== FOOTER ====== */}
        <footer className="pt-6 border-t border-slate-800/50 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 bg-gradient-to-br from-orange-500 to-amber-500 rounded-lg flex items-center justify-center">
              <Sparkles className="w-4 h-4 text-white" />
            </div>
            <p className="text-sm text-slate-400">
              WG Easy · Dashboard Executivo
            </p>
          </div>
          <p className="text-xs text-slate-600">
            Grupo WG Almeida · v2.0 CEO Edition
          </p>
        </footer>
      </div>
    </div>
  );
}

