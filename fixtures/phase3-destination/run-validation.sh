#!/usr/bin/env bash
# Phase 3 fixture: structural gate check on write-prd destination documents.
#
# HONESTY NOTE: the documents under outputs/ are AUTHORED walkthroughs written by
# hand while porting the skill. They are not recorded agent runs. This grader
# checks that the skill's contract is satisfiable and mechanically checkable; it
# does not demonstrate that a live agent satisfies it.
#
# Each destination case must:
#   - carry all 12 required headings, in the skill's order;
#   - preserve at least one unresolved label (UNKNOWN/HITL/RESEARCH);
#   - carry explicit negative decisions (non-goals) and a risk section;
#   - contain no implementation artifacts (code, module paths, endpoints,
#     schema DDL, issue IDs, estimates, task sequences, issue authorization);
#   - stop at human review rather than authorizing issue generation; and
#   - stay inside the prose bound.
#
# The unconfirmed-guard case must REFUSE to write a document.
# The mutation-negative case must be REJECTED by this grader.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/case-results.jsonl"
: > "$OUT"
rc=0

HEADINGS="Status|Problem and Users|Solution|Observable Stories|Acceptance Criteria|Data Behavior|Contracts and Module Map|Security Constraints|Testing and QA|Non-Goals|Unresolved Risks|Handoff"

