// ============================================================
// DASHBOARD EXECUTIVO - CEO & FOUNDER
// Sistema WG Easy - Grupo WG Almeida
// ============================================================
//
// SUPABASE STUDIO - TABELAS RELACIONADAS:
// - frases_motivacionais: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/frases_motivacionais
// - ceo_checklist_diario: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/ceo_checklist_diario
// - ceo_checklist_itens: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/ceo_checklist_itens
// - contratos: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/contratos
// - cronograma_tarefas: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/editor/cronograma_tarefas
//
// ============================================================

import { useEffect, useMemo, useState, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import {
  ArrowRight,
  Calendar,
  CheckCircle2,
  ChevronDown,
  Copy,
  FileText,
  GaugeCircle,
  Layers,
  MessageCircle,
  MessageSquare,
  Rocket,
  Sparkles,
  Sun,
  Moon,
  Sunset,
  Plus,
  Check,
  X,
  Loader2,
  Trash2,
  Quote,
  AtSign,
} from "lucide-react";
import { supabase } from "@/lib/supabaseClient";
import { useUsuarioLogado } from "@/hooks/useUsuarioLogado";
import { listarFinanceiro, LancamentoFinanceiro } from "@/lib/financeiroApi";
import {
  ResponsiveContainer,
  LineChart,
  Line,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
} from "recharts";
import {
  obterChecklistDiario,
  adicionarItemComMencoes,
  toggleItemConcluido,
  removerItem,
  calcularProgresso,
  buscarMencoesUsuario,
  importarMencaoParaChecklist,
  type CEOChecklist,
} from "@/lib/ceoChecklistApi";
import { obterFraseDoDiaComFallback, type FraseMotivacional } from "@/lib/frasesMotivacionaisApi";
import "@/styles/dashboard.css";

type DadosCliente = {
  nome?: string;
  foto_url?: string;
  avatar_url?: string;
} | null;

type DadosImovel = {
  endereco_completo?: string;
  bairro?: string;
  cidade?: string;
  estado?: string;
  cep?: string;
  horario_seg_sex?: string;
  horario_sabado?: string;
} | null;

interface ContratoAtivoResumo {
  id: string;
  numero: string;
  status: string;
  cliente_id?: string;
  dados_cliente_json?: DadosCliente;
  dados_imovel_json?: DadosImovel;
  cliente?: {
    nome?: string;
    foto_url?: string;
    avatar_url?: string;
  } | null;
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

interface EventoCalendario {
  id: string;
  titulo: string;
  data: string;
  tipo: 'deadline' | 'reuniao' | 'entrega';
  projeto?: string;
}

export default function DashboardPage() {
  const navigate = useNavigate();
  const { usuario, loading: loadingUsuario } = useUsuarioLogado();

  const [contratosAtivos, setContratosAtivos] = useState<ContratoAtivoResumo[]>([]);
  const [copiedContratoId, setCopiedContratoId] = useState<string | null>(null);
  const [loadingContratos, setLoadingContratos] = useState(true);
  const [contratoExpandido, setContratoExpandido] = useState<string | null>(null);

  // Frase motivacional do dia
  const [fraseDoDia, setFraseDoDia] = useState<FraseMotivacional | null>(null);

  // Checklist persistente do banco de dados
  const [ceoChecklist, setCeoChecklist] = useState<CEOChecklist | null>(null);
  const [novoItemTexto, setNovoItemTexto] = useState("");
  const [salvandoItem, setSalvandoItem] = useState(false);

  // Menções do CEO em tarefas
  const [mencoes, setMencoes] = useState<Mencao[]>([]);
  const [importandoMencao, setImportandoMencao] = useState<string | null>(null);

  // Eventos do calendário real
  const [eventosCalendario, setEventosCalendario] = useState<EventoCalendario[]>([]);
  const [loadingEventos, setLoadingEventos] = useState(true);

  // Dados financeiros
  const [dadosFinanceiros, setDadosFinanceiros] = useState<LancamentoFinanceiro[]>([]);
  const [loadingFinanceiro, setLoadingFinanceiro] = useState(true);

  // Saudação baseada na hora
  const saudacao = useMemo(() => {
    const hora = new Date().getHours();
    if (hora >= 5 && hora < 12) return { texto: 'Bom dia', icon: Sun, cor: 'text-amber-500' };
    if (hora >= 12 && hora < 18) return { texto: 'Boa tarde', icon: Sunset, cor: 'text-orange-500' };
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

  // Carregar contratos ativos
  useEffect(() => {
    async function carregarContratosAtivos() {
      try {
        const { data, error } = await supabase
          .from("contratos")
          .select(`
            id,
            numero,
            status,
            cliente_id,
            dados_cliente_json,
            dados_imovel_json,
            cliente:pessoas!contratos_cliente_id_fkey(nome, foto_url, avatar_url)
          `)
          .eq("status", "ativo")
          .order("updated_at", { ascending: false })
          .limit(16);

        if (error) throw error;
        // Normalizar dados - cliente pode vir como array do Supabase
        const contratosNormalizados = (data || []).map((c: any) => ({
          ...c,
          cliente: Array.isArray(c.cliente) ? c.cliente[0] || null : c.cliente
        }));
        setContratosAtivos(contratosNormalizados);
      } catch (error) {
        console.error("Erro ao carregar contratos ativos:", error);
        setContratosAtivos([]);
      } finally {
        setLoadingContratos(false);
      }
    }

    carregarContratosAtivos();
  }, []);

  // Carregar frase do dia e checklist do CEO
  useEffect(() => {
    async function carregarDadosCEO() {
      // Carregar frase motivacional
      try {
        const frase = await obterFraseDoDiaComFallback();
        setFraseDoDia(frase);
      } catch (err) {
        console.error("Erro ao carregar frase:", err);
      }

      // Carregar checklist e menções se usuário logado
      if (usuario?.id) {
        try {
          const checklistDiario = await obterChecklistDiario(usuario.id);
          setCeoChecklist(checklistDiario);
        } catch (err) {
          console.error("Erro ao carregar checklist:", err);
        }

        try {
          const mencoesRecentes = await buscarMencoesUsuario(usuario.id, 7);
          setMencoes(mencoesRecentes);
        } catch (err) {
          console.error("Erro ao carregar menções:", err);
        }
      }
    }

    if (!loadingUsuario) {
      carregarDadosCEO();
    }
  }, [usuario, loadingUsuario]);

  // Carregar eventos reais do cronograma
  useEffect(() => {
    async function carregarEventos() {
      try {
        const hoje = new Date();
        const dataLimite = new Date();
        dataLimite.setDate(dataLimite.getDate() + 14);

        const { data, error } = await supabase
          .from("cronograma_tarefas")
          .select(`
            id,
            titulo,
            data_termino,
            nucleo,
            projeto:projetos(nome)
          `)
          .gte("data_termino", hoje.toISOString().split("T")[0])
          .lte("data_termino", dataLimite.toISOString().split("T")[0])
          .not("status", "in", '("concluido","cancelado")')
          .order("data_termino", { ascending: true })
          .limit(5);

        if (error) throw error;

        const eventos: EventoCalendario[] = (data || []).map((tarefa: any) => {
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
            dataLabel = dataTarefa.toLocaleDateString("pt-BR", { day: "numeric", month: "short" });
          }

          return {
            id: tarefa.id,
            titulo: tarefa.titulo,
            data: dataLabel,
            tipo: "deadline" as const,
            projeto: tarefa.projeto?.nome || tarefa.nucleo || undefined,
          };
        });

        setEventosCalendario(eventos);
      } catch (error) {
        console.error("Erro ao carregar eventos:", error);
      } finally {
        setLoadingEventos(false);
      }
    }

    carregarEventos();
  }, []);

  // Carregar dados financeiros
  useEffect(() => {
    async function carregarFinanceiro() {
      try {
        setLoadingFinanceiro(true);
        console.log("🔄 Dashboard: Carregando dados financeiros...");
        const lista = await listarFinanceiro();
        console.log("📊 Dashboard: Recebidos", lista.length, "lançamentos");
        if (lista.length > 0) {
          console.log("📋 Primeiro lançamento:", lista[0]);
        }
        setDadosFinanceiros(lista);
      } catch (error) {
        console.error("❌ Erro ao carregar financeiro:", error);
      } finally {
        setLoadingFinanceiro(false);
      }
    }
    carregarFinanceiro();
  }, []);

  // KPIs Financeiros calculados
  const kpisFinanceiros = useMemo(() => {
    const totalEntrada = dadosFinanceiros
      .filter(d => d.tipo === "entrada")
      .reduce((acc, v) => acc + Number(v.valor_total || 0), 0);
    const totalSaida = dadosFinanceiros
      .filter(d => d.tipo === "saida")
      .reduce((acc, v) => acc + Number(v.valor_total || 0), 0);
    const lucro = totalEntrada - totalSaida;
    const margem = totalEntrada ? ((lucro / totalEntrada) * 100) : 0;

    return { totalEntrada, totalSaida, lucro, margem };
  }, [dadosFinanceiros]);

  // Curva S (acumulado mensal)
  const curvaS = useMemo(() => {
    const agrupado = Object.values(
      dadosFinanceiros
        .filter(item => item.vencimento)
        .reduce((acc: any, item) => {
          const mes = item.vencimento!.substring(0, 7);
          if (!acc[mes]) acc[mes] = { mes, entrada: 0, saida: 0 };
          if (item.tipo === "entrada") acc[mes].entrada += Number(item.valor_total || 0);
          else acc[mes].saida += Number(item.valor_total || 0);
          return acc;
        }, {})
    ).sort((a: any, b: any) => (a.mes > b.mes ? 1 : -1));

    let entradaAcum = 0;
    let saidaAcum = 0;

    return agrupado.map((i: any) => {
      entradaAcum += i.entrada;
      saidaAcum += i.saida;
      return {
        mes: i.mes.substring(5) + "/" + i.mes.substring(2, 4),
        entradaAcum,
        saidaAcum
      };
    });
  }, [dadosFinanceiros]);

  // Despesas por centro de custo
  const porCentroCusto = useMemo(() => {
    const mapa: Record<string, number> = {};
    dadosFinanceiros.filter(d => d.tipo === "saida").forEach((d) => {
      const nucleo = d.nucleo || "Outros";
      mapa[nucleo] = (mapa[nucleo] || 0) + Number(d.valor_total || 0);
    });
    return Object.entries(mapa)
      .map(([centro_custo, total]) => ({ centro_custo, total }))
      .sort((a, b) => b.total - a.total)
      .slice(0, 6);
  }, [dadosFinanceiros]);

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

  // Adicionar novo item ao checklist (novos itens aparecem PRIMEIRO)
  // Suporta menções @usuario - a tarefa aparece no checklist do mencionado também
  const handleAdicionarItem = useCallback(async () => {
    if (!ceoChecklist?.id || !novoItemTexto.trim() || !usuario?.id) return;

    setSalvandoItem(true);
    try {
      const novoItem = await adicionarItemComMencoes(
        ceoChecklist.id,
        {
          texto: novoItemTexto.trim(),
          prioridade: "media",
        },
        usuario.id // Autor da tarefa (para processar @menções)
      );
      // Novo item vai para o INÍCIO da lista
      setCeoChecklist(prev => prev ? {
        ...prev,
        itens: [novoItem, ...(prev.itens || [])]
      } : null);
      setNovoItemTexto("");
    } catch (err) {
      console.error("Erro ao adicionar item:", err);
    } finally {
      setSalvandoItem(false);
    }
  }, [ceoChecklist?.id, novoItemTexto, usuario?.id]);

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

  const formatHorario = (value?: string | null) =>
    value && value.trim().length > 0 ? value.trim() : "Não informado";

  const formatEndereco = (contrato: ContratoAtivoResumo) => {
    const dados = contrato.dados_imovel_json || {};
    const principal = (dados.endereco_completo || "").trim();
    const complemento = [dados.bairro, dados.cidade, dados.estado].filter(Boolean).join(" - ");

    if (principal && complemento) return `${principal} - ${complemento}`;
    return principal || complemento || "Endereço não informado";
  };

  const getInitials = (nome: string) => {
    if (!nome) return "WG";
    const partes = nome.trim().split(/\s+/);
    if (partes.length === 1) return partes[0].slice(0, 2).toUpperCase();
    return (partes[0][0] + partes[partes.length - 1][0]).toUpperCase();
  };

  const getAvatarColor = (nome: string) => {
    const palette = ["#F25C26", "#0EA5E9", "#10B981", "#6366F1", "#BE185D", "#059669"];
    let hash = 0;
    for (const char of nome) {
      hash = char.charCodeAt(0) + ((hash << 5) - hash);
    }
    return palette[Math.abs(hash) % palette.length];
  };

  const normalizarTelefone = (telefone?: string | null) =>
    telefone ? telefone.replace(/\D/g, "") : "";

  const montarTextoContrato = (contrato: ContratoAtivoResumo) => {
    const clienteNome = contrato.dados_cliente_json?.nome?.trim() || "Cliente";
    const numeroContrato = contrato.numero || "-";
    const endereco = formatEndereco(contrato);
    const horarioSeg = formatHorario(contrato.dados_imovel_json?.horario_seg_sex);
    const horarioSab = formatHorario(contrato.dados_imovel_json?.horario_sabado);

    return [
      `Cliente: ${clienteNome}`,
      `Contrato: ${numeroContrato}`,
      `Endereço da obra: ${endereco}`,
      `Seg-Sex: ${horarioSeg}`,
      `Sábados: ${horarioSab}`,
    ].join("\n");
  };

  async function handleCopiarContrato(contrato: ContratoAtivoResumo) {
    try {
      const texto = montarTextoContrato(contrato);
      if (typeof navigator === "undefined" || !navigator.clipboard) {
        throw new Error("Clipboard API indisponível");
      }
      await navigator.clipboard.writeText(texto);
      setCopiedContratoId(contrato.id);
      setTimeout(() => setCopiedContratoId(null), 2000);
    } catch (error) {
      console.error("Erro ao copiar resumo do contrato:", error);
      alert("Não foi possível copiar o texto. Tente novamente.");
    }
  }

  const kpiCards = useMemo(
    () => [
      {
        label: "Receita projetada",
        value: "R$ 4,2M",
        trend: "+18% este trimestre",
        accent: "from-[#ff8f3f] to-[#ff622d]",
      },
      {
        label: "Projetos em execução",
        value: "12 obras",
        trend: "5 com sprint ativa",
        accent: "from-[#4f46e5] to-[#7c3aed]",
      },
      {
        label: "Solicitações respondidas",
        value: "36 tickets",
        trend: "Tempo médio 2h",
        accent: "from-[#0ea5e9] to-[#14b8a6]",
      },
      {
        label: "Aprovações pendentes",
        value: "04 itens",
        trend: "2 aguardando cliente",
        accent: "from-[#111827] to-[#374151]",
      },
    ],
    []
  );

  const jornadaCards = [
    {
      title: "Experiência do cliente",
      description: "Onboarding, referências e diário de obra em tempo real.",
      icon: <Sparkles className="w-5 h-5 text-white" />,
      color: "from-[#111827] to-[#1f2937]",
      link: "/area-cliente",
    },
    {
      title: "Operações WG",
      description: "Distribua tarefas entre arquitetura, engenharia e marcenaria.",
      icon: <Layers className="w-5 h-5 text-white" />,
      color: "from-[#0f172a] to-[#1e3a8a]",
      link: "/cronograma",
    },
    {
      title: "Financeiro inteligente",
      description: "Fluxos de aprovação, cobrança e previsão de caixa.",
      icon: <GaugeCircle className="w-5 h-5 text-white" />,
      color: "from-[#052e16] to-[#166534]",
      link: "/financeiro",
    },
  ];

  return (
    <div className="pb-16 space-y-8">
      {/* ====== HEADER COM SAUDAÇÃO E FRASE ====== */}
      <section className="rounded-3xl bg-gradient-to-r from-[#0f172a] via-[#1f2937] to-[#111827] text-white p-8 md:p-10 shadow-xl overflow-hidden relative">
        {/* Background decorativo */}
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-0 right-0 w-80 h-80 bg-orange-500 rounded-full blur-3xl" />
          <div className="absolute bottom-0 left-0 w-64 h-64 bg-orange-500/50 rounded-full blur-2xl" />
        </div>

        <div className="relative z-10 flex flex-col gap-8 lg:flex-row lg:items-center lg:justify-between">
          <div className="flex items-center gap-6">
            {/* Avatar estilizado */}
            <div className="relative shrink-0">
              {usuario?.avatar_url ? (
                <img
                  src={usuario.avatar_url}
                  alt={usuario.nome || 'CEO'}
                  className="w-20 h-20 md:w-24 md:h-24 rounded-full object-cover border-4 border-orange-500/30 shadow-2xl ring-4 ring-orange-500/10"
                />
              ) : (
                <div className="w-20 h-20 md:w-24 md:h-24 rounded-full bg-gradient-to-br from-orange-500 to-orange-600 text-white flex items-center justify-center text-2xl md:text-3xl font-bold border-4 border-orange-500/30 shadow-2xl ring-4 ring-orange-500/10">
                  {usuario?.nome ? getInitials(usuario.nome) : 'CEO'}
                </div>
              )}
            </div>

            <div className="space-y-2">
              <p className="text-xs uppercase tracking-[0.4em] text-white/60">WG EASY · DASHBOARD EXECUTIVO</p>
              {/* Saudação dinâmica */}
              <div className="flex items-center gap-3">
                <saudacao.icon className={`w-6 h-6 ${saudacao.cor}`} />
                <h1 className="text-3xl md:text-4xl font-semibold">
                  {saudacao.texto}, <span className="text-orange-400">{usuario?.nome?.split(' ')[0] || 'CEO'}</span>
                </h1>
              </div>
              <p className="text-sm text-white/80 capitalize">{dataHoje}</p>
            </div>
          </div>

          <div className="flex-1 max-w-xl space-y-4">
            {/* Frase motivacional do dia */}
            {fraseDoDia && (
              <div className="flex items-start gap-3 mt-4 p-4 bg-white/5 rounded-xl border border-white/10">
                <Quote className="w-5 h-5 text-[#F25C26]/70 flex-shrink-0 mt-0.5" />
                <div>
                  <p className="text-sm text-white/90 italic leading-relaxed">
                    "{fraseDoDia.frase}"
                  </p>
                  <p className="text-xs text-white/50 mt-2">— {fraseDoDia.autor}</p>
                </div>
              </div>
            )}

            <div className="flex flex-wrap gap-3 mt-4">
              <a
                href="/area-cliente"
                className="inline-flex items-center gap-2 rounded-full bg-white px-5 py-2 text-sm font-semibold text-black hover:opacity-90"
              >
                Abrir experiência do cliente
                <ArrowRight className="w-4 h-4" />
              </a>
              <a
                href="/sistema/area-cliente"
                className="inline-flex items-center gap-2 rounded-full border border-white/30 px-5 py-2 text-sm text-white hover:bg-white/10"
              >
                Configurar acessos
                <FileText className="w-4 h-4" />
              </a>
            </div>
          </div>
          <div className="rounded-2xl bg-white/10 p-6 backdrop-blur-md min-w-[280px] space-y-4">
            <div className="text-xs uppercase tracking-[0.3em] text-white/70">Status geral</div>
            <div className="text-5xl font-semibold">72%</div>
            <p className="text-sm text-white/80">Sprint global WG concluída nesta semana.</p>
            <div className="h-2 w-full rounded-full bg-white/20 overflow-hidden">
              <div className="h-full w-3/4 rounded-full bg-gradient-to-r from-[#f97316] to-[#fb7185]" />
            </div>
          </div>
        </div>
      </section>

      {/* ====== CONTRATOS ATIVOS + CHECKLIST ====== */}
      <section className="grid gap-6 lg:grid-cols-2">
        {/* Coluna Esquerda: Contratos Ativos */}
        <div className="space-y-4">
          <div className="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
            <div>
              <h2 className="text-xl font-semibold text-gray-900">Contratos ativos do dia</h2>
              <p className="text-sm text-gray-500">
                Mini cards com avatar, acesso rápido ao contato do cliente e endereço da obra.
              </p>
            </div>
            {!loadingContratos && (
              <span className="text-xs uppercase tracking-[0.3em] text-gray-400">
                {contratosAtivos.length} clientes ativos
              </span>
            )}
          </div>

          {loadingContratos ? (
            <div className="rounded-3xl border border-dashed border-gray-200 p-6 text-sm text-gray-500">
              Carregando cartões de contratos...
            </div>
          ) : contratosAtivos.length === 0 ? (
            <div className="rounded-3xl border border-dashed border-gray-200 p-6 text-sm text-gray-500">
              Nenhum contrato ativo disponível para exibir agora.
            </div>
          ) : (
            <div className="grid gap-3 grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-4 xl:grid-cols-5">
            {contratosAtivos.map((contrato) => {
              const clienteNome = contrato.dados_cliente_json?.nome?.trim() ||
                                  contrato.cliente?.nome?.trim() ||
                                  "Cliente";
              const fotoUrl = contrato.cliente?.foto_url ||
                             contrato.cliente?.avatar_url ||
                             contrato.dados_cliente_json?.foto_url ||
                             contrato.dados_cliente_json?.avatar_url;
              const endereco = formatEndereco(contrato);
              const email = (contrato.dados_cliente_json as any)?.email || "Não informado";
              const telefone = (contrato.dados_cliente_json as any)?.telefone || "";
              const telefoneLimpo = normalizarTelefone(telefone);
              const whatsappLink = telefoneLimpo ? `https://wa.me/55${telefoneLimpo}` : null;
              const expandido = contratoExpandido === contrato.id;

              return (
                <div
                  key={contrato.id}
                  className="rounded-xl border border-gray-200 bg-white p-3 shadow-sm hover:shadow-md transition-shadow"
                >
                  <div className="flex flex-col items-center gap-2">
                    {fotoUrl ? (
                      <img
                        src={fotoUrl}
                        alt={clienteNome}
                        className="h-14 w-14 rounded-full object-cover ring-2 ring-white shadow-md"
                        onError={(e) => {
                          e.currentTarget.style.display = 'none';
                          e.currentTarget.nextElementSibling?.classList.remove('hidden');
                        }}
                      />
                    ) : null}
                    <div
                      className={`h-14 w-14 rounded-full flex items-center justify-center text-white font-semibold text-sm shadow-md ${fotoUrl ? 'hidden' : ''}`}
                      style={{ background: getAvatarColor(clienteNome) }}
                    >
                      {getInitials(clienteNome)}
                    </div>
                    <div className="text-center w-full">
                      <p className="text-xs font-semibold text-gray-900 truncate px-1" title={clienteNome}>
                        {clienteNome}
                      </p>
                      <p className="text-[10px] text-gray-500">#{contrato.numero || "-"}</p>
                    </div>
                    <button
                      type="button"
                      onClick={() =>
                        setContratoExpandido((prev) => (prev === contrato.id ? null : contrato.id))
                      }
                      className="rounded-full bg-gray-100 p-1.5 text-gray-500 hover:bg-gray-200 hover:text-black transition-colors"
                      title="Ver detalhes"
                    >
                      <ChevronDown
                        className={`w-3 h-3 transition-transform ${expandido ? "rotate-180" : ""}`}
                      />
                    </button>
                  </div>

                  {expandido && (
                    <div className="space-y-2 border-t border-gray-100 pt-3 mt-3 text-xs text-gray-600">
                      <div className="flex flex-col">
                        <span className="text-[9px] uppercase tracking-[0.3em] text-gray-400">Telefone</span>
                        <span className="text-xs">{telefone || "Não informado"}</span>
                      </div>
                      <div className="flex flex-col">
                        <span className="text-[9px] uppercase tracking-[0.3em] text-gray-400">E-mail</span>
                        <span className="text-xs break-all">{email}</span>
                      </div>
                      <div className="flex flex-col">
                        <span className="text-[9px] uppercase tracking-[0.3em] text-gray-400">Endereço</span>
                        <span className="text-xs leading-snug">{endereco}</span>
                      </div>
                      <div className="flex items-center gap-1.5 pt-2">
                        <button
                          type="button"
                          onClick={() => handleCopiarContrato(contrato)}
                          className="flex-1 inline-flex items-center justify-center gap-1.5 rounded-lg border border-gray-200 px-2 py-1.5 text-[10px] font-semibold text-gray-700 hover:bg-gray-50"
                          title="Copiar resumo"
                        >
                          <Copy className="w-3 h-3" />
                          Copiar
                        </button>
                        {whatsappLink && (
                          <a
                            href={whatsappLink}
                            target="_blank"
                            rel="noreferrer"
                            className="rounded-lg border border-emerald-200 bg-emerald-50 p-1.5 text-emerald-600 hover:bg-emerald-100"
                            title="Abrir WhatsApp"
                          >
                            <MessageCircle className="w-3.5 h-3.5" />
                          </a>
                        )}
                      </div>
                      {copiedContratoId === contrato.id && (
                        <p className="text-[10px] text-emerald-600 font-medium text-center">✔ Copiado</p>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
        </div>

        {/* Coluna Direita: Checklist do Dia */}
        <div className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm space-y-4 h-fit">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center">
                <CheckCircle2 className="w-5 h-5 text-emerald-600" />
              </div>
              <div>
                <h2 className="text-lg font-semibold text-gray-900">Checklist do Dia</h2>
                <p className="text-xs text-gray-500">
                  {checklistProgress}% concluído • {ceoChecklist?.itens?.filter(i => i.concluido).length || 0}/{ceoChecklist?.itens?.length || 0} tarefas
                </p>
              </div>
            </div>
          </div>

          {/* Progress bar */}
          <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-emerald-500 to-teal-400 rounded-full transition-all duration-500"
              style={{ width: `${checklistProgress}%` }}
            />
          </div>

          {/* Input para novo item - suporta @menções */}
          <div className="flex gap-2">
            <input
              type="text"
              value={novoItemTexto}
              onChange={(e) => setNovoItemTexto(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleAdicionarItem()}
              placeholder="@eliana fazer entrega... (use @nome)"
              className="flex-1 px-3 py-2 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 bg-gray-50"
            />
            {novoItemTexto.trim() && (
              <button
                type="button"
                onClick={handleAdicionarItem}
                disabled={salvandoItem}
                className="px-3 py-2 bg-emerald-500 text-white rounded-xl hover:bg-emerald-600 disabled:opacity-50"
              >
                {salvandoItem ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
              </button>
            )}
          </div>

          {/* Items */}
          <div className="space-y-2 max-h-[280px] overflow-y-auto">
            {(!ceoChecklist?.itens || ceoChecklist.itens.length === 0) ? (
              <div className="text-center py-4">
                <CheckCircle2 className="w-8 h-8 text-gray-300 mx-auto mb-2" />
                <p className="text-sm text-gray-500">Nenhuma tarefa para hoje</p>
              </div>
            ) : (
              ceoChecklist.itens.map((item) => (
                <div
                  key={item.id}
                  className={`group flex items-center gap-3 p-3 rounded-xl transition-all ${
                    item.concluido
                      ? 'bg-emerald-50 border border-emerald-100'
                      : 'bg-gray-50 hover:bg-gray-100 border border-transparent'
                  }`}
                >
                  <button
                    type="button"
                    onClick={() => toggleChecklist(item.id)}
                    className={`w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 ${
                      item.concluido
                        ? 'bg-emerald-500'
                        : 'border-2 border-gray-300 hover:border-emerald-400'
                    }`}
                  >
                    {item.concluido && <Check className="w-3 h-3 text-white" />}
                  </button>
                  <span
                    onClick={() => toggleChecklist(item.id)}
                    className={`flex-1 text-sm cursor-pointer ${item.concluido ? 'text-gray-400 line-through' : 'text-gray-700'}`}
                  >
                    {item.texto}
                  </span>
                  {item.prioridade === 'alta' && !item.concluido && (
                    <span className="px-2 py-0.5 bg-red-100 text-red-600 text-xs rounded-full">Alta</span>
                  )}
                  <button
                    type="button"
                    onClick={() => handleRemoverItem(item.id)}
                    className="opacity-0 group-hover:opacity-100 p-1 hover:bg-red-100 rounded"
                    title="Remover tarefa"
                  >
                    <Trash2 className="w-3.5 h-3.5 text-red-500" />
                  </button>
                </div>
              ))
            )}
          </div>
        </div>
      </section>

      {/* ====== KPIs FINANCEIROS ====== */}
      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-xl font-semibold text-gray-900">Visão Financeira</h2>
            <p className="text-sm text-gray-500">Indicadores em tempo real do fluxo de caixa</p>
          </div>
          <button
            type="button"
            onClick={() => navigate('/financeiro')}
            className="text-sm text-blue-600 hover:text-blue-700 flex items-center gap-1"
          >
            Ver detalhes <ArrowRight className="w-4 h-4" />
          </button>
        </div>

        {loadingFinanceiro ? (
          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            {[1, 2, 3, 4].map(i => (
              <div key={i} className="rounded-2xl bg-gray-100 p-6 animate-pulse h-28" />
            ))}
          </div>
        ) : dadosFinanceiros.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-gray-300 bg-gray-50 p-8 text-center">
            <GaugeCircle className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-600 font-medium">Nenhum lançamento financeiro cadastrado</p>
            <p className="text-sm text-gray-500 mt-1">
              Cadastre receitas e despesas na tabela <code className="bg-gray-200 px-1 rounded">financeiro_lancamentos</code> para visualizar os KPIs.
            </p>
            <button
              type="button"
              onClick={() => navigate('/financeiro')}
              className="mt-4 inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm"
            >
              <Plus className="w-4 h-4" /> Ir para Financeiro
            </button>
          </div>
        ) : (
          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
            <div className="rounded-2xl bg-gradient-to-br from-emerald-500 to-emerald-600 text-white p-6 shadow-lg">
              <p className="text-xs uppercase tracking-[0.3em] text-white/70">Receita Total</p>
              <div className="mt-2 text-3xl font-semibold">
                {new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL', notation: 'compact', maximumFractionDigits: 1 }).format(kpisFinanceiros.totalEntrada)}
              </div>
              <p className="mt-1 text-sm text-white/80">Entradas confirmadas</p>
            </div>

            <div className="rounded-2xl bg-gradient-to-br from-red-500 to-red-600 text-white p-6 shadow-lg">
              <p className="text-xs uppercase tracking-[0.3em] text-white/70">Despesa Total</p>
              <div className="mt-2 text-3xl font-semibold">
                {new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL', notation: 'compact', maximumFractionDigits: 1 }).format(kpisFinanceiros.totalSaida)}
              </div>
              <p className="mt-1 text-sm text-white/80">Saídas registradas</p>
            </div>

            <div className="rounded-2xl bg-gradient-to-br from-blue-500 to-blue-600 text-white p-6 shadow-lg">
              <p className="text-xs uppercase tracking-[0.3em] text-white/70">Lucro / Resultado</p>
              <div className="mt-2 text-3xl font-semibold">
                {new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL', notation: 'compact', maximumFractionDigits: 1 }).format(kpisFinanceiros.lucro)}
              </div>
              <p className="mt-1 text-sm text-white/80">{kpisFinanceiros.lucro >= 0 ? 'Saldo positivo' : 'Saldo negativo'}</p>
            </div>

            <div className="rounded-2xl bg-gradient-to-br from-gray-800 to-gray-900 text-white p-6 shadow-lg">
              <p className="text-xs uppercase tracking-[0.3em] text-white/70">Margem</p>
              <div className="mt-2 text-3xl font-semibold">
                {kpisFinanceiros.margem.toFixed(1)}%
              </div>
              <p className="mt-1 text-sm text-white/80">{kpisFinanceiros.margem >= 20 ? 'Margem saudável' : 'Atenção à margem'}</p>
            </div>
          </div>
        )}
      </section>

      {/* ====== GRÁFICOS FINANCEIROS ====== */}
      {!loadingFinanceiro && (curvaS.length > 0 || porCentroCusto.length > 0) && (
        <section className="grid gap-6 lg:grid-cols-2">
          {/* Curva S */}
          {curvaS.length > 0 && (
            <div className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Curva S (Acumulado)</h3>
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={curvaS}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#eee" />
                    <XAxis dataKey="mes" stroke="#666" fontSize={12} />
                    <YAxis stroke="#666" fontSize={12} tickFormatter={(v) => `${(v/1000).toFixed(0)}k`} />
                    <Tooltip
                      formatter={(value: number) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value)}
                      labelStyle={{ color: '#333' }}
                    />
                    <Line type="monotone" dataKey="entradaAcum" stroke="#10b981" strokeWidth={3} name="Receitas" dot={false} />
                    <Line type="monotone" dataKey="saidaAcum" stroke="#ef4444" strokeWidth={3} name="Despesas" dot={false} />
                  </LineChart>
                </ResponsiveContainer>
              </div>
              <div className="flex justify-center gap-6 mt-4 text-sm">
                <span className="flex items-center gap-2"><span className="w-3 h-3 rounded-full bg-emerald-500" /> Receitas</span>
                <span className="flex items-center gap-2"><span className="w-3 h-3 rounded-full bg-red-500" /> Despesas</span>
              </div>
            </div>
          )}

          {/* Centro de Custo */}
          {porCentroCusto.length > 0 && (
            <div className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Despesas por Núcleo</h3>
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={porCentroCusto} layout="vertical">
                    <CartesianGrid strokeDasharray="3 3" stroke="#eee" horizontal={false} />
                    <XAxis type="number" stroke="#666" fontSize={12} tickFormatter={(v) => `${(v/1000).toFixed(0)}k`} />
                    <YAxis type="category" dataKey="centro_custo" stroke="#666" fontSize={11} width={100} />
                    <Tooltip
                      formatter={(value: number) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value)}
                    />
                    <Bar dataKey="total" fill="#F25C26" radius={[0, 4, 4, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>
          )}
        </section>
      )}

      {/* ====== GRID PRINCIPAL ====== */}
      <section className="grid gap-8 lg:grid-cols-2">
        {/* JORNADA WG */}
        <div className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm space-y-6">
          <div className="flex items-center justify-between">
            <div>
              <h2 className="text-xl font-semibold text-gray-900">Jornada WG</h2>
              <p className="text-sm text-gray-500">Módulos essenciais para conduzir o cliente.</p>
            </div>
            <Rocket className="w-5 h-5 text-gray-400" />
          </div>
          <div className="grid gap-4">
            {jornadaCards.map((card) => (
              <a
                key={card.title}
                href={card.link}
                className={`rounded-2xl border border-gray-100 bg-gradient-to-r ${card.color} text-white p-5 flex items-center justify-between hover:opacity-95 transition`}
              >
                <div>
                  <p className="text-sm uppercase tracking-[0.3em] text-white/70">{card.title}</p>
                  <p className="mt-2 text-sm text-white/90 max-w-md">{card.description}</p>
                </div>
                <div className="rounded-full bg-white/20 p-3">{card.icon}</div>
              </a>
            ))}
          </div>
        </div>

        {/* MENÇÕES DO CEO */}
        <div className="space-y-6">
          {/* Menções do CEO */}
          {mencoes.length > 0 && (
            <div className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm space-y-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center">
                  <AtSign className="w-5 h-5 text-purple-600" />
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-gray-900">Você foi Mencionado</h3>
                  <p className="text-xs text-gray-500">
                    {mencoes.length} {mencoes.length === 1 ? 'menção recente' : 'menções recentes'}
                  </p>
                </div>
              </div>

              <div className="space-y-2 max-h-[180px] overflow-y-auto">
                {mencoes.map((mencao) => (
                  <div
                    key={mencao.id}
                    className="group flex items-start gap-3 p-3 bg-gray-50 hover:bg-purple-50 rounded-xl transition-all"
                  >
                    <MessageSquare className="w-4 h-4 text-purple-500 mt-0.5 flex-shrink-0" />
                    <div className="flex-1 min-w-0">
                      {mencao.task?.titulo && (
                        <p className="text-sm font-medium text-gray-900 truncate">{mencao.task.titulo}</p>
                      )}
                      <p className="text-xs text-gray-500 line-clamp-2 mt-0.5">
                        {mencao.comentario.substring(0, 100)}...
                      </p>
                      {mencao.task?.project?.nome && (
                        <p className="text-xs text-purple-600 mt-1">{mencao.task.project.nome}</p>
                      )}
                    </div>
                    <button
                      type="button"
                      onClick={() => handleImportarMencao(mencao)}
                      disabled={importandoMencao === mencao.id}
                      className="opacity-0 group-hover:opacity-100 p-1.5 bg-purple-100 hover:bg-purple-200 rounded-lg transition-all"
                      title="Adicionar ao checklist"
                    >
                      {importandoMencao === mencao.id ? (
                        <Loader2 className="w-3.5 h-3.5 text-purple-600 animate-spin" />
                      ) : (
                        <ArrowRight className="w-3.5 h-3.5 text-purple-600" />
                      )}
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Agenda e aprovações */}
          <div className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm space-y-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-xl font-semibold text-gray-900">Agenda e aprovações</h2>
                <p className="text-sm text-gray-500">Próximos eventos do cronograma.</p>
              </div>
              <Calendar className="w-5 h-5 text-gray-400" />
            </div>
            <div className="space-y-4">
              {loadingEventos ? (
                <div className="flex items-center justify-center py-6">
                  <Loader2 className="w-5 h-5 text-gray-400 animate-spin" />
                </div>
              ) : eventosCalendario.length === 0 ? (
                <div className="text-center py-6 text-sm text-gray-500">
                  Nenhum deadline nos próximos 14 dias
                </div>
              ) : (
                eventosCalendario.map((item) => (
                  <div key={item.id} className="flex items-start gap-4">
                    <div className="rounded-full bg-black text-white text-xs font-semibold px-3 py-1">{item.data}</div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900">{item.titulo}</p>
                      {item.projeto && (
                        <span className="text-[11px] uppercase tracking-[0.3em] text-gray-400">{item.projeto}</span>
                      )}
                    </div>
                  </div>
                ))
              )}
            </div>
            <button
              type="button"
              onClick={() => navigate('/cronograma')}
              className="w-full py-2.5 text-sm text-blue-600 hover:text-blue-700 hover:bg-blue-50 rounded-xl transition-colors"
            >
              Ver calendário completo →
            </button>
          </div>
        </div>
      </section>

      {/* ====== COMUNICADOS ====== */}
      <section className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm space-y-5">
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-semibold text-gray-900">Comunicados e insights</h2>
          <MessageSquare className="w-5 h-5 text-gray-400" />
        </div>
        <div className="space-y-4">
          <div className="rounded-2xl border border-gray-100 p-4">
            <span className="text-[11px] uppercase tracking-[0.4em] text-gray-400">Produto</span>
            <p className="text-sm font-semibold text-gray-900 mt-1">Nova jornada área do cliente</p>
            <p className="text-xs text-gray-500">Integração com Google Drive hospedada no layout WG já disponível.</p>
          </div>
          <div className="rounded-2xl border border-gray-100 p-4">
            <span className="text-[11px] uppercase tracking-[0.4em] text-gray-400">Operações</span>
            <p className="text-sm font-semibold text-gray-900 mt-1">Playbook sprint marcenaria</p>
            <p className="text-xs text-gray-500">Sequência padrão com fotos e liberação automática no diário.</p>
          </div>
        </div>
        <div className="rounded-2xl border border-dashed border-gray-200 p-4 text-center text-sm text-gray-500">
          Integrações com BI externo, notificações de SLA e status financeiros podem ser conectados aqui.
        </div>
      </section>

    </div>
  );
}
