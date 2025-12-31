
import React from 'react';
import { motion } from 'framer-motion';
import { BookOpen } from 'lucide-react';

const ProductStory = ({ wine }) => {
  return (
    <section className="mb-16">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="bg-white rounded-2xl p-8 border border-[#E5E5E5]"
      >
        <div className="flex items-center gap-3 mb-6">
          <div className="w-12 h-12 rounded-full bg-[#6B8E2315] flex items-center justify-center">
            <BookOpen className="h-6 w-6 text-[#6B8E23]" />
          </div>
          <h2 className="text-2xl font-semibold text-[#1A1A1A]">A História</h2>
        </div>

        <div className="prose max-w-none">
          <h3 className="text-lg font-semibold text-[#1A1A1A] mb-3">
            Sobre o Produtor
          </h3>
          <p className="text-[#6B6B6B] leading-relaxed mb-6">
            {wine.producerStory}
          </p>

          <h3 className="text-lg font-semibold text-[#1A1A1A] mb-3">
            O Vinhedo
          </h3>
          <p className="text-[#6B6B6B] leading-relaxed mb-6">
            {wine.vineyardInfo}
          </p>

          <h3 className="text-lg font-semibold text-[#1A1A1A] mb-3">
            Processo de Vinificação
          </h3>
          <p className="text-[#6B6B6B] leading-relaxed">
            {wine.winemaking}
          </p>
        </div>
      </motion.div>
    </section>
  );
};

export default ProductStory;
