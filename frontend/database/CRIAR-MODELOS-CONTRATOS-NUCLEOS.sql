-- =============================================================================
-- MODELOS DE CONTRATOS POR NÚCLEO - WG ALMEIDA
-- =============================================================================
-- Este script insere os modelos de contrato padrão para cada núcleo de negócio
-- Baseado nos contratos reais da empresa analisados em 26/12/2024
-- =============================================================================

-- Limpar modelos existentes (opcional - comentar se quiser manter)
-- DELETE FROM juridico_modelos_contrato WHERE codigo IN ('MOD-ARQ-PROJETO-001', 'MOD-ENG-OBRA-001', 'MOD-MAR-MOVEIS-001');

-- =============================================================================
-- 1. MODELO DE CONTRATO - ARQUITETURA (Projeto Arquitetônico)
-- =============================================================================
-- Empresa: WG ALMEIDA ARQUITETURA E COMERCIO LTDA
-- CNPJ: 45.150.970/0001-01
-- =============================================================================

INSERT INTO juridico_modelos_contrato (
    codigo,
    nome,
    descricao,
    nucleo,
    status,
    versao,
    conteudo_html,
    clausulas,
    variaveis_obrigatorias
) VALUES (
    'MOD-ARQ-PROJETO-001',
    'Contrato de Projeto Arquitetônico',
    'Modelo padrão de contrato para prestação de serviços de projeto arquitetônico, incluindo todas as etapas desde o Estudo Preliminar até o Projeto Executivo.',
    'arquitetura',
    'publicado',
    1,
    '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; font-size: 12pt; line-height: 1.5; margin: 40px; }
        h1 { text-align: center; font-size: 16pt; margin-bottom: 30px; }
        h2 { font-size: 14pt; margin-top: 20px; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        .partes { margin: 20px 0; }
        .clausula { margin: 15px 0; text-align: justify; }
        .etapa { margin: 10px 0 10px 20px; }
        .assinaturas { margin-top: 50px; }
        .assinatura-box { display: inline-block; width: 45%; text-align: center; margin-top: 60px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        td, th { border: 1px solid #ccc; padding: 8px; text-align: left; }
    </style>
</head>
<body>
    <h1>CONTRATO DE PRESTAÇÃO DE SERVIÇOS DE PROJETO ARQUITETÔNICO</h1>

    <div class="partes">
        <p><strong>CONTRATANTE:</strong> {{pessoa.nome}}, {{pessoa.nacionalidade}}, {{pessoa.estado_civil}}, {{pessoa.profissao}},
        portador(a) do RG nº {{pessoa.rg}} e inscrito(a) no CPF sob o nº {{pessoa.cpf}},
        residente e domiciliado(a) à {{pessoa.endereco}}, {{pessoa.cidade}}/{{pessoa.estado}},
        CEP {{pessoa.cep}}, telefone {{pessoa.telefone}}, e-mail {{pessoa.email}}.</p>

        <p><strong>CONTRATADA:</strong> WG ALMEIDA ARQUITETURA E COMERCIO LTDA, pessoa jurídica de direito privado,
        inscrita no CNPJ sob o nº 45.150.970/0001-01, com sede à Rua Cel. Alfredo Fláquer, 1141, sala 31,
        Centro, Santo André/SP, CEP 09020-030, neste ato representada por seu sócio administrador
        WELLINGTON GRACIELE DE ALMEIDA, brasileiro, casado, arquiteto e urbanista, inscrito no CAU sob nº A146972-8,
        portador do RG nº 35.500.612-7 SSP/SP e CPF nº 324.548.628-80.</p>
    </div>

    <p class="clausula">As partes acima qualificadas têm entre si justo e contratado o presente instrumento particular
    de prestação de serviços de projeto arquitetônico, que será regido pelas seguintes cláusulas e condições:</p>

    <h2>CLÁUSULA PRIMEIRA - DO OBJETO</h2>
    <p class="clausula">O presente contrato tem por objeto a prestação de serviços de elaboração de PROJETO ARQUITETÔNICO
    de {{projeto.tipo_projeto}} para o imóvel situado à {{imovel.endereco}}, {{imovel.cidade}}/{{imovel.estado}},
    com área total de aproximadamente {{imovel.area_total}} m².</p>

    <h2>CLÁUSULA SEGUNDA - DAS ETAPAS E PRAZOS</h2>
    <p class="clausula">Os serviços objeto deste contrato serão desenvolvidos nas seguintes etapas:</p>

    <div class="etapa"><strong>ETAPA 1 - REUNIÃO INICIAL E BRIEFING:</strong> Reunião para levantamento de necessidades,
    definição do programa de necessidades e expectativas do cliente. Prazo: {{etapa1.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 2 - LEVANTAMENTO TÉCNICO:</strong> Visita técnica ao local, levantamento arquitetônico
    e fotográfico, análise de documentação existente. Prazo: {{etapa2.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 3 - ESTUDO PRELIMINAR:</strong> Apresentação de 2 (duas) propostas de layout com
    plantas humanizadas, incluindo distribuição dos ambientes e fluxos. Prazo: {{etapa3.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 4 - ANTEPROJETO:</strong> Desenvolvimento da proposta aprovada com plantas baixas,
    cortes, fachadas e perspectivas 3D. Prazo: {{etapa4.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 5 - PROJETO LEGAL:</strong> Elaboração de projeto para aprovação junto aos órgãos
    competentes (Prefeitura, Corpo de Bombeiros, etc.). Prazo: {{etapa5.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 6 - PROJETO EXECUTIVO:</strong> Detalhamento técnico completo para execução da obra,
    incluindo plantas de layout, paginação de pisos, pontos elétricos e hidráulicos. Prazo: {{etapa6.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 7 - MEMORIAL DESCRITIVO:</strong> Documento com especificações técnicas de materiais
    e acabamentos. Prazo: {{etapa7.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 8 - COMPATIBILIZAÇÃO:</strong> Compatibilização com projetos complementares
    (estrutural, elétrico, hidráulico). Prazo: {{etapa8.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 9 - DETALHAMENTOS:</strong> Detalhamento de marcenaria, gesso, iluminação e
    elementos especiais. Prazo: {{etapa9.prazo}} dias úteis.</div>

    <div class="etapa"><strong>ETAPA 10 - ACOMPANHAMENTO:</strong> {{acompanhamento.visitas}} visitas técnicas à obra
    para verificação da execução conforme projeto. Prazo: durante a execução da obra.</div>

    <h2>CLÁUSULA TERCEIRA - DO PREÇO E FORMA DE PAGAMENTO</h2>
    <p class="clausula">O valor total dos serviços objeto deste contrato é de R$ {{contrato.valor_total}}
    ({{contrato.valor_extenso}}), que será pago da seguinte forma:</p>

    <table>
        <tr><th>Parcela</th><th>Percentual</th><th>Valor</th><th>Vencimento</th></tr>
        <tr><td>1ª Parcela (Assinatura)</td><td>30%</td><td>R$ {{parcela1.valor}}</td><td>Na assinatura</td></tr>
        <tr><td>2ª Parcela (Estudo Preliminar)</td><td>20%</td><td>R$ {{parcela2.valor}}</td><td>Aprovação EP</td></tr>
        <tr><td>3ª Parcela (Anteprojeto)</td><td>20%</td><td>R$ {{parcela3.valor}}</td><td>Aprovação AP</td></tr>
        <tr><td>4ª Parcela (Projeto Executivo)</td><td>30%</td><td>R$ {{parcela4.valor}}</td><td>Entrega PE</td></tr>
    </table>

    <h2>CLÁUSULA QUARTA - DAS OBRIGAÇÕES DA CONTRATADA</h2>
    <p class="clausula">São obrigações da CONTRATADA:</p>
    <p class="clausula">a) Executar os serviços com zelo e dedicação, observando as normas técnicas aplicáveis;</p>
    <p class="clausula">b) Manter sigilo sobre informações confidenciais do CONTRATANTE;</p>
    <p class="clausula">c) Cumprir os prazos estabelecidos neste contrato;</p>
    <p class="clausula">d) Fornecer ART/RRT dos projetos elaborados;</p>
    <p class="clausula">e) Realizar as alterações solicitadas dentro do escopo contratado;</p>
    <p class="clausula">f) Comparecer às reuniões previamente agendadas.</p>

    <h2>CLÁUSULA QUINTA - DAS OBRIGAÇÕES DO CONTRATANTE</h2>
    <p class="clausula">São obrigações do CONTRATANTE:</p>
    <p class="clausula">a) Fornecer todas as informações e documentos necessários à execução dos serviços;</p>
    <p class="clausula">b) Efetuar os pagamentos nas datas acordadas;</p>
    <p class="clausula">c) Aprovar ou solicitar alterações nas etapas apresentadas em até 5 (cinco) dias úteis;</p>
    <p class="clausula">d) Disponibilizar acesso ao imóvel para levantamentos e visitas técnicas;</p>
    <p class="clausula">e) Não utilizar os projetos para fins diversos do contratado sem autorização.</p>

    <h2>CLÁUSULA SEXTA - DA VIGÊNCIA E RESCISÃO</h2>
    <p class="clausula">O presente contrato vigorará pelo prazo necessário à conclusão de todas as etapas,
    estimado em {{contrato.prazo_estimado}} dias, contados da assinatura.</p>
    <p class="clausula">Em caso de rescisão por iniciativa do CONTRATANTE, serão devidos os valores
    proporcionais às etapas já executadas, acrescidos de multa de 20% sobre o saldo restante.</p>
    <p class="clausula">Em caso de rescisão por iniciativa da CONTRATADA sem justa causa, esta devolverá
    os valores recebidos proporcionalmente às etapas não executadas.</p>

    <h2>CLÁUSULA SÉTIMA - DAS CONDIÇÕES GERAIS</h2>
    <p class="clausula">Os direitos autorais sobre os projetos são de propriedade da CONTRATADA,
    sendo cedidos ao CONTRATANTE apenas para uso no imóvel objeto deste contrato.</p>
    <p class="clausula">Alterações de escopo solicitadas após aprovação de cada etapa serão objeto de
    orçamento complementar.</p>
    <p class="clausula">Fica eleito o Foro da Comarca de Santo André/SP para dirimir quaisquer questões
    oriundas deste contrato.</p>

    <div class="assinaturas">
        <p>E por estarem assim justos e contratados, firmam o presente instrumento em 2 (duas) vias de igual
        teor e forma, na presença de 2 (duas) testemunhas.</p>

        <p style="text-align: center; margin-top: 30px;">{{contrato.cidade}}, {{contrato.data_extenso}}</p>

        <div style="text-align: center; margin-top: 60px;">
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p><strong>CONTRATANTE</strong></p>
                <p>{{pessoa.nome}}</p>
                <p>CPF: {{pessoa.cpf}}</p>
            </div>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p><strong>CONTRATADA</strong></p>
                <p>WG ALMEIDA ARQUITETURA E COMERCIO LTDA</p>
                <p>CNPJ: 45.150.970/0001-01</p>
            </div>
        </div>

        <div style="margin-top: 60px;">
            <p><strong>TESTEMUNHAS:</strong></p>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p>Nome: _______________________________</p>
                <p>CPF: ________________________________</p>
            </div>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p>Nome: _______________________________</p>
                <p>CPF: ________________________________</p>
            </div>
        </div>
    </div>
</body>
</html>',
    '[
        {
            "ordem": 1,
            "tipo": "objeto",
            "titulo": "DO OBJETO",
            "conteudo": "Prestação de serviços de elaboração de projeto arquitetônico conforme especificações do imóvel e tipo de projeto definidos."
        },
        {
            "ordem": 2,
            "tipo": "prazo",
            "titulo": "DAS ETAPAS E PRAZOS",
            "conteudo": "10 etapas: Briefing, Levantamento, Estudo Preliminar, Anteprojeto, Projeto Legal, Projeto Executivo, Memorial, Compatibilização, Detalhamentos e Acompanhamento."
        },
        {
            "ordem": 3,
            "tipo": "preco",
            "titulo": "DO PREÇO E FORMA DE PAGAMENTO",
            "conteudo": "Pagamento em 4 parcelas: 30% na assinatura, 20% no Estudo Preliminar, 20% no Anteprojeto, 30% no Projeto Executivo."
        },
        {
            "ordem": 4,
            "tipo": "obrigacoes_contratada",
            "titulo": "DAS OBRIGAÇÕES DA CONTRATADA",
            "conteudo": "Executar serviços com zelo, manter sigilo, cumprir prazos, fornecer ART/RRT, realizar alterações no escopo, comparecer às reuniões."
        },
        {
            "ordem": 5,
            "tipo": "obrigacoes_contratante",
            "titulo": "DAS OBRIGAÇÕES DO CONTRATANTE",
            "conteudo": "Fornecer informações e documentos, efetuar pagamentos, aprovar etapas em 5 dias úteis, disponibilizar acesso ao imóvel."
        },
        {
            "ordem": 6,
            "tipo": "rescisao",
            "titulo": "DA VIGÊNCIA E RESCISÃO",
            "conteudo": "Multa de 20% sobre saldo restante em caso de rescisão pelo contratante. Devolução proporcional em caso de rescisão pela contratada."
        },
        {
            "ordem": 7,
            "tipo": "disposicoes_gerais",
            "titulo": "DAS CONDIÇÕES GERAIS",
            "conteudo": "Direitos autorais da contratada, alterações de escopo com orçamento complementar, Foro de Santo André/SP."
        }
    ]'::jsonb,
    '["pessoa.nome", "pessoa.cpf", "pessoa.rg", "pessoa.endereco", "pessoa.cidade", "pessoa.estado", "pessoa.telefone", "pessoa.email", "imovel.endereco", "imovel.cidade", "imovel.estado", "imovel.area_total", "projeto.tipo_projeto", "contrato.valor_total", "contrato.valor_extenso", "contrato.prazo_estimado", "contrato.cidade", "contrato.data_extenso"]'::jsonb
)
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    conteudo_html = EXCLUDED.conteudo_html,
    clausulas = EXCLUDED.clausulas,
    variaveis_obrigatorias = EXCLUDED.variaveis_obrigatorias,
    updated_at = NOW();

-- =============================================================================
-- 2. MODELO DE CONTRATO - ENGENHARIA (Fornecimento de Mão de Obra)
-- =============================================================================
-- Empresa: WG ALMEIDA REFORMAS ESPECIALIZADAS LTDA
-- CNPJ: 43.716.324/0001-33
-- =============================================================================

INSERT INTO juridico_modelos_contrato (
    codigo,
    nome,
    descricao,
    nucleo,
    status,
    versao,
    conteudo_html,
    clausulas,
    variaveis_obrigatorias
) VALUES (
    'MOD-ENG-OBRA-001',
    'Contrato de Fornecimento de Mão de Obra para Obras',
    'Modelo padrão de contrato para prestação de serviços de mão de obra em obras de construção, reforma e ampliação, incluindo garantia de 12 meses.',
    'engenharia',
    'publicado',
    1,
    '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; font-size: 12pt; line-height: 1.5; margin: 40px; }
        h1 { text-align: center; font-size: 16pt; margin-bottom: 30px; }
        h2 { font-size: 14pt; margin-top: 20px; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        .partes { margin: 20px 0; }
        .clausula { margin: 15px 0; text-align: justify; }
        .item { margin: 10px 0 10px 20px; }
        .assinaturas { margin-top: 50px; }
        .assinatura-box { display: inline-block; width: 45%; text-align: center; margin-top: 60px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        td, th { border: 1px solid #ccc; padding: 8px; text-align: left; }
    </style>
</head>
<body>
    <h1>CONTRATO PARA FORNECIMENTO DE MÃO DE OBRA</h1>

    <div class="partes">
        <p><strong>CONTRATANTE:</strong> {{pessoa.nome}}, {{pessoa.nacionalidade}}, {{pessoa.estado_civil}}, {{pessoa.profissao}},
        portador(a) do RG nº {{pessoa.rg}} e inscrito(a) no CPF sob o nº {{pessoa.cpf}},
        residente e domiciliado(a) à {{pessoa.endereco}}, {{pessoa.cidade}}/{{pessoa.estado}},
        CEP {{pessoa.cep}}, telefone {{pessoa.telefone}}, e-mail {{pessoa.email}}.</p>

        <p><strong>CONTRATADA:</strong> WG ALMEIDA REFORMAS ESPECIALIZADAS LTDA, pessoa jurídica de direito privado,
        inscrita no CNPJ sob o nº 43.716.324/0001-33, com sede à Rua Cel. Alfredo Fláquer, 1141, sala 31,
        Centro, Santo André/SP, CEP 09020-030, neste ato representada por seu sócio administrador
        WELLINGTON GRACIELE DE ALMEIDA, brasileiro, casado, portador do RG nº 35.500.612-7 SSP/SP
        e CPF nº 324.548.628-80.</p>
    </div>

    <h2>CLÁUSULA PRIMEIRA - DO OBJETO</h2>
    <p class="clausula">O presente contrato tem por objeto a prestação de serviços de MÃO DE OBRA para execução
    de {{obra.tipo_obra}} no imóvel situado à {{imovel.endereco}}, {{imovel.cidade}}/{{imovel.estado}},
    conforme Memorial Executivo anexo, que passa a fazer parte integrante deste instrumento.</p>
    <p class="clausula"><strong>Parágrafo Único:</strong> O escopo detalhado dos serviços, incluindo acabamentos,
    materiais de referência e especificações técnicas, consta no Memorial Executivo (Anexo I).</p>

    <h2>CLÁUSULA SEGUNDA - DO PRAZO DE EXECUÇÃO</h2>
    <p class="clausula">Os serviços serão executados no prazo de {{obra.prazo_execucao}} dias corridos,
    contados a partir da data de início efetivo dos trabalhos, que ocorrerá em até 5 (cinco) dias úteis
    após a assinatura deste contrato e liberação do local.</p>
    <p class="clausula"><strong>§1º</strong> O prazo poderá ser prorrogado por até 15 (quinze) dias em caso de:</p>
    <p class="item">a) Condições climáticas adversas que impeçam a execução dos serviços;</p>
    <p class="item">b) Atraso na entrega de materiais pelo CONTRATANTE;</p>
    <p class="item">c) Alterações de escopo solicitadas pelo CONTRATANTE;</p>
    <p class="item">d) Força maior ou caso fortuito devidamente comprovados.</p>
    <p class="clausula"><strong>§2º</strong> Alterações que impactem significativamente o cronograma serão
    objeto de aditivo contratual.</p>

    <h2>CLÁUSULA TERCEIRA - DO PREÇO E CONDIÇÕES DE PAGAMENTO</h2>
    <p class="clausula">O valor total da mão de obra objeto deste contrato é de R$ {{contrato.valor_total}}
    ({{contrato.valor_extenso}}), que será pago conforme cronograma abaixo:</p>

    <table>
        <tr><th>Parcela</th><th>Etapa</th><th>Percentual</th><th>Valor</th></tr>
        <tr><td>1ª</td><td>Assinatura do contrato</td><td>{{parcela1.percentual}}%</td><td>R$ {{parcela1.valor}}</td></tr>
        <tr><td>2ª</td><td>{{parcela2.etapa}}</td><td>{{parcela2.percentual}}%</td><td>R$ {{parcela2.valor}}</td></tr>
        <tr><td>3ª</td><td>{{parcela3.etapa}}</td><td>{{parcela3.percentual}}%</td><td>R$ {{parcela3.valor}}</td></tr>
        <tr><td>4ª</td><td>Conclusão e entrega</td><td>{{parcela4.percentual}}%</td><td>R$ {{parcela4.valor}}</td></tr>
    </table>

    <p class="clausula"><strong>§1º</strong> Os pagamentos serão efetuados mediante transferência bancária para:</p>
    <p class="item">Banco: {{empresa.banco}} | Agência: {{empresa.agencia}} | Conta: {{empresa.conta}}</p>
    <p class="item">PIX (CNPJ): 43.716.324/0001-33</p>
    <p class="clausula"><strong>§2º</strong> O atraso no pagamento implicará multa de 2% e juros de 1% ao mês.</p>

    <h2>CLÁUSULA QUARTA - DOS MATERIAIS</h2>
    <p class="clausula">Os materiais necessários à execução dos serviços serão fornecidos pelo CONTRATANTE,
    conforme lista de materiais (Anexo II) a ser entregue pela CONTRATADA.</p>
    <p class="clausula"><strong>§1º</strong> A CONTRATADA se responsabiliza pela guarda e uso adequado dos materiais.</p>
    <p class="clausula"><strong>§2º</strong> Eventuais desperdícios superiores a 10% serão de responsabilidade da CONTRATADA.</p>

    <h2>CLÁUSULA QUINTA - DAS OBRIGAÇÕES DA CONTRATADA</h2>
    <p class="clausula">São obrigações da CONTRATADA:</p>
    <p class="item">a) Executar os serviços conforme projeto e especificações técnicas;</p>
    <p class="item">b) Manter equipe qualificada e em número suficiente para cumprimento dos prazos;</p>
    <p class="item">c) Fornecer ferramentas e equipamentos necessários;</p>
    <p class="item">d) Cumprir normas de segurança do trabalho, fornecendo EPIs aos funcionários;</p>
    <p class="item">e) Manter o local limpo e organizado durante a execução;</p>
    <p class="item">f) Comunicar imediatamente quaisquer problemas ou imprevistos;</p>
    <p class="item">g) Emitir notas fiscais correspondentes aos pagamentos recebidos;</p>
    <p class="item">h) Responsabilizar-se por encargos trabalhistas e previdenciários de sua equipe.</p>

    <h2>CLÁUSULA SEXTA - DAS OBRIGAÇÕES DO CONTRATANTE</h2>
    <p class="clausula">São obrigações do CONTRATANTE:</p>
    <p class="item">a) Fornecer os materiais conforme cronograma e especificações;</p>
    <p class="item">b) Efetuar os pagamentos nas datas acordadas;</p>
    <p class="item">c) Fornecer água, energia elétrica e sanitário para uso da equipe;</p>
    <p class="item">d) Disponibilizar projetos e documentação técnica necessária;</p>
    <p class="item">e) Aprovar ou solicitar correções nas etapas executadas em até 3 dias;</p>
    <p class="item">f) Comunicar previamente sobre visitas ou alterações no cronograma.</p>

    <h2>CLÁUSULA SÉTIMA - DA GARANTIA</h2>
    <p class="clausula">A CONTRATADA oferece garantia de 12 (doze) meses sobre os serviços executados,
    contados a partir da data de entrega final e aceite pelo CONTRATANTE.</p>
    <p class="clausula"><strong>§1º</strong> A garantia cobre defeitos de execução, não se aplicando a:</p>
    <p class="item">a) Desgaste natural dos materiais;</p>
    <p class="item">b) Uso inadequado ou falta de manutenção;</p>
    <p class="item">c) Modificações realizadas por terceiros;</p>
    <p class="item">d) Problemas estruturais pré-existentes.</p>
    <p class="clausula"><strong>§2º</strong> Solicitações de garantia devem ser feitas por escrito,
    com prazo de atendimento de até 15 dias úteis.</p>

    <h2>CLÁUSULA OITAVA - DO SEGURO</h2>
    <p class="clausula">A CONTRATADA manterá seguro de responsabilidade civil durante a execução dos serviços,
    cobrindo danos a terceiros e ao patrimônio do CONTRATANTE.</p>

    <h2>CLÁUSULA NONA - DA RESCISÃO</h2>
    <p class="clausula">O presente contrato poderá ser rescindido:</p>
    <p class="item">a) Por acordo mútuo entre as partes;</p>
    <p class="item">b) Por descumprimento de obrigações contratuais;</p>
    <p class="item">c) Por impossibilidade técnica comprovada.</p>
    <p class="clausula"><strong>§1º</strong> Em caso de rescisão por iniciativa do CONTRATANTE sem justa causa,
    este pagará multa de 30% sobre o valor não executado.</p>
    <p class="clausula"><strong>§2º</strong> Em caso de rescisão por culpa da CONTRATADA, esta devolverá
    valores recebidos proporcionalmente aos serviços não executados, acrescidos de multa de 20%.</p>

    <h2>CLÁUSULA DÉCIMA - DAS PENALIDADES</h2>
    <p class="clausula">O atraso injustificado na execução dos serviços sujeitará a CONTRATADA a multa
    diária de 0,5% sobre o valor total do contrato, limitada a 10%.</p>
    <p class="clausula">O abandono da obra por período superior a 5 dias sem justificativa configura
    rescisão por culpa da CONTRATADA.</p>

    <h2>CLÁUSULA DÉCIMA PRIMEIRA - DO ADITIVO</h2>
    <p class="clausula">Quaisquer serviços adicionais não previstos neste contrato serão objeto de
    aditivo contratual, com valores e prazos a serem acordados entre as partes.</p>

    <h2>CLÁUSULA DÉCIMA SEGUNDA - DO FORO</h2>
    <p class="clausula">Fica eleito o Foro da Comarca de Santo André/SP para dirimir quaisquer questões
    oriundas deste contrato, renunciando as partes a qualquer outro, por mais privilegiado que seja.</p>

    <div class="assinaturas">
        <p>E por estarem assim justos e contratados, firmam o presente instrumento em 2 (duas) vias de igual
        teor e forma, na presença de 2 (duas) testemunhas.</p>

        <p style="text-align: center; margin-top: 30px;">{{contrato.cidade}}, {{contrato.data_extenso}}</p>

        <div style="text-align: center; margin-top: 60px;">
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p><strong>CONTRATANTE</strong></p>
                <p>{{pessoa.nome}}</p>
                <p>CPF: {{pessoa.cpf}}</p>
            </div>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p><strong>CONTRATADA</strong></p>
                <p>WG ALMEIDA REFORMAS ESPECIALIZADAS LTDA</p>
                <p>CNPJ: 43.716.324/0001-33</p>
            </div>
        </div>

        <div style="margin-top: 60px;">
            <p><strong>TESTEMUNHAS:</strong></p>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p>Nome: _______________________________</p>
                <p>CPF: ________________________________</p>
            </div>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p>Nome: _______________________________</p>
                <p>CPF: ________________________________</p>
            </div>
        </div>
    </div>
