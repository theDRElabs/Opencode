# Fixture Session 3: API Integration

Request: "Post harness metrics to our internal dashboard API."

## Interview

**Turn 1 — Question:** What is the smallest end-to-end workflow? Recommended:
after each `collect-metrics.sh` run, POST one summary JSON; nothing on failure.
Reason: bounds scope to one producer/one consumer. User: agrees.

**Turn 2 — Question:** What is the contract? Recommended: treat
`fixtures/_lib/RESULTS-CONTRACT.md` summary shape as the payload; confirm field
names with the dashboard team before coding. Reason: avoids inventing a second
schema. User: says contract confirmation is HITL.

**Turn 3 — Question:** Failure ownership and retries? Recommended: one retry
with backoff, then record failure in history.jsonl and exit non-zero; never
block the local metrics run on the network call. User: agrees.

**Turn 4 — Question:** Idempotency: can the same summary be posted twice?
Recommended: include a run id (timestamp + suite list hash) so the dashboard
can dedupe. Reason: reruns are common. User: agrees.

**Turn 5 — Question:** Security: where does the API token live? Recommended:
environment variable, never in metrics/history.jsonl or the repo; document
rotation. User: agrees.

**Turn 6 — Question:** Research branch needed? Recommended: yes — spike the
dashboard's actual response codes and timeout behavior with a stub server
before implementing. User: accepts; branch labeled RESEARCH.

**Turn 7 — Question:** Testing? Recommended: fixture with a local stub HTTP
server asserting payload shape, auth header, and one-retry behavior. User:
agrees.

## Alignment Record

- Workflow: one POST per metrics run; failure does not block local run.
  [DECIDED]
- Payload: RESULTS-CONTRACT summary shape; field names HITL confirmation.
  [DECIDED][HITL]
- Retries: one retry with backoff; failure recorded. [DECIDED]
- Idempotency: run id for dashboard dedupe. [DECIDED]
- Token: env var only. [DECIDED]
- Pre-work: stub-server spike for response codes/timeouts. [RESEARCH]
- Testing: local stub server fixture. [DECIDED]

Stop condition met: integration semantics decided, research spike scoped, no implementation started.
