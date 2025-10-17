\set ON_ERROR_STOP on
-- Orquestrador com caminhos absolutos (funciona de qualquer lugar)

DROP SCHEMA IF EXISTS prj5 CASCADE;

\i /sql/01_SCHEMA_E_PAPEIS.sql
\i /sql/02_TIPOS_E_SEQUENCES.sql
\i /sql/03_TABELAS_NEGOCIAIS_E_RL.sql
\i /sql/04_AUDITORIA_TRIGGERS.sql
\i /sql/05_INDICES_E_CONSTRAINTS.sql
\i /sql/06_EVENT_TRIGGER_MAD1.sql
\i /sql/07_VIEWS_E_MV.sql
\i /sql/08_SEED_MINIMA.sql
