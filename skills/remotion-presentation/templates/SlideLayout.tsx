import React from 'react';
import {
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
  staticFile,
  Video,
  Easing,
} from 'remotion';

// ─── Floating Particles Overlay ─────────────────────────────────
const FloatingParticles: React.FC = () => {
  const frame = useCurrentFrame();

  const particles = Array.from({ length: 12 }, (_, i) => {
    const seed = i * 137.508;
    const baseX = ((seed * 7.3) % 100);
    const baseY = ((seed * 13.7) % 100);
    const size = 3 + (i % 4) * 2;
    const speed = 0.15 + (i % 3) * 0.08;
    const opacity = 0.08 + (i % 5) * 0.03;

    const x = baseX + Math.sin((frame * speed + seed) * 0.02) * 8;
    const y = baseY - (frame * speed * 0.3) % 120 + 10;

    return { x, y: ((y % 120) + 120) % 120 - 10, size, opacity };
  });

  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 3, pointerEvents: 'none' }}>
      {particles.map((p, i) => (
        <div
          key={i}
          style={{
            position: 'absolute',
            left: `${p.x}%`,
            top: `${p.y}%`,
            width: p.size,
            height: p.size,
            borderRadius: '50%',
            background: `rgba(255, 255, 255, ${p.opacity})`,
            boxShadow: `0 0 ${p.size * 2}px rgba(255, 255, 255, ${p.opacity * 0.5})`,
          }}
        />
      ))}
    </div>
  );
};

// ─── Glass Card with Breathing Glow ─────────────────────────────
const GlassCard: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const frame = useCurrentFrame();

  const glowStrength = interpolate(
    frame % 90,
    [0, 45, 90],
    [0.12, 0.25, 0.12],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  return (
    <div
      style={{
        background: 'rgba(0, 0, 0, 0.5)',
        backdropFilter: 'blur(16px)',
        WebkitBackdropFilter: 'blur(16px)',
        borderRadius: 20,
        padding: '56px 64px',
        border: `1px solid rgba(255, 255, 255, ${glowStrength})`,
        boxShadow: `0 0 ${20 * glowStrength}px rgba(0, 224, 200, ${glowStrength * 0.4}), 0 8px 32px rgba(0, 0, 0, 0.3)`,
      }}
    >
      {children}
    </div>
  );
};

