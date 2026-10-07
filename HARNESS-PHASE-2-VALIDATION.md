# Phase 2 Validation: Alignment Workflow (grill-me)

Date: 2026-10-06 (updated 2026-10-07 with the emergent human run)
Method: artifact creation plus a structural gate check over five recorded
walkthrough transcripts; a simulated `/grill-me` transcript
(`fixtures/phase2-alignment/live-transcript-sample.md`); and an emergent,
human-driven `/grill-me` run in the TUI (session
`ses_ee85bf5a3ffeJVTaFQTbsagVBC`) extracted from the local session database into
`fixtures/phase2-alignment/live-human-run.md`, checked field-by-field against that
database by an independent verifier.

## Artifacts

- Skill: `skills/grill-me/SKILL.md`
- Invocation command: `commands/grill-me.md` (no implementation permissions;
  it names the skill and forbids editing or planning).
- Fixture: `fixtures/phase2-alignment/`

## Observed fixture run

Command: `fixtures/phase2-alignment/run-validation.sh`
Log: `fixtures/phase2-alignment/case-results.jsonl`
Exit code: 0 (all five cases pass).

Per-case results from the first passing run (not the committed file):

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

- A live transcript now exists: `fixtures/phase2-alignment/live-transcript-sample.md`
  — a 2026-10-07 simulated live `/grill-me` session (export-to-CSV button).
  It follows the skill rules verbatim: 13 turns, one question per turn, each
  with a provisional recommended answer and reason, all required decision
  areas covered (user, workflow, boundaries, edge cases, data behavior,
  security, integrations, testing, risks), HITL/UNKNOWN items explicitly
  assigned, stop conditions recorded, and no edits attested. It passes the
  same structural grader checks the authored transcripts pass (verified by
  re-running the grader's grep contract against it: recommended-answer
  present, alignment record with labels, stop condition, turn/question count
  match 13/13, no-edit attestation). It is honest about being a simulated
  live session, not an emergent real-agent run.
- **Emergent real-agent run recorded 2026-10-07.** A human ran `/grill-me` live
  in the TUI (session `ses_ee85bf5a3ffeJVTaFQTbsagVBC`, title "Grill Me Session").
  The transcript was extracted from the local session database into
  `fixtures/phase2-alignment/live-human-run.md`: 28 `question`-tool calls (25 with
  a recorded human choice, 3 that never rendered), 4 assistant messages, and an
  appendix listing every other tool call in the session (including one out-of-scope
  environment inspection at seq 272 and the alignment-record write at seq 281). The interview covered platform, injection mechanism, STT
  engine, permissions, data/privacy, acceptance bar, and unresolved risks; it
  flagged a real downgrade (clipboard-paste instead of true typing), recorded
  `ASSUMED`/`HITL` items, handled an accidental-tap correction by discarding and
  re-asking, wrote an alignment record, and explicitly did not plan or implement.
  This is the previously-missing emergent evidence.
- The five authored sessions remain structural walkthroughs; the grader remains a
  structural check. They complement rather than replace the emergent run.
- Findings this run surfaced against the skill itself, recorded not hidden:
  1. 5 of 28 questions (#10, #11, #12, #14, #25) offered options with no
     `(Recommended)` label, violating `SKILL.md` rule 3.
  2. 3 question calls never rendered (2 schema errors, 1 dismissal).
  3. One out-of-scope shell call inspected `~/.claude/memory/` mid-interview.
  4. The alignment record was written pre-confirmation and self-declared
     "confirmed by user"; its status line was corrected after verification.
- Residual limit: the emergent run is a single session, so it demonstrates the
  behavior once rather than establishing a rate.
- The skill and command files mirror `opencode-config` so the artifact is
  consistent with the installed configuration; no config change was made in
  this phase.
