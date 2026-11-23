# Templates

Part of [taimzz9-living-docs-spine](../SKILL.md) v2.0. Starting text for each spine file. Replace
every `...` and `YYYY` placeholder; keep the shapes, because `spine-status` and `check-docs` read them.

## Contents

1. HOME status board
2. Status line
3. PLAN phase
4. PROJECT.md (portfolio layout)
5. LOG.md
6. Runbook
7. Runbook index
8. CHANGELOG entry
9. Owner decision item
10. Nav footer

## 1 · HOME status board

```
# Project name · Home

## Status board

**Updated YYYY-MM-DD HH:MM.** Priority 1 is up next. Percent = (done + 20% of each in progress or
delegated item) / items, counted from the status marks in each linked document (20/80 rule).
Recomputed with spine-status.

| Priority | Workstream | Where | Next action | Who | Done | Count |
|---|---|---|---|---|---|---|
| 1 | ... | [PLAN phase 2](PLAN.md#phase-2--name) · [R12](docs/runbooks/R12-name.md) | one concrete action | Owner | 63% | 7 done, 6 in progress, of 13 |

**Document map:** [PLAN](PLAN.md) · [Runbooks](docs/runbooks/README.md) · [CONVENTIONS](CONVENTIONS.md) · [CHANGELOG](CHANGELOG.md) · [HANDOFF](HANDOFF.md)
```

The first `.md` link in **Where** must be the file that holds that workstream's items.

## 2 · Status line

Second line of every living doc that holds items, updated in the same edit as the marks:

```
**Status YYYY-MM-DD HH:MM:** 4 done, 1 in progress, of 9. Next: one concrete action.
```

`spine-status` compares `N done`, `N in progress` and `of N` with the marks.

## 3 · PLAN phase

```
## Phase 2 · Name  ◧

| # | Item | Owner | Status | Done when |
|---|---|---|---|---|
| 2.2 | ... | Owner | ◧ draft written; owner review to do | one line state |
| 2.3 | ... | Vendor | ⇢ Vendor name, asked YYYY-MM-DD | ... |
| 2.1 | ... | Claude | ✅ DONE YYYY-MM-DD HH:MM | ... |
```

## 4 · PROJECT.md (portfolio layout)

```
# Pnnn · Project name

**Status YYYY-MM-DD HH:MM:** 0 done, 0 in progress, of 6. Next: G0 reuse search.

| Field | Value |
|---|---|
| Type | Client / Internal |
| Client | business name |
| Owner | name |
| Started | YYYY-MM-DD |
| Estimate | hours |
| Actual hours | running total |
| Hours saved by reuse | estimate, or "not measured" |

## Brief

Goal in one or two sentences. Scope. **Out of scope:** ...

## Reused (G0)

| Knowledge entry | How it was used | Hours saved (estimate) |
|---|---|---|

## Items

| # | Item | Who | Status | Updated |
|---|---|---|---|---|
| 1 | G0 Reuse search | Claude | ☐ | |
| 2 | G1 Brief confirmed by owner | Owner | ☐ | |
| 3 | G2 build item | | ☐ | |
| 5 | G3 Handover | | ☐ | |
| 6 | G4 Extraction: entries written; actual vs estimate recorded | Claude | ☐ | |

## Evidence

One line per done item: readback, output, link, or "per the owner report".

## Lessons (G4)

| Lesson | Became knowledge entry |
|---|---|
```

## 5 · LOG.md

```
# Pnnn · Log

Newest first. What was done, by whom, what was checked, what was found and not fixed.

## YYYY-MM-DD HH:MM

- Changed: ...
- Verified: command and its result line
- Not checked: ...
```

## 6 · Runbook

````
# R12 · Title

**Status YYYY-MM-DD HH:MM:** 1 done, 0 in progress, of 3. Next: step 2.

| # | Step | Where | As | Takes | Status | Updated |
|---|---|---|---|---|---|---|
| 2 | ... | SERVER01, elevated | domain admin (needs X) | 5 min | ☐ | |
| 1 | ... | ... | ... | 2 min | ✅ DONE YYYY-MM-DD HH:MM | YYYY-MM-DD HH:MM |

## 2 · Title  ☐

**Where:** ... **As:** ... because ...

Read first:

```powershell
& { Get-Service -Name 'X' | Select-Object Name, Status; 'want: Status Running' }
```

CHANGE:

```powershell
& { $p = @{ Name = 'X'; StartupType = 'Automatic' }; Set-Service @p; (Get-Service X).StartType; 'want: Automatic' }
```

**Good:** `Automatic` printed beside `want: Automatic`.
````

## 7 · Runbook index

```
# Runbooks

**Status YYYY-MM-DD HH:MM:** 4 runbooks. Next: R12 step 2.

## Up next

1. [R12 step 2](R12-name.md) ... (owner)

| ID | Runbook | Who | State |
|---|---|---|---|
| R12 | [Title](R12-name.md) | Owner | ◧ 1 of 3 |
```

## 8 · CHANGELOG entry

```
## YYYY-MM-DD HH:MM · What happened (project at N%)

- **Changed:** ...
- **Verified:** check-docs: N links, 0 broken, 0 malformed table rows; spine-status: every claim agrees.
- **Not changed:** ...
- **Not checked:** ...
- **Found, not fixed:** ...
```

Use only the lines that apply.

## 9 · Owner decision item

```
| 8 | Owner decision: include X or not: yes ("Yes, include X") | Owner | ✅ DONE YYYY-MM-DD HH:MM | YYYY-MM-DD HH:MM |
| 8c | Supersedes 8: X removed again ("..."), see LOG YYYY-MM-DD | Owner | ✅ DONE ... | ... |
```

## 10 · Nav footer

```
<!-- nav -->
---
**Related:** [Home, status board](HOME.md#status-board) · [PLAN](PLAN.md) · [CHANGELOG](CHANGELOG.md)
```

Paths are relative to the file's own folder. Skip the self link.

<!-- nav -->
---
**Related:** [Skill](../SKILL.md) · [Portfolio](portfolio.md) · [Automation](automation.md)
