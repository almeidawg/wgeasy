/**
 * Script para remover console.log de produção
 * Mantém console.error, console.warn e console.debug
 * Executa: node scripts/remover-console-log.cjs
 */

const fs = require('fs');
const path = require('path');

const SRC_DIR = path.join(__dirname, '..', 'src');

// Padrões para remover (console.log apenas)
const PATTERNS_TO_REMOVE = [
  /^\s*console\.log\([^)]*\);?\s*$/gm,  // console.log em linha única
  /console\.log\([^)]*\)[,;]?\s*/g,      // console.log inline
];

// Arquivos a ignorar
const IGNORE_FILES = [
  'node_modules',
  '.git',
  'dist',
  'build',
];

let totalRemoved = 0;
let filesModified = 0;

function shouldIgnore(filePath) {
  return IGNORE_FILES.some(ignore => filePath.includes(ignore));
}

function processFile(filePath) {
  if (shouldIgnore(filePath)) return;
  if (!filePath.endsWith('.ts') && !filePath.endsWith('.tsx') && !filePath.endsWith('.js')) return;

  let content = fs.readFileSync(filePath, 'utf8');
  const originalContent = content;
  let removedCount = 0;

  // Contar e remover console.log
  const matches = content.match(/console\.log\(/g);
  if (matches) {
    removedCount = matches.length;
  }

  // Remover linhas com apenas console.log
  content = content.replace(/^\s*console\.log\([^)]*\);?\s*\n/gm, '');

  // Substituir console.log por comentário em linhas com mais código
  // content = content.replace(/console\.log\([^)]*\)[,;]?\s*/g, '/* log removed */ ');

  if (content !== originalContent) {
    // Por segurança, não salva automaticamente - apenas mostra o que seria removido
    console.log(`📄 ${filePath.replace(SRC_DIR, 'src')}: ${removedCount} console.log encontrados`);
    totalRemoved += removedCount;
    filesModified++;

    // Descomente para aplicar as mudanças:
    // fs.writeFileSync(filePath, content, 'utf8');
  }
}

function processDirectory(dirPath) {
  if (shouldIgnore(dirPath)) return;

  const items = fs.readdirSync(dirPath);

  for (const item of items) {
    const fullPath = path.join(dirPath, item);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      processDirectory(fullPath);
    } else if (stat.isFile()) {
      processFile(fullPath);
    }
  }
}

console.log('🔍 Procurando console.log em src/...\n');
processDirectory(SRC_DIR);

console.log('\n========================================');
console.log(`📊 Total: ${totalRemoved} console.log em ${filesModified} arquivos`);
console.log('========================================');
console.log('\n⚠️  Este script apenas LISTA os console.log.');
console.log('    Para REMOVER, descomente a linha fs.writeFileSync no código.');
