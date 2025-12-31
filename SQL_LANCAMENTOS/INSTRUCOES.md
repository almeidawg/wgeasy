# INSTRUÇÕES DE IMPORTAÇÃO - LANÇAMENTOS FINANCEIROS

## Resumo

- **Total de registros:** 2.215
- **Batches gerados:** 12 (200 registros cada, último com 15)
- **Núcleo:** arquitetura (WG Designer)
- **Tabela destino:** `financeiro_lancamentos`

## Arquivos Gerados

### Preparação (executar primeiro)
- `00_PREPARACAO.sql` - Verifica lançamentos existentes

### Batches de Importação (executar em sequência)
| Arquivo | Registros |
|---------|-----------|
| BATCH_01_financeiro.sql | 1 a 200 |
| BATCH_02_financeiro.sql | 201 a 400 |
| BATCH_03_financeiro.sql | 401 a 600 |
| BATCH_04_financeiro.sql | 601 a 800 |
| BATCH_05_financeiro.sql | 801 a 1000 |
| BATCH_06_financeiro.sql | 1001 a 1200 |
| BATCH_07_financeiro.sql | 1201 a 1400 |
| BATCH_08_financeiro.sql | 1401 a 1600 |
| BATCH_09_financeiro.sql | 1601 a 1800 |
| BATCH_10_financeiro.sql | 1801 a 2000 |
| BATCH_11_financeiro.sql | 2001 a 2200 |
| BATCH_12_financeiro.sql | 2201 a 2215 |

## Como Executar

### Passo 1: Verificar lançamentos existentes
1. Acesse o SQL Editor do Supabase
2. Execute o arquivo `00_PREPARACAO.sql`
3. Analise os resultados para decidir se precisa limpar registros antigos

### Passo 2: Limpar registros existentes (se necessário)
Se precisar substituir lançamentos existentes, descomente e execute:
```sql
DELETE FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura';
```

### Passo 3: Importar os batches
Execute cada arquivo na ordem:
1. BATCH_01_financeiro.sql
2. BATCH_02_financeiro.sql
3. ... até BATCH_12_financeiro.sql

### Passo 4: Verificar importação
```sql
SELECT
    nucleo,
    tipo,
    COUNT(*) as total,
    SUM(valor_total) as valor_total
FROM financeiro_lancamentos
WHERE nucleo = 'arquitetura'
GROUP BY nucleo, tipo;
```

## Estrutura dos Dados

Cada registro contém:
- **data_competencia:** Data do lançamento
- **tipo:** 'saida' ou 'entrada'
- **valor_total:** Valor em R$
- **descricao:** Favorecido + descrição original
- **status:** 'pago' (convertido de Realizado/Pago)
- **nucleo:** 'arquitetura' (WG Designer)
- **observacoes:** Centro de custo, conta e categoria originais

## Resultado Esperado

Após importação completa:
- **Total:** 2.215 lançamentos
- **Núcleo:** arquitetura
- **Período:** 2013 a 2024
