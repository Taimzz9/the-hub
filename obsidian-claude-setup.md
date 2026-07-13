# Claude + Obsidian: a second brain that writes itself

**A BW field guide** · Setup in four steps

> **What this is.** A plain walkthrough for wiring **Claude Code** into an
> **Obsidian** vault so an AI writes and organizes your notes while you just
> talk. You open Obsidian, open Claude Code inside the vault, and describe what
> happened. Claude files it in the right place, links it, and keeps your indexes
> current. You never format a note by hand again.
>
> **You do not need to know how to code.** Claude Code looks like a black
> terminal window. You type sentences into it. That is the whole skill.

---

## A reminder before you start

This tool is only as good as the thinking you bring to it. It will file, link,
and summarize faster than you ever could. It will not decide what matters, and
it will occasionally file something in the wrong place or invent a tidy summary
of a messy meeting. Read what it writes. The vault is yours; the judgment stays
yours.

Keep it honest: capture what actually happened, not what you wish had. A second
brain full of spin is worse than no notes at all.

---

## What you need

| Piece | What it is | Where |
|---|---|---|
| Claude Code | The AI you talk to, in a terminal | claude.ai/code |
| Obsidian | The note vault (plain Markdown files on your disk) | obsidian.md |
| Node.js (LTS) | Runtime the connector needs | nodejs.org |
| Obsidian-Mind | The bridge that lets Claude read and write your vault | github.com/breferrari/obsidian-mind |

Everything here is free. Your notes stay as plain files on your own computer.

---

## Step 1 · Install Claude Code

1. Go to **claude.ai/code** and download it.
2. Install it like any normal app.
3. Open it and sign in with your Anthropic or Google account.
4. You will see a terminal window. That is Claude Code. It is ready.

> The black screen with text is normal. You type into it, Claude replies. That
> is all it is.

---

## Step 2 · Install Obsidian

1. Go to **obsidian.md** and download for your operating system.
2. Install it like any normal app.
3. Open it. When it asks, choose **Create new vault** and name it anything.
   "My Brain" is fine.
4. Enable the **Local REST API** in Obsidian's settings. This is what lets
   Claude write into your vault.

> **Keep Obsidian open whenever you use Claude.** If Obsidian is closed, Claude
> cannot read or write your notes.

---

## Step 3 · Install Obsidian-Mind (the connector)

Obsidian-Mind is the bridge. Without it, Claude and Obsidian have no idea the
other exists. It also installs the folders, commands, and automations Claude
uses to file your notes.

1. **Install Node.js first** if you do not have it. Get the **LTS** version from
   **nodejs.org** and install it like any normal app.
2. Open your terminal (search "Terminal" on Mac, "Command Prompt" on Windows)
   and run:
   ```
   npm install -g shardmind
   ```
3. Create a new empty folder for your vault, open your terminal inside it, and
   run:
   ```
   shardmind install github:breferrari/obsidian-mind
   ```
4. A short setup wizard asks a few questions (your name, what you use it for).
   Answer them. About two minutes.
5. In Obsidian, choose **Open folder as vault** and select the folder you just
   created. Your vault now has all of Obsidian-Mind's folders and commands.
6. Open your terminal inside that same vault folder and run:
   ```
   claude
   ```
   Claude Code is now running inside your vault.

**From here on, the rhythm is always the same:** open Obsidian, open Claude Code
in the vault folder, start talking.

### One-time task before your first real session

Open **`brain/North Star.md`** in your vault. Write three to five bullet points
about your current goals and what you are working on. Claude reads this file at
the start of every session, so it is the single highest-leverage thing in the
whole setup. Keep it current.

---

## Step 4 · The prompts

Type these into Claude Code once your vault is connected. Replace anything in
`[brackets]` with your own words.

| When | Prompt | What it does |
|---|---|---|
| Every morning | `/om-standup` | Reads your goals, projects, and tasks and hands you a brief on what to focus on today. |
| After anything happens | `/om-dump [describe what happened in plain sentences]` | Writes the right notes into your vault automatically. You organize nothing. |
| End of every day | `wrap up` | Checks every note is linked, updates your indexes, logs wins you forgot to mention. |
| After a meeting or call | `/om-capture-1on1 [who you met and what happened]` | Writes a structured meeting note and links it to that person's file. |
| Once a week | `/om-weekly` | Looks across your whole week, spots patterns, checks your goals, surfaces wins you missed. |
| To find anything | `Search my vault for everything related to [topic, project, or person]` | Searches by meaning, not just keywords. |

Talk to it naturally. No bullet points, no formatting, no structure needed on
your end. That is Claude's job.

---

## The daily loop, in one line

**Open Obsidian → open Claude Code in the vault → `/om-standup` in the morning,
`/om-dump` through the day, `wrap up` at night.** Everything else is Claude
keeping your second brain tidy while you do the work.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Claude cannot see or write notes | Obsidian is probably closed. Open it and confirm the Local REST API is on. |
| `shardmind` or `claude` command not found | Reopen your terminal after installing, or reinstall Node.js (LTS) and run `npm install -g shardmind` again. |
| Claude ignores your goals | Your `brain/North Star.md` is empty or stale. Fill it in. |
| A note landed in the wrong place | Tell Claude in plain words. It moves and re-links it. |

---

*Adapted from Dominik Romwalter's "Claude + Obsidian Setup Guide" (AI Automation).
Rewritten as a BW field guide. Obsidian-Mind is a third-party connector; install
commands are reproduced from the original and may change as that project evolves.*
