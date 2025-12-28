// ============================================================
// PÁGINA: Listagem de Quantitativos de Projeto
// Sistema WG Easy - Grupo WG Almeida
// ============================================================

import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import {
  listarQuantitativosProjetos,
  obterEstatisticasQuantitativos,
  deletarQuantitativoProjeto,
} from "../../services/quantitativosApi";
import type {
  QuantitativoProjetoCompleto,
  QuantitativosFiltros,
  QuantitativosEstatisticas,
  NucleoQuantitativo,
  StatusQuantitativo,
} from "../../types/quantitativos";
import {
  getNucleoLabel,
  getNucleoColor,
  getStatusLabel,
  getStatusColor,
  formatarPreco,
  formatarAreaComUnidade,
} from "../../types/quantitativos";

export default function QuantitativosListPage() {
  const navigate = useNavigate();

  // Estados
  const [quantitativos, setQuantitativos] = useState<QuantitativoProjetoCompleto[]>([]);
  const [estatisticas, setEstatisticas] = useState<QuantitativosEstatisticas | null>(null);
  const [loading, setLoading] = useState(true);
  const [filtros, setFiltros] = useState<QuantitativosFiltros>({});

  // Carregar dados
  useEffect(() => {
    carregarDados();
  }, [filtros]);

  const carregarDados = async () => {
    try {
      setLoading(true);
      const [projetosData, statsData] = await Promise.all([
        listarQuantitativosProjetos(filtros),
        obterEstatisticasQuantitativos(),
      ]);
      setQuantitativos(projetosData);
      setEstatisticas(statsData);
    } catch (error) {
      console.error("Erro ao carregar quantitativos:", error);
      alert("Erro ao carregar quantitativos");
    } finally {
      setLoading(false);
    }
  };

  const handleDeletar = async (id: string, nome: string) => {
    if (!confirm(`Tem certeza que deseja deletar o quantitativo "${nome}"?`)) {
      return;
    }

    try {
      await deletarQuantitativoProjeto(id);
      alert("Quantitativo deletado com sucesso!");
      carregarDados();
    } catch (error) {
      console.error("Erro ao deletar quantitativo:", error);
      alert("Erro ao deletar quantitativo");
    }
  };

  return (
    <div style={{ padding: "24px", maxWidth: "1400px", margin: "0 auto" }}>
      {/* Header */}
      <div style={{ marginBottom: "32px" }}>
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginBottom: "16px",
          }}
        >
          <div>
            <h1 style={{ fontSize: "28px", fontWeight: "600", marginBottom: "8px" }}>
              📐 Quantitativos de Projeto
            </h1>
            <p style={{ color: "#666", fontSize: "14px" }}>
              Gestão completa de quantitativos executivos
            </p>
          </div>
          <button
            onClick={() => navigate("/quantitativos/novo")}
            style={{
              background: "linear-gradient(135deg, #5E9B94 0%, #2B4580 100%)",
              color: "white",
              border: "none",
              padding: "12px 24px",
              borderRadius: "8px",
              fontSize: "15px",
              fontWeight: "600",
              cursor: "pointer",
              transition: "transform 0.2s",
            }}
            onMouseEnter={(e) => (e.currentTarget.style.transform = "translateY(-2px)")}
            onMouseLeave={(e) => (e.currentTarget.style.transform = "translateY(0)")}
          >
            + Novo Quantitativo
          </button>
        </div>
      </div>

      {/* Cards de Estatísticas */}
      {estatisticas && (
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
            gap: "16px",
            marginBottom: "32px",
          }}
        >
          <StatCard
            label="Total de Projetos"
            value={estatisticas.total_projetos}
            color="#5E9B94"
          />
          <StatCard
            label="Em Elaboração"
            value={estatisticas.total_em_elaboracao}
            color="#FFA726"
          />
          <StatCard
            label="Aprovados"
            value={estatisticas.total_aprovados}
            color="#66BB6A"
          />
          <StatCard
            label="Valor Total"
            value={formatarPreco(estatisticas.valor_total_geral)}
            color="#2B4580"
          />
        </div>
      )}

      {/* Filtros */}
      <div
        style={{
          background: "#F8F9FA",
          padding: "20px",
          borderRadius: "12px",
          marginBottom: "24px",
        }}
      >
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
            gap: "16px",
          }}
        >
          {/* Busca */}
          <div>
            <label
              style={{
                display: "block",
                marginBottom: "6px",
                fontSize: "13px",
                fontWeight: "500",
                color: "#333",
              }}
            >
              Buscar
            </label>
            <input
              type="text"
              placeholder="Número ou nome..."
              value={filtros.busca || ""}
              onChange={(e) => setFiltros({ ...filtros, busca: e.target.value })}
              style={{
                width: "100%",
                padding: "10px 12px",
                border: "1px solid #DDD",
                borderRadius: "6px",
                fontSize: "14px",
              }}
            />
          </div>

          {/* Núcleo */}
          <div>
            <label
              style={{
                display: "block",
                marginBottom: "6px",
                fontSize: "13px",
                fontWeight: "500",
                color: "#333",
              }}
            >
              Núcleo
            </label>
            <select
              value={filtros.nucleo || ""}
              onChange={(e) =>
                setFiltros({
                  ...filtros,
                  nucleo: e.target.value as NucleoQuantitativo | undefined,
                })
              }
              style={{
                width: "100%",
                padding: "10px 12px",
                border: "1px solid #DDD",
                borderRadius: "6px",
                fontSize: "14px",
              }}
            >
              <option value="">Todos os núcleos</option>
              <option value="arquitetura">Arquitetura</option>
              <option value="engenharia">Engenharia</option>
              <option value="marcenaria">Marcenaria</option>
            </select>
          </div>

          {/* Status */}
          <div>
            <label
              style={{
                display: "block",
                marginBottom: "6px",
                fontSize: "13px",
                fontWeight: "500",
                color: "#333",
              }}
            >
              Status
            </label>
            <select
              value={filtros.status || ""}
              onChange={(e) =>
                setFiltros({
                  ...filtros,
                  status: e.target.value as StatusQuantitativo | undefined,
                })
              }
              style={{
                width: "100%",
                padding: "10px 12px",
                border: "1px solid #DDD",
                borderRadius: "6px",
                fontSize: "14px",
              }}
            >
              <option value="">Todos os status</option>
              <option value="em_elaboracao">Em Elaboração</option>
              <option value="aprovado">Aprovado</option>
              <option value="revisao">Em Revisão</option>
              <option value="arquivado">Arquivado</option>
            </select>
          </div>

          {/* Botão Limpar */}
          <div style={{ display: "flex", alignItems: "flex-end" }}>
            <button
              onClick={() => setFiltros({})}
              style={{
                width: "100%",
                padding: "10px 12px",
                border: "1px solid #DDD",
                borderRadius: "6px",
                background: "white",
                fontSize: "14px",
                cursor: "pointer",
              }}
            >
              Limpar Filtros
            </button>
          </div>
        </div>
      </div>

      {/* Tabela */}
      {loading ? (
        <div style={{ textAlign: "center", padding: "40px", color: "#999" }}>
          Carregando...
        </div>
      ) : quantitativos.length === 0 ? (
        <div
          style={{
            textAlign: "center",
            padding: "60px 20px",
            background: "#F8F9FA",
            borderRadius: "12px",
          }}
        >
          <div style={{ fontSize: "48px", marginBottom: "16px" }}>📐</div>
          <h3 style={{ fontSize: "18px", color: "#666", marginBottom: "8px" }}>
            Nenhum quantitativo encontrado
          </h3>
          <p style={{ color: "#999", fontSize: "14px" }}>
            Crie seu primeiro quantitativo clicando no botão acima
          </p>
        </div>
      ) : (
        <div style={{ overflowX: "auto" }}>
          <table
            style={{
              width: "100%",
              borderCollapse: "collapse",
              background: "white",
              borderRadius: "12px",
              overflow: "hidden",
              boxShadow: "0 2px 8px rgba(0,0,0,0.1)",
            }}
          >
            <thead>
              <tr style={{ background: "#F8F9FA" }}>
                <th style={tableHeaderStyle}>Número</th>
                <th style={tableHeaderStyle}>Nome</th>
                <th style={tableHeaderStyle}>Cliente</th>
                <th style={tableHeaderStyle}>Núcleo</th>
                <th style={tableHeaderStyle}>Status</th>
                <th style={tableHeaderStyle}>Área</th>
                <th style={tableHeaderStyle}>Ambientes</th>
                <th style={tableHeaderStyle}>Itens</th>
                <th style={tableHeaderStyle}>Valor Total</th>
                <th style={tableHeaderStyle}>Ações</th>
              </tr>
            </thead>
            <tbody>
              {quantitativos.map((projeto) => (
                <tr
                  key={projeto.id}
                  style={{
                    borderBottom: "1px solid #E5E7EB",
                    transition: "background 0.2s",
                  }}
                  onMouseEnter={(e) =>
                    (e.currentTarget.style.background = "#F9FAFB")
                  }
                  onMouseLeave={(e) =>
                    (e.currentTarget.style.background = "white")
                  }
                >
                  <td style={tableCellStyle}>
                    <span
                      style={{
                        fontFamily: "monospace",
                        fontSize: "13px",
                        color: "#666",
                      }}
                    >
                      {projeto.numero}
                    </span>
                  </td>
                  <td style={tableCellStyle}>
                    <strong>{projeto.nome}</strong>
                  </td>
                  <td style={tableCellStyle}>{projeto.cliente_nome}</td>
                  <td style={tableCellStyle}>
                    <span
                      style={{
                        background: getNucleoColor(projeto.nucleo),
                        color: "white",
                        padding: "4px 12px",
                        borderRadius: "12px",
                        fontSize: "12px",
                        fontWeight: "500",
                      }}
                    >
                      {getNucleoLabel(projeto.nucleo)}
                    </span>
                  </td>
                  <td style={tableCellStyle}>
                    <span
                      style={{
                        background: getStatusColor(projeto.status),
                        color: "white",
                        padding: "4px 12px",
                        borderRadius: "12px",
                        fontSize: "12px",
                        fontWeight: "500",
                      }}
                    >
                      {getStatusLabel(projeto.status)}
                    </span>
                  </td>
                  <td style={tableCellStyle}>
                    {formatarAreaComUnidade(projeto.area_construida)}
                  </td>
                  <td style={tableCellStyle}>
                    <span
                      style={{
                        background: "#E3F2FD",
                        color: "#1976D2",
                        padding: "4px 8px",
                        borderRadius: "6px",
                        fontSize: "13px",
                        fontWeight: "500",
                      }}
                    >
                      {projeto.total_ambientes || 0}
                    </span>
                  </td>
                  <td style={tableCellStyle}>
                    <span
                      style={{
                        background: "#F3E5F5",
                        color: "#7B1FA2",
                        padding: "4px 8px",
                        borderRadius: "6px",
                        fontSize: "13px",
                        fontWeight: "500",
                      }}
                    >
                      {projeto.total_itens || 0}
                    </span>
                  </td>
                  <td style={tableCellStyle}>
                    <strong style={{ color: "#2B4580" }}>
                      {formatarPreco(projeto.valor_total || 0)}
                    </strong>
                  </td>
                  <td style={tableCellStyle}>
                    <div style={{ display: "flex", gap: "8px" }}>
                      <button
                        onClick={() => navigate(`/quantitativos/${projeto.id}/editor`)}
                        style={{
                          padding: "6px 12px",
                          background: "#312E81",
                          color: "white",
                          border: "none",
                          borderRadius: "6px",
                          fontSize: "13px",
                          cursor: "pointer",
                        }}
                      >
                        Editor & IA
                      </button>
                      <button
                        onClick={() => navigate(`/quantitativos/${projeto.id}/editar`)}
                        style={{
                          padding: "6px 12px",
                          background: "#5E9B94",
                          color: "white",
                          border: "none",
                          borderRadius: "6px",
                          fontSize: "13px",
                          cursor: "pointer",
                        }}
                      >
                        Editar
                      </button>
                      <button
                        onClick={() => handleDeletar(projeto.id, projeto.nome)}
                        style={{
                          padding: "6px 12px",
                          background: "#EF4444",
                          color: "white",
                          border: "none",
                          borderRadius: "6px",
                          fontSize: "13px",
                          cursor: "pointer",
                        }}
                      >
                        Deletar
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// ============================================================
// Componente: Card de Estatística
// ============================================================

interface StatCardProps {
  label: string;
  value: string | number;
  color: string;
}

function StatCard({ label, value, color }: StatCardProps) {
  return (
    <div
      style={{
        background: "white",
        padding: "20px",
        borderRadius: "12px",
        boxShadow: "0 2px 8px rgba(0,0,0,0.1)",
        borderLeft: `4px solid ${color}`,
      }}
    >
      <div
        style={{
          fontSize: "28px",
          fontWeight: "bold",
          color: color,
          marginBottom: "8px",
        }}
      >
        {value}
      </div>
      <div style={{ fontSize: "13px", color: "#666", fontWeight: "500" }}>
        {label}
      </div>
    </div>
  );
}

// ============================================================
// Estilos
// ============================================================

const tableHeaderStyle: React.CSSProperties = {
  padding: "14px 16px",
  textAlign: "left",
  fontSize: "13px",
  fontWeight: "600",
  color: "#666",
  textTransform: "uppercase",
  letterSpacing: "0.5px",
};

const tableCellStyle: React.CSSProperties = {
  padding: "16px",
  fontSize: "14px",
  color: "#333",
};
