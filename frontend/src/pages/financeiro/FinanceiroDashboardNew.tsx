import { useState, useEffect, useCallback } from "react";
import { motion } from "framer-motion";
import {
  TrendingUp,
  TrendingDown,
  DollarSign,
  Building2,
  AlertCircle,
  Users,
  Wrench,
  Package,
  ShoppingCart,
  Filter,
  RefreshCw,
  ArrowUpRight,
  ArrowDownRight,
} from "lucide-react";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  AreaChart,
  Area,
} from "recharts";
import { supabaseRaw as supabase } from "@/lib/supabaseClient";
import { Button } from "@/components/ui/button";

// Cores dos núcleos WG
const NUCLEO_COLORS = {
  arquitetura: "#5E9B94", // Verde Mineral
  engenharia: "#2B4580",  // Azul Técnico
  marcenaria: "#8B5E3C",  // Marrom Carvalho
};

// Cores das categorias
const CATEGORIA_COLORS = {
  mao_de_obra: "#F25C26",   // Laranja WG
  servicos: "#2B4580",      // Azul
  produtos: "#5E9B94",      // Verde
  materiais: "#8B5E3C",     // Marrom
};

type DashboardData = {
  resumo: {
    saldoTotal: number;
    custosTotal: number;
    receitasTotal: number;
    projetosAtivos: number;
    valorContratosAtivos: number;
  };
  porNucleo: {
    nucleo: string;
    cor: string;
    receitas: number;
    custos: number;
    margem: number;
    projetos: number;
  }[];
  porCategoria: {
    categoria: string;
    nome: string;
    cor: string;
    valor: number;
    icone: string;
    percentual: number;
  }[];
  fluxoMensal: { mes: string; entrada: number; saida: number; saldo: number }[];
  alertas: { tipo: string; mensagem: string }[];
  topProjetos: { nome: string; valor: number; nucleo: string }[];
};

