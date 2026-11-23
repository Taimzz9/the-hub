#!/usr/bin/env bash
# check-docs.sh - taimzz9-living-docs-spine v2.0 - MIT, by Taimzz9 (Taim Al-Bakri)
#
# Read only. Same checks as check-docs.ps1, for bash (Linux, macOS, Git Bash):
#   1. every relative link and reference definition resolves to a file or folder
#   2. every #anchor to a .md file matches a heading (GitHub style slug) or an <a id>
#   3. every table row has the same number of cells as its header row
# Links in code fences and inline code are ignored; scheme links (http, mailto) are not checked.
# Needs: bash, find, awk (gawk or POSIX awk). No network.
#
# Usage: bash check-docs.sh [root] [--skip .git,node_modules] [--strict-anchors]
# Exit:  0 = 0 broken links and 0 malformed tables; 1 = something to fix; 2 = bad arguments.
# Anchor slugs: exact for ASCII headings; for non ASCII headings it depends on the awk locale.

set -u
root="."
skip=".git,node_modules"
strict=0
while [ $# -gt 0 ]; do
  case "$1" in
    --skip) skip="${2:-}"; shift 2 ;;
    --strict-anchors) strict=1; shift ;;
    -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
    *) root="$1"; shift ;;
  esac
done
if [ ! -d "$root" ]; then echo "check-docs: folder not found: $root (pass the folder as the first argument)"; exit 2; fi
root="$(cd "$root" && pwd)"

list="$(mktemp)"; trap 'rm -f "$list"' EXIT
prune=""
IFS=',' read -r -a parts <<< "$skip"
for p in "${parts[@]}"; do [ -n "$p" ] && prune="$prune -name $p -o"; done
prune="${prune% -o}"
if [ -n "$prune" ]; then
  # shellcheck disable=SC2086
  find "$root" \( $prune \) -prune -o -type f -name '*.md' -print | LC_ALL=C sort > "$list"
else
  find "$root" -type f -name '*.md' -print | LC_ALL=C sort > "$list"
fi

