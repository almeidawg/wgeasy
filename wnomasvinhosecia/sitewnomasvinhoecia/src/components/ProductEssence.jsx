
import React from 'react';
import { motion } from 'framer-motion';
import { Wine, MapPin, Grape } from 'lucide-react';

const ProductEssence = ({ wine }) => {
  return (
    <section className="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-16">
      <motion.div
        initial={{ opacity: 0, x: -30 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.6 }}
        className="aspect-[3/4] rounded-2xl overflow-hidden bg-[#F5F5F5]"
      >
        <img
          src={wine.image}
          alt={wine.name}
          className="w-full h-full object-cover"
        />
      </motion.div>

      <motion.div
        initial={{ opacity: 0, x: 30 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.6 }}
        className="flex flex-col justify-center"
      >
        <div className="flex items-center gap-2 text-sm text-[#8B4513] font-medium mb-3">
          <Wine className="h-4 w-4" />
          <span>{wine.type}</span>
        </div>

        <h1 className="text-4xl font-semibold text-[#1A1A1A] mb-2">
          {wine.name}
        </h1>

        <div className="flex items-center gap-2 text-[#6B6B6B] mb-6">
          <MapPin className="h-4 w-4" />
          <span>{wine.region} · {wine.grapes.join(', ')}</span>
        </div>

        {/* Nota Wno Mas */}
        <div className="bg-[#F5F5F5] rounded-xl p-5 mb-6 border-l-4 border-[#8B4513]">
          <p className="text-xs uppercase tracking-widest text-[#8B4513] mb-2">
            Nota Wno Mas
          </p>
          <p className="text-[#1A1A1A] leading-relaxed">
            {wine.description}
          </p>
        </div>

        <div className="grid grid-cols-2 gap-4 mb-8">
          <div className="bg-white rounded-xl p-4 border border-[#E5E5E5]">
            <span className="block text-xs text-[#6B6B6B] mb-1">Uvas</span>
            <div className="flex items-center gap-2">
              <Grape className="h-4 w-4 text-[#8B4513]" />
              <span className="text-sm font-medium text-[#1A1A1A]">
                {wine.grapes.join(', ')}
              </span>
            </div>
          </div>

          <div className="bg-white rounded-xl p-4 border border-[#E5E5E5]">
            <span className="block text-xs text-[#6B6B6B] mb-1">Safra</span>
            <span className="text-sm font-medium text-[#1A1A1A]">
              {wine.vintage}
            </span>
          </div>
        </div>

        <div className="text-4xl font-semibold text-[#1A1A1A]">
          R$ {wine.price.toFixed(2)}
        </div>
      </motion.div>
    </section>
  );
};

export default ProductEssence;
