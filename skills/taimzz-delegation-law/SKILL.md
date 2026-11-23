---
name: taimzz-delegation-law
description: v2.1 · Taim Al-Bakri's (Taimzz9) rule for planning and delegating multi step coding or research work in Claude Code so it is fast, cheap and accurate. Plans the breakdown first, sends each subtask to the most appropriate model and effort for that task type (Haiku for file finding and log digests, Sonnet for research and precisely described edits, Opus for features, bugs, refactors and reviews, Fable for architecture, root cause and outage debugging), runs independent work in parallel on disjoint files, gives every subtask one pass or fail check, and reads subagent reports instead of reopening files. Applies whenever a task spans more than one file, needs research before an edit, a test run or a review, or is a bug fix, refactor or audit, even when subagents or this skill are not named.
license: MIT
---

# Taimzz delegation law

**Author:** Taim Al-Bakri (Taimzz9) · Version 2.1, 2026-11-21

Goal: finish fast, spend as little as possible, get it right the first time. The main thread plans, briefs, dispatches, decides and merges. Subagents do the reading, the noisy runs and the parallel work. Every agent run, test run, CI run and review costs money, so nothing is done twice.

**Source column:** a link is Anthropic documentation; **House** is the owner's rule, not documented guidance. Row ids like `S29` point to [research.md](research.md).

## 1 · Delegate or not

| Situation | Do | Source |
|---|---|---|
| One file fix, one command, answer already in context, tight back and forth | Main thread, no subagent | [best practices][bp-sub] |
| Independent parts that can run at the same time | Subagents, one wave | [best practices][bp-sub] |
| Verbose output: test runs, logs, docs fetches, wide search | Cheap subagent that returns a summary | [costs][c-verbose] |
| Review of a risky change | Fresh context reviewer, once | [best practices][bp-review] |
| Wanting a "smarter answer" or to "protect context" | Not a reason: a subagent does not answer better, and 1M windows rarely run out | [best practices][bp-sub] |
| Brief would need a long dump of this conversation | Fork (`/subtask`): inherits the context and shares the parent cache | [subagents][sa-fork], [caching][pc-sub] |
| Same mechanical change in 5 to 30 places | `/batch <change>`: one worktree and PR per unit, after approval | [best practices][bp-par] |
| Fan out of 25+ agents (audit, migration) | Workflow, only when the owner says "use a workflow" | [workflows][wf], [cost][wf-cost] |
| Workers must debate (competing hypotheses, multi angle review) | Agent team, off by default; ask first | [agent teams][teams], [costs][c-teams] |
| Intent unclear | Interview, write `SPEC.md`, build from it | [best practices][bp-spec] |
| Destructive, auth, payments, data migration, production config | Ask the owner before dispatch | House |

## 2 · Workflow

1. **Plan.** Multi file or exploration heavy work starts in plan mode ([plan mode][pm]; it prevents "expensive re-work", [costs][c-plan]). Write one table: subtask, done check, agent, model, effort, files owned, wave. Keep it in the plan or the project log so it survives compaction ([context window][cw]).
2. **Size it.** Lookup: 1 agent, 3 to 10 tool calls. Comparison: 2 to 4 agents. 10+ only for broad research ([multi-agent research][mars], `S30`). Waves of 3 to 5 ([mars][mars], [team size][teams-size]); never near the default cap of 20 ([subagents][sa-bg]).
3. **Batch.** Small related fixes become one subtask and one PR. House
4. **Dispatch.** A whole wave goes out in one message so it runs in parallel ([mars][mars]). Agents run in the background; wait for the completion notification, never poll ([subagents][sa-bg]). Two writers never share a file ([team size][teams-size]); when they must share a repo area, use `isolation: worktree` ([worktrees][wt]). Security, money and migration work runs alone. House
5. **Decide** from the report: done, rebrief, or escalate (§3). Follow ups go to the same agent with `SendMessage`, not a new agent ([subagents][sa-resume]), ideally within 5 minutes while its cache is warm ([caching][pc-ttl]).
6. **Merge** one PR at a time; sync with the base branch once, right before merging. House
7. **Close** from the reports: outcome, files, checks, open items. Run `/usage` after a heavy task to see which agent cost most ([costs][c-usage]). `/clear` before an unrelated task ([best practices][bp-cost]).

## 3 · Model routing

Ladder: Haiku, Sonnet, Opus, Fable. Anthropic's start point for coding is Opus 5.5; move down for smaller scope, up for the most open ended work ([choosing][choose], [Fable 5.2 launch][fable-launch]). Pass `model` and `effort` in every dispatch; the row decides both.

