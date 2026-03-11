---
name: remotion-presentation
description: "Cookie-cutter Remotion video presentation with billboard-style slides, glass card UI, electric pulse animations, and looping video backgrounds. Supply a script, get a polished 1080p video."
---

# Remotion Presentation

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
A production-ready Remotion video template for data-driven presentations. Each slide shows one visual punch - a big stat, a short title, or a key insight - over looping cinematic video backgrounds. Glass card UI, alternating teal/orange color scheme, and subtle electric pulse animations are built in.

## Why Does It Exist?
Creating polished video presentations from scratch takes days. This template gives the agent a proven layout system so it can turn any script into a studio-quality 1080p video in minutes. Just supply the script data, drop in backgrounds, and render.

## What It Does For You
The agent scaffolds the full Remotion project, maps your script to slide types, assigns background videos, and produces a render-ready presentation. You get a professional video with animated stat counters, glass morphism cards, floating particles, and a cohesive color system without touching any code.

---

## Activation
- "Create a video presentation"
- "Turn this script into a Remotion video"
- "Build a data-driven presentation"
- "Make a video with stats and slides"

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- SETUP                                              -->
<!-- ═══════════════════════════════════════════════════ -->

## Project Setup

### 1. Scaffold the project

Create a new directory and initialize:

```bash
mkdir my-presentation && cd my-presentation
```

### 2. package.json

```json
{
  "name": "my-presentation",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "studio": "remotion studio",
    "render": "remotion render Presentation out/presentation.mp4",
    "render-preview": "remotion render Presentation out/preview.mp4 --frames=0-900"
  },
  "dependencies": {
    "@remotion/cli": "^4.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "remotion": "^4.0.0"
  },
  "devDependencies": {
    "@types/react": "^19.0.0",
    "typescript": "^5.7.0"
  }
}
```

### 3. tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

### 4. Install dependencies

```bash
bun install
```

### 5. Background videos

Place looping `.mp4` video clips in:

```
public/backgrounds/
```

Each slide references a background by filename (e.g., `'ocean.mp4'`). The template supports any number of backgrounds. For variety, use a mix of categories:

- **Vibrant (V):** colorful abstract, oil macro, gradients
- **Dark (D):** space, deep ocean, smoke
- **Nature (N):** forests, water, aurora, clouds

> [!TIP]
> Background videos should be short loops (5-15 seconds), ideally 1920x1080 or larger. They will be scaled to cover the full frame with a subtle Ken Burns zoom effect.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- FILE STRUCTURE                                     -->
<!-- ═══════════════════════════════════════════════════ -->

## File Structure

```
my-presentation/
├── package.json
├── tsconfig.json
├── public/
│   └── backgrounds/       ← looping .mp4 video clips
│       ├── ocean.mp4
│       ├── nebula.mp4
│       └── ...
└── src/
    ├── index.ts           ← Remotion entry point
    ├── Root.tsx            ← Composition registration
    ├── Presentation.tsx    ← Slide sequencer + color index
    ├── styles.css          ← Global styles + Inter font
    ├── components/
    │   └── SlideLayout.tsx ← All slide types + animations
    └── data/
        └── script.ts      ← YOUR SCRIPT DATA GOES HERE
```

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- BOILERPLATE FILES                                  -->
<!-- ═══════════════════════════════════════════════════ -->

## Boilerplate Files

### src/index.ts

```tsx
import { registerRoot } from 'remotion';
import { RemotionRoot } from './Root';

registerRoot(RemotionRoot);
```

### src/Root.tsx

```tsx
import React from 'react';
import { Composition } from 'remotion';
import { Presentation } from './Presentation';
import { TOTAL_FRAMES } from './data/script';

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="Presentation"
        component={Presentation}
        durationInFrames={TOTAL_FRAMES}
        fps={30}
        width={1920}
        height={1080}
      />
    </>
  );
};
```

### src/styles.css

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

:root {
  --color-bg-deep: #050810;
  --color-teal: #22D3EE;
  --color-teal-glow: rgba(34, 211, 238, 0.3);
  --color-orange: #FFB347;
  --color-white: #F9FAFB;
  --color-muted: rgba(249, 250, 251, 0.5);
  --font: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: var(--font);
  background: var(--color-bg-deep);
  color: var(--color-white);
  -webkit-font-smoothing: antialiased;
}
```

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- SCRIPT DATA MODEL                                  -->
<!-- ═══════════════════════════════════════════════════ -->

## Script Data Model (src/data/script.ts)

This is the **only file users customize**. The agent maps the user's script content to this structure.

### Interfaces

```typescript
export interface Slide {
  text: string;
  highlight?: string;
  stat?: string;
  statLabel?: string;
  type: 'title' | 'body' | 'stat' | 'company' | 'comparison' | 'funnel' | 'cta' | 'intro';
  /** Background video filename in public/backgrounds/ */
  bgVideo: string;
}