awk -v root="$root" -v listfile="$list" -v strict="$strict" '
function rel(p) { return (index(p, root "/") == 1) ? substr(p, length(root) + 2) : p }
function dirname(p,   i) { i = match(p, /\/[^\/]*$/); return i ? substr(p, 1, i - 1) : "." }
function norm(p,   n, a, i, k, st, out, lead) {
  lead = (substr(p, 1, 1) == "/") ? "/" : ""
  n = split(p, a, "/"); k = 0
  for (i = 1; i <= n; i++) {
    if (a[i] == "" || a[i] == ".") continue
    if (a[i] == "..") { if (k > 0 && st[k] != "..") k--; else st[++k] = ".."; continue }
    st[++k] = a[i]
  }
  out = ""
  for (i = 1; i <= k; i++) out = out (i > 1 ? "/" : "") st[i]
  return lead out
}
function exists(p,   q) {
  if (p in ex) return ex[p]
  q = p; gsub(/\047/, "\047\\\047\047", q)
  ex[p] = (system("test -e \047" q "\047") == 0)
  return ex[p]
}
function slug(t) {
  gsub(/`/, "", t); sub(/^[ \t]+/, "", t); sub(/[ \t]+$/, "", t)
  t = tolower(t); gsub(/[^[:alnum:] _-]/, "", t); gsub(/ /, "-", t)
  return t
}
function cells(s) {
  gsub(/`[^`]*`/, "", s); gsub(/\\\|/, "", s)
  sub(/^[ \t]*\|/, "", s); sub(/\|[ \t]*$/, "", s)
  return gsub(/\|/, "|", s) + 1
}
# Code fences, CommonMark style: open with 3+ backticks or tildes, close only with the
# same character, at least as many, nothing after. Returns the open marker or "".
function stepfence(line, open,   m, re) {
  if (open == "") {
    if (match(line, /^ ? ? ?(````*|~~~~*)/)) { m = substr(line, RSTART, RLENGTH); sub(/^ */, "", m); return m }
    return ""
  }
  re = (substr(open, 1, 1) == "`") ? "^`+$" : "^~+$"
  m = line; sub(/^ ? ? ?/, "", m); sub(/[ \t]+$/, "", m)
  if (length(m) >= length(open) && m ~ re) return ""
  return open
}
# Headings and <a id> anchors of a file outside the scanned set (a link that leaves the root).
function loadanchors(f,   line, fence, was, h, b, s, k, tmp, a) {
  if (f in scanned) return
  scanned[f] = 1; fence = ""
  while ((getline line < f) > 0) {
    sub(/\r$/, "", line)
    was = fence; fence = stepfence(line, fence)
    if (was != "" || fence != "") continue
    if (match(line, /^ ? ? ?#+[ \t]+/)) {
      h = substr(line, RLENGTH + 1); sub(/[ \t]+#*[ \t]*$/, "", h)
      b = slug(h); s = b; k = 0
      while ((f SUBSEP s) in anc) { k++; s = b "-" k }
      anc[f, s] = 1
    }
    tmp = line
    while (match(tmp, /<a[ \t]+(id|name)="[^"]+"/)) {
      a = substr(tmp, RSTART, RLENGTH); sub(/^[^"]*"/, "", a); sub(/"$/, "", a)
      anc[f, a] = 1; tmp = substr(tmp, RSTART + RLENGTH)
    }
  }
  close(f)
}
function addlink(f, n, t) { nl++; lf[nl] = f; ln[nl] = n; lt[nl] = t }
BEGIN {
  nf = 0
  while ((getline f < listfile) > 0) { files[++nf] = f; scanned[f] = 1 }
  close(listfile)
  for (fi = 1; fi <= nf; fi++) {
    f = files[fi]; fence = ""; block = 0; lineno = 0
    while ((getline line < f) > 0) {
      lineno++; sub(/\r$/, "", line)
      was = fence; fence = stepfence(line, fence)
      if (was != "" || fence != "") { block = 0; continue }
      # headings and explicit anchors
      if (match(line, /^ ? ? ?#+[ \t]+/)) {
        h = substr(line, RLENGTH + 1); sub(/[ \t]+#*[ \t]*$/, "", h)
        b = slug(h); s = b; k = 0
        while ((f SUBSEP s) in anc) { k++; s = b "-" k }
        anc[f, s] = 1
      }
      tmp = line
      while (match(tmp, /<a[ \t]+(id|name)="[^"]+"/)) {
        a = substr(tmp, RSTART, RLENGTH); sub(/^[^"]*"/, "", a); sub(/"$/, "", a)
        anc[f, a] = 1; tmp = substr(tmp, RSTART + RLENGTH)
      }
      # tables
      if (line ~ /^[ \t]*\|/) {
        block++
        if (block == 1) { hc = cells(line); istable = 0 }
        else if (block == 2) { istable = (line ~ /^[ \t]*\|?[ \t]*:?-+:?[ \t]*(\|[ \t]*:?-+:?[ \t]*)*\|?[ \t]*$/) }
        else if (istable) { c = cells(line); if (c != hc) tab[++nt] = "TABLE    " rel(f) ":" lineno "  row has " c " cells, header has " hc }
      } else block = 0
      # links
      plain = line; gsub(/`[^`]*`/, "", plain)
      tmp = plain
      while (match(tmp, /\]\([ \t]*<?[^) \t>]+/)) {
        t = substr(tmp, RSTART + 2, RLENGTH - 2); sub(/^[ \t]*<?/, "", t)
        addlink(f, lineno, t); tmp = substr(tmp, RSTART + RLENGTH)
      }
      if (match(plain, /^ ? ? ?\[[^\]]+\]:[ \t]*<?[^ \t>]+/)) {
        t = substr(plain, RSTART, RLENGTH); sub(/^[^\]]*\]:[ \t]*<?/, "", t)
        addlink(f, lineno, t)
      }
    }
    close(f)
  }
  links = 0; nb = 0; na = 0
  for (i = 1; i <= nl; i++) {
    t = lt[i]
    if (t ~ /^[A-Za-z][A-Za-z0-9+.-]*:/ || t ~ /^\/\//) continue
    links++
    p = t; a = ""
    h = index(p, "#"); if (h) { a = substr(p, h + 1); p = substr(p, 1, h - 1) }
    q = index(p, "?"); if (q) p = substr(p, 1, q - 1)
    gsub(/%20/, " ", p)
    here = rel(lf[i]) ":" ln[i]
    if (p == "") full = lf[i]
    else if (substr(p, 1, 1) == "/") full = norm(root p)
    else full = norm(dirname(lf[i]) "/" p)
    if (!exists(full)) { br[++nb] = "BROKEN   " here "  " t; continue }
    if (a != "" && full ~ /\.[mM][dD]$/) {
      loadanchors(full)
      if (!((full SUBSEP a) in anc) && !((full SUBSEP tolower(a)) in anc)) am[++na] = "ANCHOR   " here "  " t
    }
  }
  printf "check-docs  root: %s\n", root
  printf "files: %d  relative links: %d  broken: %d  anchors not found: %d  malformed table rows: %d\n", nf, links, nb, na, nt
  for (i = 1; i <= nb; i++) print br[i]
  for (i = 1; i <= nt; i++) print tab[i]
  for (i = 1; i <= na; i++) print am[i]
  if (nb > 0 || nt > 0 || (strict && na > 0)) { print "result: FIX NEEDED"; exit 1 }
  print "result: OK"; exit 0
}'
