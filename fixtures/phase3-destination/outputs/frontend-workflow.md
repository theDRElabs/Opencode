# Destination Document — Approval Queue

## Status

`active`. Destination and definition of done only.

## Problem and Users

Submitted items wait without clear ownership, so reviewers duplicate each
other's work and requesters cannot tell what happened.

- Users: reviewers (decide), requesters (observe status).
- Success: exactly one reviewer owns an item at a time, every decision records
  the evidence it was based on, and a requester can see the outcome.

## Solution

A queue where a reviewer claims an item exclusively and approves or rejects it,
with asynchronous processing, a failure queue, and visible requester status.

## Observable Stories

- As a reviewer I claim an item so no one else decides it, so decisions do not
  conflict.
- As a reviewer I approve or reject with the evidence version I reviewed, so the
  decision is auditable later.
- As a requester I see my item's status, so I know whether it is pending,
  approved, rejected, or failed.
- As a requester with a duplicate active request I am told the request is a
  duplicate and it is escalated, so I do not wait on a decision that will not
  come.
- As a requester my unsubmitted draft survives, so I can finish it later.

## Acceptance Criteria

1. Only a reviewer may approve or reject; a requester sees status only.
2. A claim is exclusive: two reviewers cannot hold the same item.
3. Every approval or rejection records the evidence version that was reviewed.
4. A request with a duplicate active request cannot be approved and is
   escalated.
5. A draft is preserved and remains editable until it is submitted.
6. Approval processing is asynchronous with bounded retries. On retry exhaustion
   the item moves to a failure queue and the requester sees a failed status.
7. Escalation ownership and failure-queue ownership are `UNKNOWN` — see
   Unresolved Risks.
8. The SSO/MFA policy protecting the queue is `HITL` — not assumed here.

## Data Behavior

- Recorded per decision: the reviewer, the outcome, and the evidence version
  reviewed.
- Claim state: exclusive per item; the owner of an escalation and of a failure
  queue entry is `UNKNOWN`.
- Retention for approval evidence: `UNKNOWN`.
- Migration: none.
- Recovery: not specified in the alignment record.

## Contracts and Module Map

- Role contract: reviewer decides, requester observes.
- Claim contract: exclusive per item.
- Evidence contract: a decision cannot exist without the evidence version it was
  made against.
- Module boundaries and locations: `UNKNOWN`. No modules or component paths were
  named during alignment and none are invented here.

## Security Constraints

- Authorization: role separation between reviewer and requester is a
  security-relevant requirement, not a convenience.
- `HITL`: the SSO/MFA policy protecting the queue requires security approval and
  is unresolved. It must not be assumed to be either stronger or weaker than
  currently exists.
- Sensitive data: approval evidence may contain user-submitted material;
  `UNKNOWN` how it is classified.
- Trust boundary: requester-supplied evidence is untrusted input.
- Audit: decisions are auditable by construction through the evidence-version
  requirement.
- Abuse limits: not specified.

## Testing and QA

- Manual QA: reviewer and requester roles exercised by hand, including the
  duplicate-request escalation and the failure-queue state.
- Automated coverage and exact checks: `UNKNOWN`. The interview did not settle
  them and none are invented here.
- Environments: `UNKNOWN`.
- Browser-level verification is expected for the claim-exclusivity path but is
  not yet specified. `UNKNOWN`.

## Non-Goals

- Batch operations, including batch approval.
- A new notification system.
- Mobile-specific design work.
- Changes to the request submission form.

## Unresolved Risks

| Item | Label | Owner | Blocks |
|---|---|---|---|
| SSO/MFA policy for the queue | `HITL` | security owner | access requirements |
| Escalation ownership | `UNKNOWN` | unassigned | acceptance criterion 7 |
| Failure-queue ownership | `UNKNOWN` | unassigned | acceptance criterion 7 |
| Approval-evidence retention | `UNKNOWN` | unassigned | data retention |
| Automated coverage and checks | `UNKNOWN` | unassigned | verification plan |
| Evidence data classification | `UNKNOWN` | unassigned | security handling |

## Handoff

Ready for human review, and not ready for issue generation: unresolved ownership
and security decisions remain. A human must accept this document and decide or
defer the `HITL` and `UNKNOWN` items above.
