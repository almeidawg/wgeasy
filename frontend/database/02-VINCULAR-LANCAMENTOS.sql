-- ============================================
-- PARTE 2: VINCULAR LANÇAMENTOS AOS CLIENTES
-- Execute DEPOIS de cadastrar os clientes
-- ============================================

-- Danilo e Renata (22 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Danilo e Renata') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Elétrica',
    'Seguro Obra',
    'Plotagens',
    'Demolição Fase 1',
    'Demolição Fase 2',
    'Sistema Exaustão',
    'Nivelamento contra Piso',
    '40% gesseiro',
    'Plantas',
    'Receita',
    'RRT Simples',
    'RRT 1806817',
    'Material',
    'Caçamba de Entulho',
    'Material + Gesso',
    'Gesso',
    'Tijolo Baiano',
    'Cimento',
    'Sacos de Areia'
  );

-- Fábio Luis Moreira (34 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Fábio Luis Moreira') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Ar Condicionado',
    'Lego',
    'Taxa de Autorização',
    'Eletricista',
    '-',
    'Portas Correr',
    'Luminárias',
    'Cortina Rolo Automatizada',
    'Papeis de Parede',
    'Gesso',
    'Pintrura',
    'Mão de Obra Geral',
    'Aquecedor a Gás',
    'Instalação',
    'Caçamba para Entulho',
    'Sacos para Entulho',
    'Envidraçamento Sacada',
    'Material',
    'Locação Martelete',
    'Ajudante  28-03 a 01-04',
    'Recolhe entulho',
    'Material Drenos',
    'Piso Vinilico',
    'Receita',
    'Projeto Gesso',
    'Isolação Acustica + Parede'
  );

-- Fernando Macedo (67 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Fernando Macedo') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    '1 pagamento',
    '2 de 2',
    'Adesivos Azulejos',
    '1 de 2',
    'Material + Instalação',
    'Eletricista',
    'Despesa',
    'Mão de Obra',
    'Aquecedor a Gás',
    'Sacada vidro2/2',
    'Pastilhas',
    'Material',
    'Saque 24h',
    '2 pagamento',
    'Banheira',
    'Piso',
    'Chaveiro',
    'Gesso',
    'Porcelanato',
    'Churrasqueira 1/2',
    'Piso de Madeira',
    'Tintas',
    '3 pagamento',
    'Pastilhas 1/2',
    'Churrasqueira 2/2',
    'Pastilhas 2/2',
    'transporte',
    'rodapé',
    'Sacada vidro1/2',
    'AR Condicionado',
    '4 pagamento',
    'Luminarias',
    'Marcenanria',
    'Elétrica',
    'Mão de Obra Marcenaria 1-2',
    'Fitas de led',
    'Ventuinha e Elice Churras'
  );

-- Laerson Phol Borre (45 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Laerson Phol Borre') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Caçamba de Entulho',
    'Thalita Nunes',
    'Pisos',
    'Mão de Obra',
    'JOLY',
    'Emissão doc',
    'TBI CAÇAMBA',
    'Gesso',
    'Chave',
    'Gesso TED',
    'Caixas de papelão',
    'Flat -Hospedagem',
    'Telha Norte',
    'Tintas',
    'Mc Donald''s',
    'Material',
    'Hidráulica',
    'Andre (Transporte)',
    'Comércio de materiais p/ C',
    'Cia do Porcelanato',
    'Deposito J Jota',
    'TBI 7472.07947',
    'NICOM',
    'Colchões',
    'Transporte',
    'Despesas',
    'Receita',
    'Mauricio Junior',
    'Material Elétrica',
    '2 pagamento'
  );

