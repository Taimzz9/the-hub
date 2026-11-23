---
name: taimzz9-living-docs-spine
description: "v2.0 · Taim Al-Bakri's (Taimzz9) living documentation system for one project or many. HOME status board with priorities, next actions and percent done recomputed by a bundled script; status marks with done items at the bottom, timestamps and evidence; cross linked docs checked by a bundled link and table checker; copy and paste runbooks; changelog and owner decisions; optional multi project layout with a registry, project folders and a knowledge library; read only verifier pass. Modes: new, adopt, update, project, check, verify. Use when the user asks to set up, organise, restructure, update, check or verify project docs, start or close a project or task, mark items done, or replicate this documentation structure."
argument-hint: new | adopt | update | project | check | verify
license: MIT
---

# Taimzz9 Living Docs Spine

> One status board that says what is next and how far along everything is, status marks that keep
> done items at the bottom, runbooks a non engineer can run by copy and paste, two scripts that
> recompute the numbers and check every link, and a read only verifier pass that checks the docs
> against live state.
>
> By Taimzz9 (Taim Al-Bakri) · Version 2.0, 2026-11-22 · Free under the MIT licence, see [LICENSE](LICENSE).
> Featured in the BiWize AI Cheat Sheet at https://biwize.ca/aics/ and published on GitHub under MIT: https://github.com/Taimzz9/taimzz9-living-docs-spine

**Source column:** ids like `D16`, `K18`, `A4`, `F6` point to [research.md](research.md) (D docs
practice, K skill authoring, A Claude Code automation, F field evidence from a real spine).
**House** is the author's rule, not outside guidance.

## Pick the mode

| Mode | When | Do | Source |
|---|---|---|---|
| `new` | No status board and few docs | Part 1 | v1 |
| `adopt` | Architecture, conventions or many docs already exist | Part 2 | v1 |
| `update` | Already on the system | Common rules on the change in front of you, then `check` | v1, F6 |
| `project` | Start or close one project or task inside a multi project spine | [references/portfolio.md](references/portfolio.md) | F1, F2 |
| `check` | Numbers or links may have drifted; before a commit; on request | Run both scripts, report the output, change nothing | F6 to F8, D5 |
| `verify` | A milestone, or the owner asks whether the docs are true | `check`, then C6 | v1, A16 |

The argument, if given, picks the mode. Where no argument is passed (claude.ai chat has no argument
substitution, `K10`), infer it from the request and say which mode runs.

## Bundled scripts

Run them; do not read them into context (`K18`). Both are read only, need no network and no installs
(`K22`), and print a markdown result plus a `result:` line. Exit 0 = clean, 1 = something to fix,
2 = bad arguments.

| Script | Checks | Source |
|---|---|---|
| `scripts/check-docs.ps1`, `scripts/check-docs.sh` | Every relative link and reference definition resolves; `#anchors` match a heading (warning only); every table row has as many cells as its header | `D5`, `D20`, `F8`, `F9` |
| `scripts/hook-check-docs.sh` | Claude Code PostToolUse hook wrapper: runs `check-docs` after a `.md` edit and feeds back only the problems ([references/automation.md](references/automation.md)) | `A4`, tested |
| `scripts/spine-status.ps1`, `scripts/spine-status.sh` | Recomputes done, in progress, delegated, to do, blocked, postponed and percent from the status marks in `PLAN.md`, `projects/*/PROJECT.md` and `docs/runbooks/R<n>*.md`; compares each file's Status line and every HOME board row with them | `F6`, `F7`, `D16` |

The scripts live in this skill's folder: `${CLAUDE_SKILL_DIR}/scripts/` in Claude Code (`A11`), or the
folder this SKILL.md was loaded from elsewhere. Paths below use forward slashes (`K20`).

```
bash scripts/check-docs.sh <repo>          # bash, Git Bash, macOS, Linux
bash scripts/spine-status.sh <repo>
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/check-docs.ps1 -Root <repo>
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/spine-status.ps1 -Root <repo>
```

