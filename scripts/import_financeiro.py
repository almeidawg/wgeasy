import argparse
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional

from supabase import Client, create_client

from finance_pipeline import (
    build_importable_records,
    extract_from_pdf,
    load_financial_files,
)

SERVICE_KEY_PATH = Path(__file__).resolve().parent.parent / "service_role_key.txt"
SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://ahlqzzkxuutwoepirpzr.supabase.co")


def load_service_role_key() -> str:
    return os.environ.get("SUPABASE_SERVICE_ROLE") or SERVICE_KEY_PATH.read_text().strip()


def build_supabase_client() -> Client:
    key = load_service_role_key()
    return create_client(SUPABASE_URL, key)


@dataclass
class LancamentoRecord:
    descricao: str
    valor: float
    tipo: str
    centro_custo: str
    cliente: str
    conta: str
    data: str

    cliente_id: Optional[str] = None
    centro_custo_id: Optional[str] = None

    def to_payload(self):
        payload = {
            "descricao": self.descricao or "Lançamento importado",
            "valor_total": float(self.valor),
            "tipo": "entrada" if self.tipo == "receita" else "saida",
            "conta_bancaria": self.conta,
            "observacoes": self.descricao,
            "data_competencia": self.data,
            "status": "pendente",
        }
        if self.cliente_id:
            payload["cliente_id"] = self.cliente_id
        else:
            payload["cliente_nome"] = self.cliente
        if self.centro_custo_id:
            payload["centro_custo_id"] = self.centro_custo_id
        else:
            payload["centro_custo"] = self.centro_custo
        return payload


def fetch_people_map(
    supabase: Client, tipo: str
) -> Dict[str, Dict[str, str]]:
    response = supabase.table("pessoas").select(
        "id,nome,email,tipo"
    ).eq("tipo", tipo)
    if response.error:
        raise RuntimeError(f"Erro ao buscar pessoas: {response.error.message}")
    mapping: Dict[str, Dict[str, str]] = {}
    for row in response.data or []:
        mapping[str(row["nome"]).strip().lower()] = {
            "id": row["id"],
            "email": row.get("email") or "",
        }
    return mapping


def fetch_centros_map(supabase: Client) -> Dict[str, str]:
    response = supabase.table("financeiro_centros_custo").select("id,nome")
    if response.error:
        raise RuntimeError(f"Erro ao buscar centros de custo: {response.error.message}")
    mapping: Dict[str, str] = {}
    for row in response.data or []:
        mapping[str(row["nome"]).strip().lower()] = row["id"]
    return mapping


def upsert_person(
    supabase: Client, nome: str, email: Optional[str], tipo: str = "CLIENTE"
) -> str:
    payload = {
        "nome": nome,
        "email": email or f"{nome.lower().replace(' ','.')}@wg.com.br",
        "tipo": tipo,
        "ativo": True,
    }
    response = supabase.table("pessoas").insert(payload).select("id").maybe_single()
    if response.error:
        raise RuntimeError(f"Erro ao criar pessoa {nome}: {response.error.message}")
    return response.data["id"] if response.data else ""


def upsert_centro(supabase: Client, nome: str, descricao: Optional[str] = None) -> str:
    payload = {"nome": nome, "descricao": descricao or "Centro importado"}
    response = supabase.table("financeiro_centros_custo").insert(payload).select("id").maybe_single()
    if response.error:
        raise RuntimeError(f"Erro ao criar centro {nome}: {response.error.message}")
    return response.data["id"] if response.data else ""


def load_colaboradores(path: Path) -> List[Dict]:
    if not path.exists():
        return []
    if path.suffix.lower() in [".xlsx", ".xls"]:
        import pandas as pd

        df = pd.read_excel(path, dtype=str)
    else:
        import pandas as pd

        df = pd.read_csv(path, dtype=str)
    df = df.fillna("")
    colaboradores = []
    for _, row in df.iterrows():
        nome = str(row.get("nome") or row.get("Nome") or "").strip()
        if not nome:
            continue
        colaboradores.append(
            {
                "nome": nome,
                "email": str(row.get("email") or f"{nome.lower().replace(' ','')}@wg.com.br"),
                "telefone": row.get("telefone") or "",
                "cargo": row.get("cargo") or row.get("função") or "Colaborador",
                "unidade": row.get("unidade") or "Geral",
                "tipo": "COLABORADOR",
                "ativo": True,
            }
        )
    return colaboradores


def ensure_clients(
    supabase: Client,
    names: Iterable[str],
    existing: Dict[str, Dict[str, str]],
) -> Dict[str, str]:
    result: Dict[str, str] = {}
    for name in names:
        key = name.strip().lower()
        if not key:
            continue
        if key in existing:
            result[name] = existing[key]["id"]
            continue
        client_id = upsert_person(supabase, name, existing.get(key, {}).get("email", ""), tipo="CLIENTE")
        existing[key] = {"id": client_id, "email": ""}
        result[name] = client_id
    return result


