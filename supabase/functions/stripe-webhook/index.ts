import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@14.10.0?target=deno";

serve(async (req) => {
  const signature = req.headers.get('stripe-signature');
  const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET');

  if (!signature || !webhookSecret) {
    return new Response('Webhook signature ou secret não encontrado', { status: 400 });
  }

  try {
    const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') || '', {
      apiVersion: '2023-10-16',
    });

    const body = await req.text();

    // Verificar assinatura do webhook
    const event = stripe.webhooks.constructEvent(body, signature, webhookSecret);

    console.log('Webhook recebido:', event.type);

    // Processar eventos do Stripe
    if (event.type === 'checkout.session.completed') {
      const session = event.data.object as Stripe.Checkout.Session;

      const parcelaId = session.metadata?.parcela_id;

      if (!parcelaId) {
        console.error('parcela_id não encontrado nos metadados');
        return new Response('Parcela ID não encontrado', { status: 400 });
      }

      // Atualizar parcela como paga
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
            stripe_payment_status: 'paid',
            stripe_payment_intent_id: session.payment_intent,
            stripe_paid_at: new Date().toISOString(),
            status: 'pago',
            data_pagamento: new Date().toISOString(),
          }),
        }
      );

      if (!updateResponse.ok) {
        const error = await updateResponse.text();
        console.error('Erro ao atualizar parcela:', error);
        throw new Error('Falha ao atualizar parcela');
      }

      console.log(`Parcela ${parcelaId} marcada como paga`);
    }

    if (event.type === 'payment_link.expired') {
      const paymentLink = event.data.object as Stripe.PaymentLink;

      // Atualizar status para expirado
      const supabaseUrl = Deno.env.get('SUPABASE_URL');
      const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

      if (!supabaseUrl || !supabaseKey) {
        throw new Error('Supabase credentials not found');
      }

      const updateResponse = await fetch(
        `${supabaseUrl}/rest/v1/financeiro_parcelas?stripe_payment_link_id=eq.${paymentLink.id}`,
        {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json',
            'apikey': supabaseKey,
            'Authorization': `Bearer ${supabaseKey}`,
            'Prefer': 'return=minimal',
          },
          body: JSON.stringify({
            stripe_payment_status: 'expired',
          }),
        }
      );

      if (!updateResponse.ok) {
        const error = await updateResponse.text();
        console.error('Erro ao atualizar status:', error);
      }
    }

    return new Response(JSON.stringify({ received: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Erro no webhook:', error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
});
