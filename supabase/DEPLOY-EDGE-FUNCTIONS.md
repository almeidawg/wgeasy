# Deploy das Edge Functions - Supabase Auth Admin

## Funcoes Criadas

### 1. `alterar-senha-admin`
Altera a senha de um usuario no Supabase Auth.

**Parametros:**
- `usuario_id` (opcional): ID do usuario na tabela usuarios
- `auth_user_id` (opcional): ID do usuario no Auth
- `email` (opcional): Email do usuario
- `nova_senha` (obrigatorio): Nova senha (minimo 6 caracteres)

### 2. `excluir-usuario-admin`
Exclui um usuario do Supabase Auth e da tabela usuarios.

**Parametros:**
- `usuario_id` (opcional): ID do usuario na tabela usuarios
- `auth_user_id` (opcional): ID do usuario no Auth
- `email` (opcional): Email do usuario
- `excluir_pessoa` (opcional): Se true, tambem exclui a pessoa vinculada

---

## Como Fazer Deploy

### Opcao 1: Via CLI do Supabase (Recomendado)

```bash
# 1. Instalar Supabase CLI (se ainda nao tiver)
npm install -g supabase

# 2. Fazer login
supabase login

# 3. Linkar ao projeto
cd sistema/wgeasy/supabase
supabase link --project-ref SEU_PROJECT_REF

# 4. Deploy de TODAS as funcoes
supabase functions deploy

# OU deploy individual:
supabase functions deploy alterar-senha-admin
supabase functions deploy excluir-usuario-admin
```

### Opcao 2: Via Dashboard do Supabase

1. Acesse: https://supabase.com/dashboard/project/SEU_PROJETO/functions
2. Clique em "New Function"
3. Nome: `alterar-senha-admin`
4. Cole o conteudo de `functions/alterar-senha-admin/index.ts`
5. Clique em "Deploy"
6. Repita para `excluir-usuario-admin`

---

## Verificar Deploy

```bash
# Testar se as funcoes estao funcionando
supabase functions list
```

No dashboard:
- Va em Functions
- Verifique se as 3 funcoes aparecem:
  - `criar-usuario-admin` (ja existia)
  - `alterar-senha-admin` (nova)
  - `excluir-usuario-admin` (nova)

---

## Uso no Frontend

As funcoes ja estao integradas na API:

```typescript
import { resetarSenhaUsuario, excluirUsuario } from '@/lib/usuariosApi';

// Alterar senha
const resultado = await resetarSenhaUsuario({
  usuario_id: 'uuid-do-usuario',
  nova_senha: 'NovaSenha123' // opcional, gera automatico se omitir
});

// Excluir usuario
const resultado = await excluirUsuario('uuid-do-usuario');
// resultado.auth_excluido, resultado.usuario_excluido, etc.
```

---

## Permissoes Necessarias

As Edge Functions usam `SUPABASE_SERVICE_ROLE_KEY` que ja esta configurado automaticamente no ambiente de execucao das funcoes.

NAO eh necessario configurar nada adicional.
