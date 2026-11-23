<#
check-docs.ps1 - taimzz9-living-docs-spine v2.0 - MIT, by Taimzz9 (Taim Al-Bakri)

Read only. Checks every .md file under a folder:
  1. every relative link and reference definition resolves to a file or folder
  2. every #anchor to a .md file matches a heading (GitHub style slug) or an <a id>
  3. every table row has the same number of cells as its header row
Links inside code fences and inline code are ignored. http, https, mailto and
other scheme links are not checked (no network).

Usage (Windows PowerShell 5.1 or PowerShell 7):
  powershell -NoProfile -ExecutionPolicy Bypass -File check-docs.ps1 -Root D:\repo
  powershell -NoProfile -ExecutionPolicy Bypass -File check-docs.ps1 -Root . -Skip .git,node_modules,dist

Exit codes: 0 = 0 broken links and 0 malformed tables (anchors only warn unless
-StrictAnchors); 1 = something to fix; 2 = bad arguments.
This file is ASCII only on purpose: Windows PowerShell 5.1 reads a .ps1 without
a BOM in the ANSI code page.
#>
param(
  [string]$Root = (Get-Location).Path,
  [string[]]$Skip = @('.git', 'node_modules'),
  [switch]$StrictAnchors
)

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
  Write-Output "check-docs: folder not found: $Root (pass -Root <folder>)"
  exit 2
}
$Root = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\', '/')
$enc = New-Object System.Text.UTF8Encoding($false)

function Get-Rel([string]$full) {
  if ($full.StartsWith($Root, [StringComparison]::OrdinalIgnoreCase)) {
    return $full.Substring($Root.Length).TrimStart('\', '/').Replace('\', '/')
  }
  return $full
}

function Test-Skipped([string]$full) {
  foreach ($part in ((Get-Rel $full) -split '/')) {
    if ($Skip -contains $part) { return $true }
  }
  return $false
}

# GitHub style heading slug: trim, lower case, drop everything that is not a
# letter, digit, space, hyphen or underscore, then each space becomes a hyphen.
function Get-Slug([string]$text) {
  $t = $text.Trim().ToLowerInvariant()
  $t = [regex]::Replace($t, '[^\p{L}\p{Nd}\p{Mn} _-]', '')
  return $t.Replace(' ', '-')
}

# Code fences, CommonMark style: a fence opens with 3+ backticks or tildes and
# closes only with the same character, at least as many, and nothing after.
# Returns the open fence marker, or '' when outside a fence.
function Step-Fence([string]$line, [string]$open) {
  if ($open -eq '') {
    if ($line -match '^\s{0,3}(`{3,}|~{3,})') { return $Matches[1] }
    return ''
  }
  $ch = [regex]::Escape($open.Substring(0, 1))
  if ($line -match ('^\s{0,3}' + $ch + '{' + $open.Length + ',}\s*$')) { return '' }
  return $open
}
$codeRx = '`[^`]*`'
$linkRx = '!?\[[^\]]*\]\(\s*<?([^)\s>]+)>?(?:\s+"[^"]*")?\s*\)'
$defRx = '^\s{0,3}\[[^\]]+\]:\s*<?([^\s>]+)>?'
$schemeRx = '^[A-Za-z][A-Za-z0-9+.-]*:'
$headRx = '^\s{0,3}#{1,6}\s+(.+?)\s*#*\s*$'
$idRx = '<a\s+(?:id|name)="([^"]+)"'
$sepRx = '^\s*\|?\s*:?-{1,}:?\s*(\|\s*:?-{1,}:?\s*)*\|?\s*$'

$files = @(Get-ChildItem -LiteralPath $Root -Recurse -File -Filter *.md -ErrorAction SilentlyContinue |
  Where-Object { -not (Test-Skipped $_.FullName) } | Sort-Object FullName)

$anchorCache = @{}
function Get-Anchors([string]$path) {
  if ($anchorCache.ContainsKey($path)) { return $anchorCache[$path] }
  $set = @{}
  $fence = ''
  foreach ($line in [IO.File]::ReadAllLines($path, $enc)) {
    $was = $fence; $fence = Step-Fence $line $fence
    if ($was -ne '' -or $fence -ne '') { continue }
    if ($line -match $headRx) {
      $base = Get-Slug ($Matches[1].Replace('`', ''))
      $slug = $base; $n = 0
      while ($set.ContainsKey($slug)) { $n++; $slug = "$base-$n" }
      $set[$slug] = $true
    }
    foreach ($m in [regex]::Matches($line, $idRx)) { $set[$m.Groups[1].Value] = $true }
  }
  $anchorCache[$path] = $set
  return $set
}

$links = 0; $broken = New-Object System.Collections.Generic.List[string]
$anchorsMissing = New-Object System.Collections.Generic.List[string]
$tables = New-Object System.Collections.Generic.List[string]

function Test-Target([string]$file, [int]$lineNo, [string]$target) {
  if ($target -match $schemeRx -or $target.StartsWith('//')) { return }
  $script:links++
  $path = $target; $anchor = ''
  $hash = $target.IndexOf('#')
  if ($hash -ge 0) { $path = $target.Substring(0, $hash); $anchor = $target.Substring($hash + 1) }
  $q = $path.IndexOf('?'); if ($q -ge 0) { $path = $path.Substring(0, $q) }
  try { $path = [Uri]::UnescapeDataString($path) } catch { }
  $here = "$(Get-Rel $file):$lineNo"
  if ($path -eq '') { $full = $file }
  elseif ($path.StartsWith('/')) { $full = [IO.Path]::GetFullPath((Join-Path $Root $path.TrimStart('/'))) }
  else { $full = [IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $file) $path)) }
  if (-not (Test-Path -LiteralPath $full)) { $script:broken.Add("BROKEN   $here  $target"); return }
  if ($anchor -ne '' -and $full.EndsWith('.md', [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $full -PathType Leaf)) {
    try { $a = [Uri]::UnescapeDataString($anchor) } catch { $a = $anchor }
    if (-not (Get-Anchors $full).ContainsKey($a.ToLowerInvariant()) -and -not (Get-Anchors $full).ContainsKey($a)) {
      $script:anchorsMissing.Add("ANCHOR   $here  $target")
    }
  }
}

