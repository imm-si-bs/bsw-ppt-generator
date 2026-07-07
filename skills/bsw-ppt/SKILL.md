# BSW PowerPoint Builder Skill

Build Brightly Software (BSW) branded PowerPoint decks from source material using
`bsw-ppt/lib/bswppt.py`. Read `bsw-ppt/BSWBRANDING.md` before writing any code.

## Quick reference

```python
import sys, os
sys.path.insert(0, os.path.expanduser("~/.claude/skills/bsw-ppt/lib"))
from bswppt import Deck, C

d = Deck(footer_author="LST Global Support",
         footer_dept="SUPPORT OPS",
         footer_date="2026-06")
```

## Slide archetypes

| Method | When to use |
|---|---|
| `d.title_slide(title_runs, subtitle, meta)` | Cover slide |
| `d.section_slide(number, title, subtitle, green=False)` | Section dividers |
| `d.content_slide(kicker, headline_runs, headline_size)` | Every content slide |
| `d.finish(slide)` | Must call on every content slide to add footer + logo |
| `d.closing_slide(title_runs, subtitle, meta)` | Questions and Thank You slide |

## Components (call after `content_slide`, before `finish`)

| Method | Purpose |
|---|---|
| `d.table(slide, data, y, col_widths, row_h)` | Branded data table |
| `d.timeline(slide, phases, y)` | Horizontal chevron timeline |
| `d.takeaway(slide, runs, y)` | Bottom "so what" accent strip |
| `d.layer_stack(slide, layers, y, w)` | Stacked architecture layers |
| `d.box(slide, x, y, w, h, runs, size)` | Raw text box |
| `d.rect(slide, x, y, w, h, fill)` | Raw filled rectangle |
| `d.gradient_bar(slide, x, y, w, h, c1, c2)` | Teal→Green gradient bar |

## Color constants (`C.*`)

| Constant | Hex | Use |
|---|---|---|
| `C.NIGHTLY` | `#003359` | BG / dark text on light |
| `C.WHITE` | `#FFFFFF` | Primary text on dark |
| `C.GREEN` | `#45FF9B` | Accent highlight (kickers, titles) |
| `C.TEAL` | `#17BDBF` | Secondary accent |
| `C.DEEP_TEAL` | `#007D80` | Tertiary accent |
| `C.GRAY` | `#B0B8C8` | Body/secondary text on dark |

## Slide dimensions

- 13.333 × 7.5 in (widescreen)
- Left margin: 0.70 in (matches Brightly template)
- Content area: x=0.70, y=1.93, w=11.93

## Typography rules

- Headlines: `font=FONT_HEAD` ("Calibri (Headings)"), `bold=True`
- Kickers/body/labels: `font=FONT_BODY` ("Calibri"), `bold=True/False` per context
- Kicker eyebrow: 11 pt, `C.GREEN`, bold
- Headline: 22–26 pt, `C.WHITE`, Calibri Light
- Body text: 10.5–13 pt, `C.GRAY` or `C.WHITE`
- Footer: 7.5 pt, `C.DIM`

## Assets (in `~/.claude/skills/bsw-ppt/assets/`)

- `image1.png` — full-bleed green gradient (cover/closing bg)
- `image12.png` — Brightly wordmark (small, placed bottom-right by `_chrome`)
- `image16.png` — Brightly connected rings icon (large decorative)
- `image6.png` — three pill shapes motif
- `image7.png` — teal swirl motif
- `image9.png` — green wave motif

## Branding rules

1. **No Siemens branding** on BSW/LST decks — no SIEMENS wordmark, no `#000028` backgrounds
2. **No Brightly logo on covers** — use the wordmark asset (`image12.png`) only
3. **Brightly Green** (`#45FF9B`) is the single highlight color — use it for kickers and one or two words per headline max
4. **Nightly Blue** (`#003359`) is the standard slide background
5. **Calibri (Heading)** for all headlines; **Calibri** for all body text
6. Always call `d.finish(slide)` on content slides
