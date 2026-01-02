/**
 * Importador de Extrato BTG para WG Easy
 * Usa o cliente Supabase do projeto
 */

const { createClient } = require('@supabase/supabase-js');
const XLSX = require('xlsx');
const path = require('path');

// Configurações Supabase
const SUPABASE_URL = 'https://ahlqzzkxuutwoepirrpzr.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.xWNEmZumCtyRdrIiotUIL41jlI168HyBgM4yHVDXPZo';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// Mapeamentos
const NUCLEOS = {
    'ENG': 'engenharia',
    'ARQ': 'arquitetura',
    'MAR': 'marcenaria',
    'ADM': 'administrativo'
};

const CATEGORIAS_MAP = {
    'DESP-PESSOAL': 'Despesa Pessoal',
    'DESP-SEM-INFO': 'Despesa Sem Classificação',
    'DESP-MO-COLAB': 'Mão de Obra - Colaborador',
    'DESP-MO-TERC': 'Mão de Obra - Terceiros',
    'DESP-MATERIAL': 'Material',
    'DESP-OPER': 'Despesa Operacional',
    'REC-CLIENTE': 'Receita Cliente'
};

function parseDate(dateStr) {
    if (!dateStr) return new Date().toISOString().split('T')[0];

    if (typeof dateStr === 'string' && dateStr.includes('/')) {
        const parts = dateStr.split('/');
        if (parts.length === 3) {
            return `${parts[2]}-${parts[1].padStart(2, '0')}-${parts[0].padStart(2, '0')}`;
        }
    }

    // Excel date serial number
    if (typeof dateStr === 'number') {
        const date = new Date((dateStr - 25569) * 86400 * 1000);
        return date.toISOString().split('T')[0];
    }

    return new Date().toISOString().split('T')[0];
}

function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        const r = Math.random() * 16 | 0;
        const v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

async function main() {
    console.log('='.repeat(60));
    console.log('  IMPORTADOR EXTRATO BTG -> WG EASY');
    console.log('='.repeat(60));
    console.log();

    // Ler arquivo Excel
    const arquivo = path.join('C:', 'Users', 'Atendimento', 'Documents', 'EXTRATO_BTG_IMPORTACAO_WGEASYreformas.xlsx');
    console.log(`Lendo arquivo: ${arquivo}`);

    let workbook;
    try {
        workbook = XLSX.readFile(arquivo);
    } catch (e) {
        console.log(`[ERRO] Falha ao ler arquivo: ${e.message}`);
        return;
    }

    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(sheet);
    console.log(`[OK] ${data.length} registros encontrados`);

    // Buscar centros de custo
    console.log('\nBuscando centros de custo...');
    const { data: centros, error: centrosError } = await supabase
        .from('financeiro_centros_custo')
        .select('id, codigo, nome');

    const centrosMap = {};
    if (centros) {
        centros.forEach(c => {
            if (c.codigo) centrosMap[c.codigo] = c.id;
        });
    }
    console.log(`[OK] ${Object.keys(centrosMap).length} centros de custo encontrados`);

    // Buscar conta bancária BTG
    console.log('Buscando conta bancária...');
    const { data: contas } = await supabase
        .from('financeiro_contas_bancarias')
        .select('id, nome, banco');

    let contaBancariaId = null;
    if (contas && contas.length > 0) {
        const contaBtg = contas.find(c =>
            (c.banco && c.banco.toUpperCase().includes('BTG')) ||
            (c.nome && c.nome.toUpperCase().includes('BTG'))
        );
        contaBancariaId = contaBtg ? contaBtg.id : contas[0].id;
    }
    console.log(`[OK] Conta: ${contaBancariaId ? contaBancariaId.substring(0, 8) + '...' : 'N/A'}`);

    // Inserir lançamentos
    console.log('\n' + '-'.repeat(60));
    console.log('Inserindo lançamentos...');
    console.log('-'.repeat(60));

    let sucesso = 0;
    let erros = 0;

    for (let i = 0; i < data.length; i++) {
        const row = data[i];

        try {
            const tipo = String(row.TIPO || '').toUpperCase();
            const isEntrada = tipo === 'RECEITA';

            const empresa = String(row.EMPRESA || 'ADM').toUpperCase();
            const nucleo = NUCLEOS[empresa] || 'administrativo';

            const centroCustoCodigo = String(row.CENTRO_CUSTO || '');
            const centroCustoId = centrosMap[centroCustoCodigo] || null;

            const categoriaCodigo = String(row.CATEGORIA || '');
            const categoria = CATEGORIAS_MAP[categoriaCodigo] || categoriaCodigo;

            const valor = parseFloat(row.VALOR) || 0;
            const dataStr = parseDate(row.DATA);

            const favorecido = String(row.FAVORECIDO_NOME || '');
            const mensagemPix = row.MENSAGEM_PIX ? String(row.MENSAGEM_PIX) : '';
            const descricaoOrig = String(row.DESCRICAO || '');

            let descricao = favorecido;
            if (mensagemPix && mensagemPix !== 'NaN' && mensagemPix !== 'undefined') {
                descricao += ` - ${mensagemPix}`;
            }

            let observacoes = descricaoOrig;
            if (row.CLASSIFICACAO_AUTO) {
                observacoes += ` | Classificação: ${row.CLASSIFICACAO_AUTO}`;
            }

            const lancamento = {
                id: generateUUID(),
                tipo: isEntrada ? 'receita' : 'despesa',
                is_entrada: isEntrada,
                natureza: String(row.NATUREZA || 'PIX'),
                valor: valor,
                valor_total: valor,
                data_emissao: dataStr,
                data_competencia: dataStr,
                descricao: descricao.substring(0, 500) || 'Importado BTG',
                categoria: categoria,
                nucleo: nucleo,
                status: 'pendente',
                observacoes: observacoes.substring(0, 1000) || null,
                numero_parcelas: 1
            };

            if (contaBancariaId) {
                lancamento.conta_bancaria_id = contaBancariaId;
            }
            if (centroCustoId) {
                lancamento.centro_custo_id = centroCustoId;
            }

            const { error } = await supabase
                .from('financeiro_lancamentos')
                .insert(lancamento);

            if (error) {
                erros++;
                console.log(`[${i+1}/${data.length}] ${descricao.substring(0, 35)}... [ERRO: ${error.message}]`);
            } else {
                sucesso++;
                console.log(`[${i+1}/${data.length}] ${descricao.substring(0, 35)}... R$ ${valor.toFixed(2)} [OK]`);
            }
        } catch (e) {
            erros++;
            console.log(`[${i+1}/${data.length}] ERRO: ${e.message}`);
        }
    }

    console.log();
    console.log('='.repeat(60));
    console.log(`  IMPORTAÇÃO CONCLUÍDA!`);
    console.log(`  ${sucesso} inseridos com sucesso`);
    console.log(`  ${erros} erros`);
    console.log('='.repeat(60));
}

main().catch(console.error);
