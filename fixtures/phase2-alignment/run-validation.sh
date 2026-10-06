#!/usr/bin/env bash
# Phase 2 fixture: structural gate check on grill-me walkthrough transcripts.
# Each transcript must show one-question-at-a-time interviewing with
# recommended answers, an alignment record with labels, a stop condition,
# and an explicit statement that no production artifact was touched.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/case-results.jsonl"
EVID="$HERE/evidence"
mkdir -p "$EVID"
: > "$OUT"
rc=0

cases="small-feature ambiguous-data-change api-integration frontend-workflow prototype-branch"
for c in $cases; do
  t0=$(date +%s)
  f="$HERE/transcripts/$c.md"
  pass=1; reasons=""
  grep -q "Recommended:" "$f" || { pass=0; reasons="$reasons missing-recommended-answer;"; }
  grep -q "## Alignment Record" "$f" || { pass=0; reasons="$reasons missing-alignment-record;"; }
  grep -Eq "\[(DECIDED|ASSUMED|UNKNOWN|HITL|RESEARCH)" "$f" || { pass=0; reasons="$reasons missing-labels;"; }
  grep -qi "stop condition" "$f" || { pass=0; reasons="$reasons missing-stop-condition;"; }
  grep -Eqi "turn[ 0-9]+.*\? -|Question" "$f" || { pass=0; reasons="$reasons missing-question-structure;"; }
  turns=$(grep -c '^\*\*Turn' "$f"); qs=$(grep -c 'Question:' "$f")
  [ "$turns" -eq "$qs" ] || { pass=0; reasons="$reasons turn-question-count-mismatch($turns/$qs);"; }
  grep -Eqi "no (files edited|migration written|component edited|implementation started|production artifact touched)" "$f" \
    || { pass=0; reasons="$reasons missing-no-edit-attestation;"; }
  dt=$(( $(date +%s) - t0 ))
  if [ $pass -eq 1 ]; then actual="gate-compliant"; else actual="violations:$reasons"; rc=1; fi
  node -e '
    const [suite,cs,expected,actual,score,dur,ev,ts] = process.argv.slice(1);
    process.stdout.write(JSON.stringify({suite:"phase2-alignment",case:cs,expected,actual,score:Number(score),status:Number(score)===1?"pass":"fail",duration_s:Number(dur),evidence:ev,known_fail:false,timestamp:ts})+"\n");' \
    "phase2-alignment" "$c" "gate-compliant transcript" "$actual" "$pass" "$dt" "$f" "$(date -u +%FT%TZ)" >> "$OUT"
  echo "$c: $([ $pass -eq 1 ] && echo PASS || echo "FAIL$reasons")"
done

echo "LOG: $OUT"
exit $rc
