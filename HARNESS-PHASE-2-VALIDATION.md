# Phase 2 Validation: Alignment Workflow (grill-me)

Date: 2026-10-06
Method: artifact creation plus a structural gate check over five recorded
walkthrough transcripts.

## Artifacts

- Skill: `skills/grill-me/SKILL.md`
- Invocation command: `commands/grill-me.md` (no implementation permissions;
  it names the skill and forbids editing or planning).
- Fixture: `fixtures/phase2-alignment/`

## Observed fixture run

Command: `fixtures/phase2-alignment/run-validation.sh`
Log: `fixtures/phase2-alignment/case-results.jsonl`
Exit code: 0 (all five cases pass).

Per-case results (verbatim from `case-results.jsonl`):

```jsonl
{"suite":"phase2-alignment","case":"small-feature","expected":"gate-compliant transcript","actual":"gate-compliant","score":1,"status":"pass","duration_s":0,"evidence":".../transcripts/small-feature.md","known_fail":false,"timestamp":"2026-10-06T23:23:44Z"}
{"suite":"phase2-alignment","case":"ambiguous-data-change","expected":"gate-compliant transcript","actual":"gate-compliant","score":1,"status":"pass","duration_s":0,"evidence":".../transcripts/ambiguous-data-change.md","known_fail":false,"timestamp":"2026-10-06T23:23:44Z"}
{"suite":"phase2-alignment","case":"api-integration","expected":"gate-compliant transcript","actual":"gate-compliant","score":1,"status":"pass","duration_s":0,"evidence":".../transcripts/api-integration.md","known_fail":false,"timestamp":"2026-10-06T23:23:44Z"}
{"suite":"phase2-alignment","case":"frontend-workflow","expected":"gate-compliant transcript","actual":"gate-compliant","score":1,"status":"pass","duration_s":0,"evidence":".../transcripts/frontend-workflow.md","known_fail":false,"timestamp":"2026-10-06T23:23:44Z"}
{"suite":"phase2-alignment","case":"prototype-branch","expected":"gate-compliant transcript","actual":"gate-compliant","score":1,"status":"pass","duration_s":0,"evidence":".../transcripts/prototype-branch.md","known_fail":false,"timestamp":"2026-10-06T23:23:44Z"}
```

(Timestamps above show the first passing run of the script; the committed
`case-results.jsonl` holds the current run's verbatim lines.)

## What each case demonstrates

- `small-feature`: one-question-at-a-time with recommended answers; invalid
  input behavior and non-goals decided; no edits.
- `ambiguous-data-change`: unresolved parsing behavior labeled UNKNOWN and
  assigned to a bounded research branch; in-place rewrite rejected; HITL
  named; no migration written.
- `api-integration`: contract/idempotency/retry/token decisions; stub-server
  spike scoped as RESEARCH; no implementation started.
- `frontend-workflow`: user base marked ASSUMED; localStorage fallback
  decided; testing split into automated + manual QA; no component edited.
- `prototype-branch`: prototype bounded with hypothesis, budget, success
  signal, cleanup, and an explicit guardrail against touching production;
  no prototype executed.

Each transcript is graded structurally for: a recommended answer per
question, one question per turn, an alignment record with DECIDED / ASSUMED
/ UNKNOWN / HITL / RESEARCH labels, an explicit stop condition, and an
explicit no-edit attestation.

## Honest limits

- The five sessions are authored walkthrough transcripts, not live agent
  sessions. The grader is a structural check over those transcripts; it does
  not observe emergent model behavior.
- No live `/grill-me` session has yet been recorded in this repo, so the
  completion gate is NOT met as written. Remaining gap: run `/grill-me`
  live against the five scenario types and confirm, from real transcripts,
  that the interview surfaces decision questions without planning or
  editing. Until then Phase 2 stays `in_progress`.
- The skill and command files mirror `opencode-config` so the artifact is
  consistent with the installed configuration; no config change was made in
  this phase.
