# Output: UNCONFIRMED input guard

Input: `inputs/unconfirmed-guard.md` — pasted alignment notes with no
confirmation statement.

## Observed behavior (authored expected output)

I cannot write this destination document yet, because the input is not a
confirmed alignment record.

The notes you pasted contain no confirmation that you accept these decisions,
and two items are not merely unconfirmed but undecided:

- Export format and destination were never discussed.
- Expected data volume and what happens when it is large were never discussed.
- The target user is marked `ASSUMED`, not stated by you.

Per the `write-prd` skill's preconditions, confirmation must be explicit; it is
not inferred from the presence of notes. Writing a destination document now
would convert an unconfirmed guess into a definition of done.

## What is needed to proceed

1. Confirm, correct, or reject the pasted record.
2. Decide export format and destination, or explicitly mark them `UNKNOWN` with
   an owner.
3. Confirm whether the user is operations staff, or correct it.
4. Confirm or defer the testing expectation.

Once you confirm, I will produce the destination document with the headings the
skill requires, preserving every `UNKNOWN`, `ASSUMED`, and `HITL` item, and
stopping at human review.

## Attestation

No destination document was produced. No project files were inspected or
edited. No plan, issue list, schema, or implementation was created.
