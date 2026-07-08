---
name: siemens-ppt-gen
description: General-purpose Siemens-branded PowerPoint slide formatting skill. Use whenever generating any Siemens presentation. Covers slide archetypes, JSON schema, color constants, typography, and strict content rules. Deck-type-agnostic — specific deck structures (section order, content requirements) live in the agent, not here.
---

# Siemens PowerPoint Generator — Formatting Skill

Read `BRANDING.md` before using this skill. All colors, typography, and layout measurements
come from there. This skill defines the slide archetypes, JSON schema, and content rules
that apply to every Siemens deck regardless of type.

---

## Color constants (quick reference)

| Constant | Hex | Use |
|---|---|---|
| `BG` | `#000028` | Background — all slides |
| `WHITE` | `#FFFFFF` | Primary text, headlines |
| `PETROL` | `#009999` | Kicker / eyebrow, accent bars |
| `GREEN` | `#00FFB9` | Highlight words, section numbers, stat values |
| `TEAL` | `#00D7A0` | Secondary accent |
| `CYAN` | `#00BEDC` | Tertiary accent |
| `DARK_PETROL` | `#00557C` | Table header fill |
| `GRAY` | `#B3B3BE` | Body / secondary text |
| `DIM` | `#66667E` | Footer text |
| `CARD` | `#0C0C3C` | Card fill on BG |

---

## Slide archetypes — JSON schema

Claude returns a JSON object `{ "meta": {...}, "slides": [...] }`.
Each slide in `slides[]` has a `type` field; remaining fields depend on the type.

### `title_slide`
```json
{
  "type": "title_slide",
  "title": "Main title text",
  "title_accent": "key phrase",
  "subtitle": "Subtitle line in gray",
  "meta": "Version | Date or any short meta line"
}
```
- `title` rendered White 48 pt bold; `title_accent` (a substring of title) rendered Bold Green
- `subtitle` Gray 19 pt; `meta` Petrol 12 pt bold

### `section_slide`
```json
{
  "type": "section_slide",
  "number": "01",
  "title": "Section Name",
  "subtitle": "Optional one-line context"
}
```
- Giant `number` in Bold Green 100 pt bold; `title` White 40 pt bold; `subtitle` Gray 15 pt
- `number` must be zero-padded two digits: "01", "02", "03", etc.

### `content_slide`
```json
{
  "type": "content_slide",
  "kicker": "SECTION NAME",
  "headline": "Action title asserting the slide's key finding",
  "body": { ... }
}
```
- `kicker` ALL-CAPS in Petrol 11 pt bold
- `headline` White 24–26 pt bold — must be a complete assertion, not a topic label
- `body` is one of the body formats below

### `closing_slide`
```json
{
  "type": "closing_slide",
  "title": "Questions?",
  "subtitle": "Optional subtitle"
}
```
- Same layout as `title_slide` — dark bg, large White title, subtitle Gray

---

## Body formats for `content_slide`

### `bullets` — plain bulleted list
```json
{
  "format": "bullets",
  "items": ["Bullet one", "Bullet two", "Bullet three"]
}
```

### `numbered` — numbered list
```json
{
  "format": "numbered",
  "items": ["First item", "Second item"]
}
```

### `table` — data table
```json
{
  "format": "table",
  "headers": ["Column A", "Column B", "Column C"],
  "rows": [
    ["Row 1 A", "Row 1 B", "Row 1 C"],
    ["Row 2 A", "Row 2 B", "Row 2 C"]
  ]
}
```
- Table header fill: Dark Petrol `#00557C`; body rows: Card `#0C0C3C`, alternating

### `two_columns` — two side-by-side text columns
```json
{
  "format": "two_columns",
  "left_header": "Left Column Title",
  "left_items": ["item", "item"],
  "right_header": "Right Column Title",
  "right_items": ["item", "item"]
}
```

---

## Layout constants

| Property | Value |
|---|---|
| Slide width | 13.333 in |
| Slide height | 7.5 in |
| Left margin | 0.6 in |
| Kicker y | 0.48 in |
| Headline y | 0.82 in |
| Content area y start | ~1.75 in |
| Content area height | ~5.0 in |
| Footer y | 7.18 in |

---

## Local Python build (Claude Code)

When building locally with `sieppt.py`:

```python
import sys, os
sys.path.insert(0, os.path.expanduser("~/.claude/skills/siemens-ppt/lib"))
from sieppt import Deck, C

d = Deck(footer_author="Author Name",
         footer_dept="DEPT",
         footer_date="2026-07")
```

Slide methods: `d.title_slide()`, `d.section_slide()`, `d.content_slide()`, `d.finish()`, `d.closing_slide()`

Components (place after `content_slide`, before `finish`):
`d.table()`, `d.timeline()`, `d.takeaway()`, `d.layer_stack()`, `d.kpi_row()`, `d.progress_compare()`, `d.code_box()`

Always call `d.finish(slide)` on every content slide to add the footer and SIEMENS wordmark.

Assets (in `~/.claude/skills/siemens-ppt/assets/`):
- `infinity_gradient.png` — Siemens infinity motif (cover/closing right side)
- `siemens_logo_white.png` — SIEMENS wordmark (dark slides)
- `siemens_logo_petrol.png` — SIEMENS wordmark (light slides)

---

## Content rules (apply to all deck types)

- **Action titles only** — every `headline` must be a complete sentence asserting a finding, not a label
- **No card grids** — never produce a card_grid; restructure as bullets, tables, or numbered lists
- **No emojis** — strip any emoji from all text before rendering
- **Bold Green is a highlight, not fill** — 1–2 words max per slide, section numbers, key stats only
- **One idea per slide** — split content across two slides rather than crowding one
- **Kickers are ALL-CAPS** — "GENERAL UPDATES", "MONTHLY METRICS", "FINDINGS"
- **Placeholders required** — if source data is absent for a planned section, create a placeholder rather than omitting it
- **Never mix Brightly and Siemens branding** — no `#003359`, `#45FF9B`, Calibri, or Brightly wordmark
