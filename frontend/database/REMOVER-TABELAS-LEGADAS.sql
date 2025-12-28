-- ============================================
-- REMOVER TABELAS LEGADAS DE CRONOGRAMA
-- Data: 2024-12-27
-- Tabelas: projects, project_tasks
-- Motivo: Sistema migrou para projetos/cronograma_etapas
-- ============================================

-- Verificar dados antes de remover
SELECT 'projects' as tabela, COUNT(*) as registros FROM projects
UNION ALL
SELECT 'project_tasks' as tabela, COUNT(*) as registros FROM project_tasks;

-- Fazer backup se necessário (comentado por segurança)
-- CREATE TABLE _backup_projects AS SELECT * FROM projects;
-- CREATE TABLE _backup_project_tasks AS SELECT * FROM project_tasks;

-- Remover as tabelas legadas
DROP TABLE IF EXISTS project_tasks CASCADE;
DROP TABLE IF EXISTS projects CASCADE;

-- Verificar que foram removidas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('projects', 'project_tasks');