-- W.G. DE ALMEIDA DESIGNER DE INTERIORES (1000 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('W.G. DE ALMEIDA DESIGNER DE INTERIORES') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'RSHOP Bis Buger',
    'TBI',
    'RSHOP Charme Paulista',
    'RSHOP LEO-MADEIRA',
    'RSHOP RED BEAN',
    'RSHOP EG AUTO POSTO',
    'Taxas Internet',
    'RSHOP Kalunga',
    'Silva Barbosa com de Ali',
    'RSHOP PIZZA HUT',
    'RSHOP Makis Place',
    'RSHOP VITORIA S F',
    'RSHOP Stars Bar',
    'IOF',
    'RSHOP POSTO AGULHA',
    'RSHOP AUTO POSTO',
    'ENCARGO CONTA C.',
    'Elétrica',
    'TAR COMUNICADO DIGIT.',
    'TAR DOC INTERNET',
    'RSHOP PIRAJA',
    'RSHOP STAR INFORM',
    'Magazine Luiza',
    'Impressora',
    'TBI Advogada',
    'TAR TED INTERNET',
    'TBI salário',
    'salário',
    'RSHOP SHELL',
    'RSHOP POSTO N B',
    'RSHOP RYOKO SUSHI',
    'RSHOP PUTIZZERIA B.',
    'RSHOP BAR e Lanchonete',
    'Materiais',
    'RSHOP SÃO FRANCISCO',
    'RSHOP YOGOBERRY',
    'RSHOP TK TMACKI',
    'BANANA TROPICAL',
    'RSHOP ACONCHEGO',
    'RSHOP FNAC MORUMBI',
    'RSHOP SUBWAY',
    'RSHOP ALTEMIR MAR',
    'RSHOP HANGAR BEER..',
    'RSHOP Sintia Mari',
    'RSHOP MIKAR PARK',
    'REGUS HQ',
    'Fnac',
    'RSHOP FAST SHOP',
    'ORGANIZZE PACOTE',
    'CARTÕES DE VISITA',
    'CONTA GOOGLE',
    'REEMBOLSO ALMOÇO',
    'PALNTAS',
    'ARTE D''LUZ',
    'RSHOP CONCHEGO',
    'TAD DOC INTERNET',
    'RSHOP MSC',
    'RSHOP FUNCHAL AUTO P.',
    'RSHOP POSTO SERVI',
    'GASOLINA',
    'ALMOÇO',
    'Puxadores Portas Marcenaria Sabrina',
    'Identificação no extrato: Tags',
    'Material Obra Perez',
    'Pedal Peruibe X Barra do Una',
    'Furos nas vigas',
    'Almoço',
    'Registro do site wgalmeida.com.br 3 anos',
    'Limpeza do apartamento e Roupa Passada',
    'Aluguel Apartamento',
    'Pagar Saldo Restaurante Dairin',
    'Seguro Bicicleta 1/2',
    'Compra Decatlhon 1/2',
    'Itens Extras Confirmar Qual obra',
    'Saldo da semana 07/07',
    'Recompensa Ajudante Roberto',
    'Recompensa Roberto',
    'Infra Automação Ajudante Roberto 5 diárias',
    'Em aberto compra de Roupas',
    'Infra Automação Roberto 5 diárias',
    'Revestimento Obra Mauro e Perez',
    'Retirada de Entulho Obra Perez',
    'Curso de Ingleês 1/14',
    'Gesseiro Obra Mauro',
    'Compra Bicicleta 2/2',
    'Compra Sapatilha',
    'Compra Decatlhon 2/2',
    'Seguro Bicicleta 2/2',
    'Saldo a quitar Ação trabalhista',
    'Web',
    'transferencia de site e sistema para amazon',
    'Parcela Final Sistema  Wg',
    'Extras Sistema Wg',
    'Adwords',
    'Marcenaria',
    'Pagamento de Empréstimo',
    'RECEITA OBRA CONSULTORIO',
    'DESCONTADO DO PROJETO MARCENARIA DO AP',
    'Alimentação',
    'Sistema',
    'Marketing',
    'Publicidade e Propaganda',
    'Marceneiro',
    'Projeto',
    'Diversos',
    'Telefone Celular',
    'Gesso',
    'Despesa Assintura Eletronica',
    'Despesas Jurídicas',
    'Despesas Pessoais',
    'Despesas com Escritório',
    'Pessoal',
    'Empréstimo Forma (4.000 Obra Mocca + 4 Obra consultório)',
    'Despesa pessoal.',
    'Marketing digital ads e facebook',
    'Despesa cabo carregador celular.',
    'TRANSPORTE FERRAGENS OBRA RUBENS E AMANDA (PEDIR REEMBOLSO FORMA MARCENARIA )',
    'PESSOAL',
    'DESPESA VISITA OBRA MARIO E ANINHA',
    'Estacionamento 15,00 pessoal',
    'Material de escritório.',
    'Despesa pessoal correios.',
    'DESPESA OBRA SQUASH',
    'Gráfica',
    'OBRA SQUASH',
    'Despesa pessoal farmácia.',
    'Evento archathon Samsung',
    'RECEB DE TED DEVOLVIDA - JOSE RAI DOS SANTOS PEREIRA - 2 - Agencia ou Conta Destinataria do Credito',
    'Transferência/TED - Banco - 341 - Ag - 3190 - Conta - 49369-9 - JOSE RAI DOS SANTOS PEREIRA',
    'Transferência entre contas Original - Ag - 0001 Conta - 12194476 - WILLIAM GOMES DE ALMEIDA',
    'Transferência',
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'COMPRA DEBITO NACIONAL - UberBR UBER TRIP HELP.-SP-BRA',
    'COMPRA DEBITO NACIONAL - ZAFFARI MORUMBI -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*amaurycastro -SAOPAULO-BRA',
    'COMPRA DEBITO NACIONAL - PONCHO VERDE CHURRASCA-SAO PAULO-BRA',
    'FERRAMENTA DE TRABALHO PRA OBRA',
    'COMPRA DEBITO NACIONAL - PAG*MonteSinaiLanchon -SAOPAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAVONI PIZZARIA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - SAO CRISTOVAO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - EQUIPE CABELEIREIROS -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - UBIRACI SOARES GARCIA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - ARMAZEM PIOLA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - POSTO DE SERVICOS 2002-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*PgftFestasE -SAOPAULO-BRA',
    'COMPRA DEBITO NACIONAL - MERCADOPAGO *TJRX -OSASCO-BRA',
    'COMPRA DEBITO NACIONAL - PANVEL FARMACIAS -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - JOSE CONCEICAO -OSASCO-BRA',
    'EVENTO ARCHATHON SAMSUNG',
    'DESPESA VISITA A ESCRITÓRIO E COMPRA DE CAMISETAS UNIFORMES NOVOS',
    'DESPESA ESCRITÓRIO',
    'COMPRA DEBITO NACIONAL - CUCA REAL II -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CAMISETAS MAGIC -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MASTER TEMAKERIA -SAO PAULO-BRA',
    'Compra de camisetas - Uniforme',
    'Feira Abimad',
    'Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 1023720-3 - Josemar Joaquim de Souza',
    'ESTORNO COMPRA NACIONAL - UberBR UBER TRIP HELP.-SP-BRA',
    'Despesa com café.',
    'COMPRA DEBITO NACIONAL - PRIME EDITORIAL -CARAPICUIBA-BRA',
    'ESTORNO COMPRA NACIONAL - LANCHONETE FLOR DA TEO-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - KALUNGA GIOVANNI GRONC-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - EG AUTO POSTO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CONILREM -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MORUMBI -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LANCHONETE FLOR DA TEO-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - AUTO POSTO PETRO SUL L-SAO PAULO-BRA',
    'Despesa CNH 1 de 2',
    'Compra de material de escritório: folha A3',
    'Pessoal!',
    'Almoço despesa empresa. Data não identificada.',
    'COMPRA DEBITO NACIONAL - OUTBACK BZ 13 MOEMA -SAO PAULO-BRA Pessoal almoço',
    'Transferência/TED - Banco - 33 - Ag - 3553 - Conta - 1007187-0 - Paulo Eduardo de Carvalho tauro Acordo Judicial',
    'COMPRA DEBITO NACIONAL - ZARA IBIRAPUERA -SAO PAULO-BRA',
    'Crédito para anúncio Google e insta.',
    'COMPRA DEBITO NACIONAL - PARK ZONE- SHOP. IBIRA-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - VERONICA GOMES MOTA DE-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - FRUTARIA EXPRESS MORUM-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CARNES PANAMBY LTDA -SAO PAULO-BRA',
    'ESTORNO COMPRA NACIONAL - PARK ZONE- SHOP. IBIRA-SAO PAULO-BRA',
    'Transferência/TED - Banco - 260 - Ag - 1 - Conta - 8862575-7 - WILLIAM GOMES DE ALMEIDA',
    'Uber',
    'Café',
    'COMPRA DEBITO NACIONAL - MARACA ELETRICA HIDRAU-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CEREALLI -COTIA-BRA',
    'COMPRA DEBITO NACIONAL - BAR LANC TRANSMONTANO -SAO PAULO-BRA',
    'Pessoal Prólabore.',
    'COMPRA DEBITO NACIONAL - VANDERBOL -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - OMTS EMPREENDIMENTOS S-COTIA-BRA',
    'Equipamentos',
    'COMPRA DEBITO NACIONAL - NORMA RODRIGUES DA SIL-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*HernaniMelsone -SAOPAULO-BRA',
    'COMPRA DEBITO NACIONAL - BR STORE -SAO PAULO-BRA',
    'Prolabore Pessoal.',
    'TED RECEBIDA - <28177227874> - <ANA PAULA CRISPIM>',
    'Transferência/TED - Banco - 237 - Ag - 516 - Conta - 72345-2 - Paulo Sergio Vaz Leite',
    'SAQUE BCO 24HORAS - 00028395-20200214181224',
    'SAQUE BCO 24HORAS - 00028395-20200214181057',
    'COMPRA DEBITO NACIONAL - CARREFOUR 48 SPG-GIOVA-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - ELISA M CABELEIREIRA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MC DONALDS MTW -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 9106 - Conta - 21462-0 - keyborder bordados ind',
    'RECEB DE TED DEVOLVIDA - keyborder bordados ind - 2 - Agencia ou Conta Destinataria do Credito Inval',
    'Pessoal Prolabore',
    'SAQUE BCO 24HORAS - 00052252-20200216122829',
    'SAQUE BCO 24HORAS - 00052252-20200216122722',
    'Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'Transferência/TED - Banco - 341 - Ag - 8846 - Conta - 25839-3 - PATRICIA DOS SANTOS',
    'COMPRA DEBITO NACIONAL - MINIMERCADO LJ 5221 -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - FAST STOP PARADA RAPID-SAO PAULO-BRA',
    'Pessoal prolabore',
    'Transferência/TED - Banco - 341 - Ag - 9106 - Conta - 10642-1 - Keyborder BORDADOS IND',
    'COMPRA DEBITO NACIONAL - MINNUTO PAO LJ 5425 -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MANDA BRASA EVENTOS E -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - SQUASH LIFE QUADRAS PO-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - NEW CLASH PAPER LTDA --SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - POSTO SERV GUARARAPES -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - SAVEMO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CASA DO NORTE DA MAMAE-SAO PAULO-BRA',
    'SAQUE BCO 24HORAS - 00028334-20200218135135',
    'COMPRA DEBITO NACIONAL - SEN LIVRARIA E PAPELAR-COTIA-BRA',
    'COMPRA DEBITO NACIONAL - ACQ*zakporba -Sao Paulo-BRA',
    'COMPRA DEBITO NACIONAL - CHURRASCO DO GORDAO -SAO PAULO-BRA',
    'Pessoal.',
    '50,00 recarga crédito servidor',
    'COMPRA DEBITO NACIONAL - CACAU SHOW CURSINO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LBS MATERIAIS P/CONSTR-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - EU TU ELES BAR -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - ALE PARKING -SAO PAULO-BRA',
    'Transferência/TED - Banco - 104 - Ag - 363 - Conta - 12637-0 - PATRÍCIA BASTISTA SYLVESTRE SOARES',
    'Despesa reunião com prospect',
    'Despesa transporte',
    'Caçamba',
    'Transferência/TED - Banco - 1 - Ag - 4328 - Conta - 18947-2 - SEIXAS E RAMOS COMERCIAL EIRELI ME',
    'Ferramenta Ferro',
    'Gastos publicitarios restantes a final de mes',
    'Conhecimento',
    'Café.',
    'COMPRA DEBITO NACIONAL - DIWIZA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LS DE SOUZA COMERCIO V-SAO PAULO-BRA',
    'PAGAMENTO DE CONTA - ENEL',
    'Água e Esgoto',
    'COMPRA DEBITO NACIONAL - DROGA MX -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - VANESSA KANASHIRO LIMA-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - ACAI BENZADEUS -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CANAS LORY -SAO PAULO-BRA',
    'Assistencia celular',
    'TRANSF CONTAS ORIGINAL - Ag - 0001 Conta - 10426728 - VICTÓRIA REGINA DE ALMEIDA',
    'COMPRA DEBITO NACIONAL - BAR E MERCEARIA GISMAR-SAO PAULO-BRA',
    'Transferência/TED - Banco - 1 - Ag - 4021 - Conta - 10417-5 - JOSÉ EDUARDO SARAIVA DA COSTA',
    'Internet',
    'COMPRA DEBITO NACIONAL - KITAGAWA TEMAKERIA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*ClebersonGomesBez -SAOPAULO-BRA',
    'SAQUE BCO 24HORAS - 00028395-20200228122355',
    'COMPRA DEBITO NACIONAL - RN MORUMBI TOWN -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LINDT E SPRUNGLI BRAZI-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - INSTITUTO NATY GUERRA -MONGAGUA-BRA',
    'Tinta da impressora.',
    'Créditos google MKT',
    'COMPRA DEBITO NACIONAL - PAG*1EstacaodaCostela -SAOPAULO-BRA',
    'Transporte',
    'COMPRA DEBITO NACIONAL - MADERO WASHINGTON LUIS-Sao Paulo-BRA',
    'COMPRA DEBITO NACIONAL - PAG*Mvcomerciodealime -SAOPAULO-BRA',
    'COMPRA DEBITO NACIONAL - MARKET GRANJA VIANA -COTIA-BRA',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 7681 - Conta - 5267-1 - DEIBIS DE ALMEIDA',
    'Crédito em conta.',
    'Apresentação de Obra a Prospects',
    'Transferência/TED - Banco - 104 - Ag - 263 - Conta - 167612-4 - SUSE MEIRE VILELA',
    'Transferência/TED - Banco - 341 - Ag - 4273 - Conta - 31598-8 - FELIPE DUTRA GONCALVES. Manutenção do site.',
    'COMPRA DEBITO NACIONAL - ROMAFER -SAO PAULO-BRA',
    'SAQUE BCO 24HORAS - 00045222-20200306184201',
    'SAQUE BCO 24HORAS - 00045222-20200306184059',
    'Transferência entre contas Original - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA',
    'Volta',
    'Ida',
    'COMPRA DEBITO NACIONAL - GRUPO ALQUIMIA -SAO PAULO-BRA',
    'Crédito em conta',
    'Material de escritório',
    'Visita fabrica/ marcenaria',
    'COMPRA DEBITO NACIONAL - BAR E RESTAURANTE CHAR-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CHARME DO BROOKLIN -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - JULIANO RODRIGO DE BAR-Sao Paulo-BRA',
    'COMPRA DEBITO NACIONAL - COMPENSADOS LANE -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - TBB MORUMBI TOWN -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LJ 3033 SHOP MORUMBI -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - RESTAURANTE CESTINHA -SANTOS-BRA',
    'COMPRA DEBITO NACIONAL - EXPRESSO LUXO SANTOS -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - AUTO POSTO RELIX -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - AUTOPASS -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 1145 - Conta - 13128-8 - ANTÔNIO PEDRO SOUZA DE OLIVEIRA. DOAÇÃO',
    'COMPRA DEBITO NACIONAL - AUTO POSTO NOVO BUTANT-SAO PAULO-BRA',
    'Transferência/TED - Banco - 237 - Ag - 2096 - Conta - 1830082-6 - DAVID FERREIRA',
    'COMPRA DEB NACIONAL STD',
    'COMPRA DEBITO NACIONAL - AEROMIX -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MINIMERCADO LJ 5224 -SAO PAULO-BRA',
    'DOC C RECEBIDO - Banco remet: 341Conta remet: 0000000357186Doc remet: 13854786000156',
    'Mercado',
    'PGTO BOLETO DIVERSOS - #G suíte Google',
    'COMPRA DEBITO NACIONAL - PAO DE ACUCAR LJ 01 -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CLEYTON DE JESUS RIBEI-SAO PAULO-BRA',
    'DOC C RECEBIDO - Banco remet: 237Conta remet: 0000000150029Doc remet: 06344443000186',
    'COMPRA DEBITO NACIONAL - ROLDAO CAMPO LIMPO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - URSULAO PIZZARIA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CONVE VALE DAS VIRTUDE-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - NEI CABELEIREIRO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - GIKANY TRANSPORTE E DI-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*DUHBURGERS -SAO PAULO-BRA',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 11/2019',
    'Despesa pessoal',
    'COMPRA DEBITO NACIONAL - ACOUGUE NOVA METRO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*CARLINHOSMERC -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 2949 - Conta - 8846-8 - DANIELA G TODELO. Mascara de proteção',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 12/2019',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 01/2020',
    'COMPRA DEBITO NACIONAL - CARREFOUR 358 SBK -SAO PAULO-BRA',
    'CREDITO RECEBIVEIS ANT',
    'COMPRA DEBITO NACIONAL - MC DONALDS AJD -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - SITIO VERDE -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - ARINELLA IMIGRANTES -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - DROG SAO PAULO 511 -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*BjBelaCintra -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - POSTO COMERCIO GAS E C-SAO PAULO-BRA',
    'Revestimentos da parede cozinha + argamassa + rejunte',
    'COMPRA DEBITO NACIONAL - CASA BLANCA DO MORUMBI-SAO PAULO-BRA',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 03/2020',
    'TED RECEBIDA - <5876012000106> - <PBTECH COM. E SERVICOS DE REVE>',
    'Recibo de compra de créditos para plataforma on line de orçamentos',
    'Anúncios Google',
    'D 26,00 Dolares - Compra de um layout para o sistema',
    'PGTO BOLETO DIVERSOS - #Havan - lançar como pró-labore',
    'Transferência/TED - Banco - 341 - Ag - 2949 - Conta - 8846-8 - Daniela G Toledo. Compra de Mascaras proteção equipe',
    'Referente ao mês de março',
    'COMPRA DEBITO NACIONAL - MADERO WASHINGTON LUIS-SAO PAULO-BRA',
    'Contabilidade',
    'COMPRA DEBITO NACIONAL - FLOR DE COIMBRA -SAO PAULO-BRA',
    'PGTO BOLETO DIVERSOS - #Cartão de crédito pro labore',
    'Transferência/TED - Banco - 290 - Ag - 1 - Conta - 2091293-7 - EDIMAR RENATO SANTOS BARROS',
    'Transferência/TED - Banco - 260 - Ag - 1 - Conta - 3498920-1 - Felipe Machado Teotnio',
    'Valor doação cesta básica',
    'Transferência/TED - Banco - 260 - Ag - 1 - Conta - 4460973-5 - Gabriel Queiroz do Nascimento',
    'COMPRA DEBITO NACIONAL - PET SHOP RACA FORTE -SAO PAULO-BRA',
    'Transferência/TED - Banco - 422 - Ag - 3 - Conta - 582435-2 - Renew Decor Comércio e serv de móve. Compra mercadoria marcenaria cliente Denis, pago em Ted 196,00 mais 3400,00 em espécie',
    'Despesa com portador retirada de documentos contabilidade',
    'Transferência/TED - Banco - 104 - Ag - 1573 - Conta - 15734769-0 - Josemar Joaquim de Souza',
    'Transferência/TED - Banco - 341 - Ag - 912 - Conta - 2624-2 - LEO MADEIRAS MÁQUINAS E FERRAGENS',
    'COMPRA DEBITO NACIONAL - PAG*AntonioJosePereir -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAG*AdailtonFigueredo -SAO BERNARDO-BRA',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 04/2020',
    'COMPRA DEBITO NACIONAL - CACAU SHOW THE SQUARE -COTIA-BRA',
    'COMPRA DEBITO NACIONAL - LUCCI BABY IMPORTADOS -VARGEM GRANDE-BRA',
    'Depósito Marcos',
    'Diária',
    'COMPRA DEBITO NACIONAL - TELHA NORTE -SAO PAULO-BRA',
    'Padroeira Interna',
    'COMPRA DEBITO NACIONAL - IMPRIMAGEM SERVICOS LT-SAO PAULO-BRA',
    'Quitação de débito, um dos débitos lançados com valor de 1.000,00 pagando 200,00',
    'Raposo Externa',
    'COMPRA DEBITO NACIONAL - PAG*Mozec -SAO PAULO-BRA - Obras consultório e Denis',
    'COMPRA DEBITO NACIONAL - DROGARIA SAO PAULO -SAO PAULO-BRA - MASCARAS',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN MORUMBI -SAO PAULO-BRA',
    'ESTORNO COMPRA NACIONAL - NEI CABELEIREIRO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - FLYING SUSHI -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PAVONE PIZZARIA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - BANCA ELITE - REVISTAS-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - AUTO POSTO CARLU -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - ELITE FLORES -SAO PAULO-BRA',
    'Transferência/TED - Banco - 237 - Ag - 2096 - Conta - 8632886-0 - NEI GILVAN STULP',
    'Despesa com camisetas pra uniforme equipe Wg Almeida',
    'Transferência/TED - Banco - 341 - Ag - 1003 - Conta - 26221-7 - MARCELO BATISTA LIMA',
    'Transferência/TED - Banco - 341 - Ag - 9340 - Conta - 12800-9 - SILVIA FERRAGENS FERRAMENTAS E LAMI',
    'PGTO BOLETO DIVERSOS - #Havan - Pessoal',
    'COMPRA DEBITO NACIONAL - PORTAL DO MORUMBI SERV-SAO PAULO-BRA',
    'PGTO BOLETO DIVERSOS - #financeiro',
    'Transferência/TED - Banco - 341 - Ag - 7867 - Conta - 29970-8 - ÁLVARO LUCIO FERREIRA',
    'Despesa portador transporte de camisetas par uniforme compra feita na Magic e enviada para Keyborder bordados, vão bordar o logo',
    'COMPRA DEBITO NACIONAL - PORTAL DO MORUMBI SERV-SAO PAULO-BRA - ABASTECIMENTO',
    'COMPRA DEBITO NACIONAL - DROGASIL -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - JESSICA CARMO SILVA -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 192 - Conta - 10557-5 - WG ARQUITETURA',
    'Transferência entre contas Original - Ag - 0001 Conta - 9827587 - WILLIAM GOMES DE ALMEIDA - Comen',
    'PGTO BOLETO DIVERSOS - #cartão de crédito',
    'Transferência/TED - Banco - 237 - Ag - 2764 - Conta - 6764-4 - ARIEL BISPO TEIXEIRA',
    'Transferência/TED - Banco - 237 - Ag - 504 - Conta - 654-8 - SIMONE FERREIRA DAS NEVES',
    'Transferência/TED - Banco - 237 - Ag - 95 - Conta - 2040-0 - Daniele Kelli Lima Vicente Pagar impostos',
    'LIQ/AMORT SDO DEVEDOR',
    'Funilaria',
    'Lançamento importado',
    'Despesa com portador para pegar camisetas uniforme levar para obra',
    'PGTO BOLETO DIVERSOS - #Domínio Arq.br',
    'Despesa marketing agência Hode',
    'Transferência/TED - Banco - 260 - Ag - 1 - Conta - 3498920-1 - Felipe Machado TeotONIO',
    'COMPRA DEBITO NACIONAL - PAG*WagnerSouzaSantos -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - FUNCHAL -SAO PAULO-BRA',
    'Campanha de marketing',
    'Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 13002458-9 - gikany transp e distr de hortifru',
    'COMPRA DEBITO NACIONAL - KITAGAWA SUSHI RES. E -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PESADA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - AUTO POSTO NEMO LTDA -SAO PAULO-BRA',
    'Transferência/TED - Banco - 237 - Ag - 127 - Conta - 38084-9 - Salvapro Soluções em proteção LT',
    'Transferência/TED - Banco - 104 - Ag - 4026 - Conta - 29077-8 - Gerardo Lima Aguiar',
    'DOC C RECEBIDO - Banco remet: 237Conta remet: 0000000295027Doc remet: 32621992811',
    'Recebimento de comissão',
    'Obra',
    'Material',
    'TED RECEBIDA - <14540890000139> - <W G A DESIGNER INTERIORES ME>',
    'PAGAMENTO DE CONTA - INSS PARCELAMENTO',
    'Pagamento de dívida antiga.',
    'Cartão pré pago.',
    'Compra de créditos aplicativo de captação de clientes',
    'COMPRA DEBITO NACIONAL - TEMAKERIA PAULISTA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CENTRO AUTOMOTIVO MOSC-SAO PAULO-BRA',
    'Prestação de serviço na cliente Ananda',
    'TED RECEBIDA - ANANDA MARIA DE SOUZA BARROS - 0000006773000002 -',
    'PGTO BOLETO DIVERSOS - #Cartão de crédito',
    'Visita em obra',
    'Visitação de obra ( despesa da empresa )',
    'Manutenção de bicicleta',
    'Despesa arquiteta Nayara, para medição de uma cliente',
    'COMPRA DEBITO NACIONAL - CHA ST ANTONIO MANOELI-SAO PAULO-BRA',
    'Retirada e entrega de mostruário de piso vinílico e laminado',
    'PAGAMENTO DE CONTA - RECEITA FEDERAL DARF',
    'Transferência/TED - Banco - 33 - Ag - 3553 - Conta - 1007187-0 - Paulo Eduardo de Carvalho tauro',
    'DESPESA GERAL EMPRESA',
    'ESTORNO COMPRA DE CIMENTO FEITO NO DIA 30/06',
    'COMPRA DEBITO NACIONAL - PORTO ALEGRE COMERCIO -SAO PAULO-BRA',
    'Café da MANHA reunião jurídica',
    'Transferência/TED - Banco - 341 - Ag - 4091 - Conta - 22280-4 - DANIELA SUTTO',
    'RECEB DE TED DEVOLVIDA - LONGTECH TECNOLOGIA DA INFORMAÇÃO - 2 - Agencia ou Conta Destinataria do',
    'Transferência/TED - Banco - 341 - Ag - 6855 - Conta - 99887-5 - AGROTTHA PISOS E DECORACOES LTDA',
    'BPO - Entrada 50%',
    'IT - Entrada 50%',
    'Combustivel',
    'Uniforme',
    'SAQUE BCO 24HORAS - 00052252-20200707201819',
    'Pagamento de dívida antiga com maquininha GETNET',
    'COMPRA DEBITO NACIONAL - PAG*Compra -SAO PAULO-BRA',
    'Transferência/TED - Banco - 336 - Ag - 1 - Conta - 985178-0 - WILLIAM GOMES DE ALMEIDA',
    'TED RECEBIDA - <31253473862> - <RAFAEL TELES>',
    'BPO - 1/5',
    'Transporte dos uniformes',
    'PGTO BOLETO DIVERSOS - #Registro domínio Wg',
    'Bordados camisetas uniforme',
    'PGTO BOLETO DIVERSOS - #acordo Itaú Divida Antiga paga',
    'Cheques',
    'Materiais de escritório',
    'Café empresa',
    'CXE 000036 DEP CHQ',
    'TEC DEP CHEQUE',
    'DEPOSITO CHQ DEVOL COMPE - insuficiencia de fundos - 1a apresentacao',
    'CXE 000037 DEP CHQ',
    'TAR CONTA CERTA 06/20',
    'SAQUE BCO 24HORAS - 00045228-20200720133953',
    'Almoço COMPRA DEBITO NACIONAL - FLOR DO MORUMBI -SAO PAULO-BRA',
    'Ferramentas - descontar do Leandro',
    'RECEB DE TED DEVOLVIDA - JOSÉ MIGUEL ROSA DA SILVA - 2 - Agencia ou Conta Destinataria do Credito I',
    'Empreitada mão de obra Galpão',
    'Almoço - visita fornecedor',
    'DEPOSITO CHQ MOBILE - 341809800181070855481751217118',
    'Hidráulica',
    'Demolição e retirada de entulho',
    'Concerto do ar condicionado cliente Dirce Cocuzzi',
    'DEPOSITO CHQ DEVOL COMPE - insuficiencia de fundos - 2a apresentacao',
    'INT TED D 326204',
    'Transferência/TED - Banco - 748 - Ag - 2602 - Conta - 33393-0 - LONGTECH TECNOLOGIA DA INFORMAÇÃO',
    'PGTO BOLETO DIVERSOS - Banco - 237',
    'Jarra de café pra cafeteira da obra',
    'Chocolate para equipe',
    'Celular comprado pro pintor Ailton',
    'Ferramentas',
    'Doação Transferência entre contas Original - Ag - 0001 Conta - 14939630 - ALESSANDRA STOCHI',
    'PAGTO DARF CONV PROPRIO - DARF IRPJ',
    'COMPRA DEBITO NACIONAL - HOJE HORTIFRUTI -SAO PAULO-BRA',
    'PAGTO DARF CONV PROPRIO - Darf 2372',
    'COMPRA DEBITO NACIONAL - NOVO PARE -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - POSTO DE SERVICOS SANT-SAO PAULO-BRA',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 06/2020',
    'Ferramenta',
    'COMPRA DEBITO NACIONAL - TEMAKERIA FRY MORUMBI -SAO PAULO-BRA',
    'COMPRA DEB NACIONAL STD - PAG*MateusCandidoDe -SAO PAULO-BRA',
    'DEPOSITO CHQ MOBILE - 033018720180017655653130309379',
    'DEP CHQ MOB ESTORNADO BCO - 033018720180017655653130309379',
    'PGTO BOLETO DIVERSOS - #Rrt da obra Monica',
    'Transferência/TED - Banco - 237 - Ag - 499 - Conta - 163521-2 - JORGE LUIZ SILVA',
    'COMPRA DEBITO NACIONAL - ROMAFER COMERCIO -SAO PAULO-BRA',
    'DEPOSITO CHQ MOBILE - 033154650180011435263130006826',
    'DEPOSITO CHQ MOBILE - 237222110180137875829701984048',
    'DEPOSITO CHQ MOBILE - 237030670180053575960702302435',
    'DEPOSITO CHQ MOBILE - 341070930180021685401450379647',
    'DEPOSITO CHQ MOBILE - 237052430180017985791671045457',
    'DEPOSITO CHQ MOBILE - 748526780180033445400000313858',
    'DEPOSITO CHQ MOBILE - 001029540188504095487013705964',
    'DEPOSITO CHQ MOBILE - 237264670180031545614201619856',
    'DEPOSITO CHQ MOBILE - 748509000180013535000001196377',
    'DEPOSITO CHQ MOBILE - 003003566990173595084107114963',
    'almoço',
    'PACOTE ORIGINAL EMPRESAS ILIMITADO - Referente a 08/2020',
    'DEP CHQ MOB ESTORNADO BCO - 237264670180031545614201619856',
    'DEP CHQ MOB ESTORNADO BCO - 003003566990173595084107114963',
    'DEP CHQ MOB ESTORNADO BCO - 748526780180033445400000313858',
    'DEP CHQ MOB ESTORNADO BCO - 237030670180053575960702302435',
    'TED RECEBIDA - <31360063803> - <DANIELE KELLI LIMA VICENTE>',
    'DEP CHQ MOB ESTORNADO BCO - 237222110180137875829701984048',
    'DEP CHQ MOB ESTORNADO BCO - 748509000180013535000001196377',
    'DEP CHQ MOB ESTORNADO BCO - 237052430180017985791671045457',
    'DEP CHQ MOB ESTORNADO BCO - 341070930180021685401450379647',
    'DEP CHQ MOB ESTORNADO BCO - 033154650180011435263130006826',
    'COMPRA DEBITO NACIONAL - BANCA ELITE - REVISTAS-SAO PAULO-BRA (CAFÉ)',
    'COMPRA DEBITO NACIONAL - FROGPAY*DIGIMAGEM716 -SAO PAULO-BRA',
    'ESTORNO COMPRA NACIONAL - CONVE VALE DAS VIRTUDE-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MC DONALDS EMB -EMBU DAS ARTE-BRA',
    'COMPRA DEBITO NACIONAL - BOA PRACA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - SEVERINO RAMOS DO NASC-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CANTINHO DO CHURRASCO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - BANCA EL -SAO PAULO-BRA',
    'CREDITO RECEBIVEIS CRE',
    'Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - ailton silva da conceicao',
    'Transferência/TED - Banco - 237 - Ag - 95 - Conta - 2040-0 - Daniele Kelli Lima Vicente',
    'COMPRA DEBITO NACIONAL - LCN COMERCIO -SAO PAULO-BRA CONCERTO DE ASPIRADOR DE PÓ PARA OBRAS E COMPRA DE SACOS PARA ASPIRADOR',
    'COMPRA DEBITO NACIONAL - LinxPay*AUTO POSTO DUQ-SAO PAULO-BRA',
    'TED RECEBIDA - <2839422662> - <REGIS BUZETTI PEREIRA MELGACO>',
    'Acordo Judicial Ricardo e sabr',
    'CHOCOLATE EQUIPE.',
    'Transferência/TED - Banco - 341 - Ag - 1145 - Conta - 13128-8 - ANTÔNIO PEDRO SOUZA DE OLIVEIRA',
    'Transferência/TED - Banco - 290 - Ag - 1 - Conta - 5380095-9 - ANTONIO EDVALDO DE OLVEIRA COMERCIO',
    'RECEB DE TED DEVOLVIDA - Rodrigo Aparecido Luiz Lopes - 3 - Ausencia ou Divergencia na Indicacao do',
    'Pagando dívida antiga em aberto',
    'visita nova marcenaria',
    'Transferência/TED - Banco - 341 - Ag - 8160 - Conta - 36042-9 - RODRIGO AUGUSTO SANCHES DE MELLO',
    'Material escritório',
    'PAGTO DARF CONV PROPRIO - DARF PRETO',
    'Transferência/TED - Banco - 341 - Ag - 2978 - Conta - 6580-9 - FRANCISCO LAURO DA ROCHA MOREIRA',
    'Transferência/TED - Banco - 1 - Ag - 7021 - Conta - 895-8 - LEANDRO REIS ALVES',
    'Chocolate equipe da obra.',
    'COMPRA DEBITO NACIONAL - PAG*Joaodemattosreis -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - HORTIFRUTI JWS -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MERCADO LIDIA -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - PETZ MORUMBI -SAO PAULO-BRA',
    'Café da manha',
    'COMPRA DEBITO NACIONAL - STATUS DO PANAMBY -SAO PAULO-BRA',
    'ferramentas empresa',
    'Ferramentas para a empresa',
    'Transferência/TED - Banco - 341 - Ag - 1661 - Conta - 35155-9 - EUCER COMERCIO E SERVIÇOS DE PISOS',
    'TED RECEBIDA - <5329169801> - <JOAO CARLOS FERREIRA DA SILVA>',
    'Transferência/TED - Banco - 341 - Ag - 1663 - Conta - 16160-0 - GILBERTO AFONSO PERIN',
    'COMPRA DEBITO NACIONAL - FERRAMENTAS&ACESSORIOS-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - 10 TABELIAO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - CONFIANCA PARK ESTACIO-SAO PAULO-BRA',
    'Transferência/TED - Banco - 237 - Ag - 619 - Conta - 3334-0 - ERIC ROCHA SANTOS',
    'COMPRA DEBITO NACIONAL - SODIMAC -BARUERI-BRA',
    'COMPRA DEBITO NACIONAL - PAG*CafeteriaAlphavil -BARUERI-BRA',
    'COMPRA DEBITO NACIONAL - ALPHA CENTER SERVICOS -BARUERI-BRA',
    'TED RECEBIDA - <3390128000105> - <LUMEN IT TECN INFORMACAO LTDA>',
    'COMPRA DEBITO NACIONAL - SERRARIA CANELAO -BARUERI-BRA',
    'COMPRA DEBITO NACIONAL - ANDREZA PAULA DA SILVA-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LOJAS RENNER FL 43 -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - G- TEACH COMERCIO DE A-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - KOMFORT HOUSE SOFAS -SAO PAULO-BRA',
    'PGTO BOLETO DIVERSOS - #Obra 202 a',
    'COMPRA DEBITO NACIONAL - ZARA-MORUMBI -SAO PAULO-BRA',
    'Transferência/TED - Banco - 1 - Ag - 7005 - Conta - 6000-3 - JOSÉ EDMILSON PEREIRA',
    'Transferência/TED - Banco - 341 - Ag - 4299 - Conta - 51207-1 - RODRIGO APARECIDO LUIZ LOPES',
    'Transferência/TED - Banco - 237 - Ag - 104 - Conta - 1012405-0 - WILLIAN ARAÚJO CORREA',
    'PGTO BOLETO DIVERSOS - #novo usuário conta Google',
    'Transferência/TED - Banco - 341 - Ag - 8751 - Conta - 19259-5 - LUFANA ESTEUTURAS METÁLICAS',
    'IT - 1/5',
    'BPO - 3/5',
    'BPO - 2/5',
    'IT - 3/5',
    'IT - 2/5',
    'Pendente - valores a serem acertados',
    'Pagar para terceiro',
    'BPO - 4/5',
    'IT - 4/5',
    'IT - 5/5',
    'BPO - 5/5'
  );

