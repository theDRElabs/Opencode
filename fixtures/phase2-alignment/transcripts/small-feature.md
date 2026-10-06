# Fixture Session 1: Small Feature

Request: "Add a --days N option to token-report.js."

## Interview

**Turn 1 — Question:** Who is the user of
`--days N` and what does success look like? (highest-value missing decision.) Recommended: a maintainer running
manual audits; success = flag changes the reported window reproducibly. Reason:
bounds testing and output format. User: confirmed recommendation.

**Turn 2 — Question:** How should invalid values (0, negative, non-integer)
behave? Recommended: exit non-zero with a usage error, no partial output.
Reason: silent clamping hides typos. User: agreed.

**Turn 3 — Question:** Should `--days` combine with existing flags?
Recommended: yes, it filters the same dataset the other flags read. Reason:
keeps one source of truth. User: agreed.

**Turn 4 — Question:** Out of scope? Recommended: no new output columns, no
schema change to usage.json. User: agreed.

**Turn 5 — Question:** Testing expectation? Recommended: one fixture case with
`--days 2` plus an invalid-value case; no manual QA needed (CLI). User: agreed.

**Turn 6 — Question:** Unresolved risks? User identifies none beyond the
invalid-value case.

## Alignment Record

- Request: add `--days N` to token-report.js.
- User/success: maintainer audits; window changes reproducibly. [DECIDED]
- Invalid values: exit non-zero, usage error, no partial output. [DECIDED]
- Composition: filters the same dataset as other flags. [DECIDED]
- Non-goals: no new columns, no schema change. [DECIDED]
- Testing: two fixture cases, no manual QA. [DECIDED]
- Unresolved risks: none. [DECIDED]

Stop condition met: all applicable areas decided, success concrete, non-goals
recorded, no HITL items. No files edited, no plan written.
