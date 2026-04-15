import { test } from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import yaml from "yaml";
import AjvModule from "ajv";
import addFormatsModule from "ajv-formats";

const Ajv = AjvModule.default ?? AjvModule;
const addFormats = addFormatsModule.default ?? addFormatsModule;

const here = dirname(fileURLToPath(import.meta.url));
const schema = JSON.parse(await readFile(resolve(here, "..", "schema.json"), "utf8"));
const ajv = new Ajv({ allErrors: true, strict: false, validateSchema: false });
addFormats(ajv);
const validate = ajv.compile(schema);

async function load(name) {
  const raw = await readFile(resolve(here, "fixtures", name), "utf8");
  return yaml.parse(raw);
}

test("valid recipe passes schema", async () => {
  const ok = validate(await load("valid-recipe.yaml"));
  assert.equal(ok, true, JSON.stringify(validate.errors));
});

test("invalid recipe fails schema with specific errors", async () => {
  const ok = validate(await load("invalid-recipe.yaml"));
  assert.equal(ok, false);
  const paths = validate.errors.map((e) => e.instancePath + " " + e.message).join("\n");
  assert.match(paths, /'id'|required property/);
  assert.match(paths, /viewport_class|enum/);
});
