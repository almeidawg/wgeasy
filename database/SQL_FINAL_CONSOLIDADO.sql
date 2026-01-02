-- ============================================================
-- SQL CONSOLIDADO FINAL - DATAS DE INÍCIO
-- Executar no Supabase SQL Editor:
-- https://supabase.com/dashboard/project/ahlqzzkxuutwoepirpzr/sql/new
-- ============================================================
-- Data: 2026-01-02
-- ============================================================

-- ============================================================
-- PASSO 1: CRIAR COLUNA DATA_INICIO
-- ============================================================
ALTER TABLE pessoas ADD COLUMN IF NOT EXISTS data_inicio DATE;

-- ============================================================
-- PASSO 2: COLABORADORES - DATAS DE INÍCIO (22 registros)
-- Fonte: Primeiro pagamento registrado + documentos
-- ============================================================

-- Colaboradores desde 2020
UPDATE pessoas SET data_inicio = '2020-06-10' WHERE id = '2cbcdb32-6ad6-412b-b0cb-73bcd1cc4e94'; -- Josemar Joaquim de Souza
UPDATE pessoas SET data_inicio = '2020-06-17' WHERE id = '5b4af090-8e6a-4b10-80c5-6686d5e63d3a'; -- William
UPDATE pessoas SET data_inicio = '2020-06-26' WHERE id = 'c7222975-5aef-4326-b726-a36bed9612f1'; -- MARCOS
UPDATE pessoas SET data_inicio = '2020-07-07' WHERE id = '28a7472a-e849-4bc3-8780-214c04a7c54f'; -- Antônio
UPDATE pessoas SET data_inicio = '2020-07-07' WHERE id = '50b8a7b2-2686-4cfe-8d05-d708de312020'; -- José Vinicius

-- Colaboradores desde 2023
UPDATE pessoas SET data_inicio = '2023-06-25' WHERE id = '04e75742-c53c-4b52-8138-fb953a30755b'; -- CARLOS
UPDATE pessoas SET data_inicio = '2023-08-29' WHERE id = '6d40482f-899e-41ca-b5de-79a795978728'; -- Rogério Aparecido Michelini (via documento)

-- Colaboradores desde 2024
UPDATE pessoas SET data_inicio = '2024-01-31' WHERE id = '35693a08-3424-4ba3-bc71-5a1c49e00311'; -- JOSENILDO
UPDATE pessoas SET data_inicio = '2024-03-07' WHERE id = 'd3d0c75d-aa6e-43e3-b042-23a30a179dc0'; -- FABIO
UPDATE pessoas SET data_inicio = '2024-07-07' WHERE id = '853b3f28-6fbf-4696-8294-023c5045414b'; -- GLEBER
UPDATE pessoas SET data_inicio = '2024-07-23' WHERE id = '4d2c4cb0-c8af-4ea3-a2aa-030faa1f1a5b'; -- WELLINGTON
UPDATE pessoas SET data_inicio = '2024-07-30' WHERE id = 'b784f700-356f-4038-90f0-6de21f60cd93'; -- Leandro

-- Colaboradores desde 2025
UPDATE pessoas SET data_inicio = '2025-02-04' WHERE id = '766be75c-41f8-4aa7-a5c6-0c96705e96c9'; -- VALDINEI
UPDATE pessoas SET data_inicio = '2025-04-24' WHERE id = 'aac151c2-6c9c-44cb-9fb0-3ba2abf9cdc0'; -- RODRIGO
UPDATE pessoas SET data_inicio = '2025-06-08' WHERE id = 'c6cbb3a9-6f7c-4d6a-8ee5-f7a866845b24'; -- VENANCIO
UPDATE pessoas SET data_inicio = '2025-07-04' WHERE id = '15e70e4f-a77f-4843-a6f7-c8eb73b2b772'; -- LOURIVAL
UPDATE pessoas SET data_inicio = '2025-07-22' WHERE id = '569afe4a-18df-45db-ac2e-9a94550b3cae'; -- JESSIKA
UPDATE pessoas SET data_inicio = '2025-08-30' WHERE id = '335f7d3c-84e7-46b8-bc07-9e2ff4f68207'; -- GERARDO
UPDATE pessoas SET data_inicio = '2025-09-13' WHERE id = 'dffe88d7-e4da-4f6f-961d-e62436c7914e'; -- Valdir
UPDATE pessoas SET data_inicio = '2025-10-14' WHERE id = 'eab94604-f118-41a8-ba7d-087212806b98'; -- Julia
UPDATE pessoas SET data_inicio = '2025-10-18' WHERE id = 'd3d6a25f-b68d-4f3d-bfac-29158310c83d'; -- JOSEILTON
UPDATE pessoas SET data_inicio = '2025-10-18' WHERE id = '2636c23d-53da-4336-b7a3-0af5fb8c0ee1'; -- JOÃO PAULO

