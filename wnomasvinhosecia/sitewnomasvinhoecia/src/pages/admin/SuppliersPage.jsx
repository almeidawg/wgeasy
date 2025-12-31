import React, { useState } from 'react';
import { Helmet } from 'react-helmet';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { useWine } from '@/contexts/WineContext';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog";
import { useToast } from "@/components/ui/use-toast";
import {
  Plus, Edit, Trash2, Search, Truck, Package,
  DollarSign, Wine, Save, Users, CheckCircle, XCircle
} from 'lucide-react';

const SuppliersPage = () => {
  const {
    suppliers, wines, rawWines,
    addSupplier, updateSupplier, deleteSupplier
  } = useWine();
  const { toast } = useToast();

  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingSupplier, setEditingSupplier] = useState(null);
  const [deleteConfirm, setDeleteConfirm] = useState(null);

  // Form state
  const [formData, setFormData] = useState({
    name: '',
    cnpj: '',
    phone: '',
    email: '',
    address: '',
    contactPerson: '',
    notes: '',
    active: true
  });

  // Filter suppliers
  const filteredSuppliers = suppliers.filter(supplier =>
    supplier.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    supplier.cnpj?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // Get wines count per supplier
  const getWineCountForSupplier = (supplierId) => {
    return rawWines.filter(wine =>
      wine.supplierCosts?.some(sc => sc.supplierId === supplierId && sc.active)
    ).length;
  };

  // Get total cost per supplier
  const getTotalCostForSupplier = (supplierId) => {
    let total = 0;
    rawWines.forEach(wine => {
      const supplierCost = wine.supplierCosts?.find(sc => sc.supplierId === supplierId && sc.active);
      if (supplierCost) {
        total += supplierCost.cost * (wine.inventory?.qty || 0);
      }
    });
    return total;
  };

  // Open modal for new supplier
  const handleNew = () => {
    setEditingSupplier(null);
    setFormData({
      name: '',
      cnpj: '',
      phone: '',
      email: '',
      address: '',
      contactPerson: '',
      notes: '',
      active: true
    });
    setIsModalOpen(true);
  };

  // Open modal for editing
  const handleEdit = (supplier) => {
    setEditingSupplier(supplier);
    setFormData({ ...supplier });
    setIsModalOpen(true);
  };

  // Handle form submission
  const handleSubmit = (e) => {
    e.preventDefault();

    const supplierData = {
      ...formData,
      id: editingSupplier?.id || `supplier-${Date.now()}`
    };

    if (editingSupplier) {
      updateSupplier(editingSupplier.id, supplierData);
      toast({
        title: "Fornecedor atualizado",
        description: `${supplierData.name} foi atualizado com sucesso.`,
      });
    } else {
      addSupplier(supplierData);
      toast({
        title: "Fornecedor cadastrado",
        description: `${supplierData.name} foi adicionado.`,
      });
    }

    setIsModalOpen(false);
  };

  // Toggle active status
  const toggleActive = (supplier) => {
    updateSupplier(supplier.id, { active: !supplier.active });
    toast({
      title: supplier.active ? "Fornecedor desativado" : "Fornecedor ativado",
      description: `${supplier.name} foi ${supplier.active ? 'desativado' : 'ativado'}.`,
    });
  };

  // Handle delete
  const handleDelete = (supplier) => {
    const wineCount = getWineCountForSupplier(supplier.id);
    if (wineCount > 0) {
      toast({
        title: "Não é possível excluir",
        description: `${supplier.name} está vinculado a ${wineCount} vinho(s). Remova os vínculos primeiro.`,
        variant: "destructive"
      });
      setDeleteConfirm(null);
      return;
    }

    deleteSupplier(supplier.id);
    setDeleteConfirm(null);
    toast({
      title: "Fornecedor removido",
      description: `${supplier.name} foi removido.`,
      variant: "destructive"
    });
  };

  // Stats
  const activeSuppliers = suppliers.filter(s => s.active).length;
  const totalSupplierValue = suppliers.reduce((acc, s) => acc + getTotalCostForSupplier(s.id), 0);

  return (
    <>
      <Helmet>
        <title>Wno Mas - Fornecedores</title>
      </Helmet>

      <div className="min-h-screen bg-[#FAFAFA]">
        <Header />

        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header */}
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
            <div>
              <h1 className="text-3xl font-semibold text-[#1A1A1A] flex items-center gap-3">
                <Truck className="h-8 w-8 text-[#722F37]" />
                Fornecedores
              </h1>
              <p className="text-[#6B6B6B]">Gerencie seus fornecedores de vinhos</p>
            </div>
            <Button onClick={handleNew} className="bg-[#722F37] hover:bg-[#5a252c]">
              <Plus className="h-4 w-4 mr-2" />
              Novo Fornecedor
            </Button>
          </div>

          {/* Stats Cards */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Total</p>
                    <p className="text-2xl font-bold">{suppliers.length}</p>
                  </div>
                  <Users className="h-8 w-8 text-[#722F37] opacity-50" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Ativos</p>
                    <p className="text-2xl font-bold text-green-600">{activeSuppliers}</p>
                  </div>
                  <CheckCircle className="h-8 w-8 text-green-500 opacity-50" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Inativos</p>
                    <p className="text-2xl font-bold text-gray-400">{suppliers.length - activeSuppliers}</p>
                  </div>
                  <XCircle className="h-8 w-8 text-gray-400 opacity-50" />
                </div>
              </CardContent>
            </Card>
            <Card>
              <CardContent className="pt-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-muted-foreground">Valor em Estoque</p>
                    <p className="text-2xl font-bold">
                      R$ {totalSupplierValue.toLocaleString('pt-BR', { maximumFractionDigits: 0 })}
                    </p>
                  </div>
                  <DollarSign className="h-8 w-8 text-green-500 opacity-50" />
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Search */}
          <Card className="mb-6">
            <CardContent className="pt-4">
              <div className="relative">
                <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Buscar por nome ou CNPJ..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </CardContent>
          </Card>

          {/* Suppliers Table */}
          <Card>
            <CardContent className="p-0">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Fornecedor</TableHead>
                    <TableHead>CNPJ</TableHead>
                    <TableHead>Contato</TableHead>
                    <TableHead className="text-center">Vinhos</TableHead>
                    <TableHead className="text-right">Valor Estoque</TableHead>
                    <TableHead className="text-center">Status</TableHead>
                    <TableHead className="text-center">Ações</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredSuppliers.map((supplier) => {
                    const wineCount = getWineCountForSupplier(supplier.id);
                    const totalValue = getTotalCostForSupplier(supplier.id);

                    return (
                      <TableRow key={supplier.id} className={!supplier.active ? 'opacity-50' : ''}>
                        <TableCell>
                          <div>
                            <p className="font-medium">{supplier.name}</p>
                            {supplier.contactPerson && (
                              <p className="text-xs text-muted-foreground">{supplier.contactPerson}</p>
                            )}
                          </div>
                        </TableCell>
                        <TableCell className="text-sm text-muted-foreground">
                          {supplier.cnpj || '-'}
                        </TableCell>
                        <TableCell>
                          <div className="text-sm">
                            {supplier.phone && <p>{supplier.phone}</p>}
                            {supplier.email && <p className="text-muted-foreground">{supplier.email}</p>}
                            {!supplier.phone && !supplier.email && '-'}
                          </div>
                        </TableCell>
                        <TableCell className="text-center">
                          <div className="flex items-center justify-center gap-1">
                            <Wine className="h-4 w-4 text-[#722F37]" />
                            <span>{wineCount}</span>
                          </div>
                        </TableCell>
                        <TableCell className="text-right">
                          R$ {totalValue.toLocaleString('pt-BR', { maximumFractionDigits: 0 })}
                        </TableCell>
                        <TableCell className="text-center">
                          <Badge
                            variant={supplier.active ? "default" : "secondary"}
                            className={supplier.active
                              ? "bg-green-100 text-green-700 hover:bg-green-200"
                              : "bg-gray-100 text-gray-500"
                            }
                            onClick={() => toggleActive(supplier)}
                            style={{ cursor: 'pointer' }}
                          >
                            {supplier.active ? 'Ativo' : 'Inativo'}
                          </Badge>
                        </TableCell>
                        <TableCell>
                          <div className="flex justify-center gap-2">
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() => handleEdit(supplier)}
                            >
                              <Edit className="h-4 w-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() => setDeleteConfirm(supplier)}
                              className="text-red-600 hover:text-red-700 hover:bg-red-50"
                            >
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    );
                  })}
                </TableBody>
              </Table>

              {filteredSuppliers.length === 0 && (
                <div className="text-center py-12 text-muted-foreground">
                  Nenhum fornecedor encontrado.
                </div>
              )}
            </CardContent>
          </Card>
        </main>

        <Footer />
      </div>

      {/* Supplier Form Modal */}
      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="max-w-xl" onClose={() => setIsModalOpen(false)}>
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Truck className="h-5 w-5 text-[#722F37]" />
              {editingSupplier ? 'Editar Fornecedor' : 'Novo Fornecedor'}
            </DialogTitle>
            <DialogDescription>
              {editingSupplier ? 'Atualize os dados do fornecedor.' : 'Preencha os dados para cadastrar um novo fornecedor.'}
            </DialogDescription>
          </DialogHeader>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label htmlFor="name">Nome do Fornecedor *</Label>
              <Input
                id="name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label htmlFor="cnpj">CNPJ</Label>
                <Input
                  id="cnpj"
                  value={formData.cnpj}
                  onChange={(e) => setFormData({ ...formData, cnpj: e.target.value })}
                  placeholder="00.000.000/0000-00"
                />
              </div>
              <div>
                <Label htmlFor="phone">Telefone</Label>
                <Input
                  id="phone"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="(00) 00000-0000"
                />
              </div>
            </div>

            <div>
              <Label htmlFor="email">E-mail</Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                placeholder="contato@fornecedor.com"
              />
            </div>

            <div>
              <Label htmlFor="contactPerson">Pessoa de Contato</Label>
              <Input
                id="contactPerson"
                value={formData.contactPerson}
                onChange={(e) => setFormData({ ...formData, contactPerson: e.target.value })}
              />
            </div>

            <div>
              <Label htmlFor="address">Endereço</Label>
              <Input
                id="address"
                value={formData.address}
                onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              />
            </div>

            <div>
              <Label htmlFor="notes">Observações</Label>
              <Input
                id="notes"
                value={formData.notes}
                onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
              />
            </div>

            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id="active"
                checked={formData.active}
                onChange={(e) => setFormData({ ...formData, active: e.target.checked })}
                className="h-4 w-4"
              />
              <Label htmlFor="active">Fornecedor ativo</Label>
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>
                Cancelar
              </Button>
              <Button type="submit" className="bg-[#722F37] hover:bg-[#5a252c]">
                <Save className="h-4 w-4 mr-2" />
                {editingSupplier ? 'Atualizar' : 'Cadastrar'}
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
              Tem certeza que deseja remover o fornecedor "{deleteConfirm?.name}"? Esta ação não pode ser desfeita.
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

export default SuppliersPage;
