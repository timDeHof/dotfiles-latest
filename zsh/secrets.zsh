# =============================================================================
# Secrets — scoped per-command, never exported into the login shell
# =============================================================================
# Exporting an API key from the shell puts it in the environment of EVERY child
# process, where it leaks into anything that dumps its environment. Real case:
# the VS Code Makefile Tools extension writes the full environment to
# workspaceStorage/.../targets.log, so both keys sat in cleartext in a log file
# that also got captured by VS Code's local file history.
#
# So keys live in ~/.config/secrets/<name> (mode 600) and are injected only
# into the single command that needs them.
#
# Note there is no STITCH_API_KEY wrapper: opencode reads its own
# ~/.config/opencode/.env, so exporting it from here was redundant.

# Read a secret by filename. Silent (and empty) if it isn't there, so a machine
# without the file degrades to "unauthenticated" rather than erroring at login.
_secret() {
  local f="$HOME/.config/secrets/$1"
  [[ -r "$f" ]] && printf '%s' "$(<"$f")"
}

# sync-to-daily.sh is the only vault script that reads GEMINI_API_KEY.
# Assignment-prefix form: the variable exists for this command only.
logsync() {
  GEMINI_API_KEY="$(_secret gemini_api_key)" \
    "$HOME/Dev/vaults/00-09-System/07-Scripts/sync-to-daily.sh" "$@"
}