| Work | Agent | Model | Effort | Source |
|---|---|---|---|---|
| Find files, grep, list structure, check links, digest test or log output, mechanical extraction | `Explore` (Haiku override) | `haiku` | low | [costs][c-model], [best practices][bp-sub], [Haiku 5.5 launch][haiku-launch] |
| Research that needs judgment, docs and web reading, summaries, comparisons | `lookup_sonnet` | `sonnet` | low | [choosing][choose], [costs][c-model] |
| Rename, mechanical or precisely described edit, docs and prose edits | `implementer_opus` with `model: "sonnet"` | `sonnet` | medium | [costs][c-model] ("Sonnet handles most coding tasks well"), [effort by task][mc-effort-task] |
| New feature with a clear scope | `implementer_opus` | `opus` | medium | [choosing][choose], [effort by task][mc-effort-task]; Sonnet at high costs half and solves about 5 fewer in 100 ([cost per task][opt-task], `Q7`) |
| Bug in existing code, flaky test | `implementer_opus` | `opus` | high | [effort by task][mc-effort-task], [best practices][bp-model] |
| Large refactor or migration | `implementer_opus`, one subtask per area | `opus` | medium, high for the hard area | [choosing][choose], [prompting Opus 5.5][opus-prompt] |
| Review: fresh context, diff against the spec | `reviewer_opus` | `opus` | high | [best practices][bp-review], [prompting Opus 5.5][opus-prompt] (stronger review, fewer false alarms) |
| Review of security, auth, money, migrations, concurrency, data loss | `reviewer_opus` with `model: "fable"` | `fable` | high | House |
| Architecture decision, root cause investigation, outage debugging, a bug Opus at high could not fix | `architect_fable` | `fable` | high | [Fable in Claude Code][mc-workfable], [effort][effort-page] |

- **Haiku never writes code.** As a coding subagent it cut cost per attempt 32% but solved about 4 fewer tasks in 100; try a lower effort Sonnet or Opus first ([cost per task][opt-orch], `Q10`).
- **Sonnet writing code runs at medium or high**, never low (it may report done without a real check) or max (it made out of scope edits) ([Sonnet 5.5 launch][sonnet-launch], `Q6`).
- **Fable runs at high.** Most of its gain is present at high; xhigh only where a gain was measured; max only to measure the ceiling ([effort][effort-page]). Opus at xhigh rarely pays: 96.7% for $0.74 per solved task vs 95.3% for $0.29 at high ([cost per task][opt-task]).
- **Set effort explicitly.** Defaults differ: Claude Code uses medium for all four models, the API uses high for Sonnet and Fable ([model config][mc-effort], [choosing][choose-crit]).
- **Unsure** between Sonnet and Opus for code: Opus. Never Fable "to be safe": it costs 2x Opus and may bill to usage credits ([model config][mc-fable]). House, from v1, matching Anthropic's default ([choosing][choose])
- **Escalate in this order:** first failure, rebrief tighter (after two failed corrections, start clean with a better prompt, [best practices][bp-steer]); second failure, the same model one effort level up, since "tuning effort is often a better lever than switching models" ([choosing][choose-crit]); third failure or "cannot decide", one tier up.
- **With tests, start cheaper and rerun only the failures one level up.** Low first, failures at high: about 97% solved at $0.17 per task, vs 95.3% at $0.29 with everything at high. Needs a reliable red or green signal ([rerun failures][opt-rerun]).
- **Judge cost per completed task**, retries included: "the bill is decided by the tasks the cheaper model fails" ([cost per task][opt-upgrade]).
- **Lead plus cheaper workers only for parallel work larger than one context window.** Opus lead with Sonnet workers matched Opus alone at about a third less cost there; for one dependent chain, one model at lower effort did better ([orchestrator][opt-orch]). Tune one model before pairing models ([combine][opt-combine]).

**Main thread choice** (made once, at session start):

| Session | Main model | Source |
|---|---|---|
| Default, mixed work | `opus` | [choosing][choose] |
| Plan heavy, then a long build | `opusplan`: Opus plans, Sonnet implements | [opusplan][opusplan] |
| Long routine serial work with a few hard decisions | `sonnet` plus `/advisor opus` (consults Opus at key moments; toggling keeps the cache) | [advisor][advisor] |
| Open ended, hours long unattended work | `fable` at high | [choosing][choose], [Fable 5.2 launch][fable-launch] |

