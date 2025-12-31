import React, { useState } from 'react';
import { Helmet } from 'react-helmet';
import { motion, AnimatePresence } from 'framer-motion';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { useWine } from '@/contexts/WineContext';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog";
import { useToast } from "@/components/ui/use-toast";
import {
  Plus, Edit, Trash2, Search, Wine, Package,
  DollarSign, TrendingUp, X, Save, AlertTriangle
} from 'lucide-react';

const WinesAdminPage = () => {
  const {
    wines, rawWines, suppliers,
    addWine, updateWine, deleteWine
  } = useWine();
  const { toast } = useToast();

  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingWine, setEditingWine] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);

  // Form state
  const [formData, setFormData] = useState({
    name: '',
    sku: '',
    type: 'Tinto',
    grapes: '',
    country: '',
    region: '',
    vintage: '',
    alcohol: '',
    body: 'Médio',
    volume: '750ml',
    producer: '',
    image: '',
    notaWnoMas: '',
    harmonization: '',
    idealMoments: '',
    history: '',
    description: '',
    marginPercent: 60,
    supplierCosts: [],
    inventory: {
      qty: 0,
      minStock: 6,
      location: '',
      entryDate: new Date().toISOString().split('T')[0],
      lot: ''
    }
  });

  // Filter wines
  const filteredWines = wines.filter(wine => {
    const matchesSearch = wine.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          wine.sku?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || wine.type === filterType;
    return matchesSearch && matchesType;
  });

  // Open modal for new wine
  const handleNew = () => {
    setEditingWine(null);
    setFormData({
      name: '',
      sku: `WNO-${Date.now().toString().slice(-6)}`,
      type: 'Tinto',
      grapes: '',
      country: '',
      region: '',
      vintage: new Date().getFullYear().toString(),
      alcohol: '',
      body: 'Médio',
      volume: '750ml',
      producer: '',
      image: '',
      notaWnoMas: '',
      harmonization: '',
      idealMoments: '',
      history: '',
      description: '',
      marginPercent: 60,
      supplierCosts: [],
      inventory: {
        qty: 0,
        minStock: 6,
        location: '',
        entryDate: new Date().toISOString().split('T')[0],
        lot: ''
      }
    });
    setIsModalOpen(true);
  };

  // Open modal for editing
  const handleEdit = (wine) => {
    const rawWine = rawWines.find(w => w.id === wine.id);
    setEditingWine(rawWine);
    setFormData({
      ...rawWine,
      grapes: rawWine.grapes?.join(', ') || '',
      harmonization: rawWine.harmonization?.join(', ') || '',
      idealMoments: rawWine.idealMoments?.join(', ') || ''
    });
    setIsModalOpen(true);
  };

  // Handle form submission
  const handleSubmit = (e) => {
    e.preventDefault();

    const wineData = {
      ...formData,
      id: editingWine?.id || `wine-${Date.now()}`,
      grapes: formData.grapes.split(',').map(g => g.trim()).filter(Boolean),
      harmonization: formData.harmonization.split(',').map(h => h.trim()).filter(Boolean),
      idealMoments: formData.idealMoments.split(',').map(m => m.trim()).filter(Boolean),
      marginPercent: Number(formData.marginPercent),
      inventory: {
        ...formData.inventory,
        qty: Number(formData.inventory.qty),
        minStock: Number(formData.inventory.minStock)
      }
    };

    if (editingWine) {
      updateWine(editingWine.id, wineData);
      toast({
        title: "Vinho atualizado",
        description: `${wineData.name} foi atualizado com sucesso.`,
      });
    } else {
      addWine(wineData);
      toast({
        title: "Vinho cadastrado",
        description: `${wineData.name} foi adicionado ao catálogo.`,
      });
    }

    setIsModalOpen(false);
  };

  // Handle supplier cost changes
  const handleSupplierCostChange = (supplierId, cost) => {
    const existingIndex = formData.supplierCosts.findIndex(sc => sc.supplierId === supplierId);
    let newCosts = [...formData.supplierCosts];

    if (cost === '' || cost === 0) {
      newCosts = newCosts.filter(sc => sc.supplierId !== supplierId);
    } else if (existingIndex >= 0) {
      newCosts[existingIndex] = { supplierId, cost: Number(cost), active: true };
    } else {
      newCosts.push({ supplierId, cost: Number(cost), active: true });
    }

    setFormData({ ...formData, supplierCosts: newCosts });
  };

  // Handle delete
  const handleDelete = (wine) => {
    deleteWine(wine.id);
    setDeleteConfirm(null);
    toast({
      title: "Vinho removido",
      description: `${wine.name} foi removido do catálogo.`,
      variant: "destructive"
    });
  };

  // Wine types
  const wineTypes = ['Tinto', 'Branco', 'Rosé', 'Espumante', 'Natural'];
  const bodyTypes = ['Leve', 'Médio', 'Encorpado', 'Muito Encorpado'];

  return (
    <>
      <Helmet>
        <title>Wno Mas - Cadastro de Vinhos</title>
      </Helmet>

      <div className="min-h-screen bg-[#FAFAFA]">
        <Header />

        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
            <div>
              <h1 className="text-3xl font-semibold text-[#1A1A1A] flex items-center gap-3">
                <Wine className="h-8 w-8 text-[#722F37]" />
                Cadastro de Vinhos
              </h1>
              <p className="text-[#6B6B6B]">Gerencie o catálogo de vinhos da Wno Mas</p>
            </div>
            <Button onClick={handleNew} className="bg-[#722F37] hover:bg-[#5a252c]">
              <Plus className="h-4 w-4 mr-2" />
              Novo Vinho
            </Button>
          </div>

          {/* Stats Cards */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Total Vinhos</p>
                    <p className="text-2xl font-bold">{wines.length}</p>
                  </div>
                  <Wine className="h-8 w-8 text-[#722F37] opacity-50" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Em Estoque</p>
                    <p className="text-2xl font-bold">
                      {wines.reduce((acc, w) => acc + (w.inventory?.qty || 0), 0)}
                    </p>
                  </div>
                  <Package className="h-8 w-8 text-blue-500 opacity-50" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Valor Estoque</p>
                    <p className="text-2xl font-bold">
                      R$ {wines.reduce((acc, w) => acc + ((w.inventory?.qty || 0) * (w.financials?.baseCost || 0)), 0).toLocaleString('pt-BR', { maximumFractionDigits: 0 })}
                    </p>
                  </div>
                  <DollarSign className="h-8 w-8 text-green-500 opacity-50" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Margem Média</p>
                    <p className="text-2xl font-bold">
                      {wines.length > 0
                        ? Math.round(wines.reduce((acc, w) => acc + (w.marginPercent || w.margin || 0), 0) / wines.length)
                        : 0}%
                    </p>
                  </div>
                  <TrendingUp className="h-8 w-8 text-purple-500 opacity-50" />
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Filters */}
          <Card className="mb-6">
            <CardContent className="pt-4">
              <div className="flex flex-col sm:flex-row gap-4">
                <div className="flex-1 relative">
                  <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                  <Input
                    placeholder="Buscar por nome ou SKU..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="pl-10"
                  />
                </div>
                <Select
                  value={filterType}
                  onChange={(e) => setFilterType(e.target.value)}
                  className="w-full sm:w-48"
                >
                  <option value="all">Todos os tipos</option>
                  {wineTypes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </Select>
              </div>
            </CardContent>
          </Card>

          {/* Wine Table */}
          <Card>
            <CardContent className="p-0">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-12"></TableHead>
                    <TableHead>Vinho</TableHead>
                    <TableHead>SKU</TableHead>
                    <TableHead>Tipo</TableHead>
                    <TableHead className="text-right">Custo Médio</TableHead>
                    <TableHead className="text-right">Preço Venda</TableHead>
                    <TableHead className="text-right">Margem</TableHead>
                    <TableHead className="text-right">Estoque</TableHead>
                    <TableHead className="text-center">Ações</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredWines.map((wine) => (
                    <TableRow key={wine.id}>
                      <TableCell>
                        {wine.image && (
                          <img
                            src={wine.image}
                            alt={wine.name}
                            className="w-10 h-10 object-contain rounded"
                          />
                        )}
                      </TableCell>
                      <TableCell>
                        <div>
                          <p className="font-medium">{wine.name}</p>
                          <p className="text-xs text-muted-foreground">{wine.producer}</p>
                        </div>
                      </TableCell>
                      <TableCell className="text-sm text-muted-foreground">{wine.sku}</TableCell>
                      <TableCell>
                        <Badge variant="outline" className={
                          wine.type === 'Tinto' ? 'border-red-200 bg-red-50 text-red-700' :
                          wine.type === 'Branco' ? 'border-yellow-200 bg-yellow-50 text-yellow-700' :
                          wine.type === 'Rosé' ? 'border-pink-200 bg-pink-50 text-pink-700' :
                          'border-blue-200 bg-blue-50 text-blue-700'
                        }>
                          {wine.type}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">
                        R$ {(wine.financials?.baseCost || 0).toFixed(2)}
                      </TableCell>
                      <TableCell className="text-right font-semibold">
                        R$ {(wine.price || 0).toFixed(2)}
                      </TableCell>
                      <TableCell className="text-right">
                        {wine.marginPercent || wine.margin || 0}%
                      </TableCell>
                      <TableCell className="text-right">
                        <span className={wine.inventory?.qty <= wine.inventory?.minStock ? 'text-red-600 font-semibold' : ''}>
                          {wine.inventory?.qty || 0}
                        </span>
                        {wine.inventory?.qty <= wine.inventory?.minStock && (
                          <AlertTriangle className="h-4 w-4 inline ml-1 text-red-600" />
                        )}
                      </TableCell>
                      <TableCell>
                        <div className="flex justify-center gap-2">
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => handleEdit(wine)}
                          >
                            <Edit className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => setDeleteConfirm(wine)}
                            className="text-red-600 hover:text-red-700 hover:bg-red-50"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              {filteredWines.length === 0 && (
                <div className="text-center py-12 text-muted-foreground">
                  Nenhum vinho encontrado.
                </div>
              )}
            </CardContent>
          </Card>
        </main>

        <Footer />
      </div>

      {/* Wine Form Modal */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto" onClose={() => setIsModalOpen(false)}>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Wine className="h-5 w-5 text-[#722F37]" />
              {editingWine ? 'Editar Vinho' : 'Novo Vinho'}
            </DialogTitle>
            <DialogDescription>
              {editingWine ? 'Atualize os dados do vinho.' : 'Preencha os dados para cadastrar um novo vinho.'}
            </DialogDescription>
          </DialogHeader>

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Basic Info */}
            <div className="space-y-4">
              <h3 className="font-semibold text-[#722F37] border-b pb-2">Informações Básicas</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="name">Nome do Vinho *</Label>
                  <Input
                    id="name"
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="sku">SKU</Label>
                  <Input
                    id="sku"
                    value={formData.sku}
                    onChange={(e) => setFormData({ ...formData, sku: e.target.value })}
                  />
                </div>
                <div>
                  <Label htmlFor="type">Tipo *</Label>
                  <Select
                    id="type"
                    value={formData.type}
                    onChange={(e) => setFormData({ ...formData, type: e.target.value })}
                    required
                  >
                    {wineTypes.map(type => (
                      <option key={type} value={type}>{type}</option>
                    ))}
                  </Select>
                </div>
                <div>
                  <Label htmlFor="grapes">Uva(s) - separadas por vírgula</Label>
                  <Input
                    id="grapes"
                    value={formData.grapes}
                    onChange={(e) => setFormData({ ...formData, grapes: e.target.value })}
                    placeholder="Malbec, Cabernet Sauvignon"
                  />
                </div>
                <div>
                  <Label htmlFor="country">País *</Label>
                  <Input
                    id="country"
                    value={formData.country}
                    onChange={(e) => setFormData({ ...formData, country: e.target.value })}
                    required
                  />
                </div>
                <div>
                  <Label htmlFor="region">Região</Label>
                  <Input
                    id="region"
                    value={formData.region}
                    onChange={(e) => setFormData({ ...formData, region: e.target.value })}
                  />
                </div>
                <div>
                  <Label htmlFor="vintage">Safra</Label>
                  <Input
                    id="vintage"
                    value={formData.vintage}
                    onChange={(e) => setFormData({ ...formData, vintage: e.target.value })}
                    placeholder="2021 ou NV"
                  />
                </div>
                <div>
                  <Label htmlFor="alcohol">Teor Alcoólico</Label>
                  <Input
                    id="alcohol"
                    value={formData.alcohol}
                    onChange={(e) => setFormData({ ...formData, alcohol: e.target.value })}
                    placeholder="13.5%"
                  />
                </div>
                <div>
                  <Label htmlFor="body">Corpo</Label>
                  <Select
                    id="body"
                    value={formData.body}
                    onChange={(e) => setFormData({ ...formData, body: e.target.value })}
                  >
                    {bodyTypes.map(body => (
                      <option key={body} value={body}>{body}</option>
                    ))}
                  </Select>
                </div>
                <div>
                  <Label htmlFor="producer">Produtor</Label>
                  <Input
                    id="producer"
                    value={formData.producer}
                    onChange={(e) => setFormData({ ...formData, producer: e.target.value })}
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="image">URL da Imagem</Label>
                <Input
                  id="image"
                  value={formData.image}
                  onChange={(e) => setFormData({ ...formData, image: e.target.value })}
                  placeholder="https://..."
                />
              </div>
            </div>

            {/* Curadoria */}
            <div className="space-y-4">
              <h3 className="font-semibold text-[#722F37] border-b pb-2">Curadoria Wno Mas</h3>
              <div>
                <Label htmlFor="description">Descrição</Label>
                <Textarea
                  id="description"
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  rows={2}
                />
              </div>
              <div>
                <Label htmlFor="notaWnoMas">Nota Wno Mas</Label>
                <Input
                  id="notaWnoMas"
                  value={formData.notaWnoMas}
                  onChange={(e) => setFormData({ ...formData, notaWnoMas: e.target.value })}
                />
              </div>
              <div>
                <Label htmlFor="harmonization">Harmonização (separado por vírgula)</Label>
                <Input
                  id="harmonization"
                  value={formData.harmonization}
                  onChange={(e) => setFormData({ ...formData, harmonization: e.target.value })}
                  placeholder="Carnes grelhadas, Massas, Queijos"
                />
              </div>
              <div>
                <Label htmlFor="idealMoments">Momentos Ideais (separado por vírgula)</Label>
                <Input
                  id="idealMoments"
                  value={formData.idealMoments}
                  onChange={(e) => setFormData({ ...formData, idealMoments: e.target.value })}
                  placeholder="Churrasco, Jantar especial"
                />
              </div>
              <div>
                <Label htmlFor="history">História do Vinho</Label>
                <Textarea
                  id="history"
                  value={formData.history}
                  onChange={(e) => setFormData({ ...formData, history: e.target.value })}
                  rows={3}
                />
              </div>
            </div>

            {/* Fornecedores e Custos */}
            <div className="space-y-4">
              <h3 className="font-semibold text-[#722F37] border-b pb-2">Fornecedores e Custos</h3>
              <p className="text-sm text-muted-foreground">
                Informe o custo de aquisição para cada fornecedor (até 3). O sistema calculará o custo médio automaticamente.
              </p>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {suppliers.filter(s => s.active).slice(0, 8).map(supplier => {
                  const existingCost = formData.supplierCosts.find(sc => sc.supplierId === supplier.id);
                  return (
                    <div key={supplier.id} className="space-y-1">
                      <Label htmlFor={`cost-${supplier.id}`} className="text-xs">{supplier.name}</Label>
                      <Input
                        id={`cost-${supplier.id}`}
                        type="number"
                        step="0.01"
                        min="0"
                        value={existingCost?.cost || ''}
                        onChange={(e) => handleSupplierCostChange(supplier.id, e.target.value)}
                        placeholder="R$ 0,00"
                      />
                    </div>
                  );
                })}
              </div>

              {formData.supplierCosts.length > 0 && (
                <div className="bg-slate-50 p-4 rounded-lg">
                  <p className="text-sm font-medium">Custos calculados:</p>
                  <div className="grid grid-cols-3 gap-4 mt-2 text-sm">
                    <div>
                      <span className="text-muted-foreground">Menor:</span>{' '}
                      <span className="font-semibold text-green-600">
                        R$ {Math.min(...formData.supplierCosts.map(sc => sc.cost)).toFixed(2)}
                      </span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Médio:</span>{' '}
                      <span className="font-semibold">
                        R$ {(formData.supplierCosts.reduce((acc, sc) => acc + sc.cost, 0) / formData.supplierCosts.length).toFixed(2)}
                      </span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Maior:</span>{' '}
                      <span className="font-semibold text-red-600">
                        R$ {Math.max(...formData.supplierCosts.map(sc => sc.cost)).toFixed(2)}
                      </span>
                    </div>
                  </div>
                </div>
              )}

              <div>
                <Label htmlFor="marginPercent">Margem (%)</Label>
                <Input
                  id="marginPercent"
                  type="number"
                  min="0"
                  max="200"
                  value={formData.marginPercent}
                  onChange={(e) => setFormData({ ...formData, marginPercent: e.target.value })}
                />
              </div>
            </div>

            {/* Estoque */}
            <div className="space-y-4">
              <h3 className="font-semibold text-[#722F37] border-b pb-2">Estoque</h3>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div>
                  <Label htmlFor="qty">Quantidade</Label>
                  <Input
                    id="qty"
                    type="number"
                    min="0"
                    value={formData.inventory.qty}
                    onChange={(e) => setFormData({
                      ...formData,
                      inventory: { ...formData.inventory, qty: e.target.value }
                    })}
                  />
                </div>
                <div>
                  <Label htmlFor="minStock">Estoque Mínimo</Label>
                  <Input
                    id="minStock"
                    type="number"
                    min="0"
                    value={formData.inventory.minStock}
                    onChange={(e) => setFormData({
                      ...formData,
                      inventory: { ...formData.inventory, minStock: e.target.value }
                    })}
                  />
                </div>
                <div>
                  <Label htmlFor="location">Localização</Label>
                  <Input
                    id="location"
                    value={formData.inventory.location}
                    onChange={(e) => setFormData({
                      ...formData,
                      inventory: { ...formData.inventory, location: e.target.value }
                    })}
                    placeholder="H-01"
                  />
                </div>
                <div>
                  <Label htmlFor="lot">Lote</Label>
                  <Input
                    id="lot"
                    value={formData.inventory.lot}
                    onChange={(e) => setFormData({
                      ...formData,
                      inventory: { ...formData.inventory, lot: e.target.value }
                    })}
                    placeholder="LOT-2024-001"
                  />
                </div>
              </div>
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>
                Cancelar
              </Button>
              <Button type="submit" className="bg-[#722F37] hover:bg-[#5a252c]">
                <Save className="h-4 w-4 mr-2" />
                {editingWine ? 'Atualizar' : 'Cadastrar'}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={!!deleteConfirm} onOpenChange={() => setDeleteConfirm(null)}>
        <DialogContent onClose={() => setDeleteConfirm(null)}>
          <DialogHeader>
            <DialogTitle className="text-red-600">Confirmar Exclusão</DialogTitle>
            <DialogDescription>
              Tem certeza que deseja remover o vinho "{deleteConfirm?.name}"? Esta ação não pode ser desfeita.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteConfirm(null)}>
              Cancelar
            </Button>
            <Button
              variant="destructive"
              onClick={() => handleDelete(deleteConfirm)}
              className="bg-red-600 hover:bg-red-700"
            >
              <Trash2 className="h-4 w-4 mr-2" />
              Excluir
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
};

export default WinesAdminPage;
