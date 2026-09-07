#!/usr/bin/env node
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, resolve, basename, dirname } from "node:path";
const root = resolve(process.argv[2] ?? ".");
const chapters = join(root, "chapters");
const shotsDir = join(root, "assets", "screenshots");
const recipesDir = join(root, "assets", "recipes");
const MARK = /<!--\s*SHOT:\s*([a-z0-9][a-z0-9-]*)\s*-->/g;
const expected = new Set(); let bad = 0;
(function walk(d) { for (const e of readdirSync(d)) { const p = join(d, e); if (statSync(p).isDirectory()) walk(p); else if (p.endsWith(".md")) {
  const chapterDir = basename(dirname(p)); const t = readFileSync(p, "utf8");
  for (const m of t.matchAll(MARK)) { const id = m[1]; const key = `${chapterDir}/${id}`; expected.add(key);
    if (!existsSync(join(shotsDir, chapterDir, `${id}.png`))) { console.log(`missing png ${key}`); bad++; }
    if (!existsSync(join(recipesDir, chapterDir, `${id}.yaml`))) { console.log(`missing recipe ${key}`); bad++; } } } } })(chapters);
function orphans(dir, ext, label) { if (!existsSync(dir)) return; for (const c of readdirSync(dir)) { const cd = join(dir, c); if (!statSync(cd).isDirectory()) continue; for (const f of readdirSync(cd)) { if (f.endsWith(ext) && !expected.has(`${c}/${f.slice(0, -ext.length)}`)) console.log(`orphan ${label} ${c}/${f}`); } } }
orphans(shotsDir, ".png", "png"); orphans(recipesDir, ".yaml", "recipe");
console.log(bad ? `${bad} shot problem(s)` : "shots ok"); process.exit(bad ? 1 : 0);
