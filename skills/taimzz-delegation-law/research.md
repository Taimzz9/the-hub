# taimzz-delegation-law v2.0 · Research

**Status 2026-11-21:** 4 research passes by read only Sonnet subagents (one per topic cluster, run in parallel), plus model ids and prices from the `claude-api` skill (model table cached 2026-11-03). Every row comes from a page fetched on 2026-11-21. The pages went through a summarising fetch, so exact strings are high fidelity, not guaranteed. Gaps are listed in §6.

Row ids (`M3`, `S12`) are cited from [SKILL.md](SKILL.md).

## Contents

1. Models, effort, caching, context engineering (M)
2. Subagents, forks, teams, workflows, worktrees, multi-agent research (S)
3. Skill authoring, hooks, permission modes, headless (K)
4. Best practices, plan mode, memory, context, cost tracking (B)
5. Model ids and prices (P)
6. Not checked

## 1 · Models, effort, caching, context engineering

| # | Topic | Finding | URL | Rule |
|---|---|---|---|---|
| M1 | Aliases | Aliases: `default` (clears override), `best` (= `opus`), `fable`, `sonnet`, `opus`, `haiku`, `sonnet[1m]`, `opus[1m]`, `opusplan` | https://code.claude.com/docs/en/model-config#model-aliases | Route with aliases, not version strings |
| M2 | Alias targets | On the Anthropic API: `opus` = Opus 5.5, `sonnet` = Sonnet 5.5, `haiku` = Haiku 5.5, `fable` = Fable 5.2. Targets move with Claude Code versions | same | Never hard code a version in agent files |
| M3 | Other providers | Bedrock, Foundry and Claude Platform on AWS resolve aliases to older models (for example Sonnet 4.5, Haiku 4.5) | same | On a third party provider, pin `ANTHROPIC_DEFAULT_*_MODEL` |
| M4 | Default model | Default is Opus 5.5 on Pro, Max, Team, Enterprise and the API; Fable is never the default | same | Assume the main thread is Opus; cheaper subagents are the saving |
| M5 | opusplan | `opusplan` = Opus in plan mode, Sonnet for execution | same | Option for plan then execute sessions; each toggle is a model switch |
| M6 | Fable billing | Fable can bill to usage credits instead of plan limits ("Requires usage credits"); Fable 5.2 needs Claude Code v2.1.321+ | https://code.claude.com/docs/en/model-config#fable-models | Fable only where depth changes the outcome |
| M7 | Subagent model order | First match wins: per invocation `model` (alias only), definition `model` (alias, full id or `inherit`), `CLAUDE_CODE_SUBAGENT_MODEL`, parent model | https://code.claude.com/docs/en/sub-agents#choose-a-model | Set `model:` in every definition; omitted means it inherits the expensive parent |
| M8 | Force one model | `CLAUDE_CODE_SUBAGENT_MODEL` plus `CLAUDE_CODE_SUBAGENT_MODEL_FORCE=1` overrides every definition | https://code.claude.com/docs/en/sub-agents#run-every-subagent-on-one-model | Do not set FORCE; it defeats tier routing |
| M9 | Built-in Explore | Explore runs on the Opus model on a subscription or Console account. A user or project agent named `Explore` with `model: haiku` overrides it, even under FORCE | same | Ship an `Explore` override on Haiku to make exploration cheap |
| M10 | Inheritance | Inheriting subagents follow `/model` switches; nested subagents default to their parent subagent's model | https://code.claude.com/docs/en/model-config#subagents-and-fallback-chains | A session switch to Fable raises every inheriting subagent's cost |
| M11 | Effort levels | `low`, `medium`, `high`, `xhigh`, `max`; set with `/effort`, `--effort`, `CLAUDE_CODE_EFFORT_LEVEL` | https://code.claude.com/docs/en/model-config#adjust-effort-level | Effort is the second cost dial |
| M12 | Effort default | Default `medium` on Fable 5.2, Opus 5.5, Sonnet 5.5, Haiku 5.5 | same | Do not assume `high` |
| M13 | Subagent effort | Frontmatter `effort` overrides the session level; per invocation `effort` overrides the field (v2.1.292+); `CLAUDE_CODE_SUBAGENT_EFFORT` is the fallback | https://code.claude.com/docs/en/sub-agents#effort-field | Set `effort:` per agent: low for lookups, higher for code and review |
| M14 | Thinking | Thinking cannot be turned off on Opus 5.5, Sonnet 5.5, Haiku 5.5, Fable; thinking bills as output | https://code.claude.com/docs/en/costs#adjust-extended-thinking | Lower effort, not thinking, to cut cost |
| M15 | Context window | Current models have a native 1M window; `[1m]` has no effect. Haiku 5.5 costs more above 100K tokens | https://code.claude.com/docs/en/model-config#extended-context | Keep Haiku prompts under 100K |
| M16 | Auto-compact | Native 1M models auto compact near 967K; set with `/autocompact`, `autoCompactWindow`, `CLAUDE_CODE_AUTO_COMPACT_WINDOW`; per subagent window exists | https://code.claude.com/docs/en/model-config#set-the-auto-compact-window | Long sessions: smaller window bounds per request context |
| M17 | Fast mode | Up to 2.5x faster at 2x price ($8/$40 Opus 5.5, $16/$80 Fable 5.2); not on Sonnet or Haiku; credits only on subscriptions | https://code.claude.com/docs/en/fast-mode | Never for cost saving; only for interactive latency |
| M18 | Fast mode cache | Fast and standard keep separate caches; turning it on mid conversation rereads all context uncached | https://code.claude.com/docs/en/prompt-caching#turning-on-fast-mode | Decide fast mode at session start |
| M19 | Choosing a model | Fable 5.2 highest capability; Opus 5.5 complex agentic coding; Sonnet 5.5 everyday coding and agents; Haiku 5.5 lowest latency and price, "subagent tasks" | https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#model-selection-matrix | Haiku for simple high volume subtasks, Sonnet routine, Opus complex, Fable when Opus at high effort falls short |
| M20 | Effort vs model | "Tuning effort is often a better lever than switching models"; efficiency first starts at Haiku and upgrades on need | https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#establish-key-criteria | Escalate effort before tier; escalate on measured failure |
| M21 | Combining models | Orchestrator delegates bulk work to lower cost workers | https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#combine-models | Strong main thread, cheap workers |
| M22 | Costs page, model | "Sonnet handles most coding tasks well and costs less than Opus. Reserve Opus for complex architectural decisions or multi-step reasoning"; `model: haiku` for simple subagent tasks | https://code.claude.com/docs/en/costs#choose-the-right-model | Well specified edits can go to Sonnet; simple subagent tasks to Haiku |
| M23 | Verbose work | Delegate tests, docs fetches and logs to subagents so only a summary returns; subagent requests still count against usage | https://code.claude.com/docs/en/costs#delegate-verbose-operations-to-subagents | Verbose output goes to a cheap subagent that returns a summary |
| M24 | Team cost | Agent teams use about 7x the tokens of a standard session when teammates run in plan mode; use Sonnet teammates, small teams, shut idle ones down | https://code.claude.com/docs/en/costs#agent-team-token-costs | Teams are rare and small |
| M25 | Reference spend | About $13 per developer per active day, $150 to 250 per month, under $30 per active day for 90% of users; high spend traces to long uncleared sessions or Opus left as default | https://code.claude.com/docs/en/costs | `/clear` between tasks; match model to job |
| M26 | Cache: model switch | Each model has its own cache; `/model` mid session rereads history uncached; a skill whose frontmatter names another `model` is a switch for that turn | https://code.claude.com/docs/en/prompt-caching#switching-models | Pick the main model at the start; put tiers in subagents |
| M27 | Cache: subagents | A subagent has its own prompt and cache and does not touch the parent's; a fork inherits the parent prefix and reads its cache | https://code.claude.com/docs/en/prompt-caching#subagents-and-the-cache | Fork when the parent context is needed; fresh subagent otherwise |
| M28 | Cache: invalidators | CLAUDE.md edits mid session, skills, plan mode, permission mode, output style keep the cache. Fast mode, changing the tool set and compaction break it. Effort change keeps it on Opus 5.5, Sonnet 5.5, Haiku 5.5, Fable 5.1+ | https://code.claude.com/docs/en/prompt-caching#actions-that-invalidate-the-cache | Do not change models or tool sets mid task |
| M29 | Cache TTL | Main thread: 1h only on a subscription within plan usage, else 5 min. Subagents, workflows, teammates, forks: 5 min unless `subagentPromptCacheTtl` / `CLAUDE_CODE_SUBAGENT_PROMPT_CACHE_TTL` set (`5m` or `1h`) | https://code.claude.com/docs/en/prompt-caching#which-ttl-each-request-gets | Resume a subagent within 5 min, or do not count on its cache |
| M30 | Cache prices | Cache read 0.1x base input (0.05x on Opus 5.5 and Sonnet 5.5); 5 min write 1.25x; 1h write 2x | https://platform.claude.com/docs/en/build-with-claude/prompt-caching | 1h TTL only when idle gaps exceed 5 min |
| M31 | Cache minimum | 512 tokens minimum on Opus 5.5, Sonnet 5.5, Haiku 5.5, Fable 5.2; below it, no cache, no error | same | Tiny prompts get no cache benefit |
| M32 | Compaction cost | `/compact` is a large request; cheap while the cache is warm, most expensive after an idle gap longer than the TTL | https://code.claude.com/docs/en/prompt-caching#compacting-the-conversation | Compact at task breaks while warm; `/clear` between unrelated tasks |
| M33 | Condensed returns | Subagents may use tens of thousands of tokens but return "a condensed, distilled summary ... (often 1,000-2,000 tokens)" | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents | Cap reports; never return raw output |
| M34 | Notes, clearing | Structured notes written outside the context window; tool result clearing is the lightest touch compaction | same | Long tasks persist state to a file |
| M35 | Just in time | Keep lightweight identifiers (paths, queries, links) and load data at runtime | same | Brief with paths and line ranges, not contents |

