# Loop Diff — Round 1

AI: 27 slides | Reference: 44 slides

---

## Slide mapping

| AI | Reference | Section | Match |
|---|---|---|---|
| 1 | 1 | Title | ~OK (extra meta line visible) |
| 2 | 2 | Agenda (COMING UP) | OK structurally; background inconsistent |
| 3 | 3 | Section: General Updates | OK |
| 4 | 4 | Company Updates content | Content close; white bg bug |
| 5 | 4 | Bug Bash / Domain (two_col) | Good 2-col layout! |
| 6 | 4 | SGES survey + Snagit | OK |
| 7 | 5 | Support TRX / Career Pathing | 2-col ok; placeholder text fine |
| 8 | 6 | Section: Process Reminders | OK |
| 9 | 7 | Call Outs | Bullets vs reference 3-card layout |
| 10 | 8 | QA Use Case | Bullets vs reference 3-card layout |
| 11 | 8 | Case Form + Time | Bullets, OK |
| 12 | 10 | Section: Monthly Metrics | OK |
| 13 | 11 | Metrics table | OK — TBD for missing data is correct |
| 14 | 12 | Section: Project Lightyear ✓ | OK |
| 15 | 13 | Lightyear rebrand overview | OK |
| 16 | 13 | Lightyear key dates | Numbered list ok; ref has more detail |
| — | 14–34 | Product-specific slides | Not in source material — cannot generate |
| 17 | 35 | Section: Shout Outs | OK |
| 18 | 36-37 | Kudos (names only, 9/slide) | OK — ref shows Teams message screenshot |
| 19 | 37 | Kudos page 2 | OK |
| 20 | 37 | NPS names | OK — ref uses different format (big names + quotes below) |
| 21 | 38 | Section: Celebrations | OK |
| 22 | 39 | Birthdays & Anniversaries | BUG: "None this month" vs EDIT placeholder |
| 23 | 40 | Personal Milestones | Bullets — ref has photos (cannot replicate) |
| 24 | 41 | Section: What's Coming | OK |
| 25 | 42 | What's Coming bullets | OK — ref has holiday images (cannot replicate) |
| 26 | 43 | Questions | OK |
| 27 | 44 | Thank You | OK |

---

## Issues by category

### 🔴 Visual issues (→ index.html)

**V1 — White background on some content slides [CRITICAL]**
AI slides 4, 7, 11, 16, 20, 25 render with WHITE background.
All content slides must use `#000028` dark navy, same as section/closing slides.
Root cause: `buildPptx()` in PptxGenJS path — some slide branches don't set explicit background color.
Fix: add `background: { fill: '000028' }` to EVERY slide in buildPptx() unconditionally.

**V2 — Title slide: extra subtitle/meta line**
AI slide 1 shows:
- Line 1: "LST · July 2026"
- Line 2: "Global Support · July 2026"
Reference shows: "LST" and "July 2026" on separate lines.
The `meta` field should NOT be rendered as a visible text line on title slides. It's metadata only.
Fix: in buildPptx() title_slide renderer, only render `title` and `subtitle` — do not render `meta` as a visible text object.

**V3 — Agenda slide has wrong dark color (pure black instead of navy)**
Minor — the agenda slide background appears pure black (#000000) not deep blue (#000028).
Same root cause as V1 — agenda content_slide branch missing background setter.

**V4 — NPS names slide: names not "first name bold green, last name white" when full names present**
Source only has first names so renders all-green, which looks correct for now.
No action needed this round.

---

### 🟡 Content issues (→ agents/lst-meeting-builder.md)

**C1 — Birthdays placeholder uses "None this month" instead of EDIT guidance**
AI slide 22: "Birthdays: None this month / Anniversaries: None this month"
Should be: empty items list + notes: "EDIT: Add July birthdays (left) and anniversaries (right) before presenting."
Fix in agent: reinforce that when birthdays/anniversaries are not in source material, the `left_items` and `right_items` arrays should be EMPTY (not "None this month") and a `notes` field should say "EDIT: Add July birthdays (left column) and anniversaries (right column) before presenting."

**C2 — Personal Milestones slide renders as bullets (minor)**
AI slide 23 shows bullets: Hailey graduated, twins graduated, Theater Arts induction.
Reference slide 40 shows photos (irreplicable by AI).
Current bullets are better than nothing. The content is correct.
No code change needed — just document this as "photos must be added manually."

**C3 — Process Reminder slides: bullets instead of 3-card layout**
AI slides 9-10 use bullets for Call Outs and QA.
Reference slides 7-8 use a 3-card layout (REMINDER | IMPACT | METRICS box grid).
The 3-card layout is a custom visual format not currently supported by the renderer.
Not fixing this round (would require new format type). Note as future work.

**C4 — Lightyear key dates: numbered list sub-bullet formatting wonky**
AI slide 16 shows item 3 as "• Internal FAQs..." numbered as item 3 instead of as a sub-bullet under item 2.
Root cause: agent generated numbered items where one of them is a sub-bullet detail, but the numbered format doesn't support sub-items.
Fix: in agent, for key date timelines use `two_columns` layout with date+event pairing, or use bullets with date as parent and detail as sub-bullet.

---

### 🟢 Structural issues (→ agents/lst-meeting-builder.md)

**S1 — Extra section (Project Lightyear) generated correctly ✓**
AI correctly generates section_slide + 2 content slides for Project Lightyear between Metrics and Shout Outs. PASS.

**S2 — Section numbers correct ✓**
01 General, 02 Process, 03 Metrics, 04 Project Lightyear, then Shout Outs, Celebrations, What's Coming. PASS.

**S3 — Per-topic process reminder slides ✓**
AI generates 3 separate process reminder content slides (call-outs, QA use case, case form). PASS.

**S4 — Reference has 17 product-specific slides (14-34) not in source material**
These are per-product rebrand detail slides (SchoolDude, Assetic, MMx/WM, Smart Assets, TheWorxHub, Confirm, Asset Essentials, Event Manager, Energy Manager, Data Share, Predictor, Origin). This content does not exist in july-source.md. The AI correctly omits it. NOT a bug.

---

## Fixes to apply this round

| Fix | File | Change |
|---|---|---|
| V1: Force navy background on all slides | index.html | buildPptx(): add `background: {fill: '000028'}` to every slide unconditionally |
| V2: Remove meta field from title slide visible text | index.html | title_slide renderer: don't render `meta` as a text box |
| C1: Birthdays — "None this month" → EDIT placeholder | agents/lst-meeting-builder.md | Celebrations rule: left_items/right_items must be EMPTY arrays when no data; add notes field |
| C4: Lightyear dates numbered list sub-bullet wonky | agents/lst-meeting-builder.md | Key dates rule: use two_col for date timelines |

---

## What's out of scope for this loop

- **3-card process reminder layout (V3)**: requires new body format type; design decision deferred
- **Photos on Celebrations slide**: impossible to auto-generate; presenter adds manually
- **Product-specific Project Lightyear slides (ref 14-34)**: source material doesn't include this content; presenter adds manually
- **Holiday images on What's Coming**: presenter adds manually
