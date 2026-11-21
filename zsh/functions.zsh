# =============================================================================
# Functions
# =============================================================================

# =============================================================================
# Kitty dev session
# =============================================================================
# _ide_bad_path <path>: true if the path cannot be written into a kitty session file safely.
# kitty splits session lines on U+0085, U+2028 and U+2029 as well as on newlines, and expands
# $VAR in every line with no working escape for a literal $ (checked on kitty 0.49.2).
# LC_ALL=C makes the match byte-wise, so it does not depend on the user's locale.
_ide_bad_path() {
  local LC_ALL=C
  [[ $1 == *[[:cntrl:]\$]* || $1 == *$'\xe2\x80\xa8'* || $1 == *$'\xe2\x80\xa9'* || $1 == *$'\xc2\x85'* ]]
}
typeset -g _IDE_SESSION=${${(%):-%x}:A:h:h}/kitty/ide-session.tmpl   # repo copy, found from this file's real path
# ide [path...]: open the kitty dev layout, one tab per directory
#   ide                 current directory
#   ide ~/Dev/app       one directory
#   ide ~/Dev/a ~/Dev/b one tab per directory
# Builds a session by repeating dev.session once per path with $PROJ and $PROJ_NAME filled in,
# and pipes it to kitty on stdin, so there is no temp file and kitty's exit status is returned.
ide() {
  local -a dirs=("${@:-$PWD}")
  local -a paths
  local d tpl
  [[ -r $_IDE_SESSION ]] || { print -u2 "ide: session file not found: $_IDE_SESSION"; return 1; }
  for d in "${dirs[@]}"; do   # quoted: an unquoted $dirs drops empty arguments, skipping this check
    [[ -d $d ]] || { print -u2 "ide: not a directory: $d"; return 1; }
    d=${d:A}
    # validate the resolved path: it is pasted into a session file, so it must not inject directives
    _ide_bad_path $d && { print -u2 "ide: unsupported character in path (control character, U+0085, U+2028, U+2029 or \$)"; return 1; }
    paths+=("$d")
  done
  tpl=$(<$_IDE_SESSION)
  for d in $paths; do print -r -- "${${tpl//\$PROJ_NAME/${d:t}}//\$PROJ/$d}"; done | kitty --detach --session -
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
  # -iTCP: without the protocol, a UDP socket on the same port would match too
  local pids; pids=$(lsof -tiTCP:"$1" -sTCP:LISTEN)
  [[ -n $pids ]] || { print -u2 "killport: nothing listening on port $1"; return 1; }
  kill ${=pids} && print "killport: stopped $pids on port $1"
}

# _gcof_branches: local branch names. `git branch --format` would also print a pseudo-entry such
# as "(HEAD detached at abc)" on a detached HEAD, which cannot be checked out.
_gcof_branches() { git for-each-ref --format='%(refname:short)' refs/heads; }

# gcof [query]: pick a local git branch with fzf and check it out
gcof() {
  local b
  b=$(_gcof_branches | fzf --prompt='branch> ' -q "$1") || return
  git checkout "$b"
}

# _extract_stream <dest> <cmd...>: run cmd into a temp file and replace dest only if cmd succeeds,
# so a corrupt archive cannot empty an existing file
_extract_stream() {
  local dest=$1 tmp="$1.extract-$$"; shift
  [[ -d $dest ]] && { print -u2 "extract: $dest is a directory"; return 1; }   # mv would drop the temp file inside it
  if "$@" > "$tmp"; then mv -- "$tmp" "$dest"; else rm -f -- "$tmp"; return 1; fi
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
      *.gz)  _extract_stream "${f:t:r}" gunzip -c "$f" ;;
      *.bz2) _extract_stream "${f:t:r}" bunzip2 -c "$f" ;;
      *.xz)  _extract_stream "${f:t:r}" unxz -c "$f" ;;
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
  local -a branches; branches=(${(f)"$(_gcof_branches 2>/dev/null)"})
  _wanted branches expl 'local branch' compadd -a branches
}
compdef _killport killport
compdef _gcof gcof
