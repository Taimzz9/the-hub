# Taimzz9 Living Docs Spine

**Version 2.0, 2026-11-22.** A documentation spine for one project or many, packaged as a Claude skill.

One status board that says what is next and how far along everything is. Status marks that keep
done items at the bottom with timestamps and evidence. Runbooks a non engineer can run by copy and
paste. Two small scripts that recompute every percent and check every link, so the numbers on the
board cannot quietly drift. A read only verifier pass that checks what the docs claim against what
is actually live.

By Taimzz9 (Taim Al-Bakri). Free under the MIT licence, see [LICENSE](LICENSE).

## What is in the box

| File | What it is |
|---|---|
| [SKILL.md](SKILL.md) | The system: modes, Part 1 (new), Part 2 (adopt), common rules C1 to C10 |
| [references/portfolio.md](references/portfolio.md) | Many projects from one repo: registry, project folders, gates, knowledge library |
| [references/templates.md](references/templates.md) | Starting text for every spine file |
| [references/automation.md](references/automation.md) | Optional Claude Code hooks, verifier agent, scheduled and CI checks |
| [references/evals.md](references/evals.md) | Test scenarios for the skill itself |
| `scripts/check-docs.sh`, `scripts/check-docs.ps1` | Link, anchor and table checker |
| `scripts/spine-status.sh`, `scripts/spine-status.ps1` | Percent recompute and board comparison |
| `scripts/hook-check-docs.sh` | Optional Claude Code hook: runs the checker after every `.md` edit |
| [research.md](research.md) | Every rule's source, field evidence, and the v1 to v2.0 change table |
| [LICENSE](LICENSE) | MIT |

The scripts are read only, need no network and no installs: bash with awk (Linux, macOS, Git Bash
on Windows) or Windows PowerShell 5.1 and later.

## Install

**Claude Code, all projects:** copy the folder to `~/.claude/skills/taimzz9-living-docs-spine/`
(Windows: `%USERPROFILE%\.claude\skills\taimzz9-living-docs-spine\`). Skills are picked up without a
restart. For one project only, use `.claude/skills/` inside the repo.

```bash
mkdir -p ~/.claude/skills
unzip taimzz9-living-docs-spine-v2.0.zip -d ~/.claude/skills/
# or straight from GitHub:
git clone https://github.com/Taimzz9/taimzz9-living-docs-spine ~/.claude/skills/taimzz9-living-docs-spine
```

The zip is attached to each release on GitHub.

**claude.ai:** Settings, Capabilities, Skills, upload the zip. The zip must hold the folder
`taimzz9-living-docs-spine/` at its root. If an older version is listed, remove it first so two
versions do not compete. The listing should show a description starting "v2.0 ·".

Skills in claude.ai and in Claude Code do not sync with each other; install in each place you use.

## Use

```
/taimzz9-living-docs-spine            the skill picks the mode
/taimzz9-living-docs-spine check      run both scripts, report, change nothing
```

| Mode | When |
|---|---|
| `new` | No status board and few docs. Sets the system up from nothing |
| `adopt` | Architecture, conventions and many docs already exist. Builds the spine around them without a rewrite |
| `update` | Already on the system. Applies the common rules to the change in front of it, then checks |
| `project` | Start or close one project or task in a multi project spine |
| `check` | Runs the two scripts and reports drift, broken links and broken tables. Edits nothing |
| `verify` | Read only. `check`, then every claim against live state, with evidence |

Run the scripts yourself any time:

```bash
bash scripts/check-docs.sh /path/to/repo
bash scripts/spine-status.sh /path/to/repo
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\check-docs.ps1 -Root D:\repo
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\spine-status.ps1 -Root D:\repo
```

## The idea behind it

Most documentation rots because status lives in several places at once and none of them agree. The
spine fixes the count rather than the prose: one place holds status, every other document links to
it, percent is computed from status marks rather than estimated, and nothing is marked done without
evidence quoted underneath it.

Version 2.0 came from using version 1 on a real repo for several projects at once. The rules held;
the numbers did not. Typed by hand, two of four board rows had drifted within a day, one table had
lost cells, and link counts were quoted from memory. So the counting moved into scripts, and the
skill gained what had been invented on top: a projects registry, project gates, a knowledge library,
and rules for several sessions sharing one folder. [research.md](research.md) lists every change
and its source.

The mistakes table at the end of the common rules (C8) is worth reading first. Each row is a real
mistake next to the rule that now prevents it.

## Changelog

### 2.0 · 2026-11-22

- **Added:** modes `project` and `check`; bundled scripts `check-docs` and `spine-status` (bash and PowerShell); C9 changelog and decisions; C10 several sessions in one folder; references for portfolio layout, templates, automation and evaluations; `research.md`.
- **Changed:** percent counts in progress and delegated items at 20% (the 20/80 rule) instead of half, with the weight as a script option; percent is recomputed by script and compared with the board; fixed Status line format; blocked items name their unblocker; work in progress limit; mistakes table gains 4 rows; Diátaxis column in adopt; version first in the description; `license` in the frontmatter; author spelled Al-Bakri.
- **Kept:** Part 1 and Part 2 flow, status marks, ordering, nav footer, runbook format, verifier format, writing rules.

### 1.0

- First public release: modes new, adopt, update, verify; common rules C1 to C8. Release date not recorded here.

## Credit and changes

Use it, change it, ship it in your own work, commercially or not. The MIT licence asks only that the
copyright notice travels with it.

Found a case it handles badly, or improved it? Tell me: info@biwize.ca

---

Featured in the BiWize AI Cheat Sheet: <https://biwize.ca/aics/>. Source on GitHub under MIT: <https://github.com/Taimzz9/taimzz9-living-docs-spine>.
