#!/usr/bin/env bash
# spine-status.sh - taimzz9-living-docs-spine v2.0 - MIT, by Taimzz9 (Taim Al-Bakri)
#
# Read only. Same output as spine-status.ps1, for bash (Linux, macOS, Git Bash):
#   1. per tracked file: table rows counted by the FIRST status mark in the row;
#      percent = (done + 20% of each in progress or delegated item) / items, rounded
#      half up: the 20/80 earned value rule (--weight 50 gives the 50/50 rule of v1)
#   2. each file's "**Status YYYY-MM-DD HH:MM:**" line counts compared with the marks
#   3. each "## Status board" row (Done and Count columns) compared with the first
#      .md file it links to
# Default tracked files: PLAN.md, projects/*/PROJECT.md (not _folders), docs/runbooks/R<digit>*.md.
# Needs: bash, awk (gawk or POSIX awk). No network.
#
# Usage: bash spine-status.sh [root] [--board HOME.md] [--path extra.md ...] [--weight 20]
# Exit:  0 = every claim agrees; 1 = at least one claim differs; 2 = bad arguments.

set -u
root="."
board="HOME.md"
extra=()
weight=20
while [ $# -gt 0 ]; do
  case "$1" in
    --board) board="${2:-}"; shift 2 ;;
    --path) extra+=("${2:-}"); shift 2 ;;
    --weight) weight="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,16p' "$0"; exit 0 ;;
    *) root="$1"; shift ;;
  esac
done
if [ ! -d "$root" ]; then echo "spine-status: folder not found: $root (pass the folder as the first argument)"; exit 2; fi
case "$weight" in ''|*[!0-9]*) echo "spine-status: --weight must be a whole number from 0 to 100, got: $weight"; exit 2 ;; esac
if [ "$weight" -gt 100 ]; then echo "spine-status: --weight must be a whole number from 0 to 100, got: $weight"; exit 2; fi
root="$(cd "$root" && pwd)"

