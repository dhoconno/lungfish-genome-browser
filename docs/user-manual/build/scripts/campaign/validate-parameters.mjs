#!/usr/bin/env node
import { readFileSync, existsSync } from "node:fs";
import { resolve, join } from "node:path";
import yaml from "yaml";
const file = resolve(process.argv[2]);
const doc = yaml.parse(readFileSync(file, "utf8"));
const CONTROLS = new Set(["checkbox", "number", "slider", "popup", "text", "file", "radio"]);
const lockPath = resolve(process.cwd(), "Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json");
const packIds = new Set(["docker", "experimental"]);
if (existsSync(lockPath)) for (const t of JSON.parse(readFileSync(lockPath, "utf8")).packTools ?? []) if (t.packID) packIds.add(t.packID);
const OP_KEYS = ["title", "entry_points", "gating", "sources", "settings", "cli_only", "notes"];
const SET_KEYS = ["label", "control", "default", "allowed", "effect", "when_to_change", "cli_flag"];
let bad = 0; const say = (s) => { console.log(s); bad++; };
for (const [id, op] of Object.entries(doc.operations ?? {})) {
  for (const k of OP_KEYS) if (!(k in op)) say(`${id}: missing '${k}'`);
  for (const g of op.gating ?? []) if (!packIds.has(g)) say(`${id}: gating '${g}' is not docker, experimental, or a known pack id`);
  (op.settings ?? []).forEach((s, i) => { for (const k of SET_KEYS) if (!(k in s)) say(`${id}: setting #${i + 1} missing '${k}'`); if (s.control && !CONTROLS.has(s.control)) say(`${id}: setting '${s.label}' control '${s.control}' not allowed`); });
}
console.log(bad ? `${bad} problem(s)` : "parameters ok"); process.exit(bad ? 1 : 0);
