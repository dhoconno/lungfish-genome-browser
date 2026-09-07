import { test } from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
const here = dirname(fileURLToPath(import.meta.url));
const fx = join(here, "fixtures");
function run(script, arg) {
  const r = spawnSync("node", [join(here, script), arg], { encoding: "utf8" });
  return { code: r.status, out: r.stdout + r.stderr };
}
test("check-links reports the broken link and the bad glossary anchor only", () => {
  const { code, out } = run("check-links.mjs", join(fx, "manual-links"));
  assert.equal(code, 1);
  assert.match(out, /missing-chapter\.md/);
  assert.match(out, /GLOSSARY\.md#not-a-term/);
  assert.doesNotMatch(out, /GLOSSARY\.md#bam/);
});
test("check-shots reports the marker without a png and the orphan recipe", () => {
  const { code, out } = run("check-shots.mjs", join(fx, "manual-shots"));
  assert.equal(code, 1);
  assert.match(out, /missing png .*no-image/);
  assert.match(out, /orphan recipe .*stray/);
});
test("validate-parameters accepts the good file and rejects the bad one", () => {
  assert.equal(run("validate-parameters.mjs", join(fx, "params-good.yaml")).code, 0);
  const bad = run("validate-parameters.mjs", join(fx, "params-bad.yaml"));
  assert.equal(bad.code, 1);
  assert.match(bad.out, /control 'dial' not allowed/);
  assert.match(bad.out, /missing 'effect'/);
});
