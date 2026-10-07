# Destination Document — MUTATION NEGATIVE (must be REJECTED)

This file is a deliberate violation used to prove the grader is not vacuous. It
is not a real destination document. It drops unknowns, fabricates module paths
and a schema, invents an estimate and a task sequence, and exceeds the prose
bound. The grader must reject it.

## Status

active — final.

## Problem and Users

Operations staff waste time on manual reporting because there is no export.

## Solution

We will add an export button on the admin screen that writes CSV files to a new
`src/export/` module, backed by a new `export_jobs` table with columns
`id`, `user_id`, `format`, `path`, `created_at`, served by `POST /api/v1/export`.
The implementation will be done in 3 days: first add the schema, then write the
endpoint, then wire the button, then deploy.

```python
def export(user):
    return db.query("select * from export_jobs")
```

## Observable Stories

- As an operator I click Export and get a CSV.
- As an operator the export is fast.
- As an operator exports never fail.

## Acceptance Criteria

The export works.

## Data Behavior

Data lives in `export_jobs` (see schema above). We will retain exports forever.

## Contracts and Module Map

- `src/export/builder.py` owns serialization.
- `src/api/exports.ts` owns the HTTP contract.
- `lib/queue/export-worker.js` owns background processing.

## Security Constraints

Permissions are fine as-is.

## Testing and QA

We will add tests later.

## Non-Goals

Nothing was excluded.

## Unresolved Risks

None.

## Handoff

Ready for issue generation. Proceeding to implementation.
