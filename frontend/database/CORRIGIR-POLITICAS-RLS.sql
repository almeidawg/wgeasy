DROP POLICY IF EXISTS "Permitir tudo para autenticados" ON categorias_compras;
DROP POLICY IF EXISTS "Permitir tudo para autenticados" ON produtos_complementares;
DROP POLICY IF EXISTS "Permitir tudo para autenticados" ON projetos_compras;
DROP POLICY IF EXISTS "Permitir tudo para autenticados" ON projeto_quantitativo;
DROP POLICY IF EXISTS "Permitir tudo para autenticados" ON projeto_lista_compras;
DROP POLICY IF EXISTS "Permitir tudo para autenticados" ON fluxo_financeiro_compras;

ALTER TABLE categorias_compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_complementares ENABLE ROW LEVEL SECURITY;
ALTER TABLE projetos_compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE projeto_quantitativo ENABLE ROW LEVEL SECURITY;
ALTER TABLE projeto_lista_compras ENABLE ROW LEVEL SECURITY;
ALTER TABLE fluxo_financeiro_compras ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Permitir tudo para autenticados" ON categorias_compras FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Permitir tudo para autenticados" ON produtos_complementares FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Permitir tudo para autenticados" ON projetos_compras FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Permitir tudo para autenticados" ON projeto_quantitativo FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Permitir tudo para autenticados" ON projeto_lista_compras FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Permitir tudo para autenticados" ON fluxo_financeiro_compras FOR ALL USING (auth.role() = 'authenticated');