export interface Section {
  id: string;
  title: string;
  slides: Slide[];
  bgHue: number;
  /** Total word count of the spoken script for this section */
  wordCount: number;
}
```

### Timing Engine

```typescript
const FPS = 30;
const WPM = 150; // speaking pace

function sectionFrames(wordCount: number): number {
  const seconds = (wordCount / WPM) * 60;
  return Math.round(seconds * FPS);
}

export function framesPerSlide(section: Section): number {
  return Math.round(sectionFrames(section.wordCount) / section.slides.length);
}

export function getSectionFrames(section: Section): number {
  if (section.id === 'intro') return 600; // 20s fixed
  return sectionFrames(section.wordCount);
}

export const TOTAL_FRAMES = SECTIONS.reduce(
  (acc, s) => acc + getSectionFrames(s), 0
);
```

### Slide Types

| Type | Purpose | Required Fields | Visual |
|------|---------|----------------|--------|
| `intro` | Opening slide | `text`, `highlight?` | Big centered title + subtitle |
| `title` | Section header | `text`, `highlight?` | Large title + underline + tagline |
| `stat` | Key statistic | `text` (source), `stat`, `statLabel` | Source small top, big number center, label bottom |
| `body` | Supporting point | `text`, `highlight?` | Short text + big gradient highlight |
| `company` | Company example | `text` (company names), `stat`, `statLabel` | Company name small top, big number, label |
| `comparison` | Multi-line data | `text` (newline-separated), `stat`, `statLabel` | Big number + label + left-aligned list |
| `funnel` | Narrowing data | `text` (newline-separated), `stat`, `statLabel` | Big number + label + funnel bars |
| `cta` | Call to action | `text`, `highlight?` | Text + big breathing gradient highlight |

### Example Section

```typescript
export const SECTIONS: Section[] = [
  {
    id: 'intro',
    title: 'INTRO',
    bgHue: 220,
    wordCount: 0, // intro uses fixed 20s / 600 frames
    slides: [
      {
        type: 'intro',
        text: 'The Numbers Don\'t Lie',
        highlight: 'An AI deep dive.',
        bgVideo: 'nebula.mp4',
      },
    ],
  },
  {
    id: 'market-size',
    title: 'Market Size',
    bgHue: 200,
    wordCount: 180, // count the spoken words for this section
    slides: [
      {
        type: 'title',
        text: 'The Scale',
        highlight: 'How big is this really?',
        bgVideo: 'ocean.mp4',
      },
      {
        type: 'stat',
        text: 'PwC Global Study',       // source (shown small)
        stat: '$15.7T',                  // big number
        statLabel: 'GDP Impact by 2030', // label below number
        bgVideo: 'aurora.mp4',
      },
      {
        type: 'body',
        text: 'Every industry. Every role.',
        highlight: 'This changes everything.',
        bgVideo: 'forest.mp4',
      },
    ],
  },
];
```

### Billboard Style Rules

> [!IMPORTANT]
> **Each slide = ONE visual punch.** Voice + subtitles carry the detail. Slides are not paragraphs.

- **Stat slides:** source small at top, giant number center, label bottom. No body text.
- **Title slides:** short title (2-5 words) + one-line highlight
- **Body slides:** one short sentence + one bold gradient highlight
- **Company slides:** company names small at top + big stat
- **No long paragraphs.** If text exceeds 10 words, shorten it.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- PRESENTATION SEQUENCER                             -->
<!-- ═══════════════════════════════════════════════════ -->

## Presentation Sequencer (src/Presentation.tsx)

The sequencer lays out slides as Remotion `<Sequence>` components and tracks a `statColorIndex` that only increments for stat/company/comparison/funnel slides to ensure proper teal/orange alternation.

```tsx
import React from 'react';
import { Sequence } from 'remotion';
import { SECTIONS, getSectionFrames } from './data/script';
import { SlideLayout } from './components/SlideLayout';
import './styles.css';

const STAT_TYPES = new Set(['stat', 'company', 'comparison', 'funnel']);

