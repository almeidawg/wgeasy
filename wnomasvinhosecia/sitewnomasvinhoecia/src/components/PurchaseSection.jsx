
import React from 'react';
import { motion } from 'framer-motion';
import { ShoppingCart, Share2, Heart, Package } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useToast } from '@/components/ui/use-toast';
// import { loadStripe } from '@stripe/stripe-js'; // Future Stripe implementation

const PurchaseSection = ({ wine }) => {
  const { toast } = useToast();

  const handlePurchase = async () => {
    toast({
      title: "Processando compra...",
      description: "Redirecionando para o checkout do Stripe.",
    });

    // Simulated Stripe checkout redirect
    setTimeout(() => {
      toast({
        title: "🚧 Integração Stripe em Andamento",
        description: "Em breve você poderá finalizar sua compra com segurança via Stripe!",
      });
    }, 1000);
  };

  const handleWhatsAppShare = () => {
    const message = `Olha que incrível este ${wine.name} que encontrei na Wno Mas! R$ ${wine.price.toFixed(2)}`;
    const url = `https://wa.me/?text=${encodeURIComponent(message + ' ' + window.location.href)}`;
    window.open(url, '_blank');
  };

  const handleWishlist = () => {
    toast({
      title: "Adicionado à Lista de Desejos",
      description: "Você poderá acessar seus favoritos em breve.",
    });
  };

  return (
    <motion.section
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
      className="sticky bottom-0 bg-white border-t border-[#E5E5E5] p-6 rounded-t-2xl shadow-[0_-5px_20px_-5px_rgba(0,0,0,0.1)] z-40"
    >
      <div className="max-w-4xl mx-auto">
        <div className="flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex flex-col">
            <span className="text-sm text-[#6B6B6B]">Preço por garrafa</span>
            <div className="flex items-baseline gap-2">
              <span className="text-3xl font-semibold text-[#1A1A1A]">
                R$ {wine.price.toFixed(2)}
              </span>
              {wine.inventory.quantity < 10 && (
                 <span className="text-xs text-red-500 font-medium bg-red-50 px-2 py-1 rounded-full">
                   Últimas {wine.inventory.quantity} unidades
                 </span>
              )}
            </div>
            {wine.kits && wine.kits.length > 0 && (
              <span className="text-xs text-[#8B4513] mt-1 flex items-center gap-1">
                <Package className="h-3 w-3" /> Disponível no {wine.kits[0]}
              </span>
            )}
          </div>

          <div className="flex items-center gap-3 w-full md:w-auto">
            <Button
              variant="outline"
              size="icon"
              onClick={handleWishlist}
              className="border-[#E5E5E5] hover:bg-[#F5F5F5]"
            >
              <Heart className="h-5 w-5 text-[#1A1A1A]" />
            </Button>

            <Button
              variant="outline"
              size="icon"
              onClick={handleWhatsAppShare}
              className="border-[#E5E5E5] hover:bg-[#F5F5F5] text-[#25D366] hover:text-[#25D366]"
            >
              <Share2 className="h-5 w-5" />
            </Button>

            <Button
              onClick={handlePurchase}
              className="flex-1 md:flex-initial bg-[#1A1A1A] text-white hover:bg-[#2A2A2A] px-8 py-6 text-lg shadow-lg hover:shadow-xl transition-all"
            >
              <ShoppingCart className="h-5 w-5 mr-2" />
              Adicionar à seleção
            </Button>
          </div>
        </div>

        <div className="mt-4 pt-4 border-t border-[#E5E5E5] hidden md:block">
          <div className="grid grid-cols-3 gap-4 text-xs text-[#6B6B6B]">
            <div className="flex items-center gap-2 justify-center">
              <div className="w-1.5 h-1.5 rounded-full bg-[#6B8E23]"></div>
              <span>Entrega Segura</span>
            </div>
            <div className="flex items-center gap-2 justify-center">
              <div className="w-1.5 h-1.5 rounded-full bg-[#6B8E23]"></div>
              <span>Armazenamento Climatizado ({wine.inventory.location.includes('Horizontal') ? 'Horizontal' : 'Adega'})</span>
            </div>
            <div className="flex items-center gap-2 justify-center">
              <div className="w-1.5 h-1.5 rounded-full bg-[#6B8E23]"></div>
              <span>Garantia de Procedência</span>
            </div>
          </div>
        </div>
      </div>
    </motion.section>
  );
};

export default PurchaseSection;
