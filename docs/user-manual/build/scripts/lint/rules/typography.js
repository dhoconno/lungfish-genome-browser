import { visit } from "unist-util-visit";

const ALLOWED = /(Space Grotesk|Inter|IBM Plex Mono|Arial|Consolas)/i;
const FONT_DECL = /font-family\s*:\s*([^;"}]+)/gi;

export default function typography() {
  return (tree, file) => {
    visit(tree, "html", (node) => {
      for (const match of node.value.matchAll(FONT_DECL)) {
        const decl = match[1].trim();
        if (!ALLOWED.test(decl)) {
          file.message(`Non-brand font-family '${decl}' — allowed: Space Grotesk, Inter, IBM Plex Mono (fallbacks Arial, Consolas)`, node);
        }
      }
    });
  };
}
