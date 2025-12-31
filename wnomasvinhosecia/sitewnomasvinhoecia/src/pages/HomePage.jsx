
import React, { useState, useMemo } from 'react';
import { Helmet } from 'react-helmet';
import { motion } from 'framer-motion';
import Header from '@/components/Header';
import Hero from '@/components/Hero';
import CurationBlock from '@/components/CurationBlock';
import NavigationBlock from '@/components/NavigationBlock';
import Filters from '@/components/Filters';
import ProductGrid from '@/components/ProductGrid';
import InstitutionalBlock from '@/components/InstitutionalBlock';
import Footer from '@/components/Footer';
import { wines } from '@/data/wines';

const HomePage = () => {
  const [filters, setFilters] = useState({
    type: 'all',
    grape: 'all',
    country: 'all',
    priceRange: [0, 1000],
    body: 'all',
    alcohol: 'all',
    productionMethod: 'all'
  });

  const filteredWines = useMemo(() => {
    return wines.filter(wine => {
      if (filters.type !== 'all' && wine.type !== filters.type) return false;
      if (filters.grape !== 'all' && !wine.grapes.includes(filters.grape)) return false;
      if (filters.country !== 'all' && wine.country !== filters.country) return false;
      if (wine.price < filters.priceRange[0] || wine.price > filters.priceRange[1]) return false;
      if (filters.body !== 'all' && wine.body !== filters.body) return false;
      if (filters.alcohol !== 'all') {
        const alcoholLevel = parseFloat(wine.alcohol);
        if (filters.alcohol === 'low' && alcoholLevel >= 12.5) return false;
        if (filters.alcohol === 'medium' && (alcoholLevel < 12.5 || alcoholLevel >= 14)) return false;
        if (filters.alcohol === 'high' && alcoholLevel < 14) return false;
      }
      if (filters.productionMethod !== 'all' && wine.productionMethod !== filters.productionMethod) return false;
      return true;
    });
  }, [filters]);

  return (
    <>
      <Helmet>
        <title>Wno Mas - Vinho & Companhia</title>
        <meta name="description" content="Vinhos escolhidos com critério. Para beber bem, sem complicação. Curadoria humana de vinhos da Argentina, Chile, Espanha e França." />
      </Helmet>
      
      <div className="min-h-screen bg-[#FAF8F5]">
        <Header />
        <Hero />
        <CurationBlock />
        <NavigationBlock setFilters={setFilters} />
        <main id="vinhos" className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="text-center mb-12"
          >
            <h2 className="text-2xl sm:text-3xl font-semibold text-[#1A1A1A] mb-4">
              Nossa Seleção
            </h2>
            <p className="text-[#6B6B6B]">
              Vinhos escolhidos com critério. Explore por tipo, região ou preço.
            </p>
          </motion.div>
          <Filters filters={filters} setFilters={setFilters} />
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.5 }}
            className="mt-8"
          >
            <ProductGrid wines={filteredWines} />
          </motion.div>
        </main>
        <InstitutionalBlock />
        <Footer />
      </div>
    </>
  );
};

export default HomePage;
