# =============================================================================
# Modern tool replacements
# =============================================================================

# Better ls
alias ls='eza --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Short listing (uses ls alias to eza)
alias l='ls -CF'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =============================================================================
# Core utilities
# =============================================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =============================================================================
# Navigation
# =============================================================================

alias -- -='cd -'          # jump to previous directory (-- prevents - as a flag)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias cproj="cd ~/dev"     # tweak path to your main projects dir

# =============================================================================
# Editor
# =============================================================================

alias vim='nvim'

# =============================================================================
# Git
# =============================================================================

alias gs="git status --short --branch"
alias gb="git branch -v"
alias gl="git log --oneline --graph --decorate -10"
alias gd="git diff"
alias ga="git add -A"
alias gac="git add -A && git commit -m"
alias gnc="git commit --amend --no-edit"
alias gwip="git add -A && git commit -m 'WIP'"
alias ginit="git add -A && git commit -m 'Initial commit'"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gcob="git checkout -b"
alias back="git checkout @{-1}"                             # jump back to last branch
alias glog='PAGER="less -F -X" git log'                    # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# =============================================================================
# Docker
# =============================================================================

alias dps="docker ps"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

# =============================================================================
# Dev Shortcuts
# =============================================================================

alias pna="pnpm add"
alias prd="pnpm dev"
alias prb="pnpm build"

alias ni="npm install"
alias nrd="npm run dev"
alias nrb="npm run build"

# .NET global tools built for older runtimes; roll forward to the installed .NET 10.
alias dotnet-metrics='DOTNET_ROLL_FORWARD=Major "$HOME/.dotnet/tools/dotnet-metrics"'
alias httprepl='DOTNET_ROLL_FORWARD=Major "$HOME/.dotnet/tools/httprepl"'

# =============================================================================
# Utilities
# =============================================================================

alias flashcards='cd $HOME/Dev/Projects/Tools/flashcardConverter && uv run python main.py'
alias weather='curl v2.wttr.in?format=1'
alias reload="source ~/.config/zsh/.zshrc"


# =============================================================================
# Video
# =============================================================================

alias stream='mpv av://v4l2:/dev/video4 --fullscreen --demuxer-lavf-o=input_format=mjpeg,framerate=30 --profile=low-latency --untimed'

# =============================================================================
# Gemini Vault Automations
# =============================================================================

alias watchinbox='"$HOME/Dev/vaults/00-09-System/07-Scripts/inbox-watcher.sh"'
alias dsadaily='"$HOME/Dev/vaults/00-09-System/07-Scripts/update-dsa-daily.sh"'

# =============================================================================
# OpenCode
# =============================================================================
alias oc='"$HOME/Dev/opencode-docker/run.sh"'
