# =============================================================================
# fzf shell key-bindings (Homebrew)
# Loaded before completion so fzf's completions register properly.
# Path comes from `brew --prefix` so this survives an Intel -> ARM move.
# =============================================================================
FZF_SHELL="$(brew --prefix 2>/dev/null)/opt/fzf/shell"
if [[ -f "$FZF_SHELL/key-bindings.zsh" ]]; then
  source "$FZF_SHELL/key-bindings.zsh"
  source "$FZF_SHELL/completion.zsh"
fi
unset FZF_SHELL

# =============================================================================
# Module loader
# =============================================================================

source "$ZDOTDIR/options.zsh"       # History + shell behaviour setopts
source "$ZDOTDIR/fzf.zsh"           # fzf UI configuration
source "$ZDOTDIR/completion.zsh"    # Completion system
source "$ZDOTDIR/zoxide.zsh"        # Smart directory navigation
source "$ZDOTDIR/env.zsh"           # Environment variables & PATH
source "$ZDOTDIR/aliases.zsh"       # Aliases
source "$ZDOTDIR/plugins.zsh"       # Plugin manager & plugins
source "$ZDOTDIR/bindings.zsh"      # Keybindings (depends on plugins)
source "$ZDOTDIR/prompt.zsh"        # Prompt / theme

# =============================================================================
# Auto-start tmux session (only if not already inside tmux)
# =============================================================================
# if [[ -z "$TMUX" ]]; then
#   if ! tmux has-session -t dev 2>/dev/null; then
#     # Create code window: nvim (left, 60%) | opencode (right, 40%)
#     tmux new-session -d -s dev -n code -c ~
#     tmux split-window -h -t dev:code -p 40 -c ~
#     tmux send-keys -t dev:code.1 "nvim" Enter
#     tmux send-keys -t dev:code.2 "opencode" Enter

#     # Other windows
#     tmux new-window -t dev -n server -c ~
#     tmux new-window -t dev -n tests -c ~
#     tmux new-window -t dev -n git -c ~

#     tmux select-window -t dev:code
#   fi

#   exec tmux attach-session -t dev
# fi
