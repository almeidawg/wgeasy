
import React from 'react';
import { Mail, Phone, Instagram, Facebook } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const Footer = () => {
  const navigate = useNavigate();

  return (
    <footer className="bg-[#1A1A1A] mt-0">
      {/* Quote section */}
      <div className="border-b border-white/10 py-12">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <p className="text-white/50 italic font-signature text-lg mb-2">
            "Quando o vinho é bom, a vontade é continuar."
          </p>
          <p className="text-[#C9A227] text-sm tracking-widest uppercase">
            Wno Mas
          </p>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <div className="flex items-center gap-2 mb-4">
              <img
                src="https://horizons-cdn.hostinger.com/e275722c-fa00-43fb-9260-1ee1b89a46ba/e86844d8ae493331bc85900765bfea7a.png"
                alt="Wno Mas - Vinho & Companhia"
                className="h-12 w-auto brightness-0 invert opacity-80"
              />
            </div>
            <p className="text-sm text-white/60 leading-relaxed">
              Vinhos escolhidos com critério.
              <br />
              Para beber bem, sem complicação.
            </p>
          </div>

          <div>
            <span className="block text-sm font-semibold text-white mb-4">Navegação</span>
            <nav className="flex flex-col gap-2">
              <button onClick={() => navigate('/')} className="text-sm text-left text-white/60 hover:text-[#C9A227] transition-colors">
                Vinhos
              </button>
              <button onClick={() => navigate('/sobre')} className="text-sm text-left text-white/60 hover:text-[#C9A227] transition-colors">
                Sobre
              </button>
              <button onClick={() => navigate('/como-escolher')} className="text-sm text-left text-white/60 hover:text-[#C9A227] transition-colors">
                Como Escolher
              </button>
            </nav>
          </div>

          <div>
            <span className="block text-sm font-semibold text-white mb-4">Contato</span>
            <div className="flex flex-col gap-2">
              <a href="mailto:contato@wnomas.com.br" className="text-sm text-white/60 hover:text-[#C9A227] transition-colors flex items-center gap-2">
                <Mail className="h-4 w-4" />
                contato@wnomas.com.br
              </a>
              <a href="tel:+5511999999999" className="text-sm text-white/60 hover:text-[#C9A227] transition-colors flex items-center gap-2">
                <Phone className="h-4 w-4" />
                (11) 99999-9999
              </a>
            </div>
          </div>

          <div>
            <span className="block text-sm font-semibold text-white mb-4">Redes Sociais</span>
            <div className="flex gap-3">
              <a
                href="#"
                className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-[#722F37] text-white/60 hover:text-white transition-colors"
              >
                <Instagram className="h-5 w-5" />
              </a>
              <a
                href="#"
                className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-[#722F37] text-white/60 hover:text-white transition-colors"
              >
                <Facebook className="h-5 w-5" />
              </a>
            </div>
          </div>
        </div>

        <div className="mt-8 pt-8 border-t border-white/10 text-center">
          <p className="text-sm text-white/40">
            © 2025 Wno Mas - Vinho & Companhia. Todos os direitos reservados.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
