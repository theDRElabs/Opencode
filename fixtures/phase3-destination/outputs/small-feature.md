# Destination Document — Save Article for Later

## Status

`active`. This document is a destination and definition of done. It is not a
backlog, plan, or implementation.

## Problem and Users

Readers finish articles they intend to return to and lose track of them.
Signed-in readers cannot mark an article for later and have no saved list.
Success: a reader can save an article, find it in their own list, and remove it,
with no cross-user leakage.

## Solution

A Save control on article pages and a per-reader saved-articles list showing
saved article identity and save time.

## Observable Stories

- As a signed-in reader I can save an article from its page and see it listed,
  so I can return to it later.
- As a signed-in reader I can remove a saved article and see it disappear, so my
  list reflects what I still want.
- As a signed-in reader with nothing saved I see an explicit empty message, so
  the empty list is not mistaken for a broken page.
- As a signed-in reader on a slow connection I see the Save state immediately and
  a clear error if the server refuses, so I never believe a save that did not
  happen.

## Acceptance Criteria

1. Saving as a signed-in reader adds that article to that reader's list only;
   another reader's list is unchanged.
2. Removing a saved article removes it from that reader's list.
3. An empty list renders a visible empty-state message.
4. Save is optimistic in the UI. If the server rejects the save, the control
   returns to its unsaved state and a short error is shown. The reader is never
   shown a saved state that was not persisted.
5. Save controls are absent from article listing pages.
6. Pagination behavior for long saved lists: `UNKNOWN` — see Unresolved Risks.

## Data Behavior

- Source of truth: the server, per user. Browser-local storage is not the
  record of a save.
- Stored per saved article: article identity and save time. Nothing else was
  agreed; adding fields is out of scope for this destination.
- Migration: none. No existing data is rewritten or backfilled.
- Retention and growth: `UNKNOWN`. Saved-article growth per user is unbounded and
  no owner has accepted a limit.
- Recovery: removal is user-initiated; there is no undo requirement in the
  alignment record.

## Contracts and Module Map

- Public behavior contracts: the saved-article list is per reader; a save
  rejects rather than partially applying; removal affects exactly one reader's
  list.
- Module boundaries and locations: `UNKNOWN`. The alignment record named no
  modules and no repository structure. No module paths are invented here.

## Security Constraints

- Authorization: a reader may only read or modify their own saved articles.
  Cross-reader access is a defect, not an error state.
- Trust boundary: the client requests a save by article identity; identity is
  not trusted from the client.
- Sensitive data: none beyond article identity.
- Abuse limits: none decided.
- `HITL`: whether an anonymous reader's attempted save is applied automatically
  after login is a product/privacy decision and is unresolved. It must not be
  assumed in either direction.

## Testing and QA

- Automated: an integration check that a save persists and is visible only to
  the saving reader; a check that a server rejection restores the unsaved state
  and surfaces an error.
- Manual QA: empty-state rendering, remove-from-list behavior.
- Environments: not specified in the alignment record.
- Unavailable checks: none recorded; a project check contract does not yet exist
  for this destination.

## Non-Goals

- Save controls on article listing pages.
- Article recommendations.
- Offline support.
- Bulk save or bulk remove actions.
- Changes to article URLs.
- Any article-page change beyond the Save control.

## Unresolved Risks

| Item | Label | Owner | Blocks |
|---|---|---|---|
| Pagination behavior for long saved lists | `UNKNOWN` | unassigned | acceptance criterion 6 |
| Anonymous attempted save applied after login | `HITL` | product/privacy owner | login-and-save behavior |
| Unbounded saved-article growth per user | `UNKNOWN` | unassigned | retention decision |

## Handoff

Ready for human review. Not ready for issue generation until a human explicitly
accepts this document, and the three unresolved items above are either decided
or explicitly deferred.
