#!/usr/bin/env bash
#
# link-dotfiles.sh — provision the symlinks from this repo into their live
# locations. Idempotent: safe to run as often as you like.
#
# This is the symlink half of the old zshrc/zshrc-file.sh, extracted into a
# standalone script. Linking is a provisioning step, not per-shell config, so
# it does not belong in an rc file that runs on every terminal launch.
#
# Deliberately NOT carried over from zshrc-file.sh:
#   - the two LaunchAgents (autoPushGithub every 180s, tmuxKillSessions)
#   - prompt initialisation (oh-my-posh)
#   - PATH mutation
#   - the ~/.zshrc target — see the ZDOTDIR note under ENTRIES below
#
# Usage:
#   ./bin/link-dotfiles.sh --dry-run    # show what would change, touch nothing
#   ./bin/link-dotfiles.sh              # apply
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=true ;;
    -h|--help)    sed -n '2,22p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; exit 0 ;;
    *) echo "unknown option: $arg (try --help)" >&2; exit 2 ;;
  esac
done

if [[ -t 1 ]]; then
  BOLD=$'\033[1m'; RED=$'\033[31m'; GREEN=$'\033[32m'
  YELLOW=$'\033[33m'; BLUE=$'\033[34m'; DIM=$'\033[2m'; OFF=$'\033[0m'
else
  BOLD=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; DIM=""; OFF=""
fi

# ─────────────────────────────────────────────────────────────────────────────
# ENTRIES:  source-relative-to-repo | target | guard
#
# guard is optional and gates the entry on something actually being installed:
#   cmd:NAME    require NAME on PATH
#   path:/abs   require that path to exist
# A failed guard SKIPS the entry. It never removes an existing link.
#
# NOTE: there is intentionally no ~/.zshrc entry. ~/.zshenv on this machine
# sets ZDOTDIR=$XDG_CONFIG_HOME/zsh, so zsh reads ~/.config/zsh/.zshrc and
# ~/.zshrc is never sourced. Linking it would be a silent no-op, and pointing
# this repo's zshrc-file.sh at $ZDOTDIR/.zshrc would clobber the modular zsh
# config that actually runs. Manage ~/.config/zsh separately.
# ─────────────────────────────────────────────────────────────────────────────
ENTRIES=(
  "vimrc/vimrc-file|$HOME/.vimrc|"
  "vimrc/vimrc-file|$HOME/github/obsidian_main/.obsidian.vimrc|"
  "bashrc/bashrc-file.sh|$HOME/.bashrc|"
  "tmux/tmux.conf.sh|$HOME/.tmux.conf|cmd:tmux"
  "alacritty/alacritty.toml|$HOME/.config/alacritty/alacritty.toml|cmd:alacritty"
  "kitty/kitty.conf|$HOME/.config/kitty/kitty.conf|cmd:kitty"
  # wezterm is intentionally unmanaged: ~/.config/wezterm/wezterm.lua is a
  # hand-tuned local config (Tokyo Night Storm / MesloLGS 19pt) and kitty is
  # the daily driver. Adding it back would clobber that with the inherited
  # 200-line upstream version.
  "ghostty|$HOME/.config/ghostty|cmd:ghostty"
  "rio|$HOME/.config/rio|cmd:rio"
  "yabai/yabairc|$HOME/.yabairc|cmd:yabai"
  "sketchybar/felixkratz-linkarzu|$HOME/.config/sketchybar|cmd:sketchybar"
  "hammerspoon|$HOME/.hammerspoon|path:/Applications/Hammerspoon.app"
  "karabiner/mxstbr|$HOME/.config/karabiner|path:/Applications/Karabiner-Elements.app"
  "ubersicht/.simplebarrc|$HOME/.simplebarrc|path:/Applications/Ubersicht.app"
  ".prettierrc.yaml|$HOME/.prettierrc.yaml|"
  "vscode/settings.json|$HOME/Library/Application Support/Code/User/settings.json|cmd:code"
  "lazygit/config.yml|$HOME/Library/Application Support/lazygit/config.yml|cmd:lazygit"
  "neovim/neobean|$HOME/.config/neobean|cmd:nvim"
  "neovim/quarto-nvim-kickstarter|$HOME/.config/quarto-nvim-kickstarter|cmd:nvim"
  "neovim/kickstart.nvim|$HOME/.config/kickstart.nvim|cmd:nvim"
  "neovim/lazyvim|$HOME/.config/lazyvim|cmd:nvim"
  "neovide|$HOME/.config/neovide|cmd:neovide"
  "yazi|$HOME/.config/yazi|cmd:yazi"
  "btop|$HOME/.config/btop|cmd:btop"
  "fastfetch|$HOME/.config/fastfetch|cmd:fastfetch"
)