No advisor on an Opus main thread: a Fable advisor added 1.7 points at about 2.1x cost ([advisor pattern][opt-advisor]).
- **Pin `model` in every agent file.** Omitted means it inherits the main model, so a cheap job runs on Opus or Fable ([subagents][sa-model]). Never set `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`: it overrides every definition ([subagents][sa-force]).
- **Main model is chosen at session start.** No `/model`, fast mode or tool set change mid task: each rereads the history uncached ([caching][pc-switch], [fast mode][fast]). Tiers live in subagents, not in the main thread.
- **Aliases, not ids.** On Bedrock, Foundry or Claude Platform on AWS the aliases resolve to older models; pin `ANTHROPIC_DEFAULT_*_MODEL` there ([model config][mc-alias]).
- **Thinking cannot be turned off** on current models and bills as output: lower effort instead ([costs][c-think]).

Checked 2026-11-21 ([model config][mc-alias], [pricing][pricing]); aliases move, so recheck when Claude Code updates:

| Alias | Resolves to | Input / output per 1M tokens | Output cost vs Haiku |
|---|---|---|---|
| `haiku` | `claude-haiku-5-5` | $0.10 / $0.50 (over 100K prompt: $0.50 / $2.50) | 1x |
| `sonnet` | `claude-sonnet-5-5` | $2 / $10 | 20x |
| `opus` | `claude-opus-5-5` (default model) | $4 / $20 | 40x |
| `fable` | `claude-fable-5-2` (Claude Code v2.1.321+) | $8 / $40 | 80x |

## 4 · Do it once

| Rule | Source |
|---|---|
| Every subtask carries a check that comes back pass or fail (test, build exit code, linter, diff); the report gives the command and its result | [best practices][bp-check] |
| One full test run per change, by the implementer, at the end. Targeted tests while working | House |
| Reviewers never rerun the full suite: typecheck, lint, the tests for the code under review, any test they add | House |
| Reviews compare the diff to the spec, report gaps that affect correctness, skip style, run once ("a reviewer asked to find problems always finds something") | [best practices][bp-review] |
| Reviews only where they change the outcome: security, auth, money, migrations, concurrency, data loss. Everything else is verified by build and tests | House |
| `/verify` once at the end for changes with a runtime surface | [best practices][bp-check] |
| CI once per PR. Docs only changes run docs and format checks only | House |
| Push a branch once, when ready. Sync with the base once, before merge | House |
| No polling for what a notification reports | [subagents][sa-bg] |
| No re-verifying what a tool already confirmed | House |
| No duplicate work: the main thread never redoes a subagent's task; two agents never cover the same ground. Vague briefs are the documented cause | [mars][mars] (`S29`) |
| Reports over files: open a file only when a report is unclear, two reports conflict, or a seam between two agents needs checking; read only the lines named | House |

## 5 · Briefing a subagent

A subagent starts with its own prompt, the brief, CLAUDE.md and a git status snapshot, and none of this conversation ([subagents][sa-start]). The brief is complete on its own:

| Field | Content | Source |
|---|---|---|
| Objective | One sentence: what done looks like | [mars][mars], [best practices][bp-prompt] |
| Files | Files it owns; files it must not touch | House |
| Inputs | Paths and line ranges from earlier reports, never file contents | [context engineering][ce] |
| Check | The command to run once and its pass condition | [best practices][bp-check] |
| Tools and sources | Where to look and with what | [mars][mars] |
| Boundaries | Scope; on a scope change, stop and report blocked | [mars][mars] |
| Report | The format in §6 | [context engineering][ce] |

- Standing rules live in CLAUDE.md; point to it, do not repeat it ([memory][mem]). The built-in Explore and Plan agents start without CLAUDE.md, so put needed rules in their brief ([subagents][sa-builtin]).
- Plain words. No IMPORTANT, no capitals, no "think hard": set `effort` instead ([best practices][bp-stopdoing]).
- Fable briefs say who owns the code and what is out of scope. Without it Fable piles onto existing structure; with "you own the codebase" it consolidates but writes 70 to 80% more and makes unrequested changes. Check the diff, not its summary ([prompting Fable 5.2][fable-prompt]).
- Long unattended runs on Opus or Fable get an instruction to finish the whole task before ending the turn; both can stop early ([prompting Opus 5.5][opus-prompt], [prompting Fable 5.2][fable-prompt]).

## 6 · Report format

Every subagent ends with this and nothing after it:

