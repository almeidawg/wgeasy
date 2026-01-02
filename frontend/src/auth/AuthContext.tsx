import { createContext, useContext, useEffect, useState, ReactNode, useRef } from "react";
import { supabaseRaw as supabase } from "@/lib/supabaseClient";
import { User } from "@supabase/supabase-js";

// Função para registrar acesso ao sistema
async function registrarAcessoSistema(user: User) {
  try {
    // Buscar nome do usuário
    const { data: pessoa } = await supabase
      .from("pessoas")
      .select("nome, tipo")
      .eq("email", user.email)
      .maybeSingle();

    const nomeUsuario = pessoa?.nome || user.email?.split("@")[0] || "Usuário";
    const tipoUsuario = pessoa?.tipo || "colaborador";

    // Atualizar último acesso na tabela usuarios
    const { error: updateError } = await supabase
      .from("usuarios")
      .update({ ultimo_acesso: new Date().toISOString() })
      .eq("auth_user_id", user.id);

    if (updateError) {
      console.warn("[Auth] Erro ao atualizar ultimo_acesso:", updateError);
    } else {
      console.log("[Auth] Último acesso atualizado para:", user.email);
    }

    // Criar notificação de acesso para admins
    await supabase.from("notificacoes_sistema").insert({
      tipo: "acesso_sistema",
      titulo: `${nomeUsuario} acessou o sistema`,
      mensagem: `Acesso registrado em ${new Date().toLocaleString("pt-BR")}`,
      referencia_tipo: "acesso",
      dados: { user_id: user.id, tipo_usuario: tipoUsuario }
    });

    console.log("[Auth] Acesso registrado para:", nomeUsuario);
  } catch (err) {
    console.warn("[Auth] Erro ao registrar acesso:", err);
  }
}

interface UsuarioCompleto {
  id: string;
  nome: string;
  email: string;
  pessoa_id?: string | null;
  tipo: string;
  avatar_url?: string;
  cargo?: string;
  empresa?: string;
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  logout: () => Promise<void>;
  usuarioCompleto: UsuarioCompleto | null;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [usuarioCompleto, setUsuarioCompleto] = useState<UsuarioCompleto | null>(null);

  // Função de logout
  const logout = async () => {
    await supabase.auth.signOut();
    setUser(null);
    setUsuarioCompleto(null);
  };

  // Carregar dados completos do usuário
  const carregarUsuarioCompleto = async (authUser: User) => {
    try {
      const { data: pessoa } = await supabase
        .from("pessoas")
        .select("id, nome, email, tipo, avatar_url, cargo, empresa")
        .eq("email", authUser.email)
        .maybeSingle();

      if (pessoa) {
        setUsuarioCompleto({
          id: pessoa.id,
          pessoa_id: pessoa.id,
          nome: pessoa.nome,
          email: pessoa.email,
          tipo: pessoa.tipo,
          avatar_url: pessoa.avatar_url,
          cargo: pessoa.cargo,
          empresa: pessoa.empresa,
        });
      }
    } catch (err) {
      console.warn("[Auth] Erro ao carregar dados completos do usuário:", err);
    }
  };

  useEffect(() => {
    async function loadSession() {
      try {
        // Primeiro, verifica se há um hash na URL (retorno do OAuth)
        const hashParams = window.location.hash;
        if (hashParams && hashParams.includes('access_token')) {
          console.log('[Auth] Detectado retorno OAuth, processando...');
          // O Supabase vai processar automaticamente o hash com detectSessionInUrl: true
          // Limpa o hash da URL após processar
          setTimeout(() => {
            window.history.replaceState(null, '', window.location.pathname);
          }, 100);
        }

        // Aguarda um pouco para o Supabase processar o hash
        await new Promise(resolve => setTimeout(resolve, 200));

        const { data, error } = await supabase.auth.getSession();

        if (error) {
          console.error('[Auth] Erro ao carregar sessão:', error);
        }

        setUser(data.session?.user || null);

        if (data.session?.user) {
          console.log('[Auth] Usuário autenticado:', data.session.user.email);
          await carregarUsuarioCompleto(data.session.user);
        }
      } catch (err) {
        console.error('[Auth] Erro inesperado:', err);
      } finally {
        setLoading(false);
      }
    }

    loadSession();

    const { data: listener } = supabase.auth.onAuthStateChange((event, session) => {
      console.log('[Auth] Estado alterado:', event, session?.user?.email);
      setUser(session?.user || null);

      // Se for um login via OAuth, redireciona para a home
      if (event === 'SIGNED_IN' && session?.user) {
        // Remove o hash da URL se existir
        if (window.location.hash) {
          window.history.replaceState(null, '', window.location.pathname || '/');
        }

        // Registrar notificação de acesso ao sistema
        registrarAcessoSistema(session.user);

        // Carregar dados completos do usuário
        carregarUsuarioCompleto(session.user);
      }

      // Limpar dados ao fazer logout
      if (event === 'SIGNED_OUT') {
        setUsuarioCompleto(null);
      }
    });

    return () => listener.subscription.unsubscribe();
  }, []);

  return (
    <AuthContext.Provider value={{ user, loading, logout, usuarioCompleto }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth(): AuthContextType {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
