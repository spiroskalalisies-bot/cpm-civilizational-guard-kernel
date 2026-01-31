
BEGIN;

-- Valid commit (PASS)
SELECT cpm.cpm_commit(
  gen_random_uuid(),
  '{"test":"ok"}',
  'human:test',
  interval '1 minute'
);

-- Illegal update (FAIL)
DO $$ BEGIN
  BEGIN
    UPDATE cpm.authority_event SET committed_by='AI';
    RAISE EXCEPTION 'FAIL';
  EXCEPTION WHEN OTHERS THEN NULL;
  END;
END $$;

ROLLBACK;
