import React, { useState, useEffect } from 'react';
import { Helmet } from 'react-helmet';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { useWine } from '@/contexts/WineContext';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/components/ui/use-toast";
import {
  Save, RotateCcw, Package, Truck, Building2,
  Calculator, Percent, DollarSign, Info, AlertTriangle
} from 'lucide-react';

const CostsPage = () => {
  const { operationalCosts, updateOperationalCosts, resetToDefaults, wines } = useWine();
  const { toast } = useToast();

  const [formData, setFormData] = useState(operationalCosts);
  const [hasChanges, setHasChanges] = useState(false);

  // Update form when context changes
  useEffect(() => {
    setFormData(operationalCosts);
  }, [operationalCosts]);

  // Track changes
  useEffect(() => {
    setHasChanges(JSON.stringify(formData) !== JSON.stringify(operationalCosts));
  }, [formData, operationalCosts]);

  // Handle save
  const handleSave = () => {
    updateOperationalCosts(formData);
    toast({
      title: "Custos atualizados",
      description: "Os custos operacionais foram salvos com sucesso.",
    });
    setHasChanges(false);
  };

  // Handle reset
  const handleReset = () => {
    setFormData(operationalCosts);
    setHasChanges(false);
  };

  // Update nested values
  const updateNested = (category, field, value) => {
    setFormData(prev => ({
      ...prev,
      [category]: {
        ...prev[category],
        [field]: Number(value) || 0
      }
    }));
  };

  // Calculate costs preview
  const packagingTotal = formData.packaging.sacola + formData.packaging.caixa +
                         formData.packaging.protecaoInterna + formData.packaging.etiquetas;

  const logisticsTotal = formData.logistics.freteMedio + formData.logistics.transporteInterno +
                         formData.logistics.seguro;

  const fixedMonthlyTotal = formData.fixed.plataformaSite + formData.fixed.marketing +
                            formData.fixed.armazenagem + formData.fixed.maoDeObra;

  const fixedPerUnit = fixedMonthlyTotal / formData.rateio.estimativaVendasMensais;

  const totalOperationalCostPerUnit = packagingTotal + logisticsTotal + fixedPerUnit;

  // Example calculation
  const exampleBaseCost = 100;
  const exampleTotalCost = exampleBaseCost + totalOperationalCostPerUnit;
  const examplePaymentTax = exampleTotalCost * formData.fixed.taxasPagamento;
  const exampleFinalCost = exampleTotalCost + examplePaymentTax;
  const examplePrice = exampleFinalCost * (1 + formData.margins.padrao / 100);

  return (
    <>
      <Helmet>
        <title>Wno Mas - Custos Operacionais</title>
      </Helmet>

      <div className="min-h-screen bg-[#FAFAFA]">
        <Header />

        <main className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
            <div>
              <h1 className="text-3xl font-semibold text-[#1A1A1A] flex items-center gap-3">
                <Calculator className="h-8 w-8 text-[#722F37]" />
                Custos Operacionais
              </h1>
              <p className="text-[#6B6B6B]">Configure os custos que compõem o preço final</p>
            </div>
            <div className="flex gap-2">
              {hasChanges && (
                <Button variant="outline" onClick={handleReset}>
                  <RotateCcw className="h-4 w-4 mr-2" />
                  Descartar
                </Button>
              )}
              <Button
                onClick={handleSave}
                disabled={!hasChanges}
                className="bg-[#722F37] hover:bg-[#5a252c]"
              >
                <Save className="h-4 w-4 mr-2" />
                Salvar Alterações
              </Button>
            </div>
          </div>

          {hasChanges && (
            <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 mb-6 flex items-center gap-3">
              <AlertTriangle className="h-5 w-5 text-amber-600" />
              <p className="text-sm text-amber-800">
                Você tem alterações não salvas. Clique em "Salvar Alterações" para aplicar.
              </p>
            </div>
          )}

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Left Column - Forms */}
            <div className="lg:col-span-2 space-y-6">
              {/* Packaging Costs */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Package className="h-5 w-5 text-[#722F37]" />
                    Custos de Embalagem (por unidade)
                  </CardTitle>
                  <CardDescription>
                    Itens utilizados na embalagem de cada garrafa vendida
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div>
                      <Label htmlFor="sacola">Sacola</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="sacola"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.packaging.sacola}
                          onChange={(e) => updateNested('packaging', 'sacola', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="caixa">Caixa</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="caixa"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.packaging.caixa}
                          onChange={(e) => updateNested('packaging', 'caixa', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="protecaoInterna">Proteção Interna</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="protecaoInterna"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.packaging.protecaoInterna}
                          onChange={(e) => updateNested('packaging', 'protecaoInterna', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="etiquetas">Etiquetas</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="etiquetas"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.packaging.etiquetas}
                          onChange={(e) => updateNested('packaging', 'etiquetas', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                  </div>
                  <div className="mt-4 pt-4 border-t flex justify-between items-center">
                    <span className="text-sm text-muted-foreground">Total Embalagem:</span>
                    <span className="font-semibold text-lg">R$ {packagingTotal.toFixed(2)}</span>
                  </div>
                </CardContent>
              </Card>

              {/* Logistics Costs */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Truck className="h-5 w-5 text-[#722F37]" />
                    Custos de Logística (por unidade)
                  </CardTitle>
                  <CardDescription>
                    Custos de transporte e entrega por garrafa
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-3 gap-4">
                    <div>
                      <Label htmlFor="freteMedio">Frete Médio</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="freteMedio"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.logistics.freteMedio}
                          onChange={(e) => updateNested('logistics', 'freteMedio', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="transporteInterno">Transporte Interno</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="transporteInterno"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.logistics.transporteInterno}
                          onChange={(e) => updateNested('logistics', 'transporteInterno', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="seguro">Seguro</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="seguro"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.logistics.seguro}
                          onChange={(e) => updateNested('logistics', 'seguro', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                  </div>
                  <div className="mt-4 pt-4 border-t flex justify-between items-center">
                    <span className="text-sm text-muted-foreground">Total Logística:</span>
                    <span className="font-semibold text-lg">R$ {logisticsTotal.toFixed(2)}</span>
                  </div>
                </CardContent>
              </Card>

              {/* Fixed Costs */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Building2 className="h-5 w-5 text-[#722F37]" />
                    Custos Fixos Mensais (rateados)
                  </CardTitle>
                  <CardDescription>
                    Custos fixos que serão divididos pelo número estimado de vendas mensais
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                    <div>
                      <Label htmlFor="plataformaSite">Plataforma/Site</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="plataformaSite"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.fixed.plataformaSite}
                          onChange={(e) => updateNested('fixed', 'plataformaSite', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="marketing">Marketing</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="marketing"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.fixed.marketing}
                          onChange={(e) => updateNested('fixed', 'marketing', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="armazenagem">Armazenagem</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="armazenagem"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.fixed.armazenagem}
                          onChange={(e) => updateNested('fixed', 'armazenagem', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="maoDeObra">Mão de Obra</Label>
                      <div className="relative">
                        <span className="absolute left-3 top-2.5 text-muted-foreground text-sm">R$</span>
                        <Input
                          id="maoDeObra"
                          type="number"
                          step="0.01"
                          min="0"
                          value={formData.fixed.maoDeObra}
                          onChange={(e) => updateNested('fixed', 'maoDeObra', e.target.value)}
                          className="pl-10"
                        />
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="taxasPagamento">Taxa de Pagamento (%)</Label>
                      <div className="relative">
                        <Input
                          id="taxasPagamento"
                          type="number"
                          step="0.01"
                          min="0"
                          max="1"
                          value={formData.fixed.taxasPagamento}
                          onChange={(e) => updateNested('fixed', 'taxasPagamento', e.target.value)}
                        />
                        <span className="absolute right-3 top-2.5 text-muted-foreground text-sm">
                          ({(formData.fixed.taxasPagamento * 100).toFixed(0)}%)
                        </span>
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="estimativaVendasMensais">Vendas/Mês (Rateio)</Label>
                      <Input
                        id="estimativaVendasMensais"
                        type="number"
                        min="1"
                        value={formData.rateio.estimativaVendasMensais}
                        onChange={(e) => setFormData(prev => ({
                          ...prev,
                          rateio: { ...prev.rateio, estimativaVendasMensais: Number(e.target.value) || 1 }
                        }))}
                      />
                    </div>
                  </div>
                  <div className="mt-4 pt-4 border-t space-y-2">
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-muted-foreground">Total Mensal:</span>
                      <span className="font-medium">R$ {fixedMonthlyTotal.toFixed(2)}</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-muted-foreground">Rateado por Unidade:</span>
                      <span className="font-semibold text-lg">R$ {fixedPerUnit.toFixed(2)}</span>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Margins */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Percent className="h-5 w-5 text-[#722F37]" />
                    Margens de Lucro
                  </CardTitle>
                  <CardDescription>
                    Margens padrão aplicadas sobre o custo total
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-3 gap-4">
                    <div>
                      <Label htmlFor="marginPadrao">Margem Padrão</Label>
                      <div className="relative">
                        <Input
                          id="marginPadrao"
                          type="number"
                          min="0"
                          max="200"
                          value={formData.margins.padrao}
                          onChange={(e) => setFormData(prev => ({
                            ...prev,
                            margins: { ...prev.margins, padrao: Number(e.target.value) }
                          }))}
                        />
                        <span className="absolute right-3 top-2.5 text-muted-foreground">%</span>
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="marginPromocional">Margem Promocional</Label>
                      <div className="relative">
                        <Input
                          id="marginPromocional"
                          type="number"
                          min="0"
                          max="200"
                          value={formData.margins.promocional}
                          onChange={(e) => setFormData(prev => ({
                            ...prev,
                            margins: { ...prev.margins, promocional: Number(e.target.value) }
                          }))}
                        />
                        <span className="absolute right-3 top-2.5 text-muted-foreground">%</span>
                      </div>
                    </div>
                    <div>
                      <Label htmlFor="marginKits">Margem Kits</Label>
                      <div className="relative">
                        <Input
                          id="marginKits"
                          type="number"
                          min="0"
                          max="200"
                          value={formData.margins.kits}
                          onChange={(e) => setFormData(prev => ({
                            ...prev,
                            margins: { ...prev.margins, kits: Number(e.target.value) }
                          }))}
                        />
                        <span className="absolute right-3 top-2.5 text-muted-foreground">%</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Right Column - Summary */}
            <div className="space-y-6">
              {/* Cost Summary Card */}
              <Card className="sticky top-4">
                <CardHeader className="bg-[#722F37] text-white rounded-t-lg">
                  <CardTitle className="flex items-center gap-2">
                    <DollarSign className="h-5 w-5" />
                    Resumo dos Custos
                  </CardTitle>
                </CardHeader>
                <CardContent className="pt-6 space-y-4">
                  <div className="space-y-3">
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Embalagem:</span>
                      <span className="font-medium">R$ {packagingTotal.toFixed(2)}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Logística:</span>
                      <span className="font-medium">R$ {logisticsTotal.toFixed(2)}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Fixos Rateados:</span>
                      <span className="font-medium">R$ {fixedPerUnit.toFixed(2)}</span>
                    </div>
                    <div className="border-t pt-3 flex justify-between">
                      <span className="font-semibold">Custo Operacional/Un:</span>
                      <span className="font-bold text-lg text-[#722F37]">
                        R$ {totalOperationalCostPerUnit.toFixed(2)}
                      </span>
                    </div>
                  </div>

                  <div className="bg-slate-50 rounded-lg p-4 mt-4">
                    <div className="flex items-center gap-2 mb-3">
                      <Info className="h-4 w-4 text-blue-500" />
                      <span className="text-sm font-medium">Exemplo de Cálculo</span>
                    </div>
                    <p className="text-xs text-muted-foreground mb-3">
                      Vinho com custo médio de R$ {exampleBaseCost.toFixed(2)}:
                    </p>
                    <div className="space-y-2 text-sm">
                      <div className="flex justify-between">
                        <span>Custo Base:</span>
                        <span>R$ {exampleBaseCost.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>+ Operacional:</span>
                        <span>R$ {totalOperationalCostPerUnit.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>+ Taxa Pgto ({(formData.fixed.taxasPagamento * 100).toFixed(0)}%):</span>
                        <span>R$ {examplePaymentTax.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between border-t pt-2">
                        <span className="font-medium">Custo Total:</span>
                        <span className="font-medium">R$ {exampleFinalCost.toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>+ Margem {formData.margins.padrao}%:</span>
                        <span>R$ {(examplePrice - exampleFinalCost).toFixed(2)}</span>
                      </div>
                      <div className="flex justify-between border-t pt-2 text-[#722F37]">
                        <span className="font-bold">Preço de Venda:</span>
                        <span className="font-bold">R$ {Math.ceil(examplePrice).toFixed(2)}</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Impact Info */}
              <Card>
                <CardContent className="pt-6">
                  <div className="flex items-start gap-3">
                    <AlertTriangle className="h-5 w-5 text-amber-500 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="font-medium text-sm">Impacto nas Precificações</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Alterar esses custos afetará automaticamente o preço de venda de todos os
                        {' '}<span className="font-medium">{wines.length} vinhos</span> cadastrados.
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </main>

        <Footer />
      </div>
    </>
  );
};

export default CostsPage;
