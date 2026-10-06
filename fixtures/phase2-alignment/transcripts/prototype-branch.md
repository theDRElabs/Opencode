# Fixture Session 5: Bounded Prototype Branch

Request: "Make grill-me ask fewer, better questions."

## Interview

**Turn 1 — Question:** What problem does this solve — user fatigue,
incomplete coverage, or both? Recommended: treat as UNKNOWN until two recent
transcripts are reviewed, because the fix differs (fewer turns vs better
ordering). User: cannot recall transcripts; accepts UNKNOWN.

**Turn 2 — Question:** Is this a production behavior change or research?
Recommended: bounded prototype branch — hypothesis, budget, success signal,
cleanup. It must not edit skills/grill-me/SKILL.md. User: accepts.

**Turn 3 — Question:** Prototype scope? Recommended: draft an alternate
question-ordering in a scratch file under /tmp, run it against the same 5
fixture scenarios, and compare coverage labels vs the current skill. Budget:
one pass over the 5 fixtures. Success signal: coverage of all required areas
with fewer turns and no lost HITL/UNKNOWN labeling. User: agrees.

**Turn 4 — Question:** Decision the prototype unblocks? Recommended: whether
ordering change is worth merging into the skill. Result label stays
`RESEARCH` until the user accepts it. User: agrees.

**Turn 5 — Question:** Stop condition for the prototype? Recommended: one
fixture pass, then stop and report; no iteration loop. User: agrees.

**Turn 6 — Question:** What must NOT happen? Recommended: no edits to the
installed skill, no config changes, no live sessions until the user accepts
the research result. User: agrees.

## Alignment Record

- Problem statement: UNKNOWN pending transcript review. [UNKNOWN]
- Branch type: bounded prototype, explicitly separate from production.
  [DECIDED]
- Scope/budget: alternate ordering in /tmp, one pass over 5 fixtures.
  [DECIDED]
- Success signal: equal coverage, fewer turns, no lost labels. [DECIDED]
- Unblocks: merge decision for the skill. Result labeled RESEARCH. [DECIDED]
- Stop: single fixture pass, report, no loop. [DECIDED]
- Guardrails: no edits to installed skill/config; no live sessions without
  user acceptance. [DECIDED]

Stop condition met: prototype scoped and bounded; no production artifact touched, no prototype executed (branch definition only).