list="$(mktemp)"; trap 'rm -f "$list"' EXIT
[ -f "$root/PLAN.md" ] && echo "$root/PLAN.md" >> "$list"
if [ -d "$root/projects" ]; then
  for d in "$root"/projects/*/; do
    n="$(basename "$d")"
    case "$n" in _*) continue ;; esac
    [ -f "$d/PROJECT.md" ] && echo "${d%/}/PROJECT.md" >> "$list"
  done
fi
if [ -d "$root/docs/runbooks" ]; then
  for f in "$root"/docs/runbooks/R[0-9]*.md; do [ -f "$f" ] && echo "$f" >> "$list"; done
fi
for p in ${extra[@]+"${extra[@]}"}; do
  if [ ! -f "$root/$p" ]; then echo "spine-status: file not found: $p"; exit 2; fi
  echo "$root/$p" >> "$list"
done

awk -v root="$root" -v listfile="$list" -v board="$board" -v w="$weight" '
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
  out = ""; for (i = 1; i <= k; i++) out = out (i > 1 ? "/" : "") st[i]
  return lead out
}
function isfile(p,   l, r) { r = (getline l < p); if (r >= 0) close(p); return r >= 0 }
function num(text, re,   s) {
  if (!match(text, re)) return ""
  s = substr(text, RSTART, RLENGTH); match(s, /[0-9]+/); return substr(s, RSTART, RLENGTH) + 0
}
function claim(text, f,   d, pr, of, ok) {
  d = num(text, "[0-9]+[ \t]+done"); of = num(text, "(^|[^A-Za-z])of[ \t]+[0-9]+")
  pr = num(text, "[0-9]+[ \t]+(delegated or in progress|in progress)")
  if (d == "" || of == "") return "no counts"
  ok = (d == S[f, "done"] && of == S[f, "items"])
  if (pr != "") ok = ok && (pr == S[f, "prog"] + S[f, "deleg"])
  return ok ? "agrees" : "DIFFERS"
}
function pct(f,   it, n) {
  it = S[f, "items"]; if (it == 0) return ""
  # percent points times items; integer maths so both shells round the same way
  n = S[f, "done"] * 100 + w * (S[f, "prog"] + S[f, "deleg"])
  return int((2 * n + it) / (2 * it))
}
# Code fences, CommonMark style: close only with the same character, at least as many.
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
function stats(f,   line, fence, was, plain, best, kind, m, i, st) {
  if ((f SUBSEP "items") in S) return
  split("done prog deleg todo blocked postponed items", K, " ")
  for (i = 1; i <= 7; i++) S[f, K[i]] = 0
  S[f, "status"] = ""; S[f, "claim"] = "no status line"; fence = ""
  while ((getline line < f) > 0) {
    sub(/\r$/, "", line)
    was = fence; fence = stepfence(line, fence)
    if (was != "" || fence != "") continue
    if (S[f, "status"] == "" && match(line, /^\*\*Status[ \t]+[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]([ \t]+[0-9][0-9]:[0-9][0-9])?/)) {
      st = substr(line, RSTART, RLENGTH); sub(/^\*\*Status[ \t]+/, "", st); S[f, "status"] = st; stext = line
    }
    if (line !~ /^[ \t]*\|/) continue
    plain = line; gsub(/`[^`]*`/, "", plain)
    best = 0; kind = ""
    for (m in MARK) { i = index(plain, m); if (i > 0 && (best == 0 || i < best)) { best = i; kind = MARK[m] } }
    if (kind != "") { S[f, kind]++; S[f, "items"]++ }
  }
  close(f)
  if (S[f, "status"] != "") S[f, "claim"] = claim(stext, f)
}
function cellsplit(line, out,   s, n, i) {
  s = line; gsub(/`[^`]*`/, "code", s)
  sub(/^[ \t]*\|/, "", s); sub(/\|[ \t]*$/, "", s)
  n = split(s, out, "|")
  for (i = 1; i <= n; i++) { gsub(/^[ \t]+|[ \t]+$/, "", out[i]) }
  return n
}
BEGIN {
  MARK["\342\234\205"] = "done"; MARK["\342\230\221"] = "done"; MARK["\342\227\247"] = "prog"
  MARK["\342\207\242"] = "deleg"; MARK["\342\230\220"] = "todo"; MARK["\342\233\224"] = "blocked"
  MARK["\342\217\270"] = "postponed"
  differs = 0
  printf "spine-status  root: %s\n\n", root
  print "| File | Done | In progress | Delegated | To do | Blocked | Postponed | Items | Percent | Status line | Status counts |"
  print "|---|---|---|---|---|---|---|---|---|---|---|"
  while ((getline f < listfile) > 0) {
    stats(f); p = pct(f); p = (p == "") ? "n/a" : p "%"
    stl = (S[f, "status"] == "") ? "none" : S[f, "status"]
    if (S[f, "claim"] == "DIFFERS") differs++
    printf "| %s | %d | %d | %d | %d | %d | %d | %d | %s | %s | %s |\n", rel(f), S[f, "done"], S[f, "prog"], S[f, "deleg"], S[f, "todo"], S[f, "blocked"], S[f, "postponed"], S[f, "items"], p, stl, S[f, "claim"]
  }
  close(listfile)
  bf = root "/" board
  print ""
  if (!isfile(bf)) { printf "Board: %s not found, board check skipped.\n", board }
  else {
    n = 0; start = 0
    while ((getline line < bf) > 0) { sub(/\r$/, "", line); BL[++n] = line; if (!start && line ~ /^#+[ \t]+Status board/) start = n }
    close(bf)
    if (!start) printf "Board: no \047## Status board\047 heading in %s, board check skipped.\n", board
    else {
      printf "Board: %s\n\n", board
      print "| Board line | Workstream | Links to | Board Done | Computed | Board Count | Computed count | Result |"
      print "|---|---|---|---|---|---|---|---|"
      row = 0; iD = 0; iC = 0; iW = 2
      for (i = start + 1; i <= n; i++) {
        line = BL[i]
        if (line !~ /^[ \t]*\|/) { if (row > 0) break; else continue }
        nc = cellsplit(line, C); row++
        if (row == 1) { for (c = 1; c <= nc; c++) { if (C[c] == "Done") iD = c; if (C[c] == "Count") iC = c; if (C[c] == "Workstream") iW = c }; continue }
        if (row == 2) continue
        work = C[iW]; bp = iD ? C[iD] : ""; bc = iC ? C[iC] : ""
        target = ""; tmp = line
        while (match(tmp, /\]\([^)#[:space:]]+\.md(#[^)]*)?\)/)) {
          t = substr(tmp, RSTART + 2, RLENGTH - 3); sub(/#.*/, "", t); tmp = substr(tmp, RSTART + RLENGTH)
          if (t !~ /^[A-Za-z][A-Za-z0-9+.-]*:/) { target = t; break }
        }
        if (target == "") { printf "| %d | %s | none | %s | n/a | %s | n/a | no link |\n", i, work, bp, bc; continue }
        gsub(/%20/, " ", target)
        full = norm(dirname(bf) "/" target)
        if (!isfile(full)) { differs++; printf "| %d | %s | %s | %s | n/a | %s | n/a | DIFFERS: link broken |\n", i, work, target, bp, bc; continue }
        stats(full); p = pct(full); ptext = (p == "") ? "n/a" : p "%"
        cc = sprintf("%d done, %d in progress or delegated, of %d", S[full, "done"], S[full, "prog"] + S[full, "deleg"], S[full, "items"])
        result = "agrees"
        if (match(bp, /[0-9]+[ \t]*%/)) { b = substr(bp, RSTART, RLENGTH) + 0; if (p == "" || b != p) result = "DIFFERS" }
        else if (bp != "" && bp != "n/a") result = "no percent"
        if (claim(bc, full) == "DIFFERS") result = "DIFFERS"
        if (result == "DIFFERS") differs++
        printf "| %d | %s | %s | %s | %s | %s | %s | %s |\n", i, work, rel(full), bp, ptext, bc, cc, result
      }
    }
  }
  print ""
  printf "Counting rule: each table row counts once, by the first status mark in it. Percent = (done + %d%% of each in progress or delegated item) / items, rounded half up.\n", w
  if (differs > 0) { printf "result: %d claim(s) DIFFER from the status marks\n", differs; exit 1 }
  print "result: OK, every claim agrees"; exit 0
}'
