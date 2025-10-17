SET search_path TO public;

CREATE SCHEMA IF NOT EXISTS prj5;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='role_dba') THEN CREATE ROLE ROLE_DBA; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='role_sistema') THEN CREATE ROLE ROLE_SISTEMA; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='role_analise') THEN CREATE ROLE ROLE_ANALISE; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='role_backup') THEN CREATE ROLE ROLE_BACKUP; END IF;
END$$;

GRANT USAGE ON SCHEMA prj5 TO ROLE_SISTEMA, ROLE_ANALISE, ROLE_BACKUP;

-- Define o search_path padrão do banco (vale para novas conexões)
ALTER DATABASE prj5_db SET search_path TO prj5, public;

-- Garante também para esta sessão
SET search_path TO prj5;

-- Contexto de auditoria (PPP1/MAD)
CREATE OR REPLACE FUNCTION SP_SET_CONTEXT_USUARIO_APLICACAO(p_usuario TEXT)
RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
  PERFORM set_config('application.user', COALESCE(p_usuario,'desconhecido'), false);
END$$;
