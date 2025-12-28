// Script de limpeza da pasta database
// Mantém apenas: CRIAR-MODULO-*.sql, CRIAR_MODULO_*.sql, *.cjs

const fs = require('fs');
const path = require('path');

const pasta = __dirname;

const arquivos = fs.readdirSync(pasta);

let deletados = 0;
let mantidos = 0;

arquivos.forEach(nome => {
  const caminho = path.join(pasta, nome);

  // Verifica se é arquivo
  if (!fs.statSync(caminho).isFile()) return;

  // Verifica se deve manter
  const manter =
    nome.startsWith('CRIAR-MODULO-') ||
    nome.startsWith('CRIAR_MODULO_') ||
    nome.endsWith('.cjs');

  if (manter) {
    console.log('MANTER:', nome);
    mantidos++;
  } else {
    console.log('DELETE:', nome);
    fs.unlinkSync(caminho);
    deletados++;
  }
});

console.log('');
console.log('=================================');
console.log(`Arquivos deletados: ${deletados}`);
console.log(`Arquivos mantidos: ${mantidos}`);
console.log('=================================');