export const Presentation: React.FC = () => {
  let frameOffset = 0;
  let globalSlideIndex = 0;
  let statColorIndex = 0;
  const totalSlides = SECTIONS.reduce((acc, s) => acc + s.slides.length, 0);

  return (
    <>
      {SECTIONS.map((section, sectionIndex) => {
        const sectionTotalFrames = getSectionFrames(section);
        const slideDuration = Math.round(sectionTotalFrames / section.slides.length);

        return section.slides.map((slide, slideIndex) => {
          const from = frameOffset;
          const currentGlobalSlide = globalSlideIndex;
          const currentStatColor = statColorIndex;

          frameOffset += slideDuration;
          globalSlideIndex += 1;
          if (STAT_TYPES.has(slide.type)) {
            statColorIndex += 1;
          }

          return (
            <Sequence
              key={`${section.id}-${slideIndex}`}
              from={from}
              durationInFrames={slideDuration}
              name={`${section.title} - Slide ${slideIndex + 1}`}
            >
              <SlideLayout
                slide={slide}
                sectionTitle={section.title}
                bgHue={section.bgHue}
                bgVideo={slide.bgVideo}
                durationInFrames={slideDuration}
                sectionIndex={sectionIndex}
                totalSections={SECTIONS.length}
                slideNumber={currentGlobalSlide + 1}
                totalSlides={totalSlides}
                statColorIndex={currentStatColor}
              />
            </Sequence>
          );
        });
      })}
    </>
  );
};
```

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- DESIGN SYSTEM                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## Design System

### Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| Teal | `#00E0C8` | Primary stat numbers, accents |
| Orange | `#FFB347` | Alternating stats, labels, highlights |
| White | `#FFFFFF` | Titles, body text |
| Deep BG | `#0a0a0f` | Base background behind video |

### Color Alternation

Stat-type slides (stat, company, comparison, funnel) alternate between teal and orange:
- **Even statColorIndex:** teal stat + orange label
- **Odd statColorIndex:** orange stat + teal label

This ensures consecutive number slides never have the same color scheme, regardless of title/body slides in between.

### Typography

| Element | Size | Weight |
|---------|------|--------|
| Intro title | 110px | 900 |
| Section title | 82px | 800 |
| Stat number | 130-140px | 900 |
| Highlight | 52px | 700 |
| Body text | 36-38px | 300 |
| Source/label | 20-26px | 400-600 |

### Component Inventory

| Component | Purpose |
|-----------|---------|
| `VideoBackground` | Looping video with Ken Burns zoom |
| `FloatingParticles` | 12 softly drifting white dots |
| `GlassCard` | Dark glass container with breathing teal border glow |
| `SectionCounter` | `01 / 12` section indicator, top-left |
| `CountUpNumber` | Animated count-up with impact punch + electric pulse |
| `useElectricPulse` | Periodic glow pulse (120-frame cycle / 4 seconds) |
| `electricShadow` | Generates text-shadow CSS for pulse intensity |

### Animation Inventory

| Animation | Timing | Effect |
|-----------|--------|--------|
| Slide fade in/out | 0-15 / last 15 frames | Opacity 0 → 1 → 0 |
| Slide up | 0-20 frames | 40px → 0px translateY |
| Spring scale | entry + 5-8f delay | Bouncy scale-in for stats/titles |
| Count-up | ~45 frames | Numbers roll from 0 to target |
| Impact punch | at count end | Scale 1 → 1.12 → 0.97 → 1 |
| Electric pulse | 120-frame cycle | Subtle teal glow fire + fade |
| Glass card glow | 90-frame cycle | Border opacity breathing |
| Ken Burns | full duration | Video scale 1.0 → 1.08 |
| Progress bar | full duration | Bottom bar fills left to right |

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- SLIDE LAYOUT COMPONENT                             -->
<!-- ═══════════════════════════════════════════════════ -->

## SlideLayout Component (src/components/SlideLayout.tsx)

> [!NOTE]
> This is the largest file (~1000 lines). The agent should generate it from this template, adapting as needed for the user's specific presentation.

The SlideLayout component handles all visual rendering. Key architecture:

1. **Main `SlideLayout`** - routes to the correct content component by `slide.type`
2. **Content components** - `TitleContent`, `StatContent`, `BodyContent`, `CompanyContent`, `ComparisonContent`, `FunnelContent`, `CTAContent`
3. **Shared utilities** - `VideoBackground`, `FloatingParticles`, `GlassCard`, `SectionCounter`, `CountUpNumber`, `useElectricPulse`, `electricShadow`

### Layout Structure

Every non-intro slide renders:
```
┌─────────────────────────────────────────────┐
│ [01/12]              Looping Video BG       │
│                                             │
│  ┌─────────────────────┐                    │
│  │   Glass Card         │                    │
│  │                     │                    │
│  │   [Content]         │      (right 1/3    │
│  │                     │       open for     │
│  │                     │       webcam)      │
│  └─────────────────────┘                    │
│                                             │
│ ████████░░░░░░░░░░░░░░░  progress bar       │
└─────────────────────────────────────────────┘
```

