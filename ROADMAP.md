# BSW PPT Generator — Project Roadmap & Implementation Plan

> **Living reference document.** Update this file as decisions are made or priorities shift.
> Add this to the project root as `ROADMAP.md` after approval so it survives across Claude sessions.

---

## Context

Following a demo with Isabella's manager, three action items were agreed in priority order:

1. **Usability** — surface file uploads earlier, reorganize the form, add contextual guidance
2. **Presentation quality** — real Siemens template fidelity + more slide layout variety
3. **New deck types** — team meeting agent, executive/QBR agent (after P1 + P2 complete)

The app is a single `index.html` (no build, no server, GitHub Pages). Behaviour is controlled by three categories of files: `index.html` (rendering + UI), `skills/siemens-ppt-gen/SKILL.md` + `BRANDING.md` (what Claude knows about slide design), and `agents/*.md` (deck-type-specific instructions + structure). Changing skill/agent files changes Claude's output with no code changes required.

---

## What I know about the current codebase (research findings)

### index.html — key facts for all priorities

- **Form layout**: Section A (topic, deck type selector) → Section B (goals textarea, raw-notes textarea, section-outline textarea with field-hint, **file upload zone LAST**).
- **PptxGenJS 3.12.0** (CDN). Four `defineSlideMaster()` calls define `SIEMENS_TITLE/CONTENT/SECTION/CLOSING` — but no slide actually references them by master name; they exist only so users can add slides in PowerPoint. Slides are built imperatively via `buildTitleSlide`, `buildSectionSlide`, `buildContentSlide`, `buildClosingSlide`.
- **Layout variety is extremely thin**: 4 slide shells × 7 body formats (`bullets`, `numbered`, `table`, `two_columns`, `agenda`, `kudos`, `nps_names`). Every content slide uses the identical positional template (kicker y=0.48, headline y=0.82, content area y=1.75 → 12.1×5.0 in). No visual weight variation exists.
- **`sieppt.py` is irrelevant to the web app** — it's a local Python library for Claude Code users. The web app has no Python runtime. Layout improvements are about expanding the web app's own JavaScript rendering capability, not parity with any local tool.
- **Other CDN libs**: mammoth 1.6.0 (docx), JSZip 3.10.1 (pptx extraction + **future template injection**), pdfjs-dist 3.11.174.
- **Existing guidance elements**: only `section-outline` has a `field-hint` block; all other fields use placeholder text only. No tooltips (`title` attributes) except the file chip remove button.

### Skills/agents — key facts

- `BRANDING.md` states it is "derived from the official Siemens O365 PowerPoint template" but no template file is referenced or accessible from the repo.
- `sieppt.py` is mentioned in SKILL.md as a local Claude Code tool only — it has no bearing on the web app, which uses JSON-driven PptxGenJS rendering exclusively.
- Both agents (lst-meeting-builder, siemens-ppt-builder) are well-structured; lst-meeting-builder has a rigid 17-slide section order and a detailed topic placement rule table.

### Siemens template research — critical findings

**PptxGenJS cannot load templates.** Confirmed from source: no `loadPresentation`, `useTemplate`, or `fromFile` API exists. This is a hard limit, not a configuration option.

**The template file is a `.thmx` (Office Theme), not a `.pptx`.** This is actually simpler to inject than a full .pptx master:
- A `.thmx` is a ZIP containing one key file: `theme/theme.xml`
- `theme.xml` contains: font scheme (Siemens Neue as heading font), color scheme (official named palette), format scheme (fills/lines/effects)
- It does **not** contain slide masters, slide layouts, or embedded images (infinity motif, logo)
- Injecting it: replace `ppt/theme/theme1.xml` in the PptxGenJS output with `theme/theme.xml` from the `.thmx`

**What `.thmx` injection gives you:**
- ✅ Siemens Neue font referenced as heading font (renders correctly for users who have it installed)
- ✅ Official Siemens named color palette in PowerPoint's color picker
- ✅ Correct theme effects and format scheme
- ❌ Not: infinity motif (stays as gradient rect proxy), not: logo raster image, not: slide master geometry (stays hand-coded in `defineSlideMaster()`)

**Why this is still worth doing:** Opens in PowerPoint with correct Siemens brand font + color scheme metadata. Much simpler than full master injection — ~50–80 lines of JS vs. ~200–300, and no relationship ID reconciliation.

**No public Siemens templates exist.** All brand portal URLs return 404. The `.thmx` file must come from the team's internal toolkit.