// ─── Section Counter ────────────────────────────────────────────
const SectionCounter: React.FC<{
  sectionIndex: number;
  totalSections: number;
}> = ({ sectionIndex, totalSections }) => {
  const frame = useCurrentFrame();

  const opacity = interpolate(frame, [10, 25], [0, 0.6], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const current = String(sectionIndex + 1).padStart(2, '0');
  const total = String(totalSections).padStart(2, '0');

  return (
    <div
      style={{
        position: 'absolute',
        top: 36,
        left: 40,
        zIndex: 5,
        opacity,
        display: 'flex',
        alignItems: 'baseline',
        gap: 4,
        fontFamily: "'Inter', sans-serif",
      }}
    >
      <span style={{ fontSize: 28, fontWeight: 700, color: '#00E0C8' }}>{current}</span>
      <span style={{ fontSize: 18, fontWeight: 300, color: 'rgba(255,255,255,0.4)' }}>/ {total}</span>
    </div>
  );
};

// ─── Electric Pulse (periodic glow that fires and fades) ────────
// Returns a 0-1 intensity value. Fires every ~120 frames (4s at 30fps).
function useElectricPulse(frame: number, settleFrame: number): number {
  const idleFrame = Math.max(0, frame - settleFrame);
  if (idleFrame <= 0) return 0;
  const cycle = idleFrame % 120;
  if (cycle < 20) return cycle / 20;            // gradual ramp up (20 frames)
  if (cycle < 100) return 1 - (cycle - 20) / 80; // slow gentle fade out
  return 0;                                      // rest before next pulse
}

// Helper: generate electric pulse text-shadow CSS
function electricShadow(intensity: number, color = '0, 224, 200'): string {
  if (intensity <= 0.01) return 'none';
  const r1 = 10 + 20 * intensity;
  const r2 = 25 + 40 * intensity;
  const a1 = 0.25 * intensity;
  const a2 = 0.08 * intensity;
  return `0 0 ${r1}px rgba(${color}, ${a1}), 0 0 ${r2}px rgba(${color}, ${a2})`;
}

// ─── Count-Up Number with Impact Punch + Idle Bob ───────────────
const CountUpNumber: React.FC<{
  value: string;
  delay?: number;
  durationInFrames: number;
}> = ({ value, delay = 0, durationInFrames }) => {
  const frame = useCurrentFrame();

  const match = value.match(/^([<>$~]*)([0-9,.]+)(.*)$/);
  if (!match) {
    const opacity = interpolate(frame, [delay, delay + 15], [0, 1], {
      extrapolateLeft: 'clamp',
      extrapolateRight: 'clamp',
    });
    return <span style={{ opacity }}>{value}</span>;
  }

  const prefix = match[1];
  const numStr = match[2].replace(/,/g, '');
  const suffix = match[3];
  const targetNum = parseFloat(numStr);

  const countDuration = Math.min(45, durationInFrames * 0.3);
  const countEnd = delay + 8 + countDuration;
  const progress = interpolate(
    frame,
    [delay + 8, countEnd],
    [0, 1],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp', easing: Easing.out(Easing.cubic) }
  );

  const currentNum = targetNum * progress;

  let formatted: string;
  if (numStr.includes('.')) {
    const decimals = numStr.split('.')[1]?.length || 0;
    formatted = currentNum.toFixed(decimals).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  } else {
    formatted = Math.round(currentNum).toLocaleString('en-US');
  }

  const opacity = interpolate(frame, [delay, delay + 10], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Impact punch
  const punchScale = interpolate(
    frame,
    [countEnd - 2, countEnd, countEnd + 6, countEnd + 15],
    [1, 1.12, 0.97, 1],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  // Glow burst at impact
  const glowIntensity = interpolate(
    frame,
    [countEnd - 2, countEnd + 3, countEnd + 25],
    [0, 1, 0.2],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  // Electric pulse after settling
  const pulse = useElectricPulse(frame, countEnd + 20);

  const totalGlow = Math.max(glowIntensity, pulse);

  return (
    <span
      style={{
        opacity,
        display: 'inline-block',
        transform: `scale(${punchScale})`,
        textShadow: `0 0 ${40 * totalGlow}px rgba(0, 224, 200, ${0.7 * totalGlow}), 0 0 ${80 * totalGlow}px rgba(0, 224, 200, ${0.3 * totalGlow})`,
      }}
    >
      {prefix}{formatted}{suffix}
    </span>
  );
};

// ─── Slide Layout Props ─────────────────────────────────────────
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

// ─── Main Slide Layout ──────────────────────────────────────────
export const SlideLayout: React.FC<SlideLayoutProps> = ({
  slide,
  sectionTitle,
  bgHue,
  bgVideo,
  durationInFrames,
  sectionIndex,
  totalSections,
  slideNumber,
  totalSlides,
  statColorIndex,
}) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const fadeIn = interpolate(frame, [0, 15], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const fadeOut = interpolate(
    frame,
    [durationInFrames - 15, durationInFrames],
    [1, 0],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );
  const opacity = Math.min(fadeIn, fadeOut);

  const slideUp = interpolate(frame, [0, 20], [40, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const progress = interpolate(frame, [0, durationInFrames], [0, 100], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  if (slide.type === 'intro') {
    return (
      <IntroSlide
        slide={slide}
        durationInFrames={durationInFrames}
        bgVideo={bgVideo}
        sectionIndex={sectionIndex}
        totalSections={totalSections}
      />
    );
  }

  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        position: 'relative',
        overflow: 'hidden',
        fontFamily: "'Inter', sans-serif",
        background: '#0a0a0f',
      }}
    >
      <VideoBackground bgVideo={bgVideo} durationInFrames={durationInFrames} />
      <FloatingParticles />
      <SectionCounter sectionIndex={sectionIndex} totalSections={totalSections} />

      {/* Content -- left 2/3 of screen */}
      <div
        style={{
          position: 'relative',
          zIndex: 4,
          width: '66.666%',
          height: '100%',
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          alignItems: 'center',
          padding: '60px 60px 60px 80px',
          opacity,
          transform: `translateY(${slideUp}px)`,
        }}
      >
        <GlassCard>
          {slide.type === 'title' && <TitleContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
          {slide.type === 'stat' && <StatContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
          {slide.type === 'body' && <BodyContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
          {slide.type === 'company' && <CompanyContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
          {slide.type === 'comparison' && <ComparisonContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
          {slide.type === 'funnel' && <FunnelContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
          {slide.type === 'cta' && <CTAContent slide={slide} frame={frame} fps={fps} durationInFrames={durationInFrames} slideNumber={slideNumber} statColorIndex={statColorIndex} />}
        </GlassCard>
      </div>

      {/* Progress bar */}
      <div
        style={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          width: '100%',
          height: 4,
          background: 'rgba(255,255,255,0.06)',
          zIndex: 5,
        }}
      >
        <div
          style={{
            height: '100%',
            width: `${progress}%`,
            background: 'linear-gradient(90deg, #00E0C8, #FFB347)',
            borderRadius: 2,
          }}
        />
      </div>
    </div>
  );
};

// ─── Video Background Component ─────────────────────────────────
const VideoBackground: React.FC<{
  bgVideo: string;
  durationInFrames: number;
}> = ({ bgVideo, durationInFrames }) => {
  const frame = useCurrentFrame();

  const scale = interpolate(frame, [0, durationInFrames], [1.0, 1.08], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <Video
      src={staticFile(`backgrounds/${bgVideo}`)}
      style={{
        position: 'absolute',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        objectFit: 'cover',
        transform: `scale(${scale})`,
        zIndex: 0,
      }}
      volume={0}
      loop
    />
  );
};

// ─── Intro Slide ────────────────────────────────────────────────
const IntroSlide: React.FC<{
  slide: any;
  durationInFrames: number;
  bgVideo: string;
  sectionIndex: number;
  totalSections: number;
}> = ({ slide, durationInFrames, bgVideo, sectionIndex, totalSections }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const titleScale = spring({ frame, fps, config: { damping: 15, stiffness: 80 }, delay: 5 });
  const subtitleOpacity = interpolate(frame, [25, 45], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const subtitleY = interpolate(frame, [25, 45], [30, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const glowPulse = interpolate(
    frame,
    [30, 60, 90, 120, 150],
    [0, 0.8, 0.4, 0.7, 0.4],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  // Electric pulse after title settles
  const pulse = useElectricPulse(frame, 50);

  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        position: 'relative',
        overflow: 'hidden',
        background: '#0a0a0f',
        fontFamily: "'Inter', sans-serif",
      }}
    >
      <VideoBackground bgVideo={bgVideo} durationInFrames={durationInFrames} />
      <FloatingParticles />
      <SectionCounter sectionIndex={sectionIndex} totalSections={totalSections} />

      <div
        style={{
          position: 'relative',
          zIndex: 4,
          width: '66.666%',
          height: '100%',
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'center',
          alignItems: 'center',
          padding: '60px 60px 60px 80px',
        }}
      >
        <GlassCard>
          <div>
            <h1
              style={{
                fontSize: 110,
                fontWeight: 900,
                color: 'white',
                letterSpacing: '-2px',
                transform: `scale(${titleScale})`,
                textShadow: electricShadow(Math.max(glowPulse, pulse)),
                margin: 0,
                textAlign: 'center',
              }}
            >
              {slide.text}
            </h1>
            {slide.highlight && (
              <p
                style={{
                  fontSize: 52,
                  fontWeight: 300,
                  background: 'linear-gradient(90deg, #00E0C8, #FFB347)',
                  WebkitBackgroundClip: 'text',
                  WebkitTextFillColor: 'transparent',
                  opacity: subtitleOpacity,
                  transform: `translateY(${subtitleY}px)`,
                  marginTop: 24,
                  letterSpacing: '0.5px',
                  textAlign: 'center',
                }}
              >
                {slide.highlight}
              </p>
            )}
          </div>
        </GlassCard>
      </div>
    </div>
  );
};

// ─── Slide Content Components ───────────────────────────────────

interface ContentProps {
  slide: any;
  frame: number;
  fps: number;
  durationInFrames: number;
  slideNumber: number;
  statColorIndex: number;
}

// ── Title Slide ──
const TitleContent: React.FC<ContentProps> = ({ slide, frame, fps }) => {
  const titleScale = spring({ frame, fps, config: { damping: 14, stiffness: 70 }, delay: 3 });

  const highlightOpacity = interpolate(frame, [18, 35], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const highlightY = interpolate(frame, [18, 35], [25, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const underlineWidth = interpolate(frame, [35, 55], [0, 100], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  // Electric pulse after settle
  const pulse = useElectricPulse(frame, 55);

  return (
    <div>
      <h2
        style={{
          fontSize: 82,
          fontWeight: 800,
          color: 'white',
          letterSpacing: '-1.5px',
          lineHeight: 1.1,
          transform: `scale(${titleScale})`,
          margin: 0,
          textShadow: pulse > 0.01 ? electricShadow(pulse) : '0 2px 20px rgba(0,0,0,0.5)',
        }}
      >
        {slide.text}
      </h2>
      <div
        style={{
          width: `${underlineWidth}%`,
          maxWidth: 300,
          height: 3,
          background: 'linear-gradient(90deg, #00E0C8, transparent)',
          margin: '20px auto',
          borderRadius: 2,
        }}
      />
      {slide.highlight && (
        <p
          style={{
            fontSize: 38,
            fontWeight: 300,
            color: 'rgba(255,255,255,0.85)',
            textShadow: '0 2px 8px rgba(0,0,0,0.7)',
            opacity: highlightOpacity,
            transform: `translateY(${highlightY}px)`,
            margin: 0,
            letterSpacing: '0.3px',
          }}
        >
          {slide.highlight}
        </p>
      )}
    </div>
  );
};

// ── Stat Slide (BIG number, alternating teal/orange) ──
const StatContent: React.FC<ContentProps> = ({ slide, frame, fps, durationInFrames, statColorIndex }) => {
  // Alternate colors based on stat-type slide index
  const useOrange = statColorIndex % 2 === 1;
  const statColor = useOrange ? '#FFB347' : '#00E0C8';
  const labelColor = useOrange ? '#00E0C8' : '#FFB347';
  const statScale = spring({
    frame,
    fps,
    config: { damping: 12, stiffness: 60 },
    delay: 5,
  });

  const labelOpacity = interpolate(frame, [30, 45], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const labelY = interpolate(frame, [30, 45], [15, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const sourceOpacity = interpolate(frame, [5, 18], [0, 0.5], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <>
      {/* Source attribution (small, top) */}
      <p
        style={{
          fontSize: 20,
          fontWeight: 400,
          color: 'rgba(255,255,255,0.5)',
          textTransform: 'uppercase',
          letterSpacing: '3px',
          opacity: sourceOpacity,
          margin: '0 0 20px 0',
        }}
      >
        {slide.text}
      </p>

      {/* BIG number */}
      {slide.stat && (
        <div
          style={{
            fontSize: 140,
            fontWeight: 900,
            color: statColor,
            letterSpacing: '-4px',
            lineHeight: 1,
            transform: `scale(${statScale})`,
            marginBottom: 16,
          }}
        >
          <CountUpNumber value={slide.stat} delay={5} durationInFrames={durationInFrames} />
        </div>
      )}

      {/* Label */}
      {slide.statLabel && (
        <p
          style={{
            fontSize: 26,
            fontWeight: 600,
            color: labelColor,
            textTransform: 'uppercase',
            letterSpacing: '4px',
            opacity: labelOpacity,
            transform: `translateY(${labelY}px)`,
            margin: 0,
          }}
        >
          {slide.statLabel}
        </p>
      )}
    </>
  );
};

// ── Body Slide (short text + big highlight) ──
const BodyContent: React.FC<ContentProps> = ({ slide, frame, fps }) => {
  const textOpacity = interpolate(frame, [5, 18], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const highlightDelay = 20;
  const highlightOpacity = interpolate(frame, [highlightDelay, highlightDelay + 15], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const highlightScale = spring({
    frame: Math.max(0, frame - highlightDelay),
    fps,
    config: { damping: 12, stiffness: 80 },
  });

  const pulse = useElectricPulse(frame, highlightDelay + 20);

  return (
    <div>
      <p
        style={{
          fontSize: 36,
          fontWeight: 300,
          color: 'rgba(255,255,255,0.8)',
          textShadow: pulse > 0.01 ? electricShadow(pulse) : '0 2px 8px rgba(0,0,0,0.7)',
          lineHeight: 1.5,
          margin: '0 0 28px 0',
          opacity: textOpacity,
        }}
      >
        {slide.text}
      </p>
      {slide.highlight && (
        <div style={{ opacity: highlightOpacity, transform: `scale(${highlightScale})` }}>
          <p
            style={{
              fontSize: 52,
              fontWeight: 700,
              background: 'linear-gradient(90deg, #00E0C8, #FFB347)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              margin: 0,
              lineHeight: 1.3,
            }}
          >
            {slide.highlight}
          </p>
        </div>
      )}
    </div>
  );
};

// ── Company Slide (company name + BIG alternating stat) ──
const CompanyContent: React.FC<ContentProps> = ({ slide, frame, fps, durationInFrames, statColorIndex }) => {
  const useOrange = statColorIndex % 2 === 1;
  const statColor = useOrange ? '#FFB347' : '#00E0C8';
  const labelColor = useOrange ? '#00E0C8' : '#FFB347';
  const statScale = spring({
    frame,
    fps,
    config: { damping: 12, stiffness: 60 },
    delay: 3,
  });

  const labelOpacity = interpolate(frame, [25, 40], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const nameOpacity = interpolate(frame, [3, 15], [0, 0.6], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <>
      {/* Company name (small, top) */}
      <p
        style={{
          fontSize: 22,
          fontWeight: 500,
          color: 'rgba(255,255,255,0.6)',
          textTransform: 'uppercase',
          letterSpacing: '4px',
          opacity: nameOpacity,
          margin: '0 0 20px 0',
        }}
      >
        {slide.text}
      </p>

      {/* BIG stat */}
      {slide.stat && (
        <div
          style={{
            fontSize: 130,
            fontWeight: 900,
            color: statColor,
            letterSpacing: '-4px',
            lineHeight: 1,
            transform: `scale(${statScale})`,
            marginBottom: 16,
          }}
        >
          <CountUpNumber value={slide.stat} delay={3} durationInFrames={durationInFrames} />
        </div>
      )}

      {/* Label */}
      {slide.statLabel && (
        <p
          style={{
            fontSize: 24,
            fontWeight: 600,
            color: labelColor,
            textTransform: 'uppercase',
            letterSpacing: '4px',
            opacity: labelOpacity,
            margin: 0,
          }}
        >
          {slide.statLabel}
        </p>
      )}
    </>
  );
};

// ── Comparison Slide ──
const ComparisonContent: React.FC<ContentProps> = ({ slide, frame, fps, durationInFrames, statColorIndex }) => {
  const useOrange = statColorIndex % 2 === 1;
  const statColor = useOrange ? '#FFB347' : '#00E0C8';
  const labelColor = useOrange ? '#00E0C8' : '#FFB347';
  const statScale = spring({
    frame,
    fps,
    config: { damping: 12, stiffness: 60 },
    delay: 3,
  });

  const labelOpacity = interpolate(frame, [20, 35], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const lines = slide.text.split('\n');

  return (
    <>
      {slide.stat && (
        <div
          style={{
            fontSize: 120,
            fontWeight: 900,
            color: statColor,
            letterSpacing: '-3px',
            transform: `scale(${statScale})`,
            marginBottom: 12,
          }}
        >
          <CountUpNumber value={slide.stat} delay={3} durationInFrames={durationInFrames} />
        </div>
      )}
      {slide.statLabel && (
        <p
          style={{
            fontSize: 22,
            fontWeight: 600,
            color: labelColor,
            textTransform: 'uppercase',
            letterSpacing: '4px',
            opacity: labelOpacity,
            margin: '0 0 28px 0',
          }}
        >
          {slide.statLabel}
        </p>
      )}
      <div style={{ maxWidth: 600, margin: '0 auto' }}>
        {lines.map((line: string, i: number) => {
          const lineDelay = 10 + i * 6;
          const lineOpacity = interpolate(frame, [lineDelay, lineDelay + 10], [0, 0.8], {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
          });

          return (
            <div
              key={i}
              style={{
                opacity: lineOpacity,
                fontSize: 26,
                fontWeight: 400,
                color: 'rgba(255,255,255,0.85)',
                textShadow: '0 2px 6px rgba(0,0,0,0.5)',
                marginBottom: 6,
                textAlign: 'left',
              }}
            >
              {line}
            </div>
          );
        })}
      </div>
    </>
  );
};

// ── Funnel Slide ──
const FunnelContent: React.FC<ContentProps> = ({ slide, frame, fps, durationInFrames }) => {
  const lines = slide.text.split('\n');
  const statScale = spring({
    frame,
    fps,
    config: { damping: 12, stiffness: 60 },
    delay: 3,
  });

  return (
    <>
      {slide.stat && (
        <div
          style={{
            fontSize: 120,
            fontWeight: 900,
            color: '#FFB347',
            letterSpacing: '-3px',
            transform: `scale(${statScale})`,
            marginBottom: 12,
          }}
        >
          <CountUpNumber value={slide.stat} delay={3} durationInFrames={durationInFrames} />
        </div>
      )}
      {slide.statLabel && (
        <p
          style={{
            fontSize: 22,
            fontWeight: 600,
            color: '#00E0C8',
            textTransform: 'uppercase',
            letterSpacing: '4px',
            margin: '0 0 32px 0',
          }}
        >
          {slide.statLabel}
        </p>
      )}
      <div style={{ maxWidth: 600, margin: '0 auto' }}>
        {lines.map((line: string, i: number) => {
          const lineDelay = 10 + i * 8;
          const lineOpacity = interpolate(frame, [lineDelay, lineDelay + 12], [0, 1], {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
          });
          const slideX = interpolate(frame, [lineDelay, lineDelay + 12], [-30, 0], {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
            easing: Easing.out(Easing.cubic),
          });
          const widthPct = 100 - i * 15;

          return (
            <div
              key={i}
              style={{
                opacity: lineOpacity,
                transform: `translateX(${slideX}px)`,
                width: `${Math.max(widthPct, 40)}%`,
                margin: '0 auto',
                padding: '10px 20px',
                marginBottom: 8,
                background: `rgba(255,255,255,${0.05 + i * 0.02})`,
                borderLeft: `3px solid rgba(0, 224, 200, ${0.3 + i * 0.15})`,
                borderRadius: 4,
                fontSize: 24,
                fontWeight: 400,
                color: 'rgba(255,255,255,0.9)',
                textShadow: '0 2px 6px rgba(0,0,0,0.5)',
                textAlign: 'left',
              }}
            >
              {line}
            </div>
          );
        })}
      </div>
    </>
  );
};

// ── CTA Slide ──
const CTAContent: React.FC<ContentProps> = ({ slide, frame }) => {
  const textOpacity = interpolate(frame, [5, 18], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const highlightDelay = 20;
  const highlightOpacity = interpolate(frame, [highlightDelay, highlightDelay + 15], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const breathe = interpolate(
    frame % 60,
    [0, 30, 60],
    [0.5, 1, 0.5],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  const pulse = useElectricPulse(frame, 35);

  return (
    <div>
      <p
        style={{
          fontSize: 38,
          fontWeight: 300,
          color: 'rgba(255,255,255,0.8)',
          textShadow: pulse > 0.01 ? electricShadow(pulse) : '0 2px 8px rgba(0,0,0,0.7)',
          lineHeight: 1.5,
          margin: '0 0 32px 0',
          opacity: textOpacity,
        }}
      >
        {slide.text}
      </p>
      {slide.highlight && (
        <p
          style={{
            fontSize: 52,
            fontWeight: 800,
            background: 'linear-gradient(90deg, #00E0C8, #FFB347)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            opacity: highlightOpacity,
            margin: 0,
            textShadow: `0 0 ${40 * breathe}px rgba(0, 224, 200, ${0.3 * breathe})`,
          }}
        >
          {slide.highlight}
        </p>
      )}
    </div>
  );
};