-- Mate Doce (3 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Mate Doce') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Loud Áudio',
    'Cabo Blindado',
    'Mão de Obra Fabio'
  );

-- Sasha e Livia (9 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Sasha e Livia') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Montagem',
    'Despesa',
    'Marcenaria',
    'Puxadores',
    'Dormitório Theo',
    'Dormitório Serviço'
  );

-- Favorita Pompeia (4 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Favorita Pompeia') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    '-',
    'Reparo Gesso',
    'Pintor 1 de 2',
    '1 pagamento'
  );

-- Davi Beck e Fabiana (45 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Davi Beck e Fabiana') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Material',
    'Prestação de Serviços',
    'Painéis',
    'Ar Condicionado',
    'Entrada',
    'Laudo e ART',
    'Material Alvenaria',
    'Romaneio',
    'Materiais Diversos',
    'Frete pisos',
    'Piso',
    'Material de solda',
    'Gesso',
    'Arandela p/ alto falante',
    'Compra',
    'Ferramentas',
    'Material de tubulação',
    'Lampadas e material',
    'Silicone p/ churrasqueira',
    'Nipel Rosca',
    'Pregos e parafuso',
    'Lixa p/ maq. Lixadeira',
    'Esmalte s, Verniz e Cola',
    'Regua pinus',
    'Tinta, Rolo e trincha',
    'Tinta'
  );

