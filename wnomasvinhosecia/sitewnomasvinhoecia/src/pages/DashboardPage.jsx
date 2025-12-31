import React from 'react';
import { Helmet } from 'react-helmet';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { useWine } from '@/contexts/WineContext';
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  AlertTriangle, TrendingUp, Package, DollarSign, Wine,
  Truck, ArrowRight, Users, BarChart3, Calculator,
  TrendingDown, CheckCircle, XCircle, Percent, ShoppingCart
} from 'lucide-react';

const DashboardPage = () => {
  const {
    wines, suppliers, operationalCosts, dashboardStats, isLoaded
  } = useWine();

  if (!isLoaded) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-[#722F37]">Carregando...</div>
      </div>
    );
  }

  // Calculated values
  const {
    totalStock, totalStockValue, lowStockWines, averageMargin,
    totalPotentialRevenue, totalPotentialProfit, activeSuppliers,
    winesWithMultipleSuppliers, winesWithoutSupplier, costDiscrepancyWines,
    topSellingWines, mostProfitableWines, winesByType, operationalCostPerUnit
  } = dashboardStats;

  // Top profitability wines (by profit margin)
  const topProfitMargins = [...wines]
    .filter(w => w.financials?.profitPerUnit > 0)
    .sort((a, b) => (b.financials?.profitPerUnit || 0) - (a.financials?.profitPerUnit || 0))
    .slice(0, 5);

  // Best suppliers (by competitive pricing)
  const supplierStats = suppliers.map(supplier => {
    const wineCount = wines.filter(w =>
      w.suppliers?.some(s => s.name === supplier.name)
    ).length;
    return { ...supplier, wineCount };
  }).filter(s => s.wineCount > 0).sort((a, b) => b.wineCount - a.wineCount);

  return (
    <>
      <Helmet>
        <title>Wno Mas - Dashboard de Gestão</title>
      </Helmet>

      <div className="min-h-screen bg-[#FAF8F5]">
        <Header />

        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header with Navigation */}
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
            <div>
              <h1 className="text-3xl font-semibold text-[#1A1A1A] flex items-center gap-3">
                <BarChart3 className="h-8 w-8 text-[#722F37]" />
                Dashboard de Gestão
              </h1>
              <p className="text-[#6B6B6B]">Visão geral completa da operação Wno Mas</p>
            </div>
            <div className="flex flex-wrap gap-2">
              <Link to="/admin/vinhos">
                <Button variant="outline" size="sm">
                  <Wine className="h-4 w-4 mr-2" />
                  Vinhos
                </Button>
              </Link>
              <Link to="/admin/fornecedores">
                <Button variant="outline" size="sm">
                  <Truck className="h-4 w-4 mr-2" />
                  Fornecedores
                </Button>
              </Link>
              <Link to="/admin/custos">
                <Button variant="outline" size="sm">
                  <Calculator className="h-4 w-4 mr-2" />
                  Custos
                </Button>
              </Link>
            </div>
          </div>

          {/* Quick Stats Grid */}
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4 mb-8">
            <Card className="bg-gradient-to-br from-[#722F37] to-[#8B3A42] text-white">
              <CardContent className="pt-4">
                <Wine className="h-5 w-5 mb-2 opacity-80" />
                <p className="text-xs opacity-80">Vinhos</p>
                <p className="text-2xl font-bold">{wines.length}</p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-4">
                <Package className="h-5 w-5 mb-2 text-blue-500" />
                <p className="text-xs text-muted-foreground">Em Estoque</p>
                <p className="text-2xl font-bold">{totalStock}</p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-4">
                <DollarSign className="h-5 w-5 mb-2 text-green-500" />
                <p className="text-xs text-muted-foreground">Valor Estoque</p>
                <p className="text-xl font-bold">
                  R$ {(totalStockValue / 1000).toFixed(0)}k
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-4">
                <TrendingUp className="h-5 w-5 mb-2 text-purple-500" />
                <p className="text-xs text-muted-foreground">Receita Potencial</p>
                <p className="text-xl font-bold">
                  R$ {(totalPotentialRevenue / 1000).toFixed(0)}k
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="pt-4">
                <Percent className="h-5 w-5 mb-2 text-amber-500" />
                <p className="text-xs text-muted-foreground">Margem Média</p>
                <p className="text-2xl font-bold">{averageMargin.toFixed(0)}%</p>
              </CardContent>
            </Card>

            <Card className={lowStockWines.length > 0 ? 'border-red-200 bg-red-50' : ''}>
              <CardContent className="pt-4">
                <AlertTriangle className={`h-5 w-5 mb-2 ${lowStockWines.length > 0 ? 'text-red-500' : 'text-gray-400'}`} />
                <p className="text-xs text-muted-foreground">Estoque Baixo</p>
                <p className={`text-2xl font-bold ${lowStockWines.length > 0 ? 'text-red-600' : ''}`}>
                  {lowStockWines.length}
                </p>
              </CardContent>
            </Card>
          </div>

          {/* Alerts Section */}
          {(lowStockWines.length > 0 || costDiscrepancyWines.length > 0 || winesWithoutSupplier > 0) && (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
              {lowStockWines.length > 0 && (
                <Card className="border-red-200 bg-red-50">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm flex items-center gap-2 text-red-700">
                      <AlertTriangle className="h-4 w-4" />
                      Estoque Crítico ({lowStockWines.length})
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <ul className="text-sm space-y-1">
                      {lowStockWines.slice(0, 3).map(wine => (
                        <li key={wine.id} className="flex justify-between">
                          <span className="truncate">{wine.name}</span>
                          <span className="font-semibold text-red-600">{wine.inventory?.qty || 0} un</span>
                        </li>
                      ))}
                    </ul>
                    {lowStockWines.length > 3 && (
                      <Link to="/admin/vinhos" className="text-xs text-red-700 hover:underline mt-2 inline-block">
                        Ver todos →
                      </Link>
                    )}
                  </CardContent>
                </Card>
              )}

              {costDiscrepancyWines.length > 0 && (
                <Card className="border-amber-200 bg-amber-50">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm flex items-center gap-2 text-amber-700">
                      <TrendingDown className="h-4 w-4" />
                      Oportunidade de Negociação ({costDiscrepancyWines.length})
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-xs text-amber-700 mb-2">
                      Vinhos com diferença de custo &gt;20% entre fornecedores
                    </p>
                    <ul className="text-sm space-y-1">
                      {costDiscrepancyWines.slice(0, 3).map(wine => (
                        <li key={wine.id} className="truncate">{wine.name}</li>
                      ))}
                    </ul>
                  </CardContent>
                </Card>
              )}

              {winesWithoutSupplier > 0 && (
                <Card className="border-gray-200 bg-gray-50">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm flex items-center gap-2 text-gray-700">
                      <XCircle className="h-4 w-4" />
                      Sem Fornecedor ({winesWithoutSupplier})
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-xs text-gray-600">
                      Vinhos sem fornecedor ativo cadastrado. Configure os fornecedores para calcular preços.
                    </p>
                    <Link to="/admin/vinhos" className="text-xs text-gray-700 hover:underline mt-2 inline-block">
                      Configurar →
                    </Link>
                  </CardContent>
                </Card>
              )}
            </div>
          )}

          {/* Main Tabs */}
          <Tabs defaultValue="inventory" className="w-full">
            <TabsList className="grid w-full grid-cols-4 mb-8">
              <TabsTrigger value="inventory">Inventário</TabsTrigger>
              <TabsTrigger value="financial">Financeiro</TabsTrigger>
              <TabsTrigger value="suppliers">Fornecedores</TabsTrigger>
              <TabsTrigger value="commercial">Comercial</TabsTrigger>
            </TabsList>

            {/* Inventory Tab */}
            <TabsContent value="inventory">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2">
                  <Card>
                    <CardHeader>
                      <CardTitle>Controle de Estoque</CardTitle>
                      <CardDescription>Posição horizontal - Vinhos deitados</CardDescription>
                    </CardHeader>
                    <CardContent>
                      <Table>
                        <TableHeader>
                          <TableRow>
                            <TableHead>Produto</TableHead>
                            <TableHead>Localização</TableHead>
                            <TableHead>Fornecedor</TableHead>
                            <TableHead className="text-right">Qtd</TableHead>
                            <TableHead className="text-center">Status</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {wines.slice(0, 10).map((wine) => (
                            <TableRow key={wine.id}>
                              <TableCell className="font-medium">{wine.name}</TableCell>
                              <TableCell>{wine.inventory?.location || '-'}</TableCell>
                              <TableCell>
                                {wine.suppliers?.[0]?.name || 'N/A'}
                                {wine.suppliers?.length > 1 && (
                                  <span className="text-muted-foreground"> (+{wine.suppliers.length - 1})</span>
                                )}
                              </TableCell>
                              <TableCell className="text-right">{wine.inventory?.qty || 0}</TableCell>
                              <TableCell className="text-center">
                                {(wine.inventory?.qty || 0) <= (wine.inventory?.minStock || 0) ? (
                                  <Badge variant="destructive">Crítico</Badge>
                                ) : (
                                  <Badge variant="outline" className="text-green-600 border-green-200 bg-green-50">OK</Badge>
                                )}
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                      <Link to="/admin/vinhos" className="block mt-4">
                        <Button variant="outline" className="w-full">
                          Ver todos os vinhos
                          <ArrowRight className="h-4 w-4 ml-2" />
                        </Button>
                      </Link>
                    </CardContent>
                  </Card>
                </div>

                <div className="space-y-6">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-base">Por Tipo de Vinho</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        {Object.entries(winesByType).map(([type, count]) => (
                          <div key={type} className="flex items-center justify-between">
                            <Badge variant="outline" className={
                              type === 'Tinto' ? 'border-red-200 bg-red-50 text-red-700' :
                              type === 'Branco' ? 'border-yellow-200 bg-yellow-50 text-yellow-700' :
                              type === 'Rosé' ? 'border-pink-200 bg-pink-50 text-pink-700' :
                              'border-blue-200 bg-blue-50 text-blue-700'
                            }>
                              {type}
                            </Badge>
                            <span className="font-semibold">{count}</span>
                          </div>
                        ))}
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle className="text-base">Custo Operacional</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <p className="text-3xl font-bold text-[#722F37]">
                        R$ {operationalCostPerUnit.toFixed(2)}
                      </p>
                      <p className="text-sm text-muted-foreground">por garrafa</p>
                      <Link to="/admin/custos" className="text-sm text-[#722F37] hover:underline mt-2 inline-block">
                        Configurar custos →
                      </Link>
                    </CardContent>
                  </Card>
                </div>
              </div>
            </TabsContent>

            {/* Financial Tab */}
            <TabsContent value="financial">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2">
                  <Card>
                    <CardHeader>
                      <CardTitle>Análise Financeira</CardTitle>
                      <CardDescription>Custos, margens e precificação detalhada</CardDescription>
                    </CardHeader>
                    <CardContent>
                      <Table>
                        <TableHeader>
                          <TableRow>
                            <TableHead>Produto</TableHead>
                            <TableHead className="text-right">Custo Médio</TableHead>
                            <TableHead className="text-right">Custo Real</TableHead>
                            <TableHead className="text-right">Preço Venda</TableHead>
                            <TableHead className="text-right">Margem</TableHead>
                            <TableHead className="text-right">Lucro/Un</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {wines.slice(0, 10).map((wine) => (
                            <TableRow key={wine.id}>
                              <TableCell className="font-medium">{wine.name}</TableCell>
                              <TableCell className="text-right">
                                R$ {(wine.financials?.baseCost || 0).toFixed(2)}
                              </TableCell>
                              <TableCell className="text-right text-muted-foreground">
                                R$ {(wine.financials?.totalRealCost || 0).toFixed(2)}
                              </TableCell>
                              <TableCell className="text-right font-bold">
                                R$ {(wine.price || 0).toFixed(2)}
                              </TableCell>
                              <TableCell className="text-right">
                                {wine.financials?.marginPercent || wine.margin || 0}%
                              </TableCell>
                              <TableCell className="text-right text-green-600">
                                R$ {(wine.financials?.profitPerUnit || 0).toFixed(2)}
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                    </CardContent>
                  </Card>
                </div>

                <div className="space-y-6">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-base">Resumo Financeiro</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      <div>
                        <p className="text-sm text-muted-foreground">Lucro Potencial (Estoque)</p>
                        <p className="text-2xl font-bold text-green-600">
                          R$ {totalPotentialProfit.toLocaleString('pt-BR', { maximumFractionDigits: 0 })}
                        </p>
                      </div>
                      <div className="border-t pt-4">
                        <p className="text-sm text-muted-foreground">Margem Média</p>
                        <p className="text-2xl font-bold">{averageMargin.toFixed(0)}%</p>
                      </div>
                    </CardContent>
                  </Card>

                  <Card>
                    <CardHeader>
                      <CardTitle className="text-base">Mais Rentáveis</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        {topProfitMargins.slice(0, 5).map((wine, index) => (
                          <div key={wine.id} className="flex items-center justify-between text-sm">
                            <span className="flex items-center gap-2">
                              <span className="text-muted-foreground">{index + 1}.</span>
                              <span className="truncate max-w-[150px]">{wine.name}</span>
                            </span>
                            <span className="font-semibold text-green-600">
                              R$ {(wine.financials?.profitPerUnit || 0).toFixed(0)}
                            </span>
                          </div>
                        ))}
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </div>
            </TabsContent>

            {/* Suppliers Tab */}
            <TabsContent value="suppliers">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2">
                  <Card>
                    <CardHeader>
                      <CardTitle>Fornecedores</CardTitle>
                      <CardDescription>Análise de fornecedores e competitividade</CardDescription>
                    </CardHeader>
                    <CardContent>
                      <Table>
                        <TableHeader>
                          <TableRow>
                            <TableHead>Fornecedor</TableHead>
                            <TableHead className="text-center">Vinhos</TableHead>
                            <TableHead className="text-center">Status</TableHead>
                          </TableRow>
                        </TableHeader>
                        <TableBody>
                          {supplierStats.map((supplier) => (
                            <TableRow key={supplier.id}>
                              <TableCell className="font-medium">{supplier.name}</TableCell>
                              <TableCell className="text-center">
                                <div className="flex items-center justify-center gap-1">
                                  <Wine className="h-4 w-4 text-[#722F37]" />
                                  {supplier.wineCount}
                                </div>
                              </TableCell>
                              <TableCell className="text-center">
                                <Badge variant={supplier.active ? "default" : "secondary"} className={
                                  supplier.active
                                    ? "bg-green-100 text-green-700"
                                    : "bg-gray-100 text-gray-500"
                                }>
                                  {supplier.active ? 'Ativo' : 'Inativo'}
                                </Badge>
                              </TableCell>
                            </TableRow>
                          ))}
                        </TableBody>
                      </Table>
                      <Link to="/admin/fornecedores" className="block mt-4">
                        <Button variant="outline" className="w-full">
                          Gerenciar Fornecedores
                          <ArrowRight className="h-4 w-4 ml-2" />
                        </Button>
                      </Link>
                    </CardContent>
                  </Card>
                </div>

                <div className="space-y-6">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-base">Estatísticas</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Total</span>
                        <span className="font-semibold">{suppliers.length}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Ativos</span>
                        <span className="font-semibold text-green-600">{activeSuppliers}</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-muted-foreground">Vinhos com 2+ fornecedores</span>
                        <span className="font-semibold">{winesWithMultipleSuppliers}</span>
                      </div>
                    </CardContent>
                  </Card>

                  <Card className="bg-blue-50 border-blue-200">
                    <CardContent className="pt-6">
                      <div className="flex items-start gap-3">
                        <CheckCircle className="h-5 w-5 text-blue-500 mt-0.5" />
                        <div>
                          <p className="font-medium text-sm">Dica</p>
                          <p className="text-xs text-muted-foreground mt-1">
                            Cadastrar múltiplos fornecedores por vinho permite calcular o custo médio e identificar oportunidades de negociação.
                          </p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              </div>
            </TabsContent>

            {/* Commercial Tab */}
            <TabsContent value="commercial">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <Card>
                  <CardHeader>
                    <CardTitle>Top 5 Mais Vendidos</CardTitle>
                    <CardDescription>Baseado no histórico de vendas</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <Table>
                      <TableHeader>
                        <TableRow>
                          <TableHead>#</TableHead>
                          <TableHead>Produto</TableHead>
                          <TableHead className="text-right">Vendas</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {topSellingWines.map((wine, index) => (
                          <TableRow key={wine.id}>
                            <TableCell className="font-medium">{index + 1}</TableCell>
                            <TableCell>{wine.name}</TableCell>
                            <TableCell className="text-right font-semibold">
                              {wine.salesStats?.totalSold || 0} un
                            </TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle>Performance de Kits</CardTitle>
                    <CardDescription>Kits promocionais cadastrados</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-4">
                      {['Kit 1 - Começar Bem', 'Kit 2 - Jantar em Casa', 'Kit 3 - Malbecs da Argentina', 'Kit 4 - Noite Especial'].map((kit) => {
                        const winesInKit = wines.filter(w => w.kits?.includes(kit));
                        return (
                          <div key={kit} className="flex justify-between items-center p-3 bg-slate-50 rounded-lg">
                            <div>
                              <span className="font-medium">{kit}</span>
                              <p className="text-xs text-muted-foreground">{winesInKit.length} vinhos</p>
                            </div>
                            <Badge variant={winesInKit.length >= 2 ? "default" : "secondary"}>
                              {winesInKit.length >= 2 ? 'Ativo' : 'Incompleto'}
                            </Badge>
                          </div>
                        );
                      })}
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>
          </Tabs>

        </main>
        <Footer />
      </div>
    </>
  );
};

export default DashboardPage;
