
// Pricing Formula Configuration
const COSTS = {
  PACKAGING: 15.00,
  SHIPPING: 5.00,
  OPERATIONAL_PERCENT: 0.10
};

// Helper to calculate pricing structure
const calculatePricing = (baseCost, targetMarginPercent) => {
  const operationalCost = baseCost * COSTS.OPERATIONAL_PERCENT;
  const totalRealCost = baseCost + COSTS.PACKAGING + COSTS.SHIPPING + operationalCost;
  // Sale Price = Total Cost / (1 - Margin%) -> This ensures the margin is on the sale price
  // Or simpler markup: Total Cost * (1 + Markup%)
  // Using Markup method for clearer margin on cost
  const finalPrice = totalRealCost * (1 + (targetMarginPercent / 100));
  
  return {
    baseCost,
    packaging: COSTS.PACKAGING,
    shipping: COSTS.SHIPPING,
    operational: operationalCost,
    totalRealCost,
    marginPercent: targetMarginPercent,
    finalPrice: Math.ceil(finalPrice)
  };
};

const winesList = [
  // RED WINES (12)
  {
    id: 'alamos-malbec',
    name: 'Catena Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2021',
    baseCost: 45.00,
    margin: 40,
    image: '/wines/download.jpg',
    alcohol: '13.5%',
    body: 'Médio',
    acidity: 'Média',
    tannins: 'Médio',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '3-5 anos',
    description: 'Um clássico argentino. Frutas negras, toque de especiarias e violetas. Equilibrado e fácil de beber.',
    kits: ['Kit 1 - Começar Bem'],
    inventory: { qty: 120, minStock: 24, location: 'H-01' },
    suppliers: [
      { name: 'Catena Zapata', cost: 45.00, active: true },
      { name: 'Mistral', cost: 48.00, active: true }
    ],
    salesStats: { totalSold: 450, profitability: 'High' }
  },
  {
    id: 'dv-catena-malbec',
    name: 'D.V. Catena Malbec-Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2019',
    baseCost: 180.00,
    margin: 45,
    image: '/wines/shopping (3).webp',
    alcohol: '14%',
    body: 'Encorpado',
    acidity: 'Média',
    tannins: 'Alto',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '10 anos',
    description: 'Blend de dois vinhedos premium. Complexo, com notas de ameixa, tabaco e baunilha.',
    kits: [],
    inventory: { qty: 45, minStock: 12, location: 'H-02' },
    suppliers: [
      { name: 'Catena Zapata', cost: 180.00, active: true }
    ],
    salesStats: { totalSold: 120, profitability: 'Medium' }
  },
  {
    id: 'dv-catena-cab-malbec',
    name: 'D.V. Catena Cabernet-Malbec',
    type: 'Tinto',
    grapes: ['Cabernet Sauvignon', 'Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2019',
    baseCost: 190.00,
    margin: 50,
    image: '/wines/shopping.webp',
    alcohol: '14%',
    body: 'Encorpado',
    acidity: 'Alta',
    tannins: 'Alto',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '15 anos',
    description: 'A elegância do Cabernet com a fruta do Malbec. Estruturado e longo.',
    kits: ['Kit 2 - Jantar em Casa'],
    inventory: { qty: 30, minStock: 12, location: 'H-03' },
    suppliers: [
      { name: 'Catena Zapata', cost: 190.00, active: true },
      { name: 'Grand Cru', cost: 205.00, active: true }
    ],
    salesStats: { totalSold: 85, profitability: 'High' }
  },
  {
    id: 'angelica-zapata-cab',
    name: 'Angelica Zapata Cabernet Franc',
    type: 'Tinto',
    grapes: ['Cabernet Franc'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2018',
    baseCost: 220.00,
    margin: 45,
    image: '/wines/shopping (4).webp',
    alcohol: '13.5%',
    body: 'Encorpado',
    acidity: 'Alta',
    tannins: 'Médio',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '10 anos',
    description: 'Fresco e floral, com a assinatura de Alejandro Vigil. Um Malbec de caráter único.',
    kits: ['Kit 3 - Malbecs da Argentina'],
    inventory: { qty: 28, minStock: 6, location: 'H-04' },
    suppliers: [
      { name: 'Mistral', cost: 220.00, active: true }
    ],
    salesStats: { totalSold: 90, profitability: 'Medium' }
  },
  {
    id: 'catena-alta-malbec',
    name: 'Catena Alta Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2020',
    baseCost: 95.00,
    margin: 40,
    image: '/wines/download (1).jpg',
    alcohol: '14%',
    body: 'Encorpado',
    acidity: 'Média',
    tannins: 'Macios',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '5 anos',
    description: 'Um ícone de consistência. Fruta madura, especiarias doces e final agradável.',
    kits: ['Kit 3 - Malbecs da Argentina'],
    inventory: { qty: 60, minStock: 12, location: 'H-05' },
    suppliers: [
      { name: 'Decanter', cost: 95.00, active: true }
    ],
    salesStats: { totalSold: 200, profitability: 'Medium' }
  },
  {
    id: 'angelica-zapata-malbec',
    name: 'Angelica Zapata Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2020',
    baseCost: 110.00,
    margin: 40,
    image: '/wines/shopping (5).webp',
    alcohol: '13.8%',
    body: 'Médio',
    acidity: 'Média',
    tannins: 'Finos',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '5-7 anos',
    description: 'Elegante e sofisticado. Notas de frutas vermelhas e carvalho bem integrado.',
    kits: ['Kit 2 - Jantar em Casa'],
    inventory: { qty: 40, minStock: 6, location: 'H-06' },
    suppliers: [
      { name: 'Catena Zapata', cost: 110.00, active: true }
    ],
    salesStats: { totalSold: 150, profitability: 'High' }
  },
  {
    id: 'saint-emilion',
    name: 'Saint-Émilion Private Réserve',
    type: 'Tinto',
    grapes: ['Merlot', 'Cabernet Franc'],
    country: 'França',
    region: 'Bordeaux',
    vintage: '2012',
    baseCost: 200.00,
    margin: 50,
    image: '/wines/shopping (6).webp',
    alcohol: '14.2%',
    body: 'Encorpado',
    acidity: 'Média',
    tannins: 'Alto',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '10 anos',
    description: 'Aristocrático. Aromas intensos, madeira presente e grande estrutura.',
    kits: [],
    inventory: { qty: 35, minStock: 6, location: 'H-07' },
    suppliers: [
      { name: 'Zahil', cost: 200.00, active: true }
    ],
    salesStats: { totalSold: 95, profitability: 'High' }
  },
  {
    id: 'angelica-zapata-alta',
    name: 'Angelica Zapata Malbec Alta',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2018',
    baseCost: 380.00,
    margin: 55,
    image: '/wines/shopping (8).webp',
    alcohol: '14.5%',
    body: 'Muito Encorpado',
    acidity: 'Média',
    tannins: 'Aveludados',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '15 anos',
    description: 'Opulento e concentrado. A assinatura de Paul Hobbs em um vinho memorável.',
    kits: ['Kit 3 - Malbecs da Argentina'],
    inventory: { qty: 15, minStock: 3, location: 'H-08' },
    suppliers: [
      { name: 'Grand Cru', cost: 380.00, active: true }
    ],
    salesStats: { totalSold: 40, profitability: 'Very High' }
  },
  {
    id: 'achaval-ferrer-quimera',
    name: 'Achaval Ferrer Quimera',
    type: 'Tinto',
    grapes: ['Malbec', 'Cabernet Franc', 'Merlot', 'Cabernet Sauvignon'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2018',
    baseCost: 350.00,
    margin: 60,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/06d50eeb48179fb63c7ff5435b838ad0.png',
    alcohol: '14.5%',
    body: 'Encorpado',
    acidity: 'Alta',
    tannins: 'Finos',
    idealTemperature: '16-18°C',
    productionMethod: 'Biodinâmico',
    agingPotential: '15+ anos',
    description: 'A busca pela perfeição. Um blend que muda a cada ano para expressar o melhor do terroir.',
    kits: ['Kit 4 - Noite Especial'],
    inventory: { qty: 10, minStock: 2, location: 'H-09' },
    suppliers: [
      { name: 'Inovini', cost: 350.00, active: true }
    ],
    salesStats: { totalSold: 30, profitability: 'Very High' }
  },
  {
    id: 'gran-enemigo-blend',
    name: 'Gran Enemigo Blend',
    type: 'Tinto',
    grapes: ['Cabernet Franc', 'Malbec', 'Petit Verdot'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2017',
    baseCost: 450.00,
    margin: 60,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/99d0c6137e6cf98e455122fc5079b0fc.png',
    alcohol: '13.9%',
    body: 'Encorpado',
    acidity: 'Alta',
    tannins: 'Finos',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '20 anos',
    description: 'Inspirado em Pomerol, mas com alma andina. Um dos grandes vinhos da América do Sul.',
    kits: ['Kit 4 - Noite Especial'],
    inventory: { qty: 8, minStock: 2, location: 'H-10' },
    suppliers: [
      { name: 'Mistral', cost: 450.00, active: true }
    ],
    salesStats: { totalSold: 25, profitability: 'Very High' }
  },
  {
    id: 'dv-catena-vineyard',
    name: 'D.V. Catena Vineyard Designated Malbec',
    type: 'Tinto',
    grapes: ['Malbec'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2021',
    baseCost: 85.00,
    margin: 40,
    image: '/wines/shopping (2).webp',
    alcohol: '13.5%',
    body: 'Médio',
    acidity: 'Média',
    tannins: 'Macios',
    idealTemperature: '15-17°C',
    productionMethod: 'Tradicional',
    agingPotential: '4 anos',
    description: 'Fruta fresca e vibrante. A expressão pura do Valle de Uco.',
    kits: [],
    inventory: { qty: 55, minStock: 12, location: 'H-11' },
    suppliers: [
      { name: 'Grand Cru', cost: 85.00, active: true }
    ],
    salesStats: { totalSold: 180, profitability: 'Low' }
  },
  {
    id: 'dv-catena-tinto-historico',
    name: 'D.V. Catena Tinto Histórico',
    type: 'Tinto',
    grapes: ['Malbec', 'Bonarda'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2020',
    baseCost: 90.00,
    margin: 40,
    image: '/wines/download (2).jpg',
    alcohol: '14%',
    body: 'Encorpado',
    acidity: 'Média',
    tannins: 'Doces',
    idealTemperature: '16-18°C',
    productionMethod: 'Tradicional',
    agingPotential: '5 anos',
    description: 'Intenso e frutado, com notas de madeira tostada e chocolate.',
    kits: [],
    inventory: { qty: 48, minStock: 6, location: 'H-12' },
    suppliers: [
      { name: 'Importadora Mendoza', cost: 90.00, active: true }
    ],
    salesStats: { totalSold: 130, profitability: 'Medium' }
  },
  // WHITE WINES (5)
  {
    id: 'alamos-chardonnay',
    name: 'Alamos Chardonnay',
    type: 'Branco',
    grapes: ['Chardonnay'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2021',
    baseCost: 45.00,
    margin: 40,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/8a5f36f7b8154fba19896430ab9eae47.png',
    alcohol: '13%',
    body: 'Médio',
    acidity: 'Média',
    tannins: 'Inexistente',
    idealTemperature: '8-10°C',
    productionMethod: 'Tradicional',
    agingPotential: '3 anos',
    description: 'Fresco e frutado, com leve toque de madeira. Perfeito para o dia a dia.',
    kits: [],
    inventory: { qty: 80, minStock: 12, location: 'V-01' },
    suppliers: [
      { name: 'Catena Zapata', cost: 45.00, active: true }
    ],
    salesStats: { totalSold: 300, profitability: 'Medium' }
  },
  {
    id: 'la-linda-chardonnay',
    name: 'La Linda Chardonnay',
    type: 'Branco',
    grapes: ['Chardonnay'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2021',
    baseCost: 55.00,
    margin: 40,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/f338d01600069020176cb5cd879a1dd8.png',
    alcohol: '13.5%',
    body: 'Leve',
    acidity: 'Alta',
    tannins: 'Inexistente',
    idealTemperature: '8-10°C',
    productionMethod: 'Tradicional',
    agingPotential: '3 anos',
    description: 'Sem madeira, foca na fruta tropical e frescor. Muito versátil.',
    kits: ['Kit 1 - Começar Bem'],
    inventory: { qty: 65, minStock: 12, location: 'V-02' },
    suppliers: [
      { name: 'Decanter', cost: 55.00, active: true }
    ],
    salesStats: { totalSold: 220, profitability: 'Medium' }
  },
  {
    id: 'dv-catena-chardonnay',
    name: 'D.V. Catena Chardonnay',
    type: 'Branco',
    grapes: ['Chardonnay'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2020',
    baseCost: 160.00,
    margin: 45,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/7833431f18b78c961c05d1c556c69c55.png',
    alcohol: '13.5%',
    body: 'Encorpado',
    acidity: 'Média',
    tannins: 'Inexistente',
    idealTemperature: '10-12°C',
    productionMethod: 'Tradicional',
    agingPotential: '8 anos',
    description: 'Rico e untuoso. Notas de frutas maduras, mel e pão tostado.',
    kits: [],
    inventory: { qty: 25, minStock: 6, location: 'V-03' },
    suppliers: [
      { name: 'Catena Zapata', cost: 160.00, active: true }
    ],
    salesStats: { totalSold: 70, profitability: 'High' }
  },
  {
    id: 'rutini-chardonnay',
    name: 'Rutini Chardonnay',
    type: 'Branco',
    grapes: ['Chardonnay'],
    country: 'Argentina',
    region: 'Mendoza',
    vintage: '2020',
    baseCost: 210.00,
    margin: 50,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/1b57bcbdf9138aaad32773163a87bbeb.png', // Reusing placeholder for visual consistency if needed, but in real scenario unique img
    alcohol: '13.8%',
    body: 'Encorpado',
    acidity: 'Média',
    tannins: 'Inexistente',
    idealTemperature: '10-12°C',
    productionMethod: 'Tradicional',
    agingPotential: '8 anos',
    description: 'Um branco de classe mundial. Elegante, com madeira perfeitamente integrada.',
    kits: ['Kit 2 - Jantar em Casa'],
    inventory: { qty: 20, minStock: 4, location: 'V-04' },
    suppliers: [
      { name: 'Zahil', cost: 210.00, active: true }
    ],
    salesStats: { totalSold: 55, profitability: 'High' }
  },
  {
    id: 'zuccardi-q-chardonnay',
    name: 'Zuccardi Q Chardonnay',
    type: 'Branco',
    grapes: ['Chardonnay'],
    country: 'Argentina',
    region: 'Valle de Uco',
    vintage: '2020',
    baseCost: 130.00,
    margin: 45,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/6ae86993ac633acd0ebcb8eac98b1c7c.png',
    alcohol: '13.5%',
    body: 'Médio',
    acidity: 'Alta',
    tannins: 'Inexistente',
    idealTemperature: '9-11°C',
    productionMethod: 'Tradicional',
    agingPotential: '6 anos',
    description: 'Mineral e tenso. Proveniente de vinhedos de altitude.',
    kits: [],
    inventory: { qty: 35, minStock: 6, location: 'V-05' },
    suppliers: [
      { name: 'Grand Cru', cost: 130.00, active: true }
    ],
    salesStats: { totalSold: 80, profitability: 'Medium' }
  },
  // SPARKLING WINES (3)
  {
    id: 'chandon-extra-brut',
    name: 'Chandon Extra Brut',
    type: 'Espumante',
    grapes: ['Chardonnay', 'Pinot Noir'],
    country: 'Brasil',
    region: 'Serra Gaúcha',
    vintage: 'NV',
    baseCost: 65.00,
    margin: 35,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/9892452f647a702a9c3390106da40e82.png',
    alcohol: '11.8%',
    body: 'Leve',
    acidity: 'Alta',
    tannins: 'Inexistente',
    idealTemperature: '6-8°C',
    productionMethod: 'Charmat',
    agingPotential: '2 anos',
    description: 'O espumante mais amado do Brasil. Fresco, cítrico e equilibrado.',
    kits: ['Kit 1 - Começar Bem', 'Kit 4 - Noite Especial'],
    inventory: { qty: 150, minStock: 24, location: 'E-01' },
    suppliers: [
      { name: 'LVMH', cost: 65.00, active: true }
    ],
    salesStats: { totalSold: 600, profitability: 'Medium' }
  },
  {
    id: 'salentein-brut-rose',
    name: 'Salentein Brut Rosé',
    type: 'Espumante',
    grapes: ['Pinot Noir'],
    country: 'Argentina',
    region: 'Valle de Uco',
    vintage: 'NV',
    baseCost: 95.00,
    margin: 40,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/520722075d72f803f01890ccfd7724ab.png',
    alcohol: '12.5%',
    body: 'Médio',
    acidity: 'Alta',
    tannins: 'Inexistente',
    idealTemperature: '6-8°C',
    productionMethod: 'Charmat Lungo',
    agingPotential: '3 anos',
    description: 'Cor salmão delicada. Aromas de frutas vermelhas e pão tostado.',
    kits: [],
    inventory: { qty: 40, minStock: 6, location: 'E-02' },
    suppliers: [
      { name: 'Zahil', cost: 95.00, active: true }
    ],
    salesStats: { totalSold: 110, profitability: 'Medium' }
  },
  {
    id: 'freixenet-extra-brut',
    name: 'Freixenet Cordon Negro Extra Brut',
    type: 'Espumante',
    grapes: ['Macabeo', 'Xarel-lo', 'Parellada'],
    country: 'Espanha',
    region: 'Cava',
    vintage: 'NV',
    baseCost: 80.00,
    margin: 35,
    image: 'https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/592b9e07fb771bc9564bcc1ff0ea5a99.png',
    alcohol: '11.5%',
    body: 'Leve',
    acidity: 'Alta',
    tannins: 'Inexistente',
    idealTemperature: '6-8°C',
    productionMethod: 'Método Tradicional',
    agingPotential: '3 anos',
    description: 'Um Cava icônico. Bolhas finas, maçã verde e cítricos.',
    kits: [],
    inventory: { qty: 90, minStock: 12, location: 'E-03' },
    suppliers: [
      { name: 'Henkell Freixenet', cost: 80.00, active: true }
    ],
    salesStats: { totalSold: 350, profitability: 'Medium' }
  }
];

// Process wines to include calculated pricing
export const wines = winesList.map(wine => {
  const pricing = calculatePricing(wine.baseCost, wine.margin);
  return {
    ...wine,
    price: pricing.finalPrice, // For frontend display
    financials: pricing, // Detailed financials for dashboard
    // Default fallback fields for frontend compatibility if missing
    pairing: ['Queijos', 'Carnes', 'Massas'],
    sommelierTip: 'Servir na temperatura correta.',
    producerStory: 'Produtor renomado com tradição familiar.',
    vineyardInfo: 'Vinhedos selecionados.',
    winemaking: 'Processo rigoroso de seleção e fermentação.'
  };
});
