from __future__ import annotations

from argparse import ArgumentParser
from pathlib import Path
import re
import sys

TABLE_CHECKS = {
    "propostas": {
        "nucleo": {"arquitetura", "engenharia", "marcenaria"},
     },
    "financeiro_lancamentos": {
        "nucleo": {"arquitetura", "engenharia", "marcenaria", "administrativo", "operacional"},
    },
}


def split_sql_tokens(source: str) -> list[str]:
    tokens: list[str] = []
    buffer: list[str] = []
    in_quote = False
    i = 0
    while i < len(source):
        char = source[i]
        if char == "'" and not in_quote:
            in_quote = True
            buffer.append(char)
        elif char == "'" and in_quote:
            buffer.append(char)
            if i + 1 < len(source) and source[i + 1] == "'":
                buffer.append("'")
                i += 1
            else:
                in_quote = False
        elif char == "," and not in_quote:
            tokens.append("".join(buffer).strip())
            buffer = []
        else:
            buffer.append(char)
        i += 1
    if buffer:
        tokens.append("".join(buffer).strip())
    return tokens


def unquote(value: str) -> str:
    value = value.strip()
    if value.startswith("'") and value.endswith("'"):
        return value[1:-1].replace("''", "'")
    return value


def find_closing_paren(text: str, start_idx: int) -> int:
    depth = 0
    in_quote = False
    i = start_idx
    while i < len(text):
        char = text[i]
        if char == "'" and not in_quote:
            in_quote = True
        elif char == "'" and in_quote:
            if i + 1 < len(text) and text[i + 1] == "'":
                i += 1
            else:
                in_quote = False
        elif not in_quote:
            if char == "(":
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    raise ValueError("Unmatched parenthesis in SQL")


def parse_columns(section: str) -> list[str]:
    return [token.strip().strip('"') for token in split_sql_tokens(section) if token]


def parse_tuple(tuple_text: str) -> list[str]:
    inner = tuple_text.strip()
    if inner.startswith("(") and inner.endswith(")"):
        inner = inner[1:-1]
    return [token for token in split_sql_tokens(inner) if token]


def parse_inserts(sql: str) -> list[tuple[str, list[str], list[list[str]]]]:
    inserts: list[tuple[str, list[str], list[list[str]]]] = []
    pattern = re.compile(r"INSERT\s+INTO\s+(\w+)", re.IGNORECASE)
    idx = 0
    while True:
        match = pattern.search(sql, idx)
        if not match:
            break
        table = match.group(1)
        col_open = sql.find("(", match.end())
        if col_open == -1:
            idx = match.end()
            continue
        col_close = find_closing_paren(sql, col_open)
        columns = parse_columns(sql[col_open + 1 : col_close])

        values_keyword = re.search(r"\bVALUES\b", sql[col_close:], re.IGNORECASE)
        if not values_keyword:
            idx = col_close
            continue
        values_start = col_close + values_keyword.end()
        tuples: list[list[str]] = []
        position = values_start
        while position < len(sql):
            while position < len(sql) and sql[position].isspace():
                position += 1
            if position >= len(sql) or sql[position] != "(":
                break
            tuple_end = find_closing_paren(sql, position)
            tuple_text = sql[position : tuple_end + 1]
            tuples.append(parse_tuple(tuple_text))
            position = tuple_end + 1
            while position < len(sql) and sql[position].isspace():
                position += 1
            if position < len(sql) and sql[position] == ",":
                position += 1
                continue
            break

        semicolon = sql.find(";", position)
        idx = semicolon + 1 if semicolon != -1 else position
        inserts.append((table, columns, tuples))
    return inserts


def validate_insert(table: str, columns: list[str], tuple_values: list[str]) -> None:
    checks = TABLE_CHECKS.get(table.lower())
    if not checks:
        return
    mapping = {col.lower(): unquote(val) for col, val in zip(columns, tuple_values)}
    for column, allowed in checks.items():
        raw_value = mapping.get(column)
        if raw_value is None:
            continue
        if raw_value not in allowed:
            raise ValueError(
                f"{table}: value '{raw_value}' is invalid for {column}; expected one of {sorted(allowed)}"
            )


def main() -> None:
    parser = ArgumentParser(description="Validar inserts financeiros antes de aplicar o SQL")
    parser.add_argument(
        "sql",
        nargs="?",
        type=Path,
        default=Path("frontend/database/CRIAR_DADOS_TESTE_GRAFICOS.sql"),
        help="Arquivo SQL de dados financeiros para validar",
    )
    args = parser.parse_args()
    content = args.sql.read_text(encoding="utf-8")
    inserts = parse_inserts(content)
    if not inserts:
        print("Nenhum INSERT encontrado.")
        return
    for table, columns, tuples in inserts:
        for tuple_values in tuples:
            if len(tuple_values) != len(columns):
                continue
            validate_insert(table, columns, tuple_values)
    print("Validacao concluida com sucesso.")


if __name__ == "__main__":
    try:
        main()
    except ValueError as exc:
        print(f"Erro na validacao: {exc}")
        sys.exit(1)