-- Favorita Panamby (4 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Favorita Panamby') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    '1 pagamento',
    '2 pagamento',
    '3 pagamento',
    '4 pagamento'
  );

-- Fernando Cunha (2 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Fernando Cunha') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    '1 pagamento',
    'Documentação'
  );

-- André e Flávia (2 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('André e Flávia') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Pagamento William',
    'Start'
  );

-- Roberto Grejo (130 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Roberto Grejo') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Gesseiro',
    'taxa cau rrt',
    'Entrada',
    'Crédito RRT',
    'Pagamento 1',
    'Emissão RRT',
    'Material Conta Empresa',
    'Material Conta Cliente',
    'Caçamba Solicitada',
    '2 Parcela',
    'Eletricista',
    'Caixa Luz 4x4 + Mascara',
    'Estopa + Caixa Luz 4x4',
    'Conduite',
    'Uber',
    'Parafusos e Fios',
    'Fita Isolante',
    'Material',
    'Pagamento 2',
    '3 Parcela',
    'Pagamento 3',
    '4 Parcela',
    'Material Ar Condicionado',
    '5 Parcela',
    'Recolha Gás do Ar',
    'Gesseiro Eduardo',
    'Pagamento 4',
    'OBRA ROBERTO GREJO',
    '6 Parcela',
    'Material obra Roberto Grejo solicitar reembolso.',
    'Despesa Josemar extras obra Roberto.',
    'Forma.',
    'COMPRA MATERIAL OBRA ROBERTO GREJO – PEDIR REEMBOLSO',
    'Coordenador de obra',
    'TED RECEBIDA - <19377223849> - <ROBERTO GREJO>',
    '7 Parcela',
    'Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 1023720-3 - Josemar Joaquim de Souza',
    'Elétrica',
    'Roberto Grejo',
    'Disco Porcelanato',
    'Obra Mooca compra de material pedir reembolso',
    'Cliente Roberto',
    'montagem banheiros',
    'Davi Montador',
    'pintura',
    'porta entrada e pontos',
    'Transporte',
    'Montagem banheiros',
    'Pedreiro',
    'Porta entrada e pontos',
    'Pintura',
    '-',
    'GESSO',
    'Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA. Pedreiro obra Casa 150,00 + Consultorio 560,00 + Obra Mooca 330,00',
    'Transferência/TED - Banco - 237 - Ag - 504 - Conta - 654-8 - SIMONE FERREIRA DAS NEVES. 540,00 despesa pintura consultorio + 270,00 despesa obra Mooca',
    '8 Parcela',
    'Obra Mooca',
    'Transferência/TED - Banco - 104 - Ag - 4557 - Conta - 292-0 - GESSO JUREMA LTDA',
    'Pintor Obra Mooca',
    'Diversos',
    'Crédito',
    'Transferência/TED - Banco - 104 - Ag - 1573 - Conta - 15734769-0 - Josemar Joaquim de Souza',
    'Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - Aiton silva da CONCEIÇÃO',
    'Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA',
    'COMPRA DEBITO NACIONAL - GRANO MOOCA -SAO PAULO-BRA',
    'Obra Mário colocar tomadas',
    'DOC C RECEBIDO - Banco remet: 341Conta remet: 0000000617168Doc remet: 13557296881',
    'Toninho pintor - Obra Mooca',
    'Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'Pintor Ailton - Obra mooca',
    'Pintor',
    'Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - ailton silva da conceicao',
    'Transferência/TED - Banco - 237 - Ag - 1831 - Conta - 500210-9 - JOSÉ MOREIRA SAMPAIO',
    'Pagamento para o Ailton feito na conta da esposa dele.',
    'Comissão',
    'Final da obra Mooca',
    'Água',
    'Transferência/TED - Banco - 260 - Ag - 1 - Conta - 73676392-8 - VANESSA',
    'Azulejista',
    'Segunda parcela',
    'Primeira parcela'
  );

