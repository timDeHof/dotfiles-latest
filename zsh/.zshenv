# ~/.config/zsh/.zshenv
#
# ----------- XDG base directories -----------
# Centralizes config/cache/data locations
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ---------- Editor -------------
# Default editor used by git, crontab, etc.
export EDITOR="vim"
export VISUAL="vim"

# ---------- GPG ----------------
export GPG_TTY=$(tty)

# ---------- PATH ---------------
# Keep only the first copy of each PATH entry. env.zsh prepends ~/.local/bin
# again after path_helper reorders PATH, and that copy must win.
# Both names are needed: -U on path alone does not dedupe `PATH=...` assignments.
typeset -U PATH path
# Personal binaries/scripts
export PATH="$HOME/.local/bin:$PATH"

# ---------- Pager ---------------
if command -v bat >/dev/null 2>&1; then
	export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
	export MANPAGER="batcat -l man -p"
fi
