# BSW Branding Specification

Brightly Software (BSW) brand for internal presentations.
Derived from `Brightly Theme.pptx` (Brightly Software official template).
Use this instead of `siemens-ppt/BRANDING.md` for all BSW/LST internal decks.

---

## Slide dimensions

| Property | Value |
|---|---|
| Width | 13.333 in |
| Height | 7.5 in |
| Aspect | Widescreen 16:9 |

---

## Color palette

| Name | Hex | Usage |
|---|---|---|
| **Nightly Blue** | `#003359` | Primary dark background (covers, dividers, content slides) |
| **White** | `#FFFFFF` | Primary text on dark; light slide backgrounds |
| **Brightly Green** | `#45FF9B` | Primary accent / highlight / brand pop |
| **Teal** | `#17BDBF` | Secondary accent |
| **Deep Teal** | `#007D80` | Tertiary accent / anchor color |
| **Lime** | `#E3F070` | Accent 4 (use sparingly) |
| **Coral** | `#FC967C` | Accent 5 (use sparingly) |
| **Pink** | `#FFA6BF` | Accent 6 (use sparingly) |
| **Gray** | `#B0B8C8` | Secondary/body text on dark |

### Quick reference (python-pptx RGBColor)
```python
NIGHTLY   = RGBColor(0x00, 0x33, 0x59)
WHITE     = RGBColor(0xFF, 0xFF, 0xFF)
GREEN     = RGBColor(0x45, 0xFF, 0x9B)   # Brightly Green — primary highlight
TEAL      = RGBColor(0x17, 0xBD, 0xBF)   # secondary accent
DEEP_TEAL = RGBColor(0x00, 0x7D, 0x80)   # anchor / fold hlink
LIME      = RGBColor(0xE3, 0xF0, 0x70)
CORAL     = RGBColor(0xFC, 0x96, 0x7C)
PINK      = RGBColor(0xFF, 0xA6, 0xBF)
GRAY      = RGBColor(0xB0, 0xB8, 0xC8)

```

---

## Typography

| Use | Typeface | Size | Weight | 
|---|---|---|---|
| Slide title (covers) | Calibri | 66-72 pt | Bold |
| Slide headline (content) | Calibri | 22–28 pt | Bold |
| Section divider | Calibri | 36–44 pt | Bold |
| Kicker / eyebrow | Calibri | 11 pt | Bold |
| Body text | Calibri | 11–13 pt | Regular |
| Footer | Calibri | 7–8 pt | Regular |

> The Brightly theme's major font is **Calibri (Headings)** and body font is **Calibri**.
> Use `font_name = "Calibri (Headings)"` and make sure it's in bold for headlines and `"Calibri"` for body/kicker.

---

## Slide layout archetypes

### Cover slide
- Background: white with full-bleed green-gradient artwork image (`image1.png`) covering the whole slide
- Brightly wordmark bottom-left (`image12.png`) at ~2.0 × 0.56 in, pos (0.64, 6.34)
- Title: Calibri (Headings) ~66-72 pt, dark blue (`#003359`), centered vertically at ~y=2.28, center-aligned
- Subtitle/tagline: Calibri 16 pt gray below title
- "Version | Date" line in small gray below subtitle
- Footer text bottom-right: `© 2026 | Brightly Software CONFIDENTIAL`, 7.5 pt

### Section divider (Blue variant)
- Background: **Nightly Blue** `#003359`
- Giant title text: Calibri Light 36–44 pt, White, center-aligned, pos (~0.70, 0.64), size (~11.5 × 4.28)
- Brightly wordmark bottom-right (`image12.png`), ~0.33 × 0.38 in, pos (12.63, 6.75)
- No other decoration — confident, clean, oversized text only

### Section divider (Green variant — use for all LST dividers (slides/sections listed on Agenda slide))
- Background: **Brightly Green** `#45FF9B`
- Title text: Calibri Light 36–44 pt, Nightly Blue `#003359` (dark text on green)
- Same wordmark placement

### Content slide (Blue — standard workhorse)
- Background: **Nightly Blue** `#003359`
- Kicker/eyebrow: 11 pt bold Calibri, Brightly Green `#45FF9B`, pos (0.70, 0.56), width ~11.93
- Headline/title: Calibri Light 22–26 pt, White, pos (0.70, 0.56+kicker_h), width ~11.93
- Content area: x=0.70, y=1.93, w=11.93, h=4.5 (use full width)
- Footer left: `© 2026 | Brightly Software CONFIDENTIAL`, 7.5 pt gray, pos (0.70, 6.97)
- Slide number: pos (0.22, 6.97)
- Brightly wordmark bottom-right: ~0.33 × 0.38 in, pos (12.63, 6.75)

### Questions / Thank You / Closing slides
- Background: full-bleed 9green-gradient (`image1.png`) + Brightly Green bg
- "Questions?" in Calibri (Headings) 115 pt, dark blue, in bold/bolded, center-aligned
- "Thank you" in Calibri (Headings) 115 pt, dark blue, in bold/bolded, center-aligned
- Brightly wordmark bottom-left

### Agenda slide
- Same as content slide (Blue)
- Title: "Agenda" or meeting title in kicker zone
- Content: numbered/tabbed list in main area

---

## Decorative assets (in `assets/`)

| File | Description | Used on |
|---|---|---|
| `image1.png` | Full-bleed green diagonal gradient (green → teal) | Cover bg, Thank You bg |
| `image3.png` | Brightly logo dark (navy) | Light-background slides |
| `image4.png` | Brightly icon dark (navy ring) | Covers, light bg |
| `image5.png` | Brightly icon teal (teal ring) | Dark bg accent |
| `image6.png` | Three overlapping rounded pill shapes (blue→green gradient) | Decorative motif |
| `image7.png` | Teal swirl/scroll shape | Decorative motif |
| `image9.png` | Green wave / squiggle shape | Decorative motif |
| `image12.png` | Brightly logo white-ish (navy, small) | Slide footer bottom-right |
| `image16.png` | Brightly connected rings icon (green/teal gradient) | Cover, divider accent |

---

## Footer format

```
© 2026 | Brightly Software CONFIDENTIAL
```
- 7.5 pt Calibri, gray
- Position: bottom-left (0.70, 6.97), width 4.5 in
- Slide number: bottom-left before footer (0.22, 6.97), 0.28 wide
- Logo: bottom-right ~(12.63, 6.75), size 0.33 × 0.38 in

---

## Tone & voice

- **Clean, confident, corporate**: no clutter, generous whitespace
- Oversized divider text signals section changes boldly
- Green `#45FF9B` is the single highlight color — use it for kickers, accent bars
- Body copy is white on dark or dark on light — no mid-gray backgrounds
