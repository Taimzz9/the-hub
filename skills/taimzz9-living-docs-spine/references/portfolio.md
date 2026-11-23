# Portfolio layout: many projects from one spine

Part of [taimzz9-living-docs-spine](../SKILL.md) v2.0. Use it when one owner runs many projects or
tasks from one repo and wants each to start from what earlier ones learned. Every rule here is House
unless a source id is given; the field evidence (`F1` to `F5`) is in [research.md](../research.md).

## Contents

1. Layout
2. Project IDs and folders
3. Gates G0 to G4
4. Registry and board
5. Knowledge entries
6. Inbox
7. Mode `project`: start and close

## 1 · Layout

```
HOME.md              status board: one row per open project, plus system workstreams
PLAN.md              portfolio phases; says which project serves which phase
CONVENTIONS.md       this layout, the gates, the entry format, what never goes in the repo
CHANGELOG.md · HANDOFF.md
projects/README.md   registry: one row per project, open on top, closed at the bottom
projects/_template/  PROJECT.md + LOG.md, copied to start a project
projects/Pnnn-slug/  PROJECT.md (brief, reused, items, evidence, lessons) + LOG.md (newest first)
knowledge/           reusable entries by type, each folder with a README index
inbox/               raw material from other machines or sessions, waiting to be ingested
docs/runbooks/       R01... including "start a new project" and "ingest a harvest"
```

`spine-status` tracks `PLAN.md`, every `projects/*/PROJECT.md` except folders starting with `_`, and
`docs/runbooks/R<n>*.md` by default, so this layout is checked with no options. (`F1`)

## 2 · Project IDs and folders

| Rule | Why |
|---|---|
| ID `P` + three digits, never reused: `P001`, `P002` | Links and logs stay valid forever |
| Folder `projects/Pnnn-short-slug/`, copied from `_template/` | Same shape everywhere, so scripts and people find things |
| The registry and the HOME board gain the row in the same turn the folder is created | C5, `F6` |
| A project with its own session, agent or person still gets its row from the index owner | C10, `F5` |

## 3 · Gates G0 to G4

Items in every `PROJECT.md`, with status marks, so they count toward percent.

| Gate | What happens | Done when |
|---|---|---|
| **G0 Reuse search** | Search `knowledge/` for matching entries; list what applies in a "Reused" table | Table filled, even if "none found" |
| **G1 Brief** | Goal, scope, out of scope, estimate in hours | Owner confirmed the brief |
| **G2 Build** | Work items with status marks (C2) | All build items done |
| **G3 Handover** | Deliverables, accounts and docs handed over | Handover list checked |
| **G4 Extraction** | Write or update knowledge entries from what was learned; record actual hours against the estimate and hours saved by reuse | At least one entry written or updated, or "nothing reusable" with a reason |

A project is not done until G4 is done. (`F2`)

## 4 · Registry and board

| Rule | Source |
|---|---|
| Registry columns: ID, Project, Type, Client, Status, Done, Started, Closed, Knowledge produced | `F1` |
| The registry Done cell repeats the board; recompute both from `spine-status` in the same turn, or make the registry link to the board instead of repeating the number | `F6`, C1 |
| Board **Where** links `PROJECT.md` first, so `spine-status` compares the right file | `F6` |
| A closed project moves to the bottom of the registry and off the board, into a Done section | C2 |
| Run `check-docs` after editing the registry: a row with a missing or extra cell breaks the table | `F8` |

## 5 · Knowledge entries

One file per entry, in a folder per type, each with a header block:

```
---
id: KB-PB-001            # KB-<type code>-<nnn>
title: ...
type: playbook           # playbook, standard, skill, pattern, case, company, reference
maturity: draft          # draft (seen once), proven (used in 2+ projects), standard (owner approved)
applies_to: [...]
source_projects: [P003]
effort_reference: "not measured"
last_verified: YYYY-MM-DD
---
```

Sections in order: When to use · Steps or content · Pitfalls · Assets · Evidence.

| Rule | Source |
|---|---|
| Only the owner promotes an entry to `standard`; the CHANGELOG records it | `F2` |
| When a project contradicts an entry, update the entry the same turn and note it under Evidence; never keep two versions | C5 |
| An entry that describes a released artifact (a skill, a template) shows its version where people see it first, for example at the start of a listing description | `F4` |
| A digest of an outside source is paraphrased, credited, and notes its licence | `F2` |
| `last_verified` is the freshness signal; `verify` lists entries not verified since their source project closed | House |

## 6 · Inbox

- Raw material lands in `inbox/` as `harvest-<source>-<YYYY-MM-DD>.md`. (`F3`)
- An ingest runbook turns it into knowledge entries, then moves the file to `inbox/processed/`. Never
  deleted.

## 7 · Mode `project`: start and close

**Start** (the owner says "new project: name, one line goal"):

1. Next free ID from the registry.
2. Copy `projects/_template/` to `projects/Pnnn-slug/`; fill the header table and a brief draft.
3. G0: search `knowledge/` for the project's keywords; fill the Reused table; tell the owner what applies.
4. Owner confirms the brief (G1).
5. Registry row and HOME row (or a hand over note to the index owner, C10), CHANGELOG entry, `check`, commit.

**Close:** G3 and G4 items done; actual against estimate recorded; Status line reads all done;
project row moves under Done in the registry and off the board; `check`; CHANGELOG; commit.

<!-- nav -->
---
**Related:** [Skill](../SKILL.md) · [Templates](templates.md) · [Automation](automation.md) · [Research](../research.md)
