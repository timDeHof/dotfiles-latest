#!/usr/bin/env bash
# Run: bash tests/link-dotfiles.test.sh
#
# link-dotfiles.sh --dry-run must finish with exit 0 and print its summary line.
# With HOME pointing at an empty directory every entry is "create", which is the
# path that used to die: ((n_create++)) returns status 1 while the counter is 0,
# and `set -e` then aborts the script after the first row.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

out="$(HOME="$tmp" "$ROOT/bin/link-dotfiles.sh" --dry-run 2>&1)"
rc=$?

fail=0
if [[ $rc -ne 0 ]]; then echo "FAIL exit code is $rc, expected 0"; fail=1; fi
if ! grep -q '^summary:\|summary:' <<<"$out"; then echo "FAIL no summary line in output"; fail=1; fi
rows="$(grep -c ' create' <<<"$out")"
if [[ $rows -lt 2 ]]; then echo "FAIL only $rows 'create' rows printed, expected every entry to be processed"; fail=1; fi
if [[ -n "$(find "$tmp" -mindepth 1 -print -quit)" ]]; then echo "FAIL dry run created files under HOME"; fail=1; fi

[[ $fail -eq 0 ]] && echo "PASS link-dotfiles --dry-run (bash $BASH_VERSION, $rows create rows)"
exit $fail
