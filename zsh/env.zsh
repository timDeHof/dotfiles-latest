# =============================================================================
# Language runtimes
# =============================================================================

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export NVM_DIR="$HOME/.nvm"
# nvm is lazy: sourcing nvm.sh costs about 0.2 s per shell. node and npm come from the default
# alias on PATH, and the first `nvm` call loads the real nvm.
# shortcut: only a numeric default alias (e.g. 24) is resolved, not lts/* or node, switch to a plain PATH entry if that changes.
_nvm_default_bin() {
  setopt localoptions numericglobsort nullglob
  local a; a=$(<"$NVM_DIR/alias/default") 2>/dev/null || return
  local -a v; v=("$NVM_DIR"/versions/node/v${a#v}*(On))
  (( $#v )) && print -r -- "$v[1]/bin"
}
if [[ -s $NVM_DIR/nvm.sh ]]; then
  _nvm_bin=$(_nvm_default_bin) && [[ -n $_nvm_bin ]] && path=("$_nvm_bin" $path)
  unset _nvm_bin
  nvm() {
    unset -f nvm
    \. "$NVM_DIR/nvm.sh"
    [[ -s $NVM_DIR/bash_completion ]] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi

# =============================================================================
# Package managers
# =============================================================================

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Bun
export PATH="$HOME/.bun/bin:$PATH"

# =============================================================================
# Languages
# =============================================================================

export PATH=$PATH:$HOME/go/bin
export PATH="$(brew --prefix)/opt/openjdk/bin:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"   # after openjdk, so `java` and JAVA_HOME are the same JDK

# .NET global tools (/etc/paths.d/dotnet-cli-tools adds a literal ~ that zsh does not expand)
path+=("$HOME/.dotnet/tools")

# =============================================================================
# Databases
# =============================================================================

export PATH="/Library/PostgreSQL/16/bin:$PATH"

# =============================================================================
# Editors & tools
# =============================================================================

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Docker Desktop CLI tools (docker-compose, kubectl, credential helpers)
export PATH="$PATH:$HOME/.docker/bin"

# =============================================================================
# Terminal integrations
# =============================================================================

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# =============================================================================
# Agentbox
# =============================================================================

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.local/bin/agentbox:${PATH}"
[[ -r ${HOME}/.local/bin/agentbox/agentbox.completion ]] && source "${HOME}/.local/bin/agentbox/agentbox.completion"

# =============================================================================
# Misc tooling
# =============================================================================

# Antigravity IDE
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# Google Stitch MCP
export GOOGLE_CLOUD_PROJECT="clever-passage-492016-h4"
# STITCH_API_KEY is not exported: opencode reads ~/.config/opencode/.env.

# =============================================================================
# GitHub Forwarding
# =============================================================================
export GITHUB_USER_NAME="timDeHof"
export GITHUB_USER_EMAIL="ttdehof@gmail.com"
