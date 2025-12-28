import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import {
  listarOS,
  deletarOS,
  alterarStatusOS,
  obterEstatisticasOS,
  type OrdemServicoCompleta,
  type OSEstatisticas,
} from "@/lib/assistenciaApi";
import {
  STATUS_OS_LABELS,
  STATUS_OS_COLORS,
  PRIORIDADE_LABELS,
  PRIORIDADE_COLORS,
  formatarValor,
  formatarData,
  getStatusOSIcon,
  getPrioridadeIcon,
  getUrgenciaOS,
} from "@/types/assistenciaTecnica";

export default function AssistenciaPage() {
  const [ordens, setOrdens] = useState<OrdemServicoCompleta[]>([]);
  const [stats, setStats] = useState<OSEstatisticas | null>(null);
  const [loading, setLoading] = useState(true);
  const [filtroStatus, setFiltroStatus] = useState<string>("");
  const [filtroPrioridade, setFiltroPrioridade] = useState<string>("");

  async function carregar() {
    setLoading(true);
    try {
      const [ordensData, statsData] = await Promise.all([
        listarOS(),
        obterEstatisticasOS(),
      ]);
      setOrdens(ordensData);
      setStats(statsData);
    } catch (err) {
      console.error("Erro ao carregar ordens de serviço:", err);
    }
    setLoading(false);
  }

  useEffect(() => {
    carregar();
  }, []);

  async function remover(id: string) {
    if (!confirm("Excluir esta ordem de serviço?")) return;
    try {
      await deletarOS(id);
      carregar();
    } catch (err) {
      console.error("Erro ao deletar OS:", err);
      alert("Erro ao deletar OS");
    }
  }

  async function mudarStatus(id: string, novoStatus: any) {
    try {
      await alterarStatusOS(id, novoStatus);
      carregar();
    } catch (err) {
      console.error("Erro ao alterar status:", err);
      alert("Erro ao alterar status");
    }
  }

  let ordensFiltradas = ordens;
  if (filtroStatus) {
    ordensFiltradas = ordensFiltradas.filter((os) => os.status === filtroStatus);
  }
  if (filtroPrioridade) {
    ordensFiltradas = ordensFiltradas.filter((os) => os.prioridade === filtroPrioridade);
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center h-[50vh] text-[#4C4C4C]">
        Carregando ordens de serviço...
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* HEADER */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-[#2E2E2E]">
            Assistência Técnica
          </h1>
          <p className="text-sm text-[#4C4C4C]">
            Gerencie ordens de serviço, atendimentos e manutenções.
          </p>
        </div>

        <div className="flex flex-wrap gap-2">
          <Link
            to="/assistencia/novo"
            className="px-4 py-2 text-sm bg-[#F25C26] text-white rounded hover:bg-[#d54b1c]"
          >
            Nova Ordem de Serviço
          </Link>
        </div>
      </div>

      {/* CARDS DE ESTATÍSTICAS */}
      {stats && (
        <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Total de OS</div>
            <div className="text-2xl font-bold text-[#2E2E2E]">{stats.total_os}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Abertas</div>
            <div className="text-2xl font-bold text-[#F59E0B]">{stats.os_abertas}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Em Atendimento</div>
            <div className="text-2xl font-bold text-[#3B82F6]">{stats.os_em_atendimento}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Concluídas</div>
            <div className="text-2xl font-bold text-[#10B981]">{stats.os_concluidas}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Valor Mês</div>
            <div className="text-xl font-bold text-[#10B981]">{formatarValor(stats.valor_total_mes)}</div>
          </div>
        </div>
      )}

      {/* FILTROS */}
      <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
        <div className="space-y-3">
          <div>
            <div className="text-xs font-semibold text-[#4C4C4C] mb-2">Status</div>
            <div className="flex gap-2 flex-wrap">
              <button
                onClick={() => setFiltroStatus("")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroStatus === ""
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Todos
              </button>
              <button
                onClick={() => setFiltroStatus("aberta")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroStatus === "aberta"
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Abertas
              </button>
              <button
                onClick={() => setFiltroStatus("em_atendimento")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroStatus === "em_atendimento"
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Em Atendimento
              </button>
              <button
                onClick={() => setFiltroStatus("concluida")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroStatus === "concluida"
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Concluídas
              </button>
            </div>
          </div>

          <div>
            <div className="text-xs font-semibold text-[#4C4C4C] mb-2">Prioridade</div>
            <div className="flex gap-2 flex-wrap">
              <button
                onClick={() => setFiltroPrioridade("")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroPrioridade === ""
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Todas
              </button>
              <button
                onClick={() => setFiltroPrioridade("urgente")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroPrioridade === "urgente"
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Urgentes
              </button>
              <button
                onClick={() => setFiltroPrioridade("alta")}
                className={`px-3 py-1 text-sm rounded ${
                  filtroPrioridade === "alta"
                    ? "bg-[#F25C26] text-white"
                    : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
                }`}
              >
                Alta
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* TABELA */}
      <div className="bg-white rounded-xl shadow-md border border-[#E5E5E5] overflow-hidden">
        <table className="w-full text-xs md:text-sm">
          <thead className="bg-[#F3F3F3] text-[#2E2E2E]">
            <tr>
              <th className="p-3 text-left">Número</th>
              <th className="p-3 text-left">Cliente</th>
              <th className="p-3 text-left">Título</th>
              <th className="p-3 text-left">Técnico</th>
              <th className="p-3 text-left">Status</th>
              <th className="p-3 text-left">Prioridade</th>
              <th className="p-3 text-left">Abertura</th>
              <th className="p-3 text-left">Previsão</th>
              <th className="p-3 text-left">Valor</th>
              <th className="p-3 text-left">Ações</th>
            </tr>
          </thead>
          <tbody>
            {ordensFiltradas.map((os) => {
              const urgencia = getUrgenciaOS(os);
              return (
                <tr key={os.id} className="border-b hover:bg-[#fafafa]">
                  <td className="p-3">
                    <div className="flex items-center gap-2">
                      <span>{getStatusOSIcon(os.status)}</span>
                      <span className="font-mono">{os.numero}</span>
                    </div>
                  </td>
                  <td className="p-3">{os.cliente?.nome || "-"}</td>
                  <td className="p-3">
                    <div>
                      <div className="font-medium">{os.titulo}</div>
                      <div className="text-xs text-[#4C4C4C]">{os.tipo_atendimento}</div>
                    </div>
                  </td>
                  <td className="p-3">{os.tecnico?.nome || "-"}</td>
                  <td className="p-3">
                    <span
                      className="px-2 py-1 rounded text-xs text-white"
                      style={{ backgroundColor: STATUS_OS_COLORS[os.status] }}
                    >
                      {STATUS_OS_LABELS[os.status]}
                    </span>
                  </td>
                  <td className="p-3">
                    <span
                      className="px-2 py-1 rounded text-xs text-white flex items-center gap-1 w-fit"
                      style={{ backgroundColor: PRIORIDADE_COLORS[os.prioridade] }}
                    >
                      <span>{getPrioridadeIcon(os.prioridade)}</span>
                      <span>{PRIORIDADE_LABELS[os.prioridade]}</span>
                    </span>
                  </td>
                  <td className="p-3">{formatarData(os.data_abertura)}</td>
                  <td className="p-3">
                    {os.data_previsao ? (
                      <div>
                        <div>{formatarData(os.data_previsao)}</div>
                        {urgencia.urgente && (
                          <div
                            className="text-xs font-medium"
                            style={{ color: urgencia.color }}
                          >
                            {urgencia.label}
                          </div>
                        )}
                      </div>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td className="p-3 font-semibold">{formatarValor(os.valor_total)}</td>
                  <td className="p-3 space-x-2">
                    <Link
                      to={`/assistencia/detalhe/${os.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Ver
                    </Link>
                    <Link
                      to={`/assistencia/editar/${os.id}`}
                      className="text-green-600 hover:underline"
                    >
                      Editar
                    </Link>
                    {os.status === "aberta" && (
                      <button
                        onClick={() => mudarStatus(os.id, "em_atendimento")}
                        className="text-blue-700 hover:underline"
                      >
                        Iniciar
                      </button>
                    )}
                    {(os.status === "em_atendimento" || os.status === "aguardando_cliente") && (
                      <button
                        onClick={() => mudarStatus(os.id, "concluida")}
                        className="text-green-700 hover:underline"
                      >
                        Concluir
                      </button>
                    )}
                    <button
                      onClick={() => remover(os.id)}
                      className="text-red-600 hover:underline"
                    >
                      Excluir
                    </button>
                  </td>
                </tr>
              );
            })}

            {ordensFiltradas.length === 0 && (
              <tr>
                <td colSpan={10} className="p-4 text-center text-[#4C4C4C]">
                  Nenhuma ordem de serviço encontrada.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