## 2 · Subagents, forks, teams, workflows, worktrees, multi-agent research

| # | Topic | Finding | URL | Rule |
|---|---|---|---|---|
| S1 | File format | Markdown with YAML frontmatter; body is the system prompt; only `name` and `description` required; keys case sensitive camelCase; unknown keys ignored silently | https://code.claude.com/docs/en/sub-agents#supported-frontmatter-fields | camelCase keys; body is the full prompt |
| S2 | name, description | `name` up to 256 chars, no `:`; `description` says when to delegate, kept short | same | Unique names; one or two sentence descriptions |
| S3 | tools | `tools` is an allowlist, inherits all if omitted; `disallowedTools` is a denylist; a pattern like `Bash(git push *)` there removes all of Bash | same | Read only agents get an explicit allowlist |
| S4 | model | `sonnet`, `opus`, `haiku`, `fable`, a full id, or `inherit` | same | Alias per tier |
| S5 | runtime fields | `permissionMode`, `maxTurns` (output marked partial, resumable), `effort`, `background`, `isolation: worktree` | same | Bound cheap agents with `maxTurns` and low `effort`; `isolation: worktree` for parallel writers |
| S6 | other fields | `skills`, `mcpServers`, `hooks`, `memory`, `color`, `omitClaudeMd`, `autoCompactWindow`, `initialPrompt`, `experimental.cacheTtl`; `hooks`, `mcpServers`, `permissionMode` ignored for plugin agents | same | Lookups can skip CLAUDE.md with `omitClaudeMd` |
| S7 | Locations | Priority: managed settings, `--agents` flag, `.claude/agents/` (project), `~/.claude/agents/` (user), plugin `agents/`; scanned recursively; changes picked up within seconds | https://code.claude.com/docs/en/sub-agents#choose-the-subagent-scope | Install to `~/.claude/agents/`; a same named higher scope agent wins |
| S8 | `--agents` flag | JSON definitions for one session; works with `-p` | same | For CI or `-p` runs that cannot write files |
| S9 | Built-ins | Explore (read only, thoroughness `quick` / `medium` / `very thorough`), Plan (read only), general-purpose (all tools, parent model); `claude-code-guide` and `web-fetch` on Haiku | https://code.claude.com/docs/en/sub-agents#built-in-subagents | Use built-ins before custom agents where they fit |
| S10 | Explore, Plan context | Start without CLAUDE.md and the git status snapshot | same | Put needed rules in the brief |
| S11 | Isolation | Fresh window: own prompt, the task message, CLAUDE.md (unless `omitClaudeMd`), git status, preloaded skills. Only the final report returns | https://code.claude.com/docs/en/sub-agents#what-loads-at-startup | Every brief is self contained |
| S12 | Proactive use | Delegation is chosen from the task and `description`; "Use proactively" phrasing encourages it; combined descriptions over 15,000 tokens warn | https://code.claude.com/docs/en/sub-agents#understand-automatic-delegation | Descriptions: "Role. Use proactively when trigger." |
| S13 | Nesting | Default depth 3; `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` turns it off; leaving `Agent` out of `tools` stops spawning | https://code.claude.com/docs/en/sub-agents#let-subagents-spawn-their-own-subagents | Workers never get `Agent`; only the main thread delegates |
| S14 | Resume | Each call is a new instance; `SendMessage` to the agent id or name resumes it with full history | https://code.claude.com/docs/en/sub-agents#resume-subagents | Follow ups go to the same agent, not a new one |
| S15 | Background | Custom subagents spawned from the main thread start in the background by default; results arrive as a notification in a later turn | https://code.claude.com/docs/en/sub-agents#run-subagents-in-foreground-or-background | Dispatch, then wait; never poll |
| S16 | Concurrency | Ctrl+B backgrounds a running task; default limit 20 concurrent subagents (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`) | same | Stay well under 20 per wave |
| S17 | `/agents` | From v2.1.198, `/agents` only reminds you to edit `.claude/agents/` or `~/.claude/agents/` | https://code.claude.com/docs/en/sub-agents#quickstart-create-your-first-subagent | Install by copying files |
| S18 | Forks | A fork inherits the whole conversation, prompt, tools and model, runs in the background, shares the parent cache ("cheaper than a fresh subagent for context heavy tasks"); `/subtask` starts one; forks cannot fork | https://code.claude.com/docs/en/sub-agents#fork-the-current-conversation | Fork when a brief would need a long context dump |
| S19 | Teams: enable | Experimental, off by default (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`); when on, a named subagent launches as a teammate; not in `-p` | https://code.claude.com/docs/en/agent-teams#enable-agent-teams | Leave teams off by default |
| S20 | Teams vs subagents | Subagents cost less and suit "focused tasks where only the result matters"; teams suit work that needs discussion; sequential work, same file edits or many dependencies suit one session or subagents | https://code.claude.com/docs/en/agent-teams#compare-with-subagents | Teams only for competing hypotheses or multi angle review |
| S21 | Team size | Start with 3 to 5 teammates, 5 to 6 tasks each; two teammates on one file overwrite each other; one team per session | https://code.claude.com/docs/en/agent-teams#choose-an-appropriate-team-size | Disjoint files; 3 to 5 workers per round |
| S22 | Workflows | A script that orchestrates many subagents in the background (`agent()`, `parallel()`, `pipeline()`, `phase()`); starts on "use a workflow" or `ultracode`; `/workflows` shows progress; limits 16 concurrent agents, 1,000 per run | https://code.claude.com/docs/en/workflows | Workflows for large fan outs, on the owner's explicit ask |
| S23 | Workflow cost | "Large workflow" warning above 25 agents or 1.5M projected tokens; `workflowSizeGuideline` default `medium` (under 10 agents); workflow agents pick models like subagents | https://code.claude.com/docs/en/workflows#cost | Trial on a small slice; name a smaller model per stage |
| S24 | Worktrees | `claude --worktree <name>` (`-w`) creates `.claude/worktrees/<name>/` on branch `worktree-<name>`; `worktree.baseRef` `fresh` (default) or `head`; `.worktreeinclude` copies ignored files | https://code.claude.com/docs/en/worktrees#start-claude-in-a-worktree | Parallel sessions that edit the same repo each get a worktree |
| S25 | Subagent worktrees | `isolation: worktree` gives a temporary worktree, removed if unchanged; branches from the default branch unless `baseRef` is `head` | https://code.claude.com/docs/en/worktrees#isolate-subagents-with-worktrees | Set `baseRef: head` when agents must see uncommitted work |
| S26 | Choosing an approach | `agents.md` compares subagents, agent view, teams and workflows | https://code.claude.com/docs/en/worktrees | Link, do not restate |
| S27 | Multi-agent cost | Agents use about 4x the tokens of chat; multi-agent systems about 15x; token usage explains 80% of variance on BrowseComp | https://www.anthropic.com/engineering/multi-agent-research-system | Multi-agent only when the value justifies about 15x tokens |
| S28 | When worth it | Best for heavily parallel work, information beyond one context window, many tools; poor fit for shared context or many dependencies, "such as most coding tasks" | same | Parallelise research, lookups and disjoint file edits only |
| S29 | Brief contents | "Each subagent needs an objective, an output format, guidance on the tools and sources to use, and clear task boundaries"; vague briefs caused duplicated work and gaps | same | Brief = objective, output format, tools and sources, boundaries |
| S30 | Effort scaling | Simple fact finding: 1 agent, 3 to 10 tool calls; comparisons: 2 to 4 subagents, 10 to 15 calls each; complex research: 10+ subagents; early versions spawned 50 for simple queries | same | Scale agent count to the question |
| S31 | Parallel calls | Lead starts 3 to 5 subagents in parallel; subagents use 3+ tools in parallel; cut research time "by up to 90%" | same | Send a wave in one message |

