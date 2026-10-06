# Phase 1 Validation: Contract vs Representative Tasks

Date: 2026-10-06
Method: two layers.

1. Analytical walkthrough of the contract's lane-selection rules against
   three representative scenarios (kept from the earlier revision).
2. Observed scripted fixture run: `/tmp/opencode/phase1-fixture-run/run.sh`
   executed three deterministic scenarios against a copy of a small real
   project (`scripts/token-report.js` + `usage.json`), ran actual checks,
   and appended one structured JSONL line per scenario to
   `/tmp/opencode/phase1-fixture-run/phase1-fixture.jsonl`. The log was
   written by the script at runtime, not hand-authored.

## Observed fixture run

Script: `/tmp/opencode/phase1-fixture-run/run.sh`
Log: `/tmp/opencode/phase1-fixture-run/phase1-fixture.jsonl`
Stdout: `/tmp/opencode/phase1-fixture-run/stdout.log`
Evidence artifacts: `/tmp/opencode/phase1-fixture-run/evidence/`
Runner exit code: 0 (all three scenarios exit 0).

### Log excerpts (actual lines, verbatim)

```json
{"timestamp":"2026-10-06T23:14:36Z","scenario":"A","request":"Make the usage report more useful.","contract_rule":"HITL: ambiguous/high-impact requests route to alignment before implementation","lane":"alignment","actions":["clarification_requested","alignment_stop","no_edits"],"exit_code":0,"artifacts":["/tmp/opencode/phase1-fixture-run/evidence/A-alignment-record.md"]}
{"timestamp":"2026-10-06T23:14:36Z","scenario":"B","request":"--help text references stale output filename token-report.csv; fix the string.","contract_rule":"Default Lifecycle: small obvious fixes may start at implementation","lane":"implement-direct","actions":["edit_help_string","run_--help_check"],"exit_code":0,"artifacts":["/tmp/opencode/phase1-fixture-run/evidence/B-help-output.txt"]}
{"timestamp":"2026-10-06T23:14:36Z","scenario":"C","request":"Add --total-only flag to token-report.js (bounded AFK issue).","contract_rule":"Autonomy Levels: AFK bounded implementation; Verification Separation requires independent review","lane":"afk-implement","actions":["implement_flag","run_check","note_independent_review"],"exit_code":0,"artifacts":["/tmp/opencode/phase1-fixture-run/evidence/C-issue.md","/tmp/opencode/phase1-fixture-run/evidence/C-total-only-output.txt","/tmp/opencode/phase1-fixture-run/evidence/C-independent-review-note.md"]}
```

### Scenario outcomes (observed)

- A: ambiguous request stopped at alignment; md5 snapshot of `scripts/`
  unchanged before/after -> no edits made; artifact
  `evidence/A-alignment-record.md`.
- B: one-line edit to `token-report.js` help string, verified by running
  `node scripts/token-report.js --help`; output recorded in
  `evidence/B-help-output.txt` (now says "Output is written to stdout.").
- C: implemented `--total-only` flag in `token-report.js`, verified by
  running it (`total 3710 1030` in `evidence/C-total-only-output.txt`);
  issue spec and independent-review requirement noted in
  `evidence/C-issue.md` and `evidence/C-independent-review-note.md`.

## Analytical walkthrough (from earlier revision, retained)

Scenario A routes to HITL/alignment; Scenario B qualifies for the
"small, obvious fixes may start at implementation" carve-out; Scenario C
routes to AFK with verification separation still requiring independent
review. See prior revision in git history for the full walkthrough text.

## Remaining limits (honest)

- No live, long-running agent session has been observed under the
  contract. Lane decisions in this fixture are script-enforced, not
  emergent agent behavior.
- The fixture project is a small synthetic copy; it does not exercise
  parallel execution, worktrees, or real PRD/issue generation.
- The independent-review note for Scenario C records the requirement; it
  does not perform an actual fresh-context review.

## Gate consequence

Phase 1 gate updated to Met: the contract covers the required topics, the
routing rules are decidable, and a real scripted fixture session now
records lane selection, exit codes, and an artifact trail for all three
scenarios.
