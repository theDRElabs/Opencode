# Phase 1 Validation: Contract vs Representative Tasks

Date: 2026-10-06
Method: analytical walkthrough of the contract's lane-selection rules against
three representative scenarios. No fixture session was executed; this document
is an analysis artifact, not an observed run.

## Contract rules exercised

- Lifecycle: `intent -> alignment -> destination -> bounded issues ->
  implementation -> automated checks -> independent review -> human QA ->
  follow-up issues` (HARNESS-CONTRACT.md § Default Lifecycle).
- "Do not skip alignment for ambiguous or high-impact work. Small, obvious
  fixes may start at implementation when their acceptance criteria and
  verification are clear." (same section)
- Autonomy levels: `HITL` (human decisions, prototypes, stakeholder feedback,
  security approval, visual judgment, irreversible action) vs `AFK` (bounded
  implementation, explicit acceptance criteria, isolated scope, deterministic
  checks, no unresolved human decision) (§ Autonomy Levels).
- Artifact handoffs (§ Artifact Handoffs) and verification separation
  (§ Verification Separation).

## Scenario A — HITL-ambiguous request

Request: "Make onboarding less confusing for new users."

Routing walkthrough:

1. Lane selection: no acceptance criteria, no single observable outcome,
   requires product taste and user judgment -> not AFK-eligible. Per
   § Autonomy Levels this routes to `HITL` from the start.
2. Contract path: intent -> alignment (one decision question at a time,
   recommended answer) -> destination document -> bounded issues. The agent
   must not draft screens or refactor copy before alignment; it exposes
   assumptions and open questions instead.
3. Autonomy check: the contract does NOT tell the agent to stop and do
   nothing. It tells the agent to run the alignment interview and produce the
   alignment record artifact. Normal autonomy (exploration, assumption surfacing,
   research branches) is preserved; only irreversible editing is gated.
4. Evidence of no suppression: § Autonomy Levels HITL covers "human decisions,
   prototypes, stakeholder feedback" — i.e., the work mode is human dialogue,
   not refusal. The contract's responsibility boundaries let the agent
   "explore, propose, and expose assumptions before implementing."

## Scenario B — small obvious fix

Request: "The `--help` text of `scripts/collect-metrics.sh` still references
the old output filename — fix the string."

Routing walkthrough:

1. Lane selection: single observable outcome (help text names the correct
   output file), acceptance criteria clear, verification clear (run the
   script with `--help` and read the output) -> qualifies for the
   § Default Lifecycle carve-out: "Small, obvious fixes may start at
   implementation."
2. Contract path: skip alignment and destination; start at implementation.
   The agent edits one line, runs the check, and reports exact evidence
   (the new `--help` output).
3. Autonomy check: this is the key no-suppression case. The contract
   explicitly does NOT force every request through alignment, destination
   docs, issues, or independent review. Over-gating a one-line fix would be
   autonomy suppression; the contract permits skipping it.
4. Evidence in the contract text: § Default Lifecycle lines 30-31, plus
   § Autonomy Levels AFK definition ("bounded implementation ... no
   unresolved human decision") — escalating this to HITL would contradict
   the contract, and would be a defect to fixture, not the expected path.

## Scenario C — AFK bounded implementation

Request: issue artifact with acceptance criteria "Add `--json` flag to
`scripts/token-report.sh`: emits the same rollup as JSON on stdout; exit 0;
no schema change to human table."

Routing walkthrough:

1. Lane selection: explicit acceptance criteria, isolated scope (one
   script), deterministic check (pipe stdout to `node -e JSON.parse`), no
   unresolved human decision -> `AFK`.
2. Contract path: implementation in one focused context -> automated checks
   -> review. No alignment or destination steps re-run; the issue artifact
   is the handoff input.
3. Autonomy check: contract expects the agent to implement autonomously and
   must NOT be interrupted for confirmation on each edit. HITL triggers are
   enumerated (security approval, irreversible action, stakeholder input)
   and none apply; requiring them here would be suppression.
4. Verification separation: producer runs the checks, but a substantial
   change still requires independent review (§ Verification Separation) —
   autonomy in production, not in verification.

## Result against the Phase 1 gate

What this walkthrough proves:

- The contract's routing rules are decidable: each scenario maps to exactly
  one lane without ad-hoc judgment.
- The contract text affirmatively permits autonomy (small obvious fixes skip
  the full lifecycle; AFK work proceeds without human checkpoints), so the
  routing rules do not inherently suppress normal autonomy.

What it does not prove:

- No session has actually executed a representative task under the contract.
  Whether a live agent, given these scenarios, routes correctly and does not
  escalate obvious fixes to HITL (or worse, asks before doing anything) is
  unobserved. That requires running the scenarios as real fixture sessions
  and recording transcripts.

Gate consequence: the Phase 1 gate stays "Not yet met". The walkthrough
closes the analytical half of the gap; the observed-run half remains open.
