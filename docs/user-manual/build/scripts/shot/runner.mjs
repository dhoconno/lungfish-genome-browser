#!/usr/bin/env node
/**
 * shot/runner.mjs
 *
 * Usage: node runner.mjs <recipe.yaml>
 *
 * Reads a recipe, validates against schema.json, prints a structured plan
 * (sequence of Computer Use tool calls), and in actual execution mode drives
 * the app via the Computer Use MCP. In sub-project 1 we ship validation
 * plus plan mode; execution integration is finalised when capturing the
 * two pilot screenshots.
 */
import { readFile, writeFile } from "node:fs/promises";
import { resolve, dirname, basename } from "node:path";
import { fileURLToPath } from "node:url";
import yaml from "yaml";
import AjvModule from "ajv";
import addFormatsModule from "ajv-formats";

const Ajv = AjvModule.default ?? AjvModule;
const addFormats = addFormatsModule.default ?? addFormatsModule;

const here = dirname(fileURLToPath(import.meta.url));
const schema = JSON.parse(await readFile(resolve(here, "schema.json"), "utf8"));
const ajv = new Ajv({ allErrors: true, strict: false, validateSchema: false });
addFormats(ajv);
const validate = ajv.compile(schema);

const [, , cmd, recipePath, ...rest] = process.argv;
if (!cmd || !recipePath) {
  console.error("usage: runner.mjs <plan|execute> <recipe.yaml>");
  process.exit(2);
}

const raw = await readFile(resolve(recipePath), "utf8");
const recipe = yaml.parse(raw);
if (!validate(recipe)) {
  for (const err of validate.errors) console.error(`recipe error: ${err.instancePath} ${err.message}`);
  process.exit(1);
}

if (cmd === "plan") {
  console.log(JSON.stringify(buildPlan(recipe), null, 2));
  process.exit(0);
}
if (cmd === "execute") {
  console.error("execute mode stubbed: see Phase 9 pilot tasks");
  process.exit(2);
}
console.error(`unknown command: ${cmd}`);
process.exit(2);

function buildPlan(recipe) {
  return {
    id: recipe.id,
    chapter: recipe.chapter,
    access_request: ["Lungfish"],
    steps: recipe.steps.map((s) => ({
      tool: mapActionToTool(s.action),
      args: { ...s },
    })),
    capture: { retina: recipe.post?.retina ?? true },
    crop: recipe.crop,
    annotations: recipe.annotations ?? [],
  };
}

function mapActionToTool(action) {
  switch (action) {
    case "open_application": return "mcp__computer-use__open_application";
    case "wait_ready": return "internal:wait";
    case "open_file": return "bash:open -a";
    case "resize_window": return "mcp__computer-use__computer_batch";
    case "scroll_to": return "mcp__computer-use__scroll";
    default: throw new Error(`unknown action: ${action}`);
  }
}
