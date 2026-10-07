# OpenCode AI Building Harness Roadmap

## Mission

Build a reliable AI software-development harness that turns human intent into
useful, maintainable, verified applications while preserving human control over
requirements, architecture, product taste, security-sensitive decisions, and
final acceptance.

The target workflow is:

```text
human intent
  -> alignment interview
  -> destination document
  -> dependency-aware vertical-slice backlog
  -> bounded implementation
  -> automated feedback
  -> fresh-context review
  -> human QA
  -> follow-up issues
  -> repeat
```

## Operating Rules

1. Read this file before starting or resuming harness work.
2. Work on the first phase whose status is `in_progress` or `pending`.
3. Do not start a later phase until the current phase passes its completion gate.
4. Update this file after every phase with status, evidence, decisions, and follow-ups.
5. Ask the user only for decisions that require human product judgment, preferences,
   credentials, approval of meaningful risk, or other unavailable information.
6. Prefer the smallest correct, inspectable component over a large framework.
7. Keep permanent context small; put specialized instructions in pull-based skills.
8. Separate planning, implementation, verification, and human acceptance.
9. Never let the agent that produced a substantial artifact be its sole verifier.
10. Establish a reliable manual workflow before automating it, and establish a
    reliable sequential workflow before parallelizing it.
11. Treat current code, tests, and maintained architecture documents as truth.
    Archive transient plans after completion so stale documents do not mislead agents.
12. Preserve unrelated user or agent changes in shared worktrees.

## Responsibility Boundaries

### Human owns

- Product intent and target users.
- Requirements and tradeoffs.
- Security-sensitive and irreversible decisions.
- Architecture and public module contracts.
- Visual and usability judgment.
- Final acceptance.

### Agents may own

- Focused repository exploration.
- Bounded implementation.
- Test creation and automated checks.
- First-pass independent review.
- Mechanical refactoring with explicit boundaries.
- Backlog updates when authorized.

### Repository owns

- Current implementation truth.
- Executable feedback loops.
- Maintained constraints and module contracts.
- Project-specific verification commands.

## Status Legend

- `pending`: not started.
- `in_progress`: current phase.
- `blocked`: requires a documented external decision or dependency.
- `completed`: implemented and independently verified against its gate.

## Phase Tracker

| Phase | Name | Status | Primary Artifact |
|---|---|---|---|
| 0 | Current Harness Audit | completed | `HARNESS-AUDIT.md` |
| 1 | Harness Contract | completed | `HARNESS-CONTRACT.md`, `HARNESS-PHASE-1-VALIDATION.md` |
| 2 | Alignment Workflow | completed | `grill-me` skill and command |
| 3 | Destination Documents | pending | `write-prd` skill and command |
| 4 | Backlog and Issue Contract | pending | `prd-to-issues` skill and issue schema |
| 5 | Project Feedback Contracts | pending | `HARNESS-PROJECT-FEEDBACK.md` and `HARNESS-PHASE-5-VALIDATION.md` |
| 6 | TDD and Bounded Implementer | pending | TDD skill and implementer agent |
| 7 | Fresh-Context Review | pending | independent reviewer workflow |
| 8 | Human QA and Visual Verification | pending | `HARNESS-PHASE-8-VALIDATION.md`, manual QA skill and browser workflow |
| 9 | Architecture Improvement | pending | architecture-audit skill |
| 10 | Sequential AFK Runner | pending | bounded sequential orchestrator and `HARNESS-PHASE-10-VALIDATION.md` |
| 11 | Sandboxing and Worktrees | pending | isolated execution environment |
| 12 | Parallel Execution | pending | dependency-aware parallel orchestrator |
| 13 | External Domain Skills | pending | skill consolidation (26 skills, merged design, removed security-scan) |
| 14 | Metrics and Improvement | pending | `HARNESS-METRICS.md` baseline + `scripts/collect-metrics.sh` |
| 15 | Results Contract v2 | pending | `fixtures/_lib/run-case.sh`, `metrics/history.jsonl` |
| 16 | Partial Credit | pending | `fixtures/_lib/RESULTS-CONTRACT.md`, scored fresh-review |
| 17 | Trials and Consistency | pending | `scripts/run-trials.sh`, `metrics/trials-*.json` |
| 18 | Token and Cost Accounting | pending | `scripts/token-report.sh`, history token totals |
| 19 | LLM-Judge Calibration | pending | `fixtures/fresh-review/calibration/`, `scripts/calibrate-judge.sh` |
| 20 | Real-Failure Sourcing | pending | `fixtures/_intake/`, 6 backfilled cases |
| 21 | Weekly Transcript Ritual | pending | `WEEKLY-REVIEW.md` |
| 22 | Eval-of-Evals | pending | `scripts/meta-validate.sh` |
| 23 | Self-Improvement Loop | pending | `scripts/harness-change-loop.sh`, proposal artifacts |

