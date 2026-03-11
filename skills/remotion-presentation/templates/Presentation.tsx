import React from 'react';
import { Sequence } from 'remotion';
import { SECTIONS, getSectionFrames } from './data/script';
import { SlideLayout } from './components/SlideLayout';
import './styles.css';

// Slide types that show a big colored number/stat
const STAT_TYPES = new Set(['stat', 'company', 'comparison', 'funnel']);

export const Presentation: React.FC = () => {
  let frameOffset = 0;
  let globalSlideIndex = 0;
  let statColorIndex = 0; // only increments for stat-like slides
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
