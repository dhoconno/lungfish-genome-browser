import { visitParents } from "unist-util-visit-parents";

const PALETTE = new Set(["#EE8B4F", "#F6B088", "#1F1A17", "#FAF4EA", "#8A847A"]);
const HEX = /#[0-9A-Fa-f]{6}\b/g;

export default function palette() {
  return (tree, file) => {
    visitParents(tree, ["text", "html"], (node, ancestors) => {
      if (node.type === "text" && ancestors.some((a) => a.type === "inlineCode" || a.type === "code")) {
        return;
      }
      const v = node.value ?? "";
      for (const match of v.matchAll(HEX)) {
        const hex = match[0].toUpperCase();
        if (!PALETTE.has(hex)) {
          file.message(`Non-palette hex ${hex} — allowed: Creamsicle #EE8B4F, Peach #F6B088, Deep Ink #1F1A17, Cream #FAF4EA, Warm Grey #8A847A`, node);
        }
      }
    });
  };
}