## Phase 0: Current Harness Audit

### Goal

Understand the current OpenCode setup before changing active behavior.

### Work

- Inventory global config, instructions, agents, commands, skills, plugins, MCPs,
  permissions, compaction, memory, and graph-memory components.
- Identify project-level overrides that affect normal work.
- Trace how a request currently moves from user input through context, tools,
  edits, verification, and completion.
- Classify components as keep, modify, replace, remove later, or investigate.
- Identify context bloat, role overlap, unsafe permissions, missing feedback, and
  stale-document risks.

### Deliverable

`~/.config/opencode/HARNESS-AUDIT.md`

### Completion Gate

The audit accurately explains the current request-to-code path, context sources,
permission boundaries, verification paths, and major gaps. A fresh verifier must
confirm the report using direct file evidence. No active configuration is changed.

## Phase 1: Harness Contract

### Goal

Create the short global contract that governs all later components.

### Work

- Define context-reset and task-sizing rules.
- Define human, agent, and repository responsibilities.
- Define phase boundaries and independent verification requirements.
- Define documentation lifecycle and stale-artifact handling.
- Decide which existing global instructions remain permanent and which become skills.
- Keep the contract concise enough to remain useful in every session.

### Completion Gate

Met — the contract covers context reset and task sizing, human/agent/
repository responsibilities, phase boundaries with independent verification,
documentation lifecycle, and the permanent-vs-skills decision; it is concise
(~140 lines) and does not restate `AGENTS.md` user rules. Observed scripted
fixture session exists (`HARNESS-PHASE-1-VALIDATION.md`):
`fixtures/phase1-contract/run.sh` ran three scenarios
(HITL-ambiguous, small obvious fix, AFK bounded), logged lane selection
for all three with exit 0s, and produced a real artifact trail in
fixtures/phase1-contract/phase1-fixture.jsonl and
`fixtures/phase1-contract/evidence/`. Remaining limits (not gate blockers): no live long-running
agent session has been observed, and lane decisions are script-enforced,
not emergent.

## Phase 2: Alignment Workflow

### Goal

Prevent silent requirement invention before substantial planning or coding.

### Work

- Create a custom `grill-me` skill.
- Ask one decision question at a time and provide a recommended answer.
- Cover user, problem, workflows, edge cases, data behavior, security, integrations,
  out-of-scope behavior, testing, and unresolved risks.
- Add explicit stop conditions and support research/prototype branches.
- Add an invocation command without granting implementation permissions.

### Completion Gate

Met — with a stated limit. Implemented: `skills/grill-me/SKILL.md`,
`commands/grill-me.md`, and `fixtures/phase2-alignment/` with five walkthrough
transcripts (small-feature, ambiguous-data-change, api-integration,
frontend-workflow, prototype-branch) graded by `run-validation.sh` (exit 0,
five pass lines in `case-results.jsonl`); a simulated session at
`fixtures/phase2-alignment/live-transcript-sample.md`; and an **emergent
real-agent run** at `fixtures/phase2-alignment/live-human-run.md`
(2026-10-07, session `ses_ee85bf5a3ffeJVTaFQTbsagVBC`) in which a human was
interviewed live in the TUI: 28 `question`-tool calls (25 with a recorded human
choice, 3 that never rendered), decision areas spanning platform, injection
mechanism, engine, permissions, data/privacy, acceptance, and risks; an
architecture downgrade surfaced and explicitly accepted (clipboard paste instead
of literal typing); `ASSUMED`/`HITL` items assigned; an accidental-tap answer
discarded and re-asked; an alignment record produced (written pre-confirmation;
its false "confirmed" status line was corrected after verification). Limits: a
single session demonstrates the behavior once rather than establishing a rate;
5 of 28 questions offered no `(Recommended)` option, violating the skill's own
rule 3; one out-of-scope environment inspection occurred mid-interview; and the
four remaining scenario types have authored transcripts only. Evidence in
`HARNESS-PHASE-2-VALIDATION.md`.

