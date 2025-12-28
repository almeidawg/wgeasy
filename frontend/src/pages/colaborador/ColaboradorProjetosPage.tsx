/**
 * Página de Projetos do Colaborador
 * Lista de projetos vinculados ao colaborador
 */

import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "@/auth/AuthContext";
import {
  Building2,
  Calendar,
  Users,
  FileText,
  ExternalLink,
  Search,
  Filter,
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
  listarProjetosColaborador,
  ColaboradorProjeto,
} from "@/lib/colaboradorApi";

export default function ColaboradorProjetosPage() {
  const { usuarioCompleto } = useAuth();
  const [loading, setLoading] = useState(true);
  const [projetos, setProjetos] = useState<ColaboradorProjeto[]>([]);
  const [filtro, setFiltro] = useState("");
  const [statusFiltro, setStatusFiltro] = useState<string>("todos");

  useEffect(() => {
    const carregarProjetos = async () => {
      if (!usuarioCompleto?.pessoa_id) return;

      try {
        setLoading(true);
        const data = await listarProjetosColaborador(usuarioCompleto.pessoa_id);
        setProjetos(data);
      } catch (error) {
        console.error("Erro ao carregar projetos:", error);
      } finally {
        setLoading(false);
      }
    };

    carregarProjetos();
  }, [usuarioCompleto?.pessoa_id]);

  const formatarData = (data?: string) => {
    if (!data) return "-";
    return new Date(data).toLocaleDateString("pt-BR");
  };

  const formatarMoeda = (valor?: number) => {
    if (!valor) return "-";
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }).format(valor);
  };

  const getStatusBadge = (status?: string) => {
    const statusConfig: Record<string, { label: string; variant: "default" | "secondary" | "destructive" | "outline"; color: string }> = {
      ativo: { label: "Ativo", variant: "default", color: "bg-green-100 text-green-800" },
      em_execucao: { label: "Em Execução", variant: "default", color: "bg-blue-100 text-blue-800" },
      concluido: { label: "Concluído", variant: "secondary", color: "bg-gray-100 text-gray-800" },
      aguardando_assinatura: { label: "Aguardando Assinatura", variant: "outline", color: "bg-yellow-100 text-yellow-800" },
    };

    const config = statusConfig[status || ""] || { label: status || "N/A", variant: "outline" as const, color: "bg-gray-100 text-gray-600" };
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${config.color}`}>
        {config.label}
      </span>
    );
  };

  const projetosFiltrados = projetos.filter((p) => {
    const matchNome =
      p.projeto?.cliente_nome?.toLowerCase().includes(filtro.toLowerCase()) ||
      p.funcao?.toLowerCase().includes(filtro.toLowerCase());

    const matchStatus =
      statusFiltro === "todos" || p.projeto?.status === statusFiltro;

    return matchNome && matchStatus;
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
          <h1 className="text-2xl font-bold text-gray-900">Meus Projetos</h1>
          <p className="text-gray-500 mt-1">
            Projetos sob sua responsabilidade
          </p>
        </div>
        <Badge variant="secondary" className="self-start sm:self-auto">
          {projetos.length} projeto{projetos.length !== 1 ? "s" : ""}
        </Badge>
      </div>

      {/* Filtros */}
      <Card>
        <CardContent className="pt-4">
          <div className="flex flex-col sm:flex-row gap-3">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
              <Input
                placeholder="Buscar por cliente ou função..."
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
                <SelectItem value="ativo">Ativos</SelectItem>
                <SelectItem value="em_execucao">Em Execução</SelectItem>
                <SelectItem value="concluido">Concluídos</SelectItem>
                <SelectItem value="aguardando_assinatura">Aguardando</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* Lista de Projetos */}
      {projetosFiltrados.length === 0 ? (
        <Card>
          <CardContent className="py-12">
            <div className="text-center text-gray-500">
              <Building2 className="h-12 w-12 mx-auto mb-3 opacity-50" />
              <p className="font-medium">Nenhum projeto encontrado</p>
              <p className="text-sm mt-1">
                {filtro || statusFiltro !== "todos"
                  ? "Tente ajustar os filtros"
                  : "Você ainda não está vinculado a nenhum projeto"}
              </p>
            </div>
          </CardContent>
        </Card>
      ) : (
        <div className="grid gap-4">
          {projetosFiltrados.map((projeto) => (
            <Card
              key={projeto.id}
              className="hover:shadow-md transition-shadow"
            >
              <CardContent className="p-6">
                <div className="flex flex-col lg:flex-row lg:items-center gap-4">
                  {/* Info Principal */}
                  <div className="flex items-start gap-4 flex-1">
                    <div className="h-12 w-12 bg-[#F25C26]/10 rounded-xl flex items-center justify-center flex-shrink-0">
                      <Building2 className="h-6 w-6 text-[#F25C26]" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-3">
                        <div>
                          <h3 className="font-semibold text-gray-900 text-lg">
                            {projeto.projeto?.cliente_nome || "Projeto"}
                          </h3>
                          <p className="text-sm text-gray-500">
                            Contrato: {projeto.projeto?.numero_contrato || "N/A"}
                          </p>
                        </div>
                        {getStatusBadge(projeto.projeto?.status)}
                      </div>

                      {/* Meta Info */}
                      <div className="flex flex-wrap items-center gap-x-4 gap-y-2 mt-3 text-sm text-gray-600">
                        <div className="flex items-center gap-1">
                          <Users className="h-4 w-4" />
                          <span>{projeto.funcao || "Equipe"}</span>
                        </div>
                        <div className="flex items-center gap-1">
                          <Calendar className="h-4 w-4" />
                          <span>Desde {formatarData(projeto.data_inicio || projeto.criado_em)}</span>
                        </div>
                        {projeto.projeto?.valor_total && (
                          <div className="flex items-center gap-1 font-medium text-[#F25C26]">
                            {formatarMoeda(projeto.projeto.valor_total)}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Ações */}
                  <div className="flex items-center gap-2 lg:flex-shrink-0">
                    <Button variant="outline" size="sm" asChild>
                      <Link to={`/colaborador/projetos/${projeto.projeto_id}`}>
                        <FileText className="h-4 w-4 mr-2" />
                        Detalhes
                      </Link>
                    </Button>
                    <Button variant="ghost" size="sm" asChild>
                      <Link to={`/colaborador/obra/${projeto.projeto_id}`}>
                        <ExternalLink className="h-4 w-4" />
                      </Link>
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
