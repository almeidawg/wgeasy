// src/pages/FinanceiroPage.tsx
import { useEffect, useState } from "react";
import {
  listarFinanceiro,
  deletarLancamento,
  LancamentoFinanceiro,
} from "@/lib/financeiroApi";
import { atualizarStatusAprovacao } from "@/lib/financeiroWorkflow";
import { exportarFinanceiroPDF, exportarFinanceiroExcel } from "@/lib/financeiroExport";
import { downloadFinanceiroTemplate } from "@/lib/templates/financeiroTemplate";
import { Link } from "react-router-dom";
import { useAuth } from "@/auth/AuthContext";

export default function FinanceiroPage() {
  const [dados, setDados] = useState<LancamentoFinanceiro[]>([]);
  const [loading, setLoading] = useState(true);
  const { user } = useAuth();

  async function carregar() {
    setLoading(true);
    try {
      const lista = await listarFinanceiro();
      setDados(lista);
    } catch (err) {
      console.error("Erro ao carregar financeiro:", err);
    }
    setLoading(false);
  }

  useEffect(() => {
    carregar();
  }, []);

  async function remover(id: string) {
    if (!confirm("Excluir esse lançamento?")) return;
    try {
      await deletarLancamento(id);
      carregar();
    } catch (error) {
      console.error("Erro ao excluir lançamento:", error);
      alert("Erro ao excluir lançamento. Tente novamente.");
    }
  }

  async function aprovar(id: string) {
    if (!user?.id) return alert("Usuário não identificado.");
    try {
      await atualizarStatusAprovacao(id, "aprovado", user.id);
      carregar();
    } catch (error) {
      console.error("Erro ao aprovar lançamento:", error);
      alert("Erro ao aprovar lançamento. Tente novamente.");
    }
  }

  async function rejeitar(id: string) {
    if (!user?.id) return alert("Usuário não identificado.");
    try {
      await atualizarStatusAprovacao(id, "rejeitado", user.id);
      carregar();
    } catch (error) {
      console.error("Erro ao rejeitar lançamento:", error);
      alert("Erro ao rejeitar lançamento. Tente novamente.");
    }
  }

  function handleExportPDF() {
    exportarFinanceiroPDF(dados);
  }

  function handleExportExcel() {
    exportarFinanceiroExcel(dados);
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center h-[50vh] text-[#4C4C4C]">
        Carregando financeiro...
      </div>
    );
  }

  return (
    <div className="space-y-6">

      {/* HEADER */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-[#2E2E2E]">Financeiro</h1>
          <p className="text-sm text-[#4C4C4C]">
            Controle de lançamentos, aprovações e exportação de relatórios.
          </p>
        </div>

        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => downloadFinanceiroTemplate()}
            className="px-3 py-2 text-sm bg-green-50 border border-green-300 text-green-700 rounded hover:bg-green-100 flex items-center gap-2"
          >
            <svg
              className="w-4 h-4"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
              />
            </svg>
            Baixar Modelo
          </button>
          <button
            onClick={handleExportPDF}
            className="px-3 py-2 text-sm bg-white border border-[#E5E5E5] rounded hover:bg-[#F3F3F3]"
          >
            Exportar PDF
          </button>
          <button
            onClick={handleExportExcel}
            className="px-3 py-2 text-sm bg-white border border-[#E5E5E5] rounded hover:bg-[#F3F3F3]"
          >
            Exportar Excel
          </button>
          <Link
            to="/financeiro/novo"
            className="px-4 py-2 text-sm bg-[#F25C26] text-white rounded hover:bg-[#d54b1c]"
          >
            Novo Lançamento
          </Link>
        </div>
      </div>

      {/* TABELA */}
      <div className="bg-white rounded-xl shadow-md border border-[#E5E5E5] overflow-hidden">
        <table className="w-full text-xs md:text-sm">
          <thead className="bg-[#F3F3F3] text-[#2E2E2E]">
            <tr>
              <th className="p-3 text-left">Descrição</th>
              <th className="p-3 text-left">Valor</th>
              <th className="p-3 text-left">Tipo</th>
              <th className="p-3 text-left">Status</th>
              <th className="p-3 text-left">Vencimento</th>
              <th className="p-3 text-left">Núcleo</th>
              <th className="p-3 text-left">Aprovação</th>
              <th className="p-3 text-left">Ações</th>
            </tr>
          </thead>
          <tbody>
            {dados.map((item) => (
              <tr key={item.id} className="border-b hover:bg-[#fafafa]">
                <td className="p-3">{item.descricao}</td>
                <td className="p-3">R$ {Number(item.valor_total || 0).toFixed(2)}</td>
                <td className="p-3 capitalize">{item.tipo}</td>
                <td className="p-3 capitalize">{item.status ?? "-"}</td>
                <td className="p-3">{item.vencimento ?? "-"}</td>
                <td className="p-3">{item.nucleo ?? "-"}</td>
                <td className="p-3 capitalize">
                  {item.approval_status ?? "pendente"}
                </td>
                <td className="p-3 space-x-2">
                  <Link
                    to={`/financeiro/editar/${item.id}`}
                    className="text-blue-600 hover:underline"
                  >
                    Editar
                  </Link>
                  <button
                    onClick={() => remover(item.id!)}
                    className="text-red-600 hover:underline"
                  >
                    Excluir
                  </button>
                  {item.approval_status !== "aprovado" && (
                    <button
                      onClick={() => aprovar(item.id!)}
                      className="text-green-700 hover:underline"
                    >
                      Aprovar
                    </button>
                  )}
                  {item.approval_status !== "rejeitado" && (
                    <button
                      onClick={() => rejeitar(item.id!)}
                      className="text-yellow-700 hover:underline"
                    >
                      Rejeitar
                    </button>
                  )}
                </td>
              </tr>
            ))}

            {dados.length === 0 && (
              <tr>
                <td colSpan={8} className="p-4 text-center text-[#4C4C4C]">
                  Nenhum registro encontrado.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

    </div>
  );
}
