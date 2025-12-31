import React from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { Wine, Utensils, Gift, Sparkles } from 'lucide-react';
import { wines } from '@/data/wines';

const CurationSection = () => {
  const navigate = useNavigate();

  // Get unique kits from wines data
  const kitsData = [
    {
      id: 'kit-1',
      name: 'Kit Começar Bem',
      description: 'Para quem está descobrindo o mundo dos vinhos. Seleção acessível e versátil.',
      icon: Sparkles,
      color: '#722F37',
      filter: 'Kit 1 - Começar Bem',
    },
    {
      id: 'kit-2',
      name: 'Kit Jantar em Casa',
      description: 'Vinhos que harmonizam com pratos elaborados. Para momentos especiais.',
      icon: Utensils,
      color: '#C9A227',
      filter: 'Kit 2 - Jantar em Casa',
    },
    {
      id: 'kit-3',
      name: 'Kit Malbecs',
      description: 'Uma jornada pelos melhores Malbecs argentinos. Do acessível ao premium.',
      icon: Wine,
      color: '#5B7553',
      filter: 'Kit 3 - Malbecs da Argentina',
    },
    {
      id: 'kit-4',
      name: 'Kit Noite Especial',
      description: 'Para celebrar. Vinhos que marcam ocasiões memoráveis.',
      icon: Gift,
      color: '#4A6FA5',
      filter: 'Kit 4 - Noite Especial',
    },
  ];

  const getKitWineCount = (kitFilter) => {
    return wines.filter((wine) => wine.kits.includes(kitFilter)).length;
  };

  return (
    <section className="py-20 bg-white border-y border-[#E5E5E5]">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="text-sm uppercase tracking-widest text-[#722F37] mb-4">
            Curadoria
          </p>
          <h2 className="text-3xl md:text-4xl font-semibold text-[#1A1A1A] mb-4">
            Nem todo vinho entra.
          </h2>
          <p className="text-lg text-[#6B6B6B] max-w-2xl mx-auto">
            Cada rótulo aqui tem um motivo para existir.
            <br />
            Seleções pensadas para diferentes momentos e paladares.
          </p>
        </motion.div>

        {/* Kits Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {kitsData.map((kit, index) => {
            const wineCount = getKitWineCount(kit.filter);
            const IconComponent = kit.icon;

            return (
              <motion.div
                key={kit.id}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                onClick={() => navigate(`/?kit=${encodeURIComponent(kit.filter)}`)}
                className="group cursor-pointer bg-[#FAF8F5] rounded-2xl p-6 border border-[#E5E5E5] hover:border-[#722F37]/30 hover:shadow-lg transition-all duration-300"
              >
                <div
                  className="w-14 h-14 rounded-xl flex items-center justify-center mb-4 transition-transform group-hover:scale-110"
                  style={{ backgroundColor: `${kit.color}15` }}
                >
                  <IconComponent
                    className="h-7 w-7"
                    style={{ color: kit.color }}
                  />
                </div>

                <h3 className="text-lg font-semibold text-[#1A1A1A] mb-2">
                  {kit.name}
                </h3>

                <p className="text-sm text-[#6B6B6B] mb-4 leading-relaxed">
                  {kit.description}
                </p>

                <div className="flex items-center justify-between">
                  <span className="text-xs text-[#6B6B6B]">
                    {wineCount} {wineCount === 1 ? 'vinho' : 'vinhos'}
                  </span>
                  <span
                    className="text-sm font-medium transition-colors"
                    style={{ color: kit.color }}
                  >
                    Ver seleção →
                  </span>
                </div>
              </motion.div>
            );
          })}
        </div>

        {/* Bottom Quote */}
        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="text-center mt-16"
        >
          <p className="text-[#6B6B6B] italic font-signature text-lg">
            "Selecionamos menos rótulos para oferecer escolhas melhores."
          </p>
        </motion.div>
      </div>
    </section>
  );
};

export default CurationSection;
