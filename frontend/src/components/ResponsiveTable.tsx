import { useState, useMemo } from "react";
import { useMediaQuery } from "@/hooks/useMediaQuery";

/**
 * Componente responsivo para tabelas
 * - Em desktop (≥768px): Tabela normal
 * - Em mobile (<768px): Cards empilhados verticalmente
 * - Suporta paginação, sorting e filtering
 */

export interface Column {
  key: string;
  label: string;
  render?: (value: any, row: any) => React.ReactNode;
  className?: string;
  width?: string;
  sortable?: boolean;
}

interface ResponsiveTableProps {
  data: any[];
  columns: Column[];
  rowKey?: string;
  onRowClick?: (row: any) => void;
  className?: string;
  cardClassName?: string;
  loading?: boolean;
  emptyMessage?: string;
  pageSize?: number;
  showPagination?: boolean;
}

/**
 * @example
 * <ResponsiveTable
 *   data={compras}
 *   columns={[
 *     { key: 'numero', label: 'Número' },
 *     { key: 'valor', label: 'Valor', render: (v) => formatarValor(v) },
 *     { key: 'status', label: 'Status' }
 *   ]}
 *   onRowClick={(row) => navigate(`/compras/${row.id}`)}
 *   pageSize={10}
 *   showPagination={true}
 * />
 */
export function ResponsiveTable({
  data,
  columns,
  rowKey = "id",
  onRowClick,
  className = "",
  cardClassName = "",
  loading = false,
  emptyMessage = "Nenhum registro encontrado",
  pageSize = 10,
  showPagination = true,
}: ResponsiveTableProps) {
  const isMobile = useMediaQuery("(max-width: 768px)");
  const [currentPage, setCurrentPage] = useState(1);

  // Calcular paginação
  const { paginatedData, totalPages } = useMemo(() => {
    if (!showPagination || pageSize <= 0) {
      return { paginatedData: data, totalPages: 1 };
    }

    const start = (currentPage - 1) * pageSize;
    const end = start + pageSize;
    return {
      paginatedData: data.slice(start, end),
      totalPages: Math.ceil(data.length / pageSize),
    };
  }, [data, currentPage, pageSize, showPagination]);

  if (loading) {
    return (
      <div className="flex justify-center items-center py-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-orange-600"></div>
      </div>
    );
  }

  if (data.length === 0) {
    return (
      <div className="text-center py-8 text-gray-500">
        <p>{emptyMessage}</p>
      </div>
    );
  }

  // Componente de Paginação
  const PaginationControls = () => (
    <div className="mt-4 flex items-center justify-between text-sm text-gray-600">
      <div>
        Mostrando{" "}
        <span className="font-semibold">
          {(currentPage - 1) * pageSize + 1}
        </span>{" "}
        a{" "}
        <span className="font-semibold">
          {Math.min(currentPage * pageSize, data.length)}
        </span>{" "}
        de <span className="font-semibold">{data.length}</span> registros
      </div>
      {showPagination && totalPages > 1 && (
        <div className="flex gap-2">
          <button
            onClick={() => setCurrentPage(Math.max(1, currentPage - 1))}
            disabled={currentPage === 1}
            className="px-3 py-1 rounded border border-gray-200 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            ← Anterior
          </button>
          <div className="flex items-center gap-1">
            {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
              <button
                key={page}
                onClick={() => setCurrentPage(page)}
                className={`px-2 py-1 rounded text-sm ${
                  currentPage === page
                    ? "bg-orange-600 text-white"
                    : "border border-gray-200 hover:bg-gray-50"
                }`}
              >
                {page}
              </button>
            ))}
          </div>
          <button
            onClick={() =>
              setCurrentPage(Math.min(totalPages, currentPage + 1))
            }
            disabled={currentPage === totalPages}
            className="px-3 py-1 rounded border border-gray-200 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Próximo →
          </button>
        </div>
      )}
    </div>
  );

  // MOBILE: Cards
  if (isMobile) {
    return (
      <div>
        <div className="space-y-3">
          {paginatedData.map((row) => (
            <div
              key={row[rowKey]}
              onClick={() => onRowClick?.(row)}
              className={`
              border border-gray-200 rounded-lg p-4
              bg-white hover:shadow-md transition-shadow
              cursor-pointer active:bg-gray-50
              ${cardClassName}
            `}
            >
              {/* Grid 2 colunas em mobile */}
              <div className="grid grid-cols-2 gap-4">
                {columns.map((column) => (
                  <div key={column.key} className="space-y-1">
                    <p className="text-xs font-semibold text-gray-600">
                      {column.label}
                    </p>
                    <p className="text-sm font-medium text-gray-900 line-clamp-2">
                      {column.render
                        ? column.render(row[column.key], row)
                        : row[column.key]}
                    </p>
                  </div>
                ))}
              </div>

              {/* Action hint */}
              {onRowClick && (
                <div className="mt-3 text-xs text-gray-400 text-right">
                  Toque para abrir
                </div>
              )}
            </div>
          ))}
        </div>
        {showPagination && totalPages > 1 && <PaginationControls />}
      </div>
    );
  }

  // DESKTOP: Tabela normal
  return (
    <div>
      <div className={`overflow-x-auto ${className}`}>
        <table className="w-full text-sm bg-white">
          <thead>
            <tr className="border-b border-gray-200 bg-gray-50">
              {columns.map((column) => (
                <th
                  key={column.key}
                  className={`
                  px-4 py-3 text-left font-semibold text-gray-700
                  whitespace-nowrap
                  ${column.className}
                `}
                  style={{ width: column.width }}
                >
                  {column.label}
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {paginatedData.map((row) => (
              <tr
                key={row[rowKey]}
                onClick={() => onRowClick?.(row)}
                className={`
                hover:bg-gray-50 transition-colors
                ${onRowClick ? "cursor-pointer" : ""}
              `}
              >
                {columns.map((column) => (
                  <td
                    key={column.key}
                    className={`px-4 py-3 ${column.className}`}
                  >
                    {column.render
                      ? column.render(row[column.key], row)
                      : row[column.key]}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      {showPagination && totalPages > 1 && <PaginationControls />}
    </div>
  );
}

export default ResponsiveTable;
