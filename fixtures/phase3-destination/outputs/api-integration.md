# Destination Document — Live Shipping Rates in Checkout

## Status

`active`. Destination and definition of done only. Provider-dependent behavior
remains unresolved by design.

## Problem and Users

Shoppers cannot see shipping cost before paying, so they abandon or are
surprised at the last step.

- Users: shoppers at checkout.
- Success: a shopper sees a real shipping rate, or an explicit unavailable
  state. Never a fabricated or silently stale rate.

## Solution

Checkout fetches live shipping rates for the shopper's cart and destination and
shows them before payment.

## Observable Stories

- As a shopper I see a shipping rate for my cart and address before I pay, so I
  can decide with full information.
- As a shopper I see an explicit unavailable state when rates cannot be
  fetched, so I am not shown a rate that does not exist.
- As a shopper my cart and payment behavior are unchanged, so adding rates does
  not alter what I buy or how I pay.

## Acceptance Criteria

1. Checkout shows a rate only when one was actually returned by the rate source.
2. When rates cannot be fetched, checkout shows an explicit unavailable state.
   It does not show a cached, estimated, or placeholder rate without saying so.
3. Cart contents, totals, and payment behavior are unchanged by this destination.
4. Rate-source-dependent criteria (timeout, retry, idempotency, credential
   handling, rate limiting, retention) are `HITL` and are not asserted here.

## Data Behavior

- Source of truth for a rate: the rate source. No local rate store is agreed.
- Persistence of rate responses: `HITL` — depends on the provider decision.
- Retention of rate responses: `HITL` — depends on the provider decision.
- Migration: none.
- Recovery: not applicable; no stored state to recover in this destination.

## Contracts and Module Map

- Public behavior contract: checkout renders either a fetched rate or the
  explicit unavailable state.
- Provider contract: `UNKNOWN`. The provider is not selected, so no endpoint,
  request shape, response shape, or error taxonomy is stated here.
- Module boundaries and locations: `UNKNOWN`. No modules were named during
  alignment.
- `RESEARCH`: compare up to three providers using official documentation and
  sandbox evidence within one working day. The research must not include
  production code or credentials. It exists to unblock provider selection and the
  provider-dependent decisions below.

## Security Constraints

- Credentials: `HITL` — handling depends on the provider. No credential is
  specified, named, or stored by this document.
- Trust boundary: rates originate outside the application and are not trusted as
  authoritative for totals.
- Sensitive data: the shopper's shipping address is disclosed to the rate source;
  scope of disclosure depends on the provider. `HITL`.
- Abuse limits: rate limiting and abuse handling are `HITL`.

## Testing and QA

- Manual QA: the unavailable state renders and is understandable.
- Automated: `UNKNOWN` — the checks depend on which provider is selected.
- Environments: `UNKNOWN`.
- Unavailable checks are recorded rather than invented.

## Non-Goals

- International checkout.
- Label purchase.
- Shipment tracking.
- Returns.
- Any change to cart or payment behavior.

## Unresolved Risks

| Item | Label | Owner | Blocks |
|---|---|---|---|
| Provider selection | `UNKNOWN` | bounded research branch | all provider-dependent criteria |
| Persistence of rate responses | `HITL` | depends on provider | data behavior section |
| Timeout and backoff | `HITL` | depends on provider | failure acceptance criteria |
| Idempotency mechanism | `HITL` | depends on provider | repeat-fetch behavior |
| Credential handling | `HITL` | depends on provider | security section |
| Rate limits and abuse handling | `HITL` | depends on provider | availability behavior |
| Retention of responses | `HITL` | depends on provider | data behavior section |
| Automated check selection | `UNKNOWN` | unassigned | testing section |

## Handoff

Ready for human review, and explicitly not ready for issue generation: the
provider is unselected, so most implementation criteria cannot yet be written
without inventing decisions. Resolve the research branch first.
