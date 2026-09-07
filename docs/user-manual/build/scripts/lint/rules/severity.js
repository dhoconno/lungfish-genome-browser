// Shared helpers for the 2026-09 campaign prose rules.
//
// report(): emits a lint message that fails the run. Strict is the default
// now that every chapter has been rewritten (2026-09 campaign, Task 6.1).
// Set LUNGFISH_MANUAL_STRICT=0 to make the campaign rules informational
// again, for instance while drafting a chapter that is not yet gated.
//
// proseText(): the visible prose of a block node, with code, HTML, and link
// URLs removed, so punctuation and word rules never fire on code or paths.
export function report(file, message, node) {
  const msg = file.message(message, node);
  if (process.env.LUNGFISH_MANUAL_STRICT === "0") msg.fatal = false;
  return msg;
}

export function proseText(node) {
  if (!node) return "";
  if (node.type === "inlineCode" || node.type === "code" || node.type === "html") return "";
  if (node.type === "text") return node.value;
  if (!node.children) return "";
  return node.children.map(proseText).join("");
}
