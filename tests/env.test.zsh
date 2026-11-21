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

# the default alias is a version prefix: "2" means v2.x, not v20 or v24
for v in v2.5.0 v20.1.0; do mkdir -p $N/versions/node/$v/bin; print '#!/bin/sh' > $N/versions/node/$v/bin/node; chmod +x $N/versions/node/$v/bin/node; done
print 2 > $N/alias/default
got=$(run 'whence -p node')
[[ $got == $N/versions/node/v2.5.0/bin/node ]] && pass "alias 2 picks v2.x, not v20 or v24" || fail "alias 2 resolved to [$got], expected v2.5.0"
print 20 > $N/alias/default
got=$(run 'whence -p node')
[[ $got == $N/versions/node/v20.1.0/bin/node ]] && pass "alias 20 picks v20.x" || fail "alias 20 resolved to [$got], expected v20.1.0"
print 24.10.0 > $N/alias/default
got=$(run 'whence -p node')
[[ $got == $N/versions/node/v24.10.0/bin/node ]] && pass "a full version alias (24.10.0) picks that version" || fail "alias 24.10.0 resolved to [$got]"

rm $N/alias/default
got=$(run 'echo ok')
[[ $got == ok ]] && pass "no default alias: env.zsh still loads cleanly" || fail "no default alias: output [$got]"

# JAVA_HOME and the java found on PATH must be the same JDK: JAVA_HOME/bin has to come before
# Homebrew's openjdk on PATH (build tools follow JAVA_HOME, everything else follows PATH).
got=$(HOME=$H zsh -c "source $ROOT/zsh/env.zsh; print -l \$path" 2>/dev/null)
jh=$(HOME=$H zsh -c "source $ROOT/zsh/env.zsh; print -r -- \$JAVA_HOME" 2>/dev/null)
paths=(${(f)got})
ji=${paths[(i)$jh/bin]} oi=${paths[(i)*/opt/openjdk/bin]}
if (( ji > $#paths )); then fail "JAVA_HOME/bin ($jh/bin) is not on PATH"
elif (( ji < oi )); then pass "JAVA_HOME/bin comes before Homebrew openjdk on PATH"
else fail "JAVA_HOME/bin is at PATH position $ji, after openjdk at $oi"; fi

# a missing agentbox install must not print an error in every shell
err=$(HOME=$H zsh -c "source $ROOT/zsh/env.zsh" 2>&1 >/dev/null)
[[ $err != *agentbox* ]] && pass "no agentbox install: no source error at startup" || fail "startup error: [$err]"

# .zshenv runs for every zsh, scripts included: it must not fork tty or export GPG_TTY. .zshrc sets it.
got=$(env -u GPG_TTY HOME=$H ZDOTDIR=$ROOT/zsh zsh -c 'print -r -- ${GPG_TTY-unset}' </dev/null 2>/dev/null)
[[ $got == unset ]] && pass ".zshenv does not set GPG_TTY for non-interactive shells" || fail "non-interactive shell got GPG_TTY=[$got]"
grep -q 'GPG_TTY' $ROOT/zsh/.zshrc && pass ".zshrc sets GPG_TTY" || fail "GPG_TTY is not set in .zshrc"

exit $(( fails > 0 ))
