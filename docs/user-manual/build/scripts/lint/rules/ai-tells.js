import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { visit } from "unist-util-visit";
import { report, proseText } from "./severity.js";

const here = dirname(fileURLToPath(import.meta.url));
const WORDS = readFileSync(join(here, "ai-tells-words.txt"), "utf8")
  .split("\n")
  .map((l) => l.trim().toLowerCase())
  .filter((l) => l && !l.startsWith("#"));

function escapeRe(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

// Build a suffix-tolerant regex for one word-list entry. The entry's last
// word carries the inflection; any earlier words are joined with a
// whitespace-or-hyphen separator and matched literally.
function buildRegex(entry) {
  const parts = entry.split(" ");
  const last = parts.pop();
  const prefix = parts.length ? parts.map(escapeRe).join("[\\s-]+") + "[\\s-]+" : "";

  let stem;
  let suffixGroup;
  if (last.length > 1 && last.endsWith("e")) {
    stem = last.slice(0, -1);
    suffixGroup = "(?:e|es|ed|ing|er|ers|ion|ely)?";
  } else if (last.length > 1 && last.endsWith("y")) {
    stem = last.slice(0, -1);
    suffixGroup = "(?:y|ies|ied|ily)?";
  } else {
    stem = last;
    suffixGroup = "(?:s|es|ed|ing|er|ers|ity|ful|ly)?";
  }

  return new RegExp(`\\b${prefix}${escapeRe(stem)}${suffixGroup}\\b`, "i");
}

const WORD_RES = WORDS.map((w) => ({ word: w, re: buildRegex(w) }));

// Sentence patterns from the same source.
const PATTERNS = [
  { name: `"It's not X, it's Y"`, re: /\bit['’]s not (about |just )?[^.,;]{1,60},? (it['’]s|but) (about |it['’]s )?/i },
  { name: `"That's not X, that's Y"`, re: /\bthat['’]s not [^.,;]{1,60}, that['’]s /i },
  { name: `"Not because X. But because Y"`, re: /\bnot because [^.]{1,60}\. but because /i },
  { name: `"Not by X, but by Y"`, re: /\bnot by [^.,;]{1,60}, but by /i },
  { name: `"No X. No Y. Just Z"`, re: /\bno [^.]{1,30}\. no [^.]{1,30}\. just /i },
  { name: `"And the X? Y."`, re: /\band the [^?]{1,30}\? [A-Z]/ },
  { name: `"The result? Y."`, re: /\bthe (result|outcome|fix|answer)\? /i },
];

const QUOTED = /"[^"\n]{1,80}"/g;

export default function aiTells() {
  return (tree, file) => {
    visit(tree, (node) => {
      if (node.type !== "paragraph" && node.type !== "heading" && node.type !== "tableCell" && node.type !== "listItem") return;
      if (node.type === "listItem") return; // its paragraph child is visited on its own
      const text = proseText(node).replace(QUOTED, " ");
      for (const { word, re } of WORD_RES) {
        const m = text.match(re);
        if (m) report(file, `overused word '${m[0]}' (list entry '${word}'). Say it plainly.`, node);
      }
      for (const { name, re } of PATTERNS) {
        if (re.test(text)) report(file, `sentence pattern ${name}. Rewrite as a plain statement.`, node);
      }
    });
  };
}
