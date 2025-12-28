-- =====================================================
-- MÓDULO JURÍDICO - SISTEMA WG EASY
-- Modelos de Contrato com Versionamento e Auditoria
-- =====================================================

-- =====================================================
-- 1. TABELA: MODELOS DE CONTRATO (TEMPLATES)
-- =====================================================
CREATE TABLE IF NOT EXISTS juridico_modelos_contrato (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,

  -- Identificação
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,

  -- Vinculação
  empresa_id UUID, -- Referência opcional à empresa (se tabela existir)
  nucleo VARCHAR(50) NOT NULL CHECK (nucleo IN ('arquitetura', 'engenharia', 'marcenaria', 'produtos', 'materiais', 'empreitada', 'geral')),

  -- Status do Workflow
  status VARCHAR(30) DEFAULT 'rascunho' CHECK (status IN ('rascunho', 'em_revisao', 'aprovado', 'publicado', 'arquivado')),

  -- Versão
  versao INTEGER DEFAULT 1,
  versao_texto VARCHAR(20) DEFAULT '1.0.0',

  -- Conteúdo do Contrato
  conteudo_html TEXT NOT NULL,
  clausulas JSONB DEFAULT '[]',

  -- Configurações
  variaveis_obrigatorias JSONB DEFAULT '[]',
  prazo_execucao_padrao INTEGER DEFAULT 90,
  prorrogacao_padrao INTEGER DEFAULT 30,

  -- Auditoria
  criado_por UUID,
  aprovado_por UUID,
  data_aprovacao TIMESTAMP WITH TIME ZONE,

  -- Metadados
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_juridico_modelos_empresa ON juridico_modelos_contrato(empresa_id);
CREATE INDEX IF NOT EXISTS idx_juridico_modelos_nucleo ON juridico_modelos_contrato(nucleo);
CREATE INDEX IF NOT EXISTS idx_juridico_modelos_status ON juridico_modelos_contrato(status);

-- =====================================================
-- 2. TABELA: CLÁUSULAS PADRÃO
-- =====================================================
CREATE TABLE IF NOT EXISTS juridico_clausulas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,

  -- Identificação
  codigo VARCHAR(50) NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  numero_ordem INTEGER DEFAULT 1,

  -- Tipo de Cláusula
  tipo VARCHAR(50) NOT NULL CHECK (tipo IN (
    'objeto',
    'prazo',
    'preco',
    'pagamento',
    'obrigacoes_contratante',
    'obrigacoes_contratada',
    'garantia',
    'rescisao',
    'penalidades',
    'foro',
    'disposicoes_gerais',
    'personalizada'
  )),

  -- Conteúdo
  conteudo_html TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',

  -- Vinculação
  nucleo VARCHAR(50),
  modelo_id UUID REFERENCES juridico_modelos_contrato(id) ON DELETE CASCADE,

  -- Status
  obrigatoria BOOLEAN DEFAULT false,
  ativa BOOLEAN DEFAULT true,

  -- Auditoria
  criado_por UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_juridico_clausulas_tipo ON juridico_clausulas(tipo);
CREATE INDEX IF NOT EXISTS idx_juridico_clausulas_modelo ON juridico_clausulas(modelo_id);

-- =====================================================
-- 3. TABELA: VARIÁVEIS DO SISTEMA
-- =====================================================
CREATE TABLE IF NOT EXISTS juridico_variaveis (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,

  -- Identificação
  codigo VARCHAR(100) NOT NULL UNIQUE,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,

  -- Categoria
  categoria VARCHAR(50) NOT NULL CHECK (categoria IN (
    'empresa',
    'pessoa',
    'contrato',
    'parcela',
    'projeto',
    'ambiente',
    'item',
    'sistema'
  )),

  -- Configuração
  tabela_origem VARCHAR(100),
  campo_origem VARCHAR(100),
  formato VARCHAR(50) DEFAULT 'texto',
  exemplo TEXT,

  -- Status
  ativa BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. TABELA: MEMORIAL EXECUTIVO
-- =====================================================
CREATE TABLE IF NOT EXISTS juridico_memorial_executivo (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,

  -- Vinculação
  contrato_id UUID REFERENCES contratos(id) ON DELETE CASCADE,

  -- Conteúdo por Núcleo (JSONB para flexibilidade)
  arquitetura JSONB DEFAULT '{"itens": [], "ambientes": [], "metragens": [], "observacoes": ""}',
  engenharia JSONB DEFAULT '{"itens": [], "ambientes": [], "metragens": [], "observacoes": ""}',
  marcenaria JSONB DEFAULT '{"itens": [], "ambientes": [], "metragens": [], "observacoes": ""}',
  materiais JSONB DEFAULT '{"itens": [], "quantidades": [], "especificacoes": []}',
  produtos JSONB DEFAULT '{"produtos": [], "modelos": [], "marcas": [], "quantidades": []}',

  -- Snapshot (cópia imutável no momento da geração)
  snapshot_data JSONB,
  snapshot_gerado_em TIMESTAMP WITH TIME ZONE,

  -- Texto Gerado para Cláusula Primeira
  texto_clausula_objeto TEXT,

  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índice
CREATE INDEX IF NOT EXISTS idx_juridico_memorial_contrato ON juridico_memorial_executivo(contrato_id);

-- =====================================================
-- 5. TABELA: HISTÓRICO DE VERSÕES
-- =====================================================
CREATE TABLE IF NOT EXISTS juridico_versoes_modelo (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,

  -- Vinculação
  modelo_id UUID REFERENCES juridico_modelos_contrato(id) ON DELETE CASCADE,

  -- Versão
  versao INTEGER NOT NULL,
  versao_texto VARCHAR(20),

  -- Snapshot do Conteúdo
  conteudo_html TEXT NOT NULL,
  clausulas JSONB,
  variaveis_obrigatorias JSONB,

  -- Auditoria
  alterado_por UUID,
  motivo_alteracao TEXT,

  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índice
CREATE INDEX IF NOT EXISTS idx_juridico_versoes_modelo ON juridico_versoes_modelo(modelo_id);

-- =====================================================
-- 6. TABELA: LOG DE AUDITORIA JURÍDICA
-- =====================================================
CREATE TABLE IF NOT EXISTS juridico_auditoria (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,

  -- Referência
  entidade VARCHAR(100) NOT NULL,
  entidade_id UUID NOT NULL,

  -- Ação
  acao VARCHAR(50) NOT NULL CHECK (acao IN (
    'criar',
    'editar',
    'aprovar',
    'rejeitar',
    'publicar',
    'arquivar',
    'restaurar',
    'gerar_contrato',
    'visualizar'
  )),

  -- Detalhes
  dados_antes JSONB,
  dados_depois JSONB,
  observacao TEXT,

  -- Auditoria
  usuario_id UUID,
  usuario_nome VARCHAR(200),
  usuario_perfil VARCHAR(50),
  ip_address VARCHAR(50),
  user_agent TEXT,

  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_juridico_auditoria_entidade ON juridico_auditoria(entidade, entidade_id);
CREATE INDEX IF NOT EXISTS idx_juridico_auditoria_usuario ON juridico_auditoria(usuario_id);
CREATE INDEX IF NOT EXISTS idx_juridico_auditoria_data ON juridico_auditoria(created_at);

-- =====================================================
-- 7. TABELA: CONTRATOS GERADOS (VINCULA MODELO À VERSÃO)
-- =====================================================
-- Adicionar colunas à tabela contratos existente
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS modelo_juridico_id UUID REFERENCES juridico_modelos_contrato(id);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS versao_modelo INTEGER;
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS memorial_executivo_id UUID REFERENCES juridico_memorial_executivo(id);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS conteudo_gerado TEXT;
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS snapshot_modelo JSONB;

-- =====================================================
-- 8. TRIGGERS
-- =====================================================

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_juridico_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_juridico_modelos_updated_at ON juridico_modelos_contrato;
CREATE TRIGGER update_juridico_modelos_updated_at
  BEFORE UPDATE ON juridico_modelos_contrato
  FOR EACH ROW
  EXECUTE FUNCTION update_juridico_updated_at();

DROP TRIGGER IF EXISTS update_juridico_clausulas_updated_at ON juridico_clausulas;
CREATE TRIGGER update_juridico_clausulas_updated_at
  BEFORE UPDATE ON juridico_clausulas
  FOR EACH ROW
  EXECUTE FUNCTION update_juridico_updated_at();

DROP TRIGGER IF EXISTS update_juridico_memorial_updated_at ON juridico_memorial_executivo;
CREATE TRIGGER update_juridico_memorial_updated_at
  BEFORE UPDATE ON juridico_memorial_executivo
  FOR EACH ROW
  EXECUTE FUNCTION update_juridico_updated_at();

-- Trigger para criar versão automaticamente
CREATE OR REPLACE FUNCTION criar_versao_modelo()
RETURNS TRIGGER AS $$
BEGIN
  -- Se o conteúdo mudou e o modelo já existia
  IF TG_OP = 'UPDATE' AND OLD.conteudo_html IS DISTINCT FROM NEW.conteudo_html THEN
    -- Incrementar versão
    NEW.versao = OLD.versao + 1;
    NEW.versao_texto = OLD.versao + 1 || '.0.0';

    -- Salvar versão anterior
    INSERT INTO juridico_versoes_modelo (
      modelo_id, versao, versao_texto, conteudo_html, clausulas, variaveis_obrigatorias, alterado_por
    ) VALUES (
      OLD.id, OLD.versao, OLD.versao_texto, OLD.conteudo_html, OLD.clausulas, OLD.variaveis_obrigatorias, NEW.criado_por
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_versao_modelo ON juridico_modelos_contrato;
CREATE TRIGGER trigger_versao_modelo
  BEFORE UPDATE ON juridico_modelos_contrato
  FOR EACH ROW
  EXECUTE FUNCTION criar_versao_modelo();

-- =====================================================
-- 9. RLS (Row Level Security) - ACESSO RESTRITO
-- =====================================================

ALTER TABLE juridico_modelos_contrato ENABLE ROW LEVEL SECURITY;
ALTER TABLE juridico_clausulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE juridico_variaveis ENABLE ROW LEVEL SECURITY;
ALTER TABLE juridico_memorial_executivo ENABLE ROW LEVEL SECURITY;
ALTER TABLE juridico_versoes_modelo ENABLE ROW LEVEL SECURITY;
ALTER TABLE juridico_auditoria ENABLE ROW LEVEL SECURITY;

-- Políticas simples - acesso total para usuários autenticados
DROP POLICY IF EXISTS "juridico_modelos_all" ON juridico_modelos_contrato;
CREATE POLICY "juridico_modelos_all" ON juridico_modelos_contrato FOR ALL USING (true);

DROP POLICY IF EXISTS "juridico_clausulas_all" ON juridico_clausulas;
CREATE POLICY "juridico_clausulas_all" ON juridico_clausulas FOR ALL USING (true);

DROP POLICY IF EXISTS "juridico_variaveis_all" ON juridico_variaveis;
CREATE POLICY "juridico_variaveis_all" ON juridico_variaveis FOR ALL USING (true);

DROP POLICY IF EXISTS "juridico_memorial_all" ON juridico_memorial_executivo;
CREATE POLICY "juridico_memorial_all" ON juridico_memorial_executivo FOR ALL USING (true);

DROP POLICY IF EXISTS "juridico_versoes_all" ON juridico_versoes_modelo;
CREATE POLICY "juridico_versoes_all" ON juridico_versoes_modelo FOR ALL USING (true);

DROP POLICY IF EXISTS "juridico_auditoria_all" ON juridico_auditoria;
CREATE POLICY "juridico_auditoria_all" ON juridico_auditoria FOR ALL USING (true);

-- =====================================================
-- 10. DADOS INICIAIS - VARIÁVEIS DO SISTEMA
-- =====================================================

INSERT INTO juridico_variaveis (codigo, nome, descricao, categoria, tabela_origem, campo_origem, formato, exemplo) VALUES
  -- EMPRESA (Contratada)
  ('empresa.razao_social', 'Razão Social da Empresa', 'Nome completo da empresa contratada', 'empresa', 'empresas', 'razao_social', 'texto', 'WG Almeida Arquitetura e Engenharia Ltda'),
  ('empresa.nome_fantasia', 'Nome Fantasia', 'Nome fantasia da empresa', 'empresa', 'empresas', 'nome_fantasia', 'texto', 'Grupo WG Almeida'),
  ('empresa.cnpj', 'CNPJ', 'CNPJ da empresa formatado', 'empresa', 'empresas', 'cnpj', 'cnpj', '12.345.678/0001-90'),
  ('empresa.endereco_completo', 'Endereço Completo', 'Endereço completo da empresa', 'empresa', 'empresas', 'endereco_completo', 'texto', 'Rua das Flores, 123, Centro, São Paulo/SP'),
  ('empresa.inscricao_estadual', 'Inscrição Estadual', 'IE da empresa', 'empresa', 'empresas', 'inscricao_estadual', 'texto', '123.456.789.000'),
  ('empresa.inscricao_municipal', 'Inscrição Municipal', 'IM da empresa', 'empresa', 'empresas', 'inscricao_municipal', 'texto', '1234567'),
  ('empresa.banco', 'Banco', 'Nome do banco', 'empresa', 'empresas', 'banco', 'texto', 'Banco do Brasil'),
  ('empresa.agencia', 'Agência', 'Número da agência', 'empresa', 'empresas', 'agencia', 'texto', '1234-5'),
  ('empresa.conta', 'Conta', 'Número da conta', 'empresa', 'empresas', 'conta', 'texto', '12345-6'),
  ('empresa.chave_pix', 'Chave PIX', 'Chave PIX da empresa', 'empresa', 'empresas', 'chave_pix', 'texto', 'financeiro@wgalmeida.com.br'),

  -- PESSOA (Contratante)
  ('pessoa.nome', 'Nome Completo', 'Nome completo do contratante', 'pessoa', 'pessoas', 'nome', 'texto', 'João da Silva'),
  ('pessoa.cpf_cnpj', 'CPF/CNPJ', 'Documento do contratante', 'pessoa', 'pessoas', 'cpf_cnpj', 'cpf_cnpj', '123.456.789-00'),
  ('pessoa.rg', 'RG', 'RG do contratante', 'pessoa', 'pessoas', 'rg', 'texto', '12.345.678-9'),
  ('pessoa.email', 'E-mail', 'E-mail do contratante', 'pessoa', 'pessoas', 'email', 'email', 'joao@email.com'),
  ('pessoa.telefone', 'Telefone', 'Telefone do contratante', 'pessoa', 'pessoas', 'telefone', 'telefone', '(11) 99999-9999'),
  ('pessoa.logradouro', 'Logradouro', 'Rua/Avenida', 'pessoa', 'pessoas', 'logradouro', 'texto', 'Rua das Palmeiras'),
  ('pessoa.numero', 'Número', 'Número do endereço', 'pessoa', 'pessoas', 'numero', 'texto', '456'),
  ('pessoa.complemento', 'Complemento', 'Complemento do endereço', 'pessoa', 'pessoas', 'complemento', 'texto', 'Apto 101'),
  ('pessoa.bairro', 'Bairro', 'Bairro', 'pessoa', 'pessoas', 'bairro', 'texto', 'Jardim América'),
  ('pessoa.cidade', 'Cidade', 'Cidade', 'pessoa', 'pessoas', 'cidade', 'texto', 'São Paulo'),
  ('pessoa.estado', 'Estado', 'UF', 'pessoa', 'pessoas', 'estado', 'texto', 'SP'),
  ('pessoa.cep', 'CEP', 'CEP formatado', 'pessoa', 'pessoas', 'cep', 'cep', '01234-567'),

  -- CONTRATO
  ('contrato.numero', 'Número do Contrato', 'Número identificador do contrato', 'contrato', 'contratos', 'numero', 'texto', 'CT-2024-001'),
  ('contrato.valor_total', 'Valor Total', 'Valor total do contrato', 'contrato', 'contratos', 'valor_total', 'moeda', 'R$ 150.000,00'),
  ('contrato.valor_extenso', 'Valor por Extenso', 'Valor total por extenso', 'contrato', 'contratos', 'valor_total', 'extenso', 'cento e cinquenta mil reais'),
  ('contrato.prazo_execucao', 'Prazo de Execução', 'Prazo em dias úteis', 'contrato', 'contratos', 'prazo_entrega_dias', 'numero', '90'),
  ('contrato.prorrogacao', 'Prorrogação', 'Dias de prorrogação', 'contrato', 'contratos', 'prorrogacao_dias', 'numero', '30'),
  ('contrato.data_inicio', 'Data de Início', 'Data prevista de início', 'contrato', 'contratos', 'data_inicio', 'data', '15/01/2024'),
  ('contrato.data_termino', 'Data de Término', 'Data prevista de término', 'contrato', 'contratos', 'data_termino', 'data', '15/04/2024'),

  -- PARCELAS
  ('parcela.descricao', 'Descrição da Parcela', 'Descrição da parcela', 'parcela', 'financeiro_lancamentos', 'descricao', 'texto', '1ª Parcela - Entrada'),
  ('parcela.valor', 'Valor da Parcela', 'Valor da parcela', 'parcela', 'financeiro_lancamentos', 'valor', 'moeda', 'R$ 30.000,00'),
  ('parcela.data_vencimento', 'Data de Vencimento', 'Vencimento da parcela', 'parcela', 'financeiro_lancamentos', 'vencimento', 'data', '20/01/2024'),
  ('parcela.forma_pagamento', 'Forma de Pagamento', 'Método de pagamento', 'parcela', 'financeiro_lancamentos', 'forma_pagamento', 'texto', 'PIX'),

  -- SISTEMA
  ('sistema.data_atual', 'Data Atual', 'Data de geração do documento', 'sistema', NULL, NULL, 'data', '17/12/2024'),
  ('sistema.data_extenso', 'Data por Extenso', 'Data atual por extenso', 'sistema', NULL, NULL, 'data_extenso', 'dezessete de dezembro de dois mil e vinte e quatro')
ON CONFLICT (codigo) DO NOTHING;

-- =====================================================
-- 11. MODELO DE CONTRATO PADRÃO (EXEMPLO)
-- =====================================================

INSERT INTO juridico_modelos_contrato (
  codigo,
  nome,
  descricao,
  nucleo,
  status,
  conteudo_html,
  clausulas,
  variaveis_obrigatorias
) VALUES (
  'MOD-ARQ-001',
  'Contrato de Prestação de Serviços - Arquitetura',
  'Modelo padrão para contratos de projetos arquitetônicos',
  'arquitetura',
  'rascunho',
  '<h1>CONTRATO DE PRESTAÇÃO DE SERVIÇOS DE ARQUITETURA</h1>

<p><strong>CONTRATANTE:</strong> {{pessoa.nome}}, pessoa física, residente e domiciliado na Cidade de {{pessoa.cidade}}, Estado de {{pessoa.estado}}, sito à {{pessoa.logradouro}}, nº {{pessoa.numero}}, {{pessoa.complemento}}, {{pessoa.bairro}}, CEP {{pessoa.cep}}, portador do CPF nº {{pessoa.cpf_cnpj}}, e do RG nº {{pessoa.rg}}, telefone(s) {{pessoa.telefone}}, e e-mail {{pessoa.email}}.</p>

<p><strong>CONTRATADA:</strong> {{empresa.razao_social}}, pessoa jurídica de direito privado, inscrita no CNPJ sob o nº {{empresa.cnpj}}, com sede em {{empresa.endereco_completo}}, neste ato representada na forma de seu Contrato Social.</p>

<h2>CLÁUSULA PRIMEIRA – DO OBJETO E DESCRIÇÃO</h2>
<p>{{memorial_executivo}}</p>

<h2>CLÁUSULA SEGUNDA – DO PRAZO PARA EXECUÇÃO</h2>
<p>Execução da obra: Em até {{contrato.prazo_execucao}} dias úteis após assinatura do projeto executivo, podendo ser prorrogado por mais {{contrato.prorrogacao}} dias em caso fortuito ou força maior, desde que devidamente notificado.</p>

<h2>CLÁUSULA TERCEIRA – DO PREÇO E HONORÁRIOS</h2>
<p>Valor acordado para execução da obra pela CONTRATADA de {{contrato.valor_total}} ({{contrato.valor_extenso}}) a serem pagos da seguinte forma:</p>
<p>{{tabela_parcelas}}</p>

<h3>DADOS BANCÁRIOS:</h3>
<p>{{empresa.razao_social}}<br>
Banco: {{empresa.banco}}<br>
Agência: {{empresa.agencia}}<br>
Conta: {{empresa.conta}}<br>
Chave Pix: {{empresa.chave_pix}}</p>

<h2>CLÁUSULA QUARTA – DAS OBRIGAÇÕES DA CONTRATADA</h2>
<p>São obrigações da CONTRATADA:</p>
<ul>
  <li>Executar os serviços conforme especificações técnicas;</li>
  <li>Manter equipe técnica qualificada;</li>
  <li>Cumprir os prazos estabelecidos;</li>
  <li>Fornecer materiais de primeira qualidade;</li>
</ul>

<h2>CLÁUSULA QUINTA – DAS OBRIGAÇÕES DO CONTRATANTE</h2>
<p>São obrigações do CONTRATANTE:</p>
<ul>
  <li>Efetuar os pagamentos nas datas acordadas;</li>
  <li>Fornecer acesso ao local de execução;</li>
  <li>Aprovar os projetos nos prazos estabelecidos;</li>
</ul>

<h2>CLÁUSULA SEXTA – DA GARANTIA</h2>
<p>A CONTRATADA oferece garantia de 5 (cinco) anos para vícios ocultos, conforme legislação vigente.</p>

<h2>CLÁUSULA SÉTIMA – DO FORO</h2>
<p>As partes elegem o Foro da Comarca de {{pessoa.cidade}}/{{pessoa.estado}} para dirimir quaisquer dúvidas oriundas do presente instrumento.</p>

<p>E por estarem assim justas e contratadas, firmam o presente instrumento em 2 (duas) vias de igual teor.</p>

<p>{{pessoa.cidade}}, {{sistema.data_extenso}}.</p>

<div class="assinaturas">
  <div class="assinatura">
    <p>_______________________________</p>
    <p><strong>CONTRATANTE</strong></p>
    <p>{{pessoa.nome}}</p>
    <p>CPF: {{pessoa.cpf_cnpj}}</p>
  </div>
  <div class="assinatura">
    <p>_______________________________</p>
    <p><strong>CONTRATADA</strong></p>
    <p>{{empresa.razao_social}}</p>
    <p>CNPJ: {{empresa.cnpj}}</p>
  </div>
</div>',
  '[
    {"numero": 1, "titulo": "DO OBJETO E DESCRIÇÃO", "tipo": "objeto", "obrigatoria": true},
    {"numero": 2, "titulo": "DO PRAZO PARA EXECUÇÃO", "tipo": "prazo", "obrigatoria": true},
    {"numero": 3, "titulo": "DO PREÇO E HONORÁRIOS", "tipo": "preco", "obrigatoria": true},
    {"numero": 4, "titulo": "DAS OBRIGAÇÕES DA CONTRATADA", "tipo": "obrigacoes_contratada", "obrigatoria": true},
    {"numero": 5, "titulo": "DAS OBRIGAÇÕES DO CONTRATANTE", "tipo": "obrigacoes_contratante", "obrigatoria": true},
    {"numero": 6, "titulo": "DA GARANTIA", "tipo": "garantia", "obrigatoria": true},
    {"numero": 7, "titulo": "DO FORO", "tipo": "foro", "obrigatoria": true}
  ]',
  '["pessoa.nome", "pessoa.cpf_cnpj", "pessoa.email", "pessoa.telefone", "pessoa.logradouro", "pessoa.cidade", "pessoa.estado", "contrato.valor_total", "contrato.prazo_execucao"]'
) ON CONFLICT (codigo) DO NOTHING;

-- =====================================================
-- COMENTÁRIOS
-- =====================================================
COMMENT ON TABLE juridico_modelos_contrato IS 'Modelos de contrato (templates) gerenciados pelo jurídico';
COMMENT ON TABLE juridico_clausulas IS 'Cláusulas padrão e personalizadas para contratos';
COMMENT ON TABLE juridico_variaveis IS 'Variáveis dinâmicas disponíveis para uso nos contratos';
COMMENT ON TABLE juridico_memorial_executivo IS 'Memorial descritivo executivo vinculado a cada contrato';
COMMENT ON TABLE juridico_versoes_modelo IS 'Histórico de versões dos modelos de contrato';
COMMENT ON TABLE juridico_auditoria IS 'Log de auditoria de todas as ações no módulo jurídico';
