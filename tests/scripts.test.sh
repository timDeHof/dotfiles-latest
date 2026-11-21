#!/usr/bin/env bash
# Run: bash tests/scripts.test.sh
#
# A script that is kept must not run a file that does not exist. 400-autoPushGithub.sh is
# not scheduled anywhere and its last step used to call a missing notification script.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
s="$ROOT/scripts/macos/mac/400-autoPushGithub.sh"
fail=0

if [[ ! -e $s ]]; then
  echo "PASS 400-autoPushGithub.sh is removed (nothing to call a missing file)"; exit 0
fi
# every ~/github/.../*.sh path the script runs must exist
while read -r p; do
  f="${p/#\~/$HOME}"; f="${f/\$HOME/$HOME}"
  [[ -e $f ]] || { echo "FAIL 400-autoPushGithub.sh runs a missing file: $p"; fail=1; }
done < <(grep -v '^\s*#' "$s" | grep -oE '(~|\$HOME)/github/[^ "]+\.sh' | sort -u)
[[ $fail -eq 0 ]] && echo "PASS every script 400-autoPushGithub.sh runs exists"
exit $fail
