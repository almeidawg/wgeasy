import React from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';

const InstitutionalBlock = () => {
  const navigate = useNavigate();

  return (
    <section className="bg-[#1A1A1A] py-20">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.7 }}
          className="text-center"
        >
          <p className="text-white/60 text-sm uppercase tracking-widest mb-6">
            Manifesto
          </p>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-semibold text-white leading-tight mb-8">
            Quando o vinho é bom,
            <br />
            a vontade é continuar.
          </h2>
          <p className="text-white/70 text-lg max-w-2xl mx-auto leading-relaxed mb-10">
            A Wno Mas nasce do hábito de escolher bem —
            <br />
            e da vontade de repetir quando a escolha é certa.
          </p>
          <button
            onClick={() => navigate('/sobre')}
            className="inline-flex items-center gap-2 text-white/80 hover:text-white transition-colors text-sm font-medium group"
          >
            Conheça nossa história
            <ArrowRight className="h-4 w-4 group-hover:translate-x-1 transition-transform" />
          </button>
        </motion.div>
      </div>
    </section>
  );
};

export default InstitutionalBlock;
