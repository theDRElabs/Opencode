# Phase 3 Validation: Destination Documents (`write-prd`)

Date: 2026-10-07
Method: port of the proven `write-prd` skill and command from the local
`opencode-config` clone, adaptation to this machine's contract, and a
structural gate check over six authored walkthroughs plus one mutation control.

## Artifacts

- Skill: `skills/write-prd/SKILL.md`
- Invocation command: `commands/write-prd.md`
- Fixture: `fixtures/phase3-destination/`
  - `inputs/` — six alignment records (five confirmed, one deliberately
    unconfirmed)
  - `outputs/` — the destination documents the skill yields from them
  - `cases/mutation-negative.md` — a violating document the grader must reject
  - `run-validation.sh` → `case-results.jsonl`
- This document: `HARNESS-PHASE-3-VALIDATION.md`

## Observed fixture run

Command: `fixtures/phase3-destination/run-validation.sh`
Exit code: 0 (7/7 cases meet expectation).

```
unconfirmed-guard: PASS refused without confirmation
small-feature: PASS gate-compliant document
data-change: PASS gate-compliant document
api-integration: PASS gate-compliant document
frontend-workflow: PASS gate-compliant document
prototype-branch: PASS gate-compliant document
mutation-negative: PASS rejected:implementation-artifact:code-block,module-path,api-endpoint,estimate,issue-authorization,next-steps dropped-unresolved-labels
```

Per-case records are in `fixtures/phase3-destination/case-results.jsonl` (JSONL,
one object per case, matching the Phase 2 record shape).

## What each case demonstrates

- `unconfirmed-guard`: pasted, unconfirmed notes with undecided items produce a
  refusal and a request for confirmation — not a document.
- `small-feature`: optimistic-save failure behavior, per-reader ownership, empty
  state, listing-page non-goal, `UNKNOWN` pagination and retention,
  `HITL` anonymous-after-login behavior.
- `data-change`: atomic transactional migration, verified backup, rollback,
  conflict abort, public-API compatibility, audit evidence, migration-window
  approval `HITL`, and an explicitly unknown module map. No schema, no module
  paths.
- `api-integration`: unselected provider stays `UNKNOWN`; persistence, timeout,
  idempotency, credentials, rate limits, and retention stay `HITL`; the bounded
  `RESEARCH` branch is preserved with its budget and exclusions; the four
  non-goals survive; no endpoint is named.
- `frontend-workflow`: role split, exclusive claim, evidence-version contract,
  duplicate escalation, draft preservation, bounded retries and failure queue,
  SSO/MFA `HITL`, ownership and coverage `UNKNOWN`s, batch non-goal.
- `prototype-branch`: stays `RESEARCH`, keeps disposable non-sensitive data, eight
  participants, counterbalancing, zero-error success, atomic simulated apply,
  disposition, and the production-shipping `HITL` — and does not become
  production scope.
- `mutation-negative`: a document with fabricated module paths, an invented
  endpoint, an estimate, a task sequence, dropped unknowns, and issue-generation
  authorization is rejected. This exists so a passing suite is not evidence of a
  vacuous grader.

## Grader

Structural, per `run-validation.sh`. Each destination document must:

1. carry all twelve required headings in the skill's order;
2. preserve at least one `UNKNOWN`/`HITL`/`RESEARCH` label, a `## Non-Goals`
   section, and a `## Unresolved Risks` section;
3. contain no code block, module path, HTTP endpoint, schema DDL, issue ID,
   estimate, task sequence, next-steps, or affirmative issue-generation
   authorization;
4. hand off at human review rather than authorizing issue generation;
5. stay inside the prose bound (≤ 900 words, no prose run over 95 words);
6. satisfy case-specific preservation tokens for the scenario's negative
   decisions, migration behavior, module-boundary unknowns, test expectations,
   and risks.

## PORT-NOTES: changes from the source, and old-machine assumptions

Source: `/workspaces/opencode-config` (`skills/write-prd/SKILL.md`,
`commands/write-prd.md`), ported rather than rewritten because that skill was
validated end-to-end on its origin machine (five fixtures, restricted-agent
permission resolution, fresh-context verification — see the source repo's
`harness-archive/HARNESS-PHASE-3-VALIDATION.md`).

### Changes made

1. **Contract deferral instead of duplication.** Added one line naming
   `HARNESS-CONTRACT.md` as the source of truth for lifecycle, responsibility,
   and verification. The skill does not restate contract rules.
2. **Explicit label carry-forward.** Preconditions now say the record's labels
   (`DECIDED`/`ASSUMED`/`UNKNOWN`/`HITL`/`RESEARCH`) carry forward and that an
   item left unresolved upstream cannot be decided here. The source implied
   this only inside the preservation rules.
3. **Confirmation is not inferred.** Added: a pasted note, a draft, or a record
   the agent itself produced is not confirmation. The source's real-world
   failure mode — an alignment record written pre-confirmation and self-declared
   "confirmed" — happened in this harness during Phase 2, so the precondition is
   now explicit rather than implied.
4. **Upstream named.** The source said "a confirmed alignment record"; it now
   names `grill-me` as the normal producer, which is what the artifact handoff
   in the contract describes.