-- Time's Burger e Sueli (9 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Time''s Burger e Sueli') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Lançamento importado',
    'Visita in Loco Nayara',
    'Nayara complementar',
    '2 pagamento',
    '3 pagamento',
    'Nayara',
    '1 pagamento',
    'Projeto'
  );

-- Bruna Spezia (24 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Bruna Spezia') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Cano e Areia',
    'Cano e ralo (nota perdida)',
    '3 Curva Azul + 15 sacos de Entulho',
    'Tubo marron de 1/2 Dreno',
    'Crédito para compra de material',
    'Luva, Redução Caixa 4x2',
    'Segundo Pagamento',
    'Segunda Parcela 30%',
    'Entrada 30%',
    'Primeiro Pagamento',
    'Compra Aparador',
    'Extras Obra',
    'Compra de Mateiral',
    'Extras e Molduras Gesseiro',
    'Pagamento Final',
    'Terceira Parcela',
    'Compra de Material',
    'Quarta Parcela',
    'Retirada Entulho',
    'Pintor Cimento Queimado',
    'Quinta parcela final (sem datas)'
  );

-- Reinaldo (4 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Reinaldo') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Projeto',
    'Comissão captação 10%',
    'Projeto arquitetônico'
  );

-- Michele Caldeira (53 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Michele Caldeira') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Pagamento 1',
    'Emissão de RRT Obra',
    'Plotagem Plantas - Debito',
    'Entrada Josemar',
    'Compra material',
    '2 parcela',
    'Pagamento 2',
    'Pagamento 4',
    '3 parcela',
    'Pagamento 3',
    'Gesso Cozinha',
    'Aporte Mão de Obra',
    '5 parcela',
    'Retirada Entulho',
    'Gesso Cortineiros e Shaft',
    '6 parcela',
    'Alteração de Registro',
    'Pagamento 5',
    '7 parcela',
    'Frete Porta',
    'Locação de Andaime',
    'Instalação do Rodapé',
    '8 parcela',
    'Pagamento 6',
    'Hall de Entrada',
    'Registro Gás Valvula e Flexivel',
    'Conversão Fogão',
    'Frete e Içamento e Subida Escada',
    'Nepli Redução Lava Roupas',
    'Uber - Retirada Lustre Ida E Volta',
    'Instação de Acessórios',
    'Frete das Cadeiras',
    'Pintura teto Hall e Retoque',
    'Retirada Entulho 01/11',
    '-',
    'Limpeza Armários',
    '9 parcela',
    'Vadação Bacia Sanitária',
    'Diversos',
    'Piso Hall e Pintura'
  );

