import React from 'react';
import { motion } from 'framer-motion';

const Hero = () => {
  return (
    <section className="relative bg-[#FAF8F5] border-b border-[#E5E5E5] overflow-hidden">
      {/* Decorative brushstroke elements - Van Gogh inspired */}
      <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
        <div className="absolute top-10 left-[10%] w-32 h-1 bg-gradient-to-r from-transparent via-[#722F37]/20 to-transparent transform -rotate-12 rounded-full" />
        <div className="absolute top-20 right-[15%] w-24 h-1 bg-gradient-to-r from-transparent via-[#C9A227]/30 to-transparent transform rotate-6 rounded-full" />
        <div className="absolute bottom-16 left-[20%] w-20 h-1 bg-gradient-to-r from-transparent via-[#722F37]/15 to-transparent transform rotate-3 rounded-full" />
      </div>

      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-24 text-center relative z-10">
        {/* Elegant quote marks */}
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 0.1, scale: 1 }}
          transition={{ duration: 1 }}
          className="absolute top-12 left-1/2 transform -translate-x-1/2 text-[120px] text-[#722F37] font-serif leading-none pointer-events-none"
        >
          "
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7 }}
          className="text-4xl sm:text-5xl lg:text-6xl font-semibold text-[#1A1A1A] leading-tight mb-6"
        >
          Vinhos escolhidos com critério.
          <br />
          <span className="text-[#722F37]">Para beber bem</span>, sem complicação.
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.2 }}
          className="text-lg text-[#6B6B6B] max-w-2xl mx-auto mb-8 leading-relaxed"
        >
          Não vendemos todos os vinhos.
          <br />
          <span className="font-medium text-[#1A1A1A]">Apenas os que fazem sentido.</span>
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.4 }}
          className="inline-block"
        >
          <p className="text-sm text-[#722F37] font-medium tracking-wide font-signature text-lg">
            Menos rótulos. Melhores escolhas.
          </p>
          <div className="mt-2 h-[2px] w-24 mx-auto bg-gradient-to-r from-transparent via-[#C9A227] to-transparent rounded-full" />
        </motion.div>

        {/* Manifesto teaser */}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.7, delay: 0.6 }}
          className="mt-12 text-sm text-[#6B6B6B] italic font-signature"
        >
          "Quando o vinho é bom, a vontade é continuar."
        </motion.p>
      </div>
    </section>
  );
};

export default Hero;