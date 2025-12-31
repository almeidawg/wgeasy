import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';

// ==========================================
// CONFIGURAÇÕES DE CUSTOS OPERACIONAIS
// ==========================================
const DEFAULT_OPERATIONAL_COSTS = {
  // Custos por unidade (embalagem)
  packaging: {
    sacola: 3.50,
    caixa: 8.00,
    protecaoInterna: 2.50,
    etiquetas: 1.00
  },
  // Logística por unidade
  logistics: {
    freteMedio: 12.00,
    transporteInterno: 3.00,
    seguro: 2.00
  },
  // Custos fixos mensais (rateados)
  fixed: {
    plataformaSite: 150.00,
    taxasPagamento: 0.05, // 5% do valor
    marketing: 500.00,
    armazenagem: 300.00,
    maoDeObra: 2000.00
  },
  // Configuração de rateio
  rateio: {
    estimativaVendasMensais: 100 // garrafas/mês para rateio
  },
  // Margens
  margins: {
    padrao: 60,
    promocional: 40,
    kits: 50
  }
};

// ==========================================
// DADOS INICIAIS DE FORNECEDORES
// ==========================================
const DEFAULT_SUPPLIERS = [
  { id: 'catena-zapata', name: 'Catena Zapata', cnpj: '', phone: '', email: '', active: true },
  { id: 'mistral', name: 'Mistral', cnpj: '', phone: '', email: '', active: true },
  { id: 'grand-cru', name: 'Grand Cru', cnpj: '', phone: '', email: '', active: true },
  { id: 'decanter', name: 'Decanter', cnpj: '', phone: '', email: '', active: true },
  { id: 'zahil', name: 'Zahil', cnpj: '', phone: '', email: '', active: true },
  { id: 'inovini', name: 'Inovini', cnpj: '', phone: '', email: '', active: true },
  { id: 'lvmh', name: 'LVMH', cnpj: '', phone: '', email: '', active: true },
  { id: 'henkell-freixenet', name: 'Henkell Freixenet', cnpj: '', phone: '', email: '', active: true }
];