-- Casa (66 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Casa') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Poste Areia Caixa Agua e Luz',
    'Material Obra',
    '1 Cimento e 10 areias',
    'Material',
    'Arame',
    'Cimento, Coluna',
    'Cimento',
    'Compra De Material',
    'Areia Cano e Prego',
    'Torneira',
    'Pontalete e Tabua',
    'Conduite, Espuma',
    'Mão de obra - Pedreiro',
    'Cimento, Bloco, Areia e Pedra',
    '2 sacos de pedra',
    '1/2 Areia Bianco Cano',
    'Caçamba Entulho',
    '1 de 2 Portão',
    'Areia Fina Luva T e Cotovelo',
    'Areia e Conduite',
    'Cimento Votoran',
    'parafuso abraçadeira porca',
    'bengala PVC',
    'Caixa 4X4',
    'Tijolo Bloco 3 Areia + 1/2 areia',
    'Fios 10mm + Espuma',
    'Prego 18X27',
    'Prego 13X12',
    'Tubulação ar',
    'Fiação e Disjuntor',
    'Materia Elétrica',
    '2 de 2 Portão',
    'locação de andaime',
    'Mangueira - Porta Papel',
    'Disjuntor e Resistencia',
    'Modulo Ponto Ativo Wifi Portão',
    'Obra casa',
    'Material obra da Casa',
    'Material obra da casa',
    'Material Elétrica',
    'Transferência/TED - Banco - 237 - Ag - 504 - Conta - 654-8 - SIMONE FERREIRA DAS NEVES Pintor Toninho',
    'Vitorio Pedreitro',
    'Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA',
    'Pedreiro',
    'Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA. Pedreiro obra Casa 150,00 + Consultorio 560,00 + Obra Mooca 330,00',
    'Transferência/TED - Banco - 341 - Ag - 7660 - Conta - 27262-1 - ANDAIMES GAZA LTDA',
    'Transferência/TED - Banco - 341 - Ag - 3753 - Conta - 19858-3 - LUIS FERNANDO DI GEROLAMO FANGEN',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 1661 - Conta - 35155-9 - EUCER COMERCIO E SERVIÇOS DE PISOS',
    'COMPRA DEBITO NACIONAL - JAU MATERIAS -SAO PAULO-BRA'
  );

-- Consultório Dra. Thais (178 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Consultório Dra. Thais') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Gesso',
    'Compras feitas pelo cliente',
    'Mão de Obra Civil',
    'Entrada pagamento 1 de 3 Romaneio',
    'Aparelhos de Ar Condicionado Cliente',
    'Comissão Girlana Captadora 5300',
    'Vassoura e Pá',
    'Abastecimento carro Josemar',
    '-',
    'Plotagem Projeto',
    'Entrada pagamento 2 de 3 Romaneio',
    'Material Ar',
    'Designer da Marca R$ 2000',
    'Gesseiro',
    'Layout Marcenaria',
    'Entrada pagamento 3 de 3 Romaneio',
    'Broca Aço',
    'Tubulação Ar Condicionado',
    'Projeto Consultório',
    'Mão de obra Infra de Ar e Instalação R$ 1200',
    'Conexões tubo cobre',
    'Parcela 4 Romaneio',
    'Marmoraria R$ 8000',
    'Pintura R$ 2400',
    'Massa Corrida e Tinta',
    'Eletricista R$ 1000',
    'Massa Corrida',
    'Fios, Disjuntor, Fita Isolante e +',
    'Disjuntores e Tomadas',
    'Fio 10mm conector',
    'Tomadas',
    'Luminárias Emergência',
    'Marcenaria $ 15.000,00',
    'Fios 16mm',
    'RECEITA OBRA CONSULTORIO',
    'Taxa',
    'entrega marcenaria',
    'Mão de Obra Instalçao + 1 Maquina',
    'Desinfetante e pano obra consultório.',
    'Despesa almoço obra consultório.',
    'Almoço obra consultório.',
    'DESPESA OBRA CONSULTÓRIO',
    'Forma.',
    'Alimentação',
    'Transferência/TED - Banco - 33 - Ag - 3719 - Conta - 1096215-2 - ROSSANA BATISTA',
    'Estacionamento',
    'Transferência/TED - Banco - 237 - Ag - 3541 - Conta - 440800-4 - Fabio Fraga de Oliveira - Frete Cadeira',
    'Pago motorista',
    'Material',
    'Pagamento Motorista Cicero',
    'Motorista Cícero',
    'TED RECEBIDA - <5701330842> - <ELIEL FERNANDES DA SILVA>',
    'Marcenaria $ 15.000,00 Parcela final debitado de um crédito de 3K',
    'Transferência/TED - Banco - 237 - Ag - 2883 - Conta - 310341-2 - JOBER SANTO DIAS',
    'Colocar as peças',
    'Refazer tubulações',
    'Pintura',
    'Transferência/TED - Banco - 341 - Ag - 7681 - Conta - 5267-1 - DEIBIS DE ALMEIDA',
    'Arrancar pedras',
    'Não entraram na obra',
    'Motorista para obra Consultório',
    'Transferência/TED - Banco - 237 - Ag - 504 - Conta - 654-8 - SIMONE FERREIRA DAS NEVES. 540,00 despesa pintura consultorio + 270,00 despesa obra Mooca',
    'Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA. Pedreiro obra Casa 150,00 + Consultorio 560,00 + Obra Mooca 330,00',
    'COMPRA DEBITO NACIONAL - MARACA ELETRICA HIDRAU-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - COMERCIAL DE COMBUSTIV-SAO PAULO-BRA',
    'Transferência/TED - Banco - 33 - Ag - 1634 - Conta - 1023720-3 - Josemar Joaquim de Souza',
    'Ida e Volta',
    'Pagamento Eliel',
    'Uber',
    'Transferência/TED - Banco - 341 - Ag - 3130 - Conta - 49369-9 - JOSE RAI DOS SANTOS PEREIRA',
    'Crédito em conta',
    'Venda de vários itens.',
    'PGTO BOLETO DIVERSOS - #Compra quadros consultório',
    'Compra feita pelo Cartão de Credito - Obra Consultório',
    'Transferência/TED - Banco - 33 - Ag - 731 - Conta - 13001307-2 - NOVA COMVEL - ESPELHO',
    'Transferência/TED - Banco - 341 - Ag - 4055 - Conta - 17962-8 - JOSÉ ANTÔNIO DE BELLO - SISTEMA DE SOM',
    'Despesa com portador para retirada e entrega de equipamento de som.',
    'Transferência/TED - Banco - 104 - Ag - 4072 - Conta - 35751-6 - Marcos Antonio S Pereira',
    'Compra sofá consultório com paulo tapeceiro da tapeçaria engenho arte. Parcela 1 de 2',
    'COMPRA DEBITO NACIONAL - POSTO PARQUE ARARIBA -SAO PAULO-BRA',
    'Transporte',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 207 - Conta - 17221-4 - IMD COMERCIO DE MÓVEIS LTDA Compra de cadeiras para consultório',
    'Transferência/TED - Banco - 104 - Ag - 4092 - Conta - 22065-6 - Renato de Assis Batista',
    'Transferência/TED - Banco - 104 - Ag - 1367 - Conta - 32017-0 - Vera Lucia Miranda De Brito Andr',
    'COMPRA DEBITO NACIONAL - OMTS EMPREENDIMENTOS S-COTIA-BRA',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA. Pedido de reembolso solicitado',
    'Transferência/TED - Banco - 104 - Ag - 4092 - Conta - 22065-6 - Renato de Assis Batista. Material e mão de obra rodapé',
    'COMPRA DEBITO NACIONAL - ASTURIAS AUTO POSTO LT-SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - MARKET GRANJA VIANA -COTIA-BRA',
    'COMPRA DEBITO NACIONAL - PAG*Perfumehinode -CARAPICUIBA-BRA',
    'COMPRA DEBITO NACIONAL - PAG*appmotorista -DIADEMA-BRA',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA - PINTURA',
    'COMPRA DEBITO NACIONAL - PAG*OtavioPaulo -OSASCO-BRA',
    'Material Elétrica',
    'Transferência/TED - Banco - 1 - Ag - 52 - Conta - 116653-0 - ANTÔNIO CARLOS MARTIN',
    'COMPRA DEBITO NACIONAL - GRANPCBN LANCHONETE EI-COTIA-BRA',
    'Compra de puxadores',
    'COMPRA DEBITO NACIONAL - MC DONALDS NFL -SAO PAULO-BRA',
    'Compra sofá parcela 2 de 2',
    'Material Obra',
    'Extras',
    'Parcela final',
    'Mão de Obra Banheiro e Final'
  );

