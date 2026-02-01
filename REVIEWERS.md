# Notes for Reviewers

This repository demonstrates an architectural boundary, not a policy system.

## What to Review
- The kernel enforces append-only, human-caused irreversible records.
- Smoke tests demonstrate that mutation paths are unreachable.
- Desktop and mobile executions show environment independence.

## What NOT to Review
- AI behavior, alignment, or cognition.
- Governance policies or ethical frameworks.
- Identity, cryptography, or distributed consensus.

## How to Verify
1. Inspect `kernel/kernel.sql`.
2. Run desktop smoke tests.
3. Confirm UPDATE/DELETE are rejected.
4. Confirm commits require human attribution.

## Claim Boundary
This work claims only:
- Separation of knowing from committing irreversible records.
- Structural prevention of authority emergence from intelligence.

No broader claims are made.