Fixture sessions for a small feature, ambiguous data change, API integration,
frontend workflow, and bounded prototype branch surface important missing
decisions without prematurely planning or editing code.

## Phase 3: Destination Documents

### Goal

Turn aligned decisions into a bounded destination and definition of done.

### Work

- Create a custom `write-prd` skill and command.
- Include problem, users, solution, observable stories, acceptance criteria, data
  behavior, contracts, module map, tests, security constraints, non-goals, rejected
  decisions, and risks.
- Preserve unknowns instead of fabricating certainty.
- Define active, completed, and archived PRD lifecycle.

### Completion Gate

Generated fixtures preserve negative decisions, migration behavior, module
boundaries, test expectations, and unresolved risks without excessive prose.

## Phase 4: Backlog and Issue Contract

### Goal

Convert destination documents into bounded, dependency-aware vertical slices.

### Work

- Define a machine-readable local Markdown issue schema.
- Include status, AFK/HITL type, blockers, outcome, acceptance criteria, vertical
  layers, module boundaries, tests, commands, constraints, and non-goals.
- Create a custom `prd-to-issues` skill and command.
- Reject horizontal layer plans and infrastructure without a validated consumer.
- Mark unsafe or unresolved work as human-in-the-loop.

### Completion Gate

Fixture PRDs produce observable vertical slices, correct blockers, genuine parallel
branches, and issues small enough for one implementation context.

## Phase 5: Project Feedback Contracts

### Goal

Give agents fast, deterministic evidence about correctness in every project.

### Work

- Define a project check convention for format, lint, typecheck, tests, build,
  migrations, E2E, startup, and test data.
- Distinguish fast per-issue checks from full pre-merge checks.
- Record unavailable checks and their residual risk.
- Integrate the existing global GitHub CI, Playwright, and Vercel pipeline rules for
  eligible heavy web projects; preserve the separate Android CI path.
- Add flaky-test discipline: N-run validation for suspected flakes, quarantine
  (`test.fixme` + issue) instead of silent skip, and never reward retry-bumping.

### Completion Gate

Injected type, test, lint, and build failures are detected and block completion.

## Phase 6: TDD and Bounded Implementer

### Goal

Reliably implement one issue in one focused context.

### Work

- Create a custom TDD skill enforcing red, green, and refactor evidence.
- Create an implementer subagent limited to one issue.
- Require relevant exploration, explicit boundaries, exact check output, and no
  unrelated edits or silent scope expansion.
- Start with manual one-issue invocation, not an unattended loop.

### Completion Gate

Representative domain, database, bug-fix, and ambiguity fixtures demonstrate a
real failing test before implementation and correct handling of failed checks.

## Phase 7: Fresh-Context Review

### Goal

Verify substantial changes independently from the producing context.

### Work

- Create a read-only general reviewer workflow.
- Reuse specialized `security-reviewer`, `silent-failure-hunter`, and
  `pr-test-analyzer` agents for their scopes.
- Push applicable acceptance criteria, standards, diff, and evidence into review.
- Require file/line findings, required changes, residual risks, and verification
  evidence.

### Completion Gate

Seeded fixtures prove detection of behavioral gaps, weak tests, swallowed errors,
authorization failures, unrelated changes, and uncovered regressions.

## Phase 8: Human QA and Visual Verification

### Goal

Preserve human product taste while automating repeatable browser evidence.

### Work

- Create a custom `manual-qa-plan` skill.
- Cover primary, empty, loading, error, boundary, authentication, permission,
  mobile, desktop, realistic data, console, and visual-quality checks.
- Reuse the existing E2E and frontend design skills where applicable.
- Use Playwright only when browser execution is useful.
- Turn QA findings into backlog issues with blockers.

### Completion Gate

A frontend fixture receives automated behavioral evidence, a usable human checklist,
desktop/mobile inspection, and a correctly formed follow-up issue.

## Phase 9: Architecture Improvement

### Goal

Make project boundaries easier for humans and agents to understand and test.

### Work

- Create a custom `architecture-audit` skill.
- Identify high coupling, shallow-module clusters, excessive public surfaces,
  repeated orchestration, heavy mocking, missing integration seams, untested logic,
  and dependency-direction problems.
- Propose deep modules with small interfaces and coherent behavior.
- Produce incremental migration slices; never auto-refactor a broad codebase.

### Completion Gate

