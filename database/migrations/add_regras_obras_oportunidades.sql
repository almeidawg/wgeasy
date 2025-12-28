-- Migration: Adicionar campos de Regras de Obras em Oportunidades
-- Data: 2024-12-17

-- Adicionar colunas de regras de obras na tabela oportunidades
ALTER TABLE oportunidades
ADD COLUMN IF NOT EXISTS condominio_nome VARCHAR(255),
ADD COLUMN IF NOT EXISTS condominio_contato VARCHAR(255),
ADD COLUMN IF NOT EXISTS obra_seg_sex_entrada TIME,
ADD COLUMN IF NOT EXISTS obra_seg_sex_saida TIME,
ADD COLUMN IF NOT EXISTS obra_sab_entrada TIME,
ADD COLUMN IF NOT EXISTS obra_sab_saida TIME,
ADD COLUMN IF NOT EXISTS obra_regras_obs TEXT;

-- Comentários para documentação
COMMENT ON COLUMN oportunidades.condominio_nome IS 'Nome do condomínio onde será realizada a obra';
COMMENT ON COLUMN oportunidades.condominio_contato IS 'Contato do condomínio (síndico, portaria, telefone)';
COMMENT ON COLUMN oportunidades.obra_seg_sex_entrada IS 'Horário de entrada permitido Segunda a Sexta';
COMMENT ON COLUMN oportunidades.obra_seg_sex_saida IS 'Horário de saída permitido Segunda a Sexta';
COMMENT ON COLUMN oportunidades.obra_sab_entrada IS 'Horário de entrada permitido Sábado';
COMMENT ON COLUMN oportunidades.obra_sab_saida IS 'Horário de saída permitido Sábado';
COMMENT ON COLUMN oportunidades.obra_regras_obs IS 'Observações sobre as regras de obra do condomínio';