```
Task: one line
Result: done / partial / blocked
Changed: one line per file, or "none"
Verified: command run once and its outcome, or "none"
Open: risks, questions, follow ups, or "none"
```

Cap 15 lines (House). Documented guidance is a condensed summary of about 1,000 to 2,000 tokens at most ([context engineering][ce]). No diffs, no file contents, no narration.

## 7 · Make it deterministic

A rule the model keeps missing belongs in a hook or a permission rule, not in more prose ([best practices][bp-det], [hooks guide][hooks]).

| Need | Mechanism | Source |
|---|---|---|
| Test output floods context | `PreToolUse` hook on Bash that pipes test commands through `2>&1 \| tail -n 100` | [costs][c-hooks] |
| Subagent stops without evidence | `SubagentStop` hook; exit 2 keeps it working (exit 1 does not block) | [hooks][hooks-ref] |
| Unattended or scripted fan out | `claude --bare -p "..." --allowedTools "..." --permission-mode dontAsk --max-turns N --max-budget-usd X`; pilot on 3 files first | [best practices][bp-unatt], [headless][headless] |
| Hard deny (for example `git push` from workers) | Permission deny rule or the agent's `tools` list, not `permissionMode` (ignored in auto mode) | [hooks guide][hooks], [permission modes][pm] |
| Idle spend | Stop `/loop` and `/goal` when the work is done | [costs][c-bg] |

## 8 · Context and cost hygiene

| Rule | Source |
|---|---|
| `/clear` between unrelated tasks; `/compact <focus>` at a natural break while the cache is warm | [best practices][bp-cost], [caching][pc-compact] |
| `/context` to find what fills the window before changing anything | [context window][cw-check] |
| Long task state lives in a file (plan, LOG), not in chat | [context engineering][ce], [context window][cw] |
| Prefer CLIs (`gh`) over MCP; disable idle MCP servers with `/mcp` | [costs][c-mcp] |
| CLAUDE.md under 200 lines; workflow rules go in skills, which load only when used | [memory][mem], [costs][c-skills] |

## 9 · Without subagents

In claude.ai chat or anywhere agents cannot be spawned, keep the discipline: a gathering pass first, then one scoped implementation pass, then a slower careful pass only for the risky part. Say which phase is running. House

## 10 · Install

| Where | Step | Source |
|---|---|---|
| Claude Code, all projects | Copy this folder to `~/.claude/skills/taimzz-delegation-law/` and `agents/*.md` to `~/.claude/agents/`; picked up within seconds | [subagents][sa-scope], [skills][skills] |
| One project only | Copy `agents/*.md` to `.claude/agents/` in that repo | [subagents][sa-scope] |
| `agents/Explore.md` | Replaces the built-in Explore (Opus on a subscription) with Haiku in every project. Leave it out to keep the built-in | [subagents][sa-force] |
| claude.ai | Upload the zip; the frontmatter uses only `name` and `description`, which upload accepts. The `agents/` files do nothing there | [skills][skills] |
| `fable` rejected | Claude Code older than v2.1.321 or no access: use `opus` with effort `high` | [model config][mc-fable] |

Evidence for every row: [research.md](research.md).

