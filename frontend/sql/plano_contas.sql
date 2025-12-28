-- =====================================================
-- PLANO DE CONTAS - PADRAO CONTABIL/FISCAL
-- Estrutura: Classe.Nucleo.Subgrupo.Item
-- Empresa: Grupo WG Almeida
-- =====================================================

-- 1. TABELA DE NUCLEOS (Centros de Custo)
-- Se a tabela ja existe, alterar o campo icone
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'fin_nucleos' AND column_name = 'icone') THEN
    ALTER TABLE fin_nucleos ALTER COLUMN icone TYPE VARCHAR(50);
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS fin_nucleos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  codigo VARCHAR(10) NOT NULL UNIQUE,
  nome VARCHAR(100) NOT NULL,
  icone VARCHAR(50),
  cor VARCHAR(20) DEFAULT '#F25C26',
  ordem INTEGER DEFAULT 1,
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_fin_nucleos_codigo ON fin_nucleos(codigo);
CREATE INDEX IF NOT EXISTS idx_fin_nucleos_ordem ON fin_nucleos(ordem);

-- 2. TABELA DO PLANO DE CONTAS
CREATE TABLE IF NOT EXISTS fin_plano_contas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  codigo VARCHAR(20) NOT NULL UNIQUE,
  nome VARCHAR(200) NOT NULL,
  classe VARCHAR(20) NOT NULL CHECK (classe IN ('custo', 'despesa')),
  nucleo_id UUID REFERENCES fin_nucleos(id) ON DELETE CASCADE,
  tipo VARCHAR(20) DEFAULT 'variavel' CHECK (tipo IN ('fixo', 'variavel')),
  ativo BOOLEAN DEFAULT true,
  ordem INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_fin_plano_contas_codigo ON fin_plano_contas(codigo);
CREATE INDEX IF NOT EXISTS idx_fin_plano_contas_nucleo ON fin_plano_contas(nucleo_id);
CREATE INDEX IF NOT EXISTS idx_fin_plano_contas_classe ON fin_plano_contas(classe);

-- 3. TRIGGER PARA ATUALIZAR updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_fin_nucleos_updated_at ON fin_nucleos;
CREATE TRIGGER update_fin_nucleos_updated_at
  BEFORE UPDATE ON fin_nucleos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_fin_plano_contas_updated_at ON fin_plano_contas;
CREATE TRIGGER update_fin_plano_contas_updated_at
  BEFORE UPDATE ON fin_plano_contas
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 4. HABILITAR RLS (Row Level Security)
ALTER TABLE fin_nucleos ENABLE ROW LEVEL SECURITY;
ALTER TABLE fin_plano_contas ENABLE ROW LEVEL SECURITY;

-- Politicas permissivas
DROP POLICY IF EXISTS "Permitir leitura de nucleos" ON fin_nucleos;
CREATE POLICY "Permitir leitura de nucleos" ON fin_nucleos
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir insercao de nucleos" ON fin_nucleos;
CREATE POLICY "Permitir insercao de nucleos" ON fin_nucleos
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualizacao de nucleos" ON fin_nucleos;
CREATE POLICY "Permitir atualizacao de nucleos" ON fin_nucleos
  FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Permitir exclusao de nucleos" ON fin_nucleos;
CREATE POLICY "Permitir exclusao de nucleos" ON fin_nucleos
  FOR DELETE USING (true);

DROP POLICY IF EXISTS "Permitir leitura de plano_contas" ON fin_plano_contas;
CREATE POLICY "Permitir leitura de plano_contas" ON fin_plano_contas
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir insercao de plano_contas" ON fin_plano_contas;
CREATE POLICY "Permitir insercao de plano_contas" ON fin_plano_contas
  FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Permitir atualizacao de plano_contas" ON fin_plano_contas;
CREATE POLICY "Permitir atualizacao de plano_contas" ON fin_plano_contas
  FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Permitir exclusao de plano_contas" ON fin_plano_contas;
CREATE POLICY "Permitir exclusao de plano_contas" ON fin_plano_contas
  FOR DELETE USING (true);

-- Comentarios
COMMENT ON TABLE fin_nucleos IS 'Nucleos/Centros de Custo do Grupo WG Almeida';
COMMENT ON TABLE fin_plano_contas IS 'Plano de Contas - Padrao Contabil/Fiscal';
COMMENT ON COLUMN fin_plano_contas.classe IS 'custo = Classe 4 | despesa = Classe 5';
COMMENT ON COLUMN fin_plano_contas.tipo IS 'fixo = Custo/Despesa Fixo | variavel = Custo/Despesa Variavel';
