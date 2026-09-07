#!/usr/bin/env node
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, dirname, resolve, relative } from "node:path";

const root = resolve(process.argv[2] ?? ".");
const files = [];
(function walk(d) { for (const e of readdirSync(d)) { const p = join(d, e); if (statSync(p).isDirectory()) { if (!["build", "node_modules", "assets", "fixtures", "reviews", "shots"].includes(e)) walk(p); } else if (p.endsWith(".md")) files.push(p); } })(root);

const LINK = /\[[^\]]*\]\(([^)\s]+)\)/g;
const H = /^#{2,3}\s+(.+?)\s*$/gm;
const ANCHOR = /\{#([a-z0-9-]+)\}/g;
function slug(s) { return s.toLowerCase().replace(/[`*_]/g, "").replace(/[^a-z0-9 -]/g, "").trim().replace(/\s+/g, "-"); }
const anchors = new Map();
for (const f of files) {
  const t = readFileSync(f, "utf8"); const set = new Set();
  for (const m of t.matchAll(H)) set.add(slug(m[1]));
  for (const m of t.matchAll(ANCHOR)) set.add(m[1]);
  anchors.set(f, set);
}
let bad = 0;
for (const f of files) {
  const lines = readFileSync(f, "utf8").split("\n");
  lines.forEach((line, i) => {
    for (const m of line.matchAll(LINK)) {
      const target = m[1];
      if (/^(https?:|mailto:|#)/.test(target)) { if (target.startsWith("#") && !anchors.get(f).has(target.slice(1))) { console.log(`${relative(root, f)}:${i + 1} ${target}`); bad++; } continue; }
      const [pathPart, frag] = target.split("#");
      const abs = resolve(dirname(f), pathPart);
      if (!existsSync(abs)) { console.log(`${relative(root, f)}:${i + 1} ${target}`); bad++; continue; }
      if (frag && anchors.has(abs) && !anchors.get(abs).has(frag)) { console.log(`${relative(root, f)}:${i + 1} ${target}`); bad++; }
    }
  });
}
console.log(bad ? `${bad} broken link(s)` : "links ok");
process.exit(bad ? 1 : 0);
