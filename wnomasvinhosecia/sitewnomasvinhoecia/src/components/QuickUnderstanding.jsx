
import React from 'react';
import { motion } from 'framer-motion';
import { Thermometer, Percent } from 'lucide-react';

// Função para converter texto em nível numérico
const getLevel = (value) => {
  const lowValues = ['Leve', 'Baixa', 'Baixo', 'Inexistente', 'Macios', 'Suaves'];
  const mediumValues = ['Médio', 'Média', 'Finos', 'Aveludados', 'Doces'];
  const highValues = ['Encorpado', 'Alta', 'Alto', 'Muito Encorpado'];

  if (lowValues.some(v => value?.includes(v))) return 2;
  if (mediumValues.some(v => value?.includes(v))) return 3;
  if (highValues.some(v => value?.includes(v))) return 4;
  return 3;
};

// Componente de bolinhas
const DotScale = ({ level, color }) => {
  return (
    <div className="flex gap-1.5 justify-center">
      {[1, 2, 3, 4, 5].map((dot) => (
        <div
          key={dot}
          className="w-3 h-3 rounded-full transition-colors"
          style={{
            backgroundColor: dot <= level ? color : '#E5E5E5'
          }}
        />
      ))}
    </div>
  );
};

const QuickUnderstanding = ({ wine }) => {
  const scaleFeatures = [
    {
      label: 'Corpo',
      value: wine.body,
      level: getLevel(wine.body),
      color: '#8B4513'
    },
    {
      label: 'Acidez',
      value: wine.acidity,
      level: getLevel(wine.acidity),
      color: '#6B8E23'
    },
    {
      label: 'Tanino',
      value: wine.tannins,
      level: getLevel(wine.tannins),
      color: '#B8860B'
    }
  ];

  return (
    <section className="mb-16">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="bg-white rounded-2xl p-8 border border-[#E5E5E5]"
      >
        <h2 className="text-2xl font-semibold text-[#1A1A1A] mb-2">
          Entenda em 10 segundos
        </h2>
        <p className="text-sm text-[#6B6B6B] mb-8">
          Visualize as características principais deste vinho.
        </p>

        {/* Escala de bolinhas */}
        <div className="grid grid-cols-3 gap-8 mb-8">
          {scaleFeatures.map((feature, index) => (
            <motion.div
              key={feature.label}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="text-center"
            >
              <span className="block text-sm font-medium text-[#1A1A1A] mb-3">
                {feature.label}
              </span>
              <DotScale level={feature.level} color={feature.color} />
              <span className="block text-xs text-[#6B6B6B] mt-2">
                {feature.value}
              </span>
            </motion.div>
          ))}
        </div>

        {/* Informações adicionais */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 pt-8 border-t border-[#E5E5E5]">
          <div className="bg-[#F5F5F5] rounded-xl p-4 text-center">
            <Percent className="h-5 w-5 mx-auto mb-2 text-[#8B4513]" />
            <span className="block text-xs text-[#6B6B6B] mb-1">Teor alcoólico</span>
            <span className="text-lg font-semibold text-[#1A1A1A]">{wine.alcohol}</span>
          </div>
          <div className="bg-[#F5F5F5] rounded-xl p-4 text-center">
            <Thermometer className="h-5 w-5 mx-auto mb-2 text-[#6B8E23]" />
            <span className="block text-xs text-[#6B6B6B] mb-1">Temperatura ideal</span>
            <span className="text-lg font-semibold text-[#1A1A1A]">{wine.idealTemperature}</span>
          </div>
          <div className="bg-[#F5F5F5] rounded-xl p-4 text-center">
            <span className="block text-xs text-[#6B6B6B] mb-1">Método</span>
            <span className="text-sm font-semibold text-[#1A1A1A]">{wine.productionMethod}</span>
          </div>
          <div className="bg-[#F5F5F5] rounded-xl p-4 text-center">
            <span className="block text-xs text-[#6B6B6B] mb-1">Guarda</span>
            <span className="text-sm font-semibold text-[#1A1A1A]">{wine.agingPotential}</span>
          </div>
        </div>
      </motion.div>
    </section>
  );
};

export default QuickUnderstanding;
