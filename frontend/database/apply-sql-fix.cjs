const https = require('https');

const SUPABASE_URL = 'ahlqzzkxuutwoepirpzr.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDU3MTI0MywiZXhwIjoyMDc2MTQ3MjQzfQ.lDPzHBxOaKFSJqWUxGdvLb_qJOWvD1kVu5BnRPTEXhU';

const sql = `
CREATE OR REPLACE FUNCTION buscar_dados_area_cliente(p_cliente_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_cliente JSON;
    v_contratos JSON;
    v_oportunidades JSON;
    v_nucleos_atividades JSON;
    v_financeiro JSON;
    v_equipe JSON;
    v_resultado JSON;
BEGIN
    SELECT json_build_object(
        'id', p.id,
        'nome', p.nome,
        'email', p.email,
        'telefone', p.telefone,
        'avatar_url', p.avatar_url,
        'drive_link', p.drive_link
    ) INTO v_cliente
    FROM pessoas p
    WHERE p.id = p_cliente_id;

    IF v_cliente IS NULL THEN
        RETURN NULL;
    END IF;

    SELECT COALESCE(json_agg(row_to_json(c)), '[]'::json)
    INTO v_contratos
    FROM (
        SELECT
            co.id,
            co.numero,
            co.titulo,
            co.status,
            co.valor_total,
            co.created_at,
            n.id as nucleo_id,
            n.nome as nucleo_nome,
            'contrato' as tipo_vinculo
        FROM contratos co
        LEFT JOIN nucleos n ON n.id = co.nucleo_id
        WHERE co.cliente_id = p_cliente_id
        ORDER BY co.created_at DESC
    ) c;

    SELECT COALESCE(json_agg(row_to_json(o)), '[]'::json)
    INTO v_oportunidades
    FROM (
        SELECT
            op.id,
            op.titulo,
            op.status,
            op.valor_estimado as valor_total,
            op.updated_at as created_at,
            NULL::uuid as nucleo_id,
            NULL::text as nucleo_nome,
            'oportunidade' as tipo_vinculo
        FROM oportunidades op
        WHERE op.cliente_id = p_cliente_id
        ORDER BY op.updated_at DESC
    ) o;

    SELECT COALESCE(json_agg(nucleo_data), '[]'::json)
    INTO v_nucleos_atividades
    FROM (
        SELECT
            COALESCE(n.nome, 'Geral') as nucleo,
            co.id as contrato_id,
            co.numero as contrato_numero,
            'contrato' as tipo_vinculo,
            '[]'::json as comentarios,
            '[]'::json as tarefas,
            0 as total_tarefas,
            0 as tarefas_concluidas,
            (
                SELECT COALESCE(json_agg(row_to_json(ci)), '[]'::json)
                FROM (
                    SELECT
                        chi.id,
                        chi.texto,
                        chi.secao,
                        chi.concluido,
                        ch.titulo as checklist_titulo
                    FROM checklist_itens chi
                    JOIN checklists ch ON ch.id = chi.checklist_id
                    WHERE ch.vinculo_id = co.id
                    AND ch.vinculo_tipo = 'contrato'
                    ORDER BY chi.ordem
                ) ci
            ) as checklist_itens,
            (
                SELECT COUNT(*)::int
                FROM checklist_itens chi
                JOIN checklists ch ON ch.id = chi.checklist_id
                WHERE ch.vinculo_id = co.id
                AND ch.vinculo_tipo = 'contrato'
            ) as total_checklist,
            (
                SELECT COUNT(*)::int
                FROM checklist_itens chi
                JOIN checklists ch ON ch.id = chi.checklist_id
                WHERE ch.vinculo_id = co.id
                AND ch.vinculo_tipo = 'contrato'
                AND chi.concluido = true
            ) as checklist_concluidos
        FROM contratos co
        LEFT JOIN nucleos n ON n.id = co.nucleo_id
        WHERE co.cliente_id = p_cliente_id
        AND co.status IN ('ativo', 'em_andamento', 'aguardando_assinatura', 'concluido')

        UNION ALL

        SELECT
            'Oportunidade' as nucleo,
            op.id as contrato_id,
            op.titulo as contrato_numero,
            'oportunidade' as tipo_vinculo,
            '[]'::json as comentarios,
            '[]'::json as tarefas,
            0 as total_tarefas,
            0 as tarefas_concluidas,
            (
                SELECT COALESCE(json_agg(row_to_json(ci)), '[]'::json)
                FROM (
                    SELECT
                        chi.id,
                        chi.texto,
                        chi.secao,
                        chi.concluido,
                        ch.titulo as checklist_titulo
                    FROM checklist_itens chi
                    JOIN checklists ch ON ch.id = chi.checklist_id
                    WHERE ch.vinculo_id = op.id
                    AND ch.vinculo_tipo = 'oportunidade'
                    ORDER BY chi.ordem
                ) ci
            ) as checklist_itens,
            (
                SELECT COUNT(*)::int
                FROM checklist_itens chi
                JOIN checklists ch ON ch.id = chi.checklist_id
                WHERE ch.vinculo_id = op.id
                AND ch.vinculo_tipo = 'oportunidade'
            ) as total_checklist,
            (
                SELECT COUNT(*)::int
                FROM checklist_itens chi
                JOIN checklists ch ON ch.id = chi.checklist_id
                WHERE ch.vinculo_id = op.id
                AND ch.vinculo_tipo = 'oportunidade'
                AND chi.concluido = true
            ) as checklist_concluidos
        FROM oportunidades op
        WHERE op.cliente_id = p_cliente_id
        AND op.status NOT IN ('perdida', 'cancelada')
    ) nucleo_data;

    SELECT json_build_object(
        'lancamentos', (
            SELECT COALESCE(json_agg(row_to_json(l)), '[]'::json)
            FROM (
                SELECT
                    fl.id,
                    fl.descricao,
                    COALESCE(NULLIF(fl.valor_total, 0), NULLIF(fl.valor_liquido, 0), NULLIF(fl.valor, 0), 0) as valor,
                    fl.tipo,
                    UPPER(fl.status) as status,
                    fl.vencimento as data_vencimento,
                    fl.data_pagamento,
                    fl.parcela_numero,
                    fl.total_parcelas as parcela_total,
                    c.numero as contrato_numero
                FROM financeiro_lancamentos fl
                INNER JOIN contratos c ON c.id = fl.contrato_id
                WHERE c.cliente_id = p_cliente_id
                AND LOWER(fl.tipo) = 'entrada'
                ORDER BY fl.vencimento ASC
                LIMIT 50
            ) l
        ),
        'resumo', (
            SELECT json_build_object(
                'total_contratado', COALESCE((
                    SELECT SUM(co.valor_total)
                    FROM contratos co
                    WHERE co.cliente_id = p_cliente_id
                ), 0),
                'total_pago', COALESCE((
                    SELECT SUM(COALESCE(NULLIF(fl.valor_total, 0), NULLIF(fl.valor_liquido, 0), NULLIF(fl.valor, 0), 0))
                    FROM financeiro_lancamentos fl
                    INNER JOIN contratos c ON c.id = fl.contrato_id
                    WHERE c.cliente_id = p_cliente_id
                    AND LOWER(fl.tipo) = 'entrada'
                    AND UPPER(fl.status) = 'PAGO'
                ), 0),
                'total_pendente', COALESCE((
                    SELECT SUM(COALESCE(NULLIF(fl.valor_total, 0), NULLIF(fl.valor_liquido, 0), NULLIF(fl.valor, 0), 0))
                    FROM financeiro_lancamentos fl
                    INNER JOIN contratos c ON c.id = fl.contrato_id
                    WHERE c.cliente_id = p_cliente_id
                    AND LOWER(fl.tipo) = 'entrada'
                    AND UPPER(fl.status) IN ('PENDENTE', 'A_PAGAR', 'AGUARDANDO')
                ), 0)
            )
        )
    ) INTO v_financeiro;

    SELECT COALESCE(json_agg(row_to_json(e)), '[]'::json)
    INTO v_equipe
    FROM (
        SELECT DISTINCT
            p.id,
            p.nome,
            p.email,
            p.telefone,
            p.avatar_url,
            COALESCE(pr.nome, 'Equipe WG') as cargo
        FROM pessoas p
        LEFT JOIN profissoes pr ON pr.id = p.profissao_id
        WHERE p.id IN (
            SELECT DISTINCT responsavel_id
            FROM contratos
            WHERE cliente_id = p_cliente_id
            AND responsavel_id IS NOT NULL
        )
        LIMIT 10
    ) e;

    v_resultado := json_build_object(
        'cliente', v_cliente,
        'contratos', v_contratos,
        'oportunidades', v_oportunidades,
        'nucleos_atividades', v_nucleos_atividades,
        'financeiro', v_financeiro,
        'equipe', v_equipe
    );

    RETURN v_resultado;
END;
$$;

GRANT EXECUTE ON FUNCTION buscar_dados_area_cliente(UUID) TO anon;
GRANT EXECUTE ON FUNCTION buscar_dados_area_cliente(UUID) TO authenticated;
`;

