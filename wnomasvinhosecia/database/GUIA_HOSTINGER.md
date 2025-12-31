# GUIA: Criar Banco de Dados na Hostinger

## Passo 1: Acessar o hPanel

1. Acesse: **https://hpanel.hostinger.com**
2. Faça login com sua conta Hostinger
3. Selecione o domínio/site do Wno Mas

---

## Passo 2: Criar o Banco de Dados MySQL

1. No menu lateral, clique em **"Banco de Dados"** ou **"MySQL Databases"**

2. Na seção **"Criar novo banco de dados MySQL"**:
   - **Nome do banco:** `wnomas_db`
   - **Nome do usuário:** `wnomas_user`
   - **Senha:** (crie uma senha forte e ANOTE!)

3. Clique em **"Criar"**

4. **IMPORTANTE - Anote essas informações:**
   ```
   Host: localhost (ou mysql.seudominio.com)
   Banco: u123456789_wnomas_db
   Usuário: u123456789_wnomas_user
   Senha: [sua_senha]
   ```

---

## Passo 3: Acessar o phpMyAdmin

1. Ainda na página de Banco de Dados, encontre seu banco criado
2. Clique no botão **"phpMyAdmin"** ou **"Entrar no phpMyAdmin"**
3. O phpMyAdmin abrirá em uma nova aba

---

## Passo 4: Executar o Script SQL

1. No phpMyAdmin, selecione seu banco de dados na lista à esquerda

2. Clique na aba **"SQL"** no menu superior

3. Abra o arquivo `wnomas_database.sql` que está na pasta `database`

4. Copie TODO o conteúdo do arquivo

5. Cole no campo de texto do phpMyAdmin

6. Clique em **"Executar"** ou **"Go"**

7. Aguarde a mensagem de sucesso (verde)

---

## Passo 5: Verificar as Tabelas

Após executar, você deve ver estas tabelas no painel esquerdo:

```
✓ categorias
✓ clientes
✓ configuracoes
✓ estoque
✓ fornecedores
✓ harmonizacoes
✓ kit_vinhos
✓ kits
✓ movimentacoes_estoque
✓ paises
✓ pedido_itens
✓ pedidos
✓ regioes
✓ uvas
✓ vinho_fornecedores
✓ vinho_harmonizacoes
✓ vinho_uvas
✓ vinhos
```

**Views criadas:**
- vw_estoque_baixo
- vw_financeiro_vinhos
- vw_vendas_por_vinho

---

## Passo 6: Configurar Conexão (para API)

Guarde estas informações para usar na API PHP:

```php
<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'u123456789_wnomas_db');  // Seu nome real
define('DB_USER', 'u123456789_wnomas_user'); // Seu usuário real
define('DB_PASS', 'sua_senha_aqui');          // Sua senha real
?>
```

---

## Estrutura do Banco de Dados

### Tabelas Principais:

| Tabela | Descrição |
|--------|-----------|
| `vinhos` | Catálogo completo de vinhos |
| `categorias` | Tipos (Tinto, Branco, Espumante, Rosé) |
| `estoque` | Quantidade e localização |
| `clientes` | Dados dos clientes |
| `pedidos` | Pedidos realizados |
| `pedido_itens` | Itens de cada pedido |
| `fornecedores` | Fornecedores cadastrados |
| `kits` | Kits/Seleções de vinhos |

### Tabelas de Relacionamento:

| Tabela | Relaciona |
|--------|-----------|
| `vinho_uvas` | Vinhos ↔ Uvas |
| `vinho_fornecedores` | Vinhos ↔ Fornecedores |
| `vinho_harmonizacoes` | Vinhos ↔ Harmonizações |
| `kit_vinhos` | Kits ↔ Vinhos |

---

## Próximos Passos

Após criar o banco, precisaremos:

1. **Criar API PHP** - Para conectar o React ao MySQL
2. **Popular os vinhos** - Migrar dados do wines.js para o banco
3. **Configurar endpoints** - CRUD completo

---

## Troubleshooting

### Erro "Access denied"
- Verifique se usuário e senha estão corretos
- Certifique-se de que o usuário tem permissões no banco

### Erro "Table already exists"
- O script pode ser executado várias vezes sem problemas
- As tabelas usam `CREATE TABLE IF NOT EXISTS`

### Erro de charset
- O banco usa `utf8mb4` para suportar emojis e caracteres especiais
- Verifique se o phpMyAdmin está configurado para UTF-8
