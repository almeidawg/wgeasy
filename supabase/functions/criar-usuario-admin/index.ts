// Edge Function para criar usuário no Supabase Auth já confirmado
// Usa a Admin API que permite criar usuários sem necessidade de confirmação de email
// Senha personalizada: 3 dígitos CPF + 3 letras Nome + 3 dígitos Telefone (ex: 342Wil991)

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";

// Gera senha personalizada baseada nos dados do usuário
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
    // Verificar o token e obter o usuário
    const { data: { user }, error } = await supabaseAdmin.auth.getUser(token);

    if (error || !user) {
      return { autorizado: false, erro: 'Token inválido ou expirado' };
    }

    // Verificar se é MASTER ou ADMIN na tabela usuarios
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

    // Criar cliente com service role key (permissões admin)
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

    const { email, senha, pessoa_id, tipo_usuario } = await req.json();

    // Validações
    if (!email || !email.includes('@')) {
      return new Response(
        JSON.stringify({ sucesso: false, erro: 'Email inválido' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (!senha || senha.length < 6) {
      return new Response(
        JSON.stringify({ sucesso: false, erro: 'Senha deve ter pelo menos 6 caracteres' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (!pessoa_id) {
      return new Response(
        JSON.stringify({ sucesso: false, erro: 'pessoa_id é obrigatório' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Verificar se pessoa existe
    const { data: pessoa, error: pessoaError } = await supabaseAdmin
      .from('pessoas')
      .select('id, nome, cpf, email')
      .eq('id', pessoa_id)
      .single();

    if (pessoaError || !pessoa) {
      return new Response(
        JSON.stringify({ sucesso: false, erro: 'Pessoa não encontrada' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Verificar se já existe usuário para esta pessoa
    const { data: usuarioExistente } = await supabaseAdmin
      .from('usuarios')
      .select('id')
      .eq('pessoa_id', pessoa_id)
      .single();

    if (usuarioExistente) {
      return new Response(
        JSON.stringify({
          sucesso: false,
          erro: 'Já existe usuário para esta pessoa',
          usuario_id: usuarioExistente.id
        }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Verificar se email já existe no Auth
    const { data: authExistente } = await supabaseAdmin.auth.admin.listUsers();
    const emailExiste = authExistente?.users?.find(u => u.email?.toLowerCase() === email.toLowerCase());

    if (emailExiste) {
      // Usuário já existe no Auth, apenas criar registro na tabela usuarios
      const { data: novoUsuario, error: insertError } = await supabaseAdmin
        .from('usuarios')
        .insert({
          auth_user_id: emailExiste.id,
          pessoa_id: pessoa_id,
          cpf: pessoa.cpf || '',
          tipo_usuario: tipo_usuario || 'CLIENTE',
          ativo: true,
          primeiro_acesso: true,
          cliente_pode_ver_valores: false,
          cliente_pode_ver_cronograma: true,
          cliente_pode_ver_documentos: true,
          cliente_pode_ver_proposta: true,
          cliente_pode_ver_contratos: true,
          cliente_pode_fazer_upload: false,
          cliente_pode_comentar: true,
          criado_em: new Date().toISOString(),
          atualizado_em: new Date().toISOString(),
        })
        .select()
        .single();

      if (insertError) {
        console.error('Erro ao inserir usuario:', insertError);
        return new Response(
          JSON.stringify({ sucesso: false, erro: insertError.message }),
          { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      return new Response(
        JSON.stringify({
          sucesso: true,
          usuario_id: novoUsuario.id,
          auth_user_id: emailExiste.id,
          mensagem: 'Email já existia no Auth. Vinculado à pessoa. Use recuperação de senha para obter acesso.',
          ja_existia: true,
        }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // CRIAR USUÁRIO NO AUTH JÁ CONFIRMADO
    const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: email.toLowerCase().trim(),
      password: senha,
      email_confirm: true, // JÁ CONFIRMA O EMAIL!
      user_metadata: {
        tipo_usuario: tipo_usuario || 'CLIENTE',
        pessoa_id: pessoa_id,
        nome: pessoa.nome,
      },
    });

    if (authError || !authUser?.user) {
      console.error('Erro ao criar auth user:', authError);
      return new Response(
        JSON.stringify({ sucesso: false, erro: authError?.message || 'Erro ao criar usuário no Auth' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Criar registro na tabela usuarios
    const { data: novoUsuario, error: usuarioError } = await supabaseAdmin
      .from('usuarios')
      .insert({
        auth_user_id: authUser.user.id,
        pessoa_id: pessoa_id,
        cpf: pessoa.cpf || '',
        tipo_usuario: tipo_usuario || 'CLIENTE',
        ativo: true,
        primeiro_acesso: true,
        cliente_pode_ver_valores: false,
        cliente_pode_ver_cronograma: true,
        cliente_pode_ver_documentos: true,
        cliente_pode_ver_proposta: true,
        cliente_pode_ver_contratos: true,
        cliente_pode_fazer_upload: false,
        cliente_pode_comentar: true,
        criado_em: new Date().toISOString(),
        atualizado_em: new Date().toISOString(),
      })
      .select()
      .single();

    if (usuarioError) {
      console.error('Erro ao inserir usuario:', usuarioError);
      // Não falhar, o auth user foi criado - o trigger pode ter criado o registro
    }

    return new Response(
      JSON.stringify({
        sucesso: true,
        usuario_id: novoUsuario?.id || null,
        auth_user_id: authUser.user.id,
        email: email.toLowerCase(),
        mensagem: 'Usuário criado com sucesso! Pode fazer login imediatamente.',
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
