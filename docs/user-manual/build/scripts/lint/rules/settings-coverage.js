import { existsSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { visit } from "unist-util-visit";
import yaml from "yaml";
import { report, proseText } from "./severity.js";

const here = dirname(fileURLToPath(import.meta.url));

function registryFor(filePath) {
  if (filePath.includes("/lint/fixtures/")) return join(here, "..", "fixtures", "parameters-test.yaml");
  let dir = dirname(resolve(filePath));
  for (let i = 0; i < 8; i++) {
    const candidate = join(dir, "parameters.yaml");
    if (existsSync(candidate)) return candidate;
    dir = dirname(dir);
  }
  return null;
}

export default function settingsCoverage() {
  return (tree, file) => {
    const path = file.path ?? "";
    if (!path.includes("/chapters/") && !path.includes("/lint/fixtures/")) return;
    let fm = null;
    visit(tree, "yaml", (n) => { fm = n; });
    if (!fm) return;
    let data;
    try { data = yaml.parse(fm.value); } catch { return; }
    const refs = data.parameters_refs ?? [];
    if (!Array.isArray(refs) || refs.length === 0) return;

    const regPath = registryFor(path);
    if (!regPath) { report(file, "parameters_refs set but no parameters.yaml found above this file", fm); return; }
    const registry = yaml.parse(readFileSync(regPath, "utf8"));
    const ops = registry.operations ?? {};

    // Collect the Settings section: paragraphs between "## Settings" and the next H2.
    // A paragraph documents a label only when the strong node's OWN text ends
    // with a period (the binding constraint: **Label.** with the period
    // inside the bold). A strong run whose text does NOT end with "." but
    // that, once trimmed, matches a label verbatim is recorded separately so
    // we can flag the period-outside-the-bold mistake without counting it as
    // documented.
    let inSettings = false; let sawSettings = false;
    const runIns = new Set();
    const outsideBold = new Set();
    visit(tree, (node) => {
      if (node.type === "heading" && node.depth === 2) {
        const t = proseText(node).trim();
        inSettings = /^Settings$/i.test(t);
        if (inSettings) sawSettings = true;
        return;
      }
      if (inSettings && node.type === "paragraph") {
        const first = node.children?.[0];
        if (first && first.type === "strong") {
          const strongText = proseText(first).trim();
          if (strongText.endsWith(".")) {
            runIns.add(strongText.replace(/\.$/, "").trim());
          } else {
            outsideBold.add(strongText);
          }
        }
      }
    });

    for (const id of refs) {
      const op = ops[id];
      if (!op) { report(file, `unknown parameters_refs id '${id}'`, fm); continue; }
      if (!sawSettings) { report(file, `parameters_refs names '${id}' but the chapter has no '## Settings' section`, fm); continue; }
      for (const s of op.settings ?? []) {
        if (outsideBold.has(s.label)) {
          report(file, `setting '${s.label}' of '${id}' is written as **${s.label}** with the period outside the bold; write **${s.label}.**`, fm);
        }
        if (!runIns.has(s.label)) {
          report(file, `setting '${s.label}' of '${id}' is not documented in '## Settings' (expected a paragraph starting with **${s.label}.**)`, fm);
        }
      }
    }
  };
}
