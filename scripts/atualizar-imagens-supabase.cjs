/**
 * Script para atualizar imagens dos produtos no banco de dados Supabase
 * Este script lê as imagens encontradas do JSON e atualiza a tabela pricelist_itens
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// Configuração do Supabase
const SUPABASE_URL = 'https://ahlqzzkxuutwoepirpzr.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1NzEyNDMsImV4cCI6MjA3NjE0NzI0M30.gLz5lpB5YlQpTfxzJjmILZwGp_H_XsT81nM2vXDbs7Y';

// Caminho do arquivo JSON com imagens
const PRODUTOS_COM_IMAGENS_JSON = path.join(__dirname, '../frontend/database/leroy-produtos-com-imagens.json');

// Função para fazer requisição HTTP
function httpRequest(method, endpoint, data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(endpoint, SUPABASE_URL);

    const options = {
      hostname: url.hostname,
      path: url.pathname + url.search,
      method: method,
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
      }
    };

    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          const result = body ? JSON.parse(body) : null;
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(result);
          } else {
            reject({ status: res.statusCode, error: result });
          }
        } catch (e) {
          resolve(body);
        }
      });
    });

    req.on('error', reject);

    if (data) {
      req.write(JSON.stringify(data));
    }

    req.end();
  });
}

// Normaliza string para comparação
function normalizar(str) {
  return str
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

// Função principal
async function main() {
  console.log('=== Atualizador de Imagens no Supabase ===\n');

  // 1. Carrega produtos do JSON com imagens
  const produtosJSON = JSON.parse(fs.readFileSync(PRODUTOS_COM_IMAGENS_JSON, 'utf-8'));
  const produtosComImagem = produtosJSON.filter(p => p.imagem);

  console.log(`Produtos no JSON: ${produtosJSON.length}`);
  console.log(`Produtos com imagem: ${produtosComImagem.length}\n`);

  if (produtosComImagem.length === 0) {
    console.log('Nenhum produto com imagem para atualizar.');
    return;
  }

  // 2. Busca todos os produtos da pricelist
  console.log('Buscando produtos da pricelist no Supabase...');

  try {
    const endpoint = '/rest/v1/pricelist_itens?select=id,nome,imagem_url';
    const pricelistItens = await httpRequest('GET', endpoint);

    console.log(`Produtos na pricelist: ${pricelistItens.length}\n`);

    // 3. Para cada produto com imagem, tenta encontrar correspondente na pricelist
    let atualizados = 0;
    let naoEncontrados = [];

    for (const produto of produtosComImagem) {
      const descricaoNorm = normalizar(produto.descricao);

      // Busca produto correspondente na pricelist
      const match = pricelistItens.find(item => {
        const nomeNorm = normalizar(item.nome);
        return nomeNorm === descricaoNorm ||
               nomeNorm.includes(descricaoNorm) ||
               descricaoNorm.includes(nomeNorm);
      });

      if (match) {
        // Verifica se já tem imagem
        if (match.imagem_url) {
          console.log(`[SKIP] Já tem imagem: ${produto.descricao.substring(0, 50)}...`);
          continue;
        }

        // Atualiza no banco de dados
        console.log(`[UPDATE] Atualizando: ${produto.descricao.substring(0, 50)}...`);

        try {
          const updateEndpoint = `/rest/v1/pricelist_itens?id=eq.${match.id}`;
          await httpRequest('PATCH', updateEndpoint, {
            imagem_url: produto.imagem,
            updated_at: new Date().toISOString()
          });

          atualizados++;
          console.log(`         Imagem: ${produto.imagem.substring(0, 60)}...`);
        } catch (err) {
          console.log(`         ERRO: ${err.message || JSON.stringify(err)}`);
        }
      } else {
        naoEncontrados.push(produto.descricao);
      }
    }

    // 4. Resumo
    console.log('\n=== Resumo ===');
    console.log(`Produtos atualizados: ${atualizados}`);
    console.log(`Produtos não encontrados na pricelist: ${naoEncontrados.length}`);

    if (naoEncontrados.length > 0) {
      console.log('\nProdutos não encontrados:');
      naoEncontrados.forEach(desc => {
        console.log(`  - ${desc.substring(0, 60)}...`);
      });
    }

  } catch (error) {
    console.error('Erro ao acessar Supabase:', error);
  }
}

main().catch(console.error);
