import { report, proseText } from "./severity.js";

// A colon may end a short lead-in immediately before a list, table, or code
// block. Anywhere else in prose it is a joiner and is banned.
const LEAD_IN_FOLLOWERS = new Set(["list", "table", "code"]);
const TIME_OR_RATIO = /\d:\d/g;

export default function sentenceColon() {
  return (tree, file) => {
    walk(tree);

    function walk(parent) {
      if (!parent.children) return;
      parent.children.forEach((node, i) => {
        if (node.type === "paragraph" || node.type === "heading" || node.type === "tableCell") {
          check(node, parent.children[i + 1]);
        }
        if (node.type !== "code" && node.type !== "html") walk(node);
      });
    }

    function check(node, next) {
      const text = proseText(node).replace(TIME_OR_RATIO, "  ");
      const trimmed = text.trimEnd();
      const colons = [...trimmed].filter((c) => c === ":").length;
      if (colons === 0) return;
      const endsWithColon = trimmed.endsWith(":");
      const followerOk = next && LEAD_IN_FOLLOWERS.has(next.type);
      const allowedLeadIn = node.type === "paragraph" && endsWithColon && followerOk;
      const banned = allowedLeadIn ? colons - 1 : colons;
      for (let k = 0; k < banned; k++) {
        report(file, "colon inside a sentence. Use a period and a new sentence, or restructure. A colon may only end a lead-in line right before a list, table, or code block.", node);
      }
    }
  };
}