Options: `check-docs` takes `--skip a,b` / `-Skip a,b` (default `.git,node_modules`) and
`--strict-anchors` / `-StrictAnchors`; `spine-status` takes `--board FILE` / `-Board FILE` and
`--path FILE` / `-Path FILE` for more tracked files and `--weight N` / `-InProgressWeight N` (default 20). If neither bash nor PowerShell can run (some chat
sandboxes), do the same checks by hand and say "scripts not run".

---

# Part 1 · At the beginning of a project

You are setting up the documentation system for this project and will keep it current on every turn
that changes state. The owner reads these docs to decide what to do next, runs steps from them by
copy and paste, and hands them to vendors and IT.

## 1.0 · Project facts (ask the owner if blank)

- Project name: ______
- Owner name and role: ______
- Who else acts on the docs (vendors, IT, MSP): ______
- One project, or many projects and tasks from one place: ______ (many: also set up [references/portfolio.md](references/portfolio.md))

## 1.1 · Create these files

Starting text for each is in [references/templates.md](references/templates.md).

| File | Job |
|---|---|
| `HOME.md` | Start here. **Status board at the very top**, then the document map |
| `PLAN.md` | The only live plan. Phases; every item has a status mark, an owner tag and a one line "Done when" |
| `CHANGELOG.md` | Newest first, ISO dates (`D13`). One entry per day or significant action (C9) |
| `HANDOFF.md` | Resume from cold. First line points to the HOME status board |
| `CONVENTIONS.md` | How we build: rules, gotchas, what never to do, the mistakes table (C8) |
| `docs/runbooks/README.md` | Runbook index: an "Up next" numbered list, then a table of every runbook with its state |
| `docs/runbooks/Rnn-*.md` | One runbook per job the owner or a third party must do by hand |
| `docs/handover/*.md` | Environment, access, reviews: reference the runbooks link to |
| `CLAUDE.md` (Claude Code projects) | One line: "Docs follow taimzz9-living-docs-spine; start at HOME.md#status-board." Status never lives here or in auto memory (`K28`, `K30`) |

## 1.2 · First run

1. Create the files above with the status board (C1) and the status marks (C2).
2. Add the nav footer (C3) to every file.
3. First CHANGELOG entry: today, "documentation system created".
4. Run `check`: 0 broken links, 0 malformed table rows, every claim agrees.
5. Commit. Tell the owner where the board is and what is up next.

---

# Part 2 · Mid project correction: adopting the system without breaking what exists

You are introducing this system into a project that already has documentation: architecture,
conventions, decision records, specs, guides, runbooks, perhaps hundreds of files. **The goal is one
place that says what is next and how far along everything is, linked to the existing docs. It is not
a rewrite.** Reference docs stay where they are and keep their content.

## 2.0 · Rules for this part

- **Read before writing.** No file is moved, renamed or restructured before the owner approves the
  mapping in step 2.3.
- **The project's own conventions win.** If it has `CONVENTIONS.md`, `ARCHITECTURE.md`, ADRs, a docs
  site, a naming scheme or a `CLAUDE.md`, follow them. Adapt the file names in Part 1 to fit; for
  example, put the status board in the existing README if that is the established entry point, and
  say so.
- **Never delete.** Superseded docs are archived (the project's archive convention, or `archive/`
  with an `_Ar` suffix), and a line is left where they were pointing to the replacement.
- **Preserve links.** Keep file paths and headings that other files, wikis or tickets link to. If a
  file must move, leave a stub at the old path that links to the new one.
- **One step, one commit**, so any step can be reverted alone.

## 2.1 · Inventory

List every documentation file: path, size, last commit date, first heading. Include root files,
`docs/`, wikis in the repo, READMEs in subfolders and ADR folders. Count them. Run `check-docs` once
to record the starting broken link and table counts.

## 2.2 · Classify each file into exactly one class