-- ============================================================
-- PASSO 3: CLIENTES - DATAS DE INÍCIO (61 registros)
-- Fonte: Primeiro pagamento recebido
-- ============================================================

-- Clientes desde 2013
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = '5587c3e0-1f55-4116-85bc-ca34fad797f9'; -- Alameda Surubiju - 1930
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = '09bd5208-a7c4-4f96-ba73-ab94e48e9522'; -- Bruna Spezia
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = 'cc2c813c-01aa-4466-a4f1-34ecd5d1704e'; -- Consultório Dra. Thais
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = '58e959fc-4582-4c02-933d-4bc4eaf56761'; -- Lumen It
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = 'afc900da-ef9d-4fb7-a5cc-be41955aca78'; -- Michele Caldeira
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = 'fea0a635-a965-496e-9701-ce2fb0624b57'; -- Monica Sampaio
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = 'd1f9131e-f2aa-4621-a79d-f6d785b60586'; -- Rafael Teles
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = '3a63e969-d118-4b5f-9dba-4392f0f51b21'; -- Roberto Grejo
UPDATE pessoas SET data_inicio = '2013-01-01' WHERE id = '406514b6-872f-4282-98a3-ccefaf52f86c'; -- W.G. DE ALMEIDA DESIGNER DE INTERIORES
UPDATE pessoas SET data_inicio = '2013-08-21' WHERE id = 'd457fc86-8aee-44bf-87f9-58ab656be31c'; -- Fernando Macedo
UPDATE pessoas SET data_inicio = '2013-10-22' WHERE id = '5eebcaf4-f364-4d1b-a22b-cd5b544fb428'; -- Danilo e Renata

-- Clientes desde 2014
UPDATE pessoas SET data_inicio = '2014-01-01' WHERE id = '1d3b69aa-c4fd-46fb-abb5-97f6ce38d11e'; -- Fábio Luis Moreira
UPDATE pessoas SET data_inicio = '2014-06-16' WHERE id = '2723fba9-3156-4372-b84b-dbf153b1b13b'; -- Davi Beck e Fabiana
UPDATE pessoas SET data_inicio = '2014-12-30' WHERE id = '7a23cf9b-f339-4570-b1da-1998fc2ea2d7'; -- André e Flávia

-- Clientes desde 2019
UPDATE pessoas SET data_inicio = '2019-07-16' WHERE id = '1a3adf23-1ff0-4ff5-b514-8e951e051646'; -- Reinaldo
UPDATE pessoas SET data_inicio = '2019-07-18' WHERE id = 'c2a9957c-79f2-40e4-b4b1-e9ed374ab0bc'; -- Michel Lemons e Aline
UPDATE pessoas SET data_inicio = '2019-07-23' WHERE id = 'fdbf71dd-be37-4e67-9136-2ea3c6611871'; -- Time's Burger e Sueli
UPDATE pessoas SET data_inicio = '2019-10-21' WHERE id = 'ddf8bfe4-d122-44f8-a9ac-4b58fef54e8f'; -- THAIS REGINA GAYA CAMINOTTO
UPDATE pessoas SET data_inicio = '2019-11-07' WHERE id = '8f829ca9-ede2-4ef0-b47a-ad2519c35164'; -- Caita
UPDATE pessoas SET data_inicio = '2019-12-19' WHERE id = '90bb4152-0bb9-4eee-a52e-af60dc13a325'; -- Stephanie Carvalho
UPDATE pessoas SET data_inicio = '2019-12-28' WHERE id = 'c5880d3f-a6bd-45c0-bb21-9b94a8ce32cb'; -- Christian Lopes de Abreu

