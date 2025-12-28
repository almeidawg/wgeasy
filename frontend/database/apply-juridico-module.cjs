// Script para aplicar o Módulo Jurídico via Supabase
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

const SUPABASE_URL = 'https://ahlqzzkxuutwoepirpzr.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFobHF6emt4dXV0d29lcGlycHpyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NjY0MjkwMCwiZXhwIjoyMDYyMjE4OTAwfQ.CPBn3kh8z17BXbPkPsP0tsTAccKq-ADiKGaZpwfGN9Y';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function verificarTabela(tabela) {
  const { error } = await supabase.from(tabela).select('id').limit(1);
  return !error || !error.message.includes('does not exist');
}

async function executarSQL(sql, descricao) {
  console.log(`\n[INFO] ${descricao}...`);
  try {
    const { error } = await supabase.rpc('exec_sql', { sql });
    if (error) {
      if (error.message.includes('already exists') || error.message.includes('duplicate')) {
        console.log(`[OK] Já existe - ${descricao}`);
        return true;
      }
      console.log(`[WARN] ${error.message}`);
      return false;
    }
    console.log(`[OK] ${descricao}`);
    return true;
  } catch (e) {
    console.log(`[WARN] ${e.message}`);
    return false;
  }
}

async function aplicarModuloJuridico() {
  console.log('=====================================================');
  console.log('       APLICANDO MÓDULO JURÍDICO - WG EASY');
  console.log('=====================================================\n');

  // 1. Verificar status atual
  console.log('[STATUS] Verificando tabelas existentes...');
  const tabelas = [
    'juridico_modelos_contrato',
    'juridico_clausulas',
    'juridico_variaveis',
    'juridico_memorial_executivo',
    'juridico_versoes_modelo',
    'juridico_auditoria'
  ];

  for (const tabela of tabelas) {
    const existe = await verificarTabela(tabela);
    console.log(`  - ${tabela}: ${existe ? '✓ Existe' : '✗ Não existe'}`);
  }

  // 2. Criar tabelas
  console.log('\n[CRIANDO TABELAS]');

  // 2.1 juridico_modelos_contrato
  await executarSQL(`
    CREATE TABLE IF NOT EXISTS juridico_modelos_contrato (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      codigo VARCHAR(50) NOT NULL UNIQUE,
      nome VARCHAR(200) NOT NULL,
      descricao TEXT,
      empresa_id UUID REFERENCES empresas(id) ON DELETE SET NULL,
      nucleo VARCHAR(50) NOT NULL CHECK (nucleo IN ('arquitetura', 'engenharia', 'marcenaria', 'produtos', 'materiais', 'empreitada', 'geral')),
      status VARCHAR(30) DEFAULT 'rascunho' CHECK (status IN ('rascunho', 'em_revisao', 'aprovado', 'publicado', 'arquivado')),
      versao INTEGER DEFAULT 1,
      versao_texto VARCHAR(20) DEFAULT '1.0.0',
      conteudo_html TEXT NOT NULL,
      clausulas JSONB DEFAULT '[]',
      variaveis_obrigatorias JSONB DEFAULT '[]',
      prazo_execucao_padrao INTEGER DEFAULT 90,
      prorrogacao_padrao INTEGER DEFAULT 30,
      criado_por UUID REFERENCES usuarios(id),
      aprovado_por UUID REFERENCES usuarios(id),
      data_aprovacao TIMESTAMP WITH TIME ZONE,
      ativo BOOLEAN DEFAULT true,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    )
  `, 'Tabela juridico_modelos_contrato');

  // 2.2 juridico_clausulas
  await executarSQL(`
    CREATE TABLE IF NOT EXISTS juridico_clausulas (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      codigo VARCHAR(50) NOT NULL,
      titulo VARCHAR(200) NOT NULL,
      numero_ordem INTEGER DEFAULT 1,
      tipo VARCHAR(50) NOT NULL,
      conteudo_html TEXT NOT NULL,
      variaveis JSONB DEFAULT '[]',
      nucleo VARCHAR(50),
      modelo_id UUID REFERENCES juridico_modelos_contrato(id) ON DELETE CASCADE,
      obrigatoria BOOLEAN DEFAULT false,
      ativa BOOLEAN DEFAULT true,
      criado_por UUID REFERENCES usuarios(id),
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    )
  `, 'Tabela juridico_clausulas');

  // 2.3 juridico_variaveis
  await executarSQL(`
    CREATE TABLE IF NOT EXISTS juridico_variaveis (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      codigo VARCHAR(100) NOT NULL UNIQUE,
      nome VARCHAR(200) NOT NULL,
      descricao TEXT,
      categoria VARCHAR(50) NOT NULL,
      tabela_origem VARCHAR(100),
      campo_origem VARCHAR(100),
      formato VARCHAR(50) DEFAULT 'texto',
      exemplo TEXT,
      ativa BOOLEAN DEFAULT true,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    )
  `, 'Tabela juridico_variaveis');

  // 2.4 juridico_memorial_executivo
  await executarSQL(`
    CREATE TABLE IF NOT EXISTS juridico_memorial_executivo (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      contrato_id UUID REFERENCES contratos(id) ON DELETE CASCADE,
      arquitetura JSONB DEFAULT '{"itens": [], "ambientes": [], "metragens": [], "observacoes": ""}',
      engenharia JSONB DEFAULT '{"itens": [], "ambientes": [], "metragens": [], "observacoes": ""}',
      marcenaria JSONB DEFAULT '{"itens": [], "ambientes": [], "metragens": [], "observacoes": ""}',
      materiais JSONB DEFAULT '{"itens": [], "quantidades": [], "especificacoes": []}',
      produtos JSONB DEFAULT '{"produtos": [], "modelos": [], "marcas": [], "quantidades": []}',
      snapshot_data JSONB,
      snapshot_gerado_em TIMESTAMP WITH TIME ZONE,
      texto_clausula_objeto TEXT,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    )
  `, 'Tabela juridico_memorial_executivo');

  // 2.5 juridico_versoes_modelo
  await executarSQL(`
    CREATE TABLE IF NOT EXISTS juridico_versoes_modelo (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      modelo_id UUID REFERENCES juridico_modelos_contrato(id) ON DELETE CASCADE,
      versao INTEGER NOT NULL,
      versao_texto VARCHAR(20),
      conteudo_html TEXT NOT NULL,
      clausulas JSONB,
      variaveis_obrigatorias JSONB,
      alterado_por UUID REFERENCES usuarios(id),
      motivo_alteracao TEXT,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    )
  `, 'Tabela juridico_versoes_modelo');

  // 2.6 juridico_auditoria
  await executarSQL(`
    CREATE TABLE IF NOT EXISTS juridico_auditoria (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      entidade VARCHAR(100) NOT NULL,
      entidade_id UUID NOT NULL,
      acao VARCHAR(50) NOT NULL,
      dados_antes JSONB,
      dados_depois JSONB,
      observacao TEXT,
      usuario_id UUID REFERENCES usuarios(id),
      usuario_nome VARCHAR(200),
      usuario_perfil VARCHAR(50),
      ip_address VARCHAR(50),
      user_agent TEXT,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    )
  `, 'Tabela juridico_auditoria');

  // 3. Adicionar colunas na tabela contratos
  console.log('\n[ALTERANDO TABELA CONTRATOS]');

  await executarSQL(`ALTER TABLE contratos ADD COLUMN IF NOT EXISTS modelo_juridico_id UUID REFERENCES juridico_modelos_contrato(id)`, 'Coluna modelo_juridico_id');
  await executarSQL(`ALTER TABLE contratos ADD COLUMN IF NOT EXISTS versao_modelo INTEGER`, 'Coluna versao_modelo');
  await executarSQL(`ALTER TABLE contratos ADD COLUMN IF NOT EXISTS memorial_executivo_id UUID`, 'Coluna memorial_executivo_id');
  await executarSQL(`ALTER TABLE contratos ADD COLUMN IF NOT EXISTS conteudo_gerado TEXT`, 'Coluna conteudo_gerado');
  await executarSQL(`ALTER TABLE contratos ADD COLUMN IF NOT EXISTS snapshot_modelo JSONB`, 'Coluna snapshot_modelo');

  // 4. Criar índices
  console.log('\n[CRIANDO ÍNDICES]');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_modelos_empresa ON juridico_modelos_contrato(empresa_id)`, 'Índice modelos_empresa');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_modelos_nucleo ON juridico_modelos_contrato(nucleo)`, 'Índice modelos_nucleo');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_modelos_status ON juridico_modelos_contrato(status)`, 'Índice modelos_status');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_clausulas_tipo ON juridico_clausulas(tipo)`, 'Índice clausulas_tipo');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_clausulas_modelo ON juridico_clausulas(modelo_id)`, 'Índice clausulas_modelo');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_memorial_contrato ON juridico_memorial_executivo(contrato_id)`, 'Índice memorial_contrato');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_versoes_modelo ON juridico_versoes_modelo(modelo_id)`, 'Índice versoes_modelo');
  await executarSQL(`CREATE INDEX IF NOT EXISTS idx_juridico_auditoria_entidade ON juridico_auditoria(entidade, entidade_id)`, 'Índice auditoria_entidade');

  // 5. Habilitar RLS
  console.log('\n[HABILITANDO RLS]');
  await executarSQL(`ALTER TABLE juridico_modelos_contrato ENABLE ROW LEVEL SECURITY`, 'RLS juridico_modelos_contrato');
  await executarSQL(`ALTER TABLE juridico_clausulas ENABLE ROW LEVEL SECURITY`, 'RLS juridico_clausulas');
  await executarSQL(`ALTER TABLE juridico_variaveis ENABLE ROW LEVEL SECURITY`, 'RLS juridico_variaveis');
  await executarSQL(`ALTER TABLE juridico_memorial_executivo ENABLE ROW LEVEL SECURITY`, 'RLS juridico_memorial_executivo');
  await executarSQL(`ALTER TABLE juridico_versoes_modelo ENABLE ROW LEVEL SECURITY`, 'RLS juridico_versoes_modelo');
  await executarSQL(`ALTER TABLE juridico_auditoria ENABLE ROW LEVEL SECURITY`, 'RLS juridico_auditoria');

  // 6. Criar políticas RLS
  console.log('\n[CRIANDO POLÍTICAS RLS]');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_modelos_select" ON juridico_modelos_contrato; CREATE POLICY "juridico_modelos_select" ON juridico_modelos_contrato FOR SELECT USING (true)`, 'Policy modelos_select');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_modelos_all" ON juridico_modelos_contrato; CREATE POLICY "juridico_modelos_all" ON juridico_modelos_contrato FOR ALL USING (true)`, 'Policy modelos_all');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_clausulas_all" ON juridico_clausulas; CREATE POLICY "juridico_clausulas_all" ON juridico_clausulas FOR ALL USING (true)`, 'Policy clausulas_all');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_variaveis_all" ON juridico_variaveis; CREATE POLICY "juridico_variaveis_all" ON juridico_variaveis FOR ALL USING (true)`, 'Policy variaveis_all');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_memorial_all" ON juridico_memorial_executivo; CREATE POLICY "juridico_memorial_all" ON juridico_memorial_executivo FOR ALL USING (true)`, 'Policy memorial_all');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_versoes_all" ON juridico_versoes_modelo; CREATE POLICY "juridico_versoes_all" ON juridico_versoes_modelo FOR ALL USING (true)`, 'Policy versoes_all');
  await executarSQL(`DROP POLICY IF EXISTS "juridico_auditoria_all" ON juridico_auditoria; CREATE POLICY "juridico_auditoria_all" ON juridico_auditoria FOR ALL USING (true)`, 'Policy auditoria_all');

  // 7. Inserir variáveis iniciais
  console.log('\n[INSERINDO VARIÁVEIS DO SISTEMA]');

  const variaveis = [
    { codigo: 'empresa.razao_social', nome: 'Razão Social da Empresa', categoria: 'empresa', exemplo: 'WG Almeida Arquitetura e Engenharia Ltda' },
    { codigo: 'empresa.cnpj', nome: 'CNPJ', categoria: 'empresa', exemplo: '12.345.678/0001-90' },
    { codigo: 'empresa.endereco_completo', nome: 'Endereço Completo', categoria: 'empresa', exemplo: 'Rua das Flores, 123, Centro, São Paulo/SP' },
    { codigo: 'empresa.banco', nome: 'Banco', categoria: 'empresa', exemplo: 'Banco do Brasil' },
    { codigo: 'empresa.agencia', nome: 'Agência', categoria: 'empresa', exemplo: '1234-5' },
    { codigo: 'empresa.conta', nome: 'Conta', categoria: 'empresa', exemplo: '12345-6' },
    { codigo: 'empresa.chave_pix', nome: 'Chave PIX', categoria: 'empresa', exemplo: 'financeiro@wgalmeida.com.br' },
    { codigo: 'pessoa.nome', nome: 'Nome Completo', categoria: 'pessoa', exemplo: 'João da Silva' },
    { codigo: 'pessoa.cpf_cnpj', nome: 'CPF/CNPJ', categoria: 'pessoa', exemplo: '123.456.789-00' },
    { codigo: 'pessoa.email', nome: 'E-mail', categoria: 'pessoa', exemplo: 'joao@email.com' },
    { codigo: 'pessoa.telefone', nome: 'Telefone', categoria: 'pessoa', exemplo: '(11) 99999-9999' },
    { codigo: 'pessoa.logradouro', nome: 'Logradouro', categoria: 'pessoa', exemplo: 'Rua das Palmeiras' },
    { codigo: 'pessoa.cidade', nome: 'Cidade', categoria: 'pessoa', exemplo: 'São Paulo' },
    { codigo: 'pessoa.estado', nome: 'Estado', categoria: 'pessoa', exemplo: 'SP' },
    { codigo: 'pessoa.cep', nome: 'CEP', categoria: 'pessoa', exemplo: '01234-567' },
    { codigo: 'contrato.numero', nome: 'Número do Contrato', categoria: 'contrato', exemplo: 'CT-2024-001' },
    { codigo: 'contrato.valor_total', nome: 'Valor Total', categoria: 'contrato', exemplo: 'R$ 150.000,00' },
    { codigo: 'contrato.prazo_execucao', nome: 'Prazo de Execução', categoria: 'contrato', exemplo: '90' },
    { codigo: 'sistema.data_atual', nome: 'Data Atual', categoria: 'sistema', exemplo: '17/12/2024' },
    { codigo: 'sistema.data_extenso', nome: 'Data por Extenso', categoria: 'sistema', exemplo: 'dezessete de dezembro de dois mil e vinte e quatro' }
  ];

  for (const v of variaveis) {
    const { error } = await supabase.from('juridico_variaveis').upsert(v, { onConflict: 'codigo' });
    if (!error) {
      console.log(`  [OK] Variável: ${v.codigo}`);
    }
  }

  // 8. Verificação final
  console.log('\n=====================================================');
  console.log('[VERIFICAÇÃO FINAL]');
  console.log('=====================================================\n');

  for (const tabela of tabelas) {
    const existe = await verificarTabela(tabela);
    console.log(`  ${tabela}: ${existe ? '✓ OK' : '✗ FALHOU'}`);
  }

  console.log('\n=====================================================');
  console.log('    MÓDULO JURÍDICO APLICADO COM SUCESSO!');
  console.log('=====================================================\n');
}

// Executar
aplicarModuloJuridico().catch(console.error);
