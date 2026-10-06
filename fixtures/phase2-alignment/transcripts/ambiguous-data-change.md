# Fixture Session 2: Ambiguous Data Change

Request: "Backfill the missing timestamps in events.jsonl."

## Interview

**Turn 1 — Question:** Who consumes events.jsonl and what breaks without
timestamps? Recommended: the metrics collector warns/skips rows; decide whether
a warning or a failure is correct. Reason: downstream tolerance determines the
required backfill rule. User: says the collector currently skips the rows and
it was never flagged.

**Turn 2 — Question:** What timestamp value should backfilled rows get?
Recommended: `null` plus a `backfilled: true` marker rather than a fabricated
time. Reason: fabricated timestamps corrupt time-based analysis. User: agrees
with null + marker, but notes the collector cannot read nulls today.

**Turn 3 — Question:** Is this a migration, a view, or a code fix?
Recommended: UNKNOWN until the collector's parsing is inspected — spawn a
bounded research branch to read the collector source and report whether null
timestamps parse. Reason: the right artifact depends on observed behavior.
User: accepts the research branch, UNKNOWN label, no migration yet.

**Turn 4 — Question:** Data ownership/retention: may the original file be
rewritten in place? Recommended: no in-place rewrite; write
`events.backfilled.jsonl` and keep the original. Reason: preserves audit
trail. User: agrees.

**Turn 5 — Question:** Security/integrity: does any consumer sign or hash the
files? Recommended: research branch must check for checksums before writing a
derived file. User: adds this to the research branch scope.

**Turn 6 — Question:** Testing expectation? Recommended: fixture asserting the
new file parses, preserves row count, and marks backfilled rows. User: agrees.

## Alignment Record

- Request: backfill missing timestamps in events.jsonl.
- Consumer/impact: collector skips rows; failure vs warning [UNKNOWN].
- Backfill value: `null` + `backfilled: true` marker. [DECIDED]
- Artifact form: UNKNOWN — research branch inspects collector parsing.
  [UNKNOWN][RESEARCH]
- Rewrite policy: derived file, original preserved. [DECIDED]
- Integrity check: part of research branch scope. [RESEARCH]
- Testing: parse check, row-count parity, marker presence. [DECIDED]
- HITL: approve derived-file naming before implementation. [HITL]

Stop condition met: unresolved items are explicitly labeled and assigned to a
research branch or HITL. No migration written, no files edited.
