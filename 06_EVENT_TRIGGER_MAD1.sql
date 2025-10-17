SET search_path TO prj5;

CREATE OR REPLACE FUNCTION FC_VALIDA_NOME_OBJETO()
RETURNS event_trigger LANGUAGE plpgsql AS $$
DECLARE
  r record;
  v_nome TEXT;
  v_tipo TEXT;
  v_norm TEXT; -- nome normalizado para MAIÚSCULO
BEGIN
  FOR r IN SELECT * FROM pg_event_trigger_ddl_commands() LOOP
    v_tipo := r.object_type;

    -- Validamos só estes tipos (ignora função, tipo, schema, etc.)
    IF v_tipo NOT IN ('table','index','sequence','trigger','view','constraint') THEN
      CONTINUE;
    END IF;

    -- Extrai apenas o identificador simples (sem schema/assinatura)
    v_nome := split_part(r.object_identity, ' ', 1);
    v_nome := regexp_replace(v_nome, '^[^\.]*\.', '');
    v_nome := regexp_replace(v_nome, '\(.*\)$', '');

    -- Normaliza para checar contra o MAD (permite criar sem aspas)
    v_norm := UPPER(v_nome);

    -- Regras gerais
    IF length(v_nome) > 30 THEN
      RAISE EXCEPTION 'Nome "%" viola MAD1: excede 30 caracteres', v_nome;
    END IF;
    IF v_norm !~ '^[A-Z0-9_]+' THEN
      RAISE EXCEPTION 'Nome "%" viola MAD1: deve conter apenas [A-Z0-9_]', v_nome;
    END IF;

    -- Regras por tipo (sobre v_norm)
    IF v_tipo = 'table' THEN
      IF v_norm !~ '^(TB_|RL_|TH_|TL_|TA_)' THEN
        RAISE EXCEPTION 'Tabela "%" viola MAD1: prefixo TB_/RL_/TH_/TL_/TA_', v_nome;
      END IF;
    ELSIF v_tipo = 'index' THEN
      IF v_norm !~ '^IDX_' THEN
        RAISE EXCEPTION 'Índice "%" viola MAD1: prefixo IDX_', v_nome;
      END IF;
    ELSIF v_tipo = 'sequence' THEN
      IF v_norm !~ '^SQ_' THEN
        RAISE EXCEPTION 'Sequence "%" viola MAD1: prefixo SQ_', v_nome;
      END IF;
    ELSIF v_tipo = 'trigger' THEN
      IF v_norm !~ '^TG_[AB]_[IUD]_' THEN
        RAISE EXCEPTION 'Trigger "%" viola MAD1: prefixo TG_[A/B]_[I/U/D]_', v_nome;
      END IF;
    ELSIF v_tipo = 'view' THEN
      IF v_norm !~ '^(VW_|VM_)' THEN
        RAISE EXCEPTION 'View "%" viola MAD1: prefixo VW_/VM_', v_nome;
      END IF;
    ELSIF v_tipo = 'constraint' THEN
      IF v_norm !~ '^(PK_|FK_|UK_|CK_|DF_|NN_|IDX_|CC_)' THEN
        RAISE EXCEPTION 'Constraint "%" viola MAD1: prefixo PK_/FK_/UK_/CK_/DF_/NN_/IDX_/CC_', v_nome;
      END IF;
    END IF;
  END LOOP;
END$$;

DROP EVENT TRIGGER IF EXISTS TG_A_DDL_VALIDA_NOMES;
CREATE EVENT TRIGGER TG_A_DDL_VALIDA_NOMES
  ON ddl_command_end
  EXECUTE PROCEDURE FC_VALIDA_NOME_OBJETO();