const postData = JSON.stringify({ query: sql });

const options = {
    hostname: SUPABASE_URL,
    port: 443,
    path: '/rest/v1/rpc/exec_sql',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
        'Prefer': 'return=representation'
    }
};

console.log('Aplicando SQL no Supabase...');

const req = https.request(options, (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
        console.log('Status:', res.statusCode);
        if (res.statusCode === 200 || res.statusCode === 204) {
            console.log('SUCESSO! Funcao criada/atualizada.');
        } else {
            console.log('Resposta:', data);
            // Tentar via SQL direto
            tryDirectSQL();
        }
    });
});

req.on('error', (e) => {
    console.error('Erro:', e.message);
    tryDirectSQL();
});

req.write(postData);
req.end();

function tryDirectSQL() {
    console.log('\nTentando via Supabase SQL Editor API...');

    const sqlEditorOptions = {
        hostname: SUPABASE_URL,
        port: 443,
        path: '/rest/v1/',
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
            'X-Client-Info': 'supabase-js/2.0.0'
        }
    };

    // Como nao ha endpoint direto para SQL, vamos testar a funcao
    console.log('\nTestando se a funcao existe chamando-a...');

    const testOptions = {
        hostname: SUPABASE_URL,
        port: 443,
        path: '/rest/v1/rpc/buscar_dados_area_cliente',
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_KEY,
            'Authorization': `Bearer ${SUPABASE_KEY}`,
        }
    };

    const testReq = https.request(testOptions, (res) => {
        let data = '';
        res.on('data', (chunk) => { data += chunk; });
        res.on('end', () => {
            console.log('Status do teste:', res.statusCode);
            if (res.statusCode === 400) {
                console.log('Funcao ainda com erro. Copie o SQL e aplique manualmente no Supabase Dashboard.');
                console.log('\nURL do Supabase Dashboard: https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/sql');
            } else {
                console.log('Resposta:', data.substring(0, 200));
            }
        });
    });

    testReq.write(JSON.stringify({ p_cliente_id: '5f1b03a0-ccbe-43cc-b430-c2675fa0f733' }));
    testReq.end();
}
