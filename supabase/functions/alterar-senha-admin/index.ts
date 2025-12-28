// Edge Function para alterar senha de usuário no Supabase Auth
// Usa a Admin API para alteração direta sem necessidade de email de confirmação

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-wg-app, x-wg-version',
};

// Função para verificar se o usuário chamador tem permissão admin
async function verificarPermissaoAdmin(supabaseAdmin: any, authHeader: string | null): Promise<{ autorizado: boolean; erro?: string }> {
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return { autorizado: false, erro: 'Token de autenticação não fornecido' };
  }

  const token = authHeader.replace('Bearer ', '');

  try {
    const { data: { user }, error } = await supabaseAdmin.auth.getUser(token);

    if (error || !user) {
      return { autorizado: false, erro: 'Token inválido ou expirado' };
    }

    const { data: usuario } = await supabaseAdmin
      .from('usuarios')
      .select('tipo_usuario, ativo')
      .eq('auth_user_id', user.id)
      .single();

    if (!usuario || !usuario.ativo) {
      return { autorizado: false, erro: 'Usuário não encontrado ou inativo' };
    }

    if (!['MASTER', 'ADMIN'].includes(usuario.tipo_usuario)) {
      return { autorizado: false, erro: 'Permissão negada. Apenas MASTER e ADMIN podem executar esta ação.' };
    }

    return { autorizado: true };
  } catch (err) {
    console.error('Erro ao verificar permissão:', err);
    return { autorizado: false, erro: 'Erro ao verificar permissão' };
  }
}

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

    // Criar cliente com service role key (permissoes admin)
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    // VERIFICAR PERMISSÃO DO CHAMADOR
    const authHeader = req.headers.get('authorization');
    const permissao = await verificarPermissaoAdmin(supabaseAdmin, authHeader);

    if (!permissao.autorizado) {
      return new Response(
        JSON.stringify({ sucesso: false, erro: permissao.erro }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const { auth_user_id, email, nova_senha, usuario_id } = await req.json();

    // Validacoes
    if (!nova_senha || nova_senha.length < 6) {
      return new Response(
        JSON.stringify({ sucesso: false, erro: 'Nova senha deve ter pelo menos 6 caracteres' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Precisamos do auth_user_id ou email para identificar o usuario
    let targetAuthUserId = auth_user_id;

    // Se nao tiver auth_user_id, tentar buscar pelo email ou usuario_id
    if (!targetAuthUserId) {
      if (email) {
        // Buscar pelo email no Auth
        const { data: authUsers } = await supabaseAdmin.auth.admin.listUsers();
        const authUser = authUsers?.users?.find(
          u => u.email?.toLowerCase() === email.toLowerCase()
        );
        if (authUser) {
          targetAuthUserId = authUser.id;
        }
      } else if (usuario_id) {
        // Buscar na tabela usuarios
        const { data: usuario } = await supabaseAdmin
          .from('usuarios')
          .select('auth_user_id')
          .eq('id', usuario_id)
          .single();

        if (usuario?.auth_user_id) {
          targetAuthUserId = usuario.auth_user_id;
        }
      }
    }

    if (!targetAuthUserId) {
      return new Response(
        JSON.stringify({
          sucesso: false,
          erro: 'Usuario nao encontrado no Auth. Forneça auth_user_id, email ou usuario_id.'
        }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Alterar senha usando Admin API
    const { data: updatedUser, error: updateError } = await supabaseAdmin.auth.admin.updateUserById(
      targetAuthUserId,
      { password: nova_senha }
    );

    if (updateError) {
      console.error('Erro ao alterar senha:', updateError);
      return new Response(
        JSON.stringify({ sucesso: false, erro: updateError.message || 'Erro ao alterar senha' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Opcional: Marcar primeiro_acesso como true para forcar troca de senha no proximo login
    if (usuario_id) {
      await supabaseAdmin
        .from('usuarios')
        .update({
          primeiro_acesso: true,
          atualizado_em: new Date().toISOString()
        })
        .eq('id', usuario_id);
    } else if (targetAuthUserId) {
      await supabaseAdmin
        .from('usuarios')
        .update({
          primeiro_acesso: true,
          atualizado_em: new Date().toISOString()
        })
        .eq('auth_user_id', targetAuthUserId);
    }

    return new Response(
      JSON.stringify({
        sucesso: true,
        auth_user_id: targetAuthUserId,
        email: updatedUser?.user?.email,
        mensagem: 'Senha alterada com sucesso! O usuario pode logar com a nova senha imediatamente.',
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('Erro na Edge Function:', error);
    return new Response(
      JSON.stringify({ sucesso: false, erro: error.message || 'Erro interno' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