-- Lumen It (61 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Lumen It') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Marcenaria',
    'Extras material',
    'Não tem a data',
    'Obra Lumen It',
    'Transferência/TED - Banco - 237 - Ag - 2883 - Conta - 310341-2 - JOBER SANTO DIAS',
    'Estacionamento mercearia Lumen It',
    'TED RECEBIDA - <3390128000105> - <LUMEN IT TECN INFORMACAO LTDA>',
    'Transporte',
    'Desmontagem',
    'Alimentação',
    'Frete para entrega dos pisos',
    'Instalação',
    'Desmontagem dos vidros da sala antiga',
    'Projeto',
    'Montador de moveis',
    'Mudança e retirada de entulho.',
    'Pagamento para subir os vidros pela escada',
    'INFRA AR',
    'COMPRA DEBITO NACIONAL - ESPACO VILLA LOBOS -SAO PAULO-BRA',
    'Débito',
    'Valor final',
    'Pintor',
    'Eletricista',
    'Material',
    'Gesso',
    'Transferência/TED - Banco - 341 - Ag - 210 - Conta - 5205-6 - WASHINGTON DE SOUZA GAMA',
    'Montador comprou material para obra.',
    'Limpeza',
    'Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'Colocação de piso',
    'Instalação ar',
    'Retirada de entulho - parcela final',
    'Transferência/TED - Banco - 237 - Ag - 2096 - Conta - 1830082-6 - DAVID FERREIRA',
    'Transferência/TED - Banco - 290 - Ag - 1 - Conta - 1280716-0 - PAAULO HENRIQUE SOARES DOS SANTOS',
    'Pintura final',
    'Sem descrição',
    'Reembolso'
  );

-- Rafael Teles (52 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Rafael Teles') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Comissão Captação',
    'pagamento',
    'Projeto Arquitetônico',
    'Adiantamento comissão.',
    'Transferência/TED - Banco - 33 - Ag - 3372 - Conta - 1014580-4 - Girlana Floreno de Sales Silva',
    'Diversos',
    'TED RECEBIDA - <31253473862> - <RAFAEL TELES>',
    'Transferência/TED - Banco - 237 - Ag - 104 - Conta - 1012405-0 - WILLIAN ARAÚJO CORREA',
    'PGTO BOLETO DIVERSOS - #Rrt Rafael execução',
    'COMPRA DEBITO NACIONAL - IMPRIMAGEM SERVICOS LT-SAO PAULO-BRA',
    'Pedir reembolso.',
    'Pedreiro',
    'Sacos de entulho',
    'Captação',
    'Despesa com ar condicionado',
    'Retirada de entulhos',
    'Arquiteta para emissão de Rrt - reembolso',
    'Infra ar condicionado',
    'Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'Material Hidráulica',
    'Retirada de entulho',
    'Gesso',
    'Eletricista',
    'Material',
    'Hidráulica',
    'RAFAEL TELES COMISSÃO RECEBIDA VENDA DE MARMORARIA TED RECEBIDA - <68113372000168>',
    'Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - ailton silva da conceicao',
    'Azulejista',
    '2020-02-01 00:00:00',
    'Transferência/TED - Banco - 104 - Ag - 4557 - Conta - 292-0 - GESSO JUREMA LTDA',
    '2020-02-02 00:00:00',
    'Gesseiro obra monumento Rafael Teles',
    'Extras'
  );

-- Caita (32 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Caita') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Sacos de Entulho',
    'Espaçadores e Cunha Impermeabilizante',
    'Arquiteta - RRT',
    'Assentamento Banhos e Piso Cozinha',
    'Assentamento Parede Cozinha',
    'Obra',
    'Argamassa, veda rosaca e tampão',
    'Massa Corrida Tinta Anel Vedação Silicone Lixas',
    'Material Pintura',
    'Retirada de Entulho - Pago',
    'Bucha e parafuso',
    'Massa Corrida',
    '99 Taxi',
    'Paradusos Massa Corrida Bolsa Bacia Sanitária',
    'Pintura',
    'Uber',
    '300 saldo final da obra do Rodrigo.',
    'TED RECEBIDA - <33112822803> - <RODRIGO CONCEICAO DA SILVA>',
    'Desmontagem Banhos',
    'Desmotagem Cozinha',
    'Montagem Cozinha',
    'Pintura das Portas',
    'Montagem Banhos'
  );

-- José Carlos (7 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('José Carlos') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Instalação Luminárias',
    'Marcenaria Dormitório',
    'Marcenaria',
    'TED RECEBIDA - <86841114272> - <JOSE CARLOS DA SILVA JUNIOR>',
    'Obra'
  );

-- Stephanie Carvalho (4 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Stephanie Carvalho') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Taxa parcelamento',
    'Projeto Arquitetônico',
    '1 de 2 Parcela Projeto',
    'Parcela 2 de 2'
  );

-- Monica Sampaio (101 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Monica Sampaio') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Taxa',
    'Taxa Sumup',
    'Lançamento importado',
    'Arquitetura',
    'Taxa parcelamento',
    '1 de 2',
    'Alimentação',
    'Cliente Monica',
    'Almoço pela empresa! Pode colocar custo obra Monica',
    'Uber',
    'Reunião Piracicaba cliente Monica',
    'Reunião Piracicaba centro de custo Monica',
    'Reunião EM Piracicaba centro de custo Monica',
    'Monica - Piracicaba Despesa - viagem vidraçaria',
    'Piracicaba vidromix ( Monica )',
    'Almoço Monica Piracicaba',
    'Monica - despesa Vidromix Piracicaba',
    '2 de 3',
    'Transferência/TED - Banco - 237 - Ag - 963 - Conta - 565-7 - CRISTIANO GUILHERME NUNES',
    'Medição técnica',
    'PGTO BOLETO DIVERSOS - #Rrt Monica',
    'Alvenaria',
    'Despesa Obra Cliente Monica Sampaio Duo Morumbi',
    'Transferência/TED - Banco - 104 - Ag - 4026 - Conta - 29077-8 - Gerardo Lima Aguiar',
    'Obra',
    'Transferência/TED - Banco - 237 - Ag - 104 - Conta - 1012405-0 - WILLIAN ARAÚJO CORREA',
    'COMPRA DEBITO NACIONAL - MARACA ELETRICA HIDRAU-SAO PAULO-BRA - Pedir reembolso! Sacos de entulho',
    'TED RECEBIDA - <8564559897> - <MONICA SAMPAIO ZACHARIAS> REEMBOLSO',
    'Transferência/TED - Banco - 104 - Ag - 4557 - Conta - 292-0 - GESSO JUREMA LTDA',
    'Transferência/TED - Banco - 341 - Ag - 8160 - Conta - 36042-9 - RODRIGO AUGUSTO SANCHES DE MELLO',
    'Retirada entulho',
    'Transporte',
    'Transferência/TED - Banco - 341 - Ag - 1661 - Conta - 42477-8 - PANORAMA COMERCIO DE MATERIAIS PARA',
    'Eletricista',
    'Transferência/TED - Banco - 237 - Ag - 107 - Conta - 298271-4 - EDNA ARAÚJO',
    'Gesso',
    'Ar condicionado',
    'Compra de cimento',
    'Pedir reembolso',
    'Infra ar condicionado',
    'Projeto',
    'Hidráulica',
    'Pedreiro',
    'Reembolso compra de material Hidráulico',
    'Retirada de entulho',
    'Material para tubulação da infra da adega',
    'Material',
    'Transferência/TED - Banco - 33 - Ag - 3411 - Conta - 60013537-4 - ailton silva da conceicao',
    'Azulejista',
    'Transferência/TED - Banco - 341 - Ag - 6507 - Conta - 26825-5 - Edinaldo Cosme de Arruda',
    'Compra de celular para pintor.',
    'TED RECEBIDA - <8564559897> - <MONICA SAMPAIO ZACHARIAS>',
    'Transferência/TED - Banco - 655 - Ag - 655 - Conta - 3439421-4 - LARISSA MARIA ROSRIGUES BEZERRA',
    'Transferência/TED - Banco - 341 - Ag - 2978 - Conta - 6580-9 - FRANCISCO LAURO DA ROCHA MOREIRA',
    'Transferência/TED - Banco - 341 - Ag - 8751 - Conta - 19259-5 - LUFANA ESTEUTURAS METÁLICAS',
    'Transferência/TED - Banco - 104 - Ag - 4072 - Conta - 35751-6 - Marcos Antonio S Pereira',
    'Locação de andaimes',
    'Gesseiro Obra Monica',
    'Amoço Monica',
    'Pagamento Allan ajudante.',
    '3 de 3',
    'Classificar'
  );

-- Squash (12 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Squash') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Solicitar Reembolso',
    'OBRA SQUASH',
    'Transferência/TED - Banco - 237 - Ag - 2415 - Conta - 36281-6 - EDELSON BRAZ DE LIMA',
    'TED RECEBIDA - <26834611000129> - <SQUASH LIFE QUADRAS POLIESPORTIVAS>',
    'Obra Squash',
    'Obra Squash 99',
    'Almoço equipe O. Squash',
    'Uber',
    'Pedreiro'
  );

-- PORTOBELLO (10 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('PORTOBELLO') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Reunião Aron Portobello.',
    'Despesa obra Portobello',
    'DESPESA - OBRA PORTOBELLO',
    'Desinstalar e instalar armários prestação de serviço para Portobello Shop Morumbi',
    'Diversos',
    'Remoção de armários e colocação',
    'Remoção e colocação de armários',
    'Marcenaria',
    'Prestação de serviço Oficina Portobello',
    'Prestação de serviço pra oficina Portobello'
  );

-- Ronaldo Bueno (Projeto Arquitetonico ) (14 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Ronaldo Bueno (Projeto Arquitetonico )') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Alimentação',
    'Reunião com Cliente Ronaldo',
    'TED RECEBIDA - <10161676871> - <RONALDO BUENO>',
    'Transferência/TED - Banco - 33 - Ag - 3372 - Conta - 1014580-4 - Girlana Floreno de Sales Silva',
    '1 de 4 Projeto Ronaldo',
    'Transferência/TED - Banco - 655 - Ag - 655 - Conta - 3439421-4 - LARISSA MARIA ROSRIGUES BEZERRA',
    'Despesa com arquiteta do projeto',
    'Lançamento importado',
    'Despesa com arquiteta do projeto - parcela final',
    'Projeto',
    'Comissão obra Ronaldo',
    'Diversos'
  );

