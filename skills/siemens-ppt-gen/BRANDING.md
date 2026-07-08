# Siemens Branding Specification

Siemens AG brand for internal and executive presentations.
Derived from the official Siemens O365 PowerPoint template.
Use this for all Siemens / Brightly-Siemens internal decks.

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
| **Deep Blue** | `#000028` | Primary dark background (all slides) |
| **White** | `#FFFFFF` | Primary text on dark |
| **Petrol** | `#009999` | Primary brand accent — kickers, eyebrows (ALL-CAPS), accent bars |
| **Bold Green** | `#00FFB9` | Highlight color — accent words in titles, stat numbers, section numbers |
| **Teal** | `#00D7A0` | Secondary accent |
| **Cyan** | `#00BEDC` | Tertiary accent |
| **Blue** | `#0087BE` | Accent 4 (use sparingly) |
| **Dark Petrol** | `#00557C` | Table header fill, anchor / deep accent |
| **Gray** | `#B3B3BE` | Secondary / body text on dark |
| **Dim** | `#66667E` | Footer text, tertiary labels |
| **Card** | `#0C0C3C` | Content card fill on Deep Blue background |

---

## Typography

| Use | Typeface | Size | Weight |
|---|---|---|---|
| Slide title (covers) | Arial | 48–72 pt | Bold |
| Slide headline (content) | Arial | 24–28 pt | Bold |
| Section divider title | Arial | 36–44 pt | Bold |
| Section number | Arial | 80–100 pt | Bold |
| Kicker / eyebrow | Arial | 10–11 pt | Bold, ALL-CAPS |
| Body text | Arial | 10–13 pt | Regular |
| Footer | Arial | 7–8 pt | Regular |

> All typefaces use **Arial**. Arial is the official corporate fallback for Siemens Sans.
> Never use Calibri or any other font.

---

## Slide layout archetypes

### Cover / Title slide
- Background: **Deep Blue** `#000028`
- Decorative motif: in the local Python build, `infinity_gradient.png` is placed on the right side (~5.4 × 2.7 in); in the browser web app, use a petrol→green gradient accent rect on the right side as a substitute
- Title: Arial 48 pt bold, White, left-aligned at (0.6, 2.0), width ~6.8 in; 1–2 key words rendered in **Bold Green** `#00FFB9`
- Subtitle: Arial 19 pt, Gray `#B3B3BE`, below title
- Meta line (version/date): Arial 12 pt, Petrol `#009999`, bold, below subtitle
- Footer: bottom-left, `© Siemens 2026  |  Restricted  |  [author]  |  [dept]  |  [date]`, 7.5 pt Dim
- SIEMENS wordmark: bottom-right, width ~1.32 in, height ~0.21 in

### Section divider
- Background: **Deep Blue** `#000028`
- Petrol→green gradient accent bar: ~0.9 × 0.07 in at (0.6, 2.45)
- Giant section number: Arial 100 pt bold, **Bold Green** `#00FFB9`, left-aligned; the JSON field `number` supplies this (e.g. "01", "02")
- Section title: Arial 40 pt bold, White, large, right of the number, vertically centered
- Subtitle (optional): Arial 15 pt, Gray, below title
- Footer + SIEMENS wordmark (standard chrome)

### Content slide (standard workhorse)
- Background: **Deep Blue** `#000028`
- Kicker/eyebrow: Arial 10–11 pt bold ALL-CAPS, **Petrol** `#009999`, pos (0.6, 0.48), width ~12.1 in
- Headline / action title: Arial 24–26 pt bold, White, pos (0.6, 0.82), width ~12.1 in
  - Action phrase not topic label — "Sales grew 18% in EMEA", not "Sales"
- Content area: x=0.6, y≈1.75, w=12.1, h≈5.0 — use full width
- Footer + SIEMENS wordmark (standard chrome)

### Closing slide (Questions / Thank You)
- Same layout as Cover / Title slide
- Single large text: Arial 48–80 pt bold, White; key word or phrase in Bold Green
- SIEMENS wordmark bottom-right; footer bottom-left

---

## Decorative assets

| File | Description | Used on |
|---|---|---|
| `infinity_gradient.png` | Siemens infinity loop gradient motif (green→petrol) | Cover right side, closing slides |
| `siemens_logo_white.png` | SIEMENS wordmark (white) | Footer bottom-right on dark slides |
| `siemens_logo_petrol.png` | SIEMENS wordmark (petrol) | Footer on light-background slides |

> Assets live in `assets/` locally. In the browser web app, images are unavailable.
> Use `#000028` bg + a petrol→green gradient rect as the decorative element for covers/closings.

---

## Footer format

```
Page N      Restricted  |  © Siemens 2026  |  [author]  |  [dept]  |  [date]
```
- 7.5 pt Arial, Dim `#66667E`
- Position: bottom-left (0.6, 7.18), width ~8.5 in
- SIEMENS wordmark: bottom-right (~12.4, 7.10), ~1.32 × 0.21 in (white version on dark bg)
- Slide number embedded in the footer line

---

## Tone & voice

- **Executive, clean, confident**: generous whitespace, no clutter
- Section numbers make section changes unmissable — oversized Bold Green
- Petrol `#009999` is the kicker accent color; **Bold Green** `#00FFB9` is the single highlight — one or two accent words per headline max
- Body copy is White or Gray on Deep Blue — no mid-tone backgrounds, no card grids
- Every content slide headline is an **action title** — a complete assertion, not a topic label

---

## Strict rules

1. **No Brightly branding** on Siemens decks — no `#003359`, `#45FF9B`, no Brightly wordmark, no Calibri
2. **No card grids** — never use a card_grid layout; restructure as bullet lists, tables, or numbered lists
3. **No emojis** anywhere in any text
4. **Bold Green** `#00FFB9` is the single highlight — limit to 1–2 words per headline, stat values, section numbers
5. **Arial** for all text — no other font
6. **Deep Blue** `#000028` background on all slides
