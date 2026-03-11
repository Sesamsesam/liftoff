---
name: remotion-presentation
description: "Cookie-cutter Remotion video presentation with billboard-style slides, glass cards, and cinematic backgrounds. Supply a script, get a 1080p video."
---

# Remotion Presentation

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

> [!IMPORTANT]
> **TAKEOVER INSTRUCTION FOR AGENTS:**
> When this skill is invoked inside a project folder, treat it as a full project takeover. Inspect the current directory for any existing files, then scaffold or adapt the Remotion presentation structure to fit. If a `src/` folder, `package.json`, or script data already exists, integrate with it rather than overwriting. If the project is empty, scaffold from scratch using the templates in `templates/` within this skill folder. Always read the template files first before generating code.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
A production-ready Remotion video template for data-driven presentations. Each slide shows one visual punch - a big stat, a short title, or a key insight - over looping cinematic background videos. Glass card UI, teal/orange color scheme, and subtle electric pulse animations are built in.

## Why Does It Exist?
Creating polished video presentations from scratch takes days. This template gives the agent a proven layout system so it can turn any script into a studio-quality 1080p video in minutes. Just supply the script data, drop in backgrounds, and render.

## What It Does For You
The agent scaffolds the full Remotion project, maps your script to slide types, assigns backgrounds, and produces a render-ready presentation with animated stat counters, glass morphism cards, and a cohesive design system.

---

## Activation
- "Create a video presentation"
- "Turn this script into a Remotion video"
- "Build a data-driven presentation"
- "Make a video with stats and slides"

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- HOW IT WORKS                                       -->
<!-- ═══════════════════════════════════════════════════ -->

## How It Works

### File Structure

```
my-presentation/
├── package.json
├── tsconfig.json
├── public/backgrounds/       ← looping .mp4 video clips
└── src/
    ├── index.ts              ← Remotion entry
    ├── Root.tsx               ← Composition registration
    ├── Presentation.tsx       ← Slide sequencer + color alternation
    ├── styles.css             ← Inter font + global resets
    ├── components/
    │   └── SlideLayout.tsx    ← All slide types + animations
    └── data/
        └── script.ts         ← USER'S SCRIPT DATA
```

### Template Files

All boilerplate code lives in the `templates/` subfolder of this skill:

| Template | Purpose |
|----------|---------|
| `templates/package.json` | Dependencies (Remotion 4 + React 19) |
| `templates/tsconfig.json` | TypeScript config |
| `templates/index.ts` | Remotion entry point |
| `templates/Root.tsx` | Composition registration |
| `templates/Presentation.tsx` | Slide sequencer with statColorIndex |
| `templates/styles.css` | Inter font + global styles |
| `templates/SlideLayout.tsx` | Full slide renderer (~1000 lines) |
| `templates/script.example.ts` | Example script data with all slide types |

The agent should read these templates and adapt them to the user's content.

---

## Slide Types

| Type | Visual | Key Fields |
|------|--------|------------|
| `intro` | Big centered title + gradient subtitle | `text`, `highlight?` |
| `title` | Section header + underline + tagline | `text`, `highlight?` |
| `stat` | Source small, **giant number**, label | `text`, `stat`, `statLabel` |
| `body` | Short text + big gradient highlight | `text`, `highlight?` |
| `company` | Company name small + big stat | `text`, `stat`, `statLabel` |
| `comparison` | Big number + left-aligned list | `text` (newline-separated), `stat`, `statLabel` |
| `funnel` | Big number + narrowing bars | `text` (newline-separated), `stat`, `statLabel` |
| `cta` | Text + breathing gradient highlight | `text`, `highlight?` |

---

## Billboard Style Rules

> [!IMPORTANT]
> **Each slide = ONE visual punch.** Voice + subtitles carry the detail.

- **Stat slides:** source small at top, giant number center, label bottom. No body text.
- **Title slides:** short title (2-5 words) + one-line highlight.
- **Body slides:** one short sentence + one bold gradient highlight.
- **Company slides:** company names small at top + big stat.
- **No long paragraphs.** If text exceeds ~10 words, shorten it.

---

## Design System

### Colors (alternating via statColorIndex)

| Token | Hex | Usage |
|-------|-----|-------|
| Teal | `#00E0C8` | Primary stat numbers, accents |
| Orange | `#FFB347` | Alternating stats, labels |
| White | `#FFFFFF` | Titles, body text |

Even statColorIndex = teal stat + orange label. Odd = orange stat + teal label. The counter only increments for stat/company/comparison/funnel slides, so title/body slides don't break the alternation.

### Typography

| Element | Size | Weight |
|---------|------|--------|
| Intro title | 110px | 900 |
| Section title | 82px | 800 |
| Stat number | 130-140px | 900 |
| Highlight | 52px | 700 |
| Body text | 36-38px | 300 |
| Source/label | 20-26px | 400-600 |

### Animations

| Effect | Cycle | Description |
|--------|-------|-------------|
| Electric pulse | 120 frames (4s) | Subtle teal glow fires and fades on settled text |
| Glass card glow | 90 frames (3s) | Border opacity breathing |
| Count-up | ~45 frames | Numbers roll from 0 to target with impact punch |
| Ken Burns | full slide | Background video zooms 1.0 → 1.08 |
| Floating particles | continuous | 12 softly drifting white dots |

### Layout

Content occupies the **left 2/3** of the screen. The right 1/3 is open for optional webcam overlay. Remove this by setting content width to `100%`.

---

## Timing Engine

Slide duration is auto-calculated from spoken word count:

```typescript
const FPS = 30;
const WPM = 150; // speaking pace - adjust as needed
```

Each `Section` has a `wordCount` field. The engine divides section time evenly across its slides.

---

## Agent Workflow

1. **Gather the script** - get the user's content, identify sections and slide types
2. **Read templates** - load all files from `templates/` in this skill folder
3. **Scaffold** - create the project structure, install with `bun install`
4. **Map script to data** - convert content to `script.ts` using billboard rules
5. **Assign backgrounds** - map `.mp4` files from `public/backgrounds/`
6. **Preview** - `bunx remotion studio`
7. **Render** - `bunx remotion render Presentation out/presentation.mp4`

---

## Customization

| Change | Where |
|--------|-------|
| Color scheme | Update `#00E0C8` / `#FFB347` in `SlideLayout.tsx` |
| Speaking pace | Change `WPM` in `script.ts` |
| Aspect ratio | Change `width`/`height` in `Root.tsx` (1920x1080, 1080x1920, etc.) |
| Remove webcam zone | Set content width to `100%` in `SlideLayout` |
| Pulse speed | Change cycle length in `useElectricPulse` (120 = 4s) |

---

## Backgrounds

Place looping `.mp4` clips in `public/backgrounds/`. Mix categories for visual variety:
- **Vibrant (V):** colorful abstract, oil macro, gradients
- **Dark (D):** space, deep ocean, smoke
- **Nature (N):** forests, water, aurora, clouds

Videos should be short loops (5-15s), 1920x1080 or larger.

---

## Guardrails

| Rule | Why |
|------|-----|
| No `translateY` idle animations | Renders staccato in Remotion's frame-by-frame model |
| No centered list items | Left-align for readability |
| No long paragraphs on slides | Billboard style: one punch per slide |
| No hardcoded total frame counts | Always derive from section word counts |
| Always use `staticFile()` for video paths | Required by Remotion for public assets |
