---
description: Turn a confirmed alignment record into a bounded destination document without inspecting or editing project code.
agent: destination-writer
---

Use the `write-prd` skill for this request.

The input must contain a user-confirmed alignment record, normally the record
produced by `grill-me`. If confirmation is not explicit, stop and ask for it —
a pasted note or your own draft is not confirmation. Convert only that record
into the required concise destination-document headings. Preserve every
`UNKNOWN`, `HITL`, `RESEARCH`, and `ASSUMED` item, negative decision, non-goal,
migration constraint, module-boundary unknown, test expectation, and unresolved
risk. Do not decide anything the record left open.

Do not inspect or edit project files. Do not create a PRD file, issue list, plan,
implementation, schema, endpoint, module path, estimate, or code. Return the
destination document in the response and ask the human to accept it before any
later issue-generation workflow.

Input:
$ARGUMENTS