-- Clientes desde 2020
UPDATE pessoas SET data_inicio = '2020-01-18' WHERE id = 'fb79dbb6-17d2-4b08-865d-4de713570bcd'; -- Monica Sampaio Zacharias
UPDATE pessoas SET data_inicio = '2020-02-04' WHERE id = 'd6bbb2c7-7e95-4e32-91d1-f1328f93853b'; -- Ronaldo Bueno
UPDATE pessoas SET data_inicio = '2020-02-07' WHERE id = '04f7719c-7935-4c78-b3d2-cf249e7fd8e3'; -- MARIO MARIUTTI
UPDATE pessoas SET data_inicio = '2020-02-14' WHERE id = '7b661f59-e073-4bab-a33f-3b279999884b'; -- Squash
UPDATE pessoas SET data_inicio = '2020-03-02' WHERE id = 'f6a82e6e-d4fc-4765-a1fe-4af08076d4fd'; -- Ronaldo Bueno (Projeto Arquitetonico)
UPDATE pessoas SET data_inicio = '2020-03-04' WHERE id = 'cc10f191-eb4f-4f2b-87db-9cd524893275'; -- José Carlos
UPDATE pessoas SET data_inicio = '2020-04-25' WHERE id = '96a4a90a-8a7a-43aa-afea-249e59798341'; -- Denis Szejnfeld
UPDATE pessoas SET data_inicio = '2020-07-13' WHERE id = 'd8a6255e-809a-49df-8306-ccf5f5b0b407'; -- Igor - Surubiju 1930
UPDATE pessoas SET data_inicio = '2020-07-14' WHERE id = '7228900b-aff5-41f9-961a-7dd62dc64cbd'; -- Eduardo Escaleira
UPDATE pessoas SET data_inicio = '2020-08-11' WHERE id = 'ce093e70-70dc-4a51-9b3a-04843d6b8628'; -- Regis Buzetti Pereira Melgaco
UPDATE pessoas SET data_inicio = '2020-09-30' WHERE id = 'cea33671-e4fd-452a-9c2d-129a8181a06d'; -- Ricardo Luiz Vieira Tonetti

-- Clientes desde 2021
UPDATE pessoas SET data_inicio = '2021-05-13' WHERE id = 'faa5eb75-84cb-4d92-8942-c48a45e0844d'; -- André Luis
UPDATE pessoas SET data_inicio = '2021-05-14' WHERE id = '18d8f06b-ce07-4bc6-a3ef-ae595c025c6f'; -- Diana Zimmer e Rodrigo
UPDATE pessoas SET data_inicio = '2021-05-19' WHERE id = 'd9a7d4d0-2245-49bb-9ea8-b7ddb246dac8'; -- Alexandre de Souza Cavalcante
UPDATE pessoas SET data_inicio = '2021-05-26' WHERE id = 'a7b45b92-9245-48a8-b9f9-8afbf29531af'; -- Maria Aparecida
UPDATE pessoas SET data_inicio = '2021-06-07' WHERE id = 'eec66d5c-ff14-4ec6-b99f-30735daef2f4'; -- Felipe Diório
UPDATE pessoas SET data_inicio = '2021-07-05' WHERE id = 'e835f7da-bc47-440f-92d7-a19edf9936aa'; -- Mauricio Barbarulo
UPDATE pessoas SET data_inicio = '2021-07-20' WHERE id = '863d918b-51e6-45c2-ab1e-10ffc7779086'; -- Helio Pereira Rebouças
UPDATE pessoas SET data_inicio = '2021-07-26' WHERE id = '64f4a9ce-7cfe-4957-b6e2-0b9906e59c36'; -- Rebecca e Andre
UPDATE pessoas SET data_inicio = '2021-09-20' WHERE id = 'cf460724-5dc1-4b86-a83a-eaeb1e73117d'; -- Paloma Medeiros
UPDATE pessoas SET data_inicio = '2021-09-27' WHERE id = '38c81dfd-3e74-4b7d-ac34-17d06aa2df99'; -- Michele e Danilo

