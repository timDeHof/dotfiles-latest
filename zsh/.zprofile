# ~/.config/zsh/.zprofile
#
# Runs for login shells, after /etc/zprofile. That file runs path_helper,
# which reorders PATH, so PATH prepends that must win go here, not .zshenv.

# ---------- Homebrew ------------
# Puts /opt/homebrew/bin ahead of /usr/local/bin and adds Homebrew's zsh
# completions to fpath (must run before compinit in completion.zsh).
eval "$(/opt/homebrew/bin/brew shellenv)"
