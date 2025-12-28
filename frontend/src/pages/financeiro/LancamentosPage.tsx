import { useEffect, useState, useMemo } from "react";
import {
  Plus,
  ArrowUpCircle,
  ArrowDownCircle,
  Edit,
  Trash2,
  Search,
  CheckCircle,
  XCircle,
  Calendar,
  Copy,
  MoreHorizontal,
  Filter,
  X,
  RefreshCw,
  ChevronLeft,
  ChevronRight,
  ChevronsLeft,
  ChevronsRight,
} from "lucide-react";
import { DateInputBR, getTodayISO } from "@/components/ui/DateInputBR";
import {
  listarFinanceiro,
  deletarLancamento,
  criarLancamento,
  atualizarLancamento,
  listarPessoas,
  listarProjetos,
  listarContratos,
  buscarContratosPorClienteNucleo,
  buscarContratosPorNucleo,
  obterCategorias,
  type LancamentoFinanceiro,
  type TipoLancamento,
  type StatusLancamento,
  type CategoriaFinanceira,
} from "@/lib/financeiroApi";


type UnidadeNegocio =
  | "designer"      // W.G. DE ALMEIDA DESIGNER DE INTERIORES (14540890000139)
  | "arquitetura"   // WG ALMEIDA ARQUITETURA E COMERCIO LTDA (45150970000101)
  | "engenharia"    // WG ALMEIDA REFORMAS ESPECIALIZADAS LTDA (43716324000133)
  | "marcenaria"    // WG ALMEIDA MARCENARIA DE ALTO PADRAO LTDA (46836926000112)
  | "produtos"
  | "materiais"
  | "grupo";        // Empresas do Grupo

const NUCLEOS_LABELS: Record<UnidadeNegocio, string> = {
  designer: "WG Designer",
  arquitetura: "Arquitetura",
  engenharia: "Engenharia",
  marcenaria: "Marcenaria",
  produtos: "Produtos",
  materiais: "Materiais",
  grupo: "Empresas do Grupo",
};

const NUCLEOS_CORES: Record<UnidadeNegocio, string> = {
  designer: "#9333EA", // Roxo para Designer
  arquitetura: "#5E9B94", // Verde arquitetura
  engenharia: "#2B4580", // Azul engenharia
  marcenaria: "#8B4513", // Marrom marcenaria
  produtos: "#F25C26", // Laranja WG
  materiais: "#6B7280", // Cinza
  grupo: "#374151", // Cinza escuro
};

function contaCodigo(l: LancamentoFinanceiro): "R" | "V" {
  // Usa o campo referencia_tipo do banco, padrão = Real (R)
  if (l.referencia_tipo === "V") return "V";
  return "R";
}


