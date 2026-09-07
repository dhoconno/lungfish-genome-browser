// Shared helpers for the 2026-09 campaign prose rules.
//
// report(): emits a lint message that is informational unless
// LUNGFISH_MANUAL_STRICT=1, so the rules can land before every chapter has
// been rewritten. The per-chapter pipeline and the final gate run strict.
//
// proseText(): the visible prose of a block node, with code, HTML, and link
// URLs removed, so punctuation and word rules never fire on code or paths.
export function report(file, message, node) {
  const msg = file.message(message, node);
  if (process.env.LUNGFISH_MANUAL_STRICT !== "1") msg.fatal = false;
  return msg;
}

export function proseText(node) {
  if (!node) return "";
  if (node.type === "inlineCode" || node.type === "code" || node.type === "html") return "";
  if (node.type === "text") return node.value;
  if (!node.children) return "";
  return node.children.map(proseText).join("");
}
