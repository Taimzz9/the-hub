<#
spine-status.ps1 - taimzz9-living-docs-spine v2.0 - MIT, by Taimzz9 (Taim Al-Bakri)

Read only. Recomputes percent done from status marks and compares it with what
the docs claim.
  1. For each tracked file: counts table rows by the FIRST status mark in the row
     (done, in progress, delegated, to do, blocked, postponed) and computes
     percent = (done + 20% of each in progress or delegated item) / items,
     rounded half up: the 20/80 earned value rule. -InProgressWeight 50 gives
     the 50/50 rule of v1.
  2. Compares each file's "**Status YYYY-MM-DD HH:MM:**" line counts
     ("N done", "N in progress", "of N") with the computed counts.
  3. Compares every row of the board's "## Status board" table (Done and Count
     columns) with the computed numbers of the first .md file the row links to.
Only table rows outside code fences are counted. Headings and prose are not.

Usage (Windows PowerShell 5.1 or PowerShell 7):
  powershell -NoProfile -ExecutionPolicy Bypass -File spine-status.ps1 -Root D:\repo
  ... -Root D:\repo -Board HOME.md -Path docs\other-plan.md
Default tracked files: PLAN.md, projects/*/PROJECT.md (not folders starting
with _), docs/runbooks/R<digit>*.md, plus every file the board links to.

Exit codes: 0 = every claim agrees; 1 = at least one claim differs; 2 = bad arguments.
ASCII only on purpose (Windows PowerShell 5.1 reads a .ps1 without BOM as ANSI);
the status marks are built from their code points.
#>
param(
  [string]$Root = (Get-Location).Path,
  [string]$Board = 'HOME.md',
  [string[]]$Path = @(),
  [ValidateRange(0, 100)][int]$InProgressWeight = 20
)

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
  Write-Output "spine-status: folder not found: $Root (pass -Root <folder>)"
  exit 2
}
$Root = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\', '/')
$enc = New-Object System.Text.UTF8Encoding($false)

# status marks by code point
$marks = [ordered]@{
  ([string][char]0x2705) = 'done'      # white heavy check mark
  ([string][char]0x2611) = 'done'      # ballot box with check
  ([string][char]0x25E7) = 'prog'      # square with left half black
  ([string][char]0x21E2) = 'deleg'     # dashed arrow right
  ([string][char]0x2610) = 'todo'      # ballot box
  ([string][char]0x26D4) = 'blocked'   # no entry
  ([string][char]0x23F8) = 'postponed' # pause
}
# Code fences, CommonMark style: closes only with the same character, at least
# as many. Returns the open fence marker, or '' when outside a fence.
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

function Get-Rel([string]$full) {
  if ($full.StartsWith($Root, [StringComparison]::OrdinalIgnoreCase)) {
    return $full.Substring($Root.Length).TrimStart('\', '/').Replace('\', '/')
  }
  return $full
}

function Get-Claim([string]$text) {
  $c = @{ done = $null; prog = $null; of = $null }
  if ($text -match '(\d+)\s+done') { $c.done = [int]$Matches[1] }
  if ($text -match '(\d+)\s+(?:delegated or in progress|in progress)') { $c.prog = [int]$Matches[1] }
  if ($text -match '\bof\s+(\d+)') { $c.of = [int]$Matches[1] }
  return $c
}

function Get-Pct($s) {
  if ($s.items -eq 0) { return $null }
  # percent points times items; integer maths so both shells round the same way
  $num = $s.done * 100 + $InProgressWeight * ($s.prog + $s.deleg)
  return [int][math]::Floor((2 * $num + $s.items) / (2 * $s.items))
}

function Test-Claim($c, $s) {
  if ($null -eq $c.done -or $null -eq $c.of) { return 'no counts' }
  $ok = ($c.done -eq $s.done) -and ($c.of -eq $s.items)
  if ($null -ne $c.prog) { $ok = $ok -and ($c.prog -eq ($s.prog + $s.deleg)) }
  if ($ok) { return 'agrees' }
  return 'DIFFERS'
}

$cache = @{}
function Get-Stats([string]$full) {
  if ($cache.ContainsKey($full)) { return $cache[$full] }
  $s = @{ done = 0; prog = 0; deleg = 0; todo = 0; blocked = 0; postponed = 0; items = 0; status = ''; claim = 'no status line' }
  $fence = ''
  foreach ($line in [IO.File]::ReadAllLines($full, $enc)) {
    $was = $fence; $fence = Step-Fence $line $fence
    if ($was -ne '' -or $fence -ne '') { continue }
    if ($s.status -eq '' -and $line -match '^\*\*Status\s+(\d{4}-\d{2}-\d{2}(?:\s+\d{2}:\d{2})?)') {
      $s.status = $Matches[1]; $s.statusText = $line
    }
    if (-not $line.TrimStart().StartsWith('|')) { continue }
    $plain = [regex]::Replace($line, $codeRx, '')
    $best = -1; $kind = $null
    foreach ($m in $marks.Keys) {
      # Ordinal: a culture aware IndexOf treats some symbols as ignorable and matches at 0
      $i = $plain.IndexOf($m, [StringComparison]::Ordinal)
      if ($i -ge 0 -and ($best -lt 0 -or $i -lt $best)) { $best = $i; $kind = $marks[$m] }
    }
    if ($null -ne $kind) { $s[$kind]++; $s.items++ }
  }
  if ($s.status -ne '') { $s.claim = Test-Claim (Get-Claim $s.statusText) $s }
  $cache[$full] = $s
  return $s
}

# tracked files
$tracked = New-Object System.Collections.Generic.List[string]
$plan = Join-Path $Root 'PLAN.md'
if (Test-Path -LiteralPath $plan) { $tracked.Add($plan) }
$proj = Join-Path $Root 'projects'
if (Test-Path -LiteralPath $proj) {
  Get-ChildItem -LiteralPath $proj -Directory | Where-Object { -not $_.Name.StartsWith('_') } | Sort-Object Name | ForEach-Object {
    $p = Join-Path $_.FullName 'PROJECT.md'; if (Test-Path -LiteralPath $p) { $tracked.Add($p) }
  }
}
$rb = Join-Path $Root 'docs\runbooks'
if (Test-Path -LiteralPath $rb) {
  Get-ChildItem -LiteralPath $rb -File -Filter 'R*.md' | Where-Object { $_.Name -match '^R\d' } | Sort-Object Name | ForEach-Object { $tracked.Add($_.FullName) }
}
foreach ($p in $Path) {
  $full = [IO.Path]::GetFullPath((Join-Path $Root $p))
  if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { Write-Output "spine-status: file not found: $p"; exit 2 }
  if (-not $tracked.Contains($full)) { $tracked.Add($full) }
}

$differs = 0
Write-Output "spine-status  root: $Root"
Write-Output ''
Write-Output '| File | Done | In progress | Delegated | To do | Blocked | Postponed | Items | Percent | Status line | Status counts |'
Write-Output '|---|---|---|---|---|---|---|---|---|---|---|'
foreach ($f in $tracked) {
  $s = Get-Stats $f
  $pct = Get-Pct $s; if ($null -eq $pct) { $pct = 'n/a' } else { $pct = "$pct%" }
  $st = $s.status; if ($st -eq '') { $st = 'none' }
  if ($s.claim -eq 'DIFFERS') { $differs++ }
  Write-Output ("| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7} | {8} | {9} | {10} |" -f (Get-Rel $f), $s.done, $s.prog, $s.deleg, $s.todo, $s.blocked, $s.postponed, $s.items, $pct, $st, $s.claim)
}

# board
$boardFull = Join-Path $Root $Board
Write-Output ''
if (-not (Test-Path -LiteralPath $boardFull -PathType Leaf)) {
  Write-Output "Board: $Board not found, board check skipped."
} else {
  $lines = [IO.File]::ReadAllLines($boardFull, $enc)
  $start = -1
  for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^#{1,6}\s+Status board') { $start = $i; break } }
  if ($start -lt 0) {
    Write-Output "Board: no '## Status board' heading in $Board, board check skipped."
  } else {
    Write-Output "Board: $Board"
    Write-Output ''
    Write-Output '| Board line | Workstream | Links to | Board Done | Computed | Board Count | Computed count | Result |'
    Write-Output '|---|---|---|---|---|---|---|---|'
    $hdr = $null; $iDone = -1; $iCount = -1; $iWork = 1; $row = 0
    for ($i = $start + 1; $i -lt $lines.Count; $i++) {
      $line = $lines[$i]
      if (-not $line.TrimStart().StartsWith('|')) { if ($null -ne $hdr) { break } else { continue } }
      $cells = @(([regex]::Replace($line, $codeRx, 'code')).Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
      $row++
      if ($row -eq 1) {
        $hdr = $cells
        for ($c = 0; $c -lt $cells.Count; $c++) {
          if ($cells[$c] -eq 'Done') { $iDone = $c }
          if ($cells[$c] -eq 'Count') { $iCount = $c }
          if ($cells[$c] -eq 'Workstream') { $iWork = $c }
        }
        continue
      }
      if ($row -eq 2) { continue }
      $work = ''; if ($iWork -lt $cells.Count) { $work = $cells[$iWork] }
      $boardPct = ''; if ($iDone -ge 0 -and $iDone -lt $cells.Count) { $boardPct = $cells[$iDone] }
      $boardCount = ''; if ($iCount -ge 0 -and $iCount -lt $cells.Count) { $boardCount = $cells[$iCount] }
      $target = $null
      foreach ($m in [regex]::Matches($line, '\]\(([^)#\s]+\.md)(#[^)]*)?\)')) {
        if ($m.Groups[1].Value -notmatch '^[A-Za-z][A-Za-z0-9+.-]*:') { $target = $m.Groups[1].Value; break }
      }
      if ($null -eq $target) { Write-Output ("| {0} | {1} | none | {2} | n/a | {3} | n/a | no link |" -f ($i + 1), $work, $boardPct, $boardCount); continue }
      $full = [IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $boardFull) ([Uri]::UnescapeDataString($target))))
      if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { $differs++; Write-Output ("| {0} | {1} | {2} | {3} | n/a | {4} | n/a | DIFFERS: link broken |" -f ($i + 1), $work, $target, $boardPct, $boardCount); continue }
      $s = Get-Stats $full
      $pct = Get-Pct $s; $pctText = 'n/a'; if ($null -ne $pct) { $pctText = "$pct%" }
      $compCount = "{0} done, {1} in progress or delegated, of {2}" -f $s.done, ($s.prog + $s.deleg), $s.items
      $result = 'agrees'
      if ($boardPct -match '(\d+)\s*%') { if ($null -eq $pct -or [int]$Matches[1] -ne $pct) { $result = 'DIFFERS' } }
      elseif ($boardPct -ne '' -and $boardPct -ne 'n/a') { $result = 'no percent' }
      $cc = Test-Claim (Get-Claim $boardCount) $s
      if ($cc -eq 'DIFFERS') { $result = 'DIFFERS' }
      if ($result -eq 'DIFFERS') { $differs++ }
      Write-Output ("| {0} | {1} | {2} | {3} | {4} | {5} | {6} | {7} |" -f ($i + 1), $work, (Get-Rel $full), $boardPct, $pctText, $boardCount, $compCount, $result)
    }
  }
}

Write-Output ''
Write-Output ("Counting rule: each table row counts once, by the first status mark in it. Percent = (done + {0}% of each in progress or delegated item) / items, rounded half up." -f $InProgressWeight)
if ($differs -gt 0) { Write-Output "result: $differs claim(s) DIFFER from the status marks"; exit 1 }
Write-Output 'result: OK, every claim agrees'
exit 0