## 3 · Skill authoring, hooks, permission modes, headless

| # | Topic | Finding | URL | Rule |
|---|---|---|---|---|
| K1 | name | Max 64 chars, lowercase letters, numbers, hyphens; no XML; reserved words `anthropic`, `claude` | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices | `taimzz-delegation-law` passes |
| K2 | description (API) | Non empty, max 1,024 chars, no XML; says what and when | same | Stay under 1,024 chars |
| K3 | description (Claude Code) | `description` plus `when_to_use` truncated at 1,536 chars in the listing | https://code.claude.com/docs/en/skills | Triggers early in the description |
| K4 | Upload keys | claude.ai and Skills API uploads accept only `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`; other keys are a hard error | same | Frontmatter: `name` and `description` only |
| K5 | Skill `model` | A skill's `model` applies to the invoking turn only; `allowed-tools` clears on the next user message | same | Never route tiers through skill frontmatter |
| K6 | Locations | Personal `~/.claude/skills/<name>/SKILL.md`, project `.claude/skills/`, plugin, claude.ai account | same | Install to the personal, project or plugin location |
| K7 | Body size | "Keep SKILL.md under 500 lines"; the body stays in context across turns | same; best-practices page | Short body, tables |
| K8 | After compaction | Only the first 5,000 tokens of each invoked skill are reattached (25,000 combined) | https://code.claude.com/docs/en/skills | Core rules in the first 5,000 tokens |
| K9 | Progressive disclosure | Three levels: metadata preloaded, body on trigger, linked files on need | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | Evidence lives in this file, one level deep |
| K10 | Reference depth | References one level deep; files over 100 lines need a table of contents | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices | This file has Contents |
| K11 | Description voice | Third person, what plus specific triggers | same | Rewritten in third person |
| K12 | Conciseness | "Claude is already very smart"; add only what it does not know | same | Cut explanations of what subagents are |
| K13 | Degrees of freedom | Low freedom for fragile steps, high for open choices | same | Fixed routing and do it once rules; free decomposition |
| K14 | Test across models | Test with Haiku, Sonnet and Opus; at least three evaluations | same | Agent prompts must work on Haiku |
| K15 | One default | Give one default plus an escape hatch; consistent terms; avoid time sensitive text | same | One route per task type; dated model table labelled |
| K16 | Hooks | 33 events including `PreToolUse`, `PostToolUse`, `SubagentStart`, `SubagentStop`, `Stop`, `PreCompact`, `PreModelSwitch`; types `command`, `http`, `mcp_tool`, `prompt`, `agent` | https://code.claude.com/docs/en/hooks | Exact event names |
| K17 | Hooks vs prose | Hooks make actions always happen rather than relying on the model; hard allow or deny belongs in permission rules | https://code.claude.com/docs/en/hooks-guide | Move must always rules into hooks or permissions |
| K18 | Exit codes | Exit 2 blocks; exit 1 does not; `SubagentStop` exit 2 keeps the subagent working | https://code.claude.com/docs/en/hooks | Gate subagent output with `SubagentStop` exit 2 |
| K19 | Permission modes | `default` (`manual`), `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions` | https://code.claude.com/docs/en/permission-modes | Exact names |
| K20 | Shift+Tab | Cycles `default`, `acceptEdits`, `plan`, then optional modes; `dontAsk` not in the cycle | same | Plan mode for architecture |
| K21 | Subagent permissionMode | Under auto mode, subagent `permissionMode` is ignored | same | Constrain agents with `tools`, not `permissionMode` |
| K22 | Headless | `claude -p`; `--output-format json` includes `total_cost_usd`; `--max-turns`; `--max-budget-usd` | https://code.claude.com/docs/en/headless | Scripted fan out runs with turn and budget caps |
| K23 | Headless tools | `--allowedTools "Bash(git diff *)"`; `--permission-mode dontAsk` for CI; `--bare` skips hooks, skills, MCP, CLAUDE.md, recommended for scripts | same | Narrow tools, `--bare`, explicit mode |
| K24 | Agent SDK | Same tools, loop and context management as Claude Code, with callbacks and structured output | https://code.claude.com/docs/en/headless (link to agent-sdk overview, not fetched) | SDK when code needs callbacks |

