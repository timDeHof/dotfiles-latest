# =============================================================================
# Language runtimes
# =============================================================================

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                    # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion

# =============================================================================
# Package managers
# =============================================================================

# pnpm
export PNPM_HOME="/Users/timothydehof/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH=~/.npm-global/bin:$PATH

# Bun
export PATH="/Users/timothydehof/.bun/bin:$PATH"

# =============================================================================
# Languages
# =============================================================================

export PATH=$PATH:$HOME/.local/opt/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH="$(brew --prefix)/opt/openjdk/bin:$PATH"

# =============================================================================
# Databases
# =============================================================================

export PATH="/Library/PostgreSQL/16/bin:$PATH"

# =============================================================================
# Editors & tools
# =============================================================================

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# =============================================================================
# Terminal integrations
# =============================================================================

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# =============================================================================
# Agentbox
# =============================================================================

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.local/bin/agentbox:${PATH}"
source "${HOME}/.local/bin/agentbox/agentbox.completion"

# =============================================================================
# Misc tooling
# =============================================================================

# Antigravity
export PATH="/Users/timothydehof/.antigravity/antigravity/bin:$PATH"

# Google Stitch MCP
export GOOGLE_CLOUD_PROJECT="clever-passage-492016-h4"
[[ -f ~/.config/secrets/stitch_api_key ]] && export STITCH_API_KEY="$(<~/.config/secrets/stitch_api_key)"

# =============================================================================
# GitHub Forwarding
# =============================================================================
export GITHUB_USER_NAME="timDeHof"
export GITHUB_USER_EMAIL="ttdehof@gmail.com"

# =============================================================================
# Gemini API (for logsync daily note summaries)
# =============================================================================
[[ -f ~/.config/secrets/gemini_api_key ]] && export GEMINI_API_KEY="$(<~/.config/secrets/gemini_api_key)"
