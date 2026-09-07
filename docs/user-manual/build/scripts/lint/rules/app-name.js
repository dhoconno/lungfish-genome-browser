import { visitParents } from "unist-util-visit-parents";
import { report } from "./severity.js";

const FULL = /\bLungfish Genome Explorer\b/;
const ABBREV = /\bLGE\b/;
const EXEMPT_AFTER = /\bLungfish(?= (Genome Explorer|Research Collaboratory|Air Kit|Wastewater Kit|Preview))/g;
const BARE = /\bLungfish\b(?! (Genome Explorer|Research Collaboratory|Air Kit|Wastewater Kit|Preview))/;
const BAD_CAPS = /\bLUNGFISH\b/;
const BAD_MIXED = /\bLungFish\b/;
const BAD_SPACED = /\bLung Fish\b/;
const BAD_LOWER = /(?<![`./\-_])\blungfish\b(?![-.])/;
const QUOTED = /"[^"\n]{1,80}"/g;

function inCode(ancestors) {
  return ancestors.some((a) => a.type === "inlineCode" || a.type === "code" || a.type === "html" || a.type === "yaml");
}

export default function appName() {
  return (tree, file) => {
    const path = file.path ?? "";
    const isChapter = path.includes("/chapters/") || path.includes("/lint/fixtures/");
    let seenFull = false;
    visitParents(tree, "text", (node, ancestors) => {
      if (inCode(ancestors)) return;
      const v = node.value.replace(QUOTED, " ");
      if (BAD_CAPS.test(v)) report(file, "LUNGFISH. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (BAD_MIXED.test(v)) report(file, "LungFish. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (BAD_SPACED.test(v)) report(file, "Lung Fish. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (BAD_LOWER.test(v)) report(file, "lowercase 'lungfish'. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (!isChapter) return;
      // Order matters within a text node: find the earliest of FULL and ABBREV.
      const fullIdx = v.search(FULL);
      const abbrIdx = v.search(ABBREV);
      if (!seenFull && abbrIdx !== -1 && (fullIdx === -1 || abbrIdx < fullIdx)) {
        report(file, "'LGE' before the first 'Lungfish Genome Explorer' in this chapter. Spell it out at first mention.", node);
      }
      if (fullIdx !== -1) seenFull = true;
      if (BARE.test(v)) report(file, "bare 'Lungfish' used for the app. Use 'Lungfish Genome Explorer' (first mention) or 'LGE'. 'Lungfish' alone is the collaborative.", node);
    });
  };
}
