
import React from 'react';
import { motion } from 'framer-motion';
import { Filter } from 'lucide-react';
import { Slider } from '@/components/ui/slider';

const Filters = ({ filters, setFilters }) => {
  const filterOptions = {
    type: ['all', 'Tinto', 'Branco', 'Rosé', 'Espumante'],
    grape: ['all', 'Malbec', 'Cabernet Sauvignon', 'Chardonnay', 'Pinot Noir', 'Syrah', 'Merlot', 'Tempranillo'],
    country: ['all', 'Argentina', 'Chile', 'Espanha', 'França'],
    body: ['all', 'Leve', 'Médio', 'Encorpado'],
    alcohol: ['all', 'low', 'medium', 'high'],
    productionMethod: ['all', 'Orgânico', 'Biodinâmico', 'Tradicional', 'Método Champenoise']
  };

  const alcoholLabels = {
    all: 'Todos',
    low: 'Baixo (<12.5%)',
    medium: 'Médio (12.5-14%)',
    high: 'Alto (>14%)'
  };

  return (
    <motion.section
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: 0.3 }}
      className="bg-white rounded-2xl p-6 border border-[#E5E5E5]"
    >
      <div className="flex items-center gap-2 mb-6">
        <Filter className="h-5 w-5 text-[#8B4513]" />
        <h2 className="text-lg font-semibold text-[#1A1A1A]">Filtros</h2>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div>
          <label className="block text-sm font-medium text-[#1A1A1A] mb-2">Tipo</label>
          <select
            value={filters.type}
            onChange={(e) => setFilters({ ...filters, type: e.target.value })}
            className="w-full px-4 py-2 border border-[#E5E5E5] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#8B4513] text-[#1A1A1A] bg-white"
          >
            {filterOptions.type.map(option => (
              <option key={option} value={option}>
                {option === 'all' ? 'Todos' : option}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-[#1A1A1A] mb-2">Uva</label>
          <select
            value={filters.grape}
            onChange={(e) => setFilters({ ...filters, grape: e.target.value })}
            className="w-full px-4 py-2 border border-[#E5E5E5] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#8B4513] text-[#1A1A1A] bg-white"
          >
            {filterOptions.grape.map(option => (
              <option key={option} value={option}>
                {option === 'all' ? 'Todas' : option}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-[#1A1A1A] mb-2">País</label>
          <select
            value={filters.country}
            onChange={(e) => setFilters({ ...filters, country: e.target.value })}
            className="w-full px-4 py-2 border border-[#E5E5E5] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#8B4513] text-[#1A1A1A] bg-white"
          >
            {filterOptions.country.map(option => (
              <option key={option} value={option}>
                {option === 'all' ? 'Todos' : option}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-[#1A1A1A] mb-2">Corpo</label>
          <select
            value={filters.body}
            onChange={(e) => setFilters({ ...filters, body: e.target.value })}
            className="w-full px-4 py-2 border border-[#E5E5E5] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#8B4513] text-[#1A1A1A] bg-white"
          >
            {filterOptions.body.map(option => (
              <option key={option} value={option}>
                {option === 'all' ? 'Todos' : option}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-[#1A1A1A] mb-2">Teor Alcoólico</label>
          <select
            value={filters.alcohol}
            onChange={(e) => setFilters({ ...filters, alcohol: e.target.value })}
            className="w-full px-4 py-2 border border-[#E5E5E5] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#8B4513] text-[#1A1A1A] bg-white"
          >
            {filterOptions.alcohol.map(option => (
              <option key={option} value={option}>
                {alcoholLabels[option]}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-[#1A1A1A] mb-2">Método de Produção</label>
          <select
            value={filters.productionMethod}
            onChange={(e) => setFilters({ ...filters, productionMethod: e.target.value })}
            className="w-full px-4 py-2 border border-[#E5E5E5] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#8B4513] text-[#1A1A1A] bg-white"
          >
            {filterOptions.productionMethod.map(option => (
              <option key={option} value={option}>
                {option === 'all' ? 'Todos' : option}
              </option>
            ))}
          </select>
        </div>

        <div className="md:col-span-2">
          <label className="block text-sm font-medium text-[#1A1A1A] mb-4">
            Faixa de Preço: R$ {filters.priceRange[0]} - R$ {filters.priceRange[1]}
          </label>
          <Slider
            value={filters.priceRange}
            onValueChange={(value) => setFilters({ ...filters, priceRange: value })}
            min={0}
            max={1000}
            step={10}
            className="w-full"
          />
        </div>
      </div>
    </motion.section>
  );
};

export default Filters;
