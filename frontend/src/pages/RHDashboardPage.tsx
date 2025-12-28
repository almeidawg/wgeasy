// src/pages/RHDashboardPage.tsx
import { useEffect, useState } from "react";
import { listarPessoas, Pessoa } from "@/lib/pessoasApi";

const RHDashboardPage = () => {
  const [colaboradores, setColaboradores] = useState<Pessoa[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function carregar() {
      const todos = await listarPessoas({ tipo: "COLABORADOR", ativo: true });
      setColaboradores(todos);
      setLoading(false);
    }
    carregar();
  }, []);

  if (loading) return <div className="p-6">Carregando...</div>;

  const total = colaboradores.length;

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-xl font-semibold uppercase tracking-[0.3em] text-[#2E2E2E]">
        RH — Colaboradores
      </h1>

      <div className="grid gap-4 md:grid-cols-3">
        <div className="rounded-2xl bg-white p-4 shadow-sm border border-[#E5E5E5]">
          <div className="text-xs uppercase tracking-[0.2em] text-[#7A7A7A]">
            Total de colaboradores
          </div>
          <div className="mt-2 text-3xl font-semibold text-[#2E2E2E]">
            {total}
          </div>
        </div>
      </div>

      <div className="rounded-2xl border border-[#E5E5E5] bg-white p-4 shadow-sm">
        <h2 className="mb-3 text-xs font-semibold uppercase tracking-[0.2em] text-[#4C4C4C]">
          Lista de colaboradores
        </h2>
        {colaboradores.length === 0 ? (
          <p className="text-sm text-[#7A7A7A]">
            Nenhum colaborador cadastrado ainda.
          </p>
        ) : (
          <ul className="space-y-2 text-sm text-[#4C4C4C]">
            {colaboradores.map((c) => (
              <li
                key={c.id}
                className="flex items-center justify-between rounded-lg border border-[#F0F0F0] px-3 py-2"
              >
                <span>{c.nome}</span>
                <span className="text-xs text-[#7A7A7A]">
                  {c.email ?? "-"}
                </span>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
};

export default RHDashboardPage;
