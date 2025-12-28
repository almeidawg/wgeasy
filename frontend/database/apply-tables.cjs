// Script para aplicar tabelas faltantes no Supabase
const { Client } = require('pg');

// Conexão direta ao banco
const connectionString = 'postgresql://postgres:130300%40%24Wgalmeida@db.ahlqzzkxuutwoepirpzr.supabase.co:5432/postgres';

async function run() {
    const client = new Client({ connectionString });

    try {
        console.log('Conectando ao Supabase...');
        await client.connect();
        console.log('Conectado!\n');

        // 1. Verificar tabelas existentes
        console.log('1. Verificando tabelas existentes...');
        const existingTables = await client.query(`
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'public'
            AND table_name IN ('nucleos', 'fin_categories', 'pricelist_categorias', 'pricelist_subcategorias', 'pricelist_itens')
        `);

        const existing = existingTables.rows.map(r => r.table_name);
        console.log('   Tabelas existentes:', existing.length > 0 ? existing.join(', ') : 'nenhuma');

        // 2. Criar tabela nucleos se não existir
        if (!existing.includes('nucleos')) {
            console.log('\n2. Criando tabela nucleos...');
            await client.query(`
                CREATE TABLE nucleos (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    nome VARCHAR(100) NOT NULL,
                    codigo VARCHAR(20),
                    cor VARCHAR(20) DEFAULT '#F25C26',
                    icone VARCHAR(50),
                    ordem INTEGER DEFAULT 0,
                    ativo BOOLEAN DEFAULT true,
                    criado_em TIMESTAMPTZ DEFAULT NOW(),
                    atualizado_em TIMESTAMPTZ DEFAULT NOW()
                )
            `);
            await client.query(`CREATE INDEX IF NOT EXISTS idx_nucleos_ativo ON nucleos(ativo)`);
            console.log('   [OK] nucleos criada');
        } else {
            console.log('\n2. [SKIP] nucleos já existe');
            // Adicionar coluna ordem se não existir
            await client.query(`ALTER TABLE nucleos ADD COLUMN IF NOT EXISTS ordem INTEGER DEFAULT 0`).catch(() => {});
        }

        // 3. Criar tabela fin_categories se não existir
        if (!existing.includes('fin_categories')) {
            console.log('\n3. Criando tabela fin_categories...');
            await client.query(`
                CREATE TABLE fin_categories (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    name VARCHAR(200) NOT NULL,
                    kind VARCHAR(20) NOT NULL CHECK (kind IN ('income', 'expense')),
                    parent_id UUID REFERENCES fin_categories(id) ON DELETE SET NULL,
                    ordem INTEGER DEFAULT 0,
                    ativo BOOLEAN DEFAULT true,
                    created_at TIMESTAMPTZ DEFAULT NOW(),
                    updated_at TIMESTAMPTZ DEFAULT NOW()
                )
            `);
            await client.query(`CREATE INDEX IF NOT EXISTS idx_fin_categories_kind ON fin_categories(kind)`);
            console.log('   [OK] fin_categories criada');
        } else {
            console.log('\n3. [SKIP] fin_categories já existe');
        }

        // 4. Criar tabela pricelist_categorias se não existir
        if (!existing.includes('pricelist_categorias')) {
            console.log('\n4. Criando tabela pricelist_categorias...');
            await client.query(`
                CREATE TABLE pricelist_categorias (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    nome VARCHAR(200) NOT NULL,
                    codigo VARCHAR(50),
                    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('mao_obra', 'material', 'servico', 'produto')),
                    descricao TEXT,
                    ordem INTEGER DEFAULT 0,
                    ativo BOOLEAN DEFAULT true,
                    created_at TIMESTAMPTZ DEFAULT NOW(),
                    updated_at TIMESTAMPTZ DEFAULT NOW()
                )
            `);
            await client.query(`CREATE INDEX IF NOT EXISTS idx_pricelist_categorias_tipo ON pricelist_categorias(tipo)`);
            console.log('   [OK] pricelist_categorias criada');
        } else {
            console.log('\n4. [SKIP] pricelist_categorias já existe');
        }

        // 5. Criar tabela pricelist_subcategorias se não existir
        if (!existing.includes('pricelist_subcategorias')) {
            console.log('\n5. Criando tabela pricelist_subcategorias...');
            await client.query(`
                CREATE TABLE pricelist_subcategorias (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    categoria_id UUID REFERENCES pricelist_categorias(id) ON DELETE CASCADE,
                    nome VARCHAR(200) NOT NULL,
                    codigo VARCHAR(50),
                    descricao TEXT,
                    ordem INTEGER DEFAULT 0,
                    ativo BOOLEAN DEFAULT true,
                    created_at TIMESTAMPTZ DEFAULT NOW(),
                    updated_at TIMESTAMPTZ DEFAULT NOW()
                )
            `);
            await client.query(`CREATE INDEX IF NOT EXISTS idx_pricelist_subcategorias_categoria ON pricelist_subcategorias(categoria_id)`);
            console.log('   [OK] pricelist_subcategorias criada');
        } else {
            console.log('\n5. [SKIP] pricelist_subcategorias já existe');
        }

        // 6. Criar tabela pricelist_itens se não existir
        if (!existing.includes('pricelist_itens')) {
            console.log('\n6. Criando tabela pricelist_itens...');
            await client.query(`
                CREATE TABLE pricelist_itens (
                    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                    categoria_id UUID REFERENCES pricelist_categorias(id) ON DELETE SET NULL,
                    subcategoria_id UUID REFERENCES pricelist_subcategorias(id) ON DELETE SET NULL,
                    nucleo_id UUID REFERENCES nucleos(id) ON DELETE SET NULL,
                    codigo VARCHAR(50),
                    nome VARCHAR(255) NOT NULL,
                    descricao TEXT,
                    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('mao_obra', 'material', 'servico', 'produto')),
                    unidade VARCHAR(20) NOT NULL DEFAULT 'un',
                    preco DECIMAL(15,2) NOT NULL DEFAULT 0,
                    producao_diaria DECIMAL(15,3),
                    custo_aquisicao DECIMAL(15,2),
                    margem_lucro DECIMAL(5,2),
                    markup DECIMAL(5,2),
                    preco_minimo DECIMAL(15,2),
                    fabricante VARCHAR(200),
                    marca VARCHAR(200),
                    modelo VARCHAR(200),
                    link_produto TEXT,
                    imagem_url TEXT,
                    fornecedor_id UUID,
                    ativo BOOLEAN DEFAULT true,
                    created_at TIMESTAMPTZ DEFAULT NOW(),
                    updated_at TIMESTAMPTZ DEFAULT NOW()
                )
            `);
            await client.query(`CREATE INDEX IF NOT EXISTS idx_pricelist_itens_categoria ON pricelist_itens(categoria_id)`);
            await client.query(`CREATE INDEX IF NOT EXISTS idx_pricelist_itens_tipo ON pricelist_itens(tipo)`);
            console.log('   [OK] pricelist_itens criada');
        } else {
            console.log('\n6. [SKIP] pricelist_itens já existe');
        }

        // 7. Configurar RLS
        console.log('\n7. Configurando RLS...');
        const tables = ['nucleos', 'fin_categories', 'pricelist_categorias', 'pricelist_subcategorias', 'pricelist_itens'];

        for (const table of tables) {
            try {
                await client.query(`ALTER TABLE ${table} ENABLE ROW LEVEL SECURITY`);
                await client.query(`DROP POLICY IF EXISTS "${table}_select_auth" ON ${table}`);
                await client.query(`CREATE POLICY "${table}_select_auth" ON ${table} FOR SELECT TO authenticated USING (true)`);
                await client.query(`DROP POLICY IF EXISTS "${table}_all_auth" ON ${table}`);
                await client.query(`CREATE POLICY "${table}_all_auth" ON ${table} FOR ALL TO authenticated USING (true) WITH CHECK (true)`);
                console.log(`   [OK] RLS ${table}`);
            } catch (e) {
                console.log(`   [SKIP] RLS ${table}: ${e.message}`);
            }
        }

        // 8. Inserir dados iniciais
        console.log('\n8. Inserindo dados iniciais...');

        // Núcleos
        const nucleosCount = await client.query(`SELECT COUNT(*) FROM nucleos`);
        if (parseInt(nucleosCount.rows[0].count) === 0) {
            await client.query(`
                INSERT INTO nucleos (nome, codigo, cor, ordem) VALUES
                ('Arquitetura', 'ARQ', '#F25C26', 1),
                ('Engenharia', 'ENG', '#2563EB', 2),
                ('Marcenaria', 'MAR', '#16A34A', 3),
                ('Interiores', 'INT', '#9333EA', 4)
            `);
            console.log('   [OK] Núcleos inseridos');
        } else {
            console.log('   [SKIP] Núcleos já existem');
        }

        // Categorias financeiras
        const finCount = await client.query(`SELECT COUNT(*) FROM fin_categories`);
        if (parseInt(finCount.rows[0].count) === 0) {
            await client.query(`
                INSERT INTO fin_categories (name, kind, ordem) VALUES
                ('Receita de Projetos', 'income', 1),
                ('Receita de Consultoria', 'income', 2),
                ('Receita de Serviços', 'income', 3),
                ('Outras Receitas', 'income', 10),
                ('Fornecedores', 'expense', 1),
                ('Mão de Obra', 'expense', 2),
                ('Material de Escritório', 'expense', 3),
                ('Aluguel e Condomínio', 'expense', 4),
                ('Serviços Terceirizados', 'expense', 5),
                ('Impostos e Taxas', 'expense', 6),
                ('Marketing', 'expense', 7),
                ('Outras Despesas', 'expense', 10)
            `);
            console.log('   [OK] Categorias financeiras inseridas');
        } else {
            console.log('   [SKIP] Categorias financeiras já existem');
        }

        // Categorias pricelist
        const pricelistCount = await client.query(`SELECT COUNT(*) FROM pricelist_categorias`);
        if (parseInt(pricelistCount.rows[0].count) === 0) {
            await client.query(`
                INSERT INTO pricelist_categorias (nome, codigo, tipo, ordem) VALUES
                ('Serviços Preliminares', 'PREL', 'servico', 1),
                ('Demolição e Remoção', 'DEMO', 'servico', 2),
                ('Alvenaria', 'ALVE', 'mao_obra', 3),
                ('Revestimentos', 'REVE', 'material', 4),
                ('Pintura', 'PINT', 'mao_obra', 5),
                ('Elétrica', 'ELET', 'servico', 6),
                ('Hidráulica', 'HIDR', 'servico', 7),
                ('Marcenaria', 'MARC', 'produto', 8),
                ('Serralheria', 'SERR', 'servico', 9),
                ('Gesso e Forro', 'GESS', 'servico', 10),
                ('Pisos', 'PISO', 'material', 11),
                ('Louças e Metais', 'LOUC', 'material', 12),
                ('Iluminação', 'ILUM', 'material', 13),
                ('Climatização', 'CLIM', 'servico', 14),
                ('Paisagismo', 'PAIS', 'servico', 15),
                ('Limpeza Final', 'LIMP', 'servico', 99)
            `);
            console.log('   [OK] Categorias pricelist inseridas');
        } else {
            console.log('   [SKIP] Categorias pricelist já existem');
        }

        // 9. Verificação final
        console.log('\n========================================');
        console.log('VERIFICACAO FINAL');
        console.log('========================================');

        const finalCheck = await client.query(`
            SELECT table_name,
                   (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name AND table_schema = 'public') as colunas
            FROM information_schema.tables t
            WHERE table_schema = 'public'
            AND table_name IN ('nucleos', 'fin_categories', 'pricelist_categorias', 'pricelist_subcategorias', 'pricelist_itens')
            ORDER BY table_name
        `);

        for (const row of finalCheck.rows) {
            const count = await client.query(`SELECT COUNT(*) FROM ${row.table_name}`);
            console.log(`[OK] ${row.table_name}: ${count.rows[0].count} registros, ${row.colunas} colunas`);
        }

        console.log('\n========================================');
        console.log('SUCESSO! Banco atualizado.');
        console.log('========================================');

    } catch (error) {
        console.error('ERRO:', error.message);
        if (error.detail) console.error('DETALHE:', error.detail);
    } finally {
        await client.end();
    }
}

run();
