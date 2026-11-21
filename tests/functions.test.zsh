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

(( fails == 0 ))