An existing project audit identifies evidence-backed testability and module-boundary
gaps with a safe incremental migration proposal.

## Phase 10: Sequential AFK Runner

### Goal

Automate the manually proven flow one issue at a time.

### Work

- Select one ready AFK issue.
- Start a clean implementation context.
- Run checks, independent review, and result recording.
- Mark complete only after all gates pass.
- Create follow-up issues from findings.
- Add dry run, bounded iterations, at most two retries, resumability, visible logs,
  and clear stop conditions.

### Completion Gate

A fixture backlog correctly handles success, blockers, failed tests, review findings,
human-required work, interruption, resumption, and an empty ready queue.

## Phase 11: Sandboxing and Worktrees

### Goal

Make unattended execution safe and isolated.

### Work

- Create a branch or Git worktree per issue.
- Add container or equivalent filesystem/process isolation.
- Deny host secrets and unrelated directories.
- Make network and shell permissions explicit.
- Capture logs, diffs, commits, test artifacts, and failures.
- Require human approval for merge, push, and deployment until separately validated.

### Completion Gate

Adversarial tests confirm denial of protected secrets, unrelated paths, destructive
commands, direct production-branch mutation, and unapproved pushes.

## Phase 12: Parallel Execution

### Goal

Run genuinely independent issues concurrently without weakening verification.

### Work

- Select only dependency-ready issues.
- Start with at most two isolated implementers.
- Review each branch independently.
- Add controlled merge orchestration and full post-merge checks.
- Avoid concurrent edits to shared migrations, central config, routes, or types unless
  explicitly coordinated.
- Measure conflicts and reduce concurrency when integration cost rises.

### Completion Gate

Independent fixture issues merge with full verification; conflicting or blocked work
is deferred rather than forced through.

## Phase 13: External Domain Skills

### Goal

Adopt vetted external expertise without surrendering control of the core workflow.

### Adoption Rules

- Verify source, license, maintenance, repository reputation, instructions, OpenCode
  compatibility, permission assumptions, and overlap before installation.
- Install one candidate at a time and test it against a fixture.
- Prefer established external domain expertise; keep the core operating model local.
- Custom core remains: alignment, PRD, issue graph, TDD contract, architecture audit,
  manual QA, implementer, reviewer, and orchestration.

### Completion Gate

Every installed skill has a written adopt/adapt/reject decision, source evidence,
compatibility check, and demonstrated benefit without context or permission regressions.

## Phase 14: Metrics and Continuous Improvement

### Goal

Measure whether the harness improves delivered software rather than merely increasing
agent activity.

### Work

- Track task context, tool calls, duration, retries, failed checks, review findings,
  QA findings, conflicts, reopenings, escaped defects, intervention rate, cost, and
  time to first usable vertical slice.
- Use evidence to resize issues, strengthen feedback, tune role prompts, and remove
  ineffective permanent instructions.
- Optimize for working software, maintainable architecture, understandable changes,
  useful outcomes, and low escaped-defect rate.

### Completion Gate

Metrics are collected without exposing secrets or creating excessive overhead, and at
least one measured workflow improvement is validated against before/after evidence.

## Phase 15: Results Contract v2 + Persistent Metrics History

### Goal

Make per-case results machine-readable and persistent so later phases build on a
single scored-results primitive instead of fragile log grepping.

### Work

- Added `fixtures/_lib/run-case.sh`: shared case runner + JSONL emitter. Every
  suite sources it; the copy-pasted `run_case` pattern is gone.
- All 8 `fixtures/*/run-validation.sh` emit one JSON line per case to
  `case-results.jsonl` (`suite`, `case`, `expected`, `actual`, `score`, `status`,
  `duration_s`, `evidence`, `known_fail`, `timestamp`). Phase 15 keeps `score` binary.
- Rewrote `scripts/collect-metrics.sh` to parse `case-results.jsonl` with `node`
  (not `grep`), report per-suite `mean_score`, and append a summary line to
  `metrics/history.jsonl` (in-repo, committed). `--no-history` skips the append.
- Updated `harness-test.sh` to consume the same JSONL: per-case counts, known-fail
  column, mean score. Known-fail cases no longer fail the suite.
- manual-qa records `KNOWN_FAIL_CASES=browser`; a failed browser case records a
  single known-fail case and skips the dependent evidence case rather than
  corrupting the suite.

### Completion Gate

Not yet met — harness-test passes, `mean_score` present, history persisted, case count at or
above baseline, manual-qa known failure isolated as a single case.