5. **Checkable acceptance criteria.** Added: each criterion must be checkable by
   someone who did not write it; "works", "is fast", and "handles errors" are
   not criteria. The grader enforces this shape, so the skill had to name it.
6. **Flaky-test rule, deferred not restated.** Added one line: a retry-dependent
   check is never acceptance, and a suspected flaky test is a tracked risk. The
   contract owns the rule (reproduce, N-run, quarantine, no retry-bumping); the
   skill only forbids encoding it as a criterion.
7. **Verification separation, one line.** The document is written to be handed
   to a fresh context; authoring it and accepting it are separate acts and
   acceptance is the human's.
8. **Command** now names `grill-me` as the expected input and repeats the
   "do not decide anything the record left open" instruction.

### Old-environment assumptions checked

- **No path assumptions to fix.** Neither source file contains `/home/ubuntu`,
  `~/projects`, a repository path, or any reference to `fixtures/`, `scripts/`,
  or other harness files. `grep` over both files for those patterns returned
  nothing. The source repo does contain such references in other files
  (`HARNESS-METRICS.md`, `docs/build-pipeline.md`, `chrome-wrapper.sh`,
  `agent/bounded-implementer.md`, several `fixtures/*/run-validation.sh`), which
  is why the same grep was run before trusting the port.
- **Relative-only by design.** Both ported files refer to no absolute path, so
  the port is machine-independent.
- **`agent: destination-writer` is retained in the command frontmatter even
  though no `agent/` directory exists in this repo.** This mirrors Phase 2
  exactly: `commands/grill-me.md` declares `agent: alignment` and the
  corresponding agent file was likewise not ported. The restricted-agent
  permission boundary that the source validated (`read`/`edit`/`glob`/`grep`/
  `bash`/`task`/`external_directory` denied) therefore is **not** reproduced
  here. Recorded as an open item, not silently inherited.
- **Contract drift.** The source repo's `HARNESS-CONTRACT.md` is an older
  revision: it lacks the context-as-a-budget section, the flaky-test and
  deterministic-edit-guardrail rules, and the harness-as-a-variable line that
  this repo's contract adds. The port targets this repo's contract.
- **Source validation claims were not carried over.** The source repo's Phase 3
  validation cites Android/Termux sessions, `opencode debug config` permission
  resolution, and session IDs that do not exist on this machine. None of that
  evidence is claimed here; the evidence below is what was actually run here.
- **Neither skill is installed yet, so `/write-prd` cannot currently be invoked.**
  `~/.config/opencode/` symlinks only `AGENTS.md`, `HARNESS-AUDIT.md`,
  `HARNESS-CONTRACT.md`, and `HARNESS-ROADMAP.md`; there is no `skill/` or
  `commands/` symlink, and this repo uses `skills/` (plural), which is not the
  layout OpenCode discovers. This is a pre-existing Phase 2 gap — `grill-me` has
  the same problem — and is recorded rather than fixed here, because wiring the
  global config directory is a change to live configuration outside this phase's
  scope. It is the practical prerequisite for the emergent run named below.

## Honest limits

- **All six walkthroughs are authored, not observed.** They were written by hand
  to satisfy the skill's rules while porting it. No agent session produced them.
  The suite shows the contract is satisfiable and mechanically checkable; it does
  **not** show that a live agent reliably produces conforming documents.
- **The grader is structural.** It checks headings, preserved tokens, absence of
  implementation artifacts, handoff wording, and prose bounds. It cannot judge
  whether a document is a *good* destination — whether the stories are the right
  stories, whether a criterion captures the real requirement, or whether an
  unknown was preserved with the correct label. Those remain human judgments.
- **Authoring bias.** Because the same agent wrote both the skill adaptation and
  the fixtures, the fixtures encode that agent's reading of the skill. A fresh
  context could reasonably produce conforming documents the grader rejects, or
  violating documents the grader accepts. This is the Verification Separation
  limit in its purest form and is the strongest argument for emergent evidence
  here.
- **No emergent run.** Phase 2 recorded a real human-driven session
  (`fixtures/phase2-alignment/live-human-run.md`). Phase 3 has no equivalent:
  `/write-prd` has never been run live against a real alignment record on this
  machine.
- **No permission-boundary evidence.** See the `agent/` note above.
- **No de-duplication check.** Nothing verifies that the ported skill still
  matches the source; drift after this commit would be silent.
- **Coverage.** Five scenario shapes mirror the source's validated set. Untested
  shapes include: a document superseded mid-flight (lifecycle `completed` and
  `archived` transitions are defined but never exercised), an alignment record
  so large the document must be split, and a record whose `HITL` items are
  answered after the document is written.

## Gate assessment

The gate — "generated fixtures preserve negative decisions, migration behavior,
module boundaries, test expectations, and unresolved risks without excessive
prose" — is satisfied for the authored fixtures under a structural grader that
is proven non-vacuous by the mutation control. The word "generated" is doing work
the evidence does not fully support: the fixtures are authored, so this is
evidence about the artifact contract, not about agent behavior.

Tracker status is therefore recorded as `in_progress`, not `completed`. The
remaining gap is precise: **one emergent `/write-prd` run against a real
alignment record, in a fresh context, whose output is graded by this same
`run-validation.sh`** — plus, if the command's `agent:` binding is meant to be
enforced, porting `agent/destination-writer.md` and recording resolved
permissions.
