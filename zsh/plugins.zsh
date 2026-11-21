# =========================================================
# Plugins
# =========================================================

# Each plugin is pinned to a commit, so a new shell never runs unreviewed upstream code.
# To update: run zplugin-update, review the upstream changes, then edit the commit below.
ZPLUGINDIR="${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}"
ZPLUGIN_HOST="${ZPLUGIN_HOST:-https://github.com}"   # overridable so tests can use a local repo

# _zplugin_load <owner> <name> <commit>
_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}" sha=$3 url="${ZPLUGIN_HOST}/${1}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    # fetch by commit (GitHub allows it) so the install never sees any other commit
    { git init -q "$plugin_path" \
      && git -C "$plugin_path" remote add origin "$url" \
      && git -C "$plugin_path" fetch -q --depth=1 origin "$sha" \
      && git -C "$plugin_path" checkout -q FETCH_HEAD; } \
      || { echo "ERROR: failed to install ${2} at ${sha}" >&2; rm -rf "$plugin_path"; return 1; }
  elif [[ $(<"$plugin_path/.git/HEAD") != $sha ]]; then   # file read, no git process on the fast path
    { git -C "$plugin_path" checkout -q --detach "$sha" 2>/dev/null \
      || { git -C "$plugin_path" fetch -q --depth=1 origin "$sha" && git -C "$plugin_path" checkout -q FETCH_HEAD; }; } \
      || { echo "ERROR: ${2} is not at ${sha} and could not be moved there" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

# zplugin-update: show pinned vs latest upstream commit for each plugin (changes nothing)
zplugin-update() {
  local dir
  for dir in "${ZPLUGINDIR}"/*/; do
    echo "${dir:t}: pinned $(git -C "$dir" rev-parse HEAD) latest $(git -C "$dir" ls-remote origin HEAD | cut -f1)"
  done
}

(( ${+ZPLUGIN_DEFINE_ONLY} )) && return 0   # test hook: define the functions, load nothing

_zplugin_load zsh-users zsh-autosuggestions 85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5
_zplugin_load zsh-users zsh-history-substring-search 14c8d2e0ffaee98f2df9850b19944f32546fdea5
_zplugin_load jeffreytse zsh-vi-mode 08bd1c04520418faee2b9d1afbc410ee1a59a8f1
_zplugin_load zdharma-continuum fast-syntax-highlighting 3d574ccf48804b10dca52625df13da5edae7f553
