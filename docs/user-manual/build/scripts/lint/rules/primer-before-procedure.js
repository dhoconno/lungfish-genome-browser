import { visit } from "unist-util-visit";

const PRIMER_HEADINGS = /^(What it is|Why this matters)\s*$/i;
const PROCEDURE_HEADING = /^Procedure\b/i;

export default function primerBeforeProcedure() {
  return (tree, file) => {
    let seenPrimer = false;
    let flagged = false;
    visit(tree, "heading", (node) => {
      if (flagged) return;
      if (node.depth !== 2) return;
      const text = node.children.map((c) => c.value ?? "").join("");
      if (PRIMER_HEADINGS.test(text.trim())) seenPrimer = true;
      if (PROCEDURE_HEADING.test(text.trim()) && !seenPrimer) {
        file.message("'## Procedure' before any primer section ('## What it is' or '## Why this matters')", node);
        flagged = true;
      }
    });
  };
}
