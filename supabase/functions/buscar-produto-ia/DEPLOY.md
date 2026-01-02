# Deploy da Edge Function: buscar-produto-ia

## Funcionalidades

Esta Edge Function oferece 3 métodos de busca de produtos:

### 1. `extrair_direto` (NOVO - Sem OpenAI)
- Extrai dados de produto diretamente da URL
- Funciona com Leroy Merlin, Amazon, e outros
- **Não requer** chave OpenAI
- Usa scraping inteligente (JSON-LD, meta tags)

### 2. `buscar_ml` (Sem OpenAI)
- Busca produtos no Mercado Livre
- Usa API pública oficial
- **Não requer** chave OpenAI

### 3. `buscar` / `extrair` (Requer OpenAI)
- Busca com inteligência artificial
- Fallback automático para métodos sem IA

## Deploy

### Passo 1: Login no Supabase
```bash
cd c:\Users\Atendimento\Documents\01VISUALSTUDIO_OFICIAL\sistema\wgeasy
supabase login
```

### Passo 2: Linkar projeto
```bash
supabase link --project-ref ahlqzzkxuutwoepirpzr
```

### Passo 3: Deploy da função
```bash
supabase functions deploy buscar-produto-ia --no-verify-jwt
```

### Passo 4 (Opcional): Configurar OpenAI
Se quiser usar busca com IA:
```bash
supabase secrets set OPENAI_API_KEY=sk-...
```

## Teste Local

```bash
# Testar extração direta (funciona sem deploy)
cd supabase/functions/buscar-produto-ia
node test-extracao-completa.mjs
```

## Sites Suportados

| Site | Método | Status |
|------|--------|--------|
| Leroy Merlin | Scraping direto | ✅ Funciona |
| Mercado Livre | API oficial | ✅ Funciona |
| Amazon | Scraping direto | ⚠️ Pode variar |
| Magazine Luiza | Scraping direto | ⚠️ Pode variar |
| Casas Bahia | Scraping direto | ⚠️ Pode variar |

## Exemplo de Uso

```typescript
// No frontend
const response = await fetch(EDGE_FUNCTION_URL, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  },
  body: JSON.stringify({
    termoBusca: 'https://www.leroymerlin.com.br/produto_12345',
    tipo: 'extrair_direto'
  }),
});

const { produto } = await response.json();
// produto = { titulo, preco, marca, sku, imagem_url, ... }
```