</body>
</html>',
    '[
        {
            "ordem": 1,
            "tipo": "objeto",
            "titulo": "DO OBJETO",
            "conteudo": "Prestação de serviços de mão de obra para execução de obra conforme Memorial Executivo anexo."
        },
        {
            "ordem": 2,
            "tipo": "prazo",
            "titulo": "DO PRAZO DE EXECUÇÃO",
            "conteudo": "Prazo em dias corridos com possibilidade de prorrogação de 15 dias por condições climáticas, atraso de materiais ou alterações de escopo."
        },
        {
            "ordem": 3,
            "tipo": "preco",
            "titulo": "DO PREÇO E CONDIÇÕES DE PAGAMENTO",
            "conteudo": "Pagamento em parcelas conforme cronograma de obra. Multa de 2% e juros de 1% ao mês por atraso."
        },
        {
            "ordem": 4,
            "tipo": "personalizada",
            "titulo": "DOS MATERIAIS",
            "conteudo": "Materiais fornecidos pelo contratante. Desperdícios superiores a 10% são de responsabilidade da contratada."
        },
        {
            "ordem": 5,
            "tipo": "obrigacoes_contratada",
            "titulo": "DAS OBRIGAÇÕES DA CONTRATADA",
            "conteudo": "Execução conforme projeto, equipe qualificada, ferramentas, EPIs, limpeza, comunicação, notas fiscais, encargos trabalhistas."
        },
        {
            "ordem": 6,
            "tipo": "obrigacoes_contratante",
            "titulo": "DAS OBRIGAÇÕES DO CONTRATANTE",
            "conteudo": "Fornecer materiais, pagamentos, água/energia/sanitário, projetos, aprovação de etapas em 3 dias."
        },
        {
            "ordem": 7,
            "tipo": "garantia",
            "titulo": "DA GARANTIA",
            "conteudo": "Garantia de 12 meses sobre serviços executados. Não cobre desgaste natural, uso inadequado ou modificações por terceiros."
        },
        {
            "ordem": 8,
            "tipo": "personalizada",
            "titulo": "DO SEGURO",
            "conteudo": "Seguro de responsabilidade civil mantido pela contratada durante a execução."
        },
        {
            "ordem": 9,
            "tipo": "rescisao",
            "titulo": "DA RESCISÃO",
            "conteudo": "Multa de 30% para contratante e 20% para contratada em caso de rescisão sem justa causa."
        },
        {
            "ordem": 10,
            "tipo": "penalidades",
            "titulo": "DAS PENALIDADES",
            "conteudo": "Multa diária de 0,5% por atraso (limite 10%). Abandono por mais de 5 dias configura rescisão."
        },
        {
            "ordem": 11,
            "tipo": "personalizada",
            "titulo": "DO ADITIVO",
            "conteudo": "Serviços adicionais mediante aditivo contratual."
        },
        {
            "ordem": 12,
            "tipo": "foro",
            "titulo": "DO FORO",
            "conteudo": "Foro da Comarca de Santo André/SP."
        }
    ]'::jsonb,
    '["pessoa.nome", "pessoa.cpf", "pessoa.rg", "pessoa.endereco", "pessoa.cidade", "pessoa.estado", "pessoa.telefone", "pessoa.email", "imovel.endereco", "imovel.cidade", "imovel.estado", "obra.tipo_obra", "obra.prazo_execucao", "contrato.valor_total", "contrato.valor_extenso", "contrato.cidade", "contrato.data_extenso"]'::jsonb
)
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    conteudo_html = EXCLUDED.conteudo_html,
    clausulas = EXCLUDED.clausulas,
    variaveis_obrigatorias = EXCLUDED.variaveis_obrigatorias,
    updated_at = NOW();

