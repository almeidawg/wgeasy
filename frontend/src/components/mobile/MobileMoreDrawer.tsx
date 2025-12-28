// ============================================================
// MobileMoreDrawer - Sheet/Drawer com mais opções do menu
// Sistema WG Easy - Grupo WG Almeida
// Abre de baixo para cima (bottom sheet)
// CORRIGIDO: Usa wgMenus completo igual ao Sidebar
// ============================================================

import { useEffect, useMemo } from "react";
import { NavLink } from "react-router-dom";
import {
  X,
  ChevronRight,
  Sparkles,
  LayoutDashboard,
  Users,
  BadgeDollarSign,
  FileText,
  ClipboardList,
  FolderKanban,
  Building2,
  CalendarCheck,
  CheckSquare,
  Coins,
  Box,
  Store,
  Home,
  BarChart3,
  Settings,
  Wallet,
  LogOut,
  Scale,
  ShoppingCart,
  Wrench,
  Circle,
} from "lucide-react";
import wgMenus, { MenuSection } from "@/config/wg-menus";
import { useUsuarioLogado } from "@/hooks/useUsuarioLogado";

interface MobileMoreDrawerProps {
  open: boolean;
  onClose: () => void;
}

// Mapeamento de seções permitidas por tipo de usuário restrito
// JURIDICO e FINANCEIRO só veem seu módulo específico
const MENU_POR_TIPO: Record<string, string[]> = {
  JURIDICO: ["Jurídico", "Sessão"],
  FINANCEIRO: ["Financeiro", "Sessão"],
};

// Função para obter ícone da seção
function getSectionIcon(section: string) {
  const size = 18;
  const sectionLower = section.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

  switch (sectionLower) {
    case "dashboard":
      return <LayoutDashboard size={size} />;
    case "pessoas":
      return <Users size={size} />;
    case "oportunidades":
      return <BadgeDollarSign size={size} />;
    case "comercial":
      return <FileText size={size} />;
    case "nucleos":
      return <FolderKanban size={size} />;
    case "planejamento":
      return <ClipboardList size={size} />;
    case "cronograma":
      return <CalendarCheck size={size} />;
    case "wg experience":
      return <CheckSquare size={size} />;
    case "financeiro":
      return <Coins size={size} />;
    case "deposito wg":
      return <Box size={size} />;
    case "wg store":
      return <Store size={size} />;
    case "area do cliente":
      return <Home size={size} />;
    case "onboarding":
      return <BarChart3 size={size} />;
    case "sistema":
      return <Settings size={size} />;
    case "pos vendas":
      return <Wallet size={size} />;
    case "sessao":
      return <LogOut size={size} />;
    case "juridico":
      return <Scale size={size} />;
    default:
      return <Circle size={size} />;
  }
}

// Função para obter ícone do item
function getItemIcon(label: string, section: string) {
  const size = 18;
  const labelLower = label.toLowerCase();

  // Ícones específicos por label
  if (labelLower.includes("compra")) return <ShoppingCart size={size} />;
  if (labelLower.includes("assistência") || labelLower.includes("assistencia")) return <Wrench size={size} />;

  // Fallback para ícone da seção
  return getSectionIcon(section);
}

export default function MobileMoreDrawer({ open, onClose }: MobileMoreDrawerProps) {
  const { usuario } = useUsuarioLogado();

  // Filtrar menus baseado no tipo de usuário (mesma lógica do Sidebar)
  const filteredMenus = useMemo(() => {
    const tipoUsuario = usuario?.tipo_usuario;

    // Se for tipo restrito (JURIDICO ou FINANCEIRO), filtrar menus
    if (tipoUsuario && MENU_POR_TIPO[tipoUsuario]) {
      const secoesPermitidas = MENU_POR_TIPO[tipoUsuario];
      return wgMenus.filter((section: MenuSection) =>
        secoesPermitidas.includes(section.section)
      );
    }

    // Tipos com acesso total (MASTER, ADMIN, COMERCIAL, etc)
    // Excluir Dashboard pois já está na barra inferior
    return wgMenus.filter((section: MenuSection) =>
      section.section !== "Dashboard"
    );
  }, [usuario?.tipo_usuario]);

  // Bloquear scroll quando aberto
  useEffect(() => {
    if (open) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [open]);

  // Fechar com ESC
  useEffect(() => {
    const handleEsc = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    if (open) {
      document.addEventListener("keydown", handleEsc);
    }
    return () => document.removeEventListener("keydown", handleEsc);
  }, [open, onClose]);

  if (!open) return null;

  return (
    <>
      {/* Overlay */}
      <div
        className="mobile-drawer-overlay"
        onClick={onClose}
        aria-hidden="true"
      />

      {/* Drawer */}
      <div className="mobile-drawer">
        {/* Handle bar */}
        <div className="mobile-drawer-handle">
          <div className="mobile-drawer-handle-bar" />
        </div>

        {/* Header */}
        <div className="mobile-drawer-header">
          <div className="flex items-center gap-2">
            <Sparkles size={18} className="text-wg-primary" />
            <h2 className="font-oswald text-lg font-bold text-gray-900">
              Menu Completo
            </h2>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="mobile-drawer-close"
            aria-label="Fechar"
          >
            <X size={20} />
          </button>
        </div>

        {/* Content */}
        <div className="mobile-drawer-content">
          {filteredMenus.map((section) => (
            <div key={section.section} className="mobile-drawer-section">
              <h3 className="mobile-drawer-section-title">
                <span className="flex items-center gap-2">
                  {getSectionIcon(section.section)}
                  {section.section}
                </span>
              </h3>
              <div className="mobile-drawer-items">
                {section.items.map((item) => {
                  const isLogout = item.path === "/logout";
                  return (
                    <NavLink
                      key={item.path}
                      to={item.path}
                      onClick={onClose}
                      className={({ isActive }) =>
                        `mobile-drawer-item ${isActive ? "active" : ""} ${isLogout ? "text-red-500" : ""}`
                      }
                    >
                      {getItemIcon(item.label, section.section)}
                      <span className="flex-1">{item.label}</span>
                      <ChevronRight size={16} className="text-gray-400" />
                    </NavLink>
                  );
                })}
              </div>
            </div>
          ))}
        </div>
      </div>
    </>
  );
}
