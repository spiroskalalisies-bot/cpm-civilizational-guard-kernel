-- Identical to desktop smoke test
BEGIN;

SELECT cpm.cpm_commit(
  gen_random_uuid(),
  '{"mobile":"ok"}',
  'human:mobile',
  interval '1 minute'
);

ROLLBACK;