// ==========================================
// DADOS INICIAIS DE VINHOS (expandido)
// ==========================================
const DEFAULT_WINES = [
  {
    id: 'alamos-malbec',
    sku: 'WNO-TIN-001',
    name: 'Alamos Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2021',
    alcohol: '13.5%',
    body: 'Médio',
    volume: '750ml',
    producer: 'Bodega Catena Zapata',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/1b57bcbdf9138aaad32773163a87bbeb.png',
    // Curadoria
    notaWnoMas: 'Um clássico argentino acessível e delicioso.',
    harmonization: ['Carnes grelhadas', 'Massas com molho vermelho', 'Queijos'],
    idealMoments: ['Churrasco', 'Jantar casual', 'Happy hour'],
    history: 'Alamos representa a linha de entrada da renomada Bodega Catena Zapata, trazendo a qualidade premium a um preço acessível.',
    description: 'Frutas negras, toque de especiarias e violetas. Equilibrado e fácil de beber.',
    // Custos de fornecedores (até 3)
    supplierCosts: [
      { supplierId: 'catena-zapata', cost: 45.00, active: true },
      { supplierId: 'mistral', cost: 48.00, active: true }
    ],
    // Margem específica do produto
    marginPercent: 60,
    // Estoque
    inventory: {
      qty: 120,
      minStock: 24,
      location: 'H-01',
      entryDate: '2024-01-15',
      lot: 'LOT-2024-001'
    },
    // Kits
    kits: ['Kit 1 - Começar Bem'],
    // Stats
    salesStats: { totalSold: 450, lastSaleDate: '2024-03-10' }
  },
  {
    id: 'dv-catena-malbec',
    sku: 'WNO-TIN-002',
    name: 'D.V. Catena Malbec-Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2019',
    alcohol: '14%',
    body: 'Encorpado',
    volume: '750ml',
    producer: 'Bodega Catena Zapata',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/6ae86993ac633acd0ebcb8eac98b1c7c.png',
    notaWnoMas: 'Complexo e elegante, para paladares exigentes.',
    harmonization: ['Cordeiro', 'Carnes nobres', 'Queijos maturados'],
    idealMoments: ['Ocasiões especiais', 'Presentes', 'Harmonização'],
    history: 'D.V. Catena homenageia Domingo Vicente Catena, o fundador da tradição vinícola da família.',
    description: 'Blend de dois vinhedos premium. Complexo, com notas de ameixa, tabaco e baunilha.',
    supplierCosts: [
      { supplierId: 'catena-zapata', cost: 180.00, active: true }
    ],
    marginPercent: 60,
    inventory: { qty: 45, minStock: 12, location: 'H-02', entryDate: '2024-02-01', lot: 'LOT-2024-002' },
    kits: [],
    salesStats: { totalSold: 120, lastSaleDate: '2024-03-08' }
  },
  {
    id: 'dv-catena-cab-malbec',
    sku: 'WNO-TIN-003',
    name: 'D.V. Catena Cabernet-Malbec',
    type: 'Tinto',
    grapes: ['Cabernet Sauvignon', 'Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2019',
    alcohol: '14%',
    body: 'Encorpado',
    volume: '750ml',
    producer: 'Bodega Catena Zapata',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/9892452f647a702a9c3390106da40e82.png',
    notaWnoMas: 'A elegância do Cabernet com a fruta do Malbec.',
    harmonization: ['Picanha', 'Costela', 'Risoto de funghi'],
    idealMoments: ['Jantar especial', 'Celebrações'],
    history: 'Um blend que representa o melhor dos dois mundos, unindo variedades francesas com o terroir argentino.',
    description: 'A elegância do Cabernet com a fruta do Malbec. Estruturado e longo.',
    supplierCosts: [
      { supplierId: 'catena-zapata', cost: 190.00, active: true },
      { supplierId: 'grand-cru', cost: 205.00, active: true }
    ],
    marginPercent: 60,
    inventory: { qty: 30, minStock: 12, location: 'H-03', entryDate: '2024-01-20', lot: 'LOT-2024-003' },
    kits: ['Kit 2 - Jantar em Casa'],
    salesStats: { totalSold: 85, lastSaleDate: '2024-03-05' }
  },
  {
    id: 'el-enemigo-malbec',
    sku: 'WNO-TIN-004',
    name: 'El Enemigo Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2018',
    alcohol: '13.5%',
    body: 'Encorpado',
    volume: '750ml',
    producer: 'Aleanna - Alejandro Vigil',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/520722075d72f803f01890ccfd7724ab.png',
    notaWnoMas: 'Assinatura de Alejandro Vigil, um dos melhores enólogos do mundo.',
    harmonization: ['Carnes vermelhas', 'Embutidos', 'Queijos azuis'],
    idealMoments: ['Degustação', 'Presente especial'],
    history: 'El Enemigo é o projeto pessoal de Alejandro Vigil, considerado o melhor enólogo da Argentina.',
    description: 'Fresco e floral, com a assinatura de Alejandro Vigil. Um Malbec de caráter único.',
    supplierCosts: [
      { supplierId: 'mistral', cost: 220.00, active: true }
    ],
    marginPercent: 60,
    inventory: { qty: 28, minStock: 6, location: 'H-04', entryDate: '2024-01-10', lot: 'LOT-2024-004' },
    kits: ['Kit 3 - Malbecs da Argentina'],
    salesStats: { totalSold: 90, lastSaleDate: '2024-03-01' }
  },
  {
    id: 'luigi-bosca-malbec',
    sku: 'WNO-TIN-005',
    name: 'Luigi Bosca Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Luján de Cuyo',
    vintage: '2020',
    alcohol: '14%',
    body: 'Encorpado',
    volume: '750ml',
    producer: 'Bodega Luigi Bosca',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/592b9e07fb771bc9564bcc1ff0ea5a99.png',
    notaWnoMas: 'Consistência e qualidade garantidas.',
    harmonization: ['Carnes assadas', 'Massas', 'Pizza'],
    idealMoments: ['Dia a dia', 'Reuniões familiares'],
    history: 'Luigi Bosca é uma das vinícolas mais tradicionais da Argentina, com mais de 100 anos de história.',
    description: 'Um ícone de consistência. Fruta madura, especiarias doces e final agradável.',
    supplierCosts: [
      { supplierId: 'decanter', cost: 95.00, active: true }
    ],
    marginPercent: 60,
    inventory: { qty: 60, minStock: 12, location: 'H-05', entryDate: '2024-02-10', lot: 'LOT-2024-005' },
    kits: ['Kit 3 - Malbecs da Argentina'],
    salesStats: { totalSold: 200, lastSaleDate: '2024-03-12' }
  },
  {
    id: 'chandon-extra-brut',
    sku: 'WNO-ESP-001',
    name: 'Chandon Extra Brut',
    type: 'Espumante',
    grapes: ['Chardonnay', 'Pinot Noir'],
    country: 'Brasil',
    region: 'Serra Gaúcha',
    vintage: 'NV',
    alcohol: '11.8%',
    body: 'Leve',
    volume: '750ml',
    producer: 'Chandon Brasil',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/9892452f647a702a9c3390106da40e82.png',
    notaWnoMas: 'O espumante brasileiro mais amado.',
    harmonization: ['Frutos do mar', 'Entradas', 'Celebrações'],
    idealMoments: ['Brinde', 'Celebração', 'Aperitivo'],
    history: 'Chandon Brasil faz parte do grupo LVMH e produz espumantes de alta qualidade desde 1973.',
    description: 'O espumante mais amado do Brasil. Fresco, cítrico e equilibrado.',
    supplierCosts: [
      { supplierId: 'lvmh', cost: 65.00, active: true }
    ],
    marginPercent: 50,
    inventory: { qty: 150, minStock: 24, location: 'E-01', entryDate: '2024-01-05', lot: 'LOT-2024-E01' },
    kits: ['Kit 1 - Começar Bem', 'Kit 4 - Noite Especial'],
    salesStats: { totalSold: 600, lastSaleDate: '2024-03-15' }
  },
  {
    id: 'alamos-chardonnay',
    sku: 'WNO-BRA-001',
    name: 'Alamos Chardonnay',
    type: 'Branco',
    grapes: ['Chardonnay'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2021',
    alcohol: '13%',
    body: 'Médio',
    volume: '750ml',
    producer: 'Bodega Catena Zapata',
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/8a5f36f7b8154fba19896430ab9eae47.png',
    notaWnoMas: 'Branco versátil e refrescante.',
    harmonization: ['Peixes', 'Saladas', 'Frango'],
    idealMoments: ['Almoço', 'Verão', 'Happy hour'],
    history: 'A linha Alamos oferece brancos frescos que expressam a altitude de Mendoza.',
    description: 'Fresco e frutado, com leve toque de madeira. Perfeito para o dia a dia.',
    supplierCosts: [
      { supplierId: 'catena-zapata', cost: 45.00, active: true }
    ],
    marginPercent: 60,
    inventory: { qty: 80, minStock: 12, location: 'V-01', entryDate: '2024-02-20', lot: 'LOT-2024-V01' },
    kits: [],
    salesStats: { totalSold: 300, lastSaleDate: '2024-03-10' }
  }
];

// ==========================================
// FUNÇÕES DE CÁLCULO DE PREÇOS
// ==========================================

// Calcula custos agregados de fornecedores
const calculateSupplierCosts = (supplierCosts) => {
  const activeCosts = supplierCosts.filter(s => s.active && s.cost > 0);
  if (activeCosts.length === 0) return { average: 0, min: 0, max: 0, count: 0 };

  const costs = activeCosts.map(s => s.cost);
  return {
    average: costs.reduce((a, b) => a + b, 0) / costs.length,
    min: Math.min(...costs),
    max: Math.max(...costs),
    count: costs.length
  };
};

// Calcula custo total de embalagem por unidade
const calculatePackagingCost = (costs) => {
  return costs.packaging.sacola + costs.packaging.caixa +
         costs.packaging.protecaoInterna + costs.packaging.etiquetas;
};

// Calcula custo total de logística por unidade
const calculateLogisticsCost = (costs) => {
  return costs.logistics.freteMedio + costs.logistics.transporteInterno + costs.logistics.seguro;
};

// Calcula custos fixos rateados por unidade
const calculateFixedCostPerUnit = (costs) => {
  const totalFixed = costs.fixed.plataformaSite + costs.fixed.marketing +
                     costs.fixed.armazenagem + costs.fixed.maoDeObra;
  return totalFixed / costs.rateio.estimativaVendasMensais;
};

// Calcula preço final do vinho
const calculateWinePrice = (wine, operationalCosts) => {
  const supplierInfo = calculateSupplierCosts(wine.supplierCosts);
  const baseCost = supplierInfo.average || 0;

  const packagingCost = calculatePackagingCost(operationalCosts);
  const logisticsCost = calculateLogisticsCost(operationalCosts);
  const fixedCostPerUnit = calculateFixedCostPerUnit(operationalCosts);

  const totalRealCost = baseCost + packagingCost + logisticsCost + fixedCostPerUnit;
  const paymentTax = totalRealCost * operationalCosts.fixed.taxasPagamento;
  const totalCostWithTax = totalRealCost + paymentTax;

  const marginMultiplier = 1 + (wine.marginPercent / 100);
  const finalPrice = Math.ceil(totalCostWithTax * marginMultiplier);

  return {
    supplierInfo,
    baseCost,
    packagingCost,
    logisticsCost,
    fixedCostPerUnit,
    paymentTax,
    totalRealCost: totalCostWithTax,
    marginPercent: wine.marginPercent,
    finalPrice,
    profitPerUnit: finalPrice - totalCostWithTax
  };
};

// ==========================================
// CONTEXT
// ==========================================
const WineContext = createContext();

export const useWine = () => {
  const context = useContext(WineContext);
  if (!context) {
    throw new Error('useWine must be used within a WineProvider');
  }
  return context;
};

export const WineProvider = ({ children }) => {
  // Estado
  const [wines, setWines] = useState([]);
  const [suppliers, setSuppliers] = useState([]);
  const [operationalCosts, setOperationalCosts] = useState(DEFAULT_OPERATIONAL_COSTS);
  const [isLoaded, setIsLoaded] = useState(false);

  // Carregar dados do Local Storage
  useEffect(() => {
    const loadFromStorage = () => {
      try {
        const storedWines = localStorage.getItem('wnoMas_wines');
        const storedSuppliers = localStorage.getItem('wnoMas_suppliers');
        const storedCosts = localStorage.getItem('wnoMas_operationalCosts');

        setWines(storedWines ? JSON.parse(storedWines) : DEFAULT_WINES);
        setSuppliers(storedSuppliers ? JSON.parse(storedSuppliers) : DEFAULT_SUPPLIERS);
        setOperationalCosts(storedCosts ? JSON.parse(storedCosts) : DEFAULT_OPERATIONAL_COSTS);
        setIsLoaded(true);
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
        setWines(DEFAULT_WINES);
        setSuppliers(DEFAULT_SUPPLIERS);
        setOperationalCosts(DEFAULT_OPERATIONAL_COSTS);
        setIsLoaded(true);
      }
    };

    loadFromStorage();
  }, []);

  // Salvar no Local Storage quando mudar
  useEffect(() => {
    if (isLoaded) {
      localStorage.setItem('wnoMas_wines', JSON.stringify(wines));
    }
  }, [wines, isLoaded]);

  useEffect(() => {
    if (isLoaded) {
      localStorage.setItem('wnoMas_suppliers', JSON.stringify(suppliers));
    }
  }, [suppliers, isLoaded]);

  useEffect(() => {
    if (isLoaded) {
      localStorage.setItem('wnoMas_operationalCosts', JSON.stringify(operationalCosts));
    }
  }, [operationalCosts, isLoaded]);

  // ==========================================
  // CRUD DE VINHOS
  // ==========================================
  const addWine = useCallback((wine) => {
    const newWine = {
      ...wine,
      id: wine.id || `wine-${Date.now()}`,
      sku: wine.sku || `WNO-${Date.now()}`,
      inventory: wine.inventory || { qty: 0, minStock: 6, location: '', entryDate: new Date().toISOString().split('T')[0], lot: '' },
      supplierCosts: wine.supplierCosts || [],
      salesStats: wine.salesStats || { totalSold: 0, lastSaleDate: null }
    };
    setWines(prev => [...prev, newWine]);
    return newWine;
  }, []);

  const updateWine = useCallback((id, updates) => {
    setWines(prev => prev.map(wine =>
      wine.id === id ? { ...wine, ...updates } : wine
    ));
  }, []);

  const deleteWine = useCallback((id) => {
    setWines(prev => prev.filter(wine => wine.id !== id));
  }, []);

  const getWineById = useCallback((id) => {
    return wines.find(wine => wine.id === id);
  }, [wines]);

  // ==========================================
  // CRUD DE FORNECEDORES
  // ==========================================
  const addSupplier = useCallback((supplier) => {
    const newSupplier = {
      ...supplier,
      id: supplier.id || `supplier-${Date.now()}`,
      active: true
    };
    setSuppliers(prev => [...prev, newSupplier]);
    return newSupplier;
  }, []);

  const updateSupplier = useCallback((id, updates) => {
    setSuppliers(prev => prev.map(supplier =>
      supplier.id === id ? { ...supplier, ...updates } : supplier
    ));
  }, []);

  const deleteSupplier = useCallback((id) => {
    setSuppliers(prev => prev.filter(supplier => supplier.id !== id));
  }, []);

  const getSupplierById = useCallback((id) => {
    return suppliers.find(supplier => supplier.id === id);
  }, [suppliers]);

  // ==========================================
  // CUSTOS OPERACIONAIS
  // ==========================================
  const updateOperationalCosts = useCallback((updates) => {
    setOperationalCosts(prev => ({
      ...prev,
      ...updates
    }));
  }, []);

  // ==========================================
  // VINHOS PROCESSADOS (com preços calculados)
  // ==========================================
  const processedWines = wines.map(wine => {
    const pricing = calculateWinePrice(wine, operationalCosts);
    return {
      ...wine,
      price: pricing.finalPrice,
      financials: pricing,
      // Compatibilidade com frontend existente
      baseCost: pricing.baseCost,
      margin: wine.marginPercent,
      suppliers: wine.supplierCosts.map(sc => ({
        name: suppliers.find(s => s.id === sc.supplierId)?.name || 'Desconhecido',
        cost: sc.cost,
        active: sc.active
      })),
      // Campos de fallback
      pairing: wine.harmonization || [],
      sommelierTip: wine.notaWnoMas || '',
      producerStory: wine.history || '',
      acidity: 'Média',
      tannins: 'Médio',
      idealTemperature: wine.type === 'Branco' || wine.type === 'Espumante' ? '6-10°C' : '16-18°C',
      productionMethod: 'Tradicional',
      agingPotential: '5 anos'
    };
  });

  // ==========================================
  // INDICADORES GERENCIAIS
  // ==========================================
  const dashboardStats = {
    // Estoque
    totalStock: wines.reduce((acc, w) => acc + (w.inventory?.qty || 0), 0),
    totalStockValue: processedWines.reduce((acc, w) => acc + ((w.inventory?.qty || 0) * (w.financials?.baseCost || 0)), 0),
    lowStockWines: wines.filter(w => w.inventory && w.inventory.qty <= w.inventory.minStock),

    // Financeiro
    averageMargin: wines.length > 0
      ? wines.reduce((acc, w) => acc + (w.marginPercent || 0), 0) / wines.length
      : 0,
    totalPotentialRevenue: processedWines.reduce((acc, w) => acc + ((w.inventory?.qty || 0) * (w.price || 0)), 0),
    totalPotentialProfit: processedWines.reduce((acc, w) => acc + ((w.inventory?.qty || 0) * (w.financials?.profitPerUnit || 0)), 0),

    // Fornecedores
    activeSuppliers: suppliers.filter(s => s.active).length,
    winesWithMultipleSuppliers: wines.filter(w => w.supplierCosts && w.supplierCosts.filter(s => s.active).length > 1).length,
    winesWithoutSupplier: wines.filter(w => !w.supplierCosts || w.supplierCosts.filter(s => s.active).length === 0).length,

    // Alertas
    costDiscrepancyWines: wines.filter(w => {
      if (!w.supplierCosts || w.supplierCosts.length < 2) return false;
      const costs = w.supplierCosts.filter(s => s.active).map(s => s.cost);
      if (costs.length < 2) return false;
      const maxDiff = Math.max(...costs) - Math.min(...costs);
      return maxDiff > Math.min(...costs) * 0.2; // >20% de diferença
    }),

    // Top vinhos
    topSellingWines: [...wines].sort((a, b) =>
      (b.salesStats?.totalSold || 0) - (a.salesStats?.totalSold || 0)
    ).slice(0, 5),

    mostProfitableWines: [...processedWines].sort((a, b) =>
      (b.financials?.profitPerUnit || 0) - (a.financials?.profitPerUnit || 0)
    ).slice(0, 5),

    // Por tipo
    winesByType: wines.reduce((acc, w) => {
      acc[w.type] = (acc[w.type] || 0) + 1;
      return acc;
    }, {}),

    // Custos operacionais calculados
    operationalCostPerUnit: calculatePackagingCost(operationalCosts) +
                            calculateLogisticsCost(operationalCosts) +
                            calculateFixedCostPerUnit(operationalCosts)
  };

  // ==========================================
  // RESET PARA DADOS PADRÃO
  // ==========================================
  const resetToDefaults = useCallback(() => {
    setWines(DEFAULT_WINES);
    setSuppliers(DEFAULT_SUPPLIERS);
    setOperationalCosts(DEFAULT_OPERATIONAL_COSTS);
  }, []);

  const value = {
    // Dados
    wines: processedWines,
    rawWines: wines,
    suppliers,
    operationalCosts,
    isLoaded,

    // CRUD Vinhos
    addWine,
    updateWine,
    deleteWine,
    getWineById,

    // CRUD Fornecedores
    addSupplier,
    updateSupplier,
    deleteSupplier,
    getSupplierById,

    // Custos
    updateOperationalCosts,

    // Indicadores
    dashboardStats,

    // Utils
    resetToDefaults,
    calculateWinePrice,
    calculateSupplierCosts
  };

  return (
    <WineContext.Provider value={value}>
      {children}
    </WineContext.Provider>
  );
};

export default WineContext;
