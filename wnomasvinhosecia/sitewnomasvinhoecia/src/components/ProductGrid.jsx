
import React from 'react';
import { motion } from 'framer-motion';
import ProductCard from '@/components/ProductCard';

const ProductGrid = ({ wines }) => {
  if (wines.length === 0) {
    return (
      <div className="text-center py-20">
        <p className="text-lg text-[#6B6B6B]">Nenhum vinho encontrado com os filtros selecionados.</p>
        <p className="text-sm text-[#6B6B6B] mt-2">Tente ajustar os filtros para ver mais opções.</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      {wines.map((wine, index) => (
        <motion.div
          key={wine.id}
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.4, delay: index * 0.08 }}
        >
          <ProductCard wine={wine} />
        </motion.div>
      ))}
    </div>
  );
};

export default ProductGrid;
