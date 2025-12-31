
import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Helmet } from 'react-helmet';
import { motion } from 'framer-motion';
import { ArrowLeft, Share2 } from 'lucide-react';
import Header from '@/components/Header';
import ProductEssence from '@/components/ProductEssence';
import QuickUnderstanding from '@/components/QuickUnderstanding';
import Harmonization from '@/components/Harmonization';
import ProductStory from '@/components/ProductStory';
import PurchaseSection from '@/components/PurchaseSection';
import Footer from '@/components/Footer';
import { wines } from '@/data/wines';
import { Button } from '@/components/ui/button';
import { useToast } from '@/components/ui/use-toast';

const ProductPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const { toast } = useToast();
  const wine = wines.find(w => w.id === id);

  if (!wine) {
    return (
      <div className="min-h-screen bg-[#FAFAFA] flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-semibold text-[#1A1A1A] mb-4">Produto não encontrado</h2>
          <Button onClick={() => navigate('/')} variant="outline">
            Voltar para home
          </Button>
        </div>
      </div>
    );
  }

  const handleWhatsAppShare = () => {
    const message = `Confira este vinho incrível: ${wine.name} - R$ ${wine.price.toFixed(2)}`;
    const url = `https://wa.me/?text=${encodeURIComponent(message + ' ' + window.location.href)}`;
    window.open(url, '_blank');
  };

  return (
    <>
      <Helmet>
        <title>{wine.name} - Wno Mas</title>
        <meta name="description" content={`${wine.name} - ${wine.description}. ${wine.grapes.join(', ')} de ${wine.region}, ${wine.country}.`} />
      </Helmet>

      <div className="min-h-screen bg-[#FAF8F5]">
        <Header />
        
        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="flex items-center gap-4 mb-8">
              <Button
                variant="ghost"
                onClick={() => navigate('/')}
                className="flex items-center gap-2 text-[#1A1A1A] hover:bg-[#F5F5F5]"
              >
                <ArrowLeft className="h-5 w-5" />
                Voltar
              </Button>
              
              <Button
                variant="outline"
                onClick={handleWhatsAppShare}
                className="ml-auto flex items-center gap-2 border-[#2A2A2A] text-[#1A1A1A] hover:bg-[#F5F5F5]"
              >
                <Share2 className="h-4 w-4" />
                Compartilhar
              </Button>
            </div>

            <ProductEssence wine={wine} />
            <QuickUnderstanding wine={wine} />
            <Harmonization wine={wine} />
            <ProductStory wine={wine} />
            <PurchaseSection wine={wine} />
          </motion.div>
        </main>

        <Footer />
      </div>
    </>
  );
};

export default ProductPage;
