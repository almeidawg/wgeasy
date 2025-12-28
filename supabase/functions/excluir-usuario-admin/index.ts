// Edge Function para excluir usuario do Supabase Auth e da tabela usuarios
// Usa a Admin API para exclusao permanente

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

    const { auth_user_id, email, usuario_id, excluir_pessoa } = await req.json();

    // Precisamos identificar o usuario
    let targetAuthUserId = auth_user_id;
    let targetUsuarioId = usuario_id;
    let targetPessoaId: string | null = null;

    // Se tiver usuario_id, buscar dados na tabela usuarios
    if (usuario_id) {
      const { data: usuario } = await supabaseAdmin
        .from('usuarios')
        .select('auth_user_id, pessoa_id')
        .eq('id', usuario_id)
        .single();

      if (usuario) {
        targetAuthUserId = usuario.auth_user_id;
        targetPessoaId = usuario.pessoa_id;
      }
    }

    // Se nao tiver auth_user_id, tentar buscar pelo email
    if (!targetAuthUserId && email) {
      const { data: authUsers } = await supabaseAdmin.auth.admin.listUsers();
      const authUser = authUsers?.users?.find(
        u => u.email?.toLowerCase() === email.toLowerCase()
      );
      if (authUser) {
        targetAuthUserId = authUser.id;
      }

      // Buscar usuario_id e pessoa_id na tabela usuarios
      if (!targetUsuarioId) {
        const { data: usuario } = await supabaseAdmin
          .from('usuarios')
          .select('id, pessoa_id')
          .eq('auth_user_id', targetAuthUserId)
          .single();

        if (usuario) {
          targetUsuarioId = usuario.id;
          targetPessoaId = usuario.pessoa_id;
        }
      }
    }

    // Resultados da exclusao
    const resultado = {
      auth_excluido: false,
      usuario_excluido: false,
      pessoa_excluida: false,
      erros: [] as string[],
    };

    // 1. Excluir do Auth (se existir)
    if (targetAuthUserId) {
      try {
        const { error: authError } = await supabaseAdmin.auth.admin.deleteUser(targetAuthUserId);

        if (authError) {
          console.error('Erro ao excluir do Auth:', authError);
          resultado.erros.push(`Auth: ${authError.message}`);
        } else {
          resultado.auth_excluido = true;
        }
      } catch (authErr: any) {
        console.error('Excecao ao excluir do Auth:', authErr);
        resultado.erros.push(`Auth: ${authErr.message}`);
      }
    }

    // 2. Excluir da tabela usuarios
    if (targetUsuarioId) {
      try {
        const { error: usuarioError } = await supabaseAdmin
          .from('usuarios')
          .delete()
          .eq('id', targetUsuarioId);

        if (usuarioError) {
          console.error('Erro ao excluir usuario:', usuarioError);
          resultado.erros.push(`Usuarios: ${usuarioError.message}`);
        } else {
          resultado.usuario_excluido = true;
        }
      } catch (usuarioErr: any) {
        console.error('Excecao ao excluir usuario:', usuarioErr);
        resultado.erros.push(`Usuarios: ${usuarioErr.message}`);
      }
    } else if (targetAuthUserId) {
      // Tentar excluir pelo auth_user_id
      try {
        const { error: usuarioError } = await supabaseAdmin
          .from('usuarios')
          .delete()
          .eq('auth_user_id', targetAuthUserId);

        if (!usuarioError) {
          resultado.usuario_excluido = true;
        }
      } catch (err) {
        // Ignorar se nao encontrou
      }
    }

    // 3. Excluir pessoa (opcional, se solicitado)
    if (excluir_pessoa && targetPessoaId) {
      try {
        // Verificar se pessoa tem outros vinculos (contratos, propostas, etc)
        const { data: vinculos } = await supabaseAdmin
          .from('contratos')
          .select('id')
          .eq('cliente_id', targetPessoaId)
          .limit(1);

        if (vinculos && vinculos.length > 0) {
          resultado.erros.push('Pessoa tem contratos vinculados. Nao foi excluida.');
        } else {
          const { error: pessoaError } = await supabaseAdmin
            .from('pessoas')
            .delete()
            .eq('id', targetPessoaId);

          if (pessoaError) {
            console.error('Erro ao excluir pessoa:', pessoaError);
            resultado.erros.push(`Pessoas: ${pessoaError.message}`);
          } else {
            resultado.pessoa_excluida = true;
          }
        }
      } catch (pessoaErr: any) {
        console.error('Excecao ao excluir pessoa:', pessoaErr);
        resultado.erros.push(`Pessoas: ${pessoaErr.message}`);
      }
    }

    // Verificar se algo foi excluido
    const algoExcluido = resultado.auth_excluido || resultado.usuario_excluido || resultado.pessoa_excluida;

    if (!algoExcluido && resultado.erros.length === 0) {
      return new Response(
        JSON.stringify({
          sucesso: false,
          erro: 'Usuario nao encontrado. Forneça auth_user_id, email ou usuario_id.',
        }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({
        sucesso: algoExcluido,
        ...resultado,
        mensagem: algoExcluido
          ? 'Usuario excluido com sucesso!'
          : 'Falha ao excluir usuario.',
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
