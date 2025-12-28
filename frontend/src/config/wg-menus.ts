// ==========================================
// WG EASY · ESTRUTURA DE MENU CORPORATIVO 2026
// Identidade Visual: WG Almeida
// ==========================================

export interface MenuItem {
  label: string;
  path: string;
  icon?: string;
  hoverColor?: string; // Cor personalizada para hover (núcleos)
}

export interface MenuSection {
  section: string;
  icon: string;
  items: MenuItem[];
  maxVisible?: number; // Limite de itens visíveis antes do "Ver mais"
}

const wgMenus: MenuSection[] = [
  {
    section: "Dashboard",
    icon: "📊",
    items: [
      { label: "Dashboard", path: "/" }
    ]
  },
  {
    section: "Pessoas",
    icon: "👥",
    maxVisible: 4,
    items: [
      { label: "Clientes", path: "/pessoas/clientes" },
      { label: "Colaboradores", path: "/pessoas/colaboradores" },
      { label: "Especificadores", path: "/pessoas/especificadores" },
      { label: "Fornecedores", path: "/pessoas/fornecedores" }
    ]
  },
  {
    section: "Oportunidades",
    icon: "🎯",
    items: [
      { label: "Oportunidades", path: "/oportunidades" }
    ]
  },
  {
    section: "Comercial",
    icon: "💼",
    maxVisible: 3,
    items: [
      { label: "Análise de Projeto", path: "/analise-projeto" },
      { label: "Propostas", path: "/propostas" },
      { label: "Contratos", path: "/contratos" }
    ]
  },
  {
    section: "Núcleos",
    icon: "🏗️",
    maxVisible: 3,
    items: [
      { label: "Arquitetura", path: "/oportunidades/kanban/arquitetura", hoverColor: "#5E9B94" }, // Verde Mineral
      { label: "Engenharia", path: "/oportunidades/kanban/engenharia", hoverColor: "#2B4580" }, // Azul Técnico
      { label: "Marcenaria", path: "/oportunidades/kanban/marcenaria", hoverColor: "#8B5E3C" } // Marrom Carvalho
    ]
  },
  {
    section: "Planejamento",
    icon: "📋",
    maxVisible: 4,
    items: [
      { label: "Modelos de Orçamento", path: "/planejamento/orcamentos/modelos" },
      { label: "Orçamentos", path: "/planejamento/orcamentos" },
      { label: "Aprovações", path: "/planejamento/aprovacoes" },
      { label: "Compras", path: "/compras" }
    ]
  },
  {
    section: "Cronograma",
    icon: "📅",
    maxVisible: 4,
    items: [
      { label: "Dashboard", path: "/cronograma" },
      { label: "Projetos", path: "/cronograma/projects" },
      { label: "Equipes", path: "/cronograma/teams" },
      { label: "Gráficos", path: "/cronograma/graficos" }
    ]
  },
  {
    section: "Financeiro",
    icon: "💰",
    maxVisible: 8,
    items: [
      { label: "Dashboard", path: "/financeiro" },
      { label: "Projetos", path: "/financeiro/obras" },
      { label: "Lançamentos", path: "/financeiro/lancamentos" },
      { label: "SDP - Solicitações", path: "/financeiro/solicitacoes" },
      { label: "Reembolsos", path: "/financeiro/reembolsos" },
      { label: "Cobranças", path: "/financeiro/cobrancas" },
      { label: "Relatórios", path: "/financeiro/relatorios" },
      { label: "Comissões", path: "/financeiro/comissionamento" }
    ]
  },
  {
    section: "Depósito WG",
    icon: "📦",
    items: [
      { label: "Depósito", path: "/deposito" }
    ]
  },
  {
    section: "WG Store",
    icon: "🛒",
    items: [
      { label: "Loja Virtual", path: "/wg-store" },
      { label: "Memorial de Acabamentos", path: "/memorial-acabamentos" }
    ]
  },
  {
    section: "Área WGXperience",
    icon: "⭐",
    items: [
      { label: "Portal do Cliente", path: "/area-cliente" },
      { label: "Jornada do Cliente", path: "/wg-experience/clientes" },
      { label: "Cadastro de Clientes", path: "/sistema/area-cliente/clientes" },
      { label: "Drive Compartilhado", path: "/sistema/area-cliente/drive" }
    ]
  },
  {
    section: "Onboarding",
    icon: "🚀",
    items: [
      { label: "Onboarding", path: "/onboarding" }
    ]
  },
  {
    section: "Jurídico",
    icon: "⚖️",
    items: [
      { label: "Dashboard Jurídico", path: "/juridico" },
      { label: "Modelos de Contrato", path: "/juridico/modelos" }
    ]
  },
  {
    section: "Sistema",
    icon: "🔧",
    maxVisible: 12,
    items: [
      { label: "Cadastros Pendentes", path: "/sistema/cadastros-pendentes" },
      { label: "Central de Links", path: "/sistema/central-links" },
      { label: "Central Import/Export", path: "/sistema/importar-exportar" },
      { label: "Empresas do Grupo WG", path: "/empresas" },
      { label: "Modelos de Contrato", path: "/modelos-contrato" },
      { label: "Planta do Sistema", path: "/sistema/planta" },
      { label: "Precificação", path: "/sistema/precificacao" },
      { label: "Price List", path: "/pricelist" },
      { label: "Saúde do Sistema", path: "/sistema/saude" },
      { label: "Templates de Checklists", path: "/sistema/checklists" },
      { label: "Usuários", path: "/usuarios" }
    ]
  },
  {
    section: "Pós Vendas",
    icon: "🛠️",
    maxVisible: 3,
    items: [
      { label: "Assistência", path: "/assistencia" },
      { label: "Termo de Aceite", path: "/termo-aceite" },
      { label: "Garantia", path: "/garantia" }
    ]
  },
  {
    section: "Sessão",
    icon: "🚪",
    items: [
      { label: "Sair", path: "/logout" }
    ]
  }
];

export default wgMenus;