# heading_order <file> -> "ok" | "missing-or-misordered:<heading>"
heading_order() {
  node -e '
    const fs = require("fs");
    const want = process.argv[1].split("|");
    const text = fs.readFileSync(process.argv[2], "utf8");
    const found = text.split("\n")
      .filter(l => /^##\s+/.test(l))
      .map(l => l.replace(/^##\s+/, "").trim());
    let i = 0;
    for (const h of want) {
      const at = found.indexOf(h, i);
      if (at === -1) { process.stdout.write("missing-or-misordered:" + h); process.exit(0); }
      i = at + 1;
    }
    process.stdout.write("ok");
  ' "$HEADINGS" "$1"
}

# no_implementation <file> -> "ok" | first violation class
no_implementation() {
  node -e '
    const fs = require("fs");
    const text = fs.readFileSync(process.argv[1], "utf8");
    const rules = [
      ["code-block", /```/],
      ["issue-id", /ISSUE-\d+/i],
      ["module-path", /\b(src|app|lib|components|server|scripts)\/[A-Za-z0-9_.-]+\b/],
      ["api-endpoint", /\b(GET|POST|PUT|PATCH|DELETE)\s+\/|https?:\/\//],
      ["schema-ddl", /\bCREATE\s+TABLE\b|\bALTER\s+TABLE\b|\bADD\s+COLUMN\b/i],
      ["estimate", /\b\d+\s?(hours?|days?|weeks?|sprints?|story points?)\b/i],
      ["task-sequence", /\b(step|phase|task|iteration|milestone)\s*\d+\b/i],
      ["issue-authorization", /(?<!not )(?<!never )\bready for issue generation\b/i],
      ["next-steps", /\bnext steps\b|\bthen we will\b|\bproceeding to implementation\b/i]
    ];
    const hits = [];
    for (const [name, re] of rules) {
      if (re.test(text)) hits.push(name);
    }
    process.stdout.write(hits.length ? hits.join(",") : "ok");
  ' "$1"
}

# prose_bounded <file> <max-words> <max-prose-block-words>
prose_bounded() {
  node -e '
    const fs = require("fs");
    const file = process.argv[1];
    const maxWords = Number(process.argv[2]);
    const maxBlock = Number(process.argv[3]);
    const text = fs.readFileSync(file, "utf8");
    const words = text.split(/\s+/).filter(Boolean).length;
    if (words > maxWords) { process.stdout.write("word-count-" + words + ">" + maxWords); process.exit(0); }
    // Prose = runs of lines that are not headings, lists, tables, or code.
    const marker = /^\s*(#{1,6}\s|[-*+]\s|\d+[.)]\s|\||```)/;
    let buf = [];
    const flush = () => {
      const bw = buf.join(" ").split(/\s+/).filter(Boolean).length;
      buf = [];
      if (bw > maxBlock) { process.stdout.write("prose-block-" + bw + ">" + maxBlock); process.exit(0); }
    };
    for (const line of text.split("\n")) {
      if (marker.test(line)) { flush(); continue; }
      if (!line.trim()) { flush(); continue; }
      buf.push(line.trim());
    }
    flush();
    process.stdout.write("ok");
  ' "$1" "$2" "$3"
}

emit() { # case expected actual score evidence
  node -e '
    const [cs, expected, actual, score, ev] = process.argv.slice(1);
    const s = Number(score);
    process.stdout.write(JSON.stringify({
      suite: "phase3-destination",
      case: cs,
      expected,
      actual,
      score: s,
      status: s === 1 ? "pass" : "fail",
      duration_s: 0,
      evidence: ev,
      known_fail: false,
      timestamp: new Date().toISOString().replace(/\.\d{3}Z$/, "Z")
    }) + "\n");
  ' "$1" "$2" "$3" "$4" "$5" >> "$OUT"
  if [ "$4" = 1 ]; then echo "$1: PASS $3"; else echo "$1: FAIL $3"; fi
}

# check_document <case> <file> <newline-separated regex tokens> [max-words]
check_document() {
  local c="$1" f="$2" tokens="$3" maxw="${4:-900}"
  local pass=1 reasons="" h impl prose dt missing=""
  h=$(heading_order "$f")
  [ "$h" = "ok" ] || { pass=0; reasons="$reasons $h;"; }
  impl=$(no_implementation "$f")
  [ "$impl" = "ok" ] || { pass=0; reasons="$reasons implementation-artifact:$impl;"; }
  prose=$(prose_bounded "$f" "$maxw" 95)
  [ "$prose" = "ok" ] || { pass=0; reasons="$reasons $prose;"; }
  grep -Eq '\b(UNKNOWN|HITL|RESEARCH)\b' "$f" || { pass=0; reasons="$reasons dropped-unresolved-labels;"; }
  grep -Eqi '^## Non-Goals' "$f" || { pass=0; reasons="$reasons missing-non-goals;"; }
  grep -Eqi '^## Unresolved Risks' "$f" || { pass=0; reasons="$reasons missing-risks;"; }
  grep -Eqi 'ready for (human )?review' "$f" || { pass=0; reasons="$reasons missing-review-handoff;"; }
  grep -Eqi 'not ready for issue generation|until a human explicitly accepts' "$f" \
    || { pass=0; reasons="$reasons handoff-authorizes-issue-generation;"; }
  local tok
  while IFS= read -r tok; do
    [ -z "$tok" ] && continue
    grep -Eqi -- "$tok" "$f" || missing="$missing [$tok]"
  done <<< "$tokens"
  [ -z "$missing" ] || { pass=0; reasons="$reasons missing-preservation:$missing;"; }

  local actual
  if [ $pass -eq 1 ]; then actual="gate-compliant document"; else actual="violations:$reasons"; rc=1; fi
  emit "$c" "gate-compliant destination document" "$actual" "$pass" "$f"
}

# --- guard case: unconfirmed input must be refused ----------------------------
c="unconfirmed-guard"; f="$HERE/outputs/$c.md"; pass=1; reasons=""
grep -Eqi 'cannot write|not write|ask(s|ed)? for confirmation|stops and asks' "$f" \
  || { pass=0; reasons="$reasons did-not-refuse;"; }
grep -Eqi '\bconfirmation\b' "$f" || { pass=0; reasons="$reasons missing-confirmation-request;"; }
grep -Eqi 'No destination document was produced' "$f" || { pass=0; reasons="$reasons missing-refusal-attestation;"; }
if grep -Eq '^## Status' "$f"; then pass=0; reasons="$reasons produced-a-destination-document;"; fi
impl=$(no_implementation "$f")
[ "$impl" = "ok" ] || { pass=0; reasons="$reasons implementation-artifact:$impl;"; }
if [ $pass -eq 1 ]; then actual="refused without confirmation"; else actual="violations:$reasons"; rc=1; fi
emit "$c" "refuses unconfirmed input" "$actual" "$pass" "$f"

# --- destination document cases ----------------------------------------------
# Third argument is ONE quoted string with one preservation regex per line.
check_document "small-feature" "$HERE/outputs/small-feature.md" 'per (reader|user)
optimistic
empty (state|message)
listing pages?
\bUNKNOWN\b
\bHITL\b
Migration: none
(server rejects|rejects the save)'

check_document "data-change" "$HERE/outputs/data-change.md" 'atomic
verified backup
[Rr]ollback
abort
public API
audit record
\bUNKNOWN\b
\bHITL\b
[Nn]o module paths'

check_document "api-integration" "$HERE/outputs/api-integration.md" '[Pp]rovider.*\bUNKNOWN\b
not selected
\bRESEARCH\b
unavailable state
credential
international
label purchase
tracking
returns
\bHITL\b
[Nn]o endpoint
one working day'

check_document "frontend-workflow" "$HERE/outputs/frontend-workflow.md" 'exclusive
claim
evidence version
escalat
failure queue
draft
SSO/MFA
batch
\bUNKNOWN\b
\bHITL\b
not yet specified'

check_document "prototype-branch" "$HERE/outputs/prototype-branch.md" '\bRESEARCH\b
disposable
non-sensitive
eight
counterbalanced
zero
atomic
disposed
\bHITL\b
not production scope
one session'

# --- mutation control: a violating document must be rejected ------------------
c="mutation-negative"; f="$HERE/cases/$c.md"
h=$(heading_order "$f"); impl=$(no_implementation "$f"); prose=$(prose_bounded "$f" 900 95)
rejected=""
[ "$h" != "ok" ] && rejected="heading-order:$h"
[ "$impl" != "ok" ] && rejected="$rejected implementation-artifact:$impl"
[ "$prose" != "ok" ] && rejected="$rejected $prose"
if ! grep -Eq '\b(UNKNOWN|HITL|RESEARCH)\b' "$f"; then rejected="$rejected dropped-unresolved-labels"; fi
if grep -Eqi '^## Non-Goals' "$f" && ! grep -Eqi 'nothing was excluded' "$f"; then
  rejected="$rejected non-goals-not-negative"
fi
if [ -n "$rejected" ]; then
  emit "$c" "grader rejects violating document" "rejected:${rejected# }" 1 "$f"
else
  rc=1
  emit "$c" "grader rejects violating document" "NOT-rejected-grader-found-nothing" 0 "$f"
fi

echo "LOG: $OUT"
exit $rc
