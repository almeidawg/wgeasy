
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Wine, MapPin, Grape, Thermometer, ArrowRight } from 'lucide-react';

const ProductCard = ({ wine }) => {
  const navigate = useNavigate();

  // Body indicator dots
  const getBodyLevel = (body) => {
    const levels = {
      'Leve': 1,
      'Médio': 2,
      'Encorpado': 3,
      'Muito Encorpado': 4
    };
    return levels[body] || 2;
  };

  const bodyLevel = getBodyLevel(wine.body);

  return (
    <motion.div
      whileHover={{ x: 4 }}
      transition={{ duration: 0.2 }}
      onClick={() => navigate(`/product/${wine.id}`)}
      className="bg-white rounded-2xl overflow-hidden border border-[#E5E5E5] cursor-pointer group hover:border-[#722F37]/30 transition-all duration-300"
    >
      <div className="flex flex-col md:flex-row items-center">
        {/* Horizontal Bottle Image - rotated to lay flat like in a cellar */}
        <div className="w-full md:w-[500px] lg:w-[580px] flex-shrink-0 bg-white">
          <div className="relative h-36 md:h-44 flex items-center justify-center">
            <img
              src={wine.image}
              alt={wine.name}
              className="h-full w-auto object-contain"
              style={{ maxWidth: 'none', width: 'auto', transform: 'rotate(90deg) scale(3.0)' }}
            />
          </div>
        </div>

        {/* Content - Compact */}
        <div className="flex-1 min-w-0 p-3 lg:p-4">
          {/* Header Row */}
          <div className="flex items-start justify-between gap-3 mb-2">
            <div className="flex-1">
              <h3 className="text-lg lg:text-xl font-semibold text-[#1A1A1A] group-hover:text-[#722F37] transition-colors">
                {wine.name}
              </h3>
              <p className="text-base text-[#722F37] font-medium">
                R$ {wine.price.toFixed(2).replace('.', ',')}
              </p>
            </div>
          </div>

          {/* Info Grid - Compact */}
          <div className="grid grid-cols-3 gap-x-4 gap-y-1 text-xs mb-2">
            <div>
              <span className="text-[#6B6B6B]">Uvas: </span>
              <span className="text-[#1A1A1A]">{wine.grapes.join(', ')}</span>
            </div>
            <div>
              <span className="text-[#6B6B6B]">Região: </span>
              <span className="text-[#1A1A1A]">{wine.region}</span>
            </div>
            <div>
              <span className="text-[#6B6B6B]">Safra: </span>
              <span className="text-[#1A1A1A]">{wine.vintage}</span>
            </div>
          </div>

          {/* Description - Compact */}
          <p className="text-[#6B6B6B] text-xs leading-relaxed mb-3 line-clamp-1">
            {wine.description}
          </p>

          {/* Bottom Row - Compact */}
          <div className="flex items-center justify-between pt-2 border-t border-[#E5E5E5]">
            <div className="flex items-center gap-2">
              <div className="flex items-center gap-1">
                <span className="text-xs text-[#6B6B6B]">Corpo</span>
                <div className="flex gap-0.5">
                  {[1, 2, 3, 4].map((level) => (
                    <div
                      key={level}
                      className={`w-1.5 h-1.5 rounded-full ${
                        level <= bodyLevel ? 'bg-[#722F37]' : 'bg-[#E5E5E5]'
                      }`}
                    />
                  ))}
                </div>
              </div>
              <span className="text-[#E5E5E5]">|</span>
              <span className="text-xs text-[#6B6B6B]">{wine.alcohol}</span>
            </div>

            <span className="flex items-center gap-1 text-xs font-medium text-[#722F37] group-hover:gap-2 transition-all">
              Ver detalhes
              <ArrowRight className="h-3 w-3" />
            </span>
          </div>
        </div>
      </div>
    </motion.div>
  );
};

export default ProductCard;
