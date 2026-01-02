import { useMediaQuery } from "@/hooks/useMediaQuery";

/**
 * Componente responsivo para tabelas
 * - Em desktop (≥768px): Tabela normal
 * - Em mobile (<768px): Cards empilhados verticalmente
 */

export interface Column {
  key: string;
  label: string;
  render?: (value: any, row: any) => React.ReactNode;
  className?: string;
  width?: string;
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
}: ResponsiveTableProps) {
  const isMobile = useMediaQuery("(max-width: 768px)");

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

  // MOBILE: Cards
  if (isMobile) {
    return (
      <div className="space-y-3">
        {data.map((row) => (
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
    );
  }

  // DESKTOP: Tabela normal
  return (
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
          {data.map((row) => (
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
  );
}