## 4 · Best practices, plan mode, memory, context, cost tracking

The 2025 engineering post on Claude Code best practices now redirects (308) to the docs page below, so only the docs page was read.

| # | Topic | Finding | URL | Rule |
|---|---|---|---|---|
| B1 | Defaults | Fresh sessions already do the right thing: auto mode, Claude delegates to subagents on its own, compaction is automatic | https://code.claude.com/docs/en/best-practices | Add rules only for what the defaults do not cover |
| B2 | Specific prompt | "Name the file, describe the symptom, say what fixed looks like" | https://code.claude.com/docs/en/best-practices#write-a-specific-prompt | Every brief names files, goal, done condition, constraints |
| B3 | Spec first | For vague goals: "Interview me until you could write the spec, then write it to SPEC.md", then build in a fresh session | https://code.claude.com/docs/en/best-practices#brainstorm-with-claude-first | Unclear intent: SPEC.md before dispatch |
| B4 | Verification | "Give Claude something it can run that comes back pass or fail"; ask for the command and its output as evidence | https://code.claude.com/docs/en/best-practices#give-claude-a-check-to-run | Every subtask carries a runnable check; report the command and result |
| B5 | Check ladder | Prompt, then `/goal <condition>`, then a `Stop` hook (exit 2 blocks; capped at 8 blocks), then `/code-review` in a fresh subagent | same | Unattended work gets `/goal` or a Stop hook |
| B6 | Review prompt | Review the diff against SPEC.md, "report gaps that affect correctness and skip style"; a reviewer asked to find problems always finds something | https://code.claude.com/docs/en/best-practices#review-against-your-spec | Reviews: spec path, correctness only, once |
| B7 | `/verify` | Builds and runs the app and looks at the result | https://code.claude.com/docs/en/best-practices#give-claude-a-check-to-run | Once, at the end, for changes with a runtime surface |
| B8 | Deterministic rules | CLAUDE.md and prompts are not deterministic; hooks, deny rules, managed settings are. A line that keeps getting missed "belongs in a hook" | https://code.claude.com/docs/en/best-practices#deterministic-and-non-deterministic-instructions | Zero exception rules go in hooks or deny rules; no IMPORTANT or capitals |
| B9 | Steering | `Esc` stops and keeps progress; `/rewind` rolls back; after two failed corrections, `/clear` and write a better prompt | https://code.claude.com/docs/en/best-practices#steer-the-session | Two failures: stop, rebrief from scratch |
| B10 | Plan mode | `--permission-mode plan`, Shift+Tab, `/plan` prefix, `defaultMode: plan`; reads and explores, no source edits until approved | https://code.claude.com/docs/en/permission-modes | Plan mode for multi file or exploration heavy work |
| B11 | Plan survives | The approved plan is reinjected from disk after compaction; `showClearContextOnPlanAccept` adds approve and clear | https://code.claude.com/docs/en/context-window#what-survives-compaction | Keep the breakdown in the plan or a file |
| B12 | Plan cost | Plan mode prevents "expensive re-work when the initial direction is wrong" | https://code.claude.com/docs/en/costs#work-efficiently-on-complex-tasks | Plan before spawning |
| B13 | CLAUDE.md scopes | Managed, user `~/.claude/CLAUDE.md`, project `./CLAUDE.md`, local `CLAUDE.local.md` | https://code.claude.com/docs/en/memory | Standing rules live in CLAUDE.md, not in briefs |
| B14 | CLAUDE.md size | "Target under 200 lines per CLAUDE.md file"; only commands, gotchas, off repo decisions, things corrected twice | https://code.claude.com/docs/en/memory | Point briefs to CLAUDE.md instead of repeating it |
| B15 | Imports | `@path` imports expand into context; do not save tokens | https://code.claude.com/docs/en/memory#import-additional-files | No token saving from imports |
| B16 | Rules folder | `.claude/rules/` with `paths:` frontmatter loads only for matching files | https://code.claude.com/docs/en/memory | Scope area rules with `paths:` |
| B17 | Skills vs CLAUDE.md | CLAUDE.md loads every session; skills load only the description until used | https://code.claude.com/docs/en/costs#move-instructions-from-claudemd-to-skills | Workflow rules belong in skills |
| B18 | Auto memory | First 200 lines or 25KB of `MEMORY.md` load at start; `/memory` edits | https://code.claude.com/docs/en/memory | Keep memory an index |
| B19 | `/clear` | Free; every request resends the whole conversation; `/clear <name>` names the session | https://code.claude.com/docs/en/best-practices#keep-cost-and-context-down | `/clear` between unrelated tasks |
| B20 | `/compact` | `/compact <focus>` steers the summary; itself a large request | https://code.claude.com/docs/en/costs#manage-context-proactively | Compact with a focus at breakpoints |
| B21 | Survives compaction | Root CLAUDE.md, unscoped rules, auto memory, skill descriptions, the plan; up to 5 recent files; background agents keep running | https://code.claude.com/docs/en/context-window#what-survives-compaction | State lives in files |
| B22 | `/context` | Live breakdown by category with suggestions | https://code.claude.com/docs/en/context-window#check-your-own-session | Diagnose bloat before acting |
| B23 | When subagents pay | Parallel independent work, keeping long output out of the main chat, a reviewer that has not seen the code. A fresh subagent can be slower (regathers context) and does not give a better answer; protecting context is rarely the issue with 1M windows | https://code.claude.com/docs/en/best-practices#know-what-subagents-cost | Delegate for parallelism, noise or independent review only |
| B24 | Subagent cost levers | `model: haiku` for simple jobs (collecting files, checking links); short summaries; `tools: Read, Grep, Glob` for a read only reviewer | same | Cheapest adequate model, minimum tools, short report |
| B25 | Model choice | Default Opus 5.5 at medium effort; Sonnet "costs less on routine work"; `/model fable` for Fable 5.2 | https://code.claude.com/docs/en/best-practices#change-the-model-and-effort | Pin models per tier |
| B26 | Effort use | low for fast iteration; high or xhigh for edge case heavy work; max only for unattended hard problems; `ultrathink` boosts one turn | same | Effort per task type, not "think hard" phrases |
| B27 | `/usage` | Session tokens and a cost estimate at list price; on plans, attribution to skills, subagents, plugins, MCP with recommendations above 10% | https://code.claude.com/docs/en/costs#using-the-usage-command | `/usage` after a heavy task. The page documents `/usage`, not `/cost` |
| B28 | Cache lifetime | About 1 hour on a subscription, 5 minutes on an API key or credits; the first message after expiry reprocesses everything | https://code.claude.com/docs/en/best-practices#keep-cost-and-context-down | Batch work while warm; `/clear` after a long break |
| B29 | MCP overhead | MCP tools deferred by default; `/mcp` to disable unused servers; CLIs (`gh`) add no listing | https://code.claude.com/docs/en/costs#reduce-mcp-server-overhead | Prefer CLIs; disable idle servers |
| B30 | Hook preprocessing | A `PreToolUse` hook can rewrite test commands to `2>&1 \| tail -n 100`, cutting tens of thousands of tokens to hundreds | https://code.claude.com/docs/en/costs#offload-processing-to-hooks-and-skills | Filter verbose test and log output |
| B31 | Background drain | `/loop`, goal check ins, idle compaction and recaps spend tokens while idle | https://code.claude.com/docs/en/costs#background-token-usage | Stop loops and goals when done |
| B32 | Parallel sessions | `claude -w <name>` per session; `/batch <change>` splits into 5 to 30 units, one worktree and PR each, after approval; a second session is the easiest independent reviewer | https://code.claude.com/docs/en/best-practices#run-sessions-in-parallel | `/batch` for large mechanical changes |
| B33 | Unattended runs | Five questions: done, self check, may touch, what stops it (`--max-turns`, `--max-budget-usd`), who signs off; pilot on three files | https://code.claude.com/docs/en/best-practices#let-claude-run-without-you | Cap turns and spend; pilot first |
| B34 | Stop doing | No longer needed: aggressive context management, IMPORTANT or capitals, "keep going" nagging, "think hard", architecture in CLAUDE.md | https://code.claude.com/docs/en/best-practices#what-you-can-stop-doing | Leave these out |