**docxtemplater** is an alternative but is incompatible with Claude's dynamic N-slides architecture (it requires pre-built template slides with `{placeholder}` tags).

---

## Priority 1: Improve Application Usability

### Goal
Lower the barrier for non-technical users to provide good inputs. The file upload zone should be the first thing users see in Section B. Every important field needs guidance text, not just placeholder text.

### What was built ✅

**Section B field order** (top to bottom):
```
Section B
  ├── Supporting files (upload zone)   ← moved to top
  ├── What should this deck cover?     (goals)
  ├── Raw notes, emails, or transcripts (raw-notes)
  └── Already have notes for a specific section? (section-outline)
```

**Field hints** added to all Section B fields. Each field has a `<p class="field-hint">` below the label, and a paired `field-tip-callout` sidebar with distinct, non-redundant advice:

- **Supporting files** — field hint describes accepted file types and instructs users to add per-file notes; sidebar explains *why* context matters (Claude can't tell what a file is or where it belongs without it)
- **What should this deck cover?** — field hint covers purpose, audience, tone, what to lead with, runtime, and slide count; sidebar focuses on how to give direction like a briefing (name a win, specify ordering and feel)
- **Raw notes / transcripts** — field hint covers what to paste and where file-form transcripts should go instead; sidebar explains *why* raw text beats a cleaned-up summary (specific names, numbers, quotes survive; summaries lose them)
- **Section outline** — field hint covers which section to name, format choice, and verbatim vs. embellish; sidebar explains the verbatim/embellish/default distinction specifically

**Collapsible "Tips for better results" panel** at the top of the form (collapsed by default):

- Good/bad input comparison table — each row includes a reason *why* it works or fails, not just an example label
- Prompt examples with "Result:" lines — shows what Claude actually produces in each case, not just what the prompt looks like
- No emojis anywhere in the tips panel or field callouts

**Removed from tips panel:**
- "Upload a metrics CSV" row (originally in the good/bad table) — removed because the file upload field hint now handles CSV-specific guidance in context

### Files modified
- `index.html` — Section B field reorder, field-hint blocks, field-tip-callout sidebars, collapsible tips panel, upload zone visual improvements

---

## Priority 2: Improve Presentation Quality

### Goal
Close the visual gap between what `sieppt.py` produces locally and what the web app produces. Two parallel tracks: (A) real Siemens template fidelity via JSZip injection, and (B) expanded slide layout vocabulary.

---

### Track A — Siemens `.thmx` Theme Injection

> **Prerequisite**: The Siemens O365 `.thmx` theme file (an Office Theme file, not a full `.pptx`). It cannot be committed to the public repo per CLAUDE.md.
>
> **Status**: Unblocked — Isabella is providing the `.thmx` file. Much simpler than full master injection (~50–80 lines JS, no relationship ID reconciliation needed).

**What a `.thmx` is**: A ZIP containing `theme/theme.xml`. That XML holds the Siemens font scheme (Siemens Neue as heading), official named color palette, and format scheme. It does *not* contain slide masters, layouts, or embedded images — those stay hand-coded via `defineSlideMaster()`.

**Step 1 — Add optional "Siemens .thmx theme" upload field to Section A** (`index.html`)

Add a small, visually distinct file input in Section A specifically for the theme file. Label: "Siemens brand theme (optional — .thmx file, improves font + color fidelity in PowerPoint)". Accepts `.thmx` only, single file. If not provided, generation proceeds unchanged. Store the ArrayBuffer in `uploadedTheme` (not in `uploadedFiles`).

**Step 2 — Implement `extractSiemensTheme(thmxBuffer)`** (`index.html` JS, ~20 lines)

```javascript
async function extractSiemensTheme(thmxBuffer) {
  const zip = await JSZip.loadAsync(thmxBuffer);  // JSZip already loaded
  return await zip.file('theme/theme.xml').async('string');
}
```

**Step 3 — Implement `injectSiemensTheme(generatedBuffer, themeXml)`** (`index.html` JS, ~30 lines)

```javascript
async function injectSiemensTheme(generatedBuffer, themeXml) {
  const zip = await JSZip.loadAsync(generatedBuffer);
  zip.file('ppt/theme/theme1.xml', themeXml);  // replace PptxGenJS default theme
  return await zip.generateAsync({ type: 'arraybuffer' });
}
```

No relationship ID changes needed — `ppt/theme/theme1.xml` is referenced by path in the master XML, not by rId, so a straight file replacement works.

**Step 4 — Wire into generation pipeline** (`index.html`, after `pptx.write()`)

```javascript
let outputBuffer = await pptx.write({ outputType: 'arraybuffer' });
if (uploadedTheme) {
  const themeXml = await extractSiemensTheme(uploadedTheme);
  outputBuffer = await injectSiemensTheme(outputBuffer, themeXml);
}
// trigger download from outputBuffer
```

**Step 5 — Visual QA**
Open the generated `.pptx` in PowerPoint. Check: (1) Design → Themes shows Siemens theme applied, (2) font picker shows Siemens Neue as heading font, (3) color picker shows official Siemens named colors. No broken relationship errors.

**Future upgrade path**: If a full Siemens `.pptx` master ever becomes available, the same insertion point (Step 4) can be upgraded to the full master injection approach without changing the surrounding architecture.

---

### Track B — Expand Slide Layout Vocabulary

> This track is independent of Track A and should proceed regardless of template availability. The current web app has only one effective layout geometry for all content — this is the track that changes that.

**New slide types to add** (selected for max visual storytelling impact):

| New type | Description | Use case |
|---|---|---|
| `stat_slide` | 1–3 large KPI numbers with labels; no bullet body | Metrics highlight, opening impact |
| `quote_slide` | Single large pull-quote with attribution; Deep Blue bg, quote in Bold Green | Customer voice, executive endorsement |
| `takeaway_slide` | Single bold assertion centered on slide; used as "landing slide" after data | Close a data-heavy sequence, key message |
| `two_col_content` | Side-by-side content blocks with distinct visual headers (improves on current `two_columns`) | Comparison, before/after, parallel streams |

**Step 1 — Extend SKILL.md JSON schema** with new type definitions and example JSON for each. Add guidance on when Claude should choose each type vs. `content_slide`.

**Step 2 — Add rendering functions to index.html**:
- `buildStatSlide(pptx, s, pageNum, meta)` — large numbers (60–80pt Bold Green), labels below (14pt Gray), up to 3 stats in a horizontal row
- `buildQuoteSlide(pptx, s, pageNum, meta)` — quote text (28pt bold white, centered), attribution (14pt Petrol, right-aligned below)
- `buildTakeawaySlide(pptx, s, pageNum, meta)` — single assertion (36pt bold white, vertically centered), optional sub-label (16pt Petrol below)

**Step 3 — Update BRANDING.md** with layout geometry for each new type (x/y/w/h values, font sizes, color rules).

**Step 4 — Update both agent files** to instruct Claude when to use each new type:
- `siemens-ppt-builder.md`: Use `stat_slide` for metrics-heavy sections; use `takeaway_slide` to close a data-heavy sequence; use `quote_slide` for customer voice or executive endorsements
- `lst-meeting-builder.md`: Use `stat_slide` as an alternative opener for the Monthly Metrics section; use `takeaway_slide` for What's Coming key message

### Files modified (Track B)
- `skills/siemens-ppt-gen/SKILL.md` — new type definitions in JSON schema
- `skills/siemens-ppt-gen/BRANDING.md` — layout geometry for new types
- `agents/lst-meeting-builder.md` — guidance on when to invoke new types
- `agents/siemens-ppt-builder.md` — same
- `index.html` — new `buildStatSlide`, `buildQuoteSlide`, `buildTakeawaySlide` functions

### Verification (both tracks)
1. **Track A**: Generate a deck with a real Siemens template uploaded. Open in PowerPoint → View → Slide Master. Confirm Siemens master is present with infinity motif and correct fonts. Confirm no "#" or broken relationship errors when opening.
2. **Track B**: Generate a deck from a prompt that would naturally invoke a stat slide and a quote slide. Confirm correct rendering, correct font sizes, and correct color assignments.
3. Sync updated skill/agent files via `sync-to-claude.bat` so local Claude Code path also benefits.

---

## Priority 3: Additional Presentation Types

> **Do not begin P3 until P1 and P2 are complete.** These depend on a stable, quality foundation.

### 3A — Team Meeting Presentation Agent

**Architecture decision (agent vs. skill):**

Recommendation: **two separate agents, not an agent + skill**. Here's why:
- The existing `lst-meeting-builder.md` is an **agent** with a rigid fixed section order — that rigidity is intentional for the LST meeting format. Making it a skill would make it harder to invoke precisely.
- A "generic team meeting" generator has a different structure (no fixed 6-section order, no metrics table, no kudos) — it should be its own agent with its own instructions.
- In the web app dropdown, the user selects the deck type → the correct agent is fetched. This works cleanly with the current architecture.
- When using Claude Code locally and the user says "I want to build a PPT for the Global Support Meeting", Claude invokes `lst-meeting-builder` agent. For a different team meeting, it invokes the new generic `team-meeting-builder` agent.

**New file**: `agents/team-meeting-builder.md`
- References `SKILL.md` and `BRANDING.md` (same as other agents)
- Flexible section structure (not fixed) — Claude derives structure from source material
- Supports all current + new (P2 Track B) slide types
- Targeted at internal team meetings that aren't the LST global meeting (product team, engineering, department all-hands)

**Web app changes**: Add "Team Meeting" option to the deck type dropdown in Section A.

### 3B — Executive / QBR Presentation Agent

> **Blocked** until Nick shares QBR examples and reporting/visualization approaches used internally.

**When unblocked**, new file: `agents/executive-qbr-builder.md`
- Heavily metrics-oriented
- Will lean on `stat_slide` and `takeaway_slide` types from P2 Track B
- May introduce a `chart_slide` type if the dataviz skill provides a viable browser-side rendering path
- Narrative arc structure: situation → data → insight → recommendation → ask

**Web app changes**: Add "Executive / QBR" option to dropdown.

---

## On Multi-Agent Orchestration

**For the web app (runtime)**: Multi-agent orchestration is not applicable. The app makes a single Claude API call per generation. Splitting into multiple sequential calls would increase latency, cost, and failure surface without meaningful quality benefit given the 8192-token output window.

**For development (building the app)**: The `multi-agent-orchestration` skill and related tools (e.g., spawning parallel agents to work on SKILL.md + index.html simultaneously) could accelerate implementation of P2 Track B where multiple files change in parallel. This is optional — the tasks are related enough that sequential implementation with this ROADMAP.md as context is simpler and less error-prone.

**Recommendation**: Do not use multi-agent orchestration for this project's runtime. For development, use it selectively only for P2 Track B where SKILL.md, BRANDING.md, two agent files, and index.html all need coordinated updates.

---

## How to use this document going forward

1. **This file should be committed to the project root as `ROADMAP.md`** at the end of this session. It will live at `bsw-ppt-generator/ROADMAP.md` and be version-controlled alongside the codebase.
2. At the start of each Claude session working on this project, read this file before touching any other file
3. Work priorities in order: P1 → P2 Track B → P2 Track A (if template available) → P3A → P3B
4. Check off sub-steps as they are completed by updating the status here
5. Update the "open questions" section as answers are resolved

### Open questions to resolve before implementation

| # | Question | Blocks |
|---|---|---|
| Q1 | ~~Template file?~~ **RESOLVED**: `Siemens.thmx` is in the repo root. It is a `.thmx` Office Theme (font scheme + color scheme), not a full `.pptx` — injection is ~60 lines of JS via JSZip, no rId reconciliation needed. | P2 Track A ✅ |
| Q2 | Should P2 Track A require the user to upload the `.thmx` every time, or should it be a one-time setup? | P2 Track A UX |
| Q3 | For the team-meeting agent (P3A): what team/audience scope should it cover? Any internal Siemens/Brightly team, or specifically LST-adjacent support teams? | P3A scope |
| Q4 | Nick's QBR examples — what format will they arrive in? | P3B start |

### Status tracker

| Priority | Track | Status |
|---|---|---|
| P1 — Usability | Form reorder + guidance | ✅ Complete (2026-07-09) |
| P2 — Quality | Track A: Siemens theme injection | 🔶 Built + working (2026-07-09) — visual tuning needed. Both paths (thmx OOXML and PptxGenJS fallback) confirmed opening cleanly. Next: compare outputs visually and decide what to keep from each. |
| P2 — Quality | Track B: Expanded layout types | ⬜ Not started |
| P3 — New types | 3A: Team meeting agent | ✅ Complete (2026-07-14) — `agents/team-meeting-builder.md` created; wired into dropdown + AGENT_URLS |
| P3 — New types | 3B: Executive/QBR agent | ✅ Complete (2026-07-14) — `agents/executive-qbr-builder.md` created (best-practices QBR arc); wired into dropdown + AGENT_URLS. Can be refined once Nick shares examples. |
