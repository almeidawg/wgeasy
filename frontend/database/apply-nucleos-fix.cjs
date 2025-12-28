const https = require('https');

const SUPABASE_URL = 'ahlqzzkxuutwoepirpzr.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0Nzc1MzQxNCwiZXhwIjoyMDYzMzI5NDE0fQ.KF57TgDQ7VpNu6Y6ki56SY9sLHHJCgkFHZoOoOuEn2Q';

// Testar a função RPC diretamente
console.log('Testando função buscar_dados_area_cliente...\n');

const testData = JSON.stringify({ p_cliente_id: '5f1b03a0-ccbe-43cc-b430-c2675fa0f733' });

const options = {
    hostname: SUPABASE_URL,
    port: 443,
    path: '/rest/v1/rpc/buscar_dados_area_cliente',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'Content-Length': Buffer.byteLength(testData)
    }
};

const req = https.request(options, (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
        console.log('Status:', res.statusCode);

        if (res.statusCode === 200) {
            try {
                const result = JSON.parse(data);
                console.log('\n=== RESULTADO ===');
                console.log('Cliente:', result?.cliente?.nome || 'N/A');
                console.log('Contratos:', result?.contratos?.length || 0);
                console.log('Oportunidades:', result?.oportunidades?.length || 0);
                console.log('Núcleos Atividades:', result?.nucleos_atividades?.length || 0);

                if (result?.nucleos_atividades?.length > 0) {
                    console.log('\n=== DETALHES NÚCLEOS ===');
                    result.nucleos_atividades.forEach((n, i) => {
                        console.log(`\n[${i+1}] ${n.nucleo} - ${n.contrato_numero}`);
                        console.log(`    Tipo: ${n.tipo_vinculo}`);
                        console.log(`    Checklist: ${n.checklist_concluidos}/${n.total_checklist} concluídos`);
                        if (n.checklist_itens && n.checklist_itens.length > 0) {
                            console.log(`    Itens:`);
                            n.checklist_itens.slice(0, 3).forEach(item => {
                                const status = item.concluido ? '✓' : '○';
                                console.log(`      ${status} ${item.texto}`);
                            });
                            if (n.checklist_itens.length > 3) {
                                console.log(`      ... e mais ${n.checklist_itens.length - 3} itens`);
                            }
                        }
                    });
                }

                console.log('\n=== FINANCEIRO ===');
                console.log('Total Contratado:', result?.financeiro?.resumo?.total_contratado || 0);
                console.log('Total Pago:', result?.financeiro?.resumo?.total_pago || 0);
                console.log('Total Pendente:', result?.financeiro?.resumo?.total_pendente || 0);

                console.log('\n✅ Função funcionando corretamente!');
            } catch (e) {
                console.log('Resposta:', data.substring(0, 500));
            }
        } else {
            console.log('Erro:', data);

            if (res.statusCode === 404) {
                console.log('\n❌ Função não encontrada. Aplique o SQL no Supabase Dashboard.');
            } else if (data.includes('profissoes')) {
                console.log('\n❌ Erro: tabela profissoes não existe. Aplicar versão corrigida.');
            }
        }
    });
});

req.on('error', (e) => {
    console.error('Erro de conexão:', e.message);
});

req.write(testData);
req.end();
