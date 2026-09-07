# =============================================================================
# Completion
# =============================================================================

# fpath additions MUST come before compinit, or the completions they add are
# never picked up. (Docker Desktop appends its own fpath+compinit block to
# .zshrc on update — if that reappears, move the fpath line here and delete
# the duplicate compinit rather than letting compinit run twice.)
fpath=("$HOME/.docker/completions" $fpath)

# Load completion system
autoload -Uz compinit

# Initialize completion with cached metadata file
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # lowercase input match
