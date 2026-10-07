# Alignment Record: Speech-to-Text Floating Widget

Status: confirmed by user. Derived from a `grill-me` alignment interview.
Not a PRD, not a plan, not implementation.

## Request and target user

`DECIDED` Lightweight Android app that turns speech into text without using the
phone keyboard, so terminal and SSH work doesn't need on-screen typing. Single
user: the requester, sideloading to their own device.

## Primary workflow and success condition

`DECIDED`

1. Tap the floating widget → listening starts.
2. Speak.
3. Tap the widget again → recognition stops, the transcript lands on the
   clipboard, and a bubble previews the text for a few seconds.
4. Paste into Termux or an SSH session. No keyboard involved.

`DECIDED` Success: a phrase spoken in Termux and in an SSH session appears via
clipboard paste with no keyboard use. Verified by hand on the user's own phone.
No automated test acceptance bar for v1.

## Decisions

| Area | Decision |
|---|---|
| Platform | Android only. iOS cannot do a floating overlay over other apps or inject text into arbitrary apps. |
| Delivery | Standalone APK, sideloaded to the user's own device. Not Play Store. |
| Commit path | Clipboard-first. Text injection is dropped for v1. |
| Engine interface | Abstraction built; Android `SpeechRecognizer` behind it. Cloud engine is a reserved slot, unbuilt. |
| Activation | Tap to start, tap to stop. No auto-stop, no silence detection, no max-duration cap. |
| Widget | Draggable, persists across apps, can be hidden per-app. |
| Privacy | On-device by default. Cloud opt-in exists in settings but is unbuilt in v1. |
| Language | Single, device default. No picker, no custom vocabulary. |
| Formatting | Raw engine output. No trailing newline, no post-processing, no separator. |
| Feedback | Widget shows idle/listening/done/failed. Transient bubble shows the transcript. |
| Failure | Error state on the widget, tap to retry. Clipboard untouched on failure. |
| Storage | Nothing persisted. No recent-transcripts list. |
| Permissions | All requested on first launch. No in-app guidance afterwards. |
| Stack | Kotlin, plain Views, minimal dependencies. |

## Edge cases

`DECIDED`

- Recognition fails or returns empty → failed state, retry tap, clipboard
  unchanged. Stale partial transcripts are never left on the clipboard.
- Second tap while already listening → stops and commits.
- Speech containing punctuation → whatever the engine produced, verbatim.
- No end-of-utterance detection; a long pause does not stop recording.

`ASSUMED` Rapid re-tapping the widget does not put the state machine into an
unrecoverable condition. Not designed in; to be observed during manual testing.

## Data, security, integrations

`DECIDED`

- Nothing is written to disk. No account, no history, no telemetry.
- Transcript transits the system clipboard, which is readable by other apps
  depending on Android version. Accepted for v1.
- Audio stays on the device in v1. A later cloud engine would send audio to a
  third party, which is a real exposure given shell commands and pasted
  credentials.
- No external service dependency in v1.

## Non-goals

`DECIDED` Explicitly out of scope for v1:

- iOS.
- Play Store release.
- AccessibilityService text injection.
- Cloud speech-to-text.
- Pause detection or auto-commit.
- Custom vocabulary and language selection.
- Transcript history or storage.
- Becoming a general keyboard/IME.

## Testing and acceptance

`DECIDED` Manual end-to-end on the user's own phone: speak a phrase in Termux
and in an SSH session, widget stops, preview shows the text, paste works, no
keyboard involved. Unit tests were considered and dropped from v1's bar.

## Unresolved risks

All `HITL`, owner is the user, settled by using the app rather than by further
interview:

1. On-device recognition accuracy on the user's actual vocabulary, including
   technical terms.
2. Whether denying the notification permission breaks the widget.
3. Whether OEM battery-optimization rules kill the overlay on the user's device.
4. Requesting all permissions on first launch with no later guidance: whether a
   subsequent revoke in Settings leaves the widget silently dead with no
   in-app route back.
5. Whether the clipboard-first downgrade is genuinely acceptable in daily use.
   The original request was "types what I say"; v1 is "copies to clipboard and
   you paste." This is the largest gap between the stated intent and the
   aligned product, and it is worth revisiting if daily use finds two taps
   too annoying.

`UNKNOWN` Node: does the chosen Android version and device expose a usable
on-device recognition model? Not verified.

No research or prototype branch was agreed. No implementation authorized.

## Skipped interview areas

- Security/permissions trust boundaries: covered under permissions and data.
  No multi-user or enterprise threat model applies to a personal sideloaded app.
- Integration contracts, timeouts, retries, idempotency: no external service in
  v1. Revisit with the cloud engine.
- Environment/CI: not applicable to a single-device sideload.