#!/usr/bin/env bash
# Shows the newest Claude plan note and redraws it when the plans folder changes.
# Used by the plan pane in sessions/claude-notes.kitty-session.
dir="${PLAN_DIR:-$HOME/Dev/vaults/10-19 Work/11-Projects/11.07-Claude-Plans}"

# kitty splits the window after this script starts, so the pane is bigger at first than it ends up.
pane_rows() {
  local r="${PLAN_ROWS:-$(stty size </dev/tty 2>/dev/null | cut -d' ' -f1)}"
  echo "${r:-24}"
}
pane_cols() {
  local c="${PLAN_COLS:-$(stty size </dev/tty 2>/dev/null | cut -d' ' -f2)}"
  echo "${c:-80}"
}

show() {
  clear
  # 11.07.00 is the dashboard, so plans start at 11.07.10.
  local f
  f=$(ls -t "$dir"/11.07.[1-9]*.md 2>/dev/null | head -1)
  if [ -z "$f" ]; then
    echo "No plan notes yet in $dir"
    return
  fi
  # Print the note from its top. A taller note is cut to the pane height and the cut is
  # marked, because output taller than the pane scrolls the top away.
  # bat wraps long lines itself, so each output line is one pane row.
  local rows cols out total
  rows=$(pane_rows)
  cols=$(pane_cols)
  last_size="$rows $cols"
  out=$(printf '%s\n\n' "${f##*/}"; bat --paging=never --language=markdown --style=plain --color=always --wrap=character --terminal-width="$cols" "$f")
  total=$(printf '%s\n' "$out" | wc -l | tr -d ' ')
  if [ "$total" -lt "$rows" ]; then
    printf '%s\n' "$out"
  else
    printf '%s\n' "$out" | head -n $((rows - 2))
    printf '… %d more lines\n' $((total - rows + 2))
  fi
}

show
# Redraw on a folder change, and when the pane size changes (polled once a second).
fswatch -o "$dir" | while :; do
  read -r -t 1 _
  status=$?
  if [ $status -eq 0 ]; then
    show
  elif [ $status -le 128 ]; then
    break # fswatch ended
  elif [ "$(pane_rows) $(pane_cols)" != "$last_size" ]; then
    show
  fi
done