-- Clientes desde 2022
UPDATE pessoas SET data_inicio = '2022-01-15' WHERE id = 'd7819977-4bd5-4794-a759-380b95e1c550'; -- Alziro da Silveira
UPDATE pessoas SET data_inicio = '2022-01-17' WHERE id = '99d8cb86-95c1-4acf-9850-08f7909229d8'; -- Denis Vitti
UPDATE pessoas SET data_inicio = '2022-03-15' WHERE id = 'd28449f2-891a-4f5c-a739-ec9453aa8388'; -- Bruna Cunha
UPDATE pessoas SET data_inicio = '2022-04-19' WHERE id = '19fc4217-4584-45d2-8777-171ad94db9ba'; -- Raquel Aquino e Arthur
UPDATE pessoas SET data_inicio = '2022-04-24' WHERE id = '9526f0dd-0f77-4f76-bc7c-0fd76ff41e33'; -- Raquel Aquino & Arthur
UPDATE pessoas SET data_inicio = '2022-06-01' WHERE id = '10764367-aca9-4cf3-a581-dec551f23089'; -- Mauro Frazili
UPDATE pessoas SET data_inicio = '2022-07-28' WHERE id = '0c7c8227-9faf-4ebe-ba9a-fd58bcb3c7b9'; -- Hospital Certa
UPDATE pessoas SET data_inicio = '2022-08-29' WHERE id = '3c8fe930-610c-4cc1-8396-1bf63aa7d9df'; -- Denis Szejnfeld Nebraska 871

-- Clientes desde 2023
UPDATE pessoas SET data_inicio = '2023-02-17' WHERE id = '745383e8-5f45-4850-a488-f85d333e1dd4'; -- Renata Lizas Verpa
UPDATE pessoas SET data_inicio = '2023-11-06' WHERE id = '3dc97ce7-4f72-4f5f-940c-48b3a7829a70'; -- Tatiana Nysp
UPDATE pessoas SET data_inicio = '2023-12-10' WHERE id = 'd8b8dc0f-4a70-4969-ae9a-9c1404996bf3'; -- Camila Nysp 102 A

-- Clientes desde 2024
UPDATE pessoas SET data_inicio = '2024-02-06' WHERE id = '04bdb2be-281a-481f-b206-e5901cf7bd75'; -- Renato NYSP
UPDATE pessoas SET data_inicio = '2024-09-25' WHERE id = 'ae6fcedd-e889-4558-a322-5e6b1c95637d'; -- William Gomes de Almeida - Pessoal

-- Clientes desde 2025
UPDATE pessoas SET data_inicio = '2025-10-06' WHERE id = '5f1b03a0-ccbe-43cc-b430-c2675fa0f733'; -- ELIANA KIELLANDER LOPES
UPDATE pessoas SET data_inicio = '2025-11-08' WHERE id = '3d56bcc7-ccd4-4f56-8b21-6a9f7ac9e96e'; -- MARLISSON FABRICIO DE OLIVEIRA MACHADO
UPDATE pessoas SET data_inicio = '2025-11-11' WHERE id = 'b1cfbb2f-1a15-412a-b997-de2200406b9e'; -- ADEMIR DE QUADROS
UPDATE pessoas SET data_inicio = '2025-11-19' WHERE id = '8a906668-ef72-4b2b-a9ac-9675508cd96b'; -- JVCORPORATE LTDA
UPDATE pessoas SET data_inicio = '2025-11-28' WHERE id = 'ffa1aea6-73e1-496a-891c-654bda63fd5e'; -- RAPHAEL HENRIQUE PINTO PIRES
UPDATE pessoas SET data_inicio = '2025-12-03' WHERE id = 'e6d2ace2-9d88-47d6-ade4-d498cb0b7be6'; -- THAIS FONSECA MARGON

-- ============================================================
-- PASSO 4: VERIFICAR RESULTADO FINAL
-- ============================================================

-- Ver colaboradores
SELECT 'COLABORADOR' as tipo, nome, data_inicio, criado_em::date as cadastro
FROM pessoas
WHERE tipo = 'COLABORADOR' AND ativo = true
ORDER BY data_inicio NULLS LAST;

-- Ver clientes com data_inicio
SELECT 'CLIENTE' as tipo, nome, data_inicio, criado_em::date as cadastro
FROM pessoas
WHERE tipo = 'CLIENTE' AND ativo = true AND data_inicio IS NOT NULL
ORDER BY data_inicio;

-- Resumo
SELECT
    tipo,
    COUNT(*) as total,
    COUNT(data_inicio) as com_data,
    COUNT(*) - COUNT(data_inicio) as sem_data
FROM pessoas
WHERE ativo = true
GROUP BY tipo;
