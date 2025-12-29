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
  path?: string; // Caminho direto ao clicar no título da seção
}

const wgMenus: MenuSection[] = [
  {
    section: "Dashboard",
    icon: "📊",
    path: "/", // Clique no título navega direto para o Dashboard
    items: []
  },
  {
    section: "Meu Financeiro",
    icon: "💳",
    path: "/meu-financeiro", // Financeiro Pessoal do usuário logado
    items: []
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
    path: "/oportunidades", // Clique no título navega direto
    items: []
  },
  {
    section: "Comercial",
    icon: "💼",
    maxVisible: 4,
    items: [
      { label: "Estudo (EVF)", path: "/evf" },
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
    maxVisible: 6,
    items: [
      { label: "Orçamento de Materiais", path: "/planejamento/orcamentos/materiais" },
      { label: "Composições", path: "/planejamento/orcamentos/composicoes" },
      { label: "Modelos de Orçamento", path: "/planejamento/orcamentos/modelos" },
      { label: "Orçamentos", path: "/planejamento/orcamentos" },
      { label: "Aprovações", path: "/planejamento/aprovacoes" },
      { label: "Compras", path: "/compras" }
    ]
  },
  {
    section: "Serviços",
    icon: "🚚",
    path: "/servicos",
    items: []
  },
  {
    section: "Cronograma",
    icon: "📅",
    path: "/cronograma", // Clique no título navega direto para o Dashboard
    items: [
      { label: "Projetos", path: "/cronograma/projects" }
    ]
  },
  {
    section: "Financeiro",
    icon: "💰",
    maxVisible: 7,
    path: "/financeiro", // Clique no título navega direto para o Dashboard
    items: [
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
    section: "Jurídico",
    icon: "⚖️",
    path: "/juridico", // Clique no título navega direto
    items: [
      { label: "Empresas do Grupo WG", path: "/juridico/empresas" },
      { label: "Modelos de Contrato", path: "/juridico/modelos" }
    ]
  },
  {
    section: "Área WGXperience",
    icon: "⭐",
    items: [
      { label: "Portal do Cliente", path: "/portal-cliente" },
      { label: "Cadastro de Clientes", path: "/sistema/area-cliente/clientes" },
      { label: "Drive Compartilhado", path: "/sistema/area-cliente/drive" }
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
    section: "Onboarding",
    icon: "🚀",
    path: "/onboarding", // Clique no título navega direto
    items: []
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
    section: "Depósito WG",
    icon: "📦",
    path: "/deposito", // Clique no título navega direto
    items: []
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
    section: "Sessão",
    icon: "🚪",
    path: "/logout", // Clique no título faz logout direto
    items: []
  }
];

export default wgMenus;