## 5 · Model ids and prices

Source: `claude-api` skill, model table cached 2026-11-03 (live page: https://platform.claude.com/docs/en/about-claude/pricing). Prices per million tokens, Anthropic API.

| # | Alias | Model id | Input | Output | Cache read | Notes |
|---|---|---|---|---|---|---|
| P1 | `haiku` | `claude-haiku-5-5` | $0.10 | $0.50 | 0.1x input | Prompts over 100K: $0.50 / $2.50. Docs name it for sub-agent tasks |
| P2 | `sonnet` | `claude-sonnet-5-5` | $2.00 | $10.00 | $0.10 | Everyday coding and agents |
| P3 | `opus` | `claude-opus-5-5` | $4.00 | $20.00 | $0.20 | Default model; effort default `medium` |
| P4 | `fable` | `claude-fable-5-2` | $8.00 | $40.00 | $0.20 | Most capable widely released; may bill usage credits in Claude Code (M6) |
| P5 | (v1 used) | `claude-fable-5-1` | $10.00 | $50.00 | $0.25 | Superseded by 5.2, which is cheaper |

Cache writes: 1.25x input for 5 minute TTL, 2x for 1 hour (M30). Ratio output price: Haiku 1, Sonnet 20, Opus 40, Fable 80.

## 6 · Not checked

- Agent SDK overview page; `agents.md` and `common-workflows.md` (known from the docs map only); the "optimizing for cost and intelligence" page; the models overview page live (ids taken from the `claude-api` skill).
- Pages read in part because of fetch truncation: sub-agents (middle section summarised), hooks (first 100K of 294K chars), skills (first 100K of 120K), permission modes (first 100K of 122K), API prompt caching (tail).
- Hooks guide: no documented example of using hooks to cut cost (keyword search only).
- Whether the research post figures were updated after publication.
- `/cost` and `/stats`: the costs page documents only `/usage`; whether `/cost` still exists as an alias was not checked.
- `goal.md`, `checkpointing.md`, `mcp.md`: known only from links on the pages above.

## 8 · Which model codes best (follow up pass, 2026-11-21)

Question from the owner: is Sonnet good for coding, according to Anthropic? Three more read only Sonnet agents (launch pages; Opus and Fable pages; model choice docs) plus the `claude-api` skill's migration guide. Benchmarks are Anthropic reported, with different effort settings and harnesses per model; do not read one table across pages.

| # | Topic | Finding | URL | Rule |
|---|---|---|---|---|
| Q1 | Anthropic's start point | "Most workloads start with Claude Opus 5.5"; Opus for complex agentic coding, large scale refactoring, multihour autonomous coding | https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#model-selection-matrix | Opus stays the code default |
| Q2 | Sonnet, Claude Code view | "Sonnet handles most coding tasks well and costs less than Opus"; "The default Opus 5.5 handles most coding well and Sonnet costs less on routine work" | https://code.claude.com/docs/en/costs#choose-the-right-model ; https://code.claude.com/docs/en/best-practices#change-the-model-and-effort | Sonnet for routine coding |
| Q3 | Sonnet strengths | Strongest on multistep agentic coding in a real repository; scopes changes and keeps edits reviewable; for the hardest long horizon work an Opus model is better | `claude-api` skill, model-migration.md "Migrating to Claude Sonnet 5.5"; https://www.anthropic.com/claude/sonnet | Sonnet for well scoped work; Opus for long or open ended work |
| Q4 | Sonnet launch numbers | Terminal-Bench 4.0: Sonnet 5.5 70.6%, Opus 5.5 66.4% (xhigh). CursorBench 4.0: 55.5% vs 57.8%. FrontierCode 1.1: Sonnet below Opus 5.5 at 54.4% | https://www.anthropic.com/claude-sonnet-5-5 | Close to Opus on coding; behind on the hardest set |
| Q5 | Sonnet positioning | Best for well scoped everyday tasks and bug fixing; Opus 5.5 "clearly stronger" for complex, open ended work needing sustained judgment | same | Ambiguous or design heavy code goes to Opus |
| Q6 | Sonnet caveat | At max effort it more often ran a multi subagent review and made out of scope edits; at low effort it sometimes reports code done without a real check | same; `claude-api` model-migration.md | Sonnet coding at medium or high, never low or max; demand a real check |
| Q7 | Cost per solved task | SWE-bench Pro subset: Sonnet 5.5 high 87.6% at $0.11; Opus 5.5 low 87.4% at $0.12; Opus medium 92.8% at $0.22; Opus high 95.3% at $0.29; Opus xhigh 96.7% at $0.74 | https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#compare-models-on-cost-per-task | Sonnet high equals Opus low; Opus medium buys about 5 points for 2x; xhigh rarely pays |
| Q8 | Escalate failures | Run at low, rerun failures at high: about 97% solved at $0.17, vs all high 95.3% at $0.29; needs a reliable failure signal such as tests | same, #re-run-failures-at-higher-effort | With tests, start cheaper and escalate only red results |
| Q9 | Judge per task | Compare cost per completed task; "the bill is decided by the tasks the cheaper model fails" | same, #upgrade-the-model | Count retries in the cost |
| Q10 | Haiku writing code | Haiku 5.5 coding subagents cut cost per attempt 32% but lowered pass rate about 4 points; "compare with lower effort first" | same, #orchestrator-pattern | Haiku for lookups, not for code writing subagents |
| Q11 | Haiku launch numbers | Terminal-Bench 4.0: Haiku 5.5 39.2% vs Sonnet 5.5 70.6%; pitched for summaries, compaction, classification, subagent work; pairs with Opus or Sonnet as a coding subagent | https://www.anthropic.com/claude-haiku-5-5 | Haiku is the cheap helper, not the coder |
| Q12 | Orchestrator pattern | Opus 5.5 medium lead plus Sonnet 5.5 workers matched Opus alone at about a third less cost, only on work larger than one context window; for one dependent chain, one model at lower effort did better | https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#orchestrator-pattern | Fan out only parallel, independent work |
| Q13 | Combine models last | Tune one model first; build a pairing only if it beats the single model's whole score vs spend curve | same, #combine-models | Effort before tier, tier before pairing |
| Q14 | Effort by task (Claude Code) | low: a rename; medium: a new feature with clear scope; high: fixing a bug in an existing codebase; max: hard autonomous work, prone to overthinking | https://code.claude.com/docs/en/model-config#choose-an-effort-level | Set effort per dispatch from the task type |
| Q15 | Effort, best practices | high or xhigh for a bug in code you did not write or a flaky test; low for a sketch or rename; `ultrathink` for one turn | https://code.claude.com/docs/en/best-practices#change-the-model-and-effort | Debugging gets high |
| Q16 | Effort defaults differ | API: Opus 5.5 and Haiku 5.5 default medium, Sonnet 5.5 and Fable 5.2 high. Claude Code: all four default medium | https://platform.claude.com/docs/en/about-claude/models/choosing-a-model#establish-key-criteria ; https://code.claude.com/docs/en/model-config#adjust-effort-level | Always set effort explicitly |
| Q17 | opusplan | Opus in plan mode for reasoning and architecture, Sonnet for implementation | https://code.claude.com/docs/en/model-config#opusplan-model-setting | Built in plan on Opus, build on Sonnet |
| Q18 | Advisor | A smaller main model consults a stronger advisor at key moments; fits large refactors and recurring errors; less value on short tasks | https://code.claude.com/docs/en/advisor#when-to-use-the-advisor | Long serial work: Sonnet main plus Opus advisor |
| Q19 | Advisor pairs | Sonnet main plus Opus advisor for routine work with escalated planning and completion checks; advisor must rank at or above the main model; `/advisor opus`; toggling keeps the cache | https://code.claude.com/docs/en/advisor#common-model-pairings | `/advisor opus` when running Sonnet as the main model |
| Q20 | Advisor measured | Opus 5.5 high plus Fable 5.1 advisor: +1.7 points on coding at about 2.1x cost (edge of noise) | https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence#advisor-pattern | No advisor on an Opus main thread |
| Q21 | Opus 5.5 launch | Terminal-Bench 4.0 66.4% vs Fable 5.1 55.8%; FrontierCode 1.1 54.4% vs 50.3%; at default medium, FrontierCode 54.6%; benchmark margins are "a less reliable guide to real-world differences" | https://www.anthropic.com/news/claude-opus-5-5 | Medium is enough for most Opus coding |
| Q22 | Opus strengths | Multihour audits and migrations with parallel subagents; testers reported stronger code review (more bugs, fewer false alarms); unattended runs can stop early, add a finish the task instruction | https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5 | Opus for review of risky code and long migrations |
| Q23 | Fable 5.2 launch | FrontierCode 2.0: Fable 5.2 49.1% (xhigh) vs Opus 5.5 45.5%; FrontierSWE v2: 69.9% vs 62.3%; Fable at high 45.3%, about Opus's best, at about half the cost per task | https://www.anthropic.com/claude-fable-and-mythos-5-2 | Fable at high is a fair alternative to Opus at xhigh |
| Q24 | Fable ladder | Start with Opus 5.5; move up to Fable for "the most ambitious, open-ended technical work"; down to Sonnet or Haiku for smaller scope | same | Ladder Haiku, Sonnet, Opus, Fable |
| Q25 | Fable in Claude Code | Pays off on root cause investigations, outage debugging, architecture decisions | https://code.claude.com/docs/en/model-config#work-with-fable | Fable directly for these three |
| Q26 | Fable effort | Most gain is present at high; xhigh only where a gain is measured; max for ceiling tests | https://platform.claude.com/docs/en/build-with-claude/effort | Fable at high |
| Q27 | Fable caveat | Without an ownership statement it adds to existing structure; with "you own the codebase" it consolidates but writes 70 to 80% more output and makes unrequested changes; PR summaries omit small changes | https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-2 | State code ownership and scope in Fable briefs; review the diff, not the summary |
| Q28 | Fable as lead | Testers had good results with Fable 5.2 planning and orchestrating other models; subagents can be a large part of session cost | same | Fable can lead, with workers pinned to cheaper models |
| Q29 | Subagents and intelligence | Subagents give parallelism or fresh eyes, "not a smarter answer" | https://code.claude.com/docs/en/best-practices#know-what-subagents-cost | Choose the model for the task, not the agent count |
| Q30 | Teams | "Use Sonnet for teammates" | https://code.claude.com/docs/en/costs#agent-team-token-costs | Sonnet teammates |

Not checked in this pass: no Anthropic page gave SWE-bench Verified or SWE-bench Pro full scores for these models (a third party figure was excluded); system cards; the Sonnet 5.5 product page table (an image); the tail of the optimizing page (methodology footnotes); https://claude.com/blog/the-advisor-strategy.

## 7 · Count

- 129 sourced rows in §1 to §5: M 35, S 31, K 24, B 34, P 5 (4 current models plus 1 superseded); 30 more in §8 (Q).
- 23 distinct pages (anchors not counted separately).
