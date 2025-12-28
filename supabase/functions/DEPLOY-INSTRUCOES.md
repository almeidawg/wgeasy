# Deploy das Edge Functions

## Pré-requisitos
1. Supabase CLI instalado
2. Fazer login: `supabase login`

## Fazer Deploy

Execute no terminal:

```bash
cd C:\Users\Atendimento\Documents\01VISUALSTUDIO_OFICIAL\sistema\wgeasy\supabase

# Login no Supabase (se não estiver logado)
supabase login

# Link do projeto (WG Dev)
supabase link --project-ref ahlqzzkxuutwoepirpzr

# Deploy das funções
supabase functions deploy criar-usuario-admin
supabase functions deploy vincular-usuarios-existentes
```

## Alternativa: Deploy via Dashboard

1. Acesse: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/functions
2. Clique em "Deploy a new function"
3. Cole o código de cada função:
   - `criar-usuario-admin/index.ts`
   - `vincular-usuarios-existentes/index.ts`

## Após o Deploy

1. Abra: `database\CORRIGIR-USUARIOS-SEM-AUTH.html`
2. Clique em "Atualizar Lista"
3. Clique em "Corrigir Todos" para criar acesso para todos os usuários

## O que as funções fazem

### criar-usuario-admin
- Cria usuários no Auth já confirmados (sem necessidade de confirmar email)
- Usada automaticamente quando criamos novos usuários pelo sistema

### vincular-usuarios-existentes
- Lista usuários sem auth_user_id
- Cria acesso Auth para usuários existentes que não conseguem logar
- Gera senhas temporárias
