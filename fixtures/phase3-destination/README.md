# Phase 3 fixture: destination documents (`write-prd`)

## What this is

Six **authored walkthroughs** of the `write-prd` skill: one confirmed alignment
record (input) and the destination document the skill is expected to produce from
it (output). They exist so the grader has a concrete corpus to check structural
properties of the skill's contract — required headings, preservation of labels and
negative decisions, refusal to fabricate, prose proportionality.

## What this is NOT

These are **not** recorded agent runs. No OpenCode session produced these
documents; they were written by hand while porting the skill, following the
skill's rules. They demonstrate that the skill's contract is satisfiable and
gradeable, not that a live agent reliably satisfies it. Phase 2's
`fixtures/phase2-alignment/live-human-run.md` is the precedent for emergent
evidence; this suite has no equivalent. That gap is recorded in
`HARNESS-PHASE-3-VALIDATION.md` and in the roadmap tracker.

## Layout

```text
inputs/    confirmed alignment records (the only permitted input)
outputs/   the destination documents the skill yields from those inputs
cases/mutation-negative.md   deliberately bad document, used to prove the grader
                             actually rejects violations
run-validation.sh            grader; writes case-results.jsonl
```

## Cases

| Case | Gate property under test |
|---|---|
| `unconfirmed-guard` | refuses to write without explicit human confirmation |
| `small-feature` | non-goals, persistence, failure behavior, `UNKNOWN` pagination, `HITL` |
| `data-change` | atomic migration, backup/rollback, API compatibility, unknown module map |
| `api-integration` | unselected provider kept unresolved, bounded `RESEARCH` branch preserved |
| `frontend-workflow` | roles, async delivery, duplicate handling, testing unknowns |
| `prototype-branch` | stays `RESEARCH`, disposable data, does not become production scope |
| `mutation-negative` | grader is not vacuous: a violating document must be rejected |

## Running

```bash
fixtures/phase3-destination/run-validation.sh
```

Exit 0 means every case met its expectation (including the mutation case being
rejected). Results land in `case-results.jsonl`, one JSON object per line.
