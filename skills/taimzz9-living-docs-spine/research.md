# taimzz9-living-docs-spine v2.0 · Research

**Status 2026-11-22:** 3 research passes by read only Sonnet subagents run in parallel (docs practice,
skill authoring, Claude Code automation), plus field evidence read from a real spine built with v1 on
2026-11-21 and used for 5 projects. 80 sourced rows over 26 distinct pages, 15 field rows. Pages went
through a summarising fetch, so wording is paraphrased, not quoted. Gaps are in §7.

Row ids are cited from [SKILL.md](SKILL.md) and the [references](references/portfolio.md).
**Evidence:** strong = official doc or primary standard; medium = well known practitioner source or a
partial read; weak = inference or opinion.

## Contents

1. Documentation practice and status tracking (D)
2. Skill authoring, CLAUDE.md and memory (K)
3. Claude Code automation (A)
4. Field evidence from a real spine (F)
5. Conflicts and how they were settled
6. v1 vs v2.0 change table
7. Not checked

## 1 · Documentation practice and status tracking

| # | Topic | Finding | URL | Evidence | Rule it implies |
|---|---|---|---|---|---|
| D1 | Diátaxis | Four forms for four needs: tutorials, how to guides, reference, explanation | https://diataxis.fr/ | strong | Do not mix types in one file; link instead |
| D2 | Diátaxis mapping | Runbooks are how to guides, conventions are reference, decisions are explanation; state docs have no Diátaxis type (researcher's inference) | https://diataxis.fr/ | weak | Diátaxis column in the adopt class table, as a guide only |
| D3 | Docs as code | Docs live in version control in plain text markup | https://www.writethedocs.org/guide/docs-as-code/ | strong | Every spine doc is Markdown in the repo |
| D4 | Docs as code | Doc changes get the same review as code | https://www.writethedocs.org/guide/docs-as-code/ | strong | Verifier pass at milestones |
| D5 | Docs as code | Automated checks run on docs (the page does not name link checking) | https://www.writethedocs.org/guide/docs-as-code/ | strong | Bundled `check-docs`; optional CI job |
| D6 | ADR | Title, context, decision, status, consequences; short; numbered; numbers never reused | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions | strong | ADR format where a project already uses ADRs |
| D7 | ADR status | Proposed, accepted, deprecated, superseded; a superseded record is kept and points to its replacement | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions | strong | Never delete a decision; mark superseded and link |
| D8 | MADR | Context and problem, considered options, decision outcome are required | https://adr.github.io/madr/ | strong | Record options considered for architecture decisions |
| D9 | Postmortem | Written record of impact, fix, root causes, follow up actions | https://sre.google/sre-book/postmortem-culture/ | strong | Every mistake becomes a row with the rule that prevents it |
| D10 | Postmortem | Blameless: fix systems, not people; an unreviewed postmortem is as good as none | https://sre.google/sre-book/postmortem-culture/ | strong | Mistakes table in blameless wording |
| D11 | Toil | Toil is manual, repetitive, automatable work with no lasting value; keep it under half of time | https://sre.google/sre-book/eliminating-toil/ | strong | Flag runbooks run often as automation candidates |
| D12 | Monitoring | Rote responses to alerts are a red flag; automate when the cause cannot be removed | https://sre.google/sre-book/monitoring-distributed-systems/ | strong | Same as D11 |
| D13 | Keep a Changelog | For humans; newest first; ISO 8601 dates | https://keepachangelog.com/en/1.1.0/ | strong | CHANGELOG newest first with `YYYY-MM-DD` |
| D14 | Keep a Changelog | Added, Changed, Deprecated, Removed, Fixed, Security, plus Unreleased at the top | https://keepachangelog.com/en/1.1.0/ | strong | Versioned section for released artifacts only |
| D15 | SemVer | MAJOR.MINOR.PATCH; a released version is never altered | https://semver.org/ | strong | Released entries are never edited |
| D16 | Percent complete | Earned value uses fixed rules such as 0/100, 50/50, 20/80; simple rules suit small projects | https://en.wikipedia.org/wiki/Earned_value_management | medium | Name the credit rule on the board |
| D17 | Percent complete | 20/80 and 25/75 weight finishing over starting | https://en.wikipedia.org/wiki/Earned_value_management | medium | Default 20/80 (owner decision 2026-11-22); weight is a script setting |
| D18 | Kanban | WIP limits cut delay and context switching; "stop starting, start finishing" | https://kanban.university/kanban-guide/ | strong | Flag more than 3 in progress per workstream |
| D19 | Kanban | Blockers are tracked; review what blocks each item | https://kanban.university/kanban-guide/ | strong | A blocked item names its unblocker |
| D20 | lychee | Checks Markdown local files and relative links; fragments only with a flag; offline mode; CI exit codes | https://github.com/lycheeverse/lychee | strong | Alternative for CI when web links matter |
| D21 | lychee | Misses anchors made by JavaScript | https://github.com/lycheeverse/lychee | strong | Anchor checks are partial evidence; warnings only |
| D22 | markdown-link-check | Documents liveness, ignore and replacement patterns; says nothing about anchors | https://github.com/tcort/markdown-link-check | strong | Not chosen |
| D23 | lychee site | Claims Markdown support, JSON output, CI use | https://lychee.cli.rs/ | medium | Cite the README for behaviour |

## 2 · Skill authoring, CLAUDE.md and memory

| # | Topic | Finding | URL | Evidence | Rule it implies |
|---|---|---|---|---|---|
| K1 | Name | Max 64 characters; lowercase letters, digits, hyphens; no `anthropic` or `claude` | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#skill-structure | strong | Name unchanged |
| K2 | Name | No leading, trailing or double hyphen; must match the folder name | https://agentskills.io/specification#name-field | strong | Zip folder = `taimzz9-living-docs-spine` |
| K3 | Description | Max 1,024 characters, no XML tags, says what and when | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#skill-structure | strong | v2.0 description stays under 1,024 |
| K4 | Description | claude.ai help article states 200 characters | https://support.claude.com/en/articles/12512198-how-to-create-custom-skills | medium | Contradicted locally by F12, see §5 |
| K5 | Description | Claude Code truncates description plus `when_to_use` at 1,536 characters in the listing | https://code.claude.com/docs/en/skills#frontmatter-reference | strong | Key trigger first |
| K6 | Voice | Third person; the description is injected into the system prompt | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#writing-effective-descriptions | strong | Third person description |
| K7 | Upload fields | Outside Claude Code only `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools` are accepted; others are an error | https://code.claude.com/docs/en/skills#frontmatter-reference | strong | Partly contradicted by F12, see §5 |
| K8 | Claude Code fields | `argument-hint`, `arguments`, `when_to_use`, `disable-model-invocation`, `context`, `hooks` and more; unknown fields ignored | https://code.claude.com/docs/en/skills#frontmatter-reference | strong | Keep `argument-hint`; add no other Claude Code only keys |
| K9 | Spec fields | `license`, `compatibility` (max 500), `metadata`, `allowed-tools` | https://agentskills.io/specification#frontmatter | strong | Add `license: MIT` |
| K10 | Arguments | `$ARGUMENTS`, `$0`; appended as `ARGUMENTS:` when no placeholder; claude.ai has no substitution | https://code.claude.com/docs/en/skills#pass-arguments-to-skills | strong | Infer the mode from the message when no argument |
| K11 | Dynamic context | `` !`cmd` `` runs before load; a non zero exit aborts the invocation | https://code.claude.com/docs/en/skills#inject-dynamic-context | strong | Not used (see automation §6) |
| K12 | Locations | Personal `~/.claude/skills/<name>/`, project `.claude/skills/`, plugin, enterprise | https://code.claude.com/docs/en/skills#where-skills-live | strong | Install table in README |
| K13 | Size | SKILL.md under 500 lines; move reference material out | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#progressive-disclosure-patterns | strong | SKILL.md plus `references/` |
| K14 | Progressive disclosure | Level 1 name and description, level 2 body, level 3 bundled files on demand | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#how-skills-work | strong | Body is navigation and rules; detail in references |
| K15 | Layout | `scripts/`, `references/`, `assets/`; relative paths from the skill root | https://agentskills.io/specification#optional-directories | strong | Same folder names |
| K16 | Depth | References one level deep from SKILL.md | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#avoid-deeply-nested-references | strong | Every reference linked from SKILL.md |
| K17 | Long files | Over 100 lines: start with a table of contents | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#structure-longer-reference-files-with-a-table-of-contents | strong | Contents list in long references |
| K18 | Scripts | Executed, not loaded; say whether to run or read | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#provide-utility-scripts | strong | "Run them; do not read them" |
| K19 | Solve, don't punt | Scripts handle errors and print specific messages | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#solve-dont-defer | strong | Exit 2 with a fix hint on bad arguments |
| K20 | Paths | Forward slashes | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#avoid-windows-style-paths | strong | Forward slashes in SKILL.md |
| K21 | Time | Avoid date dependent text | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#avoid-time-sensitive-information | strong | Only the version date in the author line |
| K22 | Runtimes | Network and installs vary by surface; state dependencies | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#runtime-environment-constraints | strong | Scripts need only bash and awk, or PowerShell 5.1; no network |
| K23 | Zip | The zip holds the skill folder as its root | https://support.claude.com/en/articles/12512198-how-to-create-custom-skills | medium | Zip command in README |
| K24 | Surfaces | claude.ai, API and Claude Code skills do not sync | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview#cross-surface-availability | strong | Install in each place |
| K25 | Evaluations | At least 3 evals, a baseline without the skill, test on Haiku, Sonnet, Opus | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#build-evaluations-first | strong | `references/evals.md` |
| K26 | Concise | Add only what Claude lacks; one default with an escape hatch | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices#concise-is-key | strong | One default command per script |
| K27 | Compaction | An invoked skill keeps its first 5,000 tokens after compaction | https://code.claude.com/docs/en/skills | medium | Modes and scripts near the top |
| K28 | CLAUDE.md | Under 200 lines; `@` imports do not reduce context | https://code.claude.com/docs/en/memory | strong | One pointer line in CLAUDE.md |
| K29 | Rules | `.claude/rules/*.md` with `paths:` scoping; HTML comments stripped | https://code.claude.com/docs/en/memory | strong | Not used; noted for projects that want scoped doc rules |
| K30 | Auto memory | Claude written; CLAUDE.md is for rules you write | https://code.claude.com/docs/en/memory | strong | Status never lives in memory |

## 3 · Claude Code automation

| # | Feature | Finding | URL | Evidence | Rule it implies |
|---|---|---|---|---|---|
| A1 | Hook events | PostToolUse, Stop, SubagentStop, SessionStart, PreCompact and others | https://code.claude.com/docs/en/hooks#hook-events | strong | Check after edits |
| A2 | Matcher | `Edit\|Write` is an exact list | https://code.claude.com/docs/en/hooks#matcher-patterns | strong | Hook matcher |
| A3 | Exit 2 on Stop | Blocks Stop with stderr as the reason | https://code.claude.com/docs/en/hooks#exit-code-2 | strong | Not used in shared folders (loop risk) |
| A4 | Exit 2 on PostToolUse | Does not block; stderr shown to Claude | https://code.claude.com/docs/en/hooks#exit-code-2-behavior-per-event | strong | Feedback hook |
| A5 | JSON output | `decision: block` with reason; `additionalContext` capped at 10,000 characters | https://code.claude.com/docs/en/hooks#json-output | strong | Keep hook output short |
| A6 | additionalContext | Replayed on resume, so timestamps go stale | https://code.claude.com/docs/en/hooks#add-context-for-claude | strong | No SessionStart injection of numbers |
| A7 | Windows | `"shell": "powershell"` available; default bash | https://code.claude.com/docs/en/hooks#command-hook-fields | strong | PowerShell twin of every script |
| A8 | Skill hooks | Frontmatter hooks run only after invocation and go on `/clear` | https://code.claude.com/docs/en/hooks#hooks-in-skills-and-agents | strong | Always on hooks belong in project settings |
| A9 | Frontmatter | `disable-model-invocation`, `context: fork` | https://code.claude.com/docs/en/skills#frontmatter-reference | strong | Not used: keeps claude.ai compatibility |
| A10 | Arguments | `$ARGUMENTS`, `$0` | https://code.claude.com/docs/en/skills#pass-arguments-to-skills | strong | Same as K10 |
| A11 | Skill folder | `${CLAUDE_SKILL_DIR}` expands in the body | https://code.claude.com/docs/en/skills#available-string-substitutions | strong | Script location line |
| A12 | allowed-tools | Pre approves tools for the turn; does not restrict | https://code.claude.com/docs/en/skills#pre-approve-tools-for-a-skill | strong | Not used |
| A13 | Injection | `` !`cmd` `` must exit 0 | https://code.claude.com/docs/en/skills#inject-dynamic-context | strong | Not used |
| A14 | Read only agent | `tools: Read, Grep, Glob` keeps a subagent read only | https://code.claude.com/docs/en/sub-agents#restrict-which-tools-a-subagent-can-use | strong | Verifier agent without Bash; caller pastes script output |
| A15 | Agent scope | `.claude/agents/` shared with the project | https://code.claude.com/docs/en/sub-agents#choose-the-subagent-scope | strong | Verifier file location |
| A16 | When to use | Subagents for verbose or self contained work; main chat for iteration | https://code.claude.com/docs/en/sub-agents#choose-between-subagents-and-main-conversation | strong | Verify in a fresh context |
| A17 | Scheduling | Desktop (local files), cloud (fresh clone), `/loop` (open session) | https://code.claude.com/docs/en/scheduled-tasks#compare-scheduling-options | strong | Weekly local check as a Desktop task |
| A18 | loop.md | `/loop` cannot run skills with `disable-model-invocation` | https://code.claude.com/docs/en/scheduled-tasks#customize-the-default-prompt-with-loop-md | strong | Keep the skill model invocable |
| A19 | CI | GitHub Actions with a schedule for unattended runs | https://code.claude.com/docs/en/scheduled-tasks#limitations | medium | CI job with the bash scripts |
| A20 | Status line | Runs a script that prints text | https://code.claude.com/docs/en/statusline | medium | Idea only |
| A21 | Settings | `.claude/settings.json` shared; `.local` personal | https://code.claude.com/docs/en/settings#share-settings-with-your-team | strong | Hooks in project settings |
| A22 | Trust | Some project settings apply only after folder trust | https://code.claude.com/docs/en/hooks#hooks-in-skills-and-agents | strong | Do not rely on hooks in headless runs |
| A23 | Hot reload | Hook edits apply without restart | https://code.claude.com/docs/en/settings#when-edits-take-effect | strong | Noted |
| A24 | Worktrees | `claude --worktree <name>` isolates a session | https://code.claude.com/docs/en/worktrees#start-claude-in-a-worktree | strong | Option when edits overlap |
| A25 | Worktree paths | `$CLAUDE_PROJECT_DIR` stays at the original root | https://code.claude.com/docs/en/worktrees#ask-claude-to-create-a-worktree | strong | Hook limitation noted |
| A26 | Shared folder | No guidance on several sessions editing one folder | https://code.claude.com/docs/en/worktrees | medium | Ownership stays a House rule |
| A27 | Parallel options | Messaging between sessions, agent teams, subagents | https://code.claude.com/docs/en/worktrees#see-also | medium | Hand over notes |

## 4 · Field evidence from a real spine

A spine built with v1 on 2026-11-21 and used for 5 projects by several Claude sessions sharing one
folder. Script output is from 2026-11-22 with the v2.0 scripts.

| # | What was seen | Where | What it implies |
|---|---|---|---|
| F1 | A projects registry, a `_template` folder and a "start a new project" runbook were invented on top of v1 | registry `projects/README.md`, runbook R03 | Portfolio layout and mode `project` |
| F2 | A knowledge library with entry types, maturity (draft, proven, standard) and project gates G0 reuse to G4 extraction | `CONVENTIONS.md` §2, §4, §5 | Gates and entries in `references/portfolio.md` |
| F3 | An `inbox/` for raw harvests from other environments, ingested by a runbook | `CONVENTIONS.md` §6 | Inbox section |
| F4 | Skill registry rows and listings show the version first ("v2.1 ·") because the listing shows only name and description | CHANGELOG 2026-11-22 00:15, runbook R04 | Version first in this description |
| F5 | Sessions shared one folder; each owned named folders; one session owned HOME, CHANGELOG and registries; others left hand over notes | P004 brief, shared notes folder | C10 |
| F6 | Board percent drifted from the marks: one row 56% shown, 60% computed; another 77% shown, 92% computed. Two rows agreed | `spine-status` on the real spine | Recompute after every change; `spine-status` |
| F7 | Status lines drifted: 2 project Status lines disagree with their tables; PLAN and HANDOFF Status lines date from the first day while later work changed their items | `spine-status`; PLAN item 2.1 open while its file exists; HANDOFF lists a decision already made | Fixed Status line format; C5 stale text rule |
| F8 | The registry table had one row with 6 cells and one with 12 under a 9 cell header | `check-docs`: `projects/README.md` lines 10 and 13 | Table check |
| F9 | Link counts were reported by hand each time (337, 31) with no shared script | CHANGELOG 2026-11-22 01:25, a project LOG | `check-docs`: 65 files, 362 relative links, 0 broken |
| F10 | CHANGELOG entries settled on Changed, Verified, Not changed, Not checked, Found not fixed, Corrected | CHANGELOG | C9 line order |
| F11 | Owner decisions were recorded as items with the owner's words quoted | a project's items 8 and 8b | C9 decision rule |
| F12 | Skills synced from a claude.ai account include the owner's own skill with a 761 character description (synced 2026-11-22) and v1 of this skill with `argument-hint` (synced 2026-11-15); bundled vendor skills carry `license` and `compatibility` | synced skills folder of the desktop app | §5 |
| F13 | The registry gives the public download as `biwize.ca/skills/`, v1 gives `biwize.ca/aics/`. Checked 2026-11-22: `biwize.ca/aics/` is the AI Cheat Sheet page (account gate), whose "Download the skill" link points to `biwize.ca/skills/taimzz9-living-docs-spine.zip` (zip URL not fetched); `biwize.ca/skills/` itself returns 404 | skills registry vs v1 SKILL.md; web fetch | The skill names the AI Cheat Sheet page and GitHub, not a zip URL (owner: "/aics/ is for AI Cheat sheet") |
| F14 | v1 LICENSE spells the author "Taim Albakri"; the author's other skills use "Taim Al-Bakri" | v1 LICENSE | v2.0 uses "Taim Al-Bakri" |
| F15 | A 9 row status table was the most edited thing in the repo; every edit risked drift | CHANGELOG entries 2026-11-21 22:10 to 2026-11-22 01:25 | Scripts over discipline for numbers |

## 5 · Conflicts and how they were settled

| Conflict | Settled as | Why |
|---|---|---|
| K4 says the claude.ai description limit is 200 characters; K3 says 1,024 | Kept 724 characters | F12: a 761 character description uploaded by the same owner syncs; K3 is the API spec. Owner checks the listing after upload |
| K7 says `argument-hint` is an error outside Claude Code | Kept `argument-hint`, as the brief asked | F12: v1 with `argument-hint` was uploaded and syncs. If an upload is refused, remove that line from the zip copy only |
| D17 suggests 20/80 over 50/50 | 20/80 is the default; `--weight` keeps 50/50 available | Owner decision 2026-11-22: "switch to 80/20" |
| A3 blocking Stop hook vs shared folders | PostToolUse feedback only | A blocking hook loops on drift in files the session does not own (F5) |

## 6 · v1 vs v2.0 change table

| # | Area | v1 | v2.0 | Why |
|---|---|---|---|---|
| 1 | Description | No version, no scripts, single project | `v2.0 ·` first, third person, scripts, multi project, 6 modes | F4, K3, K6 |
| 2 | Frontmatter | `name`, `description`, `argument-hint` | Adds `license: MIT`; `argument-hint` gains `project`, `check` | K9, F12 |
| 3 | Modes | new, adopt, update, verify | Adds `project` (start or close one project) and `check` (scripts only, no edits) | F1, F2, F6 to F9 |
| 4 | Percent | Computed by hand from marks | Recomputed by `spine-status`; board and Status lines compared, 0 DIFFERS before the turn ends | F6, F7 |
| 5 | Link check | "Report the broken count; it must be 0" | `check-docs`: links, reference definitions, anchors, table shape; counts quoted from output | F8, F9, D5 |
| 6 | Percent rule | Unnamed half credit (50/50) | 20/80 earned value rule, named on the board; weight is a script setting | D16, D17, owner decision |
| 7 | Status line | Free text | Fixed `N done, N in progress, of N` format, updated in the same edit as the marks | F7 |
| 8 | Blocked items | Mark only | Board names who or what unblocks | D19 |
| 9 | Work in progress | Not covered | More than 3 in progress per workstream flagged | D18, House threshold |
| 10 | Runbooks | Copy and paste format | Same, plus an automation candidate line after 3 manual runs | D11, D12 |
| 11 | Changelog | Newest first | Plus line order and a versioned section for released artifacts | D13 to D15, F10 |
| 12 | Decisions | Decision class left untouched | New C9: owner words quoted, superseded kept and linked, ADR format where used | D6 to D8, F11 |
| 13 | Several sessions | Not covered | New C10: file ownership, hand over notes, worktrees when edits overlap | F5, A24, A26 |
| 14 | Verifier | Read only format | Same format; runs `check` first; fresh context read only subagent in Claude Code | A14, A16 |
| 15 | Adopt classes | 6 classes | Same, plus a Diátaxis column | D1, D2 |
| 16 | Mistakes table | 9 rows | 13 rows; add new rows in blameless wording | D9, D10, F5 to F8 |
| 17 | CLAUDE.md | Not covered | One pointer line; status never in memory | K28, K30 |
| 18 | Structure | One file | SKILL.md plus 4 references one level deep, contents lists in long files | K13, K14, K16, K17 |
| 19 | Code | "There is no code" | 4 read only scripts (bash and PowerShell 5.1 twins), run not read, no network, exit codes 0, 1, 2 | K18, K19, K22, A7 |
| 20 | Evaluations | None | 7 scenarios with pass conditions | K25 |
| 21 | Automation | None | Optional PostToolUse hook with its wrapper script (tested), verifier agent, scheduled and CI checks, Claude Code only | A2, A4, A15, A17, A21 |
| 22 | Author | "Taim Albakri" | "Taim Al-Bakri", version and date in the author line | F14, brief |
| 23 | Kept | Part 1 and Part 2 flow, status marks and ordering, timestamps, evidence, nav footer, runbook step format, update discipline, verifier answer format, writing rules | Unchanged in substance | v1 worked (F1 to F15 show additions, not failures) |

## 7 · Not checked

- RAG status pitfalls and a PMI source for the 20/80 and 50/50 rules: only Wikipedia was read (D16, D17).
- Stale doc practice (last reviewed dates, doc ownership, g3doc): no source fetched; the GitLab handbook page returned only navigation.
- Diátaxis detail pages; D2 is the researcher's inference.
- Hooks page beyond its first 100,000 characters (per event input JSON, SessionStart output); status line input fields; headless and GitHub Actions pages.
- The claude.ai help article was read through a summarising fetch; the 200 character claim was not checked in a browser.
- The verifier agent, scheduled task and CI snippets in [references/automation.md](references/automation.md) were not run. The PostToolUse hook was tested in the author's repo on 2026-11-22.
- The evaluations in [references/evals.md](references/evals.md) were not run.
- `check-docs` anchor slugs in bash for non ASCII headings depend on the awk locale.
- The scripts were run on Windows 11 (PowerShell 5.1 and Git Bash with GNU awk 5.4); macOS and Linux not run.

<!-- nav -->
---
**Related:** [Skill](SKILL.md) · [README](README.md) · [Portfolio](references/portfolio.md) · [Automation](references/automation.md)
