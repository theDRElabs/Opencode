# Fixture Session 4: Frontend Workflow

Request: "Add a dark mode toggle to the dashboard page."

## Interview

**Turn 1 — Question:** Who uses this and what does success look like?
Recommended: returning users on low-light setups; success = preference
persists across sessions and respects OS setting on first visit. Reason:
defines testable behavior. User: agrees but cannot name the user base —
marked ASSUMED pending analytics.

**Turn 2 — Question:** Where does the preference live? Recommended:
localStorage plus `prefers-color-scheme` default; no server round-trip.
Reason: zero backend coupling. User: agrees.

**Turn 3 — Question:** Edge cases: what if localStorage is unavailable
(private mode)? Recommended: fall back to OS setting for the session, no
error shown. User: agrees.

**Turn 4 — Question:** Workflow/scope: toggle only on the dashboard page or
site-wide? Recommended: site-wide via a shared layout change; a page-only
toggle creates inconsistent state. User: accepts site-wide.

**Turn 5 — Question:** Testing? Recommended: Playwright case (toggle
persists, OS default respected) plus manual QA for contrast. Reason: visual
judgment is human-owned. User: agrees.

**Turn 6 — Question:** Non-goals? User: no theme customization, no per-page
overrides.

## Alignment Record

- User/success: low-light returning users; persistence + OS default.
  [ASSUMED user-base — analytics follow-up]
- Storage: localStorage, `prefers-color-scheme` default. [DECIDED]
- Fallback: OS setting when localStorage unavailable. [DECIDED]
- Scope: site-wide shared layout. [DECIDED]
- Testing: Playwright persistence case + manual contrast QA. [DECIDED]
- Non-goals: customization, per-page overrides. [DECIDED]

Stop condition met: an ASSUMED item is labeled and requires confirmation
before handoff. No component edited.