def ensure_centers(
    supabase: Client, centers: Iterable[str], existing: Dict[str, str]
) -> Dict[str, str]:
    result: Dict[str, str] = {}
    for center in centers:
        key = center.strip().lower()
        if not key:
            continue
        if key in existing:
            result[center] = existing[key]
            continue
        center_id = upsert_centro(supabase, center)
        existing[key] = center_id
        result[center] = center_id
    return result


def create_colaboradores(supabase: Client, colaboradores: List[Dict[str, str]]) -> None:
    for person in colaboradores:
        nome = person["nome"]
        resp = supabase.table("pessoas").insert(person).select("id").maybe_single()
        if resp.error:
            print(f"Erro ao criar colaborador {nome}: {resp.error.message}")
        else:
            print(f"Colaborador criado: {nome} (ID {resp.data['id']})")


def summarize(records: List["LancamentoRecord"]) -> None:
    print(f"Registros para importar: {len(records)}")
    total = sum(r.valor for r in records)
    entrada = sum(r.valor for r in records if r.tipo == "receita")
    saida = sum(r.valor for r in records if r.tipo == "despesa")
    print("Totais:")
    print(f"  Entrada: R$ {entrada:,.2f}")
    print(f"  Saída  : R$ {saida:,.2f}")
    print(f"  Saldo  : R$ {total:,.2f}")


def run_import(
    patterns: List[str],
    *,
    dry_run: bool = False,
    pdf_files: Optional[List[str]] = None,
    sync_clients: bool = False,
    sync_centers: bool = False,
    sync_colaboradores: bool = False,
    colaboradores_file: Optional[str] = None,
) -> None:
    pdf_files = pdf_files or []
    df = load_financial_files(patterns)

    for pdf in pdf_files:
        pdf_df = extract_from_pdf(Path(pdf))
        if not pdf_df.empty:
            df = df.append(pdf_df, ignore_index=True)

    need_supabase = sync_clients or sync_centers or sync_colaboradores or not dry_run
    supabase = build_supabase_client() if need_supabase else None
    client_map = {}
    center_map = {}
    if sync_clients:
        existing_clients = fetch_people_map(supabase, "CLIENTE")
        names = set(df["cliente_nome"].dropna())
        client_map = ensure_clients(supabase, names, existing_clients)
    if sync_centers:
        existing_centers = fetch_centros_map(supabase)
        centers = set(df["centro_custo"].dropna())
        center_map = ensure_centers(supabase, centers, existing_centers)
    if sync_colaboradores and colaboradores_file:
        create_colaboradores(supabase, load_colaboradores(Path(colaboradores_file)))

    records_data = build_importable_records(df)
    model = []
    for entry in records_data:
        record = LancamentoRecord(**entry)
        if sync_clients and record.cliente in client_map:
            record.cliente_id = client_map[record.cliente]
        if sync_centers and record.centro_custo in center_map:
            record.centro_custo_id = center_map[record.centro_custo]
        model.append(record)

    summarize(model)

    if dry_run:
        print("Dry run habilitado; nenhum registro será enviado.")
        return

    payloads = [record.to_payload() for record in model]
    response = supabase.table("financeiro_lancamentos").insert(payloads).execute()
    if response.error:
        raise RuntimeError(f"Erro ao inserir lançamentos: {response.error.message}")

    print(f"{len(payloads)} lançamentos importados com sucesso.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Importar lançamentos financeiros diretamente para o Supabase."
    )
    parser.add_argument(
        "--patterns",
        nargs="+",
        required=True,
        help="Padrões glob (ex: 'dados/Gerenciamento 2025*.xlsx').",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Apenas sumariza os registros sem enviar para o Supabase.",
    )
    parser.add_argument(
        "--pdf",
        nargs="*",
        default=[],
        help="Arquivos PDF adicionais convertidos em tabelas.",
    )
    parser.add_argument(
        "--sync-clients",
        action="store_true",
        help="Cria clientes novos a partir dos lançamentos.",
    )
    parser.add_argument(
        "--sync-centers",
        action="store_true",
        help="Cria centros de custo novos com os nomes encontrados.",
    )
    parser.add_argument(
        "--sync-colaboradores",
        action="store_true",
        help="Importa colaboradores a partir de um arquivo CSV/XLSX.",
    )
    parser.add_argument(
        "--colaboradores-file",
        help="Caminho para planilha de colaboradores (CSV ou XLSX).",
    )

    args = parser.parse_args()
    if args.sync_colaboradores and not args.colaboradores_file:
        parser.error("--sync-colaboradores requer --colaboradores-file")
    run_import(
        args.patterns,
        dry_run=args.dry_run,
        pdf_files=args.pdf,
        sync_clients=args.sync_clients,
        sync_centers=args.sync_centers,
        sync_colaboradores=args.sync_colaboradores,
        colaboradores_file=args.colaboradores_file,
    )


if __name__ == "__main__":
    main()