-- MARIO MARIUTTI (42 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('MARIO MARIUTTI') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'DESPESA OBRA MARIO MARIUTTI',
    'Material obra Mário Mariutti',
    'Despesa ferramentas! Escada obra Mário Mariutti',
    'TED RECEBIDA - <31876629860> - <MARIO L P MARIUTTI>',
    '1500 obra Mário Máriutti.',
    'Transferência/TED - Banco - 237 - Ag - 450 - Conta - 610151-8 - ANTONIO PEREIRA CARVALHO',
    'Transferência/TED - Banco - 77 - Ag - 1 - Conta - 1675914-1 - SÉRGIO LUIZ DOMINGUES',
    'Transferência/TED - Banco - 341 - Ag - 6940 - Conta - 18315-2 - FORMA GLASS VIDROS LTDA',
    'Obra Mário',
    'Café O. Mario: 2',
    'Café O. Mario: 1',
    'Referente almoço obra Mário equipe',
    'Reembolso O. Mário',
    'Café com cliente',
    'Transferência/TED - Banco - 104 - Ag - 263 - Conta - 167612-4 - SUSE MEIRE VILELA',
    'Transferência/TED - Banco - 341 - Ag - 7220 - Conta - 5290-1 - JOSÉ WALDOMIRO RIBEIRO PIRES Redes de proteção',
    'Transferência/TED - Banco - 341 - Ag - 740 - Conta - 11032-5 - DAVI CAETANO DOS SANTOS',
    'Transferência/TED - Banco - 290 - Ag - 1 - Conta - 2593417-5 - Kleber Alessandro cianelli Faustino Luminarias',
    'Transferência/TED - Banco - 341 - Ag - 3130 - Conta - 49369-9 - JOSE RAI DOS SANTOS PEREIRA',
    'Transferência/TED - Banco - 104 - Ag - 4072 - Conta - 35751-6 - Marcos Antonio S Pereira',
    'Prateleira Assistência',
    'Assistência',
    'prateleira asssitência Mário',
    'assitência',
    'Transferência/TED - Banco - 290 - Ag - 1 - Conta - 2593417-5 - KLEBER ALESSANDRO CIANELLI FAUSTINO. Compra de luminárias',
    'DOC C RECEBIDO - Banco remet: 341Conta remet: 0000000357186Doc remet: 13854786000156',
    'Manutenção interfone',
    'Diversos',
    'Transporte',
    'Alimentação',
    'Material'
  );

-- Rubens e Amanda (9 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Rubens e Amanda') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Transferência/TED - Banco - 341 - Ag - 765 - Conta - 25664-9 - EVAL COM DE TINTAS E FERRRAGENS LTD. Pagamento para Forma.',
    'Uber',
    'Referente Almoço O. Rubens',
    'Referente almoço marcenaria Rubens',
    'Marcenaria Rubens e Amanda',
    'Obra Marcenaria Rubens e Amanda',
    'Transferência/TED - Banco - 341 - Ag - 866 - Conta - 34601-8 - Matheus Perez Zorzi Duarte',
    'Despesas Jurídicas'
  );

-- José Ricardo (7 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('José Ricardo') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Material',
    'Transferência/TED - Banco - 104 - Ag - 3009 - Conta - 27187-5 - SANTA FERREIRA DA COSTA',
    'Transferência/TED - Banco - 341 - Ag - 7867 - Conta - 29970-8 - ÁLVARO LUCIO FERREIRA',
    'Marcenaria',
    'MÃO DE OBRA DE FINALIZAÇÃO PAGO AO JOSÉ EDSON SERVIÇOS GERAIS'
  );

-- Consultório (11 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Consultório') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'arrancar pedras',
    'pintura',
    'não entraram na obra',
    'refazer tubulações',
    'motorista para obra Consultório',
    'colocar as peças'
  );

-- Denis Szejnfeld (24 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Denis Szejnfeld') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'luminaria personalizada',
    'Obra',
    'Venda para novo cliente',
    'Liberador Técnico da Marcenaria WG',
    'Transferência/TED - Banco - 104 - Ag - 612 - Conta - 132446-4 - MARCOS VIEIRA ROCHA',
    'Compra mercadoria marcenaria cliente Denis, pago em Ted 196,00 mais 3400,00 em espécie',
    'Transporte',
    'COMPRA DEBITO NACIONAL - PASTELARIA MECTIO -SAO PAULO-BRA. Café despesa Cleinte Denis',
    'PGTO BOLETO DIVERSOS - #leds marcenaria Denis',
    'Material',
    'Despesa cliente Denis - Marcenaria',
    'COMPRA DEBITO NACIONAL - PADARIA MANHATTAN -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - IRACEMA DO BROOKLIN -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - COMPENSADOS LANE -SAO PAULO-BRA',
    'Transferência/TED - Banco - 341 - Ag - 7867 - Conta - 29970-8 - ÁLVARO LUCIO FERREIRA - marceneiro Álvaro',
    'Despesa cliente Denis compra de luminárias como cortesia!',
    'COMPRA DEBITO NACIONAL - LEROY MERLIN RAPOSO -SAO PAULO-BRA',
    'COMPRA DEBITO NACIONAL - LEO MADEIRAS -SAO PAULO-BRA',
    'Retirada móvel cliente Denis',
    'Alimentação'
  );

-- Regis 194 (17 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Regis 194') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Regis Externa',
    'Fotos do projeto do cliente Regis',
    'Entrada',
    'Pedreiro',
    'PGTO BOLETO DIVERSOS - #seguro obra 194 A Regis',
    'COMPRA DEBITO NACIONAL - PAG*Multisolucoes -SAO PAULO-BRA',
    'Material',
    'COMPRA DEBITO NACIONAL - C C GIOVANNI -SAO PAULO-BRA',
    'Descontado do recebimento de 7 mil reais.',
    'Descontado do recebimento de 7 mil reais',
    'COMPRA DEBITO NACIONAL - MARACA ELETRICA HIDRAU-SAO PAULO-BRA',
    'Transferência/TED - Banco - 104 - Ag - 4072 - Conta - 35751-6 - Marcos Antonio S Pereira',
    'Obra'
  );

-- Escritório Woods (1 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Escritório Woods') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Diversos'
  );

-- Pedro Ruiz (22 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Pedro Ruiz') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Transporte',
    'Almoço',
    'Café',
    'Combustivel',
    'COMPRA DEBITO NACIONAL - POSTO COMERCIO GAS E C-SAO PAULO-BRA',
    'Alimentação',
    'PGTO BOLETO DIVERSOS - #Pedro Ruiz 212c',
    'TEC DEP CHEQUE',
    'Transferência/TED - Banco - 104 - Ag - 4026 - Conta - 29077-8 - Gerardo Lima Aguiar',
    'Pedreiro',
    'Transferência/TED - Banco - 104 - Ag - 4072 - Conta - 35751-6 - Marcos Antonio S Pereira',
    'Material',
    'Tubulação material ar condicionado',
    'Eletricista',
    'Gesseiro',
    'Hidráulica'
  );

-- Eduardo Escaleira (10 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Eduardo Escaleira') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Obra',
    'TED RECEBIDA - <22999652895> - <WILLIAN BORGES DA SILVA>',
    'Transferência/TED - Banco - 104 - Ag - 4026 - Conta - 29077-8 - Gerardo Lima Aguiar',
    'Gesseiro'
  );

-- Alameda Surubiju - 1930 (44 lançamentos)
UPDATE financeiro_lancamentos
SET pessoa_id = (SELECT id FROM pessoas WHERE UPPER(nome) = UPPER('Alameda Surubiju - 1930') LIMIT 1)
WHERE pessoa_id IS NULL
  AND nucleo = 'designer'
  AND descricao IN (
    'Uber',
    'Estacionamento',
    'DFM2039 - Praça Barueri',
    'QQZ0553 - Praça: Osasco',
    'QQZ0553 - Praça: Barueri',
    'QQZ0553- Praça Barueri',
    'Pedágio - QQZ0553',
    'Almoço em equipe',
    'Almoço equipe',
    'Material',
    'Descontar Miguel',
    'COMPRA DEBITO NACIONAL - SODIMAC -BARUERI-BRA',
    'Descontar do Leandro Reis',
    'Fase 1',
    'Seguro obra',
    'Demolição',
    'Transferência/TED - Banco - 104 - Ag - 2929 - Conta - 3001538-6 - MÁRCIO RUIZ GARCIA ME',
    'COMPRA DEBITO NACIONAL - RALPHA POSTO LTDA -BARUERI-BRA',
    'Transferência/TED - Banco - 1 - Ag - 7021 - Conta - 895-8 - LEANDRO REIS ALVES',
    'Diversos',
    'Arquiteta',
    'Transferência/TED - Banco - 237 - Ag - 2386 - Conta - 20938-4 - Glecio lima Cruz',
    'Transferência/TED - Banco - 341 - Ag - 1663 - Conta - 16160-0 - GILBERTO AFONSO PERIN',
    'Retirada entulho',
    'Transferência/TED - Banco - 341 - Ag - 6690 - Conta - 16576-3 - JOSÉ MIGUEL ROSA DA SILVA',
    'Retirada de entulho',
    'Vidro',
    'Vidros',
    'Fase 2',
    'Final'
  );


-- Verificar resultado:
SELECT
    CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END as status,
    COUNT(*) as total
FROM financeiro_lancamentos
WHERE nucleo = 'designer'
GROUP BY CASE WHEN pessoa_id IS NULL THEN 'SEM CLIENTE' ELSE 'COM CLIENTE' END;
