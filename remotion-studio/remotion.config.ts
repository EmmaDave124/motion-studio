import { Config } from "@remotion/cli/config";

// WebGL needs the "angle" renderer for 3D scenes to render headless
Config.setChromiumOpenGlRenderer("angle");
Config.setVideoImageFormat("jpeg");
Config.setOverwriteOutput(true);
