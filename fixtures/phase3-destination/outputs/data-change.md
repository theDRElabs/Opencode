# Destination Document — Rename `customer` to `account`

## Status

`active`. Destination and definition of done only.

## Problem and Users

The entity is named inconsistently across storage, code, and the public API.
Operations staff and integrators both depend on the current name.

- Users: internal operations staff on admin screens; integrators on the public
  API.
- Success: internal naming is `account` everywhere, the public API keeps
  accepting `customer` until integrators migrate, and the rename is reversible.

## Solution

An atomic, transactional rename of the entity in storage and internal code, with
legacy naming preserved at the public API boundary.

## Observable Stories

- As an operations user I see the same admin behavior after the rename, so the
  rename is invisible to my work.
- As an integrator my existing `customer` calls keep working, so I can migrate
  on my own schedule.
- As the data owner I can stop a migration safely, so a bad run cannot leave
  half-renamed state.

## Acceptance Criteria

1. The migration is atomic and transactional: it either completes fully or
   leaves the previous state intact.
2. A verified backup exists before migration changes begin.
3. Conflicts or unexpected dependencies abort the migration before any change is
   made.
4. Rollback restores the pre-migration state from the verified backup.
5. Legacy `customer` naming remains supported at the public API boundary until
   all clients migrate.
6. Admin screen behavior is unchanged by the rename.
7. The migration writes an audit record of what changed.
8. A rollback rehearsal on a copy passes before the production run.
9. Retirement of the legacy public API names is `HITL` — see Unresolved Risks.

## Data Behavior

- Source of truth: existing storage; the rename does not create a new store.
- Migration: atomic and transactional, preceded by a verified backup, aborted on
  conflict or unexpected dependency.
- Rollback: restore from the verified backup.
- Compatibility: internal naming becomes `account`; public API keeps `customer`.
- Audit evidence: the migration run records what changed.
- Approval gate: the data owner approves the migration window before it runs.
- Schema and storage layout: `UNKNOWN`. The alignment record deliberately did not
  specify a schema, so none is invented here.

## Contracts and Module Map

- Public contract: `customer` request and response names remain accepted at the
  API boundary.
- Internal contract: the entity identifier is named `account` in storage and
  internal code.
- Module boundaries and locations: `UNKNOWN`. No modules were named during
  alignment. No module paths are asserted.

## Security Constraints

- Authorization and authentication are unchanged by this destination.
- Sensitive data: unchanged set; the rename must not alter what is stored about
  a person.
- Trust boundary: unchanged.
- Abuse limits: not applicable.
- Audit: the migration run itself is auditable.

## Testing and QA

- Automated: pre-migration environment check; post-migration parity check
  confirming row-level equivalence and unchanged public API responses.
- Manual: rollback rehearsal on a copy; data-owner review of the migration
  window.
- Environments: production is the target; the alignment record named no staging
  environment. Unavailable checks are recorded rather than assumed.

## Non-Goals

- Behavior changes to admin screens.
- Data reshaping beyond the rename.
- Authentication or billing changes.
- Removing legacy public API names in this destination.

## Unresolved Risks

| Item | Label | Owner | Blocks |
|---|---|---|---|
| Migration window approval | `HITL` | data owner | production migration run |
| Legacy API name retirement timing | `HITL` | API owner | acceptance criterion 9 |
| Storage schema and module locations | `UNKNOWN` | unassigned | any future issue generation |

## Handoff

Ready for human review. Not ready for issue generation until a human accepts it
and the two `HITL` items are decided or explicitly deferred.