export default function FinanceiroDashboardNew() {
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [nucleoFiltro, setNucleoFiltro] = useState<string>("todos");

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      // Buscar lançamentos financeiros
      const { data: transacoes, error: transacoesError } = await supabase
        .from("financeiro_lancamentos")
        .select("valor_total, tipo, data_competencia, categoria_id, unidade_negocio, descricao")
        .range(0, 49999);

      // Buscar contratos ativos
      const { data: contratos, error: contratosError } = await supabase
        .from("contratos")
        .select("id, status, valor_total, unidade_negocio, titulo, cliente_id")
        .in("status", ["ativo", "em_andamento", "Em Andamento"]);

      // Buscar categorias
      const { data: categorias } = await supabase
        .from("fin_categories")
        .select("id, name, kind");

      // Buscar solicitações pendentes
      const { data: solicitacoes } = await supabase
        .from("solicitacoes_pagamento")
        .select("status, valor")
        .eq("status", "Pendente");

      if (transacoesError) throw transacoesError;
      if (contratosError) throw contratosError;

      // Processar totais
      const totalEntradas = (transacoes || [])
        .filter((t) => t.tipo === "entrada")
        .reduce((acc, t) => acc + Number(t.valor_total), 0);

      const totalSaidas = (transacoes || [])
        .filter((t) => t.tipo === "saida")
        .reduce((acc, t) => acc + Number(t.valor_total), 0);

      // Processar dados por núcleo
      const nucleos = ["arquitetura", "engenharia", "marcenaria"];
      const porNucleo = nucleos.map(nucleo => {
        const contratosNucleo = (contratos || []).filter(c =>
          c.unidade_negocio?.toLowerCase().includes(nucleo)
        );
        const transacoesNucleo = (transacoes || []).filter(t =>
          t.unidade_negocio?.toLowerCase().includes(nucleo)
        );

        const receitas = transacoesNucleo
          .filter(t => t.tipo === "entrada")
          .reduce((acc, t) => acc + Number(t.valor_total), 0) ||
          contratosNucleo.reduce((acc, c) => acc + Number(c.valor_total || 0), 0);

        const custos = transacoesNucleo
          .filter(t => t.tipo === "saida")
          .reduce((acc, t) => acc + Number(t.valor_total), 0);

        return {
          nucleo: nucleo.charAt(0).toUpperCase() + nucleo.slice(1),
          cor: NUCLEO_COLORS[nucleo as keyof typeof NUCLEO_COLORS],
          receitas,
          custos,
          margem: receitas > 0 ? ((receitas - custos) / receitas * 100) : 0,
          projetos: contratosNucleo.length,
        };
      });

      // Processar por categoria (Mão de Obra, Serviços, Produtos, Materiais)
      const categoriasConfig = [
        { key: "mao_de_obra", nome: "Mão de Obra", icone: "users", termos: ["mão de obra", "mao de obra", "salario", "equipe", "funcionario"] },
        { key: "servicos", nome: "Serviços", icone: "wrench", termos: ["serviço", "servico", "instalação", "montagem", "execução"] },
        { key: "produtos", nome: "Produtos", icone: "shopping", termos: ["produto", "equipamento", "móvel", "movel", "eletrodoméstico"] },
        { key: "materiais", nome: "Materiais", icone: "package", termos: ["material", "insumo", "matéria", "madeira", "ferragem"] },
      ];

      const totalCustos = totalSaidas || 1;
      const porCategoria = categoriasConfig.map(cat => {
        const valor = (transacoes || [])
          .filter(t => t.tipo === "saida")
          .filter(t => {
            const desc = (t.descricao || "").toLowerCase();
            const catId = (t.categoria_id || "").toLowerCase();
            return cat.termos.some(termo => desc.includes(termo) || catId.includes(termo));
          })
          .reduce((acc, t) => acc + Number(t.valor_total), 0);

        return {
          categoria: cat.key,
          nome: cat.nome,
          cor: CATEGORIA_COLORS[cat.key as keyof typeof CATEGORIA_COLORS],
          valor,
          icone: cat.icone,
          percentual: (valor / totalCustos) * 100,
        };
      });

      // Adicionar "Outros" para valores não categorizados
      const valorCategorizado = porCategoria.reduce((acc, c) => acc + c.valor, 0);
      const valorOutros = totalSaidas - valorCategorizado;
      if (valorOutros > 0) {
        porCategoria.push({
          categoria: "outros",
          nome: "Outros",
          cor: "#94A3B8",
          valor: valorOutros,
          icone: "circle",
          percentual: (valorOutros / totalCustos) * 100,
        });
      }

      // Fluxo mensal com saldo acumulado
      const fluxoMensal: { [key: string]: { mes: string; entrada: number; saida: number } } = {};
      (transacoes || []).forEach(t => {
        const date = new Date(t.data_competencia);
        const mes = date.toLocaleString("pt-BR", { month: "short" });
        if (!fluxoMensal[mes]) fluxoMensal[mes] = { mes, entrada: 0, saida: 0 };
        if (t.tipo === "entrada") fluxoMensal[mes].entrada += Number(t.valor_total);
        else fluxoMensal[mes].saida += Number(t.valor_total);
      });

      const fluxoMensalArray = Object.values(fluxoMensal).map((item, index, arr) => {
        const saldoAcumulado = arr.slice(0, index + 1).reduce((acc, curr) =>
          acc + curr.entrada - curr.saida, 0
        );
        return { ...item, saldo: saldoAcumulado };
      });

      // Top projetos
      const topProjetos = (contratos || [])
        .slice(0, 5)
        .map(c => ({
          nome: c.titulo || "Projeto",
          valor: Number(c.valor_total || 0),
          nucleo: c.unidade_negocio || "Geral",
        }));

      // Contratos ativos
      const contratosAtivos = contratos || [];
      const valorTotalContratosAtivos = contratosAtivos.reduce(
        (acc, c) => acc + Number(c.valor_total || 0), 0
      );

      const receitaEfetiva = totalEntradas > 0 ? totalEntradas : valorTotalContratosAtivos;

      // Alertas
      const solicitacoesPendentesCount = (solicitacoes || []).length;
      const valorSolicitacoesPendentes = (solicitacoes || []).reduce((acc, s) => acc + Number(s.valor || 0), 0);

      const alertas = [];
      if (solicitacoesPendentesCount > 0) {
        alertas.push({
          tipo: "warning",
          mensagem: `${solicitacoesPendentesCount} solicitações pendentes (R$ ${valorSolicitacoesPendentes.toLocaleString("pt-BR", { minimumFractionDigits: 2 })})`,
        });
      }
      if (contratosAtivos.length > 10) {
        alertas.push({
          tipo: "info",
          mensagem: `${contratosAtivos.length} contratos ativos simultaneamente`,
        });
      }
      const margemGeral = receitaEfetiva > 0 ? ((receitaEfetiva - totalSaidas) / receitaEfetiva * 100) : 0;
      if (margemGeral < 20) {
        alertas.push({
          tipo: "warning",
          mensagem: `Margem geral baixa: ${margemGeral.toFixed(1)}%`,
        });
      } else {
        alertas.push({
          tipo: "success",
          mensagem: `Margem saudável: ${margemGeral.toFixed(1)}%`,
        });
      }

      setDashboardData({
        resumo: {
          saldoTotal: receitaEfetiva - totalSaidas,
          custosTotal: totalSaidas,
          receitasTotal: receitaEfetiva,
          projetosAtivos: contratosAtivos.length,
          valorContratosAtivos: valorTotalContratosAtivos,
        },
        porNucleo,
        porCategoria,
        fluxoMensal: fluxoMensalArray,
        alertas,
        topProjetos,
      });
    } catch (error: any) {
      console.error("Dashboard Error:", error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  if (loading || !dashboardData) {
    return (
      <div className="flex items-center justify-center h-full pt-16">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#F25C26]"></div>
      </div>
    );
  }

  const formatCurrency = (value: number) => {
    return `R$ ${value.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}`;
  };

  const getCategoriaIcon = (icone: string) => {
    switch (icone) {
      case "users": return <Users className="w-5 h-5" />;
      case "wrench": return <Wrench className="w-5 h-5" />;
      case "shopping": return <ShoppingCart className="w-5 h-5" />;
      case "package": return <Package className="w-5 h-5" />;
      default: return <DollarSign className="w-5 h-5" />;
    }
  };

  return (
    <div className="space-y-6 p-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard Financeiro</h1>
          <p className="text-gray-600 mt-1">Visão consolidada por núcleos e categorias</p>
        </div>
        <div className="flex items-center gap-3">
          {/* Filtro por Núcleo */}
          <div className="flex items-center gap-2 bg-white rounded-lg border border-gray-200 p-1">
            <button
              onClick={() => setNucleoFiltro("todos")}
              className={`px-3 py-1.5 rounded-md text-sm font-medium transition-colors ${
                nucleoFiltro === "todos" ? "bg-[#F25C26] text-white" : "text-gray-600 hover:bg-gray-100"
              }`}
            >
              Todos
            </button>
            {Object.entries(NUCLEO_COLORS).map(([nucleo, cor]) => (
              <button
                key={nucleo}
                onClick={() => setNucleoFiltro(nucleo)}
                className={`px-3 py-1.5 rounded-md text-sm font-medium transition-colors ${
                  nucleoFiltro === nucleo ? "text-white" : "text-gray-600 hover:bg-gray-100"
                }`}
                style={{ backgroundColor: nucleoFiltro === nucleo ? cor : undefined }}
              >
                {nucleo.charAt(0).toUpperCase() + nucleo.slice(1)}
              </button>
            ))}
          </div>
          <Button variant="outline" size="sm" onClick={fetchData}>
            <RefreshCw className="w-4 h-4 mr-2" />
            Atualizar
          </Button>
        </div>
      </div>

      {/* Cards Resumo Principal */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-100 text-sm font-medium">Saldo Atual</p>
              <p className="text-2xl font-bold mt-1">{formatCurrency(dashboardData.resumo.saldoTotal)}</p>
              <div className="flex items-center mt-2 text-green-100 text-sm">
                <ArrowUpRight className="w-4 h-4 mr-1" />
                <span>+12.5% este mês</span>
              </div>
            </div>
            <div className="p-3 bg-white/20 rounded-lg">
              <DollarSign className="w-8 h-8" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-100 text-sm font-medium">Receitas</p>
              <p className="text-2xl font-bold mt-1">{formatCurrency(dashboardData.resumo.receitasTotal)}</p>
              <div className="flex items-center mt-2 text-blue-100 text-sm">
                <TrendingUp className="w-4 h-4 mr-1" />
                <span>{dashboardData.resumo.projetosAtivos} contratos</span>
              </div>
            </div>
            <div className="p-3 bg-white/20 rounded-lg">
              <TrendingUp className="w-8 h-8" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-gradient-to-br from-orange-500 to-red-500 rounded-xl shadow-lg p-6 text-white"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-orange-100 text-sm font-medium">Custos Totais</p>
              <p className="text-2xl font-bold mt-1">{formatCurrency(dashboardData.resumo.custosTotal)}</p>
              <div className="flex items-center mt-2 text-orange-100 text-sm">
                <ArrowDownRight className="w-4 h-4 mr-1" />
                <span>4 categorias</span>
              </div>
            </div>
            <div className="p-3 bg-white/20 rounded-lg">
              <TrendingDown className="w-8 h-8" />
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-lg p-6 text-white"
        >
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-100 text-sm font-medium">Contratos Ativos</p>
              <p className="text-2xl font-bold mt-1">{dashboardData.resumo.projetosAtivos}</p>
              <p className="text-purple-100 text-sm mt-1">
                {formatCurrency(dashboardData.resumo.valorContratosAtivos)}
              </p>
            </div>
            <div className="p-3 bg-white/20 rounded-lg">
              <Building2 className="w-8 h-8" />
            </div>
          </div>
        </motion.div>
      </div>

      {/* Cards por Núcleo */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {dashboardData.porNucleo.map((nucleo, index) => (
          <motion.div
            key={nucleo.nucleo}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 + index * 0.1 }}
            className="bg-white rounded-xl shadow-md border border-gray-100 p-6"
          >
            <div className="flex items-center gap-3 mb-4">
              <div
                className="w-3 h-10 rounded-full"
                style={{ backgroundColor: nucleo.cor }}
              />
              <div>
                <h3 className="font-bold text-gray-900">{nucleo.nucleo}</h3>
                <p className="text-sm text-gray-500">{nucleo.projetos} projetos ativos</p>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-xs text-gray-500 uppercase">Receitas</p>
                <p className="text-lg font-bold text-green-600">{formatCurrency(nucleo.receitas)}</p>
              </div>
              <div>
                <p className="text-xs text-gray-500 uppercase">Custos</p>
                <p className="text-lg font-bold text-red-500">{formatCurrency(nucleo.custos)}</p>
              </div>
            </div>
            <div className="mt-4 pt-4 border-t border-gray-100">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Margem</span>
                <span
                  className={`text-sm font-bold ${nucleo.margem >= 20 ? "text-green-600" : "text-orange-500"}`}
                >
                  {nucleo.margem.toFixed(1)}%
                </span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2 mt-2">
                <div
                  className="h-2 rounded-full transition-all"
                  style={{
                    width: `${Math.min(nucleo.margem, 100)}%`,
                    backgroundColor: nucleo.margem >= 20 ? "#10B981" : "#F59E0B"
                  }}
                />
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Custos por Categoria */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.8 }}
        className="bg-white rounded-xl shadow-md border border-gray-100 p-6"
      >
        <h2 className="text-lg font-bold text-gray-900 mb-6">Custos por Categoria</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-4">
          {dashboardData.porCategoria.map((cat) => (
            <div
              key={cat.categoria}
              className="bg-gray-50 rounded-xl p-4 border-l-4"
              style={{ borderLeftColor: cat.cor }}
            >
              <div className="flex items-center gap-2 mb-2">
                <div className="p-2 rounded-lg" style={{ backgroundColor: `${cat.cor}20` }}>
                  <div style={{ color: cat.cor }}>
                    {getCategoriaIcon(cat.icone)}
                  </div>
                </div>
                <span className="text-sm font-medium text-gray-700">{cat.nome}</span>
              </div>
              <p className="text-xl font-bold text-gray-900">{formatCurrency(cat.valor)}</p>
              <p className="text-xs text-gray-500 mt-1">{cat.percentual.toFixed(1)}% do total</p>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Gráficos */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Fluxo de Caixa */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.9 }}
          className="bg-white rounded-xl shadow-md border border-gray-100 p-6 lg:col-span-2"
        >
          <h2 className="text-lg font-bold text-gray-900 mb-4">Fluxo de Caixa Mensal</h2>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={dashboardData.fluxoMensal}>
              <defs>
                <linearGradient id="colorEntrada" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#10B981" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#10B981" stopOpacity={0}/>
                </linearGradient>
                <linearGradient id="colorSaida" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#F25C26" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#F25C26" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" />
              <XAxis dataKey="mes" stroke="#6B7280" />
              <YAxis tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`} stroke="#6B7280" />
              <Tooltip
                formatter={(value: any) => formatCurrency(value)}
                contentStyle={{ borderRadius: "8px", border: "1px solid #E5E7EB" }}
              />
              <Legend />
              <Area
                type="monotone"
                dataKey="entrada"
                stroke="#10B981"
                fillOpacity={1}
                fill="url(#colorEntrada)"
                strokeWidth={2}
                name="Entradas"
              />
              <Area
                type="monotone"
                dataKey="saida"
                stroke="#F25C26"
                fillOpacity={1}
                fill="url(#colorSaida)"
                strokeWidth={2}
                name="Saídas"
              />
            </AreaChart>
          </ResponsiveContainer>
        </motion.div>

        {/* Alertas */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1 }}
          className="bg-white rounded-xl shadow-md border border-gray-100 p-6"
        >
          <h2 className="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
            <AlertCircle className="text-[#F25C26]" size={20} /> Alertas
          </h2>
          <div className="space-y-3">
            {dashboardData.alertas.map((alerta, index) => (
              <div
                key={index}
                className={`flex items-start gap-3 p-3 rounded-lg ${
                  alerta.tipo === "warning"
                    ? "bg-yellow-50 border border-yellow-200"
                    : alerta.tipo === "info"
                    ? "bg-blue-50 border border-blue-200"
                    : "bg-green-50 border border-green-200"
                }`}
              >
                <div className={`w-2 h-2 rounded-full mt-1.5 ${
                  alerta.tipo === "warning" ? "bg-yellow-500" :
                  alerta.tipo === "info" ? "bg-blue-500" : "bg-green-500"
                }`} />
                <p className="text-sm text-gray-700">{alerta.mensagem}</p>
              </div>
            ))}
          </div>

          {/* Top Projetos */}
          {dashboardData.topProjetos.length > 0 && (
            <div className="mt-6 pt-4 border-t border-gray-100">
              <h3 className="text-sm font-semibold text-gray-700 mb-3">Top Projetos</h3>
              <div className="space-y-2">
                {dashboardData.topProjetos.slice(0, 3).map((projeto, i) => (
                  <div key={i} className="flex items-center justify-between text-sm">
                    <span className="text-gray-600 truncate max-w-[150px]">{projeto.nome}</span>
                    <span className="font-medium text-gray-900">{formatCurrency(projeto.valor)}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </motion.div>
      </div>

      {/* Distribuição por Núcleo - Gráfico de Pizza */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.1 }}
          className="bg-white rounded-xl shadow-md border border-gray-100 p-6"
        >
          <h2 className="text-lg font-bold text-gray-900 mb-4">Distribuição por Núcleo</h2>
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={dashboardData.porNucleo.filter(n => n.receitas > 0)}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={100}
                fill="#8884d8"
                dataKey="receitas"
                nameKey="nucleo"
                label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
              >
                {dashboardData.porNucleo.map((entry) => (
                  <Cell key={entry.nucleo} fill={entry.cor} />
                ))}
              </Pie>
              <Tooltip formatter={(value: any) => formatCurrency(value)} />
            </PieChart>
          </ResponsiveContainer>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.2 }}
          className="bg-white rounded-xl shadow-md border border-gray-100 p-6"
        >
          <h2 className="text-lg font-bold text-gray-900 mb-4">Comparativo de Custos</h2>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={dashboardData.porCategoria.filter(c => c.valor > 0)}>
              <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" />
              <XAxis dataKey="nome" stroke="#6B7280" tick={{ fontSize: 12 }} />
              <YAxis tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`} stroke="#6B7280" />
              <Tooltip formatter={(value: any) => formatCurrency(value)} />
              <Bar dataKey="valor" radius={[4, 4, 0, 0]}>
                {dashboardData.porCategoria.map((entry) => (
                  <Cell key={entry.categoria} fill={entry.cor} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </motion.div>
      </div>
    </div>
  );
}
