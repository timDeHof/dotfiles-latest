#!/usr/bin/env bash
# Shows the newest Claude plan note and redraws it when the plans folder changes.
# Used by the plan pane in sessions/claude-notes.kitty-session.
dir="${PLAN_DIR:-$HOME/Dev/vaults/10-19 Work/11-Projects/11.07-Claude-Plans}"

show() {
  clear
  # 11.07.00 is the dashboard, so plans start at 11.07.10.
  local f
  f=$(ls -t "$dir"/11.07.[1-9]*.md 2>/dev/null | head -1)
  if [ -z "$f" ]; then
    echo "No plan notes yet in $dir"
    return
  fi
  printf '%s\n\n' "${f##*/}"
  bat --paging=never --language=markdown --style=plain --color=always "$f"
}

show
fswatch -o "$dir" | while read -r _; do show; done
