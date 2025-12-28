import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@14.10.0?target=deno";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
      apiVersion: '2023-10-16',
    });

    const { parcelaId, valor, descricao, clienteNome, clienteEmail } = await req.json();

    if (!parcelaId || !valor) {
      return new Response(
        JSON.stringify({ error: 'Parcela ID e valor são obrigatórios' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // Criar Payment Link no Stripe
    const paymentLink = await stripe.paymentLinks.create({
      line_items: [
        {
          price_data: {
            currency: 'brl',
            product_data: {
              name: descricao || `Parcela #${parcelaId}`,
              description: `Pagamento da parcela ${parcelaId}${clienteNome ? ` - ${clienteNome}` : ''}`,
            },
            unit_amount: Math.round(valor * 100), // Stripe usa centavos
          },
          quantity: 1,
        },
      ],
      after_completion: {
        type: 'redirect',
        redirect: {
          url: `${Deno.env.get('APP_URL') || 'http://localhost:5173'}/financeiro/pagamento-confirmado?parcela=${parcelaId}`,
        },
      },
      metadata: {
        parcela_id: parcelaId,
        cliente_nome: clienteNome || '',
        cliente_email: clienteEmail || '',
      },
    });

    // Atualizar parcela no banco com dados do Stripe
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

    if (!supabaseUrl || !supabaseKey) {
      throw new Error('Supabase credentials not found');
    }

    const updateResponse = await fetch(
      `${supabaseUrl}/rest/v1/financeiro_parcelas?id=eq.${parcelaId}`,
      {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'apikey': supabaseKey,
          'Authorization': `Bearer ${supabaseKey}`,
          'Prefer': 'return=minimal',
        },
        body: JSON.stringify({
          stripe_payment_link_id: paymentLink.id,
          stripe_payment_link_url: paymentLink.url,
          stripe_payment_status: 'pending',
          stripe_created_at: new Date().toISOString(),
        }),
      }
    );

    if (!updateResponse.ok) {
      const error = await updateResponse.text();
      console.error('Erro ao atualizar parcela:', error);
      throw new Error('Falha ao atualizar parcela no banco de dados');
    }

    return new Response(
      JSON.stringify({
        success: true,
        paymentLink: {
          id: paymentLink.id,
          url: paymentLink.url,
        },
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  } catch (error) {
    console.error('Erro ao criar Payment Link:', error);
    return new Response(
      JSON.stringify({
        error: error.message || 'Erro ao criar link de pagamento',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