-- =============================================================================
-- 3. MODELO DE CONTRATO - MARCENARIA (Venda de Produtos e Montagem)
-- =============================================================================
-- Empresa: WG ALMEIDA Marcenaria de Alto Padrão Ltda
-- CNPJ: 46.836.926/0001-12
-- =============================================================================

INSERT INTO juridico_modelos_contrato (
    codigo,
    nome,
    descricao,
    nucleo,
    status,
    versao,
    conteudo_html,
    clausulas,
    variaveis_obrigatorias
) VALUES (
    'MOD-MAR-MOVEIS-001',
    'Contrato de Venda de Móveis Planejados e Montagem',
    'Modelo padrão de contrato para venda de móveis planejados sob medida com montagem, incluindo garantia de 6 anos e cláusula de reserva de domínio.',
    'marcenaria',
    'publicado',
    1,
    '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; font-size: 12pt; line-height: 1.5; margin: 40px; }
        h1 { text-align: center; font-size: 16pt; margin-bottom: 30px; }
        h2 { font-size: 14pt; margin-top: 20px; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
        .partes { margin: 20px 0; }
        .clausula { margin: 15px 0; text-align: justify; }
        .item { margin: 10px 0 10px 20px; }
        .assinaturas { margin-top: 50px; }
        .assinatura-box { display: inline-block; width: 45%; text-align: center; margin-top: 60px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        td, th { border: 1px solid #ccc; padding: 8px; text-align: left; }
        .ambiente { background-color: #f5f5f5; font-weight: bold; }
    </style>
</head>
<body>
    <h1>CONTRATO PARTICULAR DE COMPRA E VENDA DE MÓVEIS PLANEJADOS COM MONTAGEM</h1>

    <div class="partes">
        <p><strong>VENDEDORA:</strong> WG ALMEIDA MARCENARIA DE ALTO PADRÃO LTDA, pessoa jurídica de direito privado,
        inscrita no CNPJ sob o nº 46.836.926/0001-12, com sede à Rua Cel. Alfredo Fláquer, 1141, sala 31,
        Centro, Santo André/SP, CEP 09020-030, neste ato representada por seu sócio administrador
        WELLINGTON GRACIELE DE ALMEIDA, brasileiro, casado, portador do RG nº 35.500.612-7 SSP/SP
        e CPF nº 324.548.628-80.</p>

        <p><strong>COMPRADOR(A):</strong> {{pessoa.nome}}, {{pessoa.nacionalidade}}, {{pessoa.estado_civil}}, {{pessoa.profissao}},
        portador(a) do RG nº {{pessoa.rg}} e inscrito(a) no CPF sob o nº {{pessoa.cpf}},
        residente e domiciliado(a) à {{pessoa.endereco}}, {{pessoa.cidade}}/{{pessoa.estado}},
        CEP {{pessoa.cep}}, telefone {{pessoa.telefone}}, e-mail {{pessoa.email}}.</p>
    </div>

    <h2>CLÁUSULA PRIMEIRA - DO OBJETO</h2>
    <p class="clausula">O presente contrato tem por objeto a venda de móveis planejados sob medida,
    fabricados pela VENDEDORA conforme projeto aprovado pelo COMPRADOR, incluindo montagem e instalação
    no imóvel situado à {{imovel.endereco}}, {{imovel.cidade}}/{{imovel.estado}}.</p>

    <h3>1.1 - ESPECIFICAÇÃO DOS AMBIENTES</h3>
    <table>
        <tr>
            <th>Ambiente</th>
            <th>Caixas</th>
            <th>Portas</th>
            <th>Lacca</th>
            <th>Dobradiça</th>
            <th>Corrediça</th>
            <th>Puxador</th>
        </tr>
        {{#each ambientes}}
        <tr>
            <td class="ambiente">{{this.nome}}</td>
            <td>{{this.caixas}}</td>
            <td>{{this.portas}}</td>
            <td>{{this.lacca}}</td>
            <td>{{this.dobradica}}</td>
            <td>{{this.corredica}}</td>
            <td>{{this.puxador}}</td>
        </tr>
        {{/each}}
    </table>

    <p class="clausula"><strong>Parágrafo Único:</strong> O detalhamento completo dos móveis, incluindo medidas,
    materiais e acabamentos, consta no Projeto de Marcenaria (Anexo I), que passa a fazer parte integrante
    deste contrato após aprovação pelo COMPRADOR.</p>

    <h2>CLÁUSULA SEGUNDA - DO PREÇO E CONDIÇÕES DE PAGAMENTO</h2>
    <p class="clausula">O valor total dos móveis objeto deste contrato é de R$ {{contrato.valor_total}}
    ({{contrato.valor_extenso}}), que será pago conforme condições abaixo:</p>

    <table>
        <tr><th>Parcela</th><th>Descrição</th><th>Percentual</th><th>Valor</th><th>Vencimento</th></tr>
        <tr><td>Entrada</td><td>Na assinatura do contrato</td><td>{{entrada.percentual}}%</td><td>R$ {{entrada.valor}}</td><td>{{entrada.vencimento}}</td></tr>
        <tr><td>2ª Parcela</td><td>Início da fabricação</td><td>{{parcela2.percentual}}%</td><td>R$ {{parcela2.valor}}</td><td>{{parcela2.vencimento}}</td></tr>
        <tr><td>3ª Parcela</td><td>Antes da entrega</td><td>{{parcela3.percentual}}%</td><td>R$ {{parcela3.valor}}</td><td>{{parcela3.vencimento}}</td></tr>
        <tr><td>Saldo</td><td>Após montagem</td><td>{{saldo.percentual}}%</td><td>R$ {{saldo.valor}}</td><td>{{saldo.vencimento}}</td></tr>
    </table>

    <p class="clausula"><strong>§1º</strong> Pagamentos em atraso serão acrescidos de multa de 2% e juros de 1% ao mês.</p>
    <p class="clausula"><strong>§2º</strong> O não pagamento de qualquer parcela autoriza a VENDEDORA a suspender
    a fabricação ou entrega até a regularização.</p>

    <h2>CLÁUSULA TERCEIRA - DO PRAZO DE ENTREGA</h2>
    <p class="clausula">Os móveis serão entregues e instalados no prazo de {{marcenaria.prazo_fabricacao}} dias úteis,
    contados a partir da aprovação do projeto final e confirmação do pagamento da entrada.</p>
    <p class="clausula"><strong>§1º</strong> O prazo poderá ser prorrogado em caso de:</p>
    <p class="item">a) Alterações solicitadas pelo COMPRADOR após aprovação do projeto;</p>
    <p class="item">b) Atraso na liberação do local para medição final ou montagem;</p>
    <p class="item">c) Falta de condições adequadas no local (energia, água, acesso);</p>
    <p class="item">d) Caso fortuito ou força maior.</p>
    <p class="clausula"><strong>§2º</strong> A VENDEDORA comunicará previamente a data de entrega e montagem
    com antecedência mínima de 3 (três) dias úteis.</p>

    <h2>CLÁUSULA QUARTA - DA MONTAGEM</h2>
    <p class="clausula">A montagem será realizada por equipe especializada da VENDEDORA, em horário comercial,
    no prazo estimado de {{marcenaria.prazo_montagem}} dias úteis após a entrega.</p>
    <p class="clausula"><strong>§1º</strong> O COMPRADOR deverá garantir:</p>
    <p class="item">a) Acesso livre e desimpedido ao local;</p>
    <p class="item">b) Disponibilidade de energia elétrica;</p>
    <p class="item">c) Paredes e pisos finalizados;</p>
    <p class="item">d) Pontos elétricos e hidráulicos conforme projeto.</p>
    <p class="clausula"><strong>§2º</strong> Serviços adicionais de marcenaria, elétrica ou hidráulica não previstos
    serão orçados separadamente.</p>

    <h2>CLÁUSULA QUINTA - DA GARANTIA</h2>
    <p class="clausula">A VENDEDORA oferece as seguintes garantias:</p>
    <table>
        <tr><th>Item</th><th>Prazo de Garantia</th></tr>
        <tr><td>Estrutura dos móveis (caixas e tampos)</td><td>6 (seis) anos</td></tr>
        <tr><td>Portas e gavetas</td><td>6 (seis) anos</td></tr>
        <tr><td>Pintura e acabamento em Lacca</td><td>3 (três) anos</td></tr>
        <tr><td>Ferragens (dobradiças e corrediças)</td><td>Conforme fabricante</td></tr>
        <tr><td>Puxadores e acessórios</td><td>90 (noventa) dias</td></tr>
    </table>

    <p class="clausula"><strong>§1º</strong> A garantia não cobre:</p>
    <p class="item">a) Danos causados por mau uso, umidade excessiva ou falta de manutenção;</p>
    <p class="item">b) Desgaste natural dos materiais;</p>
    <p class="item">c) Modificações realizadas por terceiros;</p>
    <p class="item">d) Danos causados por instalações elétricas ou hidráulicas inadequadas.</p>
    <p class="clausula"><strong>§2º</strong> A solicitação de garantia deve ser feita por escrito,
    com atendimento em até 15 dias úteis.</p>

    <h2>CLÁUSULA SEXTA - DAS OBRIGAÇÕES DA VENDEDORA</h2>
    <p class="clausula">São obrigações da VENDEDORA:</p>
    <p class="item">a) Fabricar os móveis conforme projeto aprovado e especificações acordadas;</p>
    <p class="item">b) Utilizar materiais de primeira qualidade;</p>
    <p class="item">c) Realizar a montagem com profissionais qualificados;</p>
    <p class="item">d) Corrigir eventuais defeitos de fabricação dentro do prazo de garantia;</p>
    <p class="item">e) Manter o local limpo após a montagem;</p>
    <p class="item">f) Fornecer manual de uso e conservação dos móveis.</p>

    <h2>CLÁUSULA SÉTIMA - DAS OBRIGAÇÕES DO COMPRADOR</h2>
    <p class="clausula">São obrigações do COMPRADOR:</p>
    <p class="item">a) Efetuar os pagamentos nas datas acordadas;</p>
    <p class="item">b) Aprovar ou solicitar alterações no projeto em até 5 dias úteis;</p>
    <p class="item">c) Garantir as condições adequadas para montagem;</p>
    <p class="item">d) Informar sobre alterações no imóvel que possam afetar as medidas;</p>
    <p class="item">e) Receber os móveis no ato da entrega ou indicar representante;</p>
    <p class="item">f) Seguir as orientações de uso e manutenção.</p>

    <h2>CLÁUSULA OITAVA - DA RESERVA DE DOMÍNIO</h2>
    <p class="clausula">Os móveis objeto deste contrato são vendidos com RESERVA DE DOMÍNIO,
    permanecendo de propriedade da VENDEDORA até o pagamento integral do preço.</p>
    <p class="clausula"><strong>§1º</strong> Até a quitação total, o COMPRADOR não poderá vender, ceder,
    emprestar ou onerar os móveis de qualquer forma.</p>
    <p class="clausula"><strong>§2º</strong> Em caso de inadimplência, a VENDEDORA poderá retomar os móveis,
    deduzindo do valor pago os custos de remoção e depreciação de 20%.</p>

    <h2>CLÁUSULA NONA - DA RESCISÃO</h2>
    <p class="clausula">O presente contrato poderá ser rescindido:</p>
    <p class="item">a) Por acordo mútuo entre as partes;</p>
    <p class="item">b) Por inadimplência do COMPRADOR superior a 30 dias;</p>
    <p class="item">c) Por descumprimento de obrigações contratuais.</p>
    <p class="clausula"><strong>§1º</strong> Em caso de desistência pelo COMPRADOR:</p>
    <p class="item">- Antes do início da fabricação: devolução de 70% do valor pago;</p>
    <p class="item">- Durante a fabricação: devolução de 30% do valor pago;</p>
    <p class="item">- Após a fabricação: sem direito a devolução.</p>
    <p class="clausula"><strong>§2º</strong> Em caso de rescisão por culpa da VENDEDORA, esta devolverá
    integralmente os valores pagos, corrigidos monetariamente.</p>

    <h2>CLÁUSULA DÉCIMA - DO FORO</h2>
    <p class="clausula">Fica eleito o Foro da Comarca de Santo André/SP para dirimir quaisquer questões
    oriundas deste contrato, renunciando as partes a qualquer outro, por mais privilegiado que seja.</p>

    <div class="assinaturas">
        <p>E por estarem assim justos e contratados, firmam o presente instrumento em 2 (duas) vias de igual
        teor e forma, na presença de 2 (duas) testemunhas.</p>

        <p style="text-align: center; margin-top: 30px;">{{contrato.cidade}}, {{contrato.data_extenso}}</p>

        <div style="text-align: center; margin-top: 60px;">
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p><strong>COMPRADOR(A)</strong></p>
                <p>{{pessoa.nome}}</p>
                <p>CPF: {{pessoa.cpf}}</p>
            </div>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p><strong>VENDEDORA</strong></p>
                <p>WG ALMEIDA MARCENARIA DE ALTO PADRÃO LTDA</p>
                <p>CNPJ: 46.836.926/0001-12</p>
            </div>
        </div>

        <div style="margin-top: 60px;">
            <p><strong>TESTEMUNHAS:</strong></p>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p>Nome: _______________________________</p>
                <p>CPF: ________________________________</p>
            </div>
            <div class="assinatura-box">
                <p>_______________________________________</p>
                <p>Nome: _______________________________</p>
                <p>CPF: ________________________________</p>
            </div>
        </div>
    </div>
