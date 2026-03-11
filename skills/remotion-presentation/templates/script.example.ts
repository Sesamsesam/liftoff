/**
 * EXAMPLE SCRIPT DATA
 * ━━━━━━━━━━━━━━━━━━
 * This is a template showing all available slide types.
 * Replace with your own content. The agent will map your script here.
 *
 * RULES:
 * - Each slide = ONE visual punch (billboard style)
 * - Voice + subtitles carry detail, slides show the headline
 * - Keep text under 10 words per field
 * - wordCount = total spoken words for that section (drives timing)
 */

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
  /** Total word count of spoken script for timing */
  wordCount: number;
}

// ─── Timing Engine ──────────────────────────────────
const FPS = 30;
const WPM = 150; // speaking pace — adjust to your speed

function sectionFrames(wordCount: number): number {
  const seconds = (wordCount / WPM) * 60;
  return Math.round(seconds * FPS);
}

export function framesPerSlide(section: Section): number {
  return Math.round(sectionFrames(section.wordCount) / section.slides.length);
}

export function getSectionFrames(section: Section): number {
  if (section.id === 'intro') return 600; // 20s fixed intro
  return sectionFrames(section.wordCount);
}

// ─── YOUR SECTIONS ──────────────────────────────────

export const SECTIONS: Section[] = [
  // ── INTRO (always 20s / 600 frames) ──
  {
    id: 'intro',
    title: 'INTRO',
    bgHue: 220,
    wordCount: 0,
    slides: [
      {
        type: 'intro',
        text: 'Your Presentation Title',
        highlight: 'A compelling subtitle.',
        bgVideo: 'intro-bg.mp4',
      },
    ],
  },

  // ── SECTION EXAMPLE ──
  {
    id: 'example-section',
    title: 'The Big Picture',
    bgHue: 200,
    wordCount: 240, // count your spoken words for this section
    slides: [
      // Title slide: section opener
      {
        type: 'title',
        text: 'The Scale',
        highlight: 'How big is this really?',
        bgVideo: 'ocean.mp4',
      },
      // Stat slide: one big number
      {
        type: 'stat',
        text: 'Industry Report 2025',       // source (shown small)
        stat: '$15.7T',                      // the big number
        statLabel: 'Projected Impact',       // label below number
        bgVideo: 'aurora.mp4',
      },
      // Body slide: short statement + bold highlight
      {
        type: 'body',
        text: 'Every industry. Every role.',
        highlight: 'This changes everything.',
        bgVideo: 'forest.mp4',
      },
      // Company slide: company name + stat
      {
        type: 'company',
        text: 'Acme Corp',                  // company name (shown small)
        stat: '85%',
        statLabel: 'Efficiency Gain',
        bgVideo: 'city.mp4',
      },
      // Comparison slide: number + multi-line list
      {
        type: 'comparison',
        text: 'Product A: $500M\nProduct B: $300M\nProduct C: $200M\nTotal: $1B',
        stat: '3x',
        statLabel: 'Combined Value',
        bgVideo: 'abstract.mp4',
      },
      // CTA slide: call to action
      {
        type: 'cta',
        text: 'The opportunity is now.',
        highlight: 'Are you ready?',
        bgVideo: 'sunset.mp4',
      },
    ],
  },
];

// ─── Total Frames (auto-calculated) ─────────────────
export const TOTAL_FRAMES = SECTIONS.reduce(
  (acc, s) => acc + getSectionFrames(s), 0
);
