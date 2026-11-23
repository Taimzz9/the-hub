# Skills

Claude Code skills by **Taim Al-Bakri (Taimzz9)**. Free under the MIT licence, see [LICENSE](LICENSE).

| Skill | What it does |
|---|---|
| [taimzz-delegation-law](taimzz-delegation-law/) | Plans and delegates multi step coding or research work: breaks the task down first, sends each subtask to the model and effort that suits it, runs independent work in parallel on disjoint files, gives every subtask one pass or fail check, and reads subagent reports instead of reopening files |
| [taimzz9-ui-law](taimzz9-ui-law/) | UX and interface rulebook: a measurable accessibility baseline, a visual system, button, action and flow rules, dashboard and report rules, and 30 usability laws with their real evidence strength. Build mode and review mode |
| [taimzz9-living-docs-spine](taimzz9-living-docs-spine/) | Living documentation system for one project or many: a status board that recomputes itself, status marks with evidence, cross linked docs checked by a bundled script, runbooks, and a read only verifier pass |

Each skill carries its sources. `taimzz-delegation-law` and `taimzz9-living-docs-spine` have a `research.md` listing every rule, where it came from, and how strong the evidence is.

## Install

**All projects:** copy a skill folder to `~/.claude/skills/<skill-name>/` (Windows: `%USERPROFILE%\.claude\skills\<skill-name>\`). Skills are picked up without a restart.

**One project only:** copy it to `.claude/skills/<skill-name>/` inside the repo.

```bash
mkdir -p ~/.claude/skills
cp -r skills/taimzz9-ui-law ~/.claude/skills/
```

## Licence

MIT, see [LICENSE](LICENSE). Each skill folder also carries its own copy, so a folder stays licensed when it is copied out on its own.
