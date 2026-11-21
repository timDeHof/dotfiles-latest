#!/usr/bin/env zsh
# Run: zsh tests/env.test.zsh
#
# env.zsh must not source nvm.sh at shell startup (about 0.2 s). node must still be on PATH
# (the default alias), and the first `nvm` call must load the real nvm.

ROOT=${0:A:h:h}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fails=0
pass() { print "PASS $1"; }
fail() { print "FAIL $1"; (( ++fails )); }

# fake nvm install: sourcing nvm.sh leaves a marker and defines a recognizable nvm
H=$tmp/home N=$H/.nvm
mkdir -p $N/alias
print 24 > $N/alias/default
for v in v22.0.0 v24.9.0 v24.10.0; do mkdir -p $N/versions/node/$v/bin; print '#!/bin/sh' > $N/versions/node/$v/bin/node; chmod +x $N/versions/node/$v/bin/node; done
print 'touch "$HOME/nvm.sh.loaded"; nvm() { echo real-nvm "$@"; }' > $N/nvm.sh
print 'touch "$HOME/completion.loaded"' > $N/bash_completion

# run <script>: source env.zsh in a fresh shell with the fake HOME, then run the script
run() { HOME=$H zsh -c "source $ROOT/zsh/env.zsh; $1" 2>/dev/null; }   # stderr: env.zsh sources unrelated files missing under the fake HOME

run 'true'
[[ ! -e $H/nvm.sh.loaded ]] && pass "sourcing env.zsh does not load nvm.sh" || fail "env.zsh sourced nvm.sh at startup"
[[ ! -e $H/completion.loaded ]] && pass "sourcing env.zsh does not load nvm bash_completion" || fail "env.zsh sourced bash_completion at startup"

got=$(run 'whence -p node')
[[ $got == $N/versions/node/v24.10.0/bin/node ]] && pass "node on PATH is the newest version matching the default alias" \
  || fail "node resolves to [$got], expected v24.10.0 (alias default=24)"

got=$(run 'nvm ls')
[[ $got == "real-nvm ls" ]] && pass "first nvm call loads nvm and runs the real command" || fail "nvm ls printed [$got]"
rm -f $H/nvm.sh.loaded $H/completion.loaded
run 'nvm ls' >/dev/null
[[ -e $H/nvm.sh.loaded && -e $H/completion.loaded ]] && pass "first nvm call loads nvm.sh and bash_completion" || fail "nvm.sh or bash_completion not loaded on first call"

rm $N/alias/default
got=$(run 'echo ok')
[[ $got == ok ]] && pass "no default alias: env.zsh still loads cleanly" || fail "no default alias: output [$got]"

exit $(( fails > 0 ))
