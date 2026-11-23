# Automation in Claude Code (optional)

Part of [taimzz9-living-docs-spine](../SKILL.md) v2.0. Everything here is **Claude Code only**: hooks,
subagents, scheduled tasks and `${CLAUDE_SKILL_DIR}` do not exist in claude.ai chat (`A8`, `A11`,
`A17`). Nothing here is installed by the skill; the owner chooses. The PostToolUse hook (§2) was
tested; the verifier agent, scheduled task and CI snippets were written from the docs and **not
run**; test one before relying on it.

## Contents

1. Put the scripts where hooks and CI can reach them
2. Hook: link and table check after every edit
3. Why not a blocking Stop hook
4. Verifier subagent
5. Scheduled checks
6. Considered and not used

## 1 · Put the scripts where hooks and CI can reach them

Hooks and CI cannot see `${CLAUDE_SKILL_DIR}`. Copy the scripts into the repo, for example
`tools/spine/` (or keep the skill folder itself in the repo), and commit them, so every person, session and CI run uses the same version. Project
settings in `.claude/settings.json` are shared through the repo; `.claude/settings.local.json` is
personal (`A21`).

## 2 · Hook: link and table check after every edit

`scripts/hook-check-docs.sh` reads the hook input, runs `check-docs` only when a `.md` file was
edited, stays silent when clean, and otherwise writes the problem lines (at most 20) to stderr with
exit 2. `.claude/settings.json`, with the path to wherever the scripts live in the repo:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/tools/spine/hook-check-docs.sh\""
          }
        ]
      }
    ]
  }
}
```

**Tested 2026-11-22** in the author's repo (Windows 11, Claude Code desktop, Git Bash): a planted
broken link in a `.md` file was reported to Claude right after the edit with file and line; removing
it cleared the feedback; a non `.md` edit stayed silent; about 1.8 s per run on 72 files.

| Fact | Source |
|---|---|
| `Edit\|Write` matches those two tools exactly | `A2` |
| On PostToolUse, exit 2 does not block; stderr is shown to Claude as feedback | `A4` |
| On Windows without Git Bash, hooks can run with `"shell": "powershell"`; then call `check-docs.ps1 -Root` instead | `A7` |
| Edits to hooks apply to the running session without a restart | `A23` |
| In a git worktree `$CLAUDE_PROJECT_DIR` stays at the original root, so the hook checks the main checkout, not the worktree | `A25` |

The check covers the whole repo, so drift in files another session owns shows up in every edit's
feedback. Fix it, or hand it to the owner of those files (C10).

## 3 · Why not a blocking Stop hook

A Stop hook that exits 2 keeps Claude working until the check passes (`A3`). In a folder shared by
several sessions, a broken link in a file this session does not own can never be fixed by it, so the
session would loop. Use a blocking Stop hook only in a single session repo, and prefer the
PostToolUse feedback above. House

## 4 · Verifier subagent

`.claude/agents/spine-verifier.md`, shared with the project (`A15`):

```markdown
---
name: spine-verifier
description: Read only verifier for a living docs spine. Checks what HOME, PLAN, project files and runbooks claim against the files and live state. Use at a milestone or when asked whether the docs are true.
tools: Read, Grep, Glob
model: sonnet
---

You verify; you never edit or fix. The brief contains the output of check-docs and spine-status.
For each claim you are given, answer exactly:
VERDICT: confirmed / contradicted / no evidence found
EVIDENCE: quote, file:line, command output or source URL. No paraphrase.
CONFIDENCE: high / medium / low
COULD NOT CHECK: anything out of scope, missing or unreachable
End with a table: file:line | what the evidence says.
```

| Choice | Source |
|---|---|
| No Write, Edit or Bash in `tools`, so it cannot change anything; the caller runs the scripts and pastes the output into the brief | `A14` |
| A fresh context agent suits a read only audit; fixes stay in the main conversation | `A16` |
| `model: sonnet` | House (evidence checking needs judgment, not code) |

## 5 · Scheduled checks

| Option | Fits | Source |
|---|---|---|
| Desktop scheduled task, weekly: "run the spine `check` mode on <repo> and report" | Local files, machine on; sees uncommitted work | `A17` |
| Cloud scheduled task | Sees only the committed repo, fresh clone each run | `A17` |
| `/loop` | Needs an open session; expires; not for weekly work | `A17`, `A18` |
| CI job running the bash scripts on push, no model needed | Repos with a remote and CI | `A19`, `D5` |

Minimal CI job (GitHub Actions, not run here):

```yaml
name: docs
on: [push, pull_request]
jobs:
  spine:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: bash tools/spine/check-docs.sh .
      - run: bash tools/spine/spine-status.sh .
```

## 6 · Considered and not used

| Idea | Why not | Source |
|---|---|---|
| `` !`script` `` in SKILL.md to inject the numbers when the skill loads | Claude Code only; a non zero exit aborts the skill, and both scripts exit 1 on drift; claude.ai would show the raw text | `A13`, `K11` |
| `hooks:` in the SKILL.md frontmatter | Run only after the skill is invoked and vanish on `/clear`; not always on; and claude.ai upload may reject the key | `A8`, `K7` |
| Status line showing percent done | Possible (a status line runs any script), but its input fields were not checked | `A20` |
| External link checker (lychee) | Strong tool with offline and anchor modes, but an install; the bundled scripts need none. Use lychee in CI if web links matter too | `D20`, `D21` |

<!-- nav -->
---
**Related:** [Skill](../SKILL.md) · [Portfolio](portfolio.md) · [Templates](templates.md) · [Research](../research.md)