guard_ok() {
  local guard="$1"
  [[ -z "$guard" ]] && return 0
  case "$guard" in
    cmd:*)  command -v "${guard#cmd:}" >/dev/null 2>&1 ;;
    path:*) [[ -e "${guard#path:}" ]] ;;
    *)      echo "bad guard: $guard" >&2; return 1 ;;
  esac
}

# The repo marks files it owns with this line, so replacing one of its own
# earlier copies does not generate a pointless backup.
UNIQUE_ID="UNIQUE_ID=do_not_delete_this_line"

needs_backup() {
  local target="$1"
  if [[ -f "$target" ]] && grep -q "$UNIQUE_ID" "$target" 2>/dev/null; then
    return 1
  fi
  if [[ -d "$target" && -f "$target/UNIQUE_ID.sh" ]] \
     && grep -q "$UNIQUE_ID" "$target/UNIQUE_ID.sh" 2>/dev/null; then
    return 1
  fi
  return 0
}

TILDE="~"
tilde() { printf '%s' "${1/#$HOME/$TILDE}"; }

n_ok=0; n_create=0; n_repoint=0; n_backup=0; n_skip=0; n_err=0

$DRY_RUN && echo "${BOLD}dry run — nothing will be modified${OFF}" && echo

printf "${BOLD}%-52s %s${OFF}\n" "TARGET" "ACTION"
printf '%s\n' "$(printf '─%.0s' {1..76})"

for entry in "${ENTRIES[@]}"; do
  IFS='|' read -r rel target guard <<<"$entry"
  src="$DOTFILES/${rel%/}"          # strip any trailing slash so compares work
  label="$(tilde "$target")"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    printf "%-52s ${RED}%s${OFF}\n" "$label" "ERROR source missing: $rel"
    ((n_err++)); continue
  fi

  if ! guard_ok "$guard"; then
    printf "%-52s ${DIM}%s${OFF}\n" "$label" "skip (${guard} not satisfied)"
    ((n_skip++)); continue
  fi

  if [[ -L "$target" ]]; then
    # compare with trailing slashes stripped: an older link written as
    # ".../neovim/neobean/" is functionally identical to ".../neovim/neobean"
    current="$(readlink "$target")"
    if [[ "${current%/}" == "$src" ]]; then
      printf "%-52s ${GREEN}%s${OFF}\n" "$label" "ok"
      ((n_ok++)); continue
    fi
    printf "%-52s ${YELLOW}%s${OFF}\n" "$label" "repoint (was $current)"
    ((n_repoint++))
  elif [[ -e "$target" ]]; then
    if needs_backup "$target"; then
      printf "%-52s ${YELLOW}%s${OFF}\n" "$label" "backup + replace"
      ((n_backup++))
    else
      printf "%-52s ${YELLOW}%s${OFF}\n" "$label" "replace (repo-owned, no backup)"
      ((n_repoint++))
    fi
  else
    printf "%-52s ${BLUE}%s${OFF}\n" "$label" "create"
    ((n_create++))
  fi

  $DRY_RUN && continue

  mkdir -p "$(dirname "$target")"
  if [[ -e "$target" && ! -L "$target" ]] && needs_backup "$target"; then
    backup="${target}_backup_$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    printf "  ${DIM}backed up to %s${OFF}\n" "$(tilde "$backup")"
  fi
  ln -snf "$src" "$target"
done

echo
printf "${BOLD}%s${OFF}  ${GREEN}%d ok${OFF}, %d create, %d repoint/replace, %d backup, ${DIM}%d skip${OFF}, ${RED}%d error${OFF}\n" \
  "summary:" "$n_ok" "$n_create" "$n_repoint" "$n_backup" "$n_skip" "$n_err"
$DRY_RUN && echo && echo "${DIM}re-run without --dry-run to apply${OFF}"
exit 0
