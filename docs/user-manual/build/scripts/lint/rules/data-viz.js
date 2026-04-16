import { visit } from "unist-util-visit";

const PALETTE = new Set(["#EE8B4F", "#F6B088", "#1F1A17", "#FAF4EA", "#8A847A"]);
const RAG_HUES = [/\bred\b/i, /\bamber\b/i, /\bgreen\b/i, /#FF0000/i, /#00FF00/i, /#FFBB00/i, /#00AA00/i];

export default function dataViz() {
  return (tree, file) => {
    visit(tree, "code", (node) => {
      if (node.lang !== "vega-lite" && node.lang !== "vega") return;
      const hits = RAG_HUES.filter((p) => p.test(node.value));
      if (hits.length >= 2) {
        file.message(`chart appears to use red-amber-green coding — use Deep Ink weight + annotation instead`, node);
      }
      for (const m of node.value.matchAll(/#[0-9A-Fa-f]{6}\b/g)) {
        const hex = m[0].toUpperCase();
        if (!PALETTE.has(hex)) {
          file.message(`non-palette colour in chart: ${hex}`, node);
        }
      }
    });
  };
}
