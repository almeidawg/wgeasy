// Edge Function para vincular usuários existentes que estão na tabela usuarios
// mas não têm auth_user_id (não foram criados no Auth corretamente)
// Cria os usuários no Auth e vincula automaticamente

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

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
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error('Supabase credentials not configured');
    }

    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    const { modo, usuario_id, senha_padrao } = await req.json();

    // Modo 1: Listar usuários sem auth
    if (modo === 'listar') {
      const { data: usuarios, error } = await supabaseAdmin
        .from('usuarios')
        .select(`
          id,
          pessoa_id,
          auth_user_id,
          tipo_usuario,
          ativo,
          pessoas:pessoa_id (
            id,
            nome,
            email,
            cpf,
            telefone
          )
        `)
        .is('auth_user_id', null)
        .order('criado_em', { ascending: false });

      if (error) {
        throw error;
      }

      return new Response(
        JSON.stringify({
          sucesso: true,
          total: usuarios?.length || 0,
          usuarios: usuarios?.map(u => ({
            usuario_id: u.id,
            pessoa_id: u.pessoa_id,
            tipo_usuario: u.tipo_usuario,
            ativo: u.ativo,
            nome: u.pessoas?.nome,
            email: u.pessoas?.email,
            cpf: u.pessoas?.cpf,
            telefone: u.pessoas?.telefone,
            tem_email: !!u.pessoas?.email,
          })),
        }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Modo 2: Corrigir um usuário específico
    if (modo === 'corrigir' && usuario_id) {
      // Buscar dados do usuário
      const { data: usuario, error: usuarioError } = await supabaseAdmin
        .from('usuarios')
        .select(`
          id,
          pessoa_id,
          auth_user_id,
          tipo_usuario,
          pessoas:pessoa_id (
            id,
            nome,
            email,
            cpf,
            telefone
          )
        `)
        .eq('id', usuario_id)
        .single();

      if (usuarioError || !usuario) {
        return new Response(
          JSON.stringify({ sucesso: false, erro: 'Usuário não encontrado' }),
          { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      if (usuario.auth_user_id) {
        return new Response(
          JSON.stringify({
            sucesso: false,
            erro: 'Usuário já tem auth_user_id vinculado',
            auth_user_id: usuario.auth_user_id,
          }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const email = usuario.pessoas?.email;
      if (!email) {
        return new Response(
          JSON.stringify({
            sucesso: false,
            erro: 'Pessoa não tem email cadastrado. Cadastre o email primeiro.',
          }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Verificar se email já existe no Auth
      const { data: authUsers } = await supabaseAdmin.auth.admin.listUsers();
      const authExistente = authUsers?.users?.find(
        u => u.email?.toLowerCase() === email.toLowerCase()
      );

      if (authExistente) {
        // Apenas vincular
        const { error: updateError } = await supabaseAdmin
          .from('usuarios')
          .update({
            auth_user_id: authExistente.id,
            atualizado_em: new Date().toISOString(),
          })
          .eq('id', usuario_id);

        if (updateError) {
          throw updateError;
        }

        return new Response(
          JSON.stringify({
            sucesso: true,
            auth_user_id: authExistente.id,
            mensagem: 'Usuário vinculado! Email já existia no Auth. Use recuperação de senha.',
            ja_existia: true,
          }),
          { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Criar novo usuário no Auth - Senha: 3 dígitos CPF + 3 letras Nome + 3 dígitos Telefone
      const senha = senha_padrao || gerarSenhaPersonalizada(
        usuario.pessoas?.cpf,
        usuario.pessoas?.nome,
        usuario.pessoas?.telefone
      );

      const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
        email: email.toLowerCase().trim(),
        password: senha,
        email_confirm: true,
        user_metadata: {
          tipo_usuario: usuario.tipo_usuario,
          pessoa_id: usuario.pessoa_id,
          nome: usuario.pessoas?.nome,
        },
      });

      if (authError || !authUser?.user) {
        return new Response(
          JSON.stringify({ sucesso: false, erro: authError?.message || 'Erro ao criar no Auth' }),
          { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Vincular
      const { error: updateError } = await supabaseAdmin
        .from('usuarios')
        .update({
          auth_user_id: authUser.user.id,
          atualizado_em: new Date().toISOString(),
        })
        .eq('id', usuario_id);

      if (updateError) {
        console.error('Erro ao vincular:', updateError);
      }

      return new Response(
        JSON.stringify({
          sucesso: true,
          usuario_id: usuario_id,
          auth_user_id: authUser.user.id,
          email: email,
          senha: senha,
          mensagem: 'Usuário criado e vinculado com sucesso!',
        }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Modo 3: Corrigir TODOS os usuários sem auth
    if (modo === 'corrigir_todos') {
      const { data: usuarios, error } = await supabaseAdmin
        .from('usuarios')
        .select(`
          id,
          pessoa_id,
          tipo_usuario,
          pessoas:pessoa_id (
            id,
            nome,
            email,
            cpf,
            telefone
          )
        `)
        .is('auth_user_id', null);

      if (error) {
        throw error;
      }

      const resultados: any[] = [];

      for (const usuario of usuarios || []) {
        const email = usuario.pessoas?.email;

        if (!email) {
          resultados.push({
            usuario_id: usuario.id,
            nome: usuario.pessoas?.nome,
            status: 'erro',
            erro: 'Sem email cadastrado',
          });
          continue;
        }

        try {
          // Verificar se email já existe no Auth
          const { data: authUsers } = await supabaseAdmin.auth.admin.listUsers();
          const authExistente = authUsers?.users?.find(
            u => u.email?.toLowerCase() === email.toLowerCase()
          );

          if (authExistente) {
            // Apenas vincular
            await supabaseAdmin
              .from('usuarios')
              .update({
                auth_user_id: authExistente.id,
                atualizado_em: new Date().toISOString(),
              })
              .eq('id', usuario.id);

            resultados.push({
              usuario_id: usuario.id,
              nome: usuario.pessoas?.nome,
              email: email,
              status: 'vinculado',
              mensagem: 'Vinculado a auth existente. Use recuperação de senha.',
            });
          } else {
            // Criar novo - Senha: 3 dígitos CPF + 3 letras Nome + 3 dígitos Telefone
            const senha = senha_padrao || gerarSenhaPersonalizada(
              usuario.pessoas?.cpf,
              usuario.pessoas?.nome,
              usuario.pessoas?.telefone
            );

            const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
              email: email.toLowerCase().trim(),
              password: senha,
              email_confirm: true,
              user_metadata: {
                tipo_usuario: usuario.tipo_usuario,
                pessoa_id: usuario.pessoa_id,
                nome: usuario.pessoas?.nome,
              },
            });

            if (authError || !authUser?.user) {
              resultados.push({
                usuario_id: usuario.id,
                nome: usuario.pessoas?.nome,
                email: email,
                status: 'erro',
                erro: authError?.message || 'Erro ao criar no Auth',
              });
              continue;
            }

            await supabaseAdmin
              .from('usuarios')
              .update({
                auth_user_id: authUser.user.id,
                atualizado_em: new Date().toISOString(),
              })
              .eq('id', usuario.id);

            resultados.push({
              usuario_id: usuario.id,
              nome: usuario.pessoas?.nome,
              email: email,
              senha: senha,
              status: 'criado',
              mensagem: 'Criado e vinculado!',
            });
          }
        } catch (err: any) {
          resultados.push({
            usuario_id: usuario.id,
            nome: usuario.pessoas?.nome,
            status: 'erro',
            erro: err.message,
          });
        }
      }

      return new Response(
        JSON.stringify({
          sucesso: true,
          total: usuarios?.length || 0,
          processados: resultados.length,
          criados: resultados.filter(r => r.status === 'criado').length,
          vinculados: resultados.filter(r => r.status === 'vinculado').length,
          erros: resultados.filter(r => r.status === 'erro').length,
          resultados,
        }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({
        sucesso: false,
        erro: 'Modo inválido. Use: listar, corrigir, ou corrigir_todos',
      }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('Erro na Edge Function:', error);
    return new Response(
      JSON.stringify({ sucesso: false, erro: error.message || 'Erro interno' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});

// Gera senha personalizada: 3 dígitos CPF + 3 letras Nome + 3 dígitos Telefone
// Exemplo: 342Wil991
function gerarSenhaPersonalizada(cpf?: string, nome?: string, telefone?: string): string {
  const cpfLimpo = (cpf || "").replace(/[^0-9]/g, "");
  const cpfParte = cpfLimpo.substring(0, 3).padEnd(3, "0");

  const nomeLimpo = (nome || "Usuario").replace(/[^a-zA-ZÀ-ÿ]/g, "");
  const nomeParte = nomeLimpo.substring(0, 1).toUpperCase() +
                    nomeLimpo.substring(1, 3).toLowerCase();

  const telLimpo = (telefone || "").replace(/[^0-9]/g, "");
  const telParte = telLimpo.length >= 3
    ? telLimpo.substring(telLimpo.length - 3)
    : telLimpo.padStart(3, "1");

  return cpfParte + nomeParte + telParte;
}
