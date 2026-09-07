import { visit } from "unist-util-visit";
import { report, proseText } from "./severity.js";

// No semicolons in prose. Paragraphs, headings, list items, and table cells
// are prose. Code, HTML, and frontmatter are not.
const PROSE_BLOCKS = new Set(["paragraph", "heading", "tableCell"]);

export default function semicolon() {
  return (tree, file) => {
    visit(tree, (node) => {
      if (!PROSE_BLOCKS.has(node.type)) return;
      const text = proseText(node);
      let idx = text.indexOf(";");
      while (idx !== -1) {
        report(file, "semicolon in prose. Split the sentence.", node);
        idx = text.indexOf(";", idx + 1);
      }
    });
  };
}
