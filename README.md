# BSW PPT Generator

Browser-based tool for generating Brightly-branded LST Monthly Global Support
Team Meeting PowerPoint decks. No install, no terminal, no Python required.

**Live app:** https://imm-si-bs.github.io/bsw-ppt-generator/

---

## How to use the app

1. Open the link above in any browser
2. Fill in the form — meeting title, type, notes
3. Upload source files (transcripts, CSV metrics, notes)
4. Click **Generate Deck**
5. Download the `.pptx` directly to your computer

---

## Where to make edits

### Editing the web app (form, layout, buttons, output)
**File:** `index.html` in the repo root

Edit it directly on GitHub (click the file → pencil icon) or clone the repo
and open it in VS Code. Commit and push to `main` — the live app updates in
~60 seconds.

### Editing what Claude is instructed to do
**Files:**
- `agents/bsw-ppt-builder.md` — deck structure, section order, content rules
- `skills/bsw-ppt/SKILL.md` — slide archetypes, layout dimensions, components
- `skills/bsw-ppt/BSWBRANDING.md` — colors, typography, brand rules

Edit these files in this repo. Because the web app fetches them fresh on every
page load, **your changes are live immediately after pushing to `main`.**
No code changes, no redeployment.

> **Also using Claude Code locally?**
> After editing agent/skill files here, run `sync-to-claude.bat` (in the repo
> root) to copy the updated files to `~/.claude/` so your local Claude Code
> session picks up the changes too.

### Adding or editing the sync script
**File:** `sync-to-claude.bat` in the repo root

This is a Windows batch file. Double-click it after editing agent/skill files
to copy them to `C:\Users\z00589ff\.claude\` automatically.

---

## Repo structure

bsw-ppt-generator/
index.html              ← web app (edit this to change the UI)
CLAUDE.md               ← full technical spec for AI-assisted development
README.md               ← this file
sync-to-claude.bat      ← copies agent/skill files to local ~/.claude/

agents/
bsw-ppt-builder.md    ← agent instructions (edit to change deck behavior)

skills/
bsw-ppt/
SKILL.md            ← slide archetypes and layout rules
BSWBRANDING.md      ← brand colors, fonts, layout spec



---

## What's NOT in this repo

These files only work locally (Python/PowerShell) and are never needed by the
browser app:

- `bswppt.py` — the Python library that builds .pptx files locally
- `assets/` — brand images used by the Python library
- `Brightly Theme.pptx` — the PowerPoint template

---

## Technical details

See `CLAUDE.md` for the full architecture, JSON schema, API config, and
rendering rules.
