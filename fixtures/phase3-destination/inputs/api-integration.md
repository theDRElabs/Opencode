# Input: confirmed alignment record (API integration)

Confirmed by the human on 2026-10-05.

## Record

- Request: show live shipping rates in checkout. [DECIDED]
- Users: shoppers at checkout. [DECIDED]
- Provider: not selected. [UNKNOWN] — comparison is out of scope for this
  alignment.
- Research branch: compare up to three providers using official documentation
  and sandbox evidence within one working day. Must not include production code
  or credentials. `RESEARCH`.
- Persistence of provider responses: [HITL] — depends on the provider.
- Timeout and backoff behavior: [HITL] — depends on the provider.
- Idempotency mechanism: [HITL] — depends on the provider.
- Credentials handling: [HITL] — depends on the provider.
- Rate limits and abuse handling: [HITL] — depends on the provider.
- Retention of rate responses: [HITL] — depends on the provider.
- Failure ownership: the checkout page must show an explicit unavailable state
  rather than a fake or stale rate when rates cannot be fetched. [DECIDED]
- Testing: manual QA of the unavailable state; automated checks depend on the
  provider decision. [UNKNOWN]
- Non-goals: international checkout, label purchase, shipment tracking, and
  returns are all excluded. [DECIDED]
- Non-goal: no changes to cart or payment behavior. [DECIDED]
