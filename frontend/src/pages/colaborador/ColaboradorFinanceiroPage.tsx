/**
 * Página Financeira do Colaborador
 * Valores a receber, histórico de pagamentos
 */

import { useEffect, useState } from "react";
import { useAuth } from "@/auth/AuthContext";
import {
  Wallet,
  TrendingUp,
  Clock,
  CheckCircle2,
  DollarSign,
  Calendar,
  Building2,
  Filter,
  Download,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  listarValoresReceber,
  obterResumoFinanceiroColaborador,
  ColaboradorValorReceber,
  ResumoFinanceiroColaborador,
} from "@/lib/colaboradorApi";

export default function ColaboradorFinanceiroPage() {
  const { usuarioCompleto } = useAuth();
  const [loading, setLoading] = useState(true);
  const [valores, setValores] = useState<ColaboradorValorReceber[]>([]);
  const [resumo, setResumo] = useState<ResumoFinanceiroColaborador | null>(null);
  const [statusFiltro, setStatusFiltro] = useState<string>("todos");
  const [tipoFiltro, setTipoFiltro] = useState<string>("todos");

  useEffect(() => {
    const carregarDados = async () => {
      if (!usuarioCompleto?.pessoa_id) return;

      try {
        setLoading(true);
        const [valoresData, resumoData] = await Promise.all([
          listarValoresReceber(usuarioCompleto.pessoa_id),
          obterResumoFinanceiroColaborador(usuarioCompleto.pessoa_id),
        ]);
        setValores(valoresData);
        setResumo(resumoData);
      } catch (error) {
        console.error("Erro ao carregar dados:", error);
      } finally {
        setLoading(false);
      }
    };

    carregarDados();
  }, [usuarioCompleto?.pessoa_id]);

  const formatarMoeda = (valor: number) => {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }).format(valor);
  };

  const formatarData = (data?: string) => {
    if (!data) return "-";
    return new Date(data).toLocaleDateString("pt-BR");
  };

  const getStatusBadge = (status: string) => {
    const statusConfig: Record<string, { label: string; color: string }> = {
      previsto: { label: "Previsto", color: "bg-yellow-100 text-yellow-800" },
      aprovado: { label: "Aprovado", color: "bg-blue-100 text-blue-800" },
      liberado: { label: "Liberado", color: "bg-emerald-100 text-emerald-800" },
      pago: { label: "Pago", color: "bg-green-100 text-green-800" },
      cancelado: { label: "Cancelado", color: "bg-red-100 text-red-800" },
    };

    const config = statusConfig[status] || { label: status, color: "bg-gray-100 text-gray-600" };
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${config.color}`}>
        {config.label}
      </span>
    );
  };

  const getTipoBadge = (tipo: string) => {
    const tipoConfig: Record<string, { label: string; color: string }> = {
      comissao: { label: "Comissão", color: "bg-purple-100 text-purple-800" },
      honorario: { label: "Honorário", color: "bg-indigo-100 text-indigo-800" },
      fee_projeto: { label: "Fee Projeto", color: "bg-cyan-100 text-cyan-800" },
      bonus: { label: "Bônus", color: "bg-pink-100 text-pink-800" },
      repasse: { label: "Repasse", color: "bg-orange-100 text-orange-800" },
      outros: { label: "Outros", color: "bg-gray-100 text-gray-600" },
    };

    const config = tipoConfig[tipo] || { label: tipo, color: "bg-gray-100 text-gray-600" };
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${config.color}`}>
        {config.label}
      </span>
    );
  };

  const valoresFiltrados = valores.filter((v) => {
    const matchStatus = statusFiltro === "todos" || v.status === statusFiltro;
    const matchTipo = tipoFiltro === "todos" || v.tipo === tipoFiltro;
    return matchStatus && matchTipo;
  });

  const totalFiltrado = valoresFiltrados.reduce((acc, v) => acc + v.valor, 0);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#F25C26]" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Meu Financeiro</h1>
          <p className="text-gray-500 mt-1">
            Acompanhe seus valores a receber
          </p>
        </div>
        <Button variant="outline">
          <Download className="h-4 w-4 mr-2" />
          Exportar
        </Button>
      </div>

      {/* Cards de Resumo */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">Previsto</p>
                <p className="text-xl font-bold text-yellow-600 mt-1">
                  {formatarMoeda(resumo?.valor_previsto || 0)}
                </p>
              </div>
              <div className="h-10 w-10 bg-yellow-100 rounded-lg flex items-center justify-center">
                <Clock className="h-5 w-5 text-yellow-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">Aprovado</p>
                <p className="text-xl font-bold text-blue-600 mt-1">
                  {formatarMoeda(resumo?.valor_aprovado || 0)}
                </p>
              </div>
              <div className="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <CheckCircle2 className="h-5 w-5 text-blue-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">Liberado</p>
                <p className="text-xl font-bold text-emerald-600 mt-1">
                  {formatarMoeda(resumo?.valor_liberado || 0)}
                </p>
              </div>
              <div className="h-10 w-10 bg-emerald-100 rounded-lg flex items-center justify-center">
                <DollarSign className="h-5 w-5 text-emerald-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">Pago</p>
                <p className="text-xl font-bold text-green-600 mt-1">
                  {formatarMoeda(resumo?.valor_pago || 0)}
                </p>
              </div>
              <div className="h-10 w-10 bg-green-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="h-5 w-5 text-green-600" />
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Barra de Progresso Global */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-gray-900">Progresso de Recebimentos</h3>
            <span className="text-sm text-gray-500">
              {resumo &&
                Math.round(
                  (resumo.valor_pago /
                    (resumo.valor_previsto +
                      resumo.valor_aprovado +
                      resumo.valor_liberado +
                      resumo.valor_pago || 1)) *
                    100
                )}
              % concluído
            </span>
          </div>
          <Progress
            value={
              resumo
                ? (resumo.valor_pago /
                    (resumo.valor_previsto +
                      resumo.valor_aprovado +
                      resumo.valor_liberado +
                      resumo.valor_pago || 1)) *
                  100
                : 0
            }
            className="h-3"
          />
          <div className="flex justify-between mt-2 text-xs text-gray-500">
            <span>Total: {formatarMoeda(
              (resumo?.valor_previsto || 0) +
              (resumo?.valor_aprovado || 0) +
              (resumo?.valor_liberado || 0) +
              (resumo?.valor_pago || 0)
            )}</span>
            <span>Recebido: {formatarMoeda(resumo?.valor_pago || 0)}</span>
          </div>
        </CardContent>
      </Card>

      {/* Lista de Valores */}
      <Card>
        <CardHeader>
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <CardTitle>Valores a Receber</CardTitle>
            <div className="flex gap-2">
              <Select value={statusFiltro} onValueChange={setStatusFiltro}>
                <SelectTrigger className="w-[140px]">
                  <SelectValue placeholder="Status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="todos">Todos</SelectItem>
                  <SelectItem value="previsto">Previstos</SelectItem>
                  <SelectItem value="aprovado">Aprovados</SelectItem>
                  <SelectItem value="liberado">Liberados</SelectItem>
                  <SelectItem value="pago">Pagos</SelectItem>
                </SelectContent>
              </Select>
              <Select value={tipoFiltro} onValueChange={setTipoFiltro}>
                <SelectTrigger className="w-[140px]">
                  <SelectValue placeholder="Tipo" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="todos">Todos</SelectItem>
                  <SelectItem value="comissao">Comissão</SelectItem>
                  <SelectItem value="honorario">Honorário</SelectItem>
                  <SelectItem value="fee_projeto">Fee Projeto</SelectItem>
                  <SelectItem value="bonus">Bônus</SelectItem>
                  <SelectItem value="repasse">Repasse</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          {valoresFiltrados.length === 0 ? (
            <div className="text-center py-12 text-gray-500">
              <Wallet className="h-12 w-12 mx-auto mb-3 opacity-50" />
              <p className="font-medium">Nenhum valor encontrado</p>
              <p className="text-sm mt-1">
                {statusFiltro !== "todos" || tipoFiltro !== "todos"
                  ? "Tente ajustar os filtros"
                  : "Você ainda não possui valores a receber registrados"}
              </p>
            </div>
          ) : (
            <>
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Projeto</TableHead>
                      <TableHead>Tipo</TableHead>
                      <TableHead>Descrição</TableHead>
                      <TableHead>Data Prevista</TableHead>
                      <TableHead>Status</TableHead>
                      <TableHead className="text-right">Valor</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {valoresFiltrados.map((valor) => (
                      <TableRow key={valor.id}>
                        <TableCell>
                          <div className="flex items-center gap-2">
                            <Building2 className="h-4 w-4 text-gray-400" />
                            <span className="font-medium">
                              {valor.projeto?.cliente_nome || "Geral"}
                            </span>
                          </div>
                        </TableCell>
                        <TableCell>{getTipoBadge(valor.tipo)}</TableCell>
                        <TableCell className="max-w-[200px] truncate">
                          {valor.descricao || "-"}
                        </TableCell>
                        <TableCell>
                          <div className="flex items-center gap-1 text-sm text-gray-600">
                            <Calendar className="h-3 w-3" />
                            {formatarData(valor.data_prevista)}
                          </div>
                        </TableCell>
                        <TableCell>{getStatusBadge(valor.status)}</TableCell>
                        <TableCell className="text-right font-semibold text-[#F25C26]">
                          {formatarMoeda(valor.valor)}
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              {/* Total Filtrado */}
              <div className="flex items-center justify-between mt-4 pt-4 border-t">
                <span className="text-sm text-gray-500">
                  {valoresFiltrados.length} registro{valoresFiltrados.length !== 1 ? "s" : ""}
                </span>
                <div className="text-right">
                  <span className="text-sm text-gray-500">Total:</span>
                  <span className="ml-2 text-lg font-bold text-[#F25C26]">
                    {formatarMoeda(totalFiltrado)}
                  </span>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
