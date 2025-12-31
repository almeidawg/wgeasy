import React from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { Wine, Utensils, Package, Calendar } from 'lucide-react';

const NavigationBlock = ({ setFilters }) => {
  const navigate = useNavigate();

  const categories = [
    {
      icon: Calendar,
      title: 'Por ocasião',
      description: 'Jantar especial, encontro casual, presente...',
      action: () => setFilters && setFilters(prev => ({ ...prev, type: 'all' })),
      color: '#8B4513'
    },
    {
      icon: Utensils,
      title: 'Por prato',
      description: 'Carnes, peixes, massas, queijos...',
      action: () => navigate('/como-escolher'),
      color: '#6B8E23'
    },
    {
      icon: Package,
      title: 'Kits e seleções',
      description: 'Combinações prontas para experimentar',
      action: () => setFilters && setFilters(prev => ({ ...prev, type: 'all' })),
      color: '#B8860B'
    }
  ];

  return (
    <section className="bg-[#FAFAFA] py-16">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="text-center mb-12"
        >
          <h2 className="text-2xl sm:text-3xl font-semibold text-[#1A1A1A] mb-4">
            Como você quer explorar?
          </h2>
          <p className="text-[#6B6B6B]">
            Encontre o vinho certo para o seu momento.
          </p>
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {categories.map((category, index) => (
            <motion.button
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              onClick={category.action}
              className="bg-white p-8 rounded-2xl border border-[#E5E5E5] hover:border-[#8B4513] transition-all hover:shadow-lg text-left group"
            >
              <div
                className="w-14 h-14 rounded-full flex items-center justify-center mb-5 transition-colors"
                style={{ backgroundColor: `${category.color}10` }}
              >
                <category.icon
                  className="h-7 w-7 transition-colors"
                  style={{ color: category.color }}
                />
              </div>
              <h3 className="text-xl font-semibold text-[#1A1A1A] mb-2 group-hover:text-[#8B4513] transition-colors">
                {category.title}
              </h3>
              <p className="text-[#6B6B6B] text-sm leading-relaxed">
                {category.description}
              </p>
            </motion.button>
          ))}
        </div>
      </div>
    </section>
  );
};

export default NavigationBlock;