- Content occupies the **left 2/3** of the screen (66.666% width)
- The **right 1/3** is intentionally left open for webcam overlay
- Glass card has dark semi-transparent background with breathing border

### Props Interface

```typescript
interface SlideLayoutProps {
  slide: {
    type: string;
    text: string;
    highlight?: string;
    stat?: string;
    statLabel?: string;
    bgVideo: string;
  };
  sectionTitle: string;
  bgHue: number;
  bgVideo: string;
  durationInFrames: number;
  sectionIndex: number;
  totalSections: number;
  slideNumber: number;
  totalSlides: number;
  statColorIndex: number;
}
```

### Electric Pulse System

The pulse creates a periodic glow effect on text after it settles. It fires every ~4 seconds with a gradual ramp-up and slow decay:

```typescript
// Returns 0-1 intensity. 120-frame cycle (4s at 30fps).
function useElectricPulse(frame: number, settleFrame: number): number {
  const idleFrame = Math.max(0, frame - settleFrame);
  if (idleFrame <= 0) return 0;
  const cycle = idleFrame % 120;
  if (cycle < 20) return cycle / 20;            // gradual ramp up
  if (cycle < 100) return 1 - (cycle - 20) / 80; // slow fade out
  return 0;                                      // rest
}

function electricShadow(intensity: number, color = '0, 224, 200'): string {
  if (intensity <= 0.01) return 'none';
  const r1 = 10 + 20 * intensity;
  const r2 = 25 + 40 * intensity;
  const a1 = 0.25 * intensity;
  const a2 = 0.08 * intensity;
  return `0 0 ${r1}px rgba(${color}, ${a1}), 0 0 ${r2}px rgba(${color}, ${a2})`;
}
```

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- AGENT WORKFLOW                                     -->
<!-- ═══════════════════════════════════════════════════ -->

## Agent Workflow

When a user asks to create a video presentation, follow these steps:

### Step 1: Gather the script
Ask for or receive the user's script/content. Identify:
- How many sections and slides
- Which slides are stats vs titles vs body
- The word count per section (for timing)

### Step 2: Scaffold the project
Create the directory structure, `package.json`, `tsconfig.json`, and boilerplate files exactly as shown above.

### Step 3: Map script to data model
Convert the user's script into `src/data/script.ts`:
- Each major topic = one `Section`
- Count the spoken words per section for timing
- Apply billboard style: one punch per slide, no paragraphs
- Assign background videos from the available clips

### Step 4: Generate SlideLayout.tsx
Use the SlideLayout component from the reference implementation. The full component code should be generated following the architecture described above. Key features to include:
- All 8 slide type renderers
- `VideoBackground` with Ken Burns zoom
- `FloatingParticles` overlay
- `GlassCard` with breathing border glow
- `CountUpNumber` with impact punch
- `useElectricPulse` for idle glow animation
- `statColorIndex`-based teal/orange alternation
- Section counter in top-left
- Progress bar at bottom

### Step 5: Generate Presentation.tsx
Use the sequencer code above, ensuring the `statColorIndex` counter is included.

### Step 6: Install and preview

```bash
bun install
bunx remotion studio
```

### Step 7: Render

```bash
bunx remotion render Presentation out/presentation.mp4
```

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- CUSTOMIZATION                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## Customization Guide

### Changing the color scheme
Update these values throughout `SlideLayout.tsx`:
- Teal: `#00E0C8` and `rgb(0, 224, 200)`
- Orange: `#FFB347`
- Gradient: `linear-gradient(90deg, #00E0C8, #FFB347)`

### Adjusting speaking pace
In `script.ts`, change `WPM` (default: 150 words per minute).

### Changing the aspect ratio
In `Root.tsx`, modify `width` and `height`. Common options:
- 1920x1080 (16:9, default)
- 1080x1920 (9:16, vertical/reels)
- 1080x1080 (1:1, square)

### Removing the webcam zone
Change the content width from `66.666%` to `100%` in `SlideLayout` to use the full frame.

### Adjusting pulse speed
In `useElectricPulse`, change the cycle length (default: 120 frames = 4s). Lower = faster, higher = slower.

---

## Guardrails

> [!CAUTION]
> - Never use `translateY` for idle animations in Remotion. It renders staccato frame-by-frame. Use opacity/glow-based effects instead.
> - Never center-align list items. Left-align for readability.
> - Never put long paragraphs on slides. Billboard style: one punch per slide.
> - Never hardcode the total frame count. Always derive from `SECTIONS` word counts.
> - Always use `staticFile()` for background video paths, not relative imports.
