#!/usr/bin/env zsh
# Run: zsh tests/plugins.test.zsh
#
# Plugins must be installed at a pinned commit, not at the default branch head, and an
# existing install at another commit must be moved to the pin.

ROOT=${0:A:h:h}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fails=0
pass() { print "PASS $1"; }
fail() { print "FAIL $1"; (( ++fails )); }

# every plugin in plugins.zsh carries a full 40-character commit
bad=$(grep -E '^_zplugin_load ' $ROOT/zsh/plugins.zsh | grep -vE ' [0-9a-f]{40}$')
[[ -z $bad ]] && pass "every _zplugin_load line in plugins.zsh has a 40-char commit pin" || fail "unpinned plugin line(s): $bad"

# fake GitHub: $tmp/host/acme/demo with two commits
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
R=$tmp/host/acme/demo
git init -q $R
print 'print v1' > $R/demo.plugin.zsh; git -C $R add . && git -C $R commit -q -m one; C1=$(git -C $R rev-parse HEAD)
print 'print v2' > $R/demo.plugin.zsh; git -C $R commit -q -am two;                    C2=$(git -C $R rev-parse HEAD)

# load the functions only (the real plugin list is skipped), pointed at the fake host
export ZPLUGIN_DEFINE_ONLY=1 ZPLUGIN_HOST=file://$tmp/host ZPLUGINDIR=$tmp/plugins
source $ROOT/zsh/plugins.zsh

out=$(_zplugin_load acme demo $C1 2>&1)
[[ $(git -C $ZPLUGINDIR/demo rev-parse HEAD) == $C1 ]] && pass "fresh install lands on the pinned commit, not the branch head" \
  || fail "fresh install is at $(git -C $ZPLUGINDIR/demo rev-parse --short HEAD), pinned $C1[1,7]"
[[ $out == *v1 ]] && pass "the pinned version of the plugin was sourced" || fail "sourced output: [$out]"

git -C $ZPLUGINDIR/demo fetch -q origin && git -C $ZPLUGINDIR/demo checkout -q $C2
out=$(_zplugin_load acme demo $C1 2>&1)
[[ $(git -C $ZPLUGINDIR/demo rev-parse HEAD) == $C1 ]] && pass "an install at another commit is moved to the pin" \
  || fail "existing install stayed at $(git -C $ZPLUGINDIR/demo rev-parse --short HEAD), pinned $C1[1,7]"

out=$(_zplugin_load acme demo 0123456789012345678901234567890123456789 2>&1); rc=$?
(( rc != 0 )) && pass "a pin that does not exist fails loudly (rc=$rc)" || fail "a missing pin returned 0: [$out]"

exit $(( fails > 0 ))