## Phase 16: Partial Credit

### Goal

Replace binary pass/fail with a scored continuum where one genuinely exists, and
document where binary is the honest answer.

### Work

- Wrote `fixtures/_lib/RESULTS-CONTRACT.md`: record shape, field semantics, score
  semantics, the per-suite scored/binary table with reasons, and known-fail policy.
- Extended `fixtures/_lib/run-case.sh` with `run_scored_case <name> <threshold>
  <grader...>`. The grader writes `{"score": <0..1>, ...}` to `$SCORE_FILE`;
  a missing/unparseable file scores 0.0. Records carry `threshold`.
- `fresh-review` is now scored (threshold `0.9`): `assert-review.js` matches
  detected findings against `expected-findings.json` on `path+kind`, computes
  `score = recall`, and writes recall/precision/matched/expected/missing/spurious
  to `$SCORE_FILE`. Five of six real issues now scores 0.8333 and fails the
  threshold instead of being indistinguishable from zero recall.
- Kept the other seven suites binary and documented why in RESULTS-CONTRACT.md.
  `project-feedback` is explicitly binary: each case injects one defect, so
  per-check partial output would be a different case, not half a case.
- `emit_case_result`/`emit_scored_result` both stamp `threshold`; suite score is
  the mean of case scores, already surfaced by `collect-metrics.sh`.

### Completion Gate

Not yet met — continuum exists where honest, binary kept and justified where not, thresholds
(not cliffs) drive pass/fail, mutation proves the scorer detects a removed finding.

## Phase 17: Trials and Consistency

### Goal

Measure run-to-run consistency: repeat a suite N times and report per-case agreement,
so deterministic-suite flakes are separated from model variance.

### Work

- Added `scripts/run-trials.sh`: `--suite <name> --n <count>` or `--all --n <count>`
  (default n=3). Runs each suite N times in isolation, collects per-trial
  `case-results.jsonl`, and builds a case x trial agreement matrix.
- Two-tier interpretation is built in: the 8 current fixture suites are tagged
  `deterministic` (100% agreement expected; any variance is an environmental flake to
  be opened as an issue, not blamed on the "agent"); anything else is
  `model-dependent` (agreement % is a first-class metric — Phase 19+ calibration and
  real AFK runs).
- Writes `metrics/trials-<suite>-<ts>.json` per suite and `metrics/trials-all-<ts>.json`
  aggregate for `--all`.
- `collect-metrics.sh` reads the latest trials artifact per suite and emits a
  `consistency` section (JSON + human summary) when trials data exists.

### Completion Gate

Not yet met — trials runner passes its acceptance gate, a full `--all --n 3` baseline is
recorded in `HARNESS-METRICS.md` at 100% consistency across all 8 suites, no case is
non-deterministic, and metrics surfaces the consistency section when trials exist.

## Phase 18: Token and Cost Accounting

### Goal

Measure what agent work actually costs in tokens, split into harness-development
spend and project-execution spend, without inventing data.

### Work

- Added `scripts/token-report.sh` (bash + `node:sqlite`, no `sqlite3` CLI): rollups
  from the `session` table grouped by `agent`, by `directory` (project), and by day,
  plus the top-N sessions by input+output tokens. Human table + `--json`.
- Two named layers: `harness_development` (sessions whose `directory` is under the
  harness config dir) and `project_execution` (every other session).
- Wired into `collect-metrics.sh`: `metrics/history.jsonl` lines now carry a
  `tokens` object, and the JSON + human metrics output includes it.
- Optional runs↔session join investigated and **skipped**: `runs/*/events.jsonl`
  records issue/attempt/commit/verdict but no session IDs, so per-issue cost is not
  cleanly attributable. Recorded as a finding, not guessed.

### Completion Gate

Not yet met — the report shows real numbers from the populated `session` table, history lines
carry token totals going forward, and the one un-attributable join plus the empty
harness layer are reported as findings.

## Phase 20: Real-Failure Sourcing

### Goal

Turn real harness incidents into regression fixtures instead of hand-writing every
case, so the suite grows from failures that actually happened.

### Work

- Added `fixtures/_intake/TEMPLATE.md` (source, date, symptom, minimal reproduction,
  expected outcome, outcome-check command, original-artifact link) and
  `fixtures/_intake/README.md` (the intake rule, the backfilled-case table, the
  running count).
