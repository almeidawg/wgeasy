// ============================================================
// COMPONENTE: ControleCobrancas
// Sistema WG Easy - Grupo WG Almeida
// ============================================================
// Lista de cobranças com status (Pendente, Vencido, Pago)
// ============================================================

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabaseClient";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  DollarSign,
  Calendar,
  User,
  Loader2,
  FileText,
  AlertCircle
} from "lucide-react";

interface Cobranca {
  id: string;
  clienteNome: string;
  vencimento: string;
  valor: number;
  status: "pendente" | "vencido" | "pago";
}

interface ControleCobrancasProps {
  clienteId: string;
  contratoId?: string;
}

export default function ControleCobrancas({ clienteId, contratoId }: ControleCobrancasProps) {
  const [cobrancas, setCobrancas] = useState<Cobranca[]>([]);
  const [loading, setLoading] = useState(true);
  const [filtroStatus, setFiltroStatus] = useState<string>("todos");

  useEffect(() => {
    carregarCobrancas();
  }, [clienteId, contratoId]);

  async function carregarCobrancas() {
    try {
      setLoading(true);

      // Buscar cobranças do cliente
      const { data, error } = await supabase
        .from("financeiro_lancamentos")
        .select(`
          id,
          valor,
          data_vencimento,
          status,
          pessoas:cliente_id (nome)
        `)
        .eq("cliente_id", clienteId)
        .eq("tipo", "receita")
        .order("data_vencimento", { ascending: true });

      if (error || !data || data.length === 0) {
        setCobrancas([]);
        return;
      }

      const hoje = new Date();
      const cobrancasFormatadas: Cobranca[] = data.map((item: any) => {
        const vencimento = new Date(item.data_vencimento);
        let status: "pendente" | "vencido" | "pago" = item.status;
        if (item.status !== "pago" && vencimento < hoje) {
          status = "vencido";
        }

        return {
          id: item.id,
          clienteNome: item.pessoas?.nome || "Cliente",
          vencimento: item.data_vencimento,
          valor: item.valor,
          status,
        };
      });

      setCobrancas(cobrancasFormatadas);
    } catch (error) {
      console.error("Erro ao carregar cobranças:", error);
      setCobrancas([]);
    } finally {
      setLoading(false);
    }
  }

  const cobrancasFiltradas = cobrancas.filter((c) => {
    if (filtroStatus === "todos") return true;
    return c.status === filtroStatus;
  });

  const statusConfig = {
    pendente: { label: "Pendente", color: "bg-amber-100 text-amber-700", dot: "bg-amber-500" },
    vencido: { label: "Vencido", color: "bg-red-100 text-red-700", dot: "bg-red-500" },
    pago: { label: "Pago", color: "bg-green-100 text-green-700", dot: "bg-green-500" },
  };

  if (loading) {
    return (
      <Card>
        <CardContent className="py-8">
          <div className="flex items-center justify-center">
            <Loader2 className="w-6 h-6 animate-spin text-gray-400" />
            <span className="ml-2 text-gray-500">Carregando cobranças...</span>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="overflow-hidden">
      <CardHeader className="bg-white border-b">
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="flex items-center gap-2 text-lg">
              <DollarSign className="w-5 h-5 text-gray-600" />
              Controle de Cobranças
            </CardTitle>
            <p className="text-sm text-gray-500 mt-1">Gerencie cobranças e recebimentos</p>
          </div>
        </div>
      </CardHeader>

      {/* Filtros */}
      <div className="p-4 border-b bg-gray-50">
        <div className="flex gap-2">
          {["todos", "pendente", "vencido", "pago"].map((status) => (
            <button
              key={status}
              onClick={() => setFiltroStatus(status)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                filtroStatus === status
                  ? status === "todos"
                    ? "bg-[#F25C26] text-white"
                    : status === "pendente"
                    ? "bg-amber-500 text-white"
                    : status === "vencido"
                    ? "bg-red-500 text-white"
                    : "bg-green-500 text-white"
                  : "bg-white text-gray-600 border border-gray-200 hover:bg-gray-100"
              }`}
            >
              {status.charAt(0).toUpperCase() + status.slice(1)}
            </button>
          ))}
        </div>
      </div>

      <CardContent className="p-0">
        {/* Header da tabela */}
        <div className="grid grid-cols-4 gap-4 px-4 py-3 bg-gray-50 border-b text-xs font-semibold text-gray-500 uppercase">
          <div>Status</div>
          <div>Cliente</div>
          <div>Vencimento</div>
          <div className="text-right">Valor</div>
        </div>

        {/* Lista de cobranças */}
        <div className="divide-y divide-gray-100 max-h-[400px] overflow-y-auto">
          {cobrancasFiltradas.length === 0 ? (
            <div className="p-8 text-center text-gray-400">
              <FileText className="w-12 h-12 mx-auto mb-3 opacity-50" />
              <p className="font-medium">Nenhuma cobrança encontrada</p>
            </div>
          ) : (
            cobrancasFiltradas.map((cobranca) => {
              const config = statusConfig[cobranca.status];
              return (
                <div
                  key={cobranca.id}
                  className="grid grid-cols-4 gap-4 px-4 py-3 hover:bg-gray-50 transition-colors items-center"
                >
                  <div>
                    <Badge className={`${config.color} flex items-center gap-1.5 w-fit`}>
                      <span className={`w-2 h-2 rounded-full ${config.dot}`}></span>
                      {config.label}
                    </Badge>
                  </div>
                  <div className="font-medium text-gray-900 truncate">
                    {cobranca.clienteNome}
                  </div>
                  <div className="text-gray-600 flex items-center gap-1.5">
                    <Calendar className="w-4 h-4 text-gray-400" />
                    {new Date(cobranca.vencimento).toLocaleDateString("pt-BR")}
                  </div>
                  <div className="text-right font-semibold text-gray-900">
                    R$ {cobranca.valor.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}
                  </div>
                </div>
              );
            })
          )}
        </div>
      </CardContent>
    </Card>
  );
}
