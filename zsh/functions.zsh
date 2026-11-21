# =============================================================================
# Functions
# =============================================================================

# =============================================================================
# Kitty dev session
# =============================================================================
# ide [path...]: open the kitty dev layout, one tab per directory
#   ide                 current directory
#   ide ~/Dev/app       one directory
#   ide ~/Dev/a ~/Dev/b one tab per directory
# Builds a session by repeating dev.session once per path with $PROJ and $PROJ_NAME filled in.
typeset -g _IDE_SESSION=${${(%):-%x}:A:h:h}/kitty/sessions/dev.kitty-session   # repo copy, found from this file's real path
ide() {
  local -a dirs=("${@:-$PWD}")
  local -a paths
  local d tpl out
  [[ -r $_IDE_SESSION ]] || { print -u2 "ide: session file not found: $_IDE_SESSION"; return 1; }
  for d in $dirs; do
    [[ -d $d ]] || { print -u2 "ide: not a directory: $d"; return 1; }
    d=${d:A}
    # validate the resolved path: a newline would inject extra directives into the session file
    [[ $d == *[[:cntrl:]]* ]] && { print -u2 "ide: path contains control characters"; return 1; }
    paths+=("$d")
  done
  tpl=$(<$_IDE_SESSION)
  out=$(mktemp -t ide-session) || return 1
  for d in $paths; do print -r -- "${${tpl//\$PROJ_NAME/${d:t}}//\$PROJ/$d}"; done > $out
  kitty --detach --session $out
  (sleep 10; rm -f $out) &!   # kitty reads the file after detaching, so delete it later
}
compdef _directories ide

# =============================================================================
# Small helpers
# =============================================================================

# mkcd <dir>: create a directory (and parents), then cd into it
mkcd() {
  [[ -n $1 ]] || { print -u2 "usage: mkcd <dir>"; return 1; }
  mkdir -p -- "$1" && cd -- "$1"
}

# killport <port>: kill the process listening on a TCP port
killport() {
  [[ $1 == <-> ]] || { print -u2 "usage: killport <port>"; return 1; }
  local pids; pids=$(lsof -ti :$1 -sTCP:LISTEN)
  [[ -n $pids ]] || { print -u2 "killport: nothing listening on port $1"; return 1; }
  kill ${=pids} && print "killport: stopped $pids on port $1"
}

# gcof [query]: pick a local git branch with fzf and check it out
gcof() {
  local b
  b=$(git branch --format='%(refname:short)' | fzf --prompt='branch> ' -q "$1") || return
  git checkout "$b"
}

# extract <archive...>: unpack archives into the current directory, by file extension
extract() {
  (( $# )) || { print -u2 "usage: extract <archive...>"; return 1; }
  local f rc=0
  for f in "$@"; do
    [[ -f $f ]] || { print -u2 "extract: not a file: $f"; rc=1; continue; }
    case ${f:l} in
      *.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz2|*.tar.xz|*.txz) tar -xf "$f" ;;
      *.zip) unzip -q "$f" ;;
      *.gz)  gunzip -c "$f" > "${f:t:r}" ;;
      *.bz2) bunzip2 -c "$f" > "${f:t:r}" ;;
      *.xz)  unxz -c "$f" > "${f:t:r}" ;;
      *.7z)  7z x "$f" ;;
      *) print -u2 "extract: unknown archive type: $f"; rc=1 ;;
    esac || rc=1
  done
  return $rc
}

# dsh [container]: open a shell in a running container (bash if present, else sh); pick with fzf if no name
dsh() {
  local c=$1
  if [[ -z $c ]]; then
    c=$(docker ps --format '{{.Names}}' | fzf --prompt='container> ') || return
  fi
  docker exec -it "$c" sh -c 'command -v bash >/dev/null && exec bash || exec sh'
}

# Completion: extract takes archive files (and directories to browse), dsh takes running container names
_extract() { _files -g '*.(tar|tgz|tbz2|txz|zip|gz|bz2|xz|7z)'; }
_dsh() {
  (( CURRENT == 2 )) || return 1
  local -a names; names=(${(f)"$(docker ps --format '{{.Names}}' 2>/dev/null)"})
  _describe -t containers 'running container' names
}
compdef _extract extract
compdef _dsh dsh

# Completion: killport takes listening TCP ports (with process name), gcof takes local branch names
_killport() {
  (( CURRENT == 2 )) || return 1
  local -a ports
  ports=(${(f)"$(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1 { p=$9; sub(/.*:/,"",p); c=$1; gsub(/\\x20/," ",c); if (!(p in seen)) { seen[p]=1; print p ":" c } }')"})
  _describe -t ports 'listening port' ports
}
_gcof() {
  (( CURRENT == 2 )) || return 1
  local -a branches; branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
  _wanted branches expl 'local branch' compadd -a branches
}
compdef _killport killport
compdef _gcof gcof
