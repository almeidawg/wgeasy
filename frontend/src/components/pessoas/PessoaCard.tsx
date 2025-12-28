import { Pencil, Trash2, Mail, FileText, MessageCircle, FileCheck } from "lucide-react";
import type { Pessoa } from "@/types/pessoas";
import { obterAvatarUrl } from "@/utils/avatarUtils";

interface PessoaCardProps {
  pessoa: Pessoa;
  onClick?: () => void;
  onEdit?: () => void;
  onDelete?: () => void;
  onPdf?: () => void;
  onVerPropostas?: () => void;
}

export default function PessoaCard({
  pessoa,
  onClick,
  onEdit,
  onDelete,
  onPdf,
  onVerPropostas,
}: PessoaCardProps) {
  const avatarUrl = obterAvatarUrl(
    pessoa.nome,
    pessoa.avatar_url,
    pessoa.foto_url,
    undefined,
    undefined,
    "fff",
    64
  );

  const whatsappLink = pessoa.telefone
    ? "https://wa.me/55" + pessoa.telefone.replace(/\D/g, "")
    : null;

  const emailLink = pessoa.email ? `mailto:${pessoa.email}` : null;

  return (
    <div
      className="w-full p-4 bg-white border rounded-xl shadow-sm flex items-center gap-4 hover:shadow-md transition cursor-pointer"
      onClick={onClick}
    >
      {/* Avatar */}
      <img
        src={avatarUrl}
        alt={pessoa.nome}
        className="w-12 h-12 rounded-full object-cover border"
      />

      {/* Informações */}
      <div className="flex-1 min-w-0">
        <h3 className="font-semibold text-sm truncate">{pessoa.nome}</h3>

        <div className="flex flex-wrap items-center text-xs text-gray-500 mt-1 gap-2">
          {pessoa.cargo && <span>{pessoa.cargo}</span>}
          {pessoa.unidade && <span className="border-l pl-2">{pessoa.unidade}</span>}
        </div>

        <div className="text-xs text-gray-400 mt-1">
          {pessoa.email && <span>{pessoa.email}</span>}
        </div>
      </div>

      {/* Ações - ícones WG */}
      <div
        className="flex items-center gap-2"
        onClick={(e) => e.stopPropagation()} // impede abrir card ao clicar nos ícones
      >
        {/* Ver Propostas (só para clientes) */}
        {pessoa.tipo === "CLIENTE" && onVerPropostas && (
          <button
            onClick={onVerPropostas}
            className="p-2 rounded-md hover:bg-[#F25C26]/10 text-[#F25C26]"
            title="Ver Propostas"
          >
            <FileCheck size={16} />
          </button>
        )}

        {/* Editar */}
        <button
          onClick={onEdit}
          className="p-2 rounded-md hover:bg-gray-100 text-gray-600"
        >
          <Pencil size={16} />
        </button>

        {/* PDF */}
        <button
          onClick={onPdf}
          className="p-2 rounded-md hover:bg-gray-100 text-gray-600"
        >
          <FileText size={16} />
        </button>

        {/* WhatsApp */}
        {whatsappLink && (
          <a
            href={whatsappLink}
            target="_blank"
            className="p-2 rounded-md hover:bg-green-50 text-green-600"
          >
            <MessageCircle size={16} />
          </a>
        )}

        {/* Email */}
        {emailLink && (
          <a
            href={emailLink}
            className="p-2 rounded-md hover:bg-blue-50 text-blue-600"
          >
            <Mail size={16} />
          </a>
        )}

        {/* Excluir */}
        <button
          onClick={onDelete}
          className="p-2 rounded-md hover:bg-red-50 text-red-600"
        >
          <Trash2 size={16} />
        </button>
      </div>
    </div>
  );
}
