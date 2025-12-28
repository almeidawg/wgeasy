import { useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { LogOut, User as UserIcon } from "lucide-react";
import { useAuth } from "@/auth/AuthContext";
import { supabase } from "@/lib/supabaseClient";
import NotificationBell from "@/components/layout/NotificationBell";
import { useUsuarioLogado } from "@/hooks/useUsuarioLogado";
import { TIPOS_USUARIO } from "@/lib/permissoesModuloApi";

export default function Topbar() {
  const { user } = useAuth();
  const { usuario } = useUsuarioLogado();
  const navigate = useNavigate();
  const [open, setOpen] = useState(false);

  // Usar nome do usuário logado se disponível
  const nome = useMemo(() => {
    if (usuario?.nome) return usuario.nome;
    if (user?.user_metadata?.full_name) return user.user_metadata.full_name;
    if (user?.email) return user.email;
    return "Usuário";
  }, [user, usuario]);

  // URL do avatar do usuário
  const avatarUrl = usuario?.avatar_url;

  const iniciais = useMemo(() => {
    const parts = nome.trim().split(/\s+/);
    if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }, [nome]);

  // Label do tipo de usuário para exibição
  const tipoUsuarioLabel = useMemo(() => {
    if (!usuario?.tipo_usuario) return null;
    const tipo = TIPOS_USUARIO.find(t => t.value === usuario.tipo_usuario);
    return tipo?.label || usuario.tipo_usuario;
  }, [usuario?.tipo_usuario]);

  async function handleSignOut() {
    setOpen(false);
    await supabase.auth.signOut();
    navigate("/login");
  }

  function handleUserClick() {
    if (!user) {
      navigate("/login");
    } else {
      setOpen((v) => !v);
    }
  }

  return (
    <header className="topbar" style={{ padding: '8px 16px', minHeight: 'auto' }}>
      {/* Espaço vazio à esquerda para manter alinhamento */}
      <div className="topbar-left" />

      {/* Sino + Avatar + Nome + Função - tudo em linha */}
      <div className="flex items-center gap-3">
        {/* Sino de notificações */}
        {user && <NotificationBell />}

        <div className="relative">
          <button
            type="button"
            onClick={handleUserClick}
            className="flex items-center gap-3 px-2 py-1.5 rounded-lg hover:bg-gray-50 transition-colors"
          >
            {/* Avatar */}
            {user ? (
              avatarUrl ? (
                <img
                  src={avatarUrl}
                  alt={nome}
                  className="w-9 h-9 rounded-full object-cover border-2 border-orange-500/30 shadow-md"
                />
              ) : (
                <div className="w-9 h-9 rounded-full bg-gradient-to-br from-orange-500 to-orange-600 text-white flex items-center justify-center text-sm font-bold border-2 border-orange-500/30 shadow-md">
                  {iniciais}
                </div>
              )
            ) : (
              <div className="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center border border-gray-200">
                <UserIcon size={16} className="text-gray-500" />
              </div>
            )}

            {/* Nome e Função na mesma linha */}
            <div className="flex items-center gap-2">
              <span className="text-sm font-semibold text-gray-900">{user ? nome : "Entrar"}</span>
              {user && tipoUsuarioLabel && (
                <span className="text-xs text-gray-500 font-medium">
                  {tipoUsuarioLabel}
                </span>
              )}
            </div>
          </button>

          {open && user && (
            <div className="user-menu">
              <div className="user-email">{user.email}</div>
              <button
                type="button"
                onClick={handleSignOut}
                className="user-menu-item"
              >
                <LogOut size={16} />
                Sair
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
