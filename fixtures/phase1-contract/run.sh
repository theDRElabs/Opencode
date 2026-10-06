#!/usr/bin/env bash
# Phase 1 fixture runner: three scenarios, structured JSONL log, real artifacts.
set -u
BASE=/tmp/opencode/phase1-fixture-run
WORK=$BASE/work
LOG=$BASE/phase1-fixture.jsonl
EVID=$BASE/evidence
mkdir -p "$EVID"
: > "$LOG"

cp -r /tmp/opencode/phase1-fixture "$WORK/fixture"
cd "$WORK/fixture" || exit 1

log_line() {
  node -e '
    const [ts,scenario,request,rule,lane,actions,exit_code,artifacts] = process.argv.slice(1);
    process.stdout.write(JSON.stringify({
      timestamp: ts, scenario, request, contract_rule: rule, lane,
      actions: JSON.parse(actions), exit_code: Number(exit_code),
      artifacts: JSON.parse(artifacts)
    }) + "\n");' "$@" >> "$LOG"
}

exit_a=0; exit_b=0; exit_c=0

# ---------- Scenario A: ambiguous HITL request ----------
snap_before=$(find scripts -type f -exec md5sum {} + | sort)
cat > "$EVID/A-alignment-record.md" <<'EOF'
# Alignment record (fixture)
Request: "Make the usage report more useful."
Decision: ambiguous — no acceptance criteria, requires product judgment.
Action: stopped at alignment; no code edited.
EOF
snap_after=$(find scripts -type f -exec md5sum {} + | sort)
if [ "$snap_before" = "$snap_after" ]; then acts_a='["clarification_requested","alignment_stop","no_edits"]'; else acts_a='["ERROR:edited_code"]'; exit_a=1; fi
log_line "$(date -u +%FT%TZ)" "A" "Make the usage report more useful." \
  "HITL: ambiguous/high-impact requests route to alignment before implementation" \
  "alignment" "$acts_a" "$exit_a" '["'"$EVID"'/A-alignment-record.md"]'
echo "A: exit=$exit_a lane=alignment"

# ---------- Scenario B: small obvious one-line fix ----------
sed -i "s/Output is written to token-report.csv./Output is written to stdout./" scripts/token-report.js
help_out=$(node scripts/token-report.js --help 2>&1); b1=$?
echo "$help_out" > "$EVID/B-help-output.txt"
echo "$help_out" | grep -q "stdout" && ! echo "$help_out" | grep -q "token-report.csv"
[ $? -eq 0 ] && [ $b1 -eq 0 ]; exit_b=$?
log_line "$(date -u +%FT%TZ)" "B" "--help text references stale output filename token-report.csv; fix the string." \
  "Default Lifecycle: small obvious fixes may start at implementation" \
  "implement-direct" '["edit_help_string","run_--help_check"]' "$exit_b" \
  '["'"$EVID"'/B-help-output.txt"]'
echo "B: exit=$exit_b lane=implement-direct"

# ---------- Scenario C: bounded AFK issue ----------
cat > "$EVID/C-issue.md" <<'EOF'
# Issue (fixture)
Add --total-only flag: prints just the totals line, exit 0, no schema change.
AFK: bounded scope, deterministic check, no unresolved human decision.
EOF
node -e '
  const fs = require("fs");
  const p = "scripts/token-report.js";
  let s = fs.readFileSync(p, "utf8");
  if (!s.includes("--total-only")) {
    s = s.replace(
      "if (process.argv.includes(\x27--help\x27)) {",
      "if (process.argv.includes(\x27--total-only\x27)) {\n  const d = JSON.parse(fs.readFileSync(path.join(__dirname, \x27..\x27, \x27usage.json\x27), \x27utf8\x27));\n  const dd = Number(process.argv[process.argv.indexOf(\x27--days\x27) + 1]) || d.length;\n  const rr = d.slice(-dd);\n  console.log(`total      ${String(rr.reduce((a,r)=>a+r.input,0)).padStart(6)}  ${String(rr.reduce((a,r)=>a+r.output,0)).padStart(6)}`);\n  process.exit(0);\n}\n\nif (process.argv.includes(\x27--help\x27)) {"
    );
    fs.writeFileSync(p, s);
  }'
total_out=$(node scripts/token-report.js --total-only 2>&1); c1=$?
echo "$total_out" > "$EVID/C-total-only-output.txt"
echo "$total_out" | grep -q "^total" && [ $c1 -eq 0 ]; exit_c=$?
cat > "$EVID/C-independent-review-note.md" <<'EOF'
# Independent review requirement
AFK lane autonomous implementation permitted; verification separation still
requires a fresh-context independent review before completion.
EOF
log_line "$(date -u +%FT%TZ)" "C" "Add --total-only flag to token-report.js (bounded AFK issue)." \
  "Autonomy Levels: AFK bounded implementation; Verification Separation requires independent review" \
  "afk-implement" '["implement_flag","run_check","note_independent_review"]' "$exit_c" \
  '["'"$EVID"'/C-issue.md","'"$EVID"'/C-total-only-output.txt","'"$EVID"'/C-independent-review-note.md"]'
echo "C: exit=$exit_c lane=afk-implement"

echo "LOG: $LOG"
exit $((exit_a + exit_b + exit_c))
