# Test Notes (Execution Friction Only)

This file records practical issues encountered while executing smoke tests.
It is not a design document.

## Environment Notes
- PostgreSQL version sensitivity (extensions, permissions)
- Termux package availability differences
- File path assumptions

## Observed Frictions
- Extension loading order matters
- Role permissions must exist before kernel.sql execution
- ROLLBACK required to keep tests non-mutating

## Non-Issues
- No authority mutation observed
- No silent commit paths detected
