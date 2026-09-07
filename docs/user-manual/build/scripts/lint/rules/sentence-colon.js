import { report, proseText } from "./severity.js";

// A colon may end a short lead-in immediately before a list, table, or code
// block. Anywhere else in prose it is a joiner and is banned.
const LEAD_IN_FOLLOWERS = new Set(["list", "table", "code"]);
const TIME_OR_RATIO = /\d:\d/g;
const URL_TOKEN = /\b[a-z][a-z0-9+.-]*:\/\/\S+/gi;

export default function sentenceColon() {
  return (tree, file) => {
    walk(tree);

    function walk(parent) {
      if (!parent.children) return;
      parent.children.forEach((node, i) => {
        if (node.type === "paragraph" || node.type === "heading" || node.type === "tableCell") {
          check(node, follower(parent.children, i));
        }
        if (node.type !== "code" && node.type !== "html") walk(node);
      });
    }

    // The follower of a paragraph is the next sibling that is not one of the
    // <!-- SHOT: id --> screenshot marker nodes remark parses as `html`.
    function follower(siblings, i) {
      let j = i + 1;
      while (siblings[j] && siblings[j].type === "html") j++;
      return siblings[j];
    }

    function check(node, next) {
      const text = proseText(node).replace(URL_TOKEN, "").replace(TIME_OR_RATIO, "  ");
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
