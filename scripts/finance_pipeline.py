import argparse
import glob
from pathlib import Path
from typing import Dict, List, Optional

import numpy as np
import pandas as pd


STANDARD_COLUMNS = {
    "data": "data",
    "datapagamento": "data",
    "datasolicitacao": "data",
    "descricao": "descricao",
    "detalhes": "descricao",
    "centrodecusto": "centro_custo",
    "centrocusto": "centro_custo",
    "cliente": "cliente_nome",
    "cliente_nome": "cliente_nome",
    "conta": "conta",
    "forma": "conta",
    "valor": "valor",
    "valortotal": "valor",
    "valorbruto": "valor",
    "tipo": "tipo",
    "natureza": "tipo",
}


def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    columns_map = {}
    for col in df.columns:
        normalized = col.strip().lower().replace(" ", "")
        columns_map[col] = STANDARD_COLUMNS.get(normalized, normalized)
    df = df.rename(columns=columns_map)
    expected = ["data", "descricao", "centro_custo", "cliente_nome", "conta", "tipo", "valor"]
    for key in expected:
        if key not in df.columns:
            df[key] = None
    df = df[expected]
    return df


def classify_transaction(row: pd.Series) -> str:
    valor = row["valor"]
    if pd.isna(valor):
        return "despesa"
    return "receita" if valor > 0 else "despesa"


def assign_center_cost(row: pd.Series, mapping: Dict[str, str]) -> str:
    centro = row["centro_custo"]
    if pd.isna(centro) or str(centro).strip() == "":
        descricao = str(row["descricao"] or "").lower()
        for term, centro_destino in mapping.items():
            if term.lower() in descricao:
                return centro_destino
        return "Centro Geral"
    return centro


def load_financial_files(patterns: List[str]) -> pd.DataFrame:
    dfs = []
    for pattern in patterns:
        for path in glob.glob(pattern):
            ext = Path(path).suffix.lower()
            if ext in (".xlsx", ".xls"):
                df = pd.read_excel(path, dtype=str)
            elif ext in (".csv",):
                df = pd.read_csv(path, dtype=str)
            else:
                continue
            df = normalize_columns(df)
            df["origem"] = Path(path).name
            dfs.append(df)
    if not dfs:
        raise FileNotFoundError("Nenhum arquivo financeiro encontrado para os padrões indicados.")
    result = pd.concat(dfs, ignore_index=True)
    result["valor"] = pd.to_numeric(result["valor"], errors="coerce")
    result["tipo"] = result.apply(classify_transaction, axis=1)
    result["centro_custo"] = result.apply(
        lambda row: assign_center_cost(row, {"material": "Materiais", "serviço": "Serviços"}) , axis=1
    )
    result["conta"] = result["conta"].fillna("Sem conta informada")
    result["cliente_nome"] = result["cliente_nome"].fillna("Cliente indefinido")
    result = result.replace({np.nan: None})
    return result


def detect_duplicates(df: pd.DataFrame) -> pd.DataFrame:
    subset = ["data", "valor", "descricao", "centro_custo"]
    duplicates = df[df.duplicated(subset=subset, keep=False)]
    return duplicates


def build_importable_records(df: pd.DataFrame) -> List[Dict[str, Optional[str]]]:
    records = []
    for _, row in df.iterrows():
        records.append(
            {
                "data": row["data"],
                "descricao": row["descricao"],
                "centro_custo": row["centro_custo"],
                "cliente": row["cliente_nome"],
                "conta": row["conta"],
                "tipo": row["tipo"],
                "valor": row["valor"],
            }
        )
    return records


def extract_from_pdf(path: Path) -> pd.DataFrame:
    try:
        import pdfplumber
    except ImportError as exc:
        raise ImportError(
            "Instale 'pdfplumber' para habilitar extração de dados de PDF."
        ) from exc

    rows = []
    with pdfplumber.open(path) as pdf:
        for page in pdf.pages:
            table = page.extract_table()
            if table:
                header = [h.strip().lower() for h in table[0]]
                for item in table[1:]:
                    payload = dict(zip(header, item))
                    rows.append(payload)
    if not rows:
        return pd.DataFrame()
    df = pd.DataFrame(rows)
    return normalize_columns(df)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Processa planilhas de lançamentos financeiros e prepara registros para importação."
    )
    parser.add_argument(
        "--patterns",
        nargs="+",
        required=True,
        help="Padrões glob para localizar arquivos (ex: 'dados/gerenciamento*.xlsx').",
    )
    parser.add_argument(
        "--pdf",
        nargs="*",
        default=[],
        help="Arquivos PDF contendo extratos (opcional).",
    )

    args = parser.parse_args()
    df = load_financial_files(args.patterns)

    for pdf_path in args.pdf:
        pdf_df = extract_from_pdf(Path(pdf_path))
        if not pdf_df.empty:
            df = pd.concat([df, pdf_df], ignore_index=True, sort=False)

    duplicates = detect_duplicates(df)
    if not duplicates.empty:
        print("Foram encontrados lançamentos possivelmente duplicados:")
        print(duplicates[["data", "descricao", "valor", "centro_custo"]])

    print(f"Total de lançamentos processados: {len(df)}")
    print("Exemplos preparados para build:")
    records = build_importable_records(df.head(5))
    for record in records:
        print(record)


if __name__ == "__main__":
    main()
