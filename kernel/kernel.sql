-- CPM CIVILIZATIONAL GUARD KERNEL v1.3
-- STATUS: IRON_FROZEN

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS cpm;

CREATE TYPE IF NOT EXISTS cpm.event_type AS ENUM (
  'COMMIT',
  'ROLLBACK',
  'FINALIZE',
  'REJECT'
);

CREATE TABLE IF NOT EXISTS cpm.authority_event (
  id BIGSERIAL PRIMARY KEY,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  event_type cpm.event_type NOT NULL,
  commit_token UUID NOT NULL,
  event_token UUID NOT NULL UNIQUE,
  committed_by TEXT NOT NULL,
  payload JSONB NOT NULL,
  parent_event UUID REFERENCES cpm.authority_event(event_token)
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_commit_once
ON cpm.authority_event(commit_token)
WHERE event_type = 'COMMIT';

CREATE OR REPLACE FUNCTION cpm.forbid_mutation()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'CPM: authority ledger is append-only';
END;
$$;

DROP TRIGGER IF EXISTS trg_no_update ON cpm.authority_event;
CREATE TRIGGER trg_no_update
BEFORE UPDATE OR DELETE ON cpm.authority_event
FOR EACH ROW EXECUTE FUNCTION cpm.forbid_mutation();

CREATE OR REPLACE FUNCTION cpm.cpm_commit(
  commit_token UUID,
  mutation JSONB,
  human_id TEXT,
  contest_duration INTERVAL
) RETURNS UUID
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE evt UUID := gen_random_uuid();
BEGIN
  IF human_id IS NULL OR human_id = '' THEN
    INSERT INTO cpm.authority_event(event_type,commit_token,event_token,committed_by,payload)
    VALUES ('REJECT',commit_token,gen_random_uuid(),'SYSTEM',
            jsonb_build_object('violation','MISSING_HUMAN_ID'));
    RAISE EXCEPTION 'human_id required';
  END IF;

  INSERT INTO cpm.authority_event(event_type,commit_token,event_token,committed_by,payload)
  VALUES ('COMMIT',commit_token,evt,human_id,
          jsonb_build_object(
            'mutation_set',mutation,
            'contest_close',now()+contest_duration
          ));
  RETURN evt;
END;
$$;

COMMIT;
