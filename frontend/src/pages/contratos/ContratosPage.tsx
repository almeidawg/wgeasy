// ============================================================
// PÁGINA: Listagem de Contratos
// Sistema WG Easy - Grupo WG Almeida
// ============================================================

import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { listarContratos, type Contrato } from "@/lib/contratosApi";
import {
  getStatusContratoColor,
  getStatusContratoLabel,
  getUnidadeNegocioColor,
  getUnidadeNegocioLabel,
} from "@/types/contratos";

export default function ContratosPage() {
  const [contratos, setContratos] = useState<Contrato[]>([]);
  const [loading, setLoading] = useState(true);
  const [filtroStatus, setFiltroStatus] = useState<string>("todos");
  const navigate = useNavigate();

  useEffect(() => {
    carregarContratos();
  }, []);

  async function carregarContratos() {
    try {
      setLoading(true);
      const data = await listarContratos();
      setContratos(data);
    } catch (error) {
      console.error("Erro ao carregar contratos:", error);
    } finally {
      setLoading(false);
    }
  }

  const contratosFiltrados =
    filtroStatus === "todos"
      ? contratos
      : contratos.filter((c) => c.status === filtroStatus);

  return (
    <div className="p-6 space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#2E2E2E]">Contratos</h1>
          <p className="text-sm text-gray-600 mt-1">
            Gerencie todos os contratos do sistema
          </p>
        </div>
        <button
          onClick={() => navigate("/contratos/novo")}
          className="px-4 py-2 bg-[#F25C26] text-white rounded-lg hover:bg-[#e04a1a] font-medium flex items-center gap-2"
        >
          <svg
            className="w-5 h-5"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M12 4v16m8-8H4"
            />
          </svg>
          Novo Contrato
        </button>
      </div>

      {/* Filtros */}
      <div className="flex items-center gap-2">
        <span className="text-sm font-medium text-gray-700">Status:</span>
        <button
          onClick={() => setFiltroStatus("todos")}
          className={`px-3 py-1 rounded-lg text-sm font-medium ${
            filtroStatus === "todos"
              ? "bg-[#F25C26] text-white"
              : "bg-gray-100 text-gray-700 hover:bg-gray-200"
          }`}
        >
          Todos ({contratos.length})
        </button>
        <button
          onClick={() => setFiltroStatus("rascunho")}
          className={`px-3 py-1 rounded-lg text-sm font-medium ${
            filtroStatus === "rascunho"
              ? "bg-[#F25C26] text-white"
              : "bg-gray-100 text-gray-700 hover:bg-gray-200"
          }`}
        >
          Rascunhos ({contratos.filter((c) => c.status === "rascunho").length})
        </button>
        <button
          onClick={() => setFiltroStatus("aguardando_assinatura")}
          className={`px-3 py-1 rounded-lg text-sm font-medium ${
            filtroStatus === "aguardando_assinatura"
              ? "bg-[#F25C26] text-white"
              : "bg-gray-100 text-gray-700 hover:bg-gray-200"
          }`}
        >
          Aguardando ({contratos.filter((c) => c.status === "aguardando_assinatura").length})
        </button>
        <button
          onClick={() => setFiltroStatus("ativo")}
          className={`px-3 py-1 rounded-lg text-sm font-medium ${
            filtroStatus === "ativo"
              ? "bg-[#F25C26] text-white"
              : "bg-gray-100 text-gray-700 hover:bg-gray-200"
          }`}
        >
          Ativos ({contratos.filter((c) => c.status === "ativo").length})
        </button>
      </div>

      {/* Tabela */}
      <div className="bg-white border border-gray-200 rounded-xl shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center">
            <div className="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-[#F25C26]" />
            <p className="text-sm text-gray-600 mt-2">Carregando contratos...</p>
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead className="bg-[#F5F5F5] border-b border-gray-200">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Número
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Cliente
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Unidade
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Valor
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-4 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                  Data
                </th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>

            <tbody className="divide-y divide-gray-200">
              {contratosFiltrados.map((contrato) => (
                <tr
                  key={contrato.id}
                  className="hover:bg-gray-50 cursor-pointer transition-colors"
                  onClick={() => navigate(`/contratos/${contrato.id}`)}
                >
                  <td className="px-4 py-3">
                    <span className="font-semibold text-gray-900">
                      {contrato.numero}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="text-gray-700">{contrato.cliente_nome}</span>
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className="px-2 py-1 rounded text-xs font-semibold text-white"
                      style={{
                        backgroundColor: getUnidadeNegocioColor(
                          contrato.unidade_negocio
                        ),
                      }}
                    >
                      {getUnidadeNegocioLabel(contrato.unidade_negocio)}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="font-semibold text-gray-900">
                      R${" "}
                      {contrato.valor_total.toLocaleString("pt-BR", {
                        minimumFractionDigits: 2,
                      })}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className="px-2 py-1 rounded-full text-xs font-medium"
                      style={{
                        backgroundColor: `${getStatusContratoColor(contrato.status)}20`,
                        color: getStatusContratoColor(contrato.status),
                      }}
                    >
                      {getStatusContratoLabel(contrato.status)}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="text-gray-600">
                      {new Date(contrato.data_criacao).toLocaleDateString("pt-BR")}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        navigate(`/contratos/${contrato.id}`);
                      }}
                      className="text-[#F25C26] hover:text-[#e04a1a] font-medium"
                    >
                      Ver
                    </button>
                  </td>
                </tr>
              ))}

              {contratosFiltrados.length === 0 && (
                <tr>
                  <td colSpan={7} className="px-4 py-8 text-center">
                    <div className="flex flex-col items-center gap-2">
                      <svg
                        className="w-12 h-12 text-gray-400"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={1.5}
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                        />
                      </svg>
                      <p className="text-gray-600 font-medium">
                        Nenhum contrato encontrado
                      </p>
                      <p className="text-sm text-gray-500">
                        Comece criando um novo contrato
                      </p>
                    </div>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </div>

      {/* Estatísticas */}
      {!loading && contratos.length > 0 && (
        <div className="grid grid-cols-4 gap-4">
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">
              Total de Contratos
            </p>
            <p className="text-2xl font-bold text-gray-900 mt-1">
              {contratos.length}
            </p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">
              Valor Total
            </p>
            <p className="text-2xl font-bold text-[#F25C26] mt-1">
              R${" "}
              {contratos
                .reduce((acc, c) => acc + c.valor_total, 0)
                .toLocaleString("pt-BR", {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 0,
                })}
            </p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">
              Contratos Ativos
            </p>
            <p className="text-2xl font-bold text-green-600 mt-1">
              {contratos.filter((c) => c.status === "ativo").length}
            </p>
          </div>
          <div className="bg-white border border-gray-200 rounded-xl p-4">
            <p className="text-xs font-medium text-gray-600 uppercase tracking-wide">
              Em Execução
            </p>
            <p className="text-2xl font-bold text-blue-600 mt-1">
              {contratos.filter((c) => c.status === "em_execucao").length}
            </p>
          </div>
        </div>
      )}
    </div>
  );
}