[bp-prompt]: https://code.claude.com/docs/en/best-practices#write-a-specific-prompt
[bp-spec]: https://code.claude.com/docs/en/best-practices#brainstorm-with-claude-first
[bp-check]: https://code.claude.com/docs/en/best-practices#give-claude-a-check-to-run
[bp-review]: https://code.claude.com/docs/en/best-practices#review-against-your-spec
[bp-det]: https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions
[bp-steer]: https://code.claude.com/docs/en/best-practices#steer-the-session
[bp-sub]: https://code.claude.com/docs/en/best-practices#know-what-subagents-cost
[bp-par]: https://code.claude.com/docs/en/best-practices#run-sessions-in-parallel
[bp-unatt]: https://code.claude.com/docs/en/best-practices#let-claude-run-without-you
[bp-cost]: https://code.claude.com/docs/en/best-practices#keep-cost-and-context-down
[bp-stopdoing]: https://code.claude.com/docs/en/best-practices#what-you-can-stop-doing
[sa-model]: https://code.claude.com/docs/en/sub-agents#choose-a-model
[sa-force]: https://code.claude.com/docs/en/sub-agents#run-every-subagent-on-one-model
[sa-start]: https://code.claude.com/docs/en/sub-agents#what-loads-at-startup
[sa-builtin]: https://code.claude.com/docs/en/sub-agents#built-in-subagents
[sa-resume]: https://code.claude.com/docs/en/sub-agents#resume-subagents
[sa-bg]: https://code.claude.com/docs/en/sub-agents#run-subagents-in-foreground-or-background
[sa-fork]: https://code.claude.com/docs/en/sub-agents#fork-the-current-conversation
[sa-scope]: https://code.claude.com/docs/en/sub-agents#choose-the-subagent-scope
[mc-alias]: https://code.claude.com/docs/en/model-config#model-aliases
[mc-fable]: https://code.claude.com/docs/en/model-config#fable-models
[c-model]: https://code.claude.com/docs/en/costs#choose-the-right-model
[c-verbose]: https://code.claude.com/docs/en/costs#delegate-verbose-operations-to-subagents
[c-teams]: https://code.claude.com/docs/en/costs#agent-team-token-costs
[c-plan]: https://code.claude.com/docs/en/costs#work-efficiently-on-complex-tasks
[c-usage]: https://code.claude.com/docs/en/costs#using-the-usage-command
[c-think]: https://code.claude.com/docs/en/costs#adjust-extended-thinking
[c-hooks]: https://code.claude.com/docs/en/costs#offload-processing-to-hooks-and-skills
[c-bg]: https://code.claude.com/docs/en/costs#background-token-usage
[c-mcp]: https://code.claude.com/docs/en/costs#reduce-mcp-server-overhead
[c-skills]: https://code.claude.com/docs/en/costs#move-instructions-from-claudemd-to-skills
[pc-switch]: https://code.claude.com/docs/en/prompt-caching#switching-models
[pc-sub]: https://code.claude.com/docs/en/prompt-caching#subagents-and-the-cache
[pc-ttl]: https://code.claude.com/docs/en/prompt-caching#which-ttl-each-request-gets
[pc-compact]: https://code.claude.com/docs/en/prompt-caching#compacting-the-conversation
[fast]: https://code.claude.com/docs/en/fast-mode
[pm]: https://code.claude.com/docs/en/permission-modes
[cw]: https://code.claude.com/docs/en/context-window#what-survives-compaction
[cw-check]: https://code.claude.com/docs/en/context-window#check-your-own-session
[mem]: https://code.claude.com/docs/en/memory
[teams]: https://code.claude.com/docs/en/agent-teams#compare-with-subagents
[teams-size]: https://code.claude.com/docs/en/agent-teams#choose-an-appropriate-team-size
[wf]: https://code.claude.com/docs/en/workflows
[wf-cost]: https://code.claude.com/docs/en/workflows#cost
[wt]: https://code.claude.com/docs/en/worktrees#isolate-subagents-with-worktrees
[hooks]: https://code.claude.com/docs/en/hooks-guide
[hooks-ref]: https://code.claude.com/docs/en/hooks
[headless]: https://code.claude.com/docs/en/headless
[skills]: https://code.claude.com/docs/en/skills
[choose]: https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#model-selection-matrix
[choose-crit]: https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#establish-key-criteria
[pricing]: https://platform.claude.com/docs/en/about-claude/pricing
[mars]: https://www.anthropic.com/engineering/multi-agent-research-system
[ce]: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
[bp-model]: https://code.claude.com/docs/en/best-practices#change-the-model-and-effort
[mc-effort]: https://code.claude.com/docs/en/model-config#adjust-effort-level
[mc-effort-task]: https://code.claude.com/docs/en/model-config#choose-an-effort-level
[mc-workfable]: https://code.claude.com/docs/en/model-config#work-with-fable
[opusplan]: https://code.claude.com/docs/en/model-config#opusplan-model-setting
[advisor]: https://code.claude.com/docs/en/advisor#common-model-pairings
[opt-task]: https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#compare-models-on-cost-per-task
[opt-rerun]: https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#re-run-failures-at-higher-effort
[opt-upgrade]: https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#upgrade-the-model
[opt-orch]: https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#orchestrator-pattern
[opt-combine]: https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#combine-models
[opt-advisor]: https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#advisor-pattern
[effort-page]: https://platform.claude.com/docs/en/build-with-claude/effort
[opus-prompt]: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5
[fable-prompt]: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-2
[sonnet-launch]: https://www.anthropic.com/claude-sonnet-5-5
[haiku-launch]: https://www.anthropic.com/claude-haiku-5-5
[fable-launch]: https://www.anthropic.com/claude-fable-and-mythos-5-2
