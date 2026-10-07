# Input: confirmed alignment record (data change)

Confirmed by the human on 2026-10-05.

## Record

- Request: rename the `customer` entity to `account` across storage and code.
  [DECIDED]
- Users: internal operations staff using the customer-facing admin screens, and
  integrators calling the public API. [DECIDED]
- Data behavior: the migration is atomic and transactional. [DECIDED]
- Data behavior: a verified backup is taken before any change begins. [DECIDED]
- Data behavior: conflicts or unexpected dependencies abort the migration before
  changes are made. [DECIDED]
- Data behavior: rollback restores the pre-migration state from the verified
  backup. [DECIDED]
- Compatibility: legacy `customer` naming stays supported at the public API
  boundary until all integrators migrate. [DECIDED]
- Compatibility: internal storage naming changes as part of the migration.
  [DECIDED]
- Evidence: migration runs write an audit record of what changed. [DECIDED]
- Approval: the data owner approves the migration window before it runs.
  [HITL] — not yet granted.
- Retirement of the legacy public API names: [HITL] — the API owner decides
  when; no date agreed.
- Module map: not established in the interview. [UNKNOWN]
- Schema: deliberately not specified at alignment time. [UNKNOWN]
- Testing: pre-migration environment check, post-migration parity check, and a
  rollback rehearsal on a copy. [DECIDED]
- Non-goal: no behavior change to admin screens; no data reshaping beyond the
  rename; no change to authentication or billing. [DECIDED]
