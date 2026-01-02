import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import type { Pessoa, PessoaTipo } from "@/types/pessoas";
import { listarPessoas, deletarPessoa } from "@/lib/pessoasApi";
import { gerarFichaClientePDF } from "@/lib/pdfFichaCliente";
import PessoaCard from "./PessoaCard";
import { BotaoGerarLink } from "@/components/cadastro-link/GerarLinkCadastroModal";
import type { TipoCadastro } from "@/lib/cadastroLinkApi";

interface PessoasListProps {
  tipo: PessoaTipo;
  titulo: string;
  descricao?: string;
  novoPath: string;
}

export default function PessoasList({
  tipo,
  titulo,
  descricao,
  novoPath,
}: PessoasListProps) {
  const navigate = useNavigate();
  const [pessoas, setPessoas] = useState<Pessoa[]>([]);
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState<string | null>(null);

  useEffect(() => {
    let cancelado = false;

    async function carregar() {
      try {
        setLoading(true);
        const data = await listarPessoas({ tipo, ativo: true });
        if (!cancelado) {
          setPessoas(data);
          setErro(null);
        }
      } catch (e: any) {
        if (!cancelado) {
          setErro(e.message ?? "Erro ao carregar cadastro.");
        }
      } finally {
        if (!cancelado) setLoading(false);
      }
    }

    carregar();

    return () => {
      cancelado = true;
    };
  }, [tipo]);

  const handleEdit = (pessoa: Pessoa) => {
    const editPath = novoPath.replace("/novo", `/editar/${pessoa.id}`);
    navigate(editPath);
  };

  const handleDelete = async (pessoa: Pessoa) => {
    if (!confirm(`Deseja realmente excluir ${pessoa.nome}?`)) return;

    try {
      await deletarPessoa(pessoa.id);
      setPessoas((prev) => prev.filter((p) => p.id !== pessoa.id));
    } catch (e: any) {
      alert(e.message ?? "Erro ao excluir");
    }
  };

  const handleView = (pessoa: Pessoa) => {
    const viewPath = novoPath.replace("/novo", `/${pessoa.id}`);
    navigate(viewPath);
  };

  const handlePdf = async (pessoa: Pessoa) => {
    try {
      await gerarFichaClientePDF({ pessoaId: pessoa.id, pessoa });
    } catch (error) {
      console.error("Erro ao gerar PDF do cliente:", error);
      const message =
        error instanceof Error
          ? error.message
          : "Não foi possível gerar o PDF.";
      alert(message);
    }
  };

  const handleVerPropostas = (pessoa: Pessoa) => {
    navigate(`/propostas/cliente/${pessoa.id}`);
  };

  return (
    <div className="p-6 space-y-4">
      <div className="flex items-center justify-between gap-3">
        <div>
          <h1 className="text-xl font-semibold">{titulo}</h1>
          {descricao && (
            <p className="text-sm text-gray-500 mt-1">{descricao}</p>
          )}
        </div>

        <div className="flex gap-2">
          <BotaoGerarLink
            tipo={tipo.toUpperCase() as TipoCadastro}
            variant="default"
            className="bg-[#F25C26] hover:bg-[#d94d1a] text-white"
          />
          <button
            type="button"
            onClick={() => navigate(novoPath)}
            className="px-4 py-2 rounded-lg bg-[#F25C26] hover:bg-[#d94d1a] text-white text-sm font-medium"
          >
            + Novo cadastro
          </button>
        </div>
      </div>

      {loading && <div className="text-sm text-gray-500">Carregando...</div>}

      {erro && (
        <div className="text-sm text-red-600 border border-red-200 bg-red-50 p-3 rounded-lg">
          {erro}
        </div>
      )}

      {!loading && !erro && pessoas.length === 0 && (
        <div className="text-sm text-gray-500 border border-dashed rounded-lg p-4">
          Nenhum cadastro encontrado para este grupo.
        </div>
      )}

      <div className="space-y-3">
        {pessoas.map((p) => (
          <PessoaCard
            key={p.id}
            pessoa={p}
            onClick={() => handleView(p)}
            onEdit={() => handleEdit(p)}
            onDelete={() => handleDelete(p)}
            onPdf={() => handlePdf(p)}
            onVerPropostas={() => handleVerPropostas(p)}
          />
        ))}
      </div>
    </div>
  );
}

