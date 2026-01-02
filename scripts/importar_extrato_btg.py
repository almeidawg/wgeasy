#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Importador de Extrato BTG para WG Easy
Lê arquivo Excel e insere lançamentos no Supabase
"""

import pandas as pd
import requests
import json
from datetime import datetime
import uuid

# Configurações Supabase (usando service_role para bypass RLS)
SUPABASE_URL = "https://ahlqzzkxuutwoepirrpzr.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo"

HEADERS = {
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal"
}

# Mapeamento de núcleos
NUCLEOS = {
    "ENG": "engenharia",
    "ARQ": "arquitetura",
    "MAR": "marcenaria",
    "ADM": "administrativo"
}

# Mapeamento de categorias
CATEGORIAS_MAP = {
    "DESP-PESSOAL": "Despesa Pessoal",
    "DESP-SEM-INFO": "Despesa Sem Classificação",
    "DESP-MO-COLAB": "Mão de Obra - Colaborador",
    "DESP-MO-TERC": "Mão de Obra - Terceiros",
    "DESP-MATERIAL": "Material",
    "DESP-OPER": "Despesa Operacional",
    "REC-CLIENTE": "Receita Cliente"
}

def parse_date(date_str):
    """Converte data do formato DD/MM/YYYY para YYYY-MM-DD"""
    if pd.isna(date_str):
        return datetime.now().strftime("%Y-%m-%d")
    try:
        if isinstance(date_str, str):
            parts = date_str.split("/")
            if len(parts) == 3:
                return f"{parts[2]}-{parts[1]}-{parts[0]}"
        return datetime.now().strftime("%Y-%m-%d")
    except:
        return datetime.now().strftime("%Y-%m-%d")

def buscar_centros_custo():
    """Busca centros de custo existentes"""
    url = f"{SUPABASE_URL}/rest/v1/financeiro_centros_custo?select=id,codigo,nome"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        centros = response.json()
        return {c.get('codigo', ''): c['id'] for c in centros if c.get('codigo')}
    return {}

def buscar_contas_bancarias():
    """Busca contas bancárias"""
    url = f"{SUPABASE_URL}/rest/v1/financeiro_contas_bancarias?select=id,nome,banco"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        contas = response.json()
        # Retorna a primeira conta BTG encontrada ou a primeira conta
        for c in contas:
            if 'BTG' in c.get('banco', '').upper() or 'BTG' in c.get('nome', '').upper():
                return c['id']
        return contas[0]['id'] if contas else None
    return None

def inserir_lancamento(lancamento):
    """Insere um lançamento no Supabase"""
    url = f"{SUPABASE_URL}/rest/v1/financeiro_lancamentos"
    response = requests.post(url, headers=HEADERS, json=lancamento)
    return response.status_code in [200, 201]

def main():
    print("=" * 60)
    print("  IMPORTADOR EXTRATO BTG -> WG EASY")
    print("=" * 60)
    print()

    # Ler arquivo Excel
    arquivo = r"C:\Users\Atendimento\Documents\EXTRATO_BTG_IMPORTACAO_WGEASYreformas.xlsx"
    print(f"Lendo arquivo: {arquivo}")

    try:
        df = pd.read_excel(arquivo)
        print(f"[OK] {len(df)} registros encontrados")
    except Exception as e:
        print(f"[ERRO] Falha ao ler arquivo: {e}")
        return

    # Buscar dados auxiliares
    print("\nBuscando centros de custo...")
    centros_custo = buscar_centros_custo()
    print(f"[OK] {len(centros_custo)} centros de custo encontrados")

    print("Buscando conta bancária BTG...")
    conta_bancaria_id = buscar_contas_bancarias()
    print(f"[OK] Conta: {conta_bancaria_id}")

    # Processar e inserir lançamentos
    print("\n" + "-" * 60)
    print("Inserindo lançamentos...")
    print("-" * 60)

    sucesso = 0
    erros = 0

    for idx, row in df.iterrows():
        try:
            # Determinar se é entrada ou saída
            tipo = str(row.get('TIPO', '')).upper()
            is_entrada = tipo == 'RECEITA'

            # Mapear núcleo
            empresa = str(row.get('EMPRESA', 'ADM')).upper()
            nucleo = NUCLEOS.get(empresa, 'administrativo')

            # Mapear centro de custo
            centro_custo_codigo = str(row.get('CENTRO_CUSTO', ''))
            centro_custo_id = centros_custo.get(centro_custo_codigo)

            # Mapear categoria
            categoria_codigo = str(row.get('CATEGORIA', ''))
            categoria = CATEGORIAS_MAP.get(categoria_codigo, categoria_codigo)

            # Valor
            valor = float(row.get('VALOR', 0))

            # Data
            data_str = parse_date(row.get('DATA'))

            # Descrição
            favorecido = str(row.get('FAVORECIDO_NOME', ''))
            descricao_orig = str(row.get('DESCRICAO', ''))
            mensagem_pix = str(row.get('MENSAGEM_PIX', ''))

            descricao = f"{favorecido}"
            if mensagem_pix and mensagem_pix != 'nan':
                descricao += f" - {mensagem_pix}"

            # Observações
            observacoes = descricao_orig
            if row.get('CLASSIFICACAO_AUTO'):
                observacoes += f" | Classificação: {row.get('CLASSIFICACAO_AUTO')}"

            # Montar lançamento
            lancamento = {
                "id": str(uuid.uuid4()),
                "tipo": "despesa" if not is_entrada else "receita",
                "is_entrada": is_entrada,
                "natureza": str(row.get('NATUREZA', 'PIX')),
                "valor": valor,
                "valor_total": valor,
                "data_emissao": data_str,
                "data_competencia": data_str,
                "descricao": descricao[:500] if descricao else "Importado BTG",
                "categoria": categoria,
                "nucleo": nucleo,
                "status": "pendente",
                "observacoes": observacoes[:1000] if observacoes else None,
                "numero_parcelas": 1,
                "conta_bancaria_id": conta_bancaria_id
            }

            # Adicionar centro de custo se encontrado
            if centro_custo_id:
                lancamento["centro_custo_id"] = centro_custo_id

            # Inserir
            if inserir_lancamento(lancamento):
                sucesso += 1
                print(f"[{idx+1}/{len(df)}] {descricao[:40]}... R$ {valor:.2f} [OK]")
            else:
                erros += 1
                print(f"[{idx+1}/{len(df)}] {descricao[:40]}... [ERRO]")

        except Exception as e:
            erros += 1
            print(f"[{idx+1}/{len(df)}] ERRO: {e}")

    print()
    print("=" * 60)
    print(f"  IMPORTAÇÃO CONCLUÍDA!")
    print(f"  {sucesso} inseridos com sucesso")
    print(f"  {erros} erros")
    print("=" * 60)

if __name__ == "__main__":
    main()
