/**
 * Dashboard do Colaborador
 * Visão geral de projetos, financeiro e pendências
 */

import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/auth/AuthContext";
import {
  FolderKanban,
  Wallet,
  Clock,
  AlertTriangle,
  TrendingUp,
  FileText,
  CheckCircle2,
  ArrowRight,
  CalendarDays,
  DollarSign,
  Building2,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import {
  listarProjetosColaborador,
  obterResumoFinanceiroColaborador,
  listarSolicitacoesPagamento,
  ColaboradorProjeto,
  ResumoFinanceiroColaborador,
  SolicitacaoPagamento,
} from "@/lib/colaboradorApi";

export default function ColaboradorDashboardPage() {
  const { usuarioCompleto } = useAuth();
  const [loading, setLoading] = useState(true);
  const [projetos, setProjetos] = useState<ColaboradorProjeto[]>([]);
  const [resumoFinanceiro, setResumoFinanceiro] =
    useState<ResumoFinanceiroColaborador | null>(null);
  const [solicitacoesPendentes, setSolicitacoesPendentes] = useState<
    SolicitacaoPagamento[]
  >([]);

  useEffect(() => {
    const carregarDados = async () => {
      if (!usuarioCompleto?.pessoa_id) return;

      try {
        setLoading(true);

        const [projetosData, resumoData, solicitacoesData] = await Promise.all([
          listarProjetosColaborador(usuarioCompleto.pessoa_id),
          obterResumoFinanceiroColaborador(usuarioCompleto.pessoa_id),
          listarSolicitacoesPagamento({
            solicitante_id: usuarioCompleto.pessoa_id,
          }),
        ]);

        setProjetos(projetosData);
        setResumoFinanceiro(resumoData);
        setSolicitacoesPendentes(
          solicitacoesData.filter((s) =>
            ["solicitado", "em_analise"].includes(s.status)
          )
        );
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

  const getStatusBadge = (status: string) => {
    const statusConfig: Record<string, { label: string; variant: "default" | "secondary" | "destructive" | "outline" }> = {
      ativo: { label: "Ativo", variant: "default" },
      em_execucao: { label: "Em Execução", variant: "default" },
      concluido: { label: "Concluído", variant: "secondary" },
      aguardando_assinatura: { label: "Aguardando", variant: "outline" },
    };

    const config = statusConfig[status] || { label: status, variant: "outline" as const };
    return <Badge variant={config.variant}>{config.label}</Badge>;
  };

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
      <div>
        <h1 className="text-2xl font-bold text-gray-900">
          Olá, {usuarioCompleto?.nome?.split(" ")[0] || "Colaborador"}!
        </h1>
        <p className="text-gray-500 mt-1">
          Aqui está o resumo da sua atuação no Grupo WG
        </p>
      </div>

      {/* Cards de Resumo */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Projetos Ativos */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">
                  Projetos Ativos
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-1">
                  {projetos.filter((p) => p.projeto?.status === "ativo").length}
                </p>
              </div>
              <div className="h-12 w-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <FolderKanban className="h-6 w-6 text-blue-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Valores a Receber */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">A Receber</p>
                <p className="text-2xl font-bold text-gray-900 mt-1">
                  {formatarMoeda(
                    (resumoFinanceiro?.valor_previsto || 0) +
                      (resumoFinanceiro?.valor_aprovado || 0)
                  )}
                </p>
              </div>
              <div className="h-12 w-12 bg-green-100 rounded-lg flex items-center justify-center">
                <Wallet className="h-6 w-6 text-green-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Solicitações Pendentes */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">
                  Solicitações Pendentes
                </p>
                <p className="text-2xl font-bold text-gray-900 mt-1">
                  {solicitacoesPendentes.length}
                </p>
              </div>
              <div className="h-12 w-12 bg-amber-100 rounded-lg flex items-center justify-center">
                <Clock className="h-6 w-6 text-amber-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Já Recebido */}
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-500">Já Recebido</p>
                <p className="text-2xl font-bold text-gray-900 mt-1">
                  {formatarMoeda(resumoFinanceiro?.valor_pago || 0)}
                </p>
              </div>
              <div className="h-12 w-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="h-6 w-6 text-purple-600" />
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Conteúdo Principal */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Projetos */}
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-lg font-semibold">
                Meus Projetos
              </CardTitle>
              <Button variant="ghost" size="sm" asChild>
                <Link to="/colaborador/projetos">
                  Ver todos
                  <ArrowRight className="h-4 w-4 ml-1" />
                </Link>
              </Button>
            </CardHeader>
            <CardContent>
              {projetos.length === 0 ? (
                <div className="text-center py-8 text-gray-500">
                  <FolderKanban className="h-12 w-12 mx-auto mb-3 opacity-50" />
                  <p>Nenhum projeto vinculado</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {projetos.slice(0, 5).map((projeto) => (
                    <div
                      key={projeto.id}
                      className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                    >
                      <div className="flex items-center gap-3">
                        <div className="h-10 w-10 bg-[#F25C26]/10 rounded-lg flex items-center justify-center">
                          <Building2 className="h-5 w-5 text-[#F25C26]" />
                        </div>
                        <div>
                          <p className="font-medium text-gray-900">
                            {projeto.projeto?.cliente_nome || "Projeto"}
                          </p>
                          <p className="text-sm text-gray-500">
                            {projeto.funcao || "Equipe"}
                          </p>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        {projeto.projeto?.status &&
                          getStatusBadge(projeto.projeto.status)}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>

          {/* Resumo Financeiro Detalhado */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg font-semibold">
                Resumo Financeiro
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {/* Barra de progresso */}
                <div>
                  <div className="flex justify-between text-sm mb-2">
                    <span className="text-gray-500">Progresso de Recebimentos</span>
                    <span className="font-medium">
                      {resumoFinanceiro &&
                        Math.round(
                          (resumoFinanceiro.valor_pago /
                            (resumoFinanceiro.valor_previsto +
                              resumoFinanceiro.valor_aprovado +
                              resumoFinanceiro.valor_pago || 1)) *
                            100
                        )}
                      %
                    </span>
                  </div>
                  <Progress
                    value={
                      resumoFinanceiro
                        ? (resumoFinanceiro.valor_pago /
                            (resumoFinanceiro.valor_previsto +
                              resumoFinanceiro.valor_aprovado +
                              resumoFinanceiro.valor_pago || 1)) *
                          100
                        : 0
                    }
                    className="h-2"
                  />
                </div>

                {/* Detalhamento */}
                <div className="grid grid-cols-2 gap-4 pt-2">
                  <div className="p-3 bg-yellow-50 rounded-lg">
                    <div className="flex items-center gap-2 text-yellow-700 mb-1">
                      <Clock className="h-4 w-4" />
                      <span className="text-sm font-medium">Previsto</span>
                    </div>
                    <p className="text-lg font-bold text-yellow-900">
                      {formatarMoeda(resumoFinanceiro?.valor_previsto || 0)}
                    </p>
                  </div>

                  <div className="p-3 bg-blue-50 rounded-lg">
                    <div className="flex items-center gap-2 text-blue-700 mb-1">
                      <CheckCircle2 className="h-4 w-4" />
                      <span className="text-sm font-medium">Aprovado</span>
                    </div>
                    <p className="text-lg font-bold text-blue-900">
                      {formatarMoeda(resumoFinanceiro?.valor_aprovado || 0)}
                    </p>
                  </div>

                  <div className="p-3 bg-emerald-50 rounded-lg">
                    <div className="flex items-center gap-2 text-emerald-700 mb-1">
                      <DollarSign className="h-4 w-4" />
                      <span className="text-sm font-medium">Liberado</span>
                    </div>
                    <p className="text-lg font-bold text-emerald-900">
                      {formatarMoeda(resumoFinanceiro?.valor_liberado || 0)}
                    </p>
                  </div>

                  <div className="p-3 bg-green-50 rounded-lg">
                    <div className="flex items-center gap-2 text-green-700 mb-1">
                      <TrendingUp className="h-4 w-4" />
                      <span className="text-sm font-medium">Pago</span>
                    </div>
                    <p className="text-lg font-bold text-green-900">
                      {formatarMoeda(resumoFinanceiro?.valor_pago || 0)}
                    </p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Sidebar - Solicitações e Alertas */}
        <div className="space-y-4">
          {/* Solicitações Pendentes */}
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-lg font-semibold">
                Solicitações
              </CardTitle>
              <Button variant="ghost" size="sm" asChild>
                <Link to="/colaborador/solicitacoes">
                  <ArrowRight className="h-4 w-4" />
                </Link>
              </Button>
            </CardHeader>
            <CardContent>
              {solicitacoesPendentes.length === 0 ? (
                <div className="text-center py-6 text-gray-500">
                  <FileText className="h-10 w-10 mx-auto mb-2 opacity-50" />
                  <p className="text-sm">Nenhuma solicitação pendente</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {solicitacoesPendentes.slice(0, 4).map((solicitacao) => (
                    <div
                      key={solicitacao.id}
                      className="p-3 border rounded-lg hover:bg-gray-50 transition-colors"
                    >
                      <div className="flex items-start justify-between gap-2">
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium text-gray-900 truncate">
                            {solicitacao.numero_solicitacao}
                          </p>
                          <p className="text-xs text-gray-500 truncate">
                            {solicitacao.descricao}
                          </p>
                        </div>
                        <Badge
                          variant={
                            solicitacao.status === "em_analise"
                              ? "default"
                              : "secondary"
                          }
                          className="text-xs"
                        >
                          {solicitacao.status === "em_analise"
                            ? "Análise"
                            : "Enviado"}
                        </Badge>
                      </div>
                      <p className="text-sm font-semibold text-[#F25C26] mt-2">
                        {formatarMoeda(solicitacao.valor)}
                      </p>
                    </div>
                  ))}
                </div>
              )}

              <Button className="w-full mt-4" variant="outline" asChild>
                <Link to="/colaborador/solicitacoes/nova">
                  Nova Solicitação
                </Link>
              </Button>
            </CardContent>
          </Card>

          {/* Alertas */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg font-semibold flex items-center gap-2">
                <AlertTriangle className="h-5 w-5 text-amber-500" />
                Alertas
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {projetos.some(
                  (p) => p.projeto?.status === "aguardando_assinatura"
                ) && (
                  <div className="p-3 bg-amber-50 border border-amber-200 rounded-lg">
                    <p className="text-sm font-medium text-amber-800">
                      Contratos aguardando assinatura
                    </p>
                    <p className="text-xs text-amber-600 mt-1">
                      Verifique os projetos pendentes
                    </p>
                  </div>
                )}

                {solicitacoesPendentes.length > 3 && (
                  <div className="p-3 bg-blue-50 border border-blue-200 rounded-lg">
                    <p className="text-sm font-medium text-blue-800">
                      {solicitacoesPendentes.length} solicitações em análise
                    </p>
                    <p className="text-xs text-blue-600 mt-1">
                      Acompanhe o andamento
                    </p>
                  </div>
                )}

                {resumoFinanceiro &&
                  resumoFinanceiro.valor_liberado > 0 && (
                    <div className="p-3 bg-green-50 border border-green-200 rounded-lg">
                      <p className="text-sm font-medium text-green-800">
                        Valores liberados para pagamento
                      </p>
                      <p className="text-xs text-green-600 mt-1">
                        {formatarMoeda(resumoFinanceiro.valor_liberado)}{" "}
                        disponível
                      </p>
                    </div>
                  )}

                {projetos.length === 0 &&
                  solicitacoesPendentes.length === 0 && (
                    <div className="text-center py-4 text-gray-500">
                      <CheckCircle2 className="h-8 w-8 mx-auto mb-2 text-green-500" />
                      <p className="text-sm">Tudo em dia!</p>
                    </div>
                  )}
              </div>
            </CardContent>
          </Card>

          {/* Próximos Eventos */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg font-semibold flex items-center gap-2">
                <CalendarDays className="h-5 w-5 text-[#F25C26]" />
                Agenda
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-center py-6 text-gray-500">
                <CalendarDays className="h-10 w-10 mx-auto mb-2 opacity-50" />
                <p className="text-sm">Nenhum evento próximo</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