- Added the standing rule to `AGENTS.md`: every harness incident that required a fix
  becomes a fixture case in the same session that fixes it.
- Backfilled 6 cases into existing suites (no new suites), each traceable to a
  documented incident in this roadmap or `HARNESS-METRICS.md`:
  - `tdd-bounded/no-sqlite3-cli` — Phase 14: SQLite CLI absent; graders depend on
    `node:sqlite` only.
  - `manual-qa/no-stale-absolute-paths` — Phase 14: a stale hardcoded project path
    broke the browser fixture.
  - `issue-sandbox/env-injection-sanitized` — Phase 11 round-5: loader injection
    through an allowlisted child (`LD_PRELOAD`).
  - `sequential-afk-runner/numeric-id-ordering` — Phase 10 follow-up: `ISSUE-2` must
    sort before `ISSUE-10`.
  - `project-feedback/results-contract-no-bypass` — Phase 5 repairs: static checks
    bypassed metadata capture; every suite must emit through `_lib/run-case.sh`.
  - `project-feedback/collectors-exclude-underscore` — Phase 15 out-of-scope fix:
    `_lib` was scanned as a suite.
- Every backfilled case uses the Phase 15 JSONL contract.
- Rotate or refresh a subset of fixtures on a schedule so the harness does not
  overfit graders to a fixed case set (fixture contamination check).

### Completion Gate

Not yet met — `harness-test.sh` passes with all new cases counted, ≥ 4 real-failure-derived
cases exist and are traceable to documented incidents, and the intake template plus
rule are committed with `AGENTS.md` referencing them.

## Phase 21: Weekly Transcript Ritual

### Goal

Turn one week of harness transcripts into a small set of concrete improvements.

### Work

- Weekly review of traces: retries, failures, intervention rate, escaped defects.
- Convert each finding into a fixture case (Phase 20 intake) or a harness change
  proposal; rank by measured impact, implement smallest first.

### Completion Gate

A recorded weekly review artifact exists with real numbers and at least one
actioned improvement or a documented "no change" conclusion.

## Phase 22: Eval-of-Evals

### Goal

Verify that the evaluation harness itself is honest, fresh, and not reward-hackable.

### Work

- `scripts/meta-validate.sh`: mutation/replay checks that graders detect injected
  defects, do not match their own source text, and fail on contaminated fixtures.
- Periodic fixture rotation and version pinning; report contamination flags.
- Watch for reward-hacking amplification when the harness self-improves; evals stay
  sandboxed and human-reviewed.

### Completion Gate

Injected-defect and self-match mutations are caught, fixtures are versioned and
rotated, and a full eval run still passes unmodified.

## Phase 23: Self-Improvement Loop

### Goal

Close the recursion: eval evidence drives concrete, gated changes to the harness's
own scaffold, skills, prompts, and configuration.

### Work

- `scripts/harness-change-loop.sh`: read `metrics/history.jsonl`, trial results, and
  weekly-review artifacts; emit a ranked list of proposed harness changes with
  expected metric deltas.
- Each proposal runs through the existing pipeline as an AFK issue in a sandboxed
  branch (Phase 11): implement → project checks (Phase 5) → independent review
  (Phase 7) → merge gate — so a harness self-change is held to the same standard as
  product code.
- The meta-eval (Phase 22) re-runs after each accepted change; a regression reverts
  the change and files a fixture case (Phase 20).
- Every recursion step is logged to `metrics/history.jsonl` so the harness can
  measure whether self-changes improved pass-rate-per-token over time.
- Safety gate: no harness change lands without human merge approval, human review of
  the eval diff, and a clean Phase 22 meta-eval. Recursion bounded by the same
  retry/escalation rules (max 2 attempts, then escalate).

### Completion Gate

End-to-end fixture proof: a planted harness deficiency produces a ranked proposal,
a sandboxed branch, passing gates, and an applied change whose metric delta is
recorded — or a documented revert when no improvement is measured.

## Major Milestones

### Milestone A: Reliable Manual Harness

Phases 0-9:

```text
grill -> PRD -> vertical issues -> one implementation -> checks
      -> independent review -> human QA
```

### Milestone B: Safe Sequential Autonomy

Phases 10-11:

```text
ready issue -> isolated implementation -> checks -> review -> result -> repeat
```

### Milestone C: Controlled Parallel Building

Phases 12-14:

```text
dependency graph -> isolated parallel work -> independent reviews
                 -> controlled merge -> full verification -> measured improvement
```
