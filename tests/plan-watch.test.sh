#!/usr/bin/env bash
# Run: bash tests/plan-watch.test.sh
#
# The plan pane is short. When the note is taller than the pane, plan-watch.sh must still
# show the note from its top and mark what it cut, instead of scrolling the top away.
# A long line wraps to several pane rows, so it counts as those rows.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin" "$tmp/plans"
printf '#!/bin/sh\nexit 0\n' > "$tmp/bin/fswatch"   # no change events, so the loop ends
# bat stand-in. Like the real bat writing to a pipe, it does not wrap unless it is given
# --terminal-width, so the pane wraps the long lines instead.
cat > "$tmp/bin/bat" <<'STUB'
#!/bin/sh
w=""
for a in "$@"; do
  case "$a" in
    --terminal-width=*) w="${a#*=}" ;;
    -*) ;;
    *) f="$a" ;;
  esac
done
if [ -n "$w" ]; then fold -w "$w" "$f"; else cat "$f"; fi
STUB
chmod +x "$tmp/bin/fswatch" "$tmp/bin/bat"
{
  echo '---'; echo 'jd-id: 11.07.10'; echo '---'
  printf 'long %.0s' $(seq 1 30); echo
  for i in $(seq 1 60); do echo "step $i"; done
} > "$tmp/plans/11.07.10-Tall-Note.md"

rows=24; cols=40
out="$(PATH="$tmp/bin:$PATH" TERM=dumb PLAN_DIR="$tmp/plans" PLAN_ROWS=$rows PLAN_COLS=$cols bash "$ROOT/kitty/scripts/plan-watch.sh" 2>&1)"
fail=0
check() { if eval "$2"; then echo "PASS $1"; else echo "FAIL $1"; fail=1; fi; }
# rows the pane needs: each line takes ceil(length / cols) rows
used="$(printf '%s\n' "$out" | awk -v c=$cols '{ n += ($0 == "" ? 1 : int((length($0) + c - 1) / c)) } END { print n }')"

check "the file name is shown" '[[ $out == *11.07.10-Tall-Note.md* ]]'
check "the top of the note is shown" '[[ $out == *jd-id:\ 11.07.10* ]]'
check "output fits the $rows-row pane (needs $used rows)" '[[ $used -lt $rows ]]'
check "the cut is marked" '[[ $out == *"more lines"* ]]'
exit $fail
