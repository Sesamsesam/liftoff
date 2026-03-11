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