</body>
</html>',
    '[
        {
            "ordem": 1,
            "tipo": "objeto",
            "titulo": "DO OBJETO",
            "conteudo": "Venda de móveis planejados sob medida com montagem e instalação. Especificação de ambientes com caixas, portas, lacca, ferragens e puxadores."
        },
        {
            "ordem": 2,
            "tipo": "preco",
            "titulo": "DO PREÇO E CONDIÇÕES DE PAGAMENTO",
            "conteudo": "Pagamento em parcelas: entrada, início da fabricação, antes da entrega e após montagem. Multa de 2% e juros de 1% por atraso."
        },
        {
            "ordem": 3,
            "tipo": "prazo",
            "titulo": "DO PRAZO DE ENTREGA",
            "conteudo": "Prazo em dias úteis após aprovação do projeto e pagamento da entrada. Comunicação prévia de 3 dias para entrega."
        },
        {
            "ordem": 4,
            "tipo": "personalizada",
            "titulo": "DA MONTAGEM",
            "conteudo": "Montagem por equipe especializada em horário comercial. Comprador deve garantir acesso, energia, paredes e pisos finalizados."
        },
        {
            "ordem": 5,
            "tipo": "garantia",
            "titulo": "DA GARANTIA",
            "conteudo": "6 anos para estrutura e portas, 3 anos para lacca, 90 dias para acessórios. Não cobre mau uso ou modificações por terceiros."
        },
        {
            "ordem": 6,
            "tipo": "obrigacoes_contratada",
            "titulo": "DAS OBRIGAÇÕES DA VENDEDORA",
            "conteudo": "Fabricar conforme projeto, materiais de qualidade, montagem profissional, correção de defeitos, limpeza, manual de uso."
        },
        {
            "ordem": 7,
            "tipo": "obrigacoes_contratante",
            "titulo": "DAS OBRIGAÇÕES DO COMPRADOR",
            "conteudo": "Pagamentos em dia, aprovação em 5 dias, condições para montagem, informar alterações no imóvel, seguir orientações de uso."
        },
        {
            "ordem": 8,
            "tipo": "personalizada",
            "titulo": "DA RESERVA DE DOMÍNIO",
            "conteudo": "Móveis permanecem propriedade da vendedora até quitação. Proibida venda, cessão ou oneração. Retomada em caso de inadimplência."
        },
        {
            "ordem": 9,
            "tipo": "rescisao",
            "titulo": "DA RESCISÃO",
            "conteudo": "Desistência antes da fabricação: devolução de 70%. Durante: 30%. Após: sem devolução. Culpa da vendedora: devolução integral."
        },
        {
            "ordem": 10,
            "tipo": "foro",
            "titulo": "DO FORO",
            "conteudo": "Foro da Comarca de Santo André/SP."
        }
    ]'::jsonb,
    '["pessoa.nome", "pessoa.cpf", "pessoa.rg", "pessoa.endereco", "pessoa.cidade", "pessoa.estado", "pessoa.telefone", "pessoa.email", "imovel.endereco", "imovel.cidade", "imovel.estado", "contrato.valor_total", "contrato.valor_extenso", "contrato.cidade", "contrato.data_extenso", "marcenaria.prazo_fabricacao", "marcenaria.prazo_montagem"]'::jsonb
)
ON CONFLICT (codigo) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    conteudo_html = EXCLUDED.conteudo_html,
    clausulas = EXCLUDED.clausulas,
    variaveis_obrigatorias = EXCLUDED.variaveis_obrigatorias,
    updated_at = NOW();

-- =============================================================================
-- 4. VARIÁVEIS ESPECÍFICAS - COMENTADO (tabela juridico_variaveis com estrutura diferente)
-- =============================================================================
-- As variáveis são definidas diretamente no campo variaveis_obrigatorias de cada modelo
-- e serão substituídas dinamicamente na geração do contrato

-- =============================================================================
-- VERIFICAÇÃO
-- =============================================================================
SELECT
    codigo,
    nome,
    nucleo,
    status,
    versao,
    jsonb_array_length(variaveis_obrigatorias) as qtd_variaveis
FROM juridico_modelos_contrato
WHERE codigo IN ('MOD-ARQ-PROJETO-001', 'MOD-ENG-OBRA-001', 'MOD-MAR-MOVEIS-001')
ORDER BY nucleo;
