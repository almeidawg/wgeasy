/**
 * Página de Solicitações de Pagamento do Colaborador
 */

import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/auth/AuthContext";
import {
  FileText,
  Plus,
  Search,
  Filter,
  Clock,
  CheckCircle2,
  XCircle,
  Eye,
  Calendar,
  Building2,
  DollarSign,
} from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  listarSolicitacoesPagamento,
  SolicitacaoPagamento,
} from "@/lib/colaboradorApi";

export default function ColaboradorSolicitacoesPage() {
  const { usuarioCompleto } = useAuth();
  const [loading, setLoading] = useState(true);
  const [solicitacoes, setSolicitacoes] = useState<SolicitacaoPagamento[]>([]);
  const [filtro, setFiltro] = useState("");
  const [statusFiltro, setStatusFiltro] = useState<string>("todos");
  const [solicitacaoDetalhe, setSolicitacaoDetalhe] = useState<SolicitacaoPagamento | null>(null);

  useEffect(() => {
    const carregarSolicitacoes = async () => {
      if (!usuarioCompleto?.pessoa_id) return;

      try {
        setLoading(true);
        const data = await listarSolicitacoesPagamento({
          solicitante_id: usuarioCompleto.pessoa_id,
        });
        setSolicitacoes(data);
      } catch (error) {
        console.error("Erro ao carregar solicitações:", error);
      } finally {
        setLoading(false);
      }
    };

    carregarSolicitacoes();
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

  const getStatusConfig = (status: string) => {
    const config: Record<string, { label: string; color: string; icon: any }> = {
      rascunho: { label: "Rascunho", color: "bg-gray-100 text-gray-600", icon: FileText },
      solicitado: { label: "Solicitado", color: "bg-blue-100 text-blue-800", icon: Clock },
      em_analise: { label: "Em Análise", color: "bg-amber-100 text-amber-800", icon: Eye },
      aprovado: { label: "Aprovado", color: "bg-green-100 text-green-800", icon: CheckCircle2 },
      rejeitado: { label: "Rejeitado", color: "bg-red-100 text-red-800", icon: XCircle },
      pago: { label: "Pago", color: "bg-emerald-100 text-emerald-800", icon: DollarSign },
      cancelado: { label: "Cancelado", color: "bg-gray-100 text-gray-600", icon: XCircle },
    };
    return config[status] || { label: status, color: "bg-gray-100 text-gray-600", icon: FileText };
  };

  const getTipoBadge = (tipo: string) => {
    const tipoConfig: Record<string, string> = {
      prestador: "Prestador",
      fornecedor: "Fornecedor",
      reembolso: "Reembolso",
      comissao: "Comissão",
      honorario: "Honorário",
      outros: "Outros",
    };
    return tipoConfig[tipo] || tipo;
  };

  const solicitacoesFiltradas = solicitacoes.filter((s) => {
    const matchTexto =
      s.numero_solicitacao?.toLowerCase().includes(filtro.toLowerCase()) ||
      s.descricao?.toLowerCase().includes(filtro.toLowerCase()) ||
      s.beneficiario_nome?.toLowerCase().includes(filtro.toLowerCase());

    const matchStatus = statusFiltro === "todos" || s.status === statusFiltro;

    return matchTexto && matchStatus;
  });

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
          <h1 className="text-2xl font-bold text-gray-900">Solicitações de Pagamento</h1>
          <p className="text-gray-500 mt-1">
            Gerencie suas solicitações de pagamento
          </p>
        </div>
        <Button asChild>
          <Link to="/colaborador/solicitacoes/nova">
            <Plus className="h-4 w-4 mr-2" />
            Nova Solicitação
          </Link>
        </Button>
      </div>

      {/* Resumo por Status */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {["solicitado", "em_analise", "aprovado", "pago"].map((status) => {
          const config = getStatusConfig(status);
          const count = solicitacoes.filter((s) => s.status === status).length;
          const Icon = config.icon;
          return (
            <Card key={status} className="cursor-pointer hover:shadow-md transition-shadow" onClick={() => setStatusFiltro(status)}>
              <CardContent className="pt-4 pb-4">
                <div className="flex items-center gap-3">
                  <div className={`h-9 w-9 rounded-lg flex items-center justify-center ${config.color}`}>
                    <Icon className="h-4 w-4" />
                  </div>
                  <div>
                    <p className="text-2xl font-bold">{count}</p>
                    <p className="text-xs text-gray-500">{config.label}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Filtros */}
      <Card>
        <CardContent className="pt-4">
          <div className="flex flex-col sm:flex-row gap-3">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
              <Input
                placeholder="Buscar por número, descrição ou beneficiário..."
                value={filtro}
                onChange={(e) => setFiltro(e.target.value)}
                className="pl-9"
              />
            </div>
            <Select value={statusFiltro} onValueChange={setStatusFiltro}>
              <SelectTrigger className="w-full sm:w-[180px]">
                <Filter className="h-4 w-4 mr-2" />
                <SelectValue placeholder="Status" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="todos">Todos os status</SelectItem>
                <SelectItem value="rascunho">Rascunho</SelectItem>
                <SelectItem value="solicitado">Solicitado</SelectItem>
                <SelectItem value="em_analise">Em Análise</SelectItem>
                <SelectItem value="aprovado">Aprovado</SelectItem>
                <SelectItem value="rejeitado">Rejeitado</SelectItem>
                <SelectItem value="pago">Pago</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* Lista de Solicitações */}
      {solicitacoesFiltradas.length === 0 ? (
        <Card>
          <CardContent className="py-12">
            <div className="text-center text-gray-500">
              <FileText className="h-12 w-12 mx-auto mb-3 opacity-50" />
              <p className="font-medium">Nenhuma solicitação encontrada</p>
              <p className="text-sm mt-1">
                {filtro || statusFiltro !== "todos"
                  ? "Tente ajustar os filtros"
                  : "Crie sua primeira solicitação de pagamento"}
              </p>
              {!filtro && statusFiltro === "todos" && (
                <Button className="mt-4" asChild>
                  <Link to="/colaborador/solicitacoes/nova">
                    <Plus className="h-4 w-4 mr-2" />
                    Nova Solicitação
                  </Link>
                </Button>
              )}
            </div>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {solicitacoesFiltradas.map((solicitacao) => {
            const statusConfig = getStatusConfig(solicitacao.status);
            const StatusIcon = statusConfig.icon;
            return (
              <Card
                key={solicitacao.id}
                className="hover:shadow-md transition-shadow cursor-pointer"
                onClick={() => setSolicitacaoDetalhe(solicitacao)}
              >
                <CardContent className="p-4">
                  <div className="flex flex-col sm:flex-row sm:items-center gap-4">
                    {/* Info Principal */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-3">
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="font-mono text-sm text-gray-500">
                              {solicitacao.numero_solicitacao}
                            </span>
                            <Badge variant="outline" className="text-xs">
                              {getTipoBadge(solicitacao.tipo)}
                            </Badge>
                          </div>
                          <h3 className="font-medium text-gray-900 mt-1 truncate">
                            {solicitacao.descricao}
                          </h3>
                        </div>
                        <span className={`px-2 py-1 rounded-full text-xs font-medium inline-flex items-center gap-1 ${statusConfig.color}`}>
                          <StatusIcon className="h-3 w-3" />
                          {statusConfig.label}
                        </span>
                      </div>

                      {/* Meta Info */}
                      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 mt-2 text-sm text-gray-500">
                        {solicitacao.beneficiario?.nome && (
                          <span>Para: {solicitacao.beneficiario.nome}</span>
                        )}
                        {solicitacao.beneficiario_nome && !solicitacao.beneficiario?.nome && (
                          <span>Para: {solicitacao.beneficiario_nome}</span>
                        )}
                        {solicitacao.projeto?.numero_contrato && (
                          <div className="flex items-center gap-1">
                            <Building2 className="h-3 w-3" />
                            <span>{solicitacao.projeto.numero_contrato}</span>
                          </div>
                        )}
                        <div className="flex items-center gap-1">
                          <Calendar className="h-3 w-3" />
                          <span>{formatarData(solicitacao.criado_em)}</span>
                        </div>
                      </div>
                    </div>

                    {/* Valor */}
                    <div className="text-right sm:min-w-[120px]">
                      <p className="text-lg font-bold text-[#F25C26]">
                        {formatarMoeda(solicitacao.valor)}
                      </p>
                      {solicitacao.data_vencimento && (
                        <p className="text-xs text-gray-500">
                          Venc: {formatarData(solicitacao.data_vencimento)}
                        </p>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}

      {/* Modal de Detalhes */}
      <Dialog open={!!solicitacaoDetalhe} onOpenChange={() => setSolicitacaoDetalhe(null)}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              Solicitação {solicitacaoDetalhe?.numero_solicitacao}
            </DialogTitle>
          </DialogHeader>
          {solicitacaoDetalhe && (
            <div className="space-y-4">
              {/* Status */}
              <div className="flex items-center gap-2">
                {(() => {
                  const config = getStatusConfig(solicitacaoDetalhe.status);
                  const Icon = config.icon;
                  return (
                    <span className={`px-3 py-1 rounded-full text-sm font-medium inline-flex items-center gap-2 ${config.color}`}>
                      <Icon className="h-4 w-4" />
                      {config.label}
                    </span>
                  );
                })()}
                <Badge variant="outline">{getTipoBadge(solicitacaoDetalhe.tipo)}</Badge>
              </div>

              {/* Descrição */}
              <div>
                <h4 className="text-sm font-medium text-gray-500 mb-1">Descrição</h4>
                <p className="text-gray-900">{solicitacaoDetalhe.descricao}</p>
              </div>

              {/* Valor */}
              <div className="p-4 bg-[#F25C26]/5 rounded-lg">
                <p className="text-sm text-gray-500">Valor Solicitado</p>
                <p className="text-3xl font-bold text-[#F25C26]">
                  {formatarMoeda(solicitacaoDetalhe.valor)}
                </p>
              </div>

              {/* Beneficiário */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h4 className="text-sm font-medium text-gray-500 mb-1">Beneficiário</h4>
                  <p className="text-gray-900">
                    {solicitacaoDetalhe.beneficiario?.nome || solicitacaoDetalhe.beneficiario_nome || "-"}
                  </p>
                </div>
                {solicitacaoDetalhe.beneficiario_documento && (
                  <div>
                    <h4 className="text-sm font-medium text-gray-500 mb-1">CPF/CNPJ</h4>
                    <p className="text-gray-900">{solicitacaoDetalhe.beneficiario_documento}</p>
                  </div>
                )}
              </div>

              {/* Dados Bancários */}
              {(solicitacaoDetalhe.chave_pix || solicitacaoDetalhe.banco) && (
                <div className="p-4 bg-gray-50 rounded-lg">
                  <h4 className="text-sm font-medium text-gray-700 mb-2">Dados para Pagamento</h4>
                  {solicitacaoDetalhe.chave_pix && (
                    <p className="text-sm">
                      <span className="text-gray-500">PIX:</span>{" "}
                      <span className="font-mono">{solicitacaoDetalhe.chave_pix}</span>
                    </p>
                  )}
                  {solicitacaoDetalhe.banco && (
                    <p className="text-sm">
                      <span className="text-gray-500">Banco:</span> {solicitacaoDetalhe.banco} |{" "}
                      <span className="text-gray-500">Ag:</span> {solicitacaoDetalhe.agencia} |{" "}
                      <span className="text-gray-500">Conta:</span> {solicitacaoDetalhe.conta}
                    </p>
                  )}
                </div>
              )}

              {/* Anexos */}
              {solicitacaoDetalhe.anexos && solicitacaoDetalhe.anexos.length > 0 && (
                <div>
                  <h4 className="text-sm font-medium text-gray-500 mb-2">Anexos</h4>
                  <div className="flex flex-wrap gap-2">
                    {solicitacaoDetalhe.anexos.map((anexo) => (
                      <a
                        key={anexo.id}
                        href={anexo.arquivo_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1 px-3 py-1 bg-gray-100 rounded-full text-sm hover:bg-gray-200 transition-colors"
                      >
                        <FileText className="h-3 w-3" />
                        {anexo.nome}
                      </a>
                    ))}
                  </div>
                </div>
              )}

              {/* Motivo Rejeição */}
              {solicitacaoDetalhe.status === "rejeitado" && solicitacaoDetalhe.motivo_rejeicao && (
                <div className="p-4 bg-red-50 rounded-lg">
                  <h4 className="text-sm font-medium text-red-800 mb-1">Motivo da Rejeição</h4>
                  <p className="text-red-700">{solicitacaoDetalhe.motivo_rejeicao}</p>
                </div>
              )}

              {/* Datas */}
              <div className="flex flex-wrap gap-4 text-sm text-gray-500 pt-4 border-t">
                <span>Criado em: {formatarData(solicitacaoDetalhe.criado_em)}</span>
                {solicitacaoDetalhe.data_vencimento && (
                  <span>Vencimento: {formatarData(solicitacaoDetalhe.data_vencimento)}</span>
                )}
                {solicitacaoDetalhe.data_aprovacao && (
                  <span>Aprovado em: {formatarData(solicitacaoDetalhe.data_aprovacao)}</span>
                )}
                {solicitacaoDetalhe.data_pagamento && (
                  <span>Pago em: {formatarData(solicitacaoDetalhe.data_pagamento)}</span>
                )}
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
