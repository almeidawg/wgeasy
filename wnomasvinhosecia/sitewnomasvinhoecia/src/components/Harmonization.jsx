
import React from 'react';
import { motion } from 'framer-motion';
import { UtensilsCrossed, Calendar } from 'lucide-react';

const Harmonization = ({ wine }) => {
  // Momentos ideais baseados no tipo de vinho
  const getMoments = (type, body) => {
    const moments = [];
    if (type === 'Tinto') {
      moments.push('Jantares especiais');
      if (body === 'Encorpado' || body === 'Muito Encorpado') {
        moments.push('Noites frias');
        moments.push('Celebrações');
      } else {
        moments.push('Refeições do dia a dia');
        moments.push('Encontros casuais');
      }
    } else if (type === 'Branco') {
      moments.push('Almoços leves');
      moments.push('Dias quentes');
      moments.push('Happy hour');
    } else if (type === 'Espumante') {
      moments.push('Comemorações');
      moments.push('Brindes');
      moments.push('Aperitivos');
    }
    return moments;
  };

  const moments = getMoments(wine.type, wine.body);

  return (
    <section className="mb-16">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="bg-white rounded-2xl p-8 border border-[#E5E5E5]"
      >
        <h2 className="text-2xl font-semibold text-[#1A1A1A] mb-8">
          Harmonização
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Pratos ideais */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <UtensilsCrossed className="h-5 w-5 text-[#8B4513]" />
              <span className="text-sm font-medium text-[#1A1A1A]">Pratos ideais</span>
            </div>
            <div className="flex flex-wrap gap-2">
              {wine.pairing.map((item, index) => (
                <motion.span
                  key={index}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ duration: 0.4, delay: index * 0.1 }}
                  className="bg-[#F5F5F5] text-[#1A1A1A] px-4 py-2 rounded-full text-sm"
                >
                  {item}
                </motion.span>
              ))}
            </div>
          </div>

          {/* Momentos ideais */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <Calendar className="h-5 w-5 text-[#6B8E23]" />
              <span className="text-sm font-medium text-[#1A1A1A]">Momentos ideais</span>
            </div>
            <div className="flex flex-wrap gap-2">
              {moments.map((moment, index) => (
                <motion.span
                  key={index}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ duration: 0.4, delay: index * 0.1 }}
                  className="bg-[#6B8E2310] text-[#1A1A1A] px-4 py-2 rounded-full text-sm"
                >
                  {moment}
                </motion.span>
              ))}
            </div>
          </div>
        </div>

        {/* Dica */}
        <div className="mt-8 p-5 bg-[#FAFAFA] rounded-xl border border-[#E5E5E5]">
          <p className="text-sm text-[#6B6B6B] leading-relaxed">
            <span className="font-semibold text-[#8B4513]">Dica Wno Mas:</span> {wine.sommelierTip}
          </p>
        </div>
      </motion.div>
    </section>
  );
};

export default Harmonization;
