import React from "react";
import { Composition } from "remotion";
import { Main } from "./Main";

// Set size, frame rate and length from the user's brief.
export const RemotionRoot: React.FC = () => {
  return (
    <Composition id="Main" component={Main} durationInFrames={150} fps={30} width={1920} height={1080} />
  );
};
