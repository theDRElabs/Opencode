# Input: confirmed alignment record (small feature)

Confirmed by the human on 2026-10-05. Source session: local scratch, no project
files were inspected during this interview.

## Record

- Request: let a signed-in reader save an article to read later. [DECIDED]
- Users: signed-in readers of the existing article site. [DECIDED]
- Primary workflow: reader opens an article, activates Save, sees it appear in a
  saved-articles list, and can remove it. [DECIDED]
- Failure behavior: saving is optimistic in the UI; if the server rejects the
  save, the control returns to its unsaved state and the reader sees a short
  error. No silent failure. [DECIDED]
- Data behavior: saved list is per-user and server-owned, not browser-local.
  [DECIDED]
- Data behavior: the saved record stores article identity and save time only.
  [DECIDED]
- Empty state: the list shows an explicit empty message. [DECIDED]
- Pagination behavior for long saved lists: [UNKNOWN] — not discussed; no owner
  assigned yet.
- Whether an anonymous reader's attempted save is applied automatically after
  login: [HITL] — product owner decides; privacy-relevant.
- Testing: one integration check that a save persists per user and one check for
  the reject path; manual QA of the empty state. [DECIDED]
- Non-goal: Save controls do not appear on article listing pages; no article
  recommendation; no offline support; no bulk actions. [DECIDED]
- Non-goal: no change to article URLs or article pages beyond the Save control.
  [DECIDED]
- Unresolved risk: saved-article growth per user is unbounded. [UNKNOWN] owner
  unassigned.
