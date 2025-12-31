
import React from 'react';
import { motion } from 'framer-motion';
import { useNavigate, useLocation } from 'react-router-dom';
import { LayoutDashboard } from 'lucide-react';

const Header = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const isActive = (path) => location.pathname === path;

  return (
    <motion.header
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      className="bg-[#FAF8F5]/95 backdrop-blur-sm border-b border-[#E5E5E5] sticky top-0 z-50"
    >
      <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
        <div className="flex items-center justify-between">
          <button
            onClick={() => navigate('/')}
            className="flex items-center gap-3 hover:opacity-80 transition-opacity"
          >
            <img
              src="https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/e86844d8ae493331bc85900765bfea7a.png"
              alt="Wno Mas - Vinho & Companhia"
              className="h-16 w-auto -my-2"
            />
          </button>

          <div className="flex items-center gap-8">
            <button
              onClick={() => navigate('/')}
              className={`text-sm font-medium transition-colors ${isActive('/') ? 'text-[#722F37]' : 'text-[#1A1A1A] hover:text-[#722F37]'}`}
            >
              Vinhos
            </button>
            <button
              onClick={() => navigate('/sobre')}
              className={`text-sm font-medium transition-colors ${isActive('/sobre') ? 'text-[#722F37]' : 'text-[#1A1A1A] hover:text-[#722F37]'}`}
            >
              Sobre
            </button>
            <button
              onClick={() => navigate('/como-escolher')}
              className={`text-sm font-medium transition-colors ${isActive('/como-escolher') ? 'text-[#722F37]' : 'text-[#1A1A1A] hover:text-[#722F37]'}`}
            >
              Como Escolher
            </button>
            <button
              onClick={() => navigate('/dashboard')}
              className="flex items-center gap-1 text-sm font-medium text-[#6B6B6B] hover:text-[#722F37] transition-colors"
            >
              <LayoutDashboard className="h-4 w-4" />
              Gestão
            </button>
          </div>
        </div>
      </nav>
    </motion.header>
  );
};

export default Header;
