// ============================================================
// PAGINA: Lista de Compras (Workflow de Compras)
// Sistema WG Easy - Grupo WG Almeida
// ============================================================

import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  listarItensCompras,
  listarProjetosCompras,
  listarCategoriasCompras,
  atualizarStatusCompra,
  deletarItemCompra,
  obterEstatisticasCompras,
  formatarMoeda,
  STATUS_COMPRA_LABELS,
  STATUS_COMPRA_COLORS,
  TIPO_COMPRA_LABELS,
  TIPO_CONTA_LABELS,
  type ListaCompraItem,
  type ProjetoCompras,
  type CategoriaCompras,
  type StatusCompra,
  type EstatisticasCompras,
} from "@/lib/listaComprasApi";

export default function ListaComprasPage() {
  const navigate = useNavigate();
  const [itens, setItens] = useState<ListaCompraItem[]>([]);
  const [projetos, setProjetos] = useState<ProjetoCompras[]>([]);
  const [categorias, setCategorias] = useState<CategoriaCompras[]>([]);
  const [estatisticas, setEstatisticas] = useState<EstatisticasCompras | null>(null);
  const [loading, setLoading] = useState(true);

  // Filtros
  const [filtroStatus, setFiltroStatus] = useState<string>("todos");
  const [filtroProjeto, setFiltroProjeto] = useState<string>("");
  const [filtroTipoConta, setFiltroTipoConta] = useState<string>("todos");
  const [filtroTipoCompra, setFiltroTipoCompra] = useState<string>("todos");
  const [busca, setBusca] = useState("");

  useEffect(() => {
    carregarDados();
  }, []);

  async function carregarDados() {
    try {
      setLoading(true);
      const [itensData, projetosData, categoriasData, statsData] = await Promise.all([
        listarItensCompras(),
        listarProjetosCompras(),
        listarCategoriasCompras(),
        obterEstatisticasCompras(),
      ]);
      setItens(itensData);
      setProjetos(projetosData);
      setCategorias(categoriasData);
      setEstatisticas(statsData);
    } catch (error) {
      console.error("Erro ao carregar dados:", error);
    } finally {
      setLoading(false);
    }
  }

  async function handleAtualizarStatus(id: string, novoStatus: StatusCompra) {
    try {
      const itemAtualizado = await atualizarStatusCompra(id, novoStatus);
      setItens((prev) =>
        prev.map((item) => (item.id === id ? itemAtualizado : item))
      );
      // Recarregar estatisticas
      const stats = await obterEstatisticasCompras();
      setEstatisticas(stats);
    } catch (error) {
      console.error("Erro ao atualizar status:", error);
      alert("Erro ao atualizar status do item");
    }
  }

  async function handleDeletar(id: string) {
    if (!confirm("Deseja realmente excluir este item?")) return;
    try {
      await deletarItemCompra(id);
      setItens((prev) => prev.filter((item) => item.id !== id));
      const stats = await obterEstatisticasCompras();
      setEstatisticas(stats);
    } catch (error) {
      console.error("Erro ao deletar item:", error);
      alert("Erro ao excluir item");
    }
  }

  // Filtrar itens
  const itensFiltrados = itens.filter((item) => {
    if (filtroStatus !== "todos" && item.status !== filtroStatus) return false;
    if (filtroProjeto && item.projeto_id !== filtroProjeto) return false;
    if (filtroTipoConta !== "todos" && item.tipo_conta !== filtroTipoConta) return false;
    if (filtroTipoCompra !== "todos" && item.tipo_compra !== filtroTipoCompra) return false;
    if (busca) {
      const buscaLower = busca.toLowerCase();
      return (
        item.descricao.toLowerCase().includes(buscaLower) ||
        item.codigo.toLowerCase().includes(buscaLower) ||
        item.fornecedor?.toLowerCase().includes(buscaLower) ||
        item.ambiente?.toLowerCase().includes(buscaLower)
      );
    }
    return true;
  });

  // Totais filtrados
  const totalFiltrado = itensFiltrados.reduce((acc, i) => acc + (i.valor_total || 0), 0);
  const totalFeeFiltrado = itensFiltrados.reduce((acc, i) => acc + (i.valor_fee || 0), 0);

  return (
    <div className="p-6 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#2E2E2E]">Lista de Compras</h1>
          <p className="text-sm text-gray-600 mt-1">
            Gerenciamento de compras de materiais para projetos
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={() => navigate("/compras/projetos")}
            className="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium"
          >
            Projetos
          </button>
          <button
            type="button"
            onClick={() => navigate("/compras/novo")}
            className="px-4 py-2 bg-[#F25C26] text-white rounded-lg hover:bg-[#e04a1a] font-medium flex items-center gap-2"
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
            </svg>
            Nova Compra
          </button>
        </div>
      </div>

      {/* Estatisticas */}
      {estatisticas && (
        <div className="grid grid-cols-5 gap-4">
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">Total de Itens</p>
            <p className="text-2xl font-bold text-gray-900 mt-1">{estatisticas.total_itens}</p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">Valor Total</p>
            <p className="text-2xl font-bold text-blue-600 mt-1">{formatarMoeda(estatisticas.valor_total)}</p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">Pendentes</p>
            <p className="text-2xl font-bold text-yellow-600 mt-1">{formatarMoeda(estatisticas.valor_pendente)}</p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">Entregues</p>
            <p className="text-2xl font-bold text-green-600 mt-1">{formatarMoeda(estatisticas.valor_entregue)}</p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">FEE Arrecadado</p>
            <p className="text-2xl font-bold text-purple-600 mt-1">{formatarMoeda(estatisticas.total_fee_arrecadado)}</p>
          </div>
        </div>
      )}

      {/* Filtros */}
      <div className="bg-white border border-gray-200 rounded-xl p-4 space-y-4">
        {/* Busca */}
        <div className="relative">
          <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          <input
            type="text"
            value={busca}
            onChange={(e) => setBusca(e.target.value)}
            placeholder="Buscar por descricao, codigo, fornecedor..."
            className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#F25C26] focus:border-transparent"
          />
        </div>

        {/* Filtros em linha */}
        <div className="flex items-center gap-4 flex-wrap">
          {/* Status */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-gray-700">Status:</span>
            <select
              value={filtroStatus}
              onChange={(e) => setFiltroStatus(e.target.value)}
              className="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#F25C26]"
            >
              <option value="todos">Todos</option>
              <option value="PENDENTE">Pendente</option>
              <option value="APROVADO">Aprovado</option>
              <option value="COMPRADO">Comprado</option>
              <option value="ENTREGUE">Entregue</option>
              <option value="CANCELADO">Cancelado</option>
            </select>
          </div>

          {/* Projeto */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-gray-700">Projeto:</span>
            <select
              value={filtroProjeto}
              onChange={(e) => setFiltroProjeto(e.target.value)}
              className="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#F25C26]"
            >
              <option value="">Todos</option>
              {projetos.map((p) => (
                <option key={p.id} value={p.id}>
                  {p.codigo} - {p.nome}
                </option>
              ))}
            </select>
          </div>

          {/* Tipo Conta */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-gray-700">Conta:</span>
            <select
              value={filtroTipoConta}
              onChange={(e) => setFiltroTipoConta(e.target.value)}
              className="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#F25C26]"
            >
              <option value="todos">Todas</option>
              <option value="REAL">Conta Real</option>
              <option value="VIRTUAL">Conta Virtual</option>
            </select>
          </div>

          {/* Tipo Compra */}
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-gray-700">Tipo:</span>
            <select
              value={filtroTipoCompra}
              onChange={(e) => setFiltroTipoCompra(e.target.value)}
              className="px-3 py-1 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#F25C26]"
            >
              <option value="todos">Todos</option>
              <option value="WG_COMPRA">WG Compra</option>
              <option value="CLIENTE_DIRETO">Cliente Direto</option>
            </select>
          </div>
        </div>

        {/* Resumo filtrado */}
        <div className="flex items-center justify-between border-t pt-3">
          <span className="text-sm text-gray-600">
            {itensFiltrados.length} item(s) encontrado(s)
          </span>
          <div className="flex items-center gap-4">
            <span className="text-sm font-medium">
              Total: <span className="text-blue-600">{formatarMoeda(totalFiltrado)}</span>
            </span>
            <span className="text-sm font-medium">
              FEE: <span className="text-purple-600">{formatarMoeda(totalFeeFiltrado)}</span>
            </span>
          </div>
        </div>
      </div>

      {/* Tabela */}
      <div className="bg-white border border-gray-200 rounded-xl shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-[#F25C26]" />
            <p className="text-sm text-gray-600 mt-2">Carregando...</p>
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-[#F5F5F5] border-b border-gray-200">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Codigo</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Projeto</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Ambiente</th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase">Descricao</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase">Qtd</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-700 uppercase">Preco Un.</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-700 uppercase">Total</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase">Tipo</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase">Conta</th>
                <th className="px-4 py-3 text-right text-xs font-semibold text-gray-700 uppercase">FEE</th>
                <th className="px-4 py-3 text-center text-xs font-semibold text-gray-700 uppercase">Status</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {itensFiltrados.map((item) => (
                <tr key={item.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-4 py-3">
                    <span className="font-mono text-xs text-gray-600">{item.codigo}</span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="text-gray-900 font-medium text-xs">
                      {item.projeto?.codigo || "-"}
                    </span>
                    <p className="text-xs text-gray-500 truncate max-w-[120px]">
                      {item.projeto?.nome || "-"}
                    </p>
                  </td>
                  <td className="px-4 py-3">
                    <span className="text-gray-700 text-sm">{item.ambiente || "-"}</span>
                  </td>
                  <td className="px-4 py-3 max-w-[200px]">
                    <span className="text-gray-900 truncate block">{item.descricao}</span>
                    {item.fornecedor && (
                      <p className="text-xs text-gray-500">Forn: {item.fornecedor}</p>
                    )}
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span className="text-gray-700">{item.quantidade_compra || 0}</span>
                    <span className="text-xs text-gray-500 ml-1">{item.unidade}</span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <span className="text-gray-700">{formatarMoeda(item.preco_unitario || 0)}</span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <span className="font-medium text-gray-900">{formatarMoeda(item.valor_total || 0)}</span>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span
                      className={`px-2 py-1 rounded-full text-xs font-medium ${
                        item.tipo_compra === "WG_COMPRA"
                          ? "bg-blue-100 text-blue-700"
                          : "bg-orange-100 text-orange-700"
                      }`}
                    >
                      {TIPO_COMPRA_LABELS[item.tipo_compra]}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-center">
                    <span
                      className={`px-2 py-1 rounded-full text-xs font-medium ${
                        item.tipo_conta === "REAL"
                          ? "bg-green-100 text-green-700"
                          : "bg-purple-100 text-purple-700"
                      }`}
                    >
                      {item.tipo_conta === "REAL" ? "Real" : "Virtual"}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    {item.valor_fee > 0 ? (
                      <div>
                        <span className="text-purple-600 font-medium">{formatarMoeda(item.valor_fee)}</span>
                        <p className="text-xs text-gray-500">{item.taxa_fee_percent}%</p>
                      </div>
                    ) : (
                      <span className="text-gray-400">-</span>
                    )}
                  </td>
                  <td className="px-4 py-3 text-center">
                    <select
                      value={item.status}
                      onChange={(e) => handleAtualizarStatus(item.id, e.target.value as StatusCompra)}
                      style={{
                        backgroundColor: `${STATUS_COMPRA_COLORS[item.status]}20`,
                        color: STATUS_COMPRA_COLORS[item.status],
                      }}
                      className="px-2 py-1 rounded-full text-xs font-medium border-0 cursor-pointer focus:outline-none focus:ring-2 focus:ring-[#F25C26]"
                    >
                      <option value="PENDENTE">Pendente</option>
                      <option value="APROVADO">Aprovado</option>
                      <option value="COMPRADO">Comprado</option>
                      <option value="ENTREGUE">Entregue</option>
                      <option value="CANCELADO">Cancelado</option>
                    </select>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <button
                        onClick={() => navigate(`/compras/editar/${item.id}`)}
                        className="text-blue-600 hover:text-blue-800"
                        title="Editar"
                      >
                        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                        </svg>
                      </button>
                      <button
                        onClick={() => handleDeletar(item.id)}
                        className="text-red-600 hover:text-red-800"
                        title="Excluir"
                      >
                        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                      </button>
                    </div>
                  </td>
                </tr>
              ))}

              {itensFiltrados.length === 0 && (
                <tr>
                  <td colSpan={12} className="px-4 py-8 text-center">
                    <div className="flex flex-col items-center gap-2">
                      <svg className="w-12 h-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                      </svg>
                      <p className="text-gray-600 font-medium">
                        {busca || filtroStatus !== "todos"
                          ? "Nenhum item encontrado com esses filtros"
                          : "Nenhum item na lista de compras"}
                      </p>
                      <p className="text-sm text-gray-500">
                        Adicione itens a partir do quantitativo do projeto
                      </p>
                    </div>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
