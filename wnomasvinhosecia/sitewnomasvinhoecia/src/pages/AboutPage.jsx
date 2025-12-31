import React from 'react';
import { Helmet } from 'react-helmet';
import { motion } from 'framer-motion';
import { ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Button } from '@/components/ui/button';

const AboutPage = () => {
  const navigate = useNavigate();

  return (
    <>
      <Helmet>
        <title>Sobre - Wno Mas</title>
        <meta name="description" content="A Wno Mas não nasceu como empresa. Nasceu como um hábito. Conheça nossa história e nosso critério." />
      </Helmet>

      <div className="min-h-screen bg-[#FAF8F5]">
        <Header />

        <main className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
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
              Voltar
            </Button>

            {/* Header */}
            <div className="text-center mb-16">
              <motion.p
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.2 }}
                className="text-sm uppercase tracking-widest text-[#8B4513] mb-4"
              >
                Nossa História
              </motion.p>
              <motion.h1
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
                className="text-4xl md:text-5xl font-semibold text-[#1A1A1A] mb-6"
              >
                A origem
              </motion.h1>
            </div>

            {/* Content */}
            <div className="prose prose-lg max-w-none">
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4 }}
                className="mb-12"
              >
                <p className="text-xl text-[#1A1A1A] font-medium leading-relaxed mb-8">
                  A Wno Mas não nasceu como empresa.
                  <br />
                  Nasceu como um hábito.
                </p>
                <p className="text-[#6B6B6B] leading-relaxed mb-6">
                  O vinho entrou na rotina antes de qualquer plano. Primeiro como curiosidade,
                  depois como preferência — e, com o tempo, como critério. Beber bem passou a
                  ser parte do cotidiano.
                </p>
                <p className="text-[#6B6B6B] leading-relaxed mb-6">
                  Naturalmente, isso começou a ser percebido por quem estava por perto.
                  Vizinhos, amigos e visitas faziam sempre a mesma pergunta:
                </p>
                <p className="text-[#1A1A1A] text-xl italic mb-6 pl-6 border-l-2 border-[#8B4513]">
                  — "Você tem um vinho?"
                </p>
                <p className="text-[#6B6B6B] leading-relaxed mb-6">
                  A resposta era simples. <strong className="text-[#1A1A1A]">Sim.</strong>
                </p>
                <p className="text-[#6B6B6B] leading-relaxed">
                  Com o tempo, as garrafas se multiplicaram. A escolha ficou mais cuidadosa.
                  Uma adega surgiu — não por excesso, mas por constância. Pela compreensão de que
                  menos rótulos certos valem mais do que muitas escolhas aleatórias.
                </p>
              </motion.div>

              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.5 }}
                className="mb-12"
              >
                <h2 className="text-2xl font-semibold text-[#1A1A1A] mb-6">
                  De gosto pessoal a curadoria
                </h2>
                <p className="text-[#6B6B6B] leading-relaxed mb-6">
                  A Wno Mas nasce no momento em que o gosto pessoal deixa de ser apenas
                  individual e passa a ser compartilhado.
                </p>
                <p className="text-[#6B6B6B] leading-relaxed mb-6">
                  Não como imposição.
                  <br />
                  Mas como <strong className="text-[#1A1A1A]">curadoria</strong>.
                </p>
                <p className="text-[#6B6B6B] leading-relaxed">
                  A marca existe para selecionar vinhos com critério, explicar sem complicar
                  e oferecer experiências que façam sentido para quem bebe — não apenas para
                  quem entende de vinho.
                </p>
              </motion.div>

              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6 }}
                className="mb-12"
              >
                <div className="bg-white p-8 rounded-2xl border border-[#E5E5E5]">
                  <p className="text-[#1A1A1A] text-lg leading-relaxed mb-4">
                    Aqui, o vinho não é tratado como produto.
                  </p>
                  <p className="text-[#8B4513] text-xl font-medium">
                    É tratado como escolha.
                  </p>
                </div>
              </motion.div>

              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.7 }}
                className="mb-12"
              >
                <h2 className="text-2xl font-semibold text-[#1A1A1A] mb-6">
                  O significado do nome
                </h2>
                <p className="text-[#6B6B6B] leading-relaxed mb-6">
                  <strong className="text-[#1A1A1A]">Wno Mas</strong> carrega uma ideia simples e direta.
                </p>
                <p className="text-[#1A1A1A] text-lg leading-relaxed mb-6">
                  Quando o vinho é bom,
                  <br />
                  a vontade é continuar.
                </p>
                <p className="text-[#6B6B6B] leading-relaxed">
                  Mais uma taça.
                  <br />
                  Mais um momento.
                  <br />
                  Mais uma vez.
                </p>
              </motion.div>

              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.8 }}
                className="bg-[#1A1A1A] p-10 rounded-2xl text-center"
              >
                <p className="text-white/70 leading-relaxed mb-6">
                  A Wno Mas é uma marca construída com silêncio, intenção e consistência.
                </p>
                <p className="text-white/50 text-sm mb-6">
                  Sem exageros. Sem barulho. Sem complicação.
                </p>
                <p className="text-white text-lg leading-relaxed mb-2">
                  Uma marca que confia no próprio gosto —
                </p>
                <p className="text-white text-lg leading-relaxed mb-8">
                  e convida você a confiar também.
                </p>
                <p className="text-[#8B4513] text-sm uppercase tracking-widest">
                  Wno Mas
                </p>
              </motion.div>
            </div>

            {/* CTA */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.9 }}
              className="mt-16 text-center"
            >
              <Button
                onClick={() => navigate('/')}
                className="bg-[#1A1A1A] text-white hover:bg-[#2A2A2A] px-8 py-6 text-lg rounded-full"
              >
                Explorar a curadoria
              </Button>
            </motion.div>
          </motion.div>
        </main>

        <Footer />
      </div>
    </>
  );
};

export default AboutPage;