function Get-CellCount([string]$line) {
  $s = ([regex]::Replace($line, $codeRx, '')).Replace('\|', '').Trim()
  if ($s.StartsWith('|')) { $s = $s.Substring(1) }
  if ($s.EndsWith('|')) { $s = $s.Substring(0, $s.Length - 1) }
  return ($s.Split('|')).Count
}

foreach ($f in $files) {
  $lines = [IO.File]::ReadAllLines($f.FullName, $enc)
  $fence = ''; $block = 0; $headerCells = 0; $isTable = $false
  for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]; $no = $i + 1
    $was = $fence; $fence = Step-Fence $line $fence
    if ($was -ne '' -or $fence -ne '') { $block = 0; continue }
    # tables
    if ($line.TrimStart().StartsWith('|')) {
      $block++
      if ($block -eq 1) { $headerCells = Get-CellCount $line; $isTable = $false }
      elseif ($block -eq 2) { $isTable = ($line -match $sepRx) }
      elseif ($isTable) {
        $c = Get-CellCount $line
        if ($c -ne $headerCells) { $tables.Add("TABLE    $(Get-Rel $f.FullName):$no  row has $c cells, header has $headerCells") }
      }
    } else { $block = 0 }
    # links
    $plain = [regex]::Replace($line, $codeRx, '')
    foreach ($m in [regex]::Matches($plain, $linkRx)) { Test-Target $f.FullName $no $m.Groups[1].Value }
    if ($plain -match $defRx) { Test-Target $f.FullName $no $Matches[1] }
  }
}

Write-Output "check-docs  root: $Root"
Write-Output ("files: {0}  relative links: {1}  broken: {2}  anchors not found: {3}  malformed table rows: {4}" -f $files.Count, $links, $broken.Count, $anchorsMissing.Count, $tables.Count)
foreach ($l in $broken) { Write-Output $l }
foreach ($l in $tables) { Write-Output $l }
foreach ($l in $anchorsMissing) { Write-Output $l }
$fail = ($broken.Count -gt 0) -or ($tables.Count -gt 0) -or ($StrictAnchors -and $anchorsMissing.Count -gt 0)
if ($fail) { Write-Output 'result: FIX NEEDED'; exit 1 }
Write-Output 'result: OK'
exit 0