export default function LancamentosPage() {
  const [lancamentos, setLancamentos] = useState<LancamentoFinanceiro[]>([]);
  const [pessoas, setPessoas] = useState<any[]>([]);
  const [projetos, setProjetos] = useState<any[]>([]);
  const [contratos, setContratos] = useState<any[]>([]);
  const [nucleosDisponiveis, setNucleosDisponiveis] = useState<UnidadeNegocio[]>([]);
  const [contratosFiltrados, setContratosFiltrados] = useState<any[]>([]);
  const [categorias, setCategorias] = useState<CategoriaFinanceira[]>([]);
  const [todasCategorias, setTodasCategorias] = useState<CategoriaFinanceira[]>([]);
  const [loading, setLoading] = useState(true);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editing, setEditing] = useState<LancamentoFinanceiro | null>(null);

  const [searchTerm, setSearchTerm] = useState("");
  const [filterTipo, setFilterTipo] = useState<TipoLancamento | "">("");
  const [filterStatus, setFilterStatus] = useState<StatusLancamento | "">("");
  const [filterNucleo, setFilterNucleo] = useState<UnidadeNegocio | "">("");
  const [filterContaTipo, setFilterContaTipo] = useState<"" | "R" | "V">("");
  const [filterCentroCusto, setFilterCentroCusto] = useState("");
  const [filterDataInicio, setFilterDataInicio] = useState("");
  const [filterDataFim, setFilterDataFim] = useState("");
  const [filterCategoria, setFilterCategoria] = useState("");
  const [refreshKey, setRefreshKey] = useState(0);
  const [showFilters, setShowFilters] = useState(false);
  const [actionMenuId, setActionMenuId] = useState<string | null>(null);
  const [editingStatusId, setEditingStatusId] = useState<string | null>(null);

  // Estados debounced para campos de texto (evita busca a cada letra)
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState("");
  const [debouncedCentroCusto, setDebouncedCentroCusto] = useState("");

  // Debounce para searchTerm (500ms de delay)
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearchTerm(searchTerm);
    }, 500);
    return () => clearTimeout(timer);
  }, [searchTerm]);

  // Debounce para filterCentroCusto (500ms de delay)
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedCentroCusto(filterCentroCusto);
    }, 500);
    return () => clearTimeout(timer);
  }, [filterCentroCusto]);

  // Paginação
  const [currentPage, setCurrentPage] = useState(1);
  const [itemsPerPage, setItemsPerPage] = useState(50);

  const [formData, setFormData] = useState({
    pessoa_id: "",
    tipo: "entrada" as TipoLancamento,
    nucleo: "" as "" | UnidadeNegocio,
    contrato_id: "",
    descricao: "",
    valor: "",
    categoria_id: "",
    status: "previsto" as StatusLancamento,
    data_competencia: getTodayISO(),
    vencimento: "",
    projeto_id: "",
    observacoes: "",
    conta_tipo: "R" as "R" | "V",
  });

  // Carregar lista principal + filtros
  useEffect(() => {
    async function carregar() {
      setLoading(true);
      try {
        const [lancs, pess, projs, conts, allCats] = await Promise.all([
          listarFinanceiro(),
          listarPessoas(),
          listarProjetos(),
          listarContratos(),
          obterCategorias(), // Todas as categorias para exibição
        ]);
        setTodasCategorias(allCats);

        let filtrados = lancs;

        if (debouncedSearchTerm) {
          const termo = debouncedSearchTerm.toLowerCase();
          filtrados = filtrados.filter((l) =>
            l.descricao.toLowerCase().includes(termo)
          );
        }

        if (filterTipo) {
          filtrados = filtrados.filter((l) => l.tipo === filterTipo);
        }

        if (filterStatus) {
          filtrados = filtrados.filter((l) => l.status === filterStatus);
        }

        if (filterNucleo) {
          filtrados = filtrados.filter((l) => {
            const nucleo =
              (l.nucleo as UnidadeNegocio | null) ||
              ((l.contrato as any)?.unidade_negocio as UnidadeNegocio | null);
            return nucleo === filterNucleo;
          });
        }

        if (filterContaTipo) {
          filtrados = filtrados.filter(
            (l) => contaCodigo(l) === filterContaTipo
          );
        }

        if (debouncedCentroCusto) {
          const termoCentro = debouncedCentroCusto.toLowerCase();
          filtrados = filtrados.filter((l) => {
            const centro = [l.pessoa?.nome, l.contrato?.numero].filter(Boolean).join(" ").toLowerCase();
            return centro.includes(termoCentro);
          });
        }

        if (filterDataInicio) {
          filtrados = filtrados.filter((l) => l.data_competencia >= filterDataInicio);
        }

        if (filterDataFim) {
          filtrados = filtrados.filter((l) => l.data_competencia <= filterDataFim);
        }

        if (filterCategoria) {
          filtrados = filtrados.filter((l) => l.categoria_id === filterCategoria);
        }

        console.log("🎯 Filtros aplicados:", {
          total: lancs.length,
          filtrados: filtrados.length,
          filtros: { debouncedSearchTerm, filterTipo, filterStatus, filterNucleo, filterContaTipo, debouncedCentroCusto }
        });
        setLancamentos(filtrados);
        setCurrentPage(1); // Reset para página 1 quando filtros mudam
        setPessoas(pess);
        setProjetos(projs);
        setContratos(conts);
      } catch (error: any) {
        console.error("Erro ao carregar dados:", error);
        alert("Erro ao carregar lançamentos: " + error.message);
      } finally {
        setLoading(false);
      }
    }

    carregar();
  }, [debouncedSearchTerm, filterTipo, filterStatus, filterNucleo, filterContaTipo, debouncedCentroCusto, filterDataInicio, filterDataFim, filterCategoria, refreshKey]);

  // Atualizar núcleos quando o cliente muda no formulário
  useEffect(() => {
    if (!formData.pessoa_id) {
      setNucleosDisponiveis([]);
      setFormData((prev) => ({ ...prev, nucleo: "", contrato_id: "" }));
      return;
    }

    // SEMPRE mostrar TODAS as opções de núcleo
    // Os núcleos de projeto terão contratos filtrados
    // Os núcleos especiais (produtos, materiais, grupo) são para despesas internas sem contrato
    setNucleosDisponiveis([
      "designer",     // W.G. DE ALMEIDA DESIGNER DE INTERIORES
      "arquitetura",  // WG ALMEIDA ARQUITETURA E COMERCIO LTDA
      "engenharia",   // WG ALMEIDA REFORMAS ESPECIALIZADAS LTDA
      "marcenaria",   // WG ALMEIDA MARCENARIA DE ALTO PADRAO LTDA
      "produtos",
      "materiais",
      "grupo",
    ]);
  }, [formData.pessoa_id]);

  // Atualizar contratos filtrados por núcleo
  // Para ENTRADA: filtra por cliente
  // Para SAÍDA (despesa): busca TODOS os contratos do núcleo
  useEffect(() => {
    async function buscarContratosParaLancamento() {
      if (!formData.nucleo) {
        setContratosFiltrados([]);
        setFormData((prev) => ({ ...prev, contrato_id: "" }));
        return;
      }

      try {
        // Para despesa (saída): busca todos os contratos do núcleo
        // Para receita (entrada): filtra por cliente
        if (formData.tipo === "saida") {
          // Buscar todos os contratos ativos do núcleo
          const lista = await buscarContratosPorNucleo(formData.nucleo);
          setContratosFiltrados(lista);
        } else if (formData.pessoa_id) {
          // Buscar contratos do cliente específico
          const lista = await buscarContratosPorClienteNucleo(
            formData.pessoa_id,
            formData.nucleo
          );
          setContratosFiltrados(lista);
        } else {
          setContratosFiltrados([]);
        }
      } catch (error) {
        console.error("Erro ao buscar contratos:", error);
        setContratosFiltrados([]);
      }
    }

    buscarContratosParaLancamento();
  }, [formData.pessoa_id, formData.nucleo, formData.tipo]);

  // Categorias por tipo (entrada / saída)
  useEffect(() => {
    async function carregarCategorias() {
      try {
        const cats = await obterCategorias(formData.tipo);
        setCategorias(cats);
      } catch (error) {
        console.error("Erro ao carregar categorias:", error);
        setCategorias([]);
      }
    }
    carregarCategorias();
  }, [formData.tipo]);

  function abrirForm(l?: LancamentoFinanceiro) {
    if (l) {
      const contrato = contratos.find((c) => c.id === l.contrato_id);
      setEditing(l);
      setFormData({
        pessoa_id: l.pessoa_id || "",
        tipo: l.tipo,
        nucleo:
          (l.nucleo as UnidadeNegocio) ||
          ((contrato?.unidade_negocio as UnidadeNegocio) || ""),
        contrato_id: l.contrato_id || "",
        descricao: l.descricao,
        valor: String(l.valor_total || ""),
        categoria_id: l.categoria_id || "",
        status: l.status || "previsto",
        data_competencia:
          l.data_competencia || getTodayISO(),
        vencimento: l.vencimento || "",
        projeto_id: l.projeto_id || "",
        observacoes: l.observacoes || "",
        conta_tipo: contaCodigo(l),
      });
    } else {
      setEditing(null);
      setFormData({
        pessoa_id: "",
        tipo: "entrada",
        nucleo: "",
        contrato_id: "",
        descricao: "",
        valor: "",
        categoria_id: "",
        status: "previsto",
        data_competencia: getTodayISO(),
        vencimento: "",
        projeto_id: "",
        observacoes: "",
        conta_tipo: "R",
      });
    }
    setIsFormOpen(true);
  }

  function fecharForm() {
    setIsFormOpen(false);
    setEditing(null);
    setFormData({
      pessoa_id: "",
      tipo: "entrada" as TipoLancamento,
      nucleo: "" as "" | UnidadeNegocio,
      contrato_id: "",
      descricao: "",
      valor: "",
      categoria_id: "",
      status: "previsto" as StatusLancamento,
      data_competencia: getTodayISO(),
      vencimento: "",
      projeto_id: "",
      observacoes: "",
      conta_tipo: "R" as "R" | "V",
    });
  }

  async function salvar(e: React.FormEvent) {
  e.preventDefault();

  if (!formData.descricao || !formData.valor) {
    alert("Preencha descrição e valor.");
    return;
  }

  if (formData.tipo === "saida") {
    if (!formData.pessoa_id) {
      alert("Selecione o cliente/fornecedor para despesas.");
      return;
    }
    if (!formData.nucleo) {
      alert("Selecione o núcleo para despesas.");
      return;
    }
    if (!formData.contrato_id) {
      alert("Selecione o contrato ao qual essa despesa pertence.");
      return;
    }
  }

  const payload: any = {
    descricao: formData.descricao,
    valor_total: parseFloat(formData.valor),
    tipo: formData.tipo,
    categoria_id: formData.categoria_id || null,
    status: formData.status,
    data_competencia: formData.data_competencia,
    vencimento: formData.vencimento || null,
    pessoa_id: formData.pessoa_id || null,
    projeto_id: formData.projeto_id || null,
    contrato_id: formData.contrato_id || null,
    observacoes: formData.observacoes || null,
    nucleo: formData.nucleo || null,
    referencia_tipo: formData.conta_tipo,
  };

  try {
    if (editing) {
      await atualizarLancamento(editing.id!, payload);
    } else {
      await criarLancamento(payload);
    }

    fecharForm();
    setRefreshKey((k) => k + 1); // força recarga da lista
    alert("Lançamento salvo com sucesso!");
  } catch (error: any) {
    console.error("Erro ao salvar lançamento:", error);
    alert("Erro ao salvar lançamento: " + error.message);
  }
}


  async function excluir(id: string) {
    if (!confirm("Excluir este lançamento?")) return;
    try {
      await deletarLancamento(id);
      setRefreshKey((k) => k + 1);
    } catch (error: any) {
      console.error("Erro ao excluir lançamento:", error);
      alert("Erro ao excluir lançamento: " + error.message);
    }
  }

  async function marcarPago(id: string) {
    try {
      await atualizarLancamento(id, {
        status: "pago",
        data_pagamento: getTodayISO(),
      });
      setRefreshKey((k) => k + 1);
    } catch (error: any) {
      console.error("Erro ao marcar como pago:", error);
      alert("Erro ao marcar como pago: " + error.message);
    }
  }

  // Alterar status diretamente na tabela
  async function alterarStatus(id: string, novoStatus: StatusLancamento) {
    try {
      const dados: Partial<LancamentoFinanceiro> = { status: novoStatus };

      // Se marcando como pago, adicionar data de pagamento
      if (novoStatus === "pago") {
        dados.data_pagamento = getTodayISO();
      }

      await atualizarLancamento(id, dados);
      setEditingStatusId(null);
      setRefreshKey((k) => k + 1);
    } catch (error: any) {
      console.error("Erro ao alterar status:", error);
      alert("Erro ao alterar status: " + error.message);
    }
  }

  // Duplicar lançamento (útil para reembolsos)
  async function duplicarLancamento(l: LancamentoFinanceiro) {
    try {
      const payload = {
        descricao: `${l.descricao} (Cópia)`,
        valor_total: l.valor_total,
        tipo: l.tipo,
        categoria_id: l.categoria_id || null,
        status: "previsto" as StatusLancamento,
        data_competencia: getTodayISO(),
        vencimento: null,
        pessoa_id: l.pessoa_id || null,
        projeto_id: l.projeto_id || null,
        contrato_id: l.contrato_id || null,
        observacoes: l.observacoes || null,
        nucleo: l.nucleo || null,
        referencia_tipo: l.referencia_tipo || "R",
      };
      await criarLancamento(payload);
      setRefreshKey((k) => k + 1);
      setActionMenuId(null);
      alert("Lançamento duplicado com sucesso!");
    } catch (error: any) {
      console.error("Erro ao duplicar lançamento:", error);
      alert("Erro ao duplicar: " + error.message);
    }
  }

  // Limpar todos os filtros
  function limparFiltros() {
    setSearchTerm("");
    setFilterTipo("");
    setFilterStatus("");
    setFilterNucleo("");
    setFilterContaTipo("");
    setFilterCentroCusto("");
    setFilterDataInicio("");
    setFilterDataFim("");
    setFilterCategoria("");
  }

  // Contar filtros ativos
  const filtrosAtivos = [
    filterTipo, filterStatus, filterNucleo, filterContaTipo,
    filterCentroCusto, filterDataInicio, filterDataFim, filterCategoria
  ].filter(Boolean).length;

  // Paginação calculada
  const totalPages = Math.ceil(lancamentos.length / itemsPerPage);
  const lancamentosPaginados = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    return lancamentos.slice(startIndex, endIndex);
  }, [lancamentos, currentPage, itemsPerPage]);

  // Resumo financeiro dos lançamentos filtrados
  const resumoFinanceiro = useMemo(() => {
    const entradas = lancamentos
      .filter((l) => l.tipo === "entrada")
      .reduce((acc, l) => acc + Number(l.valor_total || 0), 0);
    const saidas = lancamentos
      .filter((l) => l.tipo === "saida")
      .reduce((acc, l) => acc + Number(l.valor_total || 0), 0);
    return {
      entradas,
      saidas,
      resultado: entradas - saidas,
    };
  }, [lancamentos]);

  const clienteSelecionado = pessoas.find((p) => p.id === formData.pessoa_id);

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      {/* Header Compacto */}
      <div className="mb-4 flex items-center justify-between gap-3 flex-wrap">
        <div>
          <h1 className="text-lg font-bold text-gray-900">
            Lançamentos Financeiros
          </h1>
          <p className="text-gray-500 text-xs">
            Núcleo, centro de custo e conta Real / Virtual
          </p>
        </div>

        {/* Resumo Financeiro */}
        <div className="flex items-center gap-4 bg-white rounded-lg px-4 py-2 shadow-sm border border-gray-100">
          <div className="text-center">
            <p className="text-[10px] text-gray-500 uppercase tracking-wide">Entradas</p>
            <p className="text-sm font-semibold text-green-600">
              +R$ {resumoFinanceiro.entradas.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
            </p>
          </div>
          <div className="h-8 w-px bg-gray-200" />
          <div className="text-center">
            <p className="text-[10px] text-gray-500 uppercase tracking-wide">Saídas</p>
            <p className="text-sm font-semibold text-red-600">
              -R$ {resumoFinanceiro.saidas.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
            </p>
          </div>
          <div className="h-8 w-px bg-gray-200" />
          <div className="text-center">
            <p className="text-[10px] text-gray-500 uppercase tracking-wide">Resultado</p>
            <p className={`text-sm font-bold ${resumoFinanceiro.resultado >= 0 ? "text-green-600" : "text-red-600"}`}>
              R$ {resumoFinanceiro.resultado.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={() => setRefreshKey((k) => k + 1)}
            className="p-2 text-gray-500 hover:text-gray-700 hover:bg-gray-100 rounded-lg"
            title="Atualizar lista"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
          <button
            type="button"
            onClick={() => abrirForm()}
            className="px-3 py-1.5 bg-[#F25C26] text-white rounded-lg flex items-center gap-1.5 hover:bg-[#d94d1f] text-sm"
          >
            <Plus className="w-4 h-4" />
            Novo Lançamento
          </button>
        </div>
      </div>

      {/* Barra de Busca e Contagem */}
      <div className="bg-white rounded-lg shadow-sm p-3 mb-4">
        <div className="flex items-center gap-3 flex-wrap">
          {/* Busca */}
          <div className="relative flex-1 min-w-[200px] max-w-[300px]">
            <Search className="w-3.5 h-3.5 text-gray-400 absolute left-2.5 top-1/2 -translate-y-1/2" />
            <input
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Buscar descrição..."
              className="w-full pl-8 pr-3 py-1.5 border border-gray-200 rounded-lg text-xs"
            />
          </div>

          {/* Botão Filtros */}
          <button
            type="button"
            onClick={() => setShowFilters(!showFilters)}
            className={`px-3 py-1.5 border rounded-lg flex items-center gap-1.5 text-xs ${
              showFilters || filtrosAtivos > 0
                ? "border-[#F25C26] text-[#F25C26] bg-orange-50"
                : "border-gray-200 text-gray-600 hover:bg-gray-50"
            }`}
          >
            <Filter className="w-3.5 h-3.5" />
            Filtros
            {filtrosAtivos > 0 && (
              <span className="bg-[#F25C26] text-white text-[10px] px-1.5 py-0.5 rounded-full">
                {filtrosAtivos}
              </span>
            )}
          </button>

          {/* Limpar Filtros */}
          {filtrosAtivos > 0 && (
            <button
              type="button"
              onClick={limparFiltros}
              className="px-2 py-1.5 text-xs text-gray-500 hover:text-red-600 flex items-center gap-1"
            >
              <X className="w-3 h-3" />
              Limpar
            </button>
          )}

          {/* Contagem */}
          <span className="text-xs text-gray-400 ml-auto">
            {lancamentos.length} lançamento{lancamentos.length !== 1 ? "s" : ""}
          </span>
        </div>
      </div>

      {/* Tabela Compacta */}
      {loading ? (
        <div className="flex justify-center items-center py-8">
          <div className="h-8 w-8 border-2 border-[#F25C26] border-t-transparent rounded-full animate-spin" />
        </div>
      ) : (
        <div className="bg-white rounded-lg shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-xs">
              <thead className="bg-gray-50 border-b border-gray-200">
                {/* Linha de Filtros */}
                {showFilters && (
                  <tr className="bg-gray-100/50">
                    <th className="px-2 py-1.5 min-w-[200px]">
                      <select
                        value={filterTipo}
                        onChange={(e) => setFilterTipo(e.target.value as TipoLancamento | "")}
                        className="w-full px-1.5 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Filtrar por tipo"
                      >
                        <option value="">Todos</option>
                        <option value="entrada">Entrada</option>
                        <option value="saida">Saída</option>
                      </select>
                    </th>
                    <th className="px-2 py-1.5 min-w-[140px]">
                      <input
                        type="text"
                        value={filterCentroCusto}
                        onChange={(e) => setFilterCentroCusto(e.target.value)}
                        placeholder="Buscar..."
                        className="w-full px-1.5 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Filtrar por centro de custo"
                      />
                    </th>
                    <th className="px-2 py-1.5">
                      <select
                        value={filterCategoria}
                        onChange={(e) => setFilterCategoria(e.target.value)}
                        className="w-full px-1.5 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Filtrar por categoria"
                      >
                        <option value="">Todas</option>
                        {todasCategorias.map((c) => (
                          <option key={c.id} value={c.id}>{c.name}</option>
                        ))}
                      </select>
                    </th>
                    <th className="px-1 py-1.5 w-10">
                      <select
                        value={filterContaTipo}
                        onChange={(e) => setFilterContaTipo(e.target.value as "" | "R" | "V")}
                        className="w-full px-1 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Filtrar por conta"
                      >
                        <option value="">-</option>
                        <option value="R">R</option>
                        <option value="V">V</option>
                      </select>
                    </th>
                    <th className="px-2 py-1.5">
                      <select
                        value={filterNucleo}
                        onChange={(e) => setFilterNucleo(e.target.value as UnidadeNegocio | "")}
                        className="w-full px-1.5 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Filtrar por núcleo"
                      >
                        <option value="">Todos</option>
                        <option value="designer">Designer</option>
                        <option value="arquitetura">Arq.</option>
                        <option value="engenharia">Eng.</option>
                        <option value="marcenaria">Marc.</option>
                      </select>
                    </th>
                    <th className="px-1 py-1.5">
                      <DateInputBR
                        value={filterDataInicio}
                        onChange={setFilterDataInicio}
                        className="w-full px-1 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Data de"
                        placeholder="dd/mm/aaaa"
                      />
                    </th>
                    <th className="px-1 py-1.5">
                      <DateInputBR
                        value={filterDataFim}
                        onChange={setFilterDataFim}
                        className="w-full px-1 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Data até"
                        placeholder="dd/mm/aaaa"
                      />
                    </th>
                    <th className="px-1 py-1.5"></th>
                    <th className="px-1 py-1.5">
                      <select
                        value={filterStatus}
                        onChange={(e) => setFilterStatus(e.target.value as StatusLancamento | "")}
                        className="w-full px-1 py-1 text-[10px] border border-gray-200 rounded bg-white"
                        title="Filtrar por status"
                      >
                        <option value="">Todos</option>
                        <option value="previsto">Previsto</option>
                        <option value="pago">Pago</option>
                        <option value="atrasado">Atrasado</option>
                        <option value="cancelado">Cancelado</option>
                      </select>
                    </th>
                    <th className="px-1 py-1.5 w-12"></th>
                  </tr>
                )}
                {/* Linha de Títulos */}
                <tr>
                  <th className="px-2 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase tracking-wide min-w-[200px]">
                    Descrição
                  </th>
                  <th className="px-2 py-2 text-left text-[10px] font-semibold text-gray-500 uppercase tracking-wide min-w-[140px]">
                    Centro Custo
                  </th>
                  <th className="px-2 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">
                    Categoria
                  </th>
                  <th className="px-2 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide w-10">
                    Cta
                  </th>
                  <th className="px-2 py-2 text-right text-[10px] font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">
                    Valor
                  </th>
                  <th className="px-2 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">
                    Criação
                  </th>
                  <th className="px-2 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">
                    Venc.
                  </th>
                  <th className="px-2 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">
                    Pgto
                  </th>
                  <th className="px-2 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide whitespace-nowrap">
                    Status
                  </th>
                  <th className="px-1 py-2 text-center text-[10px] font-semibold text-gray-500 uppercase tracking-wide w-12">
                    Ações
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {lancamentosPaginados.length === 0 ? (
                  <tr>
                    <td className="px-3 py-8 text-center text-gray-400 text-xs" colSpan={12}>
                      Nenhum lançamento encontrado
                    </td>
                  </tr>
                ) : (
                  lancamentosPaginados.map((l) => {
                    const conta = contaCodigo(l);
                    const nucleo =
                      (l.nucleo as UnidadeNegocio | null) ||
                      ((l.contrato as any)?.unidade_negocio as UnidadeNegocio | null);
                    const nomeCliente = l.pessoa?.nome || "";
                    const codigoContrato = l.contrato?.numero || "";
                    const nomeProjeto = l.projeto?.nome || "";
                    return (
                      <tr key={l.id} className="hover:bg-gray-50/50 group">
                        {/* Descrição + Núcleo (2 linhas) */}
                        <td className="px-2 py-1.5">
                          <div className="flex items-start gap-1.5">
                            {l.tipo === "entrada" ? (
                              <ArrowUpCircle className="w-3.5 h-3.5 text-green-500 mt-0.5 flex-shrink-0" title="Entrada" />
                            ) : (
                              <ArrowDownCircle className="w-3.5 h-3.5 text-red-500 mt-0.5 flex-shrink-0" title="Saída" />
                            )}
                            <div className="min-w-0">
                              <div className="font-medium text-gray-800 text-[11px] truncate" title={l.descricao}>
                                {l.descricao}
                              </div>
                              {nucleo && (
                                <span
                                  className="text-[10px] font-medium"
                                  style={{ color: NUCLEOS_CORES[nucleo] }}
                                >
                                  {NUCLEOS_LABELS[nucleo]}
                                </span>
                              )}
                            </div>
                          </div>
                        </td>
                        {/* Centro Custo (Cliente) */}
                        <td className="px-2 py-1.5">
                          <div className="max-w-[140px]">
                            {codigoContrato && (
                              <div className="font-semibold text-gray-800 text-[10px] truncate" title={`Contrato: ${codigoContrato}`}>
                                {codigoContrato}
                              </div>
                            )}
                            {nomeCliente ? (
                              <div className="text-[10px] text-gray-600 truncate" title={nomeCliente}>
                                {nomeCliente}
                              </div>
                            ) : nomeProjeto ? (
                              <div className="text-[10px] text-blue-600 truncate" title={nomeProjeto}>
                                {nomeProjeto}
                              </div>
                            ) : (
                              <span className="text-gray-300 text-[10px]">-</span>
                            )}
                          </div>
                        </td>
                        {/* Categoria */}
                        <td className="px-2 py-1.5 text-center">
                          <span className="text-gray-600 text-[10px] whitespace-nowrap">
                            {todasCategorias.find(c => c.id === l.categoria_id)?.name || "-"}
                          </span>
                        </td>
                        {/* Conta */}
                        <td className="px-1 py-1.5 text-center">
                          <span className={`px-1 py-0.5 rounded text-[9px] font-bold ${
                            conta === "R"
                              ? "bg-blue-100 text-blue-700"
                              : "bg-purple-100 text-purple-700"
                          }`}>
                            {conta}
                          </span>
                        </td>
                        {/* Valor */}
                        <td className="px-2 py-1.5 text-right whitespace-nowrap">
                          <span className={`font-semibold text-[11px] ${
                            l.tipo === "entrada" ? "text-green-600" : "text-red-600"
                          }`}>
                            {l.tipo === "entrada" ? "+" : "-"}R$ {Number(l.valor_total).toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
                          </span>
                        </td>
                        {/* Data Criação */}
                        <td className="px-1 py-1.5 text-center text-gray-500 text-[10px] whitespace-nowrap">
                          {l.data_competencia
                            ? new Date(l.data_competencia).toLocaleDateString("pt-BR")
                            : "-"}
                        </td>
                        {/* Data Vencimento */}
                        <td className="px-1 py-1.5 text-center text-[10px] whitespace-nowrap">
                          {l.vencimento ? (
                            <span className={`${
                              new Date(l.vencimento) < new Date() && l.status !== 'pago' && l.status !== 'cancelado'
                                ? 'text-red-600 font-medium'
                                : 'text-gray-500'
                            }`}>
                              {new Date(l.vencimento).toLocaleDateString("pt-BR")}
                            </span>
                          ) : (
                            <span className="text-gray-300">-</span>
                          )}
                        </td>
                        {/* Data Pagamento */}
                        <td className="px-1 py-1.5 text-center text-[10px] whitespace-nowrap">
                          {l.data_pagamento ? (
                            <span className="text-green-600 font-medium">
                              {new Date(l.data_pagamento).toLocaleDateString("pt-BR")}
                            </span>
                          ) : (
                            <span className="text-gray-300">-</span>
                          )}
                        </td>
                        {/* Status - Clicável para editar */}
                        <td className="px-1 py-1.5 text-center relative">
                          {editingStatusId === l.id ? (
                            <select
                              autoFocus
                              value={l.status}
                              onChange={(e) => alterarStatus(l.id!, e.target.value as StatusLancamento)}
                              onBlur={() => setEditingStatusId(null)}
                              title="Selecionar status do lançamento"
                              className="text-[10px] px-1 py-0.5 border border-gray-300 rounded bg-white focus:outline-none focus:ring-2 focus:ring-[#F25C26] cursor-pointer"
                            >
                              <option value="previsto">Previsto</option>
                              <option value="pago">{l.tipo === "entrada" ? "Recebido" : "Pago"}</option>
                              <option value="atrasado">Atrasado</option>
                              <option value="cancelado">Cancelado</option>
                            </select>
                          ) : (
                            <button
                              type="button"
                              onClick={() => setEditingStatusId(l.id!)}
                              className="cursor-pointer hover:opacity-80 transition-opacity"
                              title="Clique para alterar status"
                            >
                              {l.status === "pago" ? (
                                l.tipo === "entrada" ? (
                                  <span className="inline-flex items-center gap-0.5 text-[10px] px-1.5 py-0.5 rounded-full bg-green-50 text-green-600">
                                    <CheckCircle className="w-3 h-3" />
                                    Recebido
                                  </span>
                                ) : (
                                  <span className="inline-flex items-center gap-0.5 text-[10px] px-1.5 py-0.5 rounded-full bg-red-50 text-red-600">
                                    <CheckCircle className="w-3 h-3" />
                                    Pago
                                  </span>
                                )
                              ) : l.status === "atrasado" ? (
                                <span className="inline-flex items-center gap-0.5 text-[10px] px-1.5 py-0.5 rounded-full bg-red-50 text-red-600">
                                  <XCircle className="w-3 h-3" />
                                  Atrasado
                                </span>
                              ) : l.status === "cancelado" ? (
                                <span className="inline-flex items-center gap-0.5 text-[10px] px-1.5 py-0.5 rounded-full bg-gray-100 text-gray-500">
                                  <XCircle className="w-3 h-3" />
                                  Cancelado
                                </span>
                              ) : (
                                <span className="inline-flex items-center gap-0.5 text-[10px] px-1.5 py-0.5 rounded-full bg-amber-50 text-amber-600">
                                  <Calendar className="w-3 h-3" />
                                  Previsto
                                </span>
                              )}
                            </button>
                          )}
                        </td>
                        {/* Ações */}
                        <td className="px-1 py-1.5">
                          <div className="flex items-center justify-center gap-0.5 relative">
                            {l.status === "previsto" && (
                              <button
                                type="button"
                                onClick={() => marcarPago(l.id!)}
                                className="p-1 text-gray-400 hover:text-green-600 hover:bg-green-50 rounded"
                                title="Marcar como pago"
                              >
                                <CheckCircle className="w-3.5 h-3.5" />
                              </button>
                            )}
                            <button
                              type="button"
                              onClick={() => abrirForm(l)}
                              className="p-1 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded"
                              title="Editar"
                            >
                              <Edit className="w-3.5 h-3.5" />
                            </button>
                            {/* Menu de mais ações */}
                            <div className="relative">
                              <button
                                type="button"
                                onClick={() => setActionMenuId(actionMenuId === l.id ? null : l.id!)}
                                className="p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded"
                                title="Mais ações"
                              >
                                <MoreHorizontal className="w-3.5 h-3.5" />
                              </button>
                              {actionMenuId === l.id && (
                                <div className="absolute right-0 top-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg py-1 z-20 min-w-[120px]">
                                  <button
                                    type="button"
                                    onClick={() => duplicarLancamento(l)}
                                    className="w-full px-3 py-1.5 text-left text-xs text-gray-700 hover:bg-gray-50 flex items-center gap-2"
                                  >
                                    <Copy className="w-3 h-3" />
                                    Duplicar
                                  </button>
                                  <button
                                    type="button"
                                    onClick={() => {
                                      setActionMenuId(null);
                                      excluir(l.id!);
                                    }}
                                    className="w-full px-3 py-1.5 text-left text-xs text-red-600 hover:bg-red-50 flex items-center gap-2"
                                  >
                                    <Trash2 className="w-3 h-3" />
                                    Excluir
                                  </button>
                                </div>
                              )}
                            </div>
                          </div>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>

          {/* Paginação */}
          {lancamentos.length > 0 && (
            <div className="px-4 py-3 border-t border-gray-200 flex items-center justify-between flex-wrap gap-2">
              <div className="flex items-center gap-2 text-xs text-gray-500">
                <span>Exibindo {((currentPage - 1) * itemsPerPage) + 1} a {Math.min(currentPage * itemsPerPage, lancamentos.length)} de {lancamentos.length}</span>
                <select
                  value={itemsPerPage}
                  onChange={(e) => {
                    setItemsPerPage(Number(e.target.value));
                    setCurrentPage(1);
                  }}
                  className="px-2 py-1 border border-gray-200 rounded text-xs"
                  title="Itens por página"
                >
                  <option value={25}>25 por página</option>
                  <option value={50}>50 por página</option>
                  <option value={100}>100 por página</option>
                  <option value={200}>200 por página</option>
                </select>
              </div>
              <div className="flex items-center gap-1">
                <button
                  type="button"
                  onClick={() => setCurrentPage(1)}
                  disabled={currentPage === 1}
                  className="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed"
                  title="Primeira página"
                >
                  <ChevronsLeft className="w-4 h-4 text-gray-600" />
                </button>
                <button
                  type="button"
                  onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                  className="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed"
                  title="Página anterior"
                >
                  <ChevronLeft className="w-4 h-4 text-gray-600" />
                </button>
                <span className="px-3 py-1 text-xs text-gray-700">
                  Página {currentPage} de {totalPages}
                </span>
                <button
                  type="button"
                  onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                  disabled={currentPage === totalPages}
                  className="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed"
                  title="Próxima página"
                >
                  <ChevronRight className="w-4 h-4 text-gray-600" />
                </button>
                <button
                  type="button"
                  onClick={() => setCurrentPage(totalPages)}
                  disabled={currentPage === totalPages}
                  className="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed"
                  title="Última página"
                >
                  <ChevronsRight className="w-4 h-4 text-gray-600" />
                </button>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Modal simples de criação/edição */}
      {isFormOpen && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="px-4 py-3 border-b border-gray-200 flex items-center justify-between">
              <h2 className="text-lg font-semibold">
                {editing ? "Editar lançamento" : "Novo lançamento"}
              </h2>
            </div>
            <form onSubmit={salvar} className="p-4 space-y-4 text-sm">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="md:col-span-2">
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Cliente / Fornecedor
                  </label>
                  <select
                    value={formData.pessoa_id}
                    onChange={(e) =>
                      setFormData((p) => ({
                        ...p,
                        pessoa_id: e.target.value,
                        nucleo: "",
                        contrato_id: "",
                      }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    title="Selecionar cliente ou fornecedor"
                  >
                    <option value="">Selecione</option>
                    {pessoas.map((p) => (
                      <option key={p.id} value={p.id}>
                        {p.nome}
                      </option>
                    ))}
                  </select>
                  {clienteSelecionado && (
                    <p className="text-xs text-gray-500 mt-1">
                      {clienteSelecionado.email || clienteSelecionado.telefone}
                    </p>
                  )}
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Tipo
                  </label>
                  <select
                    value={formData.tipo}
                    onChange={(e) =>
                      setFormData((p) => ({
                        ...p,
                        tipo: e.target.value as TipoLancamento,
                      }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    title="Selecionar tipo de lançamento"
                  >
                    <option value="entrada">Entrada</option>
                    <option value="saida">Saída</option>
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Núcleo {formData.tipo === "saida" && <span className="text-red-500">*</span>}
                  </label>
                  <select
                    value={formData.nucleo}
                    onChange={(e) =>
                      setFormData((p) => ({
                        ...p,
                        nucleo: e.target.value as UnidadeNegocio | "",
                        contrato_id: "",
                      }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    required={formData.tipo === "saida"}
                    title="Selecionar núcleo"
                  >
                    <option value="">Selecione</option>
                    {nucleosDisponiveis.map((n) => (
                      <option key={n} value={n}>
                        {NUCLEOS_LABELS[n]}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Contrato{" "}
                    {formData.tipo === "saida" && (
                      <span className="text-red-500">*</span>
                    )}
                  </label>
                  <select
                    value={formData.contrato_id}
                    onChange={(e) =>
                      setFormData((p) => ({ ...p, contrato_id: e.target.value }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    required={formData.tipo === "saida"}
                    title="Selecionar contrato"
                  >
                    <option value="">Selecione um contrato</option>
                    {contratosFiltrados.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.numero} - {(c.pessoas as any)?.nome || c.titulo || 'Cliente'}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Conta (Real / Virtual)
                  </label>
                  <select
                    value={formData.conta_tipo}
                    onChange={(e) =>
                      setFormData((p) => ({
                        ...p,
                        conta_tipo: e.target.value as "R" | "V",
                      }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    title="Selecionar tipo de conta"
                  >
                    <option value="R">Real (R)</option>
                    <option value="V">Virtual (V)</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">
                  Descrição *
                </label>
                <input
                  value={formData.descricao}
                  onChange={(e) =>
                    setFormData((p) => ({ ...p, descricao: e.target.value }))
                  }
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  required
                  placeholder="Digite a descrição"
                  title="Descrição do lançamento"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Valor *
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={formData.valor}
                    onChange={(e) =>
                      setFormData((p) => ({ ...p, valor: e.target.value }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    required
                    placeholder="0.00"
                    title="Valor do lançamento"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Data de competência
                  </label>
                  <DateInputBR
                    value={formData.data_competencia}
                    onChange={(val) => setFormData((p) => ({ ...p, data_competencia: val }))}
                    disabled
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50"
                    title="Data de competência"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Vencimento
                  </label>
                  <DateInputBR
                    value={formData.vencimento}
                    onChange={(val) => setFormData((p) => ({ ...p, vencimento: val }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    title="Data de vencimento"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Categoria *
                  </label>
                  <select
                    value={formData.categoria_id}
                    onChange={(e) =>
                      setFormData((p) => ({
                        ...p,
                        categoria_id: e.target.value,
                      }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    required
                    title="Selecionar categoria"
                  >
                    <option value="">Selecione</option>
                    {categorias.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-medium text-gray-700 mb-1">
                    Status
                  </label>
                  <select
                    value={formData.status}
                    onChange={(e) =>
                      setFormData((p) => ({
                        ...p,
                        status: e.target.value as StatusLancamento,
                      }))
                    }
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    title="Selecionar status"
                  >
                    <option value="previsto">Previsto</option>
                    <option value="pago">Pago</option>
                    <option value="atrasado">Atrasado</option>
                    <option value="cancelado">Cancelado</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-xs font-medium text-gray-700 mb-1">
                  Observações
                </label>
                <textarea
                  value={formData.observacoes}
                  onChange={(e) =>
                    setFormData((p) => ({ ...p, observacoes: e.target.value }))
                  }
                  rows={3}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  placeholder="Digite as observações (opcional)"
                  title="Observações"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-gray-200">
                <button
                  type="button"
                  onClick={fecharForm}
                  className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 text-sm"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-[#F25C26] text-white rounded-lg text-sm hover:bg-[#d94d1f]"
                >
                  {editing ? "Salvar" : "Criar"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
