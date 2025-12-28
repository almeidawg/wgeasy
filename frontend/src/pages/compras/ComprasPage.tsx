import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import {
  listarPedidosCompra,
  deletarPedidoCompra,
  alterarStatusPedidoCompra,
  obterEstatisticasPedidosCompra,
  type PedidoCompraCompleto,
  type PedidosCompraEstatisticas,
} from "@/lib/comprasApi";
import {
  STATUS_PEDIDO_LABELS,
  STATUS_PEDIDO_COLORS,
  formatarValor,
  formatarData,
  getStatusPedidoIcon,
  getUrgenciaPedido,
} from "@/types/pedidosCompra";

export default function ComprasPage() {
  const [pedidos, setPedidos] = useState<PedidoCompraCompleto[]>([]);
  const [stats, setStats] = useState<PedidosCompraEstatisticas | null>(null);
  const [loading, setLoading] = useState(true);
  const [filtroStatus, setFiltroStatus] = useState<string>("");

  async function carregar() {
    setLoading(true);
    try {
      const [pedidosData, statsData] = await Promise.all([
        listarPedidosCompra(),
        obterEstatisticasPedidosCompra(),
      ]);
      setPedidos(pedidosData);
      setStats(statsData);
    } catch (err) {
      console.error("Erro ao carregar pedidos de compra:", err);
    }
    setLoading(false);
  }

  useEffect(() => {
    carregar();
  }, []);

  async function remover(id: string) {
    if (!confirm("Excluir este pedido de compra?")) return;
    try {
      await deletarPedidoCompra(id);
      carregar();
    } catch (err) {
      console.error("Erro ao deletar pedido:", err);
      alert("Erro ao deletar pedido");
    }
  }

  async function mudarStatus(id: string, novoStatus: any) {
    try {
      await alterarStatusPedidoCompra(id, novoStatus);
      carregar();
    } catch (err) {
      console.error("Erro ao alterar status:", err);
      alert("Erro ao alterar status");
    }
  }

  const pedidosFiltrados = filtroStatus
    ? pedidos.filter((p) => p.status === filtroStatus)
    : pedidos;

  if (loading) {
    return (
      <div className="flex justify-center items-center h-[50vh] text-[#4C4C4C]">
        Carregando pedidos de compra...
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* HEADER */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-[#2E2E2E]">
            Pedidos de Compra
          </h1>
          <p className="text-sm text-[#4C4C4C]">
            Gerencie pedidos de compra, fornecedores e controle de entregas.
          </p>
        </div>

        <div className="flex flex-wrap gap-2">
          <Link
            to="/compras/importar"
            className="px-3 py-2 text-sm bg-white border border-[#E5E5E5] rounded hover:bg-[#F3F3F3]"
          >
            Importar Item
          </Link>
          <Link
            to="/compras/novo"
            className="px-4 py-2 text-sm bg-[#F25C26] text-white rounded hover:bg-[#d54b1c]"
          >
            Novo Pedido
          </Link>
        </div>
      </div>

      {/* CARDS DE ESTATÍSTICAS */}
      {stats && (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Total de Pedidos</div>
            <div className="text-2xl font-bold text-[#2E2E2E]">{stats.total_pedidos}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Pendentes</div>
            <div className="text-2xl font-bold text-[#F59E0B]">{stats.pedidos_pendentes}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Em Trânsito</div>
            <div className="text-2xl font-bold text-[#8B5CF6]">{stats.pedidos_em_transito}</div>
          </div>
          <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
            <div className="text-xs text-[#4C4C4C] mb-1">Valor Mês</div>
            <div className="text-2xl font-bold text-[#10B981]">{formatarValor(stats.valor_total_mes)}</div>
          </div>
        </div>
      )}

      {/* FILTROS */}
      <div className="bg-white p-4 rounded-lg shadow-sm border border-[#E5E5E5]">
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
            onClick={() => setFiltroStatus("pendente")}
            className={`px-3 py-1 text-sm rounded ${
              filtroStatus === "pendente"
                ? "bg-[#F25C26] text-white"
                : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
            }`}
          >
            Pendentes
          </button>
          <button
            onClick={() => setFiltroStatus("aprovado")}
            className={`px-3 py-1 text-sm rounded ${
              filtroStatus === "aprovado"
                ? "bg-[#F25C26] text-white"
                : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
            }`}
          >
            Aprovados
          </button>
          <button
            onClick={() => setFiltroStatus("em_transito")}
            className={`px-3 py-1 text-sm rounded ${
              filtroStatus === "em_transito"
                ? "bg-[#F25C26] text-white"
                : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
            }`}
          >
            Em Trânsito
          </button>
          <button
            onClick={() => setFiltroStatus("entregue")}
            className={`px-3 py-1 text-sm rounded ${
              filtroStatus === "entregue"
                ? "bg-[#F25C26] text-white"
                : "bg-[#F3F3F3] text-[#4C4C4C] hover:bg-[#E5E5E5]"
            }`}
          >
            Entregues
          </button>
        </div>
      </div>

      {/* TABELA */}
      <div className="bg-white rounded-xl shadow-md border border-[#E5E5E5] overflow-hidden">
        <table className="w-full text-xs md:text-sm">
          <thead className="bg-[#F3F3F3] text-[#2E2E2E]">
            <tr>
              <th className="p-3 text-left">Número</th>
              <th className="p-3 text-left">Fornecedor</th>
              <th className="p-3 text-left">Data Pedido</th>
              <th className="p-3 text-left">Previsão Entrega</th>
              <th className="p-3 text-left">Status</th>
              <th className="p-3 text-left">Urgência</th>
              <th className="p-3 text-left">Itens</th>
              <th className="p-3 text-left">Valor Total</th>
              <th className="p-3 text-left">Ações</th>
            </tr>
          </thead>
          <tbody>
            {pedidosFiltrados.map((pedido) => {
              const urgencia = getUrgenciaPedido(pedido);
              return (
                <tr key={pedido.id} className="border-b hover:bg-[#fafafa]">
                  <td className="p-3">
                    <div className="flex items-center gap-2">
                      <span>{getStatusPedidoIcon(pedido.status)}</span>
                      <span className="font-mono">{pedido.numero}</span>
                    </div>
                  </td>
                  <td className="p-3">{pedido.fornecedor?.nome || "-"}</td>
                  <td className="p-3">{formatarData(pedido.data_pedido)}</td>
                  <td className="p-3">{formatarData(pedido.data_previsao_entrega)}</td>
                  <td className="p-3">
                    <span
                      className="px-2 py-1 rounded text-xs text-white"
                      style={{ backgroundColor: STATUS_PEDIDO_COLORS[pedido.status] }}
                    >
                      {STATUS_PEDIDO_LABELS[pedido.status]}
                    </span>
                  </td>
                  <td className="p-3">
                    <span
                      className="text-xs font-medium"
                      style={{ color: urgencia.color }}
                    >
                      {urgencia.label}
                    </span>
                  </td>
                  <td className="p-3">{pedido.total_itens}</td>
                  <td className="p-3 font-semibold">{formatarValor(pedido.valor_total)}</td>
                  <td className="p-3 space-x-2">
                    <Link
                      to={`/compras/${pedido.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Ver
                    </Link>
                    <Link
                      to={`/compras/${pedido.id}`}
                      className="text-green-600 hover:underline"
                    >
                      Editar
                    </Link>
                    {pedido.status === "pendente" && (
                      <button
                        onClick={() => mudarStatus(pedido.id, "aprovado")}
                        className="text-green-700 hover:underline"
                      >
                        Aprovar
                      </button>
                    )}
                    {pedido.status === "aprovado" && (
                      <button
                        onClick={() => mudarStatus(pedido.id, "em_transito")}
                        className="text-purple-600 hover:underline"
                      >
                        Em Trânsito
                      </button>
                    )}
                    {(pedido.status === "em_transito" || pedido.status === "aprovado") && (
                      <button
                        onClick={() => mudarStatus(pedido.id, "entregue")}
                        className="text-green-700 hover:underline"
                      >
                        Entregue
                      </button>
                    )}
                    <button
                      onClick={() => remover(pedido.id)}
                      className="text-red-600 hover:underline"
                    >
                      Excluir
                    </button>
                  </td>
                </tr>
              );
            })}

            {pedidosFiltrados.length === 0 && (
              <tr>
                <td colSpan={9} className="p-4 text-center text-[#4C4C4C]">
                  Nenhum pedido encontrado.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
