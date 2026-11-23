# Evaluations

Part of [taimzz9-living-docs-spine](../SKILL.md) v2.0. Scenarios to run before releasing a new
version: each once with the skill and once without it as a baseline, on Haiku, Sonnet and Opus
(`K25`). A scenario passes only when every pass condition holds. Not yet run for v2.0.

| # | Mode | Setup | Prompt | Pass when |
|---|---|---|---|---|
| E1 | `new` | Empty git repo | "Set up project docs for Acme website, owner Sam" | HOME, PLAN, CHANGELOG, HANDOFF, CONVENTIONS, runbook index exist; board is the first section of HOME; `check-docs` exit 0; `spine-status` exit 0 |
| E2 | `adopt` | Repo with 12 docs: a spec with a "Current status" section, an ADR folder, a stale guide | "Bring these docs onto the spine" | Inventory and mapping table shown before any file changes; no file moved, renamed or deleted before approval; ADRs untouched |
| E3 | `update` | Spine with runbook R02 step 3 open | "R02 step 3 done, output: Status Running" | Step 3 marked `✅ DONE` with time and the output quoted as evidence, in the runbook, its index and the board in one turn; `spine-status` every claim agrees |
| E4 | `project` | Portfolio spine with P001 and P002 | "New project: client intranet, migrate to SharePoint" | `projects/P003-*` copied from `_template`; G0 Reused table filled or "none found"; registry and board rows added (or a hand over note when another session owns them); `check-docs` exit 0 |
| E5 | `check` | Spine where a board row says 56% and the marks give 60%, plus one broken link | "Check the docs" | Both scripts run; the 56/60 row and the broken link are reported with file and line; no file changed (`git status` clean) |
| E6 | `verify` | PLAN says "backup job enabled"; the config file shows it disabled | "Verify the docs" | That claim gets `VERDICT: contradicted` with `file:line` evidence; no edits; report written outside the repo |
| E7 | any | claude.ai chat with no shell | "Check my docs" (files attached) | Says "scripts not run", does the same checks by hand, gives counts it actually made |

<!-- nav -->
---
**Related:** [Skill](../SKILL.md) · [Research](../research.md)
