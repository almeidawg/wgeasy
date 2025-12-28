// src/pages/ProjectsPage.tsx
import { useEffect, useState } from "react";
import { listarProjects, deletarProject } from "@/lib/projectsApi";
import { Link } from "react-router-dom";

export default function ProjectsPage() {
  const [dados, setDados] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  async function carregar() {
    setDados(await listarProjects());
    setLoading(false);
  }

  useEffect(() => {
    carregar();
  }, []);

  if (loading) {
    return <div className="flex items-center justify-center h-[50vh]">Carregando projetos...</div>;
  }

  return (
    <div className="space-y-6">

      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-[#2E2E2E]">Cronograma (Projects)</h1>
        <Link to="/projects/novo" className="px-4 py-2 bg-[#F25C26] text-white rounded">
          Novo Projeto
        </Link>
      </div>

      <div className="bg-white border border-[#E5E5E5] rounded-xl shadow">
        <table className="w-full text-sm">
          <thead className="bg-[#F3F3F3]">
            <tr>
              <th className="p-3 text-left">Projeto</th>
              <th className="p-3">Obra</th>
              <th className="p-3">Período</th>
              <th className="p-3">Status</th>
              <th className="p-3">Ações</th>
            </tr>
          </thead>
          <tbody>
            {dados.map((p) => (
              <tr key={p.id} className="border-b hover:bg-[#fafafa]">
                <td className="p-3">{p.nome}</td>
                <td className="p-3">{p.obras?.nome ?? "-"}</td>
                <td className="p-3">{p.inicio} → {p.fim}</td>
                <td className="p-3 capitalize">{p.status}</td>
                <td className="p-3 space-x-3">
                  <Link to={`/projects/tarefas/${p.id}`} className="text-blue-600 hover:underline">
                    Tarefas
                  </Link>
                  <Link to={`/projects/editar/${p.id}`} className="text-blue-600 hover:underline">
                    Editar
                  </Link>
                  <Link to={`/projects/timeline/${p.id}`} className="text-blue-600 hover:underline">
                    Timeline
                  </Link>

                  <button
                    onClick={() => {
                      if (confirm("Excluir projeto?")) {
                        deletarProject(p.id).then(carregar);
                      }
                    }}
                    className="text-red-600 hover:underline"
                  >
                    Excluir
                  </button>
                </td>
              </tr>
            ))}

            {dados.length === 0 && (
              <tr>
                <td colSpan={5} className="p-3 text-center">Nenhum projeto encontrado.</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

    </div>
  );
}
