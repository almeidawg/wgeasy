#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Upload Sistema WGeasy direto para easy.wgalmeida.com.br
"""

import os
import time
from ftplib import FTP

FTP_HOST = "147.93.64.151"
FTP_USER = "u968231423.easy.wgalmeida.com.br"
FTP_PASS = "WGEasy2026!"

SISTEMA_DIST = r"C:\Users\Atendimento\Documents\01VISUALSTUDIO_OFICIAL\sistema\wgeasy\frontend\dist"
REMOTE_PATH = "/public_html"

def conectar():
    ftp = FTP(FTP_HOST, timeout=30)
    ftp.login(FTP_USER, FTP_PASS)
    ftp.set_pasv(True)
    return ftp

def criar_dir(remote_dir):
    try:
        ftp = conectar()
        ftp.mkd(remote_dir)
        ftp.quit()
        print(f"  [DIR] {remote_dir}")
    except:
        pass

def upload_com_retry(local_file, remote_file, max_tentativas=3):
    for tentativa in range(max_tentativas):
        try:
            ftp = conectar()
            with open(local_file, 'rb') as f:
                ftp.storbinary(f'STOR {remote_file}', f)
            ftp.quit()
            return True
        except Exception as e:
            if tentativa < max_tentativas - 1:
                time.sleep(1)
            else:
                print(f"  [FALHA] {os.path.basename(remote_file)}")
                return False
    return False

def main():
    print("=" * 60)
    print("  UPLOAD SISTEMA - easy.wgalmeida.com.br")
    print("  FTP direto do subdominio")
    print("=" * 60)
    print()

    # Testar conexao
    print("Testando conexao...")
    try:
        ftp = conectar()
        print(f"Conectado! Dir: {ftp.pwd()}")
        ftp.quit()
    except Exception as e:
        print(f"Erro de conexao: {e}")
        return

    # Coletar arquivos
    arquivos = []
    diretorios = set()

    for root, dirs, files in os.walk(SISTEMA_DIST):
        rel_path = os.path.relpath(root, SISTEMA_DIST)
        if rel_path == ".":
            rel_path = ""

        if rel_path:
            remote_dir = REMOTE_PATH + "/" + rel_path.replace("\\", "/")
            diretorios.add(remote_dir)

        for filename in files:
            local_file = os.path.join(root, filename)
            if rel_path:
                remote_file = REMOTE_PATH + "/" + rel_path.replace("\\", "/") + "/" + filename
            else:
                remote_file = REMOTE_PATH + "/" + filename
            arquivos.append((local_file, remote_file))

    print(f"Arquivos: {len(arquivos)}")
    print(f"Diretorios: {len(diretorios)}")
    print()

    # Criar diretorios
    print("Criando diretorios...")
    for d in sorted(diretorios):
        criar_dir(d)

    # Upload arquivos
    print("\nEnviando arquivos...")
    enviados = 0
    erros = 0

    for i, (local_file, remote_file) in enumerate(arquivos, 1):
        nome = os.path.basename(remote_file)
        # Limitar nome para evitar erro de encoding
        nome_display = nome[:35] if len(nome) > 35 else nome
        print(f"[{i}/{len(arquivos)}] {nome_display}", end=" ")
        if upload_com_retry(local_file, remote_file):
            print("[OK]")
            enviados += 1
        else:
            erros += 1

    print()
    print("=" * 60)
    print(f"  SISTEMA ENVIADO!")
    print(f"  {enviados} OK, {erros} erros")
    print("=" * 60)
    print("\nAcesse: https://easy.wgalmeida.com.br")

if __name__ == "__main__":
    main()
