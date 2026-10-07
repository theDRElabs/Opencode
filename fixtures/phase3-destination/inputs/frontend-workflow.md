# Input: confirmed alignment record (frontend workflow)

Confirmed by the human on 2026-10-05.

## Record

- Request: an approval queue screen where a reviewer approves or rejects
  submitted items. [DECIDED]
- Users: reviewers and requesters. [DECIDED]
- Roles: reviewer approves or rejects; requester sees status only. [DECIDED]
- Claiming: a reviewer claims an item exclusively; two reviewers cannot hold the
  same item. [DECIDED]
- Evidence: every approval decision stores the evidence version that was
  reviewed. [DECIDED]
- Duplicates: a request with a duplicate active request cannot be approved and is
  escalated. [DECIDED]
- Drafts: drafts submitted by a requester are preserved and remain editable
  until submitted. [DECIDED]
- Asynchronous processing: approval processing is asynchronous with bounded
  retries; on exhaustion the item moves to a failure queue. [DECIDED]
- Escalation ownership: who owns escalated duplicates: [UNKNOWN].
- Failure queue ownership: [UNKNOWN].
- Security approval for the SSO/MFA policy protecting the queue: [HITL].
- Retention for approval evidence: [UNKNOWN].
- Testing: automated coverage and the exact checks: [UNKNOWN] — the interview did
  not settle these.
- Manual QA: reviewer and requester roles exercised by hand. [DECIDED]
- Non-goals: batch operations including batch approval; no new notification
  system; no mobile-specific design work; no changes to the request submission
  form. [DECIDED]
