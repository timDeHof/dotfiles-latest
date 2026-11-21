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
  : > $tmp/$1.port
  python3 -I -c '
import socket, sys, time
udp = sys.argv[1] == "udp"
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM if udp else socket.SOCK_STREAM)
s.bind(("127.0.0.1", 0))
if not udp: s.listen()
print(s.getsockname()[1], flush=True)
time.sleep(60)' $1 > $tmp/$1.port &
  LPID=$!; helpers+=($LPID)   # (port file is emptied above so a retry waits for the new port)
  local i; for i in {1..50}; do [[ -s $tmp/$1.port ]] && break; sleep 0.1; done
  LPORT=$(<$tmp/$1.port)
}

alive() { kill -0 $1 2>/dev/null; }

# tcp_port_busy <port>: true if a process listens on that TCP port
tcp_port_busy() { [[ -n "$(lsof -tiTCP:$1 -sTCP:LISTEN 2>/dev/null)" ]]; }

# start_udp_listener: like start_listener udp, but never on a port a TCP service already holds,
# because killport would stop that service
start_udp_listener() {
  local i
  for i in {1..20}; do
    start_listener udp
    tcp_port_busy $LPORT || return 0
    kill $LPID 2>/dev/null
  done
  print "could not find a UDP port without a TCP listener" >&2; return 1
}

# ---- test harness guard ---------------------------------------------------
# TCP and UDP ports are separate. If the UDP fixture happens to get a port number that
# a real TCP service already uses, killport would stop that service. tcp_port_busy
# lets the fixture detect this and pick another port.
python3 -I -c '
import socket, time
t = socket.socket(); t.bind(("127.0.0.1", 0)); t.listen()
p = t.getsockname()[1]
u = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); u.bind(("127.0.0.1", p))
print(p, flush=True); time.sleep(30)' > $tmp/both.port &
helpers+=($!)
for i in {1..50}; do [[ -s $tmp/both.port ]] && break; sleep 0.1; done
BOTH=$(<$tmp/both.port)
tcp_port_busy $BOTH 2>/dev/null && pass "tcp_port_busy sees a TCP listener on a shared port" \
  || fail "tcp_port_busy did not report the TCP listener on port $BOTH"
FREE=$(python3 -I -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')
tcp_port_busy $FREE 2>/dev/null; rc=$?
(( rc == 1 )) && pass "tcp_port_busy returns 1 for a free port" || fail "tcp_port_busy returned $rc for the free port $FREE"

# ---- killport -------------------------------------------------------------
start_udp_listener || { fail "no safe UDP port for the killport test"; exit 1; }
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

# The temp file is named <dest>.extract-<pid>, which someone else can predict. If that
# name is already a symlink, writing to it must fail instead of following the link.
mkdir -p $tmp/sym && cd $tmp/sym
print precious > report; print "not gzip" > report.gz
ln -s report "report.extract-$$"
extract report.gz >/dev/null 2>&1
if [[ "$(<report)" == precious ]]; then pass "extract does not write through a symlinked temp name"
else fail "extract emptied ./report through a symlinked temp name (content=[$(<report)])"; fi
rm -f -- "report.extract-$$"
ln -s nowhere "report.extract-$$"
extract report.gz >/dev/null 2>&1
if [[ ! -e nowhere ]]; then pass "extract does not create files through a dangling temp symlink"
else fail "extract created ./nowhere through a dangling temp symlink"; fi
cd $ROOT

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

# kitty strips trailing whitespace, ASCII and Unicode, from each session line (checked on
# kitty 0.49.2), so "cd /x/tw<space>" opens /x/tw. A name that ends in whitespace must be refused.
ide_refuses "a trailing space"                    'tw '
ide_refuses "a trailing space (LC_ALL=C)"         'tx ' C
ide_refuses "a trailing U+00A0"                   $'tw\xc2\xa0'
ide_refuses "a trailing U+1680"                   $'tw\xe1\x9a\x80'
ide_refuses "a trailing U+2000"                   $'tw\xe2\x80\x80'
ide_refuses "a trailing U+200A"                   $'tw\xe2\x80\x8a'
ide_refuses "a trailing U+202F"                   $'tw\xe2\x80\xaf'
ide_refuses "a trailing U+205F"                   $'tw\xe2\x81\x9f'
ide_refuses "a trailing U+3000"                   $'tw\xe3\x80\x80'
ide_refuses "a trailing U+3000 (LC_ALL=C)"        $'tx\xe3\x80\x80' C

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

# The template needs PROJ and PROJ_NAME, so it must not sit in kitty/sessions, which
# kitty's goto_session picker (kitty/kitty.conf) lists and would load without them.
if [[ -r $_IDE_SESSION && ! -e $ROOT/kitty/sessions/dev.kitty-session && ${_IDE_SESSION:h} != $ROOT/kitty/sessions ]]
then pass "the ide template is outside the session picker folder"
else fail "the ide template is still in kitty/sessions (_IDE_SESSION=${_IDE_SESSION#$ROOT/})"; fi

# An empty argument must be an error. In zsh an unquoted $array drops empty
# elements, so the check used to be skipped and kitty started with no session.
kitty() { cat > $tmp/session.out; }
: > $tmp/session.out
ide "" >/dev/null 2>&1; rc=$?
if (( rc != 0 )) && [[ ! -s $tmp/session.out ]]; then pass "ide refuses an empty argument"
else fail "ide accepted an empty argument (rc=$rc, session bytes: $(wc -c < $tmp/session.out | tr -d ' '))"; fi
: > $tmp/session.out
ide "$tmp/ide/plain" "" >/dev/null 2>&1; rc=$?
if (( rc != 0 )) && [[ ! -s $tmp/session.out ]]; then pass "ide refuses an empty argument after a valid one"
else fail "ide accepted an empty second argument (rc=$rc)"; fi

# extract must not drop its temp file inside a directory that has the output's name
mkdir -p $tmp/z/data && cd $tmp/z
print hello | gzip -c > data.gz
extract data.gz >/dev/null 2>&1; rc=$?
if (( rc != 0 )) && [[ -z "$(print -l data/*(N))" ]]; then pass "extract refuses to write over a directory"
else fail "extract with a directory named data: rc=$rc, found inside data/: $(print -l data/*(N) | tr '\n' ' ')"; fi

# gcof must list real branches only. On a detached HEAD, git prints a pseudo-entry
# like "(HEAD detached at abc)" that cannot be checked out.
git init -q -b main $tmp/repo && cd $tmp/repo
git -c user.name=t -c user.email=t@t commit -q --allow-empty -m a
git branch feature
git -c user.name=t -c user.email=t@t commit -q --allow-empty -m b
git checkout -q --detach HEAD~1
fzf() { cat > $tmp/fzf.in; return 1; }   # stub: capture the list gcof offers
gcof >/dev/null 2>&1
if [[ "$(sort $tmp/fzf.in | tr '\n' ' ')" == "feature main " ]]; then pass "gcof lists only real branches on a detached HEAD"
else fail "gcof offered: $(tr '\n' '|' < $tmp/fzf.in)"; fi
unfunction fzf
cd $ROOT

(( fails == 0 ))
