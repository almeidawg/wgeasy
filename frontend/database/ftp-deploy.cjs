// FTP Deploy Script para WG Easy
const ftp = require('basic-ftp');
const path = require('path');
const fs = require('fs');

const config = {
  host: '147.93.64.151',
  user: 'u968231423.wgalmeida-com-br-238673.hostingersite.com',
  password: '130300@\$Wg',
  secure: false
};

const localDir = 'C:\\Users\\Atendimento\\Documents\\01VISUALSTUDIO_OFICIAL\\sistema\\wgeasy\\frontend\\dist';
const remoteDir = '/domains/easy.wgalmeida.com.br/public_html';

async function deploy() {
  const client = new ftp.Client();
  client.ftp.verbose = true;

  try {
    console.log('========================================');
    console.log('  DEPLOY FTP - WGeasy Sistema');
    console.log('========================================\n');

    console.log('Conectando ao servidor FTP...');
    await client.access(config);
    console.log('[OK] Conectado!\n');

    console.log(`Navegando para: ${remoteDir}`);
    await client.ensureDir(remoteDir);
    console.log('[OK] Diretório OK\n');

    console.log('Iniciando upload dos arquivos...\n');
    await client.uploadFromDir(localDir, remoteDir);

    console.log('\n========================================');
    console.log('  DEPLOY CONCLUIDO COM SUCESSO!');
    console.log('========================================');
    console.log('\nSite atualizado em: https://easy.wgalmeida.com.br');

  } catch (err) {
    console.error('\n[ERRO]', err.message);
  } finally {
    client.close();
  }
}

deploy();