| Class | Diátaxis type (`D1`, `D2`) | What it is | What happens to it |
|---|---|---|---|
| **State** | none | Says what is done, in progress or next: plans, status pages, trackers | Its status moves into PLAN and the HOME board. The file keeps its content and gets a banner: `Status now lives in [PLAN](PLAN.md). This file is reference as of DATE.` |
| **Procedure** | How to guide | Steps someone runs by hand | Becomes or joins a runbook. Gains status marks, Where, As, read before CHANGE, and a Good line (C4) |
| **Reference** | Reference | Architecture, specs, data models, conventions | **Content untouched.** Gains the nav footer and a row in the HOME document map |
| **Decision** | Explanation | ADRs, decision logs, owner decisions | Untouched. Linked from the PLAN item each one governs (C9) |
| **History** | none | Changelogs, meeting notes, release notes | Kept. The newest changelog becomes `CHANGELOG.md`, or is linked from it if another name is established |
| **Stale** | any | Contradicted by the code or live state, or superseded | Banner: "Stale as of DATE: [what is wrong]. Read [replacement] instead." Archived only with owner approval |

A file that mixes classes (a spec with a "current status" section) stays in place; only its status
section is lifted into PLAN, and that section is replaced by a link. Tutorials, if any, are Reference.

## 2.3 · Mapping table, for owner approval

Write `docs-migration-DATE.md` outside the repo, or as the project's convention says:

| File | Class | Action | Target | Links in |
|---|---|---|---|---|

"Links in" is the count of other files linking to it, found by search. Anything with a high count is
not moved. Show the table to the owner and wait for approval or corrections before step 2.4.

## 2.4 · Build the spine, then connect

Order, one commit each:
1. **PLAN.** Collect every open item from the State files into phases. Each item links back to its
   source doc. Where two sources disagree, record both and mark the item `◧` with "sources disagree:
   [a] vs [b]"; do not pick one.
2. **Status marks and ordering** (C2) in PLAN and every runbook.
3. **HOME status board** (C1), numbers from `spine-status`.
4. **Banners** on State and Stale files.
5. **Runbook index**, listing Procedure files, open first.
6. **Nav footer** (C3) on State, Procedure and the most linked Reference files. For very large sets,
   footer the top 20 by links in and list the rest in the HOME document map.
7. **CHANGELOG** entry: "documentation system adopted", the counts per class, the mapping file.

## 2.5 · Verify, then hand over

Run `verify` on the result: `check` must show 0 broken links, 0 malformed table rows and every claim
agreeing; no reference content changed (`git diff --stat` on Reference files shows only footer
lines). Then tell the owner: where the board is, what is up next, what was found stale, what was not
checked.

## 2.6 · Pitfalls when adopting mid project

| Pitfall | Avoid it by |
|---|---|
| Rewriting architecture or spec docs to "match the new style" | Reference content is untouched; only a footer is added |
| Two sources of status after adoption | Every lifted status section is replaced by a link to PLAN |
| Breaking external links by moving files | Keep paths; stub any moved file |
| Resolving contradictions by guessing | Record both sources, mark `◧`, ask the owner |
| One giant commit nobody can review | One step, one commit |
| Percent inflated by counting reference docs as "done" | Percent counts PLAN, project and runbook items only |
| Losing the owner's existing entry point | Put the board where people already start, if that is established |

---

# Common rules, used by every mode

## C1 · The HOME status board

Directly under the title, before any diagram or prose. Template in [references/templates.md](references/templates.md).

