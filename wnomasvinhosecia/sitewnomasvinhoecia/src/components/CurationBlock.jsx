import React from 'react';
import { motion } from 'framer-motion';

const CurationBlock = () => {
  return (
    <section className="relative bg-white py-20 border-b border-[#E5E5E5] overflow-hidden">
      {/* Decorative brushstroke elements */}
      <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
        <div className="absolute top-8 right-[20%] w-20 h-[2px] bg-gradient-to-r from-transparent via-[#C9A227]/40 to-transparent transform rotate-12 rounded-full" />
        <div className="absolute bottom-12 left-[15%] w-16 h-[2px] bg-gradient-to-r from-transparent via-[#722F37]/30 to-transparent transform -rotate-6 rounded-full" />
      </div>

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.7 }}
          className="text-center"
        >
          <p className="text-sm uppercase tracking-widest text-[#722F37] mb-6">
            Curadoria
          </p>
          <h2 className="text-3xl sm:text-4xl font-semibold text-[#1A1A1A] mb-6">
            Nem todo vinho entra.
          </h2>
          <p className="text-lg text-[#6B6B6B] max-w-2xl mx-auto leading-relaxed mb-8">
            Cada rótulo aqui tem um motivo para existir.
          </p>
          <p className="text-[#6B6B6B] max-w-xl mx-auto leading-relaxed">
            Selecionamos vinhos que entregam <span className="text-[#1A1A1A] font-medium">prazer real</span>, equilíbrio e coerência
            com o momento em que são bebidos.
          </p>

          {/* Decorative divider */}
          <div className="mt-10 flex items-center justify-center gap-4">
            <div className="w-16 h-[1px] bg-gradient-to-r from-transparent to-[#E5E5E5]" />
            <div className="w-2 h-2 rounded-full bg-[#722F37]/30" />
            <div className="w-16 h-[1px] bg-gradient-to-l from-transparent to-[#E5E5E5]" />
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default CurationBlock;
