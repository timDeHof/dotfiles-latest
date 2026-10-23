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
