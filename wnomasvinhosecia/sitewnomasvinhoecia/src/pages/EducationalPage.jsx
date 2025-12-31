
import React from 'react';
import { Helmet } from 'react-helmet';
import { motion } from 'framer-motion';
import { ArrowLeft, Wine, Clock, Users, Utensils } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';

const EducationalPage = () => {
  const navigate = useNavigate();

  const guides = [
    {
      icon: Clock,
      title: "Para quando é o vinho?",
      description: "Jantar hoje? Um vinho jovem e frutado (Safra recente). Para guardar? Um vinho com potencial de envelhecimento (Gran Reserva, Premium).",
      color: "#8B4513"
    },
    {
      icon: Users,
      title: "Quem vai beber?",
      description: "Iniciantes? Vinhos mais suaves, menos taninos (Merlot, Pinot Noir). Conhecedores? Vinhos complexos, encorpados (Cabernet, Tannat, Malbec).",
      color: "#6B8E23"
    },
    {
      icon: Utensils,
      title: "O que vai comer?",
      description: "Carnes vermelhas pedem taninos (Cabernet, Malbec). Peixes e frutos do mar pedem acidez (Brancos, Espumantes). Massas? Depende do molho!",
      color: "#B8860B"
    },
    {
      icon: Wine,
      title: "Qual o seu gosto?",
      description: "Gosta de café preto sem açúcar? Tente vinhos secos e tânicos. Prefere sucos doces? Comece com vinhos frutados e macios.",
      color: "#CD853F"
    }
  ];

  return (
    <>
      <Helmet>
        <title>Como Escolher seu Vinho - Wno Mas</title>
        <meta name="description" content="Guia prático para escolher o vinho ideal para cada ocasião. Aprenda sobre harmonização, tipos de uva e como decifrar rótulos." />
      </Helmet>

      <div className="min-h-screen bg-[#FAF8F5]">
        <Header />

        <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <Button
              variant="ghost"
              onClick={() => navigate('/')}
              className="flex items-center gap-2 text-[#1A1A1A] hover:bg-[#F5F5F5] mb-8"
            >
              <ArrowLeft className="h-5 w-5" />
              Voltar para Vinhos
            </Button>

            <h1 className="text-4xl md:text-5xl font-semibold text-[#1A1A1A] mb-6">
              Qual vinho escolher?
            </h1>
            <p className="text-xl text-[#6B6B6B] mb-12 max-w-2xl">
              Escolher um vinho não precisa ser complicado. Use nosso guia simplificado para encontrar a garrafa perfeita para o seu momento.
            </p>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {guides.map((guide, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.5, delay: index * 0.1 }}
                  className="bg-white p-8 rounded-2xl border border-[#E5E5E5] hover:border-[#8B4513] transition-colors"
                >
                  <div
                    className="w-12 h-12 rounded-full flex items-center justify-center mb-4"
                    style={{ backgroundColor: `${guide.color}15` }}
                  >
                    <guide.icon className="h-6 w-6" style={{ color: guide.color }} />
                  </div>
                  <h3 className="text-xl font-semibold text-[#1A1A1A] mb-3">
                    {guide.title}
                  </h3>
                  <p className="text-[#6B6B6B] leading-relaxed">
                    {guide.description}
                  </p>
                </motion.div>
              ))}
            </div>

            <div className="mt-16 bg-[#1A1A1A] rounded-2xl p-8 md:p-12 text-center">
              <h2 className="text-2xl md:text-3xl font-semibold text-white mb-4">
                Ainda na dúvida?
              </h2>
              <p className="text-white/80 mb-8 max-w-xl mx-auto">
                Nossa seleção é curada para garantir qualidade em qualquer escolha. 
                Explore nossos kits para experimentar diferentes estilos.
              </p>
              <Button
                onClick={() => navigate('/')}
                className="bg-white text-[#1A1A1A] hover:bg-gray-100 px-8 py-6 text-lg rounded-full"
              >
                Ver Nossa Seleção
              </Button>
            </div>
          </motion.div>
        </main>

        <Footer />
      </div>
    </>
  );
};

export default EducationalPage;
