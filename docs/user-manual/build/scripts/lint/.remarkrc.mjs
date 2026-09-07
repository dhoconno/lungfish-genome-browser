import frontmatter from "remark-frontmatter";
import appName from "./rules/app-name.js";
import palette from "./rules/palette.js";
import typography from "./rules/typography.js";
import voice from "./rules/voice.js";
import primerBeforeProcedure from "./rules/primer-before-procedure.js";
import frontmatterRule from "./rules/frontmatter.js";
import dataViz from "./rules/data-viz.js";
import emDash from "./rules/em-dash.js";
import bulletCap from "./rules/bullet-cap.js";
import semicolon from "./rules/semicolon.js";
import sentenceColon from "./rules/sentence-colon.js";
import aiTells from "./rules/ai-tells.js";

export default {
  plugins: [
    [frontmatter, ["yaml"]],
    appName,
    palette,
    typography,
    voice,
    primerBeforeProcedure,
    frontmatterRule,
    dataViz,
    emDash,
    bulletCap,
    semicolon,
    sentenceColon,
    aiTells,
  ],
};