| Rule | Source |
|---|---|
| Columns: Priority, Workstream, Where, Next action, Who, Done, Count. Sort by priority; postponed workstreams last, `⏸`, "n/a" | v1 |
| **Where** links the file that holds the workstream's items first (PLAN section, `PROJECT.md` or runbook); `spine-status` reads that first `.md` link | House, `F6` |
| **Next action is one concrete step**, the first open item of that workstream | v1 |
| **Percent is computed, never estimated or typed from memory.** Percent = (done + 20% of each in progress or delegated item) / items, rounded half up: the 20/80 earned value rule, which weights finishing over starting. Name the rule on the board so readers know the convention | `D16`, `D17`, owner decision 2026-11-22 |
| A project that wants another weight says so on the board and passes it to the script (`--weight 50` / `-InProgressWeight 50` gives v1's 50/50 rule) | `D17` |
| **Count** reads `N done, N in progress, of N` so anyone, and `spine-status`, can recheck it | v1, `F6` |
| After any status change, run `spine-status`; every row must read `agrees` before the turn ends | `F6` |
| A workstream with a `⛔` item says who or what unblocks it in Next action | `D19` |
| More than 3 items in progress in one workstream: say so on the board and finish before starting more | House, `D18` |
| Under the table, a one line **document map** linking every living doc and runbook | v1 |
| A derived number lives in at most two places: the board and the file's own Status line. Other indexes link to the board, or are recomputed in the same turn | House, `F6` |

## C2 · Status marks and ordering

`☐` to do · `◧` in progress or partly done · `⇢` delegated to a named third party · `⛔` blocked ·
`⏸` postponed · `☑` or `✅ DONE YYYY-MM-DD HH:MM` done.

- **One mark per item row.** The first mark in a table row is its status; `spine-status` counts only
  table rows, so a mark in a heading or prose is not counted. (`F6`)
- **Up next on top, done at the bottom.** Within each list, phase, table and section: in progress,
  to do, delegated, blocked, postponed, done. An all done section moves under a `# Done` heading at
  the bottom of its file; an all done phase moves to the bottom of PLAN.
- **Numbers stay stable** when reordering. A step found later gets a suffix (`12b`).
- **Timestamps on every change**: `✅ DONE 2026-09-23 15:10`. Each updated file carries a Status line
  near the top, exactly `**Status YYYY-MM-DD HH:MM:** N done, N in progress, of N. Next: ...`, updated
  in the same edit as the marks. (`F7`)
- **Evidence under the heading** when marking done: the readback, the output line, or "per the owner
  report" when not checked. Never mark done on inference.
- Partly done says what is left: `◧ read done; CHANGE block to do`.

## C3 · Cross links and tables

- Every living doc ends with the same footer, paths relative to its folder:
  `<!-- nav -->` then `---` then `**Related:** [Home, status board](HOME.md#status-board) · [PLAN](PLAN.md) · ...`
  Skip the self link; the marker stops a rerun duplicating it.
- Link the first inline mention of any other doc.
- After each pass run `check-docs`: 0 broken links and 0 malformed table rows. Report the counts from
  its output, never from memory (`F9`). Anchor warnings are fixed or listed as "not checked".

## C4 · Runbooks the owner can run

- **Copy and paste blocks, not script files**, for anything run on a server.
- Each step: `## N · Title  <status>`, **Where** (machine, elevated or not), **As** (which account, and
  why), a **read block first**, then a block marked **CHANGE**, then a **Good:** line with the exact
  output wanted.
- PowerShell blocks wrapped in `& { ... }`; splatting, not backtick continuations. Every check prints
  `want X` beside its result.
- An order table at the top: `# | Step | Where | As | Takes | Status | Updated`, open rows first.
- Results come back as screenshots or pasted output. Read them, then mark the step in every file the
  same turn. If a line fails, say which line, what it means, and the one action that fixes it.
- A runbook run by hand three times or more gets an "automation candidate" line in the index: rote,
  repeated manual work is toil (`D11`, `D12`; threshold House).

## C5 · Update discipline

- **Same turn, every file**: PLAN or PROJECT, the runbook, the runbook index, the HOME board, any
  review doc. Then `check`. Then commit. One source of fact per item; other files link to it.
- **"Use these only to update MDs"** means apply exactly what the owner reported, labelled "per the
  owner", and nothing else.
- **Remove stale text when a fact changes.** Search every doc for the old claim before committing.
  This includes HANDOFF open decisions and PLAN rows another project already closed. (`F7`)
- Never push unless asked. Follow `.gitignore`; fix it rather than force adding. Never write, echo or
  commit a secret; the owner types every password.

## C6 · The verifier pass, on request or at a milestone

Read only: no edits, no fixes. Run `check` first; its output is evidence. Then check live state
against what the docs claim. In Claude Code run it as a fresh context, read only subagent so the
writer does not grade its own work (`A14`, `A16`); paste the script output into its brief, since a
read only agent may lack a shell. Answer each question in exactly this form:

```
VERDICT: confirmed / contradicted / no evidence found
EVIDENCE: [quote, file:line, command output or source URL. No paraphrase.]
CONFIDENCE: high / medium / low
COULD NOT CHECK: [anything out of scope, missing or unreachable]
```

"No evidence found" is a valid answer. Write the report to a temporary `milestone-verifier-DATE.md`
outside the repo, ending with a table of `file:line | what the evidence says`. The next pass uses it.

## C7 · Writing rules

1. No em dashes, no hyphenated compounds.
2. No preamble.
3. Factual and sequential: numbers, names, times.
4. No assumptions; write "not checked" or ask.
5. No tying a specific problem to a general cause without evidence.
6. Stay on the topic asked.
7. Pin the ask down precisely. Tables over paragraphs when comparing.
8. They/them for anyone whose pronouns are not stated.

## C8 · Mistakes this system exists to prevent

When a new mistake happens, add a row here (or to the project's `CONVENTIONS.md`): what happened and
the rule that now prevents it, in blameless wording (`D9`, `D10`).

| Mistake | Rule that prevents it |
|---|---|
| A fix declared done before it was measured; the measurement disagreed | Evidence under the heading (C2) |
| A count quoted in chat matched no file; the real run differed | Quote counts from run output, into the doc |
| One claim summarised a list where one member was an exception | Name exceptions explicitly |
| Old text stayed after a new reading contradicted it | Search and replace the old claim everywhere (C5) |
| An item open in PLAN and done in the runbook | Same turn, every file; the verifier checks (C6) |
| Scripts the owner could not confirm had run | Copy and paste blocks with `want` lines (C4) |
| A step run as the wrong account failed | Every step states **As** which account |
| A change made outside the runbook, maker unknown | Record what was observed and "by whom: not recorded" |
| Scope drift inside the main phase | New work gets a phase before it is built; the verifier reports scope |
| Board percent typed by hand drifted from the marks (under 50/50: 56% shown, 60% computed; 77% shown, 92% computed) | `spine-status` after every change (C1) |
| A Status line said 1 in progress while the table had 2 | Status line updated in the same edit as the marks (C2) |
| Registry table rows lost and gained cells; the table rendered wrong | `check-docs` table check (C3) |
| Two sessions in one folder edited the same index | One owner per shared file (C10) |

## C9 · Changelog and decisions

| Rule | Source |
|---|---|
| CHANGELOG is newest first with `YYYY-MM-DD HH:MM · title` headings | v1, `D13` |
| Each entry uses only the lines that apply, in this order: **Changed**, **Verified**, **Not changed**, **Not checked**, **Found, not fixed** | House, `F10` |
| For a released artifact (a package, a skill, a template), keep a versioned section with Added, Changed, Removed, Fixed, and versions as MAJOR.MINOR.PATCH; a released entry is never edited | `D14`, `D15` |
| An owner decision is an item with the date and the owner's words quoted ("per the owner: ..."), linked from the items it governs | House, `F11` |
| A changed decision is never deleted: mark it superseded and link the new one | `D7` |
| Architecture decisions in a project that has ADRs use its format: context, decision, status, consequences, options considered | `D6`, `D8` |

## C10 · Several sessions or people in one folder

| Rule | Source |
|---|---|
| Each session owns named files or folders; it touches nothing else. Shared indexes (HOME, CHANGELOG, registries) have one owner | House, `F5` |
| A session that does not own an index leaves a hand over note (what to register, the numbers, open decisions) in a shared notes folder or its own LOG; the owner registers it | House, `F5` |
| If edits may overlap, give each session its own git worktree and merge; for docs, prefer ownership, since merging status tables by hand is error prone | `A24`, `A26` |
| After merging work from another session, run `check` before trusting any number | `F6` |

---

## More

| File | What it holds | Read when |
|---|---|---|
| [references/portfolio.md](references/portfolio.md) | Multi project layout: registry, project folders, gates G0 to G4, knowledge library, inbox | The owner runs many projects or tasks from one place; mode `project` |
| [references/templates.md](references/templates.md) | Starting text for HOME, PLAN, PROJECT, LOG, runbook, CHANGELOG entry, Status line | Creating any spine file |
| [references/automation.md](references/automation.md) | Claude Code only: hooks, a verifier subagent, scheduled checks | The owner wants the checks to run without being asked |
| [references/evals.md](references/evals.md) | Test scenarios with pass conditions for this skill | Changing this skill |
| [research.md](research.md) | Every finding with its source, and the v1 to v2.0 change table | Checking why a rule exists |
