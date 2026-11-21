#!/usr/bin/env zsh
# Run: zsh tests/functions.test.zsh
#
# killport must only stop TCP listeners, and extract must never destroy an
# existing file when decompression fails.

ROOT=${0:A:h:h}
compdef() { :; }   # only defined in an interactive shell with compinit
source "$ROOT/zsh/functions.zsh"

tmp=$(mktemp -d)
typeset -a helpers
cleanup() { (( $#helpers )) && kill $helpers 2>/dev/null; rm -rf "$tmp"; }
trap cleanup EXIT

fails=0
pass() { print "PASS $1"; }
fail() { print "FAIL $1"; (( ++fails )); }

# start_listener <tcp|udp>: bind 127.0.0.1 on a free port; sets LPORT and LPID
start_listener() {
  python3 -I -c '
import socket, sys, time
udp = sys.argv[1] == "udp"
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM if udp else socket.SOCK_STREAM)
s.bind(("127.0.0.1", 0))
if not udp: s.listen()
print(s.getsockname()[1], flush=True)
time.sleep(60)' $1 > $tmp/$1.port &
  LPID=$!; helpers+=($LPID)
  local i; for i in {1..50}; do [[ -s $tmp/$1.port ]] && break; sleep 0.1; done
  LPORT=$(<$tmp/$1.port)
}

alive() { kill -0 $1 2>/dev/null; }

# ---- killport -------------------------------------------------------------
start_listener udp
killport $LPORT >/dev/null 2>&1; rc=$?
if alive $LPID && (( rc != 0 )); then pass "killport leaves a UDP-only socket alone (rc=$rc)"
else fail "killport touched a UDP-only socket on port $LPORT (rc=$rc, alive=$(alive $LPID && echo yes || echo no))"; fi
kill $LPID 2>/dev/null

start_listener tcp
killport $LPORT >/dev/null 2>&1; rc=$?
for i in {1..30}; do alive $LPID || break; sleep 0.1; done
if ! alive $LPID && (( rc == 0 )); then pass "killport stops a TCP listener"
else fail "killport did not stop the TCP listener on port $LPORT (rc=$rc)"; fi

# ---- extract --------------------------------------------------------------
mkdir $tmp/x && cd $tmp/x
print precious > report
print "not gzip" > report.gz
extract report.gz >/dev/null 2>&1; rc=$?
if (( rc != 0 )) && [[ "$(<report)" == precious ]]; then pass "extract keeps an existing file when the .gz is corrupt"
else fail "extract changed ./report on a corrupt .gz (rc=$rc, content=[$(<report)])"; fi
left=$(print -l *(N) | grep -vxE 'report|report.gz' || true)
[[ -z $left ]] && pass "extract leaves no temp files behind" || fail "extract left files behind: $left"

print hello | gzip -c > good.gz
extract good.gz >/dev/null 2>&1
[[ "$(<good)" == hello ]] && pass "extract still unpacks a valid .gz" || fail "extract broke a valid .gz"

# ---- ide ------------------------------------------------------------------
# kitty splits session files on U+0085, U+2028 and U+2029 (checked against kitty
# 0.49.2) and expands $VAR in every line, with no working escape for a literal $.
# So ide must refuse such paths instead of pasting them into the session.
# stub for: kitty --detach --session -   (the session arrives on stdin; anything else is an error)
kitty() { [[ $1 == --detach && $2 == --session && $3 == - ]] || return 64; cat > $tmp/session.out; }

# ide_refuses <label> <dir name> [locale]: ide must exit non-zero and write no session
ide_refuses() {
  local d=$tmp/ide/$2 rc
  mkdir -p -- $d || { fail "$1: could not create the test directory"; return; }
  : > $tmp/session.out
  LC_ALL=${3:-$LANG} ide $d >/dev/null 2>&1; rc=$?
  if (( rc != 0 )) && [[ ! -s $tmp/session.out ]]; then pass "ide refuses $1"
  else fail "ide accepted $1 (rc=$rc, session written: $([[ -s $tmp/session.out ]] && echo yes || echo no))"; fi
}
ide_refuses "U+2028 in a name"                    $'p\xe2\x80\xa8launch x'
ide_refuses "U+2028 in a name (LC_ALL=C)"         $'q\xe2\x80\xa8launch x' C
ide_refuses "U+2029 in a name"                    $'p\xe2\x80\xa9launch x'
ide_refuses "U+2029 in a name (LC_ALL=C)"         $'q\xe2\x80\xa9launch x' C
ide_refuses "U+0085 in a name"                    $'p\xc2\x85launch x'
ide_refuses "U+0085 in a name (LC_ALL=C)"         $'q\xc2\x85launch x' C
ide_refuses 'a $ in a name'                       'cost$HOME'

# ordinary names, including a space and non-ASCII, still work and appear verbatim
mkdir -p -- "$tmp/ide/my proj" "$tmp/ide/café"
for n in "my proj" "café"; do
  : > $tmp/session.out
  ide "$tmp/ide/$n" >/dev/null 2>&1; rc=$?
  if (( rc == 0 )) && grep -qxF "new_tab $n" $tmp/session.out && grep -qxF "cd ${tmp:A}/ide/$n" $tmp/session.out
  then pass "ide opens '$n' with the right title and cwd"
  else fail "ide mishandled '$n' (rc=$rc)"; fi
done

# The session goes to kitty on stdin, so there is no temp file to clean up on a timer
# (a timer deletes the file too early if kitty is slow to start) and kitty's exit
# status is not hidden behind a background job.
mkdir -p -- "$tmp/ide/plain"
count_sessions() { print -l ${TMPDIR:-/tmp}/ide-session*(N) | grep -c . ; }
before=$(count_sessions)
ide "$tmp/ide/plain" >/dev/null 2>&1
after=$(count_sessions)
(( after == before )) && pass "ide leaves no temp session file" || fail "ide left $(( after - before )) temp session file(s) in ${TMPDIR:-/tmp}"

kitty() { cat >/dev/null; return 3; }   # stub: kitty exits 3
ide "$tmp/ide/plain" >/dev/null 2>&1; rc=$?
(( rc == 3 )) && pass "ide returns kitty's exit status" || fail "ide returned $rc when kitty exited 3"

(( fails == 0 ))
