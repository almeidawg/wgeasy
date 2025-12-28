/**
 * Layout para Área do Fornecedor
 * Layout simples e objetivo para fornecedores externos
 */

import { Outlet, Link, useLocation, useNavigate } from "react-router-dom";
import { useAuth } from "@/auth/AuthContext";
import {
  LayoutDashboard,
  FileSearch,
  Wallet,
  Briefcase,
  LogOut,
  Menu,
  X,
  Bell,
  User,
  ChevronDown,
} from "lucide-react";
import { useState } from "react";
import { cn } from "@/lib/utils";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

const menuItems = [
  {
    label: "Início",
    href: "/fornecedor",
    icon: LayoutDashboard,
  },
  {
    label: "Cotações",
    href: "/fornecedor/cotacoes",
    icon: FileSearch,
  },
  {
    label: "Meus Serviços",
    href: "/fornecedor/servicos",
    icon: Briefcase,
  },
  {
    label: "Financeiro",
    href: "/fornecedor/financeiro",
    icon: Wallet,
  },
];

export default function FornecedorLayout() {
  const { user, logout, usuarioCompleto } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const handleLogout = async () => {
    await logout();
    navigate("/login");
  };

  const getInitials = (name?: string) => {
    if (!name) return "F";
    return name
      .split(" ")
      .map((n) => n[0])
      .join("")
      .toUpperCase()
      .slice(0, 2);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-white border-b border-gray-200 shadow-sm">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            {/* Logo */}
            <div className="flex items-center gap-3">
              <Link to="/fornecedor" className="flex items-center gap-2">
                <div className="w-8 h-8 bg-[#F25C26] rounded-lg flex items-center justify-center">
                  <span className="text-white font-bold text-sm">WG</span>
                </div>
                <div className="hidden sm:block">
                  <span className="font-semibold text-gray-900">Portal do</span>
                  <span className="font-semibold text-[#F25C26] ml-1">
                    Fornecedor
                  </span>
                </div>
              </Link>
            </div>

            {/* Desktop Navigation */}
            <nav className="hidden md:flex items-center gap-1">
              {menuItems.map((item) => {
                const Icon = item.icon;
                const isActive = location.pathname === item.href;
                return (
                  <Link
                    key={item.href}
                    to={item.href}
                    className={cn(
                      "flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors",
                      isActive
                        ? "bg-[#F25C26]/10 text-[#F25C26]"
                        : "text-gray-600 hover:bg-gray-100 hover:text-gray-900"
                    )}
                  >
                    <Icon className="h-4 w-4" />
                    {item.label}
                  </Link>
                );
              })}
            </nav>

            {/* Right side */}
            <div className="flex items-center gap-3">
              {/* Notificações */}
              <Button variant="ghost" size="icon" className="relative">
                <Bell className="h-5 w-5 text-gray-500" />
              </Button>

              {/* User Menu */}
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button
                    variant="ghost"
                    className="flex items-center gap-2 px-2"
                  >
                    <Avatar className="h-8 w-8">
                      <AvatarImage src={usuarioCompleto?.avatar_url} />
                      <AvatarFallback className="bg-[#F25C26] text-white text-xs">
                        {getInitials(usuarioCompleto?.nome)}
                      </AvatarFallback>
                    </Avatar>
                    <div className="hidden sm:block text-left">
                      <p className="text-sm font-medium text-gray-900 truncate max-w-[120px]">
                        {usuarioCompleto?.empresa ||
                          usuarioCompleto?.nome?.split(" ")[0] ||
                          "Fornecedor"}
                      </p>
                    </div>
                    <ChevronDown className="h-4 w-4 text-gray-400" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-56">
                  <div className="px-3 py-2">
                    <p className="text-sm font-medium text-gray-900">
                      {usuarioCompleto?.nome}
                    </p>
                    <p className="text-xs text-gray-500">
                      {usuarioCompleto?.email}
                    </p>
                  </div>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem asChild>
                    <Link to="/fornecedor/perfil" className="cursor-pointer">
                      <User className="h-4 w-4 mr-2" />
                      Meus Dados
                    </Link>
                  </DropdownMenuItem>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem
                    onClick={handleLogout}
                    className="text-red-600 cursor-pointer"
                  >
                    <LogOut className="h-4 w-4 mr-2" />
                    Sair
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>

              {/* Mobile menu button */}
              <Button
                variant="ghost"
                size="icon"
                className="md:hidden"
                onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              >
                {mobileMenuOpen ? (
                  <X className="h-6 w-6" />
                ) : (
                  <Menu className="h-6 w-6" />
                )}
              </Button>
            </div>
          </div>
        </div>

        {/* Mobile Navigation */}
        {mobileMenuOpen && (
          <div className="md:hidden border-t border-gray-200 bg-white">
            <nav className="px-4 py-3 space-y-1">
              {menuItems.map((item) => {
                const Icon = item.icon;
                const isActive = location.pathname === item.href;
                return (
                  <Link
                    key={item.href}
                    to={item.href}
                    onClick={() => setMobileMenuOpen(false)}
                    className={cn(
                      "flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-colors",
                      isActive
                        ? "bg-[#F25C26]/10 text-[#F25C26]"
                        : "text-gray-600 hover:bg-gray-100"
                    )}
                  >
                    <Icon className="h-5 w-5" />
                    {item.label}
                  </Link>
                );
              })}
            </nav>
          </div>
        )}
      </header>

      {/* Main Content */}
      <main className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <Outlet />
      </main>

      {/* Footer */}
      <footer className="border-t border-gray-200 bg-white mt-auto">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <p className="text-center text-sm text-gray-500">
            Portal do Fornecedor WG &copy; {new Date().getFullYear()} - Grupo WG
            Almeida
          </p>
        </div>
      </footer>
    </div>
  );
}
