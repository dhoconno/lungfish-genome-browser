# User Manual Fidelity and Accessibility Campaign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite the whole Lungfish Genome Explorer user manual so every claim matches the installed Preview build 2026.9.13, every operation's settings are explained, the prose reads at undergraduate biology level in one consistent shape, and machine-writing tells are gone, with screenshots recaptured from the Preview app.

**Architecture:** Four stages run in order. Tooling first (lint rules, checkers, agent definitions), then ground truth (reality maps, a parameter registry, fixtures, a demo project), then a per-chapter rewrite pipeline (author, fidelity review, reader team, editor, lint, Fable gate), then screenshots and whole-manual verification. Every stage leaves the repository buildable and lint-green.

**Tech Stack:** Markdown chapters under `docs/user-manual/chapters/`, remark-based linter in `docs/user-manual/build/scripts/lint/` (Node 20, `node --test`), mkdocs-material for the site, Python 3 for fixture and demo-project scripts, `lungfish-cli` 2026.9.13 at `.build/debug/lungfish-cli` (built from the primary checkout; never rebuild from this worktree), computer use against `/Applications/Lungfish Preview.app` for screenshots.

**Spec:** `docs/superpowers/specs/2026-09-06-user-manual-fidelity-campaign-design.md`

## Global Constraints

- Arbiter of truth, in order: `/Applications/Lungfish Preview.app` (2026.9.13, bundle id `com.lungfish.browser.preview`), the Swift source, `lungfish-cli --help` from `.build/debug/lungfish-cli` (2026.9.13), `third-party-tools-lock.json`, then `features.yaml` as a partial index.
- App name in chapter prose: "Lungfish Genome Explorer" at first mention in a chapter body, "LGE" after. "Lungfish" alone means the research collaborative.
- Prose rules: no em dashes, no semicolons, no colons inside a sentence (a colon may end a short lead-in line immediately before a list, table, or fenced code block), no words or sentence patterns from the overused-list (Task 1.3 carries the list), at most five bullets per list and two lists per H2 section.
- Example data: human or macaque first. Viral only where the feature is viral by design (Viral Recon, Freyja, EsViritu, NVD, classification chapters).
- Genotyping chapters: genotyping only, worked on the Williams MiSeq project. Haplotype analysis gets one short section per affected chapter, headed `## Haplotype analysis (placeholder)`, saying the feature exists and that a worked example with an MCM dataset will follow. No procedure, no settings, no screenshots for haplotyping.
- Fixture caps: 10 MB per file, 50 MB per set, `fetch.sh` for anything larger, README with accession, license, citation, sizes, consistency notes.
- Models: Fable 5.1 gates, reviews every diff, and does fidelity review. Opus authors and edits (Opus 4.8 preferred where a picker offers it). Sonnet or Haiku only for mechanical passes.
- Agents run one chapter per role at a time. No two agents edit the same file at once.
- Never run `swift build` or `swift test` from this worktree. Never `cd` out of the worktree. Never bare `git stash`.
- Every commit ends with `Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>`.
- Screenshots: light appearance, window 1600 by 1000 for full-app shots, never the menu bar or Dock, never user-specific state, one recipe per PNG.

---

## Phase 0: Campaign scaffolding

### Task 0.1: Review folder and results skeleton

**Files:**
- Create: `docs/user-manual/reviews/fidelity-2026-09/README.md`
- Create: `docs/user-manual/reviews/fidelity-2026-09/RESULTS.md`
- Create: `docs/user-manual/reviews/fidelity-2026-09/ground-truth/.gitkeep`
- Create: `docs/user-manual/reviews/fidelity-2026-09/chapters/.gitkeep`
- Create: `docs/user-manual/reviews/fidelity-2026-09/cli-help/.gitkeep`

**Interfaces:**
- Produces: the folder layout every later task writes into. Per-chapter review records go to `reviews/fidelity-2026-09/chapters/<chapter_id with slashes replaced by __>/<role>.md`.

- [ ] **Step 1: Write the README**

```markdown
# Fidelity and accessibility campaign, 2026-09

Spec: `docs/superpowers/specs/2026-09-06-user-manual-fidelity-campaign-design.md`
Plan: `docs/superpowers/plans/2026-09-06-user-manual-fidelity-campaign.md`

Layout:

- `cli-help/` one file per `lungfish-cli` command, the `--help` text of the
  2026.9.13 binary, recursed one level. Written once by Task 2.1.
- `ground-truth/<part>.md` reality maps, one per manual part (Task 2.2).
- `DRIFT.md` the consolidated per-chapter correction list and the chapter
  roster (Task 2.5).
- `chapters/<chapter>/` per-chapter pipeline records: `fidelity.md`,
  `readers.md` (the synthesized reader-team report), `editor.md`,
  `fable-gate.md`.
- `RESULTS.md` the closing report.
```

- [ ] **Step 2: Write the RESULTS.md skeleton**

```markdown
# Results, fidelity and accessibility campaign 2026-09

Status: in progress.

## Summary

(written at Task 6.5)

## Factual corrections

One row per correction. Columns: chapter, old claim, corrected claim, evidence.

| Chapter | Old claim | Corrected claim | Evidence |
|---|---|---|---|

## Features the old manual described that do not exist

| Chapter | Claim | Evidence |
|---|---|---|

## Features the old manual omitted

| Feature | Chapter that now covers it | Evidence |
|---|---|---|

## Claims that could not be verified

| Chapter | Claim | Why unverifiable |
|---|---|---|

## App defects found during the audit

| Area | Observation | Evidence | Issue |
|---|---|---|---|

## Screenshots

| Chapter | Shot id | Status (new, recaptured, unchanged) |
|---|---|---|
```

- [ ] **Step 3: Commit**

```bash
git add docs/user-manual/reviews/fidelity-2026-09
git commit -m "Scaffold the 2026-09 manual fidelity campaign review folder

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

## Phase 1: Rules, linter, checkers, and agent definitions

All lint work happens in `docs/user-manual/build/scripts/lint/`. Run tests with `node --test test-rules.mjs` from that directory. Run the linter on a chapter with `bash docs/user-manual/build/scripts/lint-chapter.sh <file>` from the worktree root.

### Task 1.1: Shared severity helper and the semicolon rule

**Files:**
- Create: `docs/user-manual/build/scripts/lint/rules/severity.js`
- Create: `docs/user-manual/build/scripts/lint/rules/semicolon.js`
- Create: `docs/user-manual/build/scripts/lint/fixtures/bad-semicolon.md`
- Modify: `docs/user-manual/build/scripts/lint/.remarkrc.mjs`
- Modify: `docs/user-manual/build/scripts/lint/test-rules.mjs`

**Interfaces:**
- Produces: `report(file, message, node)` in `severity.js`. It calls `file.message(...)` and, unless `process.env.LUNGFISH_MANUAL_STRICT === "1"`, sets `msg.fatal = false` so the runner (which fails on `fatal !== false`) treats the message as informational. Every campaign prose rule (Tasks 1.1 to 1.5) reports through it. The per-chapter pipeline runs lint with `LUNGFISH_MANUAL_STRICT=1`. Task 6.1 flips the default to strict.
- Produces: `proseText(node)` in `severity.js`, which concatenates the text of a paragraph, heading, list item, or table cell while skipping `inlineCode`, `code`, `html`, and link URLs. Rules 1.1 to 1.4 use it.

- [ ] **Step 1: Write the failing test**

Append to `test-rules.mjs`:

```js
test("semicolon flags semicolons in prose but not in code", async () => {
  const messages = await lint("bad-semicolon.md");
  const reasons = messages.map((m) => m.reason).join("\n");
  assert.match(reasons, /semicolon in prose/);
  assert.equal((reasons.match(/semicolon in prose/g) || []).length, 2);
});
```

Write `fixtures/bad-semicolon.md`:

```markdown
---
title: Semicolon fixture
chapter_id: 99-test/bad-semicolon
audience: bench-scientist
prereqs: []
estimated_reading_min: 3
shots: []
glossary_refs: []
features_refs: []
fixtures_refs: []
brand_reviewed: false
lead_approved: false
---

## What it is

Reads are short; they need mapping.

Here is code that is fine: `a; b` and a block:

```bash
samtools sort in.bam; samtools index out.bam
```

## Procedure

1. Open the file; then wait.
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: the new test fails with `AssertionError` (no message matches `semicolon in prose`).

- [ ] **Step 3: Write `severity.js`**

```js
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
```

- [ ] **Step 4: Write `semicolon.js`**

```js
import { visit } from "unist-util-visit";
import { report, proseText } from "./severity.js";

// No semicolons in prose. Paragraphs, headings, list items, and table cells
// are prose. Code, HTML, and frontmatter are not.
const PROSE_BLOCKS = new Set(["paragraph", "heading", "tableCell"]);

export default function semicolon() {
  return (tree, file) => {
    visit(tree, (node) => {
      if (!PROSE_BLOCKS.has(node.type)) return;
      const text = proseText(node);
      let idx = text.indexOf(";");
      while (idx !== -1) {
        report(file, "semicolon in prose. Split the sentence.", node);
        idx = text.indexOf(";", idx + 1);
      }
    });
  };
}
```

- [ ] **Step 5: Register the rule**

In `.remarkrc.mjs` add `import semicolon from "./rules/semicolon.js";` and append `semicolon,` to the `plugins` array after `bulletCap`.

- [ ] **Step 6: Run the tests to verify they pass**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: all tests pass, including `semicolon flags semicolons in prose but not in code` (exactly two hits: the paragraph and the list item).

- [ ] **Step 7: Confirm the existing manual still exits 0 in non-strict mode**

Run: `bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/*/*.md > /dev/null; echo exit=$?`
Expected: `exit=0` (semicolon messages are informational, and the two pre-existing warnings are the baseline).

- [ ] **Step 8: Commit**

```bash
git add docs/user-manual/build/scripts/lint
git commit -m "Add the semicolon lint rule with a shared strict-mode helper

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.2: In-sentence colon rule

**Files:**
- Create: `docs/user-manual/build/scripts/lint/rules/sentence-colon.js`
- Create: `docs/user-manual/build/scripts/lint/fixtures/bad-sentence-colon.md`
- Modify: `docs/user-manual/build/scripts/lint/.remarkrc.mjs`
- Modify: `docs/user-manual/build/scripts/lint/test-rules.mjs`

**Interfaces:**
- Consumes: `report`, `proseText` from `severity.js`.
- Rule: a colon in a paragraph is allowed only when it is the last non-space character of the paragraph's prose AND the next sibling block is a `list`, `table`, or `code` node. Colons inside `inlineCode`, URLs, and times (`12:30`) are ignored. Headings and table cells never allow colons.

- [ ] **Step 1: Write the failing test**

Append to `test-rules.mjs`:

```js
test("sentence-colon flags joiner colons and allows lead-in colons", async () => {
  const messages = await lint("bad-sentence-colon.md");
  const reasons = messages.map((m) => m.reason).join("\n");
  assert.equal((reasons.match(/colon inside a sentence/g) || []).length, 2);
});
```

Write `fixtures/bad-sentence-colon.md` with the same frontmatter block as `bad-semicolon.md` (change `title` and `chapter_id`), then this body:

```markdown
## What it is

There is one rule: keep it simple.

The steps are:

1. Open the project.
2. Choose the file.

Run this:

```bash
lungfish-cli version
```

The clock read 12:30 when it finished, and `a:b` is a path.

## Procedure

Choose a mapper: minimap2 is the default.
```

Expected hits: "There is one rule: keep it simple." and "Choose a mapper: minimap2 is the default." The two lead-ins and the time and code span must not fire.

- [ ] **Step 2: Run the test to verify it fails**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: the new test fails.

- [ ] **Step 3: Write `sentence-colon.js`**

```js
import { report, proseText } from "./severity.js";

// A colon may end a short lead-in immediately before a list, table, or code
// block. Anywhere else in prose it is a joiner and is banned.
const LEAD_IN_FOLLOWERS = new Set(["list", "table", "code"]);
const TIME_OR_RATIO = /\d:\d/g;

export default function sentenceColon() {
  return (tree, file) => {
    walk(tree);

    function walk(parent) {
      if (!parent.children) return;
      parent.children.forEach((node, i) => {
        if (node.type === "paragraph" || node.type === "heading" || node.type === "tableCell") {
          check(node, parent.children[i + 1]);
        }
        if (node.type !== "code" && node.type !== "html") walk(node);
      });
    }

    function check(node, next) {
      const text = proseText(node).replace(TIME_OR_RATIO, "  ");
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
```

- [ ] **Step 4: Register the rule**

In `.remarkrc.mjs` add `import sentenceColon from "./rules/sentence-colon.js";` and append `sentenceColon,` to `plugins`.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: all pass; the colon test reports exactly two hits.

- [ ] **Step 6: Commit**

```bash
git add docs/user-manual/build/scripts/lint
git commit -m "Add the in-sentence colon lint rule

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.3: Overused-word and sentence-pattern rule

**Files:**
- Create: `docs/user-manual/build/scripts/lint/rules/ai-tells-words.txt`
- Create: `docs/user-manual/build/scripts/lint/rules/ai-tells.js`
- Create: `docs/user-manual/build/scripts/lint/fixtures/bad-ai-tells.md`
- Modify: `docs/user-manual/build/scripts/lint/.remarkrc.mjs`
- Modify: `docs/user-manual/build/scripts/lint/test-rules.mjs`

**Interfaces:**
- Consumes: `report`, `proseText`.
- Produces: `ai-tells-words.txt`, one entry per line, `#` comments allowed. Entries are matched as whole words or phrases, case-insensitive, with these suffixes tolerated: `s`, `es`, `ed`, `ing`, `er`, `ers`, `ity`, `ful`, `ly`. Quoted app labels (text inside straight double quotes) and inline code are exempt. `voice.js` stays as is.

- [ ] **Step 1: Write the word list**

Write `rules/ai-tells-words.txt`. The source is https://www.contentbeta.com/blog/list-of-words-overused-by-ai/ (retrieved 2026-09-06). Entries retrieved from the page, one per line, lowercase:

```
# Source: contentbeta.com list of words overused by AI, retrieved 2026-09-06.
# One entry per line. Matched whole-word, case-insensitive, common suffixes tolerated.
# Lines starting with # are comments.
arena
arsenal
bombard
bloated
boosts
brain dump
break the bank
breeze
buzz
cadence
captivate
catapult
chaos into clarity
comes to the rescue
compelling
cornerstone
convey
craft
crafting
critical
crucial
cutting edge
deep dive
delve
despair
digital age
digital world
dive
diverge
diving
drowning
elephant in the room
elevate
embark
employ
engage
engaging
enhance
entrusting
ever wondered
eye roll
fast-paced
fast paced world
fantastic
falls flat
fluff
formidable
foster
game changer
gaslights
grabs people's attention
hard truth
harness
here's the deal
here's the truth
hiccups
hits different
hits home
hits a wall
honest text
hone
imaginative
in a world
in conclusion
in the era of
in today's era
in today's modern age
in today's world
in the world of
incorporating
is all about
it is like
juggling
kicker
lands well
let's dive in
magic
marvelous
messaging is landing
mind blowing
miss the mark
moves the needle
navigate
nail
nailing down
necessitating
nimble
nugget
nutshell
paramount
perfect storm
picture this
powerful tool
punchline
quiet acceptance
raves
real deal
realm
resonate
resonates
revolutionize
roll your eyes
scrappy
scroll stopper
sea of
secret sauce
secret weapon
saves the day
sifting
skyrocket
sneak peek
stall
stay tuned
stellar
supercharge
surge
scream into the void
tailor
tailored
tackle
tap
tightrope
trailblazer
turbocharge
uncover
unleash
unlock
unlocking
unveil
wedge
welcome to the world
whip
# Widely cited additions the page lists under other headings or that the
# user named directly (README review, 2026-09-06).
seamless
seamlessly
robust
leverage
streamline
comprehensive
delve into
tapestry
testament
landscape
journey
game-changing
groundbreaking
ever-evolving
```

- [ ] **Step 2: Reconcile the list with the live page**

Run:

```bash
curl -sL "https://www.contentbeta.com/blog/list-of-words-overused-by-ai/" \
 | python3 -c "
import sys,re,html
s=sys.stdin.read(); s=re.sub(r'<script.*?</script>|<style.*?</style>','',s,flags=re.S)
t=html.unescape(re.sub(r'<[^>]+>','\n',s)); lines=[l.strip().lower() for l in t.splitlines() if l.strip()]
a=lines.index('arena'); b=lines.index('whip')
print('\n'.join(lines[a:b+1]))" > /tmp/live-words.txt
grep -v '^#' docs/user-manual/build/scripts/lint/rules/ai-tells-words.txt | sort > /tmp/ours.txt
sort /tmp/live-words.txt | comm -23 - /tmp/ours.txt
```

Expected: the `comm` output lists words on the live page missing from ours (the page's B-section entries between "boosts" and "brain dump" were not captured on 2026-09-06). Append every printed word to `ai-tells-words.txt`, except `void` (legal usage) and `capture` (the manual's screenshot vocabulary), and record both exclusions as `#` comments.

- [ ] **Step 3: Write the failing test**

Append to `test-rules.mjs`:

```js
test("ai-tells flags listed words, inflections, and sentence patterns, but not quoted labels or code", async () => {
  const messages = await lint("bad-ai-tells.md");
  const reasons = messages.map((m) => m.reason).join("\n");
  assert.match(reasons, /overused word 'delve'/i);
  assert.match(reasons, /overused word 'seamlessly'/i);
  assert.match(reasons, /overused word 'navigating'/i);
  assert.match(reasons, /pattern "It's not X, it's Y"/);
  assert.match(reasons, /pattern "No X\. No Y\. Just Z"/);
  assert.doesNotMatch(reasons, /overused word 'Navigate'/);
  assert.doesNotMatch(reasons, /overused word 'tap'/);
});
```

Write `fixtures/bad-ai-tells.md` (frontmatter as in Task 1.1 with its own title and id), body:

```markdown
## What it is

Let us delve into reads. The app works seamlessly. You start by navigating to the folder.

It's not about speed, it's about accuracy. No theory. No fluff. Just execution.

Click "Navigate" in the toolbar. Run `tap` to test.
```

- [ ] **Step 4: Run the test to verify it fails**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: the new test fails.

- [ ] **Step 5: Write `ai-tells.js`**

```js
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { visit } from "unist-util-visit";
import { report, proseText } from "./severity.js";

const here = dirname(fileURLToPath(import.meta.url));
const WORDS = readFileSync(join(here, "ai-tells-words.txt"), "utf8")
  .split("\n")
  .map((l) => l.trim().toLowerCase())
  .filter((l) => l && !l.startsWith("#"));

const SUFFIX = "(?:s|es|ed|ing|er|ers|ity|ful|ly)?";
function escapeRe(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); }
const WORD_RES = WORDS.map((w) => ({
  word: w,
  re: new RegExp(`\\b${escapeRe(w).replace(/ /g, "[\\s-]+")}${SUFFIX}\\b`, "i"),
}));

// Sentence patterns from the same source.
const PATTERNS = [
  { name: `"It's not X, it's Y"`, re: /\bit['’]s not (about |just )?[^.,;]{1,60},? (it['’]s|but) (about |it['’]s )?/i },
  { name: `"That's not X, that's Y"`, re: /\bthat['’]s not [^.,;]{1,60}, that['’]s /i },
  { name: `"Not because X. But because Y"`, re: /\bnot because [^.]{1,60}\. but because /i },
  { name: `"Not by X, but by Y"`, re: /\bnot by [^.,;]{1,60}, but by /i },
  { name: `"No X. No Y. Just Z"`, re: /\bno [^.]{1,30}\. no [^.]{1,30}\. just /i },
  { name: `"And the X? Y."`, re: /\band the [^?]{1,30}\? [A-Z]/ },
  { name: `"The result? Y."`, re: /\bthe (result|outcome|fix|answer)\? /i },
];

const QUOTED = /"[^"\n]{1,80}"/g;

export default function aiTells() {
  return (tree, file) => {
    visit(tree, (node) => {
      if (node.type !== "paragraph" && node.type !== "heading" && node.type !== "tableCell" && node.type !== "listItem") return;
      if (node.type === "listItem") return; // its paragraph child is visited on its own
      const text = proseText(node).replace(QUOTED, " ");
      for (const { word, re } of WORD_RES) {
        const m = text.match(re);
        if (m) report(file, `overused word '${m[0]}' (list entry '${word}'). Say it plainly.`, node);
      }
      for (const { name, re } of PATTERNS) {
        if (re.test(text)) report(file, `sentence pattern ${name}. Rewrite as a plain statement.`, node);
      }
    });
  };
}
```

- [ ] **Step 6: Register the rule**

In `.remarkrc.mjs` add `import aiTells from "./rules/ai-tells.js";` and append `aiTells,` to `plugins`.

- [ ] **Step 7: Run the tests to verify they pass**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: all pass.

- [ ] **Step 8: Measure the current manual and record the baseline**

Run:

```bash
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/*/*.md 2>&1 \
 | grep -oE "overused word '[^']+'" | sort | uniq -c | sort -rn | head -40
```

Append the output to `docs/user-manual/reviews/fidelity-2026-09/README.md` under a heading `## Overused-word baseline (before rewrite)`. If any listed word is an unavoidable term of art in this manual (for example "tap" if a control is named Tap), add it to the `# exclusions` block in `ai-tells-words.txt` with a reason, and re-run.

- [ ] **Step 9: Commit**

```bash
git add docs/user-manual/build/scripts/lint docs/user-manual/reviews/fidelity-2026-09/README.md
git commit -m "Add the overused-word and sentence-pattern lint rule

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.4: App-name rule replacing written-identity

**Files:**
- Create: `docs/user-manual/build/scripts/lint/rules/app-name.js`
- Create: `docs/user-manual/build/scripts/lint/fixtures/bad-app-name.md`
- Delete: `docs/user-manual/build/scripts/lint/rules/written-identity.js`
- Delete: `docs/user-manual/build/scripts/lint/fixtures/bad-written-identity.md`
- Modify: `docs/user-manual/build/scripts/lint/.remarkrc.mjs`
- Modify: `docs/user-manual/build/scripts/lint/test-rules.mjs`
- Modify: `docs/user-manual/build/scripts/lint/fixtures/passing.md` (its body says "Lungfish reads VCF files." which the new rule flags; change to "Lungfish Genome Explorer reads VCF files.")

**Interfaces:**
- Rule, applied to chapter files only (path contains `/chapters/` or `/lint/fixtures/`): (a) the first occurrence in body prose of either "Lungfish Genome Explorer" or "LGE" must be "Lungfish Genome Explorer"; (b) "LGE" before that first full mention is flagged; (c) a bare "Lungfish" in prose is flagged unless followed by " Genome Explorer", " Research Collaboratory", " Air Kit", " Wastewater Kit", or " Preview" (the installed app's name), or preceded by "the " and followed by " project" is NOT exempt (that is the app); (d) the old misspellings LUNGFISH, LungFish, Lung Fish remain flagged. Code, paths, and quoted labels are exempt. Frontmatter is exempt. `GLOSSARY.md` and non-chapter files are exempt from (a) and (b) but not (d).

- [ ] **Step 1: Write the failing test**

Replace the `written-identity` test in `test-rules.mjs` with:

```js
test("app-name enforces first full mention, LGE after, and no bare Lungfish", async () => {
  const messages = await lint("bad-app-name.md");
  const reasons = messages.map((m) => m.reason).join("\n");
  assert.match(reasons, /'LGE' before the first 'Lungfish Genome Explorer'/);
  assert.match(reasons, /bare 'Lungfish'/);
  assert.match(reasons, /LUNGFISH/);
  assert.equal((reasons.match(/bare 'Lungfish'/g) || []).length, 1);
});
```

Write `fixtures/bad-app-name.md` (frontmatter as in Task 1.1, own title and id), body:

```markdown
## What it is

LGE opens the file. Lungfish Genome Explorer is the app. After that, LGE is fine.

Lungfish writes the bundle. The Lungfish Research Collaboratory funds the work. Open "Lungfish Preview.app" from `/Applications/Lungfish Preview.app`.

LUNGFISH is wrong.
```

Expected: one "LGE before first full mention" hit (first sentence), one bare-Lungfish hit ("Lungfish writes the bundle."), one LUNGFISH hit. "Lungfish Research Collaboratory", the quoted label, and the code path do not fire.

- [ ] **Step 2: Run the test to verify it fails**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: the new test fails (and the old written-identity test is gone).

- [ ] **Step 3: Write `app-name.js`**

```js
import { visitParents } from "unist-util-visit-parents";
import { report } from "./severity.js";

const FULL = /\bLungfish Genome Explorer\b/;
const ABBREV = /\bLGE\b/;
const EXEMPT_AFTER = /\bLungfish(?= (Genome Explorer|Research Collaboratory|Air Kit|Wastewater Kit|Preview))/g;
const BARE = /\bLungfish\b(?! (Genome Explorer|Research Collaboratory|Air Kit|Wastewater Kit|Preview))/;
const BAD_CAPS = /\bLUNGFISH\b/;
const BAD_MIXED = /\bLungFish\b/;
const BAD_SPACED = /\bLung Fish\b/;
const BAD_LOWER = /(?<![`./\-_])\blungfish\b(?![-.])/;
const QUOTED = /"[^"\n]{1,80}"/g;

function inCode(ancestors) {
  return ancestors.some((a) => a.type === "inlineCode" || a.type === "code" || a.type === "html" || a.type === "yaml");
}

export default function appName() {
  return (tree, file) => {
    const path = file.path ?? "";
    const isChapter = path.includes("/chapters/") || path.includes("/lint/fixtures/");
    let seenFull = false;
    visitParents(tree, "text", (node, ancestors) => {
      if (inCode(ancestors)) return;
      const v = node.value.replace(QUOTED, " ");
      if (BAD_CAPS.test(v)) report(file, "LUNGFISH. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (BAD_MIXED.test(v)) report(file, "LungFish. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (BAD_SPACED.test(v)) report(file, "Lung Fish. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (BAD_LOWER.test(v)) report(file, "lowercase 'lungfish'. Use 'Lungfish Genome Explorer' or 'LGE'.", node);
      if (!isChapter) return;
      // Order matters within a text node: find the earliest of FULL and ABBREV.
      const fullIdx = v.search(FULL);
      const abbrIdx = v.search(ABBREV);
      if (!seenFull && abbrIdx !== -1 && (fullIdx === -1 || abbrIdx < fullIdx)) {
        report(file, "'LGE' before the first 'Lungfish Genome Explorer' in this chapter. Spell it out at first mention.", node);
      }
      if (fullIdx !== -1) seenFull = true;
      if (BARE.test(v)) report(file, "bare 'Lungfish' used for the app. Use 'Lungfish Genome Explorer' (first mention) or 'LGE'. 'Lungfish' alone is the collaborative.", node);
    });
  };
}
```

- [ ] **Step 4: Swap the registration**

In `.remarkrc.mjs` replace the `writtenIdentity` import and entry with `import appName from "./rules/app-name.js";` and `appName,`. Delete `rules/written-identity.js` and `fixtures/bad-written-identity.md`. Edit `fixtures/passing.md` body to "Lungfish Genome Explorer reads VCF files."

- [ ] **Step 5: Run the tests to verify they pass**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: all pass.

- [ ] **Step 6: Commit**

```bash
git add -A docs/user-manual/build/scripts/lint
git commit -m "Replace the written-identity lint rule with the LGE app-name rule

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.5: Settings-coverage rule and the `parameters_refs` frontmatter key

**Files:**
- Create: `docs/user-manual/parameters.yaml` (schema header and an empty `operations:` map; Phase 2 fills it)
- Create: `docs/user-manual/build/scripts/lint/rules/settings-coverage.js`
- Create: `docs/user-manual/build/scripts/lint/fixtures/parameters-test.yaml`
- Create: `docs/user-manual/build/scripts/lint/fixtures/bad-settings-coverage.md`
- Modify: `docs/user-manual/build/scripts/lint/rules/frontmatter.js` (accept optional `parameters_refs: [ids]`)
- Modify: `docs/user-manual/build/scripts/lint/.remarkrc.mjs`
- Modify: `docs/user-manual/build/scripts/lint/test-rules.mjs`

**Interfaces:**
- Registry location: the rule walks up from the linted file to the nearest directory containing `parameters.yaml`, unless the file is under `/lint/fixtures/`, in which case it reads `fixtures/parameters-test.yaml`.
- Rule: for a chapter whose frontmatter has a non-empty `parameters_refs`, (a) every id must exist in the registry, (b) a `## Settings` H2 must exist, (c) for every setting `label` of every referenced operation, the Settings section must contain a paragraph starting with `**<label>.**` (bold run-in, exact label text, trailing period inside the bold). Missing labels are reported one per label.

- [ ] **Step 1: Write the registry skeleton**

Write `docs/user-manual/parameters.yaml`:

```yaml
# parameters.yaml, the operation settings registry for the Lungfish Genome
# Explorer user manual. Owner: Code Cartographer. Filled by Phase 2 of the
# 2026-09 fidelity campaign. Chapters cite operation ids in frontmatter
# parameters_refs; the settings-coverage lint rule checks that a chapter's
# "## Settings" section documents every setting listed here.
#
# Schema:
#   operations:
#     <operation_id>:
#       title: <human name as shown in the app>
#       entry_points: [<menu path>, "CLI: lungfish-cli ..."]
#       gating: [<pack id>, docker, experimental]   # [] when none
#       sources: [<Sources/ path>, ...]
#       settings:
#         - label: <control label exactly as the app shows it>
#           control: checkbox | number | slider | popup | text | file | radio
#           default: <value>
#           allowed: <range, list, or "any">
#           effect: <one or two plain sentences>
#           when_to_change: <one sentence, or "rarely">
#           cli_flag: <flag or null>
#       cli_only:
#         - flag: <flag>
#           default: <value>
#           effect: <one sentence>
#       notes: <free text>
version: 0
operations: {}
```

- [ ] **Step 2: Write the test registry and failing test**

Write `fixtures/parameters-test.yaml`:

```yaml
version: 0
operations:
  test.trim:
    title: Trim reads
    entry_points: ["Tools > Trimming > Trim"]
    gating: []
    sources: []
    settings:
      - label: Minimum length
        control: number
        default: 50
        allowed: "1 to 10000"
        effect: Drops reads shorter than this after trimming.
        when_to_change: rarely
        cli_flag: --min-length
      - label: Quality cutoff
        control: number
        default: 20
        allowed: "0 to 60"
        effect: Trims bases below this Phred score from read ends.
        when_to_change: rarely
        cli_flag: --quality
    cli_only: []
    notes: test only
```

Write `fixtures/bad-settings-coverage.md` with the Task 1.1 frontmatter plus `parameters_refs: [test.trim, test.missing]`, body:

```markdown
## What it is

Lungfish Genome Explorer trims reads.

## Settings

**Minimum length.** Drops reads shorter than this. Default 50. Change it for very short amplicons.
```

Append to `test-rules.mjs`:

```js
test("settings-coverage flags unknown ids and undocumented settings", async () => {
  const messages = await lint("bad-settings-coverage.md");
  const reasons = messages.map((m) => m.reason).join("\n");
  assert.match(reasons, /unknown parameters_refs id 'test.missing'/);
  assert.match(reasons, /setting 'Quality cutoff' of 'test.trim' is not documented/);
  assert.doesNotMatch(reasons, /setting 'Minimum length'/);
});
```

- [ ] **Step 3: Run the test to verify it fails**

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: the new test fails.

- [ ] **Step 4: Write `settings-coverage.js`**

```js
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
    let inSettings = false; let sawSettings = false; const runIns = new Set();
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
          const label = proseText(first).replace(/\.$/, "").trim();
          runIns.add(label);
        }
      }
    });

    for (const id of refs) {
      const op = ops[id];
      if (!op) { report(file, `unknown parameters_refs id '${id}'`, fm); continue; }
      if (!sawSettings) { report(file, `parameters_refs names '${id}' but the chapter has no '## Settings' section`, fm); continue; }
      for (const s of op.settings ?? []) {
        if (!runIns.has(s.label)) {
          report(file, `setting '${s.label}' of '${id}' is not documented in '## Settings' (expected a paragraph starting with **${s.label}.**)`, fm);
        }
      }
    }
  };
}
```

- [ ] **Step 5: Accept `parameters_refs` in `frontmatter.js`**

In `frontmatter.js`, after the `AUDIENCES` check, add:

```js
    if ("parameters_refs" in data && !Array.isArray(data.parameters_refs)) {
      file.message("parameters_refs must be a list of operation ids", fm);
    }
```

- [ ] **Step 6: Register and test**

In `.remarkrc.mjs` add `import settingsCoverage from "./rules/settings-coverage.js";` and append `settingsCoverage,`.

Run: `cd docs/user-manual/build/scripts/lint && node --test test-rules.mjs`
Expected: all pass.

- [ ] **Step 7: Commit**

```bash
git add docs/user-manual/parameters.yaml docs/user-manual/build/scripts/lint
git commit -m "Add the parameter registry skeleton and the settings-coverage lint rule

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.6: Link, shot, and registry checkers

**Files:**
- Create: `docs/user-manual/build/scripts/campaign/check-links.mjs`
- Create: `docs/user-manual/build/scripts/campaign/check-shots.mjs`
- Create: `docs/user-manual/build/scripts/campaign/validate-parameters.mjs`
- Create: `docs/user-manual/build/scripts/campaign/package.json`
- Create: `docs/user-manual/build/scripts/campaign/test-campaign.mjs`
- Create: `docs/user-manual/build/scripts/campaign/fixtures/` (small inputs for the tests)

**Interfaces:**
- `check-links.mjs <manual-root>`: exits 1 and prints one line per broken relative link (`file:line target`) across `chapters/**/*.md`, `index.md`, and `GLOSSARY.md`. Anchors of the form `GLOSSARY.md#slug` must match a `{#slug}` in the glossary. Anchors within chapters must match an H2 or H3 slug (lowercase, spaces to hyphens, punctuation removed).
- `check-shots.mjs <manual-root>`: for every `<!-- SHOT: id -->` in a chapter, requires `assets/screenshots/<chapter-dir>/<id>.png` and `assets/recipes/<chapter-dir>/<id>.yaml` where `<chapter-dir>` is the chapter's directory name (for example `03-reads`). Exits 1 listing what is missing. Also lists PNGs and recipes with no marker (orphans) as warnings.
- `validate-parameters.mjs <parameters.yaml>`: validates the schema from Task 1.5 (required keys per operation and per setting, `control` in the allowed set, `gating` values in `{docker, experimental}` or a pack id from `third-party-tools-lock.json`'s `packTools[].packID`). Exits 1 with one line per problem.

- [ ] **Step 1: Write the tests**

`package.json`:

```json
{ "name": "lungfish-manual-campaign", "private": true, "type": "module",
  "scripts": { "test": "node --test test-campaign.mjs" },
  "dependencies": { "yaml": "2.5.0" } }
```

`test-campaign.mjs`:

```js
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
```

Create the fixtures. `fixtures/manual-links/chapters/01-x/a.md` contains a link to `missing-chapter.md`, a link to `../../GLOSSARY.md#bam`, and a link to `../../GLOSSARY.md#not-a-term`. `fixtures/manual-links/GLOSSARY.md` contains `**BAM**{#bam}.`. `fixtures/manual-links/index.md` contains a valid link to `chapters/01-x/a.md`. `fixtures/manual-shots/chapters/01-x/a.md` contains `<!-- SHOT: has-image -->` and `<!-- SHOT: no-image -->`; `fixtures/manual-shots/assets/screenshots/01-x/has-image.png` is any 1-pixel PNG; `fixtures/manual-shots/assets/recipes/01-x/has-image.yaml` and `.../stray.yaml` are one-line YAML files. `fixtures/params-good.yaml` is the Task 1.5 test registry. `fixtures/params-bad.yaml` is the same with one setting's `control: dial` and another setting missing `effect`.

- [ ] **Step 2: Run the tests to verify they fail**

Run: `cd docs/user-manual/build/scripts/campaign && npm install --silent && node --test test-campaign.mjs`
Expected: three failures (scripts missing).

- [ ] **Step 3: Write `check-links.mjs`**

```js
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
```

- [ ] **Step 4: Write `check-shots.mjs`**

```js
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
```

- [ ] **Step 5: Write `validate-parameters.mjs`**

```js
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
```

- [ ] **Step 6: Run the tests to verify they pass**

Run: `cd docs/user-manual/build/scripts/campaign && node --test test-campaign.mjs`
Expected: all three pass. Then run the checkers on the real manual and record the counts in `reviews/fidelity-2026-09/README.md` under `## Checker baseline (before rewrite)`:

```bash
node docs/user-manual/build/scripts/campaign/check-links.mjs docs/user-manual | tail -1
node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual | tail -1
node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml
```

- [ ] **Step 7: Commit**

```bash
git add docs/user-manual/build/scripts/campaign docs/user-manual/reviews/fidelity-2026-09/README.md
git commit -m "Add campaign checkers for links, shots, and the parameter registry

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.7: STYLE.md, chapter README, and ARCHITECTURE.md rules

**Files:**
- Modify: `docs/user-manual/STYLE.md`
- Modify: `docs/user-manual/chapters/README.md`
- Modify: `docs/user-manual/ARCHITECTURE.md` (a new dated status block and the chapter template)

- [ ] **Step 1: Rewrite the "Prose rules" and "Written identity" sections of STYLE.md**

Replace the "Prose rules" section with:

```markdown
## Prose rules

Five hard rules apply to every chapter and every agent-facing doc under
`docs/user-manual/` and `.claude/agents/`.

First, **no em dashes.** Use a period and start a new sentence.

Second, **no semicolons.** Split the sentence.

Third, **no colons inside a sentence.** A colon may end a short lead-in line
that is immediately followed by a list, a table, or a fenced code block, and
nowhere else. Do not use a colon where an em dash used to be.

Fourth, **no overused words or patterns.** The banned list lives in
`build/scripts/lint/rules/ai-tells-words.txt`, every inflection included.
Sentence shapes such as "It's not X, it's Y" and "No X. No Y. Just Z" are
banned too. A control whose label happens to be on the list is written in
straight double quotes, which the linter exempts.

Fifth, **bullet lists are capped.** At most five items per list, at most
two lists per H2 section. Longer enumerations become prose or a table.

Lint: `em-dash.js` (error), `semicolon.js`, `sentence-colon.js`,
`ai-tells.js`, `bullet-cap.js`.
```

Replace the "Written identity" section with:

```markdown
## Written identity

The app is **Lungfish Genome Explorer**. Spell it out at first mention in
every chapter body, then write **LGE**. **Lungfish** alone names the research
collaborative (the **Lungfish Research Collaboratory**), never the app. The
installed preview build is "Lungfish Preview.app" and may be named that way
inside quotes or code. Never `LUNGFISH`, `LungFish`, `Lung Fish`, or lowercase
`lungfish` in prose. Lint: `app-name.js`.
```

- [ ] **Step 2: Add the chapter template to STYLE.md**

Append after "Chapter structure":

```markdown
## Chapter template (2026-09 campaign)

Chapters follow this order. Concept-only chapters use the first two sections
and whatever else applies.

1. `## What it is`. The concept in two to four short paragraphs. Every
   term is glossed the first time it appears in the chapter. The reader is
   an undergraduate who has taken genetics and never opened a terminal.
2. `## Why you would do this`. The biological motivation, tied to the
   chapter's fixture.
3. `## Before you start`. What must already be in the project, which tool
   pack, whether Docker Desktop is needed, how long the example takes.
4. `## Procedure`. Numbered steps, exact menu path, one action per step,
   a `<!-- SHOT: id -->` marker wherever the reader needs to see the screen.
5. `## Settings`. One paragraph per setting, in the fixed shape below,
   covering every setting `parameters.yaml` lists for the chapter's
   `parameters_refs`.
6. `## Reading the results`. What appears in the viewport and the
   Inspector, what each number means, worked against the fixture.
7. `## What good looks like`. The checks to apply before trusting the
   result.
8. `## On the command line`. One shell block that reproduces the
   procedure.

Each Settings entry is one paragraph that begins with the control's label
in bold with a period inside the bold, then three sentences in this order:
what it does, what the default is and why, when to change it.

    **Minimum read length.** Discards reads shorter than this after
    trimming. The default is 50 bases, long enough to map uniquely on most
    genomes. Lower it for very short amplicons, raise it when adapters
    leave many short fragments.

Explanations use the same sentence shapes across chapters. Introduce a
number with what it measures ("Depth is the number of reads covering a
position"), then what a typical value looks like on the fixture, then what
a bad value looks like.
```

- [ ] **Step 3: Update `chapters/README.md`**

Correct the directory listing to the real one (`01-foundations`, `02-sequences`, `03-reads`, `04-alignments`, `05-variants`, `06-classification`, `06-human-germline-variants`, `07-assembly`, `08-workflows`, `09-genotyping`, `appendices`) and add one sentence pointing at the chapter template in `STYLE.md`.

- [ ] **Step 4: Add a status block to ARCHITECTURE.md**

Insert after the existing `## Status (2026-05-09)` block:

```markdown
## Status (2026-09-06)

The 2026-09 fidelity and accessibility campaign rewrites every chapter to
the template in `STYLE.md` against the 2026.9.13 Preview build, adds
`parameters.yaml`, flips fixtures to human and macaque data, and
recaptures screenshots. Editorial rule 5 (screenshots at gate 2) is in force
again. The audience for every chapter is now the undergraduate reader
described in `STYLE.md`; the three tiers below remain as labels.
```

- [ ] **Step 5: Lint the three files and commit**

Run: `bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/STYLE.md docs/user-manual/chapters/README.md docs/user-manual/ARCHITECTURE.md`
Expected: no messages other than informational ones (these are not chapter files, so frontmatter rules skip them). Fix any em dash, semicolon, or in-sentence colon the run reports in the text you just wrote.

```bash
git add docs/user-manual/STYLE.md docs/user-manual/chapters/README.md docs/user-manual/ARCHITECTURE.md
git commit -m "Record the 2026-09 prose rules, app naming, and chapter template in the style guide

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 1.8: Agent definitions

**Files:**
- Modify: `.claude/agents/documentation-lead.md`
- Modify: `.claude/agents/bioinformatics-educator.md`
- Modify: `.claude/agents/brand-copy-editor.md`
- Modify: `.claude/agents/code-cartographer.md`
- Modify: `.claude/agents/screenshot-scout.md`
- Create: `.claude/agents/manual-fidelity-reviewer.md`
- Create: `.claude/agents/undergraduate-reader.md`

**Interfaces:**
- Every definition keeps its frontmatter (`name`, `description`, `tools`) and gains a section `## Campaign rules (2026-09)` containing, verbatim, the five prose rules, the app-name rule, the fixture tiers, the chapter template pointer, and the model policy line. Definitions are linted with the same linter (no em dashes, semicolons, or in-sentence colons in them).

- [ ] **Step 1: Write the shared block**

Write this block once and paste it into every definition (under a `## Campaign rules (2026-09)` heading):

```markdown
## Campaign rules (2026-09)

Ground truth, in order, is the installed Preview app at
`/Applications/Lungfish Preview.app` (2026.9.13), the Swift source, the
`lungfish-cli --help` tree from `.build/debug/lungfish-cli`, the tool lock
manifest, and only then `features.yaml`. `docs/user-manual/parameters.yaml`
lists every setting of every operation. A chapter that documents an
operation cites its ids in `parameters_refs` and documents every setting.

Prose. No em dashes. No semicolons. No colons inside a sentence (a colon may
end a lead-in line right before a list, table, or code block). No word from
`build/scripts/lint/rules/ai-tells-words.txt` in any inflection, and none of
the banned sentence shapes. At most five bullets per list and two lists per
H2 section. The app is "Lungfish Genome Explorer" at first mention and
"LGE" after. "Lungfish" alone is the research collaborative.

Reader. An undergraduate who has taken genetics and never opened a
terminal. Gloss every term at first use in every chapter. Explain what each
number means before saying what a good value is.

Examples. Human or macaque data first. Viral data only where the feature is
viral by design.

Template. The chapter template in `docs/user-manual/STYLE.md`, in that
order, with a Settings entry per setting in the fixed three-sentence shape.

Run `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh <file>`
before handing a chapter on. Never edit a file another role owns.
```

- [ ] **Step 2: Update the five existing definitions**

In each, paste the block, then make these role-specific edits. `documentation-lead.md`: gate 2 also requires `parameters_refs` coverage green and the shot check green for the chapter. `bioinformatics-educator.md`: replace the three-part template paragraph with a pointer to the STYLE.md template; add that the author never writes a Settings entry without reading the registry entry and the wizard source it cites. `brand-copy-editor.md`: add that the editor applies the synthesized reader-team report before the style pass, and records what it changed in `reviews/fidelity-2026-09/chapters/<chapter>/editor.md`. `code-cartographer.md`: add ownership of `parameters.yaml` and the extraction procedure (read the dialog state and wizard sheet, then `--help`, then fill every key). `screenshot-scout.md`: replace the "Tool access" section with: captures are driven through the `mcp__computer-use__*` tools against "Lungfish Genome Explorer Preview" (bundle id `com.lungfish.browser.preview`), the app is launched by `open -a "Lungfish Preview"`, access is requested for that app alone with a one-line reason, and a recipe YAML is still written for every PNG with the click steps recorded as `# PROSE-ONLY` comments until the runner learns to click.

- [ ] **Step 3: Write `manual-fidelity-reviewer.md`**

```markdown
---
name: manual-fidelity-reviewer
description: Checks every factual claim in a Lungfish Genome Explorer user-manual chapter against the Preview app, the Swift source, the CLI help tree, and the parameter registry. Reports, never edits.
tools: Read, Grep, Glob, Bash
---

# Manual Fidelity Reviewer

You read one chapter and its reality map, and you decide for every claim
about the app whether it is true. A claim is any sentence naming a menu
path, a dialog, a control, a setting, a default, an output file, a
viewport element, a number the app shows, or a behavior.

## Your inputs

The chapter file, its reality map under
`docs/user-manual/reviews/fidelity-2026-09/ground-truth/`, its
`parameters_refs` entries in `docs/user-manual/parameters.yaml`, the CLI
help dumps under `reviews/fidelity-2026-09/cli-help/`, and the Swift source
under `Sources/`. You may run `.build/debug/lungfish-cli <command> --help`.
You never run a command that writes, downloads, installs, or builds.

## Your output

`docs/user-manual/reviews/fidelity-2026-09/chapters/<chapter>/fidelity.md`
with one table: claim (quoted), verdict (true, false, unverifiable),
evidence (file and line, or CLI output), and the corrected wording when the
verdict is false. End with a one-line count of each verdict.

## Never do

Never edit the chapter. Never guess. When you cannot find evidence either
way, write unverifiable and say what would settle it.

(paste the Campaign rules block here)
```

- [ ] **Step 4: Write `undergraduate-reader.md`**

```markdown
---
name: undergraduate-reader
description: One member of the reader team for the Lungfish Genome Explorer user manual. Reads a chapter cold as an undergraduate biology student and lists every sentence or step that could not be followed. Reports, never edits.
tools: Read
---

# Undergraduate Reader

You are one of four readers. Your persona is given in the task prompt and is
one of: a sophomore fresh from a genetics course with no lab time; a senior
who has pipetted for two years but never analyzed data; a pre-med student
for whom English is a second language; a student who used Geneious in one
class. Stay in persona. You have never opened a terminal.

## What you do

Read the chapter from the top without skipping. Every time you meet a word
you do not know, a step you could not perform from the text alone, a
number you do not know how to judge, or a sentence you had to read twice,
write it down.

## Your output

A Markdown report with one table: location (heading and the first five
words of the sentence), what stopped you, and what would have helped. Then
three lines: the one thing you learned, the one thing you still could not
do, and the sentence you liked most. Nothing else.

## Never do

Never suggest rewrites longer than one sentence. Never comment on things
you understood. Never edit the chapter.
```

- [ ] **Step 5: Lint and commit**

Run: `bash docs/user-manual/build/scripts/lint-chapter.sh .claude/agents/*.md`
Expected: no em dash, semicolon, or in-sentence colon messages. Fix any.

```bash
git add .claude/agents
git commit -m "Update the manual agent team for the 2026-09 campaign and add reviewer personas

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

## Phase 2: Ground truth, registry, and drift

### Task 2.1: CLI help tree dump

**Files:**
- Create: `docs/user-manual/build/scripts/campaign/dump-cli-help.sh`
- Create: `docs/user-manual/reviews/fidelity-2026-09/cli-help/*.txt` (generated)

**Interfaces:**
- Produces: one file per top-level command, `cli-help/<command>.txt`, holding the command's `--help` and, below a `==== <command> <sub> ====` banner, every subcommand's `--help`. `cli-help/_root.txt` holds the root help. `cli-help/_version.txt` holds `lungfish-cli --version`.

- [ ] **Step 1: Write the script**

```bash
#!/usr/bin/env bash
# Dump the lungfish-cli help tree (root, every command, one level of
# subcommands) into docs/user-manual/reviews/fidelity-2026-09/cli-help/.
set -euo pipefail
CLI="${LUNGFISH_CLI:-.build/debug/lungfish-cli}"
[ -x "$CLI" ] || CLI="/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli"
OUT="docs/user-manual/reviews/fidelity-2026-09/cli-help"
mkdir -p "$OUT"
"$CLI" --version > "$OUT/_version.txt"
"$CLI" --help > "$OUT/_root.txt" 2>&1
cmds=$(sed -n '/^SUBCOMMANDS:/,/^$/p' "$OUT/_root.txt" | grep -E '^  [a-z]' | awk '{print $1}')
for c in $cmds; do
  f="$OUT/$c.txt"
  { echo "==== $c ===="; "$CLI" help "$c" 2>&1; } > "$f"
  subs=$(sed -n '/^SUBCOMMANDS:/,/^$/p' "$f" | grep -E '^  [a-z]' | awk '{print $1}' | sed 's/^(default)$//')
  for s in $subs; do
    { echo; echo "==== $c $s ===="; "$CLI" help "$c" "$s" 2>&1; } >> "$f"
    # one more level for the groups that nest (fastq, tree infer, genotype)
    subsubs=$(sed -n "/==== $c $s ====/,\$p" "$f" | sed -n '/^SUBCOMMANDS:/,/^$/p' | grep -E '^  [a-z]' | awk '{print $1}')
    for t in $subsubs; do { echo; echo "==== $c $s $t ===="; "$CLI" help "$c" "$s" "$t" 2>&1; } >> "$f"; done
  done
done
echo "wrote $(ls "$OUT" | wc -l | tr -d ' ') files; version $(cat "$OUT/_version.txt")"
```

- [ ] **Step 2: Run it and check**

Run: `bash docs/user-manual/build/scripts/campaign/dump-cli-help.sh`
Expected: `version 2026.9.13`, 46 files (44 commands plus `_root.txt` and `_version.txt`). Spot check: `grep -c "====" docs/user-manual/reviews/fidelity-2026-09/cli-help/fastq.txt` is 45 or more (the group plus 44 subcommands).

- [ ] **Step 3: Commit**

```bash
git add docs/user-manual/build/scripts/campaign/dump-cli-help.sh docs/user-manual/reviews/fidelity-2026-09/cli-help
git commit -m "Dump the 2026.9.13 CLI help tree as campaign ground truth

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 2.2: Reality maps, one per part

**Files:**
- Create: `docs/user-manual/reviews/fidelity-2026-09/ground-truth/<part>.md` for each of: `01-foundations`, `02-sequences`, `03-reads`, `04-alignments`, `05-variants`, `06-classification`, `06-human-germline-variants`, `07-assembly`, `08-workflows`, `09-genotyping`, `appendices`.

**Interfaces:**
- Each map follows this exact structure so Task 2.5 can consolidate them mechanically:

```markdown
# Reality map: <part>

Sources consulted: (list of Sources/ files and cli-help files)

## <chapter file name>

### Claims

| # | Claim (quoted from the chapter) | Verdict (true, false, changed) | Evidence | Corrected wording |
|---|---|---|---|---|

### Missing from this chapter

| Feature or setting | Evidence it exists |
|---|---|

### Screenshots

| Marker or planned shot | Still valid? | Why |
|---|---|---|
```

- [ ] **Step 1: Dispatch one agent per part (eleven agents, run four at a time, Opus)**

Prompt template (fill `<part>`, `<chapter files>`, `<june map path if any>`):

```
You are the manual-fidelity-reviewer persona (read .claude/agents/manual-fidelity-reviewer.md first, including its Campaign rules block). Repository worktree: <worktree path>. Do not build anything; you may run /Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli <cmd> --help.

Write docs/user-manual/reviews/fidelity-2026-09/ground-truth/<part>.md for these chapters: <chapter files>. Use exactly the structure in the plan (Reality map heading, Sources consulted, then per chapter: Claims table, Missing table, Screenshots table).

Ground truth in order: the Swift source (Sources/LungfishApp/App/MainMenu.swift, AppDelegate+ToolsMenu.swift, Views/FASTQ/FASTQOperationDialogState.swift, the wizard sheets under Sources/LungfishApp/Views, pipelines under Sources/LungfishWorkflow), the CLI help dumps under docs/user-manual/reviews/fidelity-2026-09/cli-help/, Sources/LungfishWorkflow/Resources/ManagedTools/third-party-tools-lock.json, then docs/user-manual/features.yaml as a partial index. The June 2026 map at <june map path> is a starting point but is three months stale; re-verify every row you reuse.

A claim is any sentence naming a menu path, dialog, control, setting, default, output, viewport element, number, or behavior. Quote it. Cite file:line or the cli-help file and banner for every verdict. When a claim is false, write the corrected wording. Under Missing, list every operation, setting, or viewport element in the code for this part that the chapters never mention. Under Screenshots, judge each <!-- SHOT --> marker and planned_shots entry against the corrected procedure.

No em dashes, semicolons, or in-sentence colons in your prose. Be exhaustive on claims; this file is the arbiter for the rewrite.
```

- [ ] **Step 2: Fable review of each map**

For each map, read it in full. Spot-check five random "true" verdicts and every "false" verdict against the source. Reject a map whose spot checks fail and re-dispatch with the failures quoted.

- [ ] **Step 3: Commit each accepted map**

```bash
git add docs/user-manual/reviews/fidelity-2026-09/ground-truth/<part>.md
git commit -m "Add the <part> reality map for the 2026-09 fidelity campaign

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 2.3: Parameter registry extraction

**Files:**
- Modify: `docs/user-manual/parameters.yaml`

**Interfaces:**
- Operation ids follow `<area>.<operation>` with lowercase and hyphens, one id per dialog operation or CLI command that a chapter will document. The groups and their source files are:

| Group | Operations to register | Sources |
|---|---|---|
| fastq ops | every entry in the twelve Tools categories (trim, filter, decontaminate, dedupe, merge, repair, orient, correct, subsample, extract by id, extract by motif, select by sequence, demultiplex, ONT Fluidigm split, Savont, pbAA, QC summary, low-complexity, rRNA removal, contaminant removal, human scrub, primer trim, fixed-base trim, length filter) | `Sources/LungfishApp/Views/FASTQ/FASTQOperationDialogState.swift`, `FASTQOperationToolPanes.swift`, `cli-help/fastq.txt` |
| import and fetch | fastq import, FASTA and GenBank import, BAM and CRAM import, VCF import, MSA and tree import, NCBI fetch, SRA fetch, Pathoplexus, Geneious, NVD, NAO-MGS, CZ ID, Kraken2/EsViritu/TaxTriage result import, sample metadata | `Sources/LungfishApp/Views/ImportCenter/`, `Views/DatabaseBrowser/`, `cli-help/import.txt`, `import-fastq.txt`, `fetch.txt` |
| mapping and BAM | map (four mappers), mark duplicates, primer trim BAM, extract reads, consensus | `Views/Mapping/MapReadsWizardSheet.swift`, `Views/BAM/BAMPrimerTrimDialog.swift`, `Views/Inspector/InspectorViewController+TrimDuplicateWorkflows.swift`, `cli-help/map.txt`, `bam.txt` |
| variants | call (five callers), GATK HaplotypeCaller and phasing plan, query, extract sample | `Views/BAM/BAMVariantCallingCatalog.swift`, `Views/Metagenomics/VariantQueryBuilderSheet.swift`, `cli-help/variants.txt`, `gatk.txt` |
| classification | Kraken 2 and Bracken, EsViritu, TaxTriage, BLAST verify, extract by taxon, database install | `Views/Metagenomics/ClassificationWizardSheet.swift`, `EsVirituWizardSheet.swift`, `TaxTriageWizardSheet.swift`, `cli-help/conda.txt`, `esviritu.txt`, `taxtriage.txt`, `blast.txt` |
| assembly | assemble (five assemblers), extract contigs | `Views/Assembly/AssemblyWizardSheet.swift`, `Sources/LungfishWorkflow/Assembly/AssemblyOptionCatalog.swift`, `cli-help/assemble.txt`, `extract.txt` |
| MSA and trees | MAFFT align, MSA export, IQ-TREE infer, reroot, extract subtree | `Sources/LungfishKit/MSASequenceScopePicker.swift`, `Views/Viewer/MSAAlignmentExportSheet.swift`, `Views/Phylogenetics/IQTreeInferenceDialog.swift`, `cli-help/align.txt`, `msa.txt`, `tree.txt` |
| genotyping and 12S | MiSeq amplicon genotyping, full-length ONT genotyping, AI haplotyping, exports, haplotype definitions, 12S matching | `Sources/LungfishGenotypeUI/`, `Sources/LungfishWorkflow/ONTGenotyping/`, `TwelveS/`, `cli-help/genotype.txt`, `haplotypes.txt`, `fastq.txt` (12S subcommands) |
| workflows | Viral Recon wizard, Freyja demix, Workflow Library run, Workflow Builder, provenance export | `Views/Mapping/ViralReconWizardSheet.swift`, `Views/WorkflowLibrary/`, `Views/WorkflowBuilder/`, `cli-help/workflow.txt`, `freyja.txt`, `provenance.txt` |

- [ ] **Step 1: Dispatch one agent per group (nine agents, three at a time, Opus, code-cartographer persona)**

Prompt template:

```
You are the code-cartographer persona (read .claude/agents/code-cartographer.md, including its Campaign rules block). Worktree: <path>. Do not build. You may run /Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli <cmd> --help.

Add entries to docs/user-manual/parameters.yaml for the "<group>" operations: <list>. Sources: <files>. Follow the schema in the file header exactly. Every GUI control in the dialog gets a settings entry with the label exactly as the app shows it (read the Swift string literals), its control type, default, allowed values, a plain one- or two-sentence effect an undergraduate can follow, a when_to_change sentence, and the CLI flag it maps to or null. Flags the CLI exposes that the GUI does not go under cli_only. gating lists pack ids from third-party-tools-lock.json packTools[].packID, and docker or experimental where they apply. Cite every source file you read in sources.

Only append to the operations map; do not touch other groups' entries. Validate before finishing:
  node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml
It must print "parameters ok". Report the operation ids you added and anything you could not determine from source.
```

- [ ] **Step 2: Validate and Fable review after each agent**

Run: `node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml`
Expected: `parameters ok`. Then open the group's wizard source and check three settings per operation (label text, default). Reject and re-dispatch on any mismatch.

- [ ] **Step 3: Commit per group**

```bash
git add docs/user-manual/parameters.yaml
git commit -m "Register <group> operation settings in parameters.yaml

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 2.4: Live spot-check of the twenty most used operations

**Files:**
- Modify: `docs/user-manual/parameters.yaml` (`notes` field of each checked operation)
- Create: `docs/user-manual/reviews/fidelity-2026-09/live-spot-check.md`

**Interfaces:**
- The twenty operations: fastq import, FASTA import, NCBI fetch, SRA fetch, fastp trim, human scrub, dedupe, merge pairs, subsample, map reads, mark duplicates, primer trim BAM, call variants, Kraken 2, EsViritu, assemble, MAFFT align, IQ-TREE, MiSeq genotyping, Viral Recon.
- This task needs the user present to grant computer-use access to "Lungfish Genome Explorer Preview".

- [ ] **Step 1: Prepare**

Run: `open -a "Lungfish Preview"`; confirm with `osascript -e 'tell application "System Events" to get name of every process whose name contains "Lungfish"'` that only the Preview process is running (quit any other Lungfish first, by its menu item, never cmd+q). Load the computer-use tools with `ToolSearch` query `computer-use` (max 30). Call `mcp__computer-use__request_access` for the Preview app alone with the reason "read dialog controls to verify the manual's parameter registry".

- [ ] **Step 2: For each of the twenty operations**

Open the dialog by its `entry_points` menu path (use `app_menu` for menu items, `app_click` for buttons found with `app_ax_find`). Take `app_screenshot`. Read every control label and default. Compare with the registry entry. Record in `live-spot-check.md` a row per operation: operation id, controls seen, mismatches. Fix mismatches in `parameters.yaml` and add to that operation's `notes`: `Live-checked in Preview 2026.9.13 on 2026-09-<dd>.` Close the dialog with its Cancel button. Never click Run.

- [ ] **Step 3: Validate and commit**

Run: `node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml`
Expected: `parameters ok`.

```bash
git add docs/user-manual/parameters.yaml docs/user-manual/reviews/fidelity-2026-09/live-spot-check.md
git commit -m "Spot-check twenty operations against the live Preview app and correct the registry

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 2.5: Drift report and chapter roster

**Files:**
- Create: `docs/user-manual/reviews/fidelity-2026-09/DRIFT.md`

**Interfaces:**
- `DRIFT.md` has two parts. Part A, one section per existing chapter with: verdict counts from its map, the list of false claims with corrected wording, the missing features, the screenshot verdicts, the fixture it will use after Phase 3, and a decision (`rewrite`, `rewrite and split`, `rewrite and merge into <chapter>`, `delete`). Part B, the roster: a table of every chapter that will exist after the campaign, in nav order, with `chapter_id`, title, `parameters_refs`, fixture, and whether it is existing or new. Every feature listed under Missing in any map must appear in some roster row's scope or in a "deliberately undocumented" list with a reason.

- [ ] **Step 1: Consolidate (Fable, in session, with a Sonnet agent for the mechanical merge of tables)**

Dispatch a Sonnet agent to concatenate the eleven maps' Claims (false rows only), Missing, and Screenshots tables into `DRIFT.md` Part A skeleton per chapter. Then write Part A decisions and Part B yourself.

- [ ] **Step 2: Reconcile the nav**

Every roster row must be in `docs/user-manual/build/mkdocs.yml` `nav:`. Note in Part B the chapters currently missing from the nav (`03-reads/08-read-processing.md`, `08-workflows/03-running-external-workflows.md`, all four `09-genotyping` chapters, `appendices/ai-assistant.md`) and any renames.

- [ ] **Step 3: Present DRIFT.md to the user**

Surface the roster and every `delete` or `merge` decision to the user before Phase 4 begins. Do not proceed to Phase 4 until the roster is approved.

- [ ] **Step 4: Commit**

```bash
git add docs/user-manual/reviews/fidelity-2026-09/DRIFT.md
git commit -m "Consolidate the drift report and the post-campaign chapter roster

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

## Phase 3: Fixtures and the demo project

All fixture scripts run from the worktree root. Sizes are checked with `du -sh`. The 10 MB per-file and 50 MB per-set caps are hard.

### Task 3.1: Human HG002 chromosome 20 slice

**Files:**
- Create: `docs/user-manual/fixtures/hg002-chr20/README.md`
- Create: `docs/user-manual/fixtures/hg002-chr20/fetch.sh`
- Create: `docs/user-manual/fixtures/hg002-chr20/regenerate.sh`
- Create (generated, committed if under caps): `GRCh38.chr20.10.0-10.5Mb.fasta`, `HG002.chr20.10.0-10.5Mb.R1.fastq.gz`, `...R2.fastq.gz`, `HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz` (+ `.tbi`), `expected/` outputs

**Interfaces:**
- Region: `chr20:10000000-10500000` (500 kb, gene-rich, no known assembly gaps). FASTA header is rewritten to `chr20_10.0-10.5Mb` and coordinates in the benchmark VCF are shifted by subtracting 9,999,999, so the fixture is self-contained.
- Produces the fixture the mapping, alignment-reading, variant-calling, and variant-browser chapters use.

- [ ] **Step 1: Verify the source URLs are live**

Run:

```bash
for u in \
 "https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam" \
 "https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz" \
 "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr20.fa.gz"; do
  printf "%s -> " "$u"; curl -sI -m 30 "$u" | head -1; done
```

Expected: three `HTTP/1.1 200` lines (or 302 to a 200). If the BAM URL has moved, browse `https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/` and pick the current Illumina GRCh38 BAM; record the URL you used in the README.

- [ ] **Step 2: Write `fetch.sh`**

```bash
#!/usr/bin/env bash
# Slice HG002 chromosome 20 (10.0 to 10.5 Mb) from public GIAB data.
# Needs samtools, bcftools, and htslib (bgzip, tabix) from the managed
# lungfish-tools environment; the paths below are the managed installs.
set -euo pipefail
cd "$(dirname "$0")"
ENV="$HOME/.lungfish/conda/envs"
SAMTOOLS="$ENV/samtools/bin/samtools"; BCFTOOLS="$ENV/bcftools/bin/bcftools"
BGZIP="$ENV/htslib/bin/bgzip"; TABIX="$ENV/htslib/bin/tabix"
REGION="chr20:10000000-10500000"; OFFSET=9999999
BAM="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam"
VCF="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz"
CHR="https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr20.fa.gz"
mkdir -p cache
# Reference slice, header renamed so the fixture stands alone.
[ -f cache/chr20.fa.gz ] || curl -sL "$CHR" -o cache/chr20.fa.gz
gunzip -kf cache/chr20.fa.gz
"$SAMTOOLS" faidx cache/chr20.fa "$REGION" | sed '1s/.*/>chr20_10.0-10.5Mb/' > GRCh38.chr20.10.0-10.5Mb.fasta
"$SAMTOOLS" faidx GRCh38.chr20.10.0-10.5Mb.fasta
# Reads: remote region fetch, name-sorted, paired FASTQ.
"$SAMTOOLS" view -b -h "$BAM" "$REGION" > cache/slice.bam
"$SAMTOOLS" sort -n -o cache/slice.nsort.bam cache/slice.bam
"$SAMTOOLS" fastq -1 HG002.chr20.10.0-10.5Mb.R1.fastq.gz -2 HG002.chr20.10.0-10.5Mb.R2.fastq.gz -0 /dev/null -s /dev/null -n cache/slice.nsort.bam
# Benchmark calls, shifted into fixture coordinates.
"$BCFTOOLS" view -r "$REGION" "$VCF" -Ou | "$BCFTOOLS" annotate --rename-chrs <(echo "chr20 chr20_10.0-10.5Mb") -Ov \
 | awk -v o="$OFFSET" 'BEGIN{OFS="\t"} /^#/ {print; next} {$2=$2-o; print}' | "$BGZIP" -c > HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz
"$TABIX" -p vcf HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz
du -sh *.fasta *.fastq.gz *.vcf.gz
```

- [ ] **Step 3: Run it and check sizes**

Run: `bash docs/user-manual/fixtures/hg002-chr20/fetch.sh`
Expected: FASTA about 0.5 MB, each FASTQ under 10 MB (2x250 at roughly 40x over 500 kb is about 20 MB of gzipped reads split across two files; if either file exceeds 10 MB, downsample in the script with `"$SAMTOOLS" view -s 0.5` before `fastq` and note the fraction in the README), VCF under 1 MB. If the managed env paths differ, run `ls ~/.lungfish/conda/envs` and correct the four tool paths.

- [ ] **Step 4: Write `regenerate.sh` and the README**

`regenerate.sh` maps the reads with the managed minimap2 and calls with bcftools into `expected/`, so the manual can quote real numbers:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
mkdir -p expected
"$CLI" map --paired --mapper minimap2 --preset sr --reference GRCh38.chr20.10.0-10.5Mb.fasta \
  --sample-name HG002 -o expected/mapping HG002.chr20.10.0-10.5Mb.R1.fastq.gz HG002.chr20.10.0-10.5Mb.R2.fastq.gz
ls expected/mapping
```

README records source URLs, GIAB's public-domain status (NIST data, no license restriction, cite Zook et al. 2019, doi:10.1038/s41587-019-0074-6), the region, the coordinate offset, per-file sizes, the downsampling fraction if any, and an internal-consistency note that the reads map to the slice and the benchmark VCF is the truth set for the chapter's variant calls.

- [ ] **Step 5: Commit**

```bash
git add docs/user-manual/fixtures/hg002-chr20
git commit -m "Add the HG002 chromosome 20 fixture for the mapping and variant chapters

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

(Add `cache/` and `expected/mapping/` to `docs/user-manual/fixtures/hg002-chr20/.gitignore` before committing if the mapping output exceeds the caps.)

### Task 3.2: Human mitochondrial genome and reads

**Files:**
- Create: `docs/user-manual/fixtures/human-mito/README.md`, `fetch.sh`, `regenerate.sh`
- Create (generated): `NC_012920.1.fasta` (rCRS, 16,569 bp), `HG002.chrM.R1.fastq.gz`, `HG002.chrM.R2.fastq.gz`, `expected/spades/contigs.fasta`

**Interfaces:**
- Used by the assembly chapters (short-read assembly of a 16.5 kb genome finishes in under a minute) and as the human entry in the primate set (Task 3.3).

- [ ] **Step 1: Write `fetch.sh`**

Same tool paths as Task 3.1. Reference via NCBI efetch: `curl -sL "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_012920.1&rettype=fasta&retmode=text" > NC_012920.1.fasta`. Reads: `"$SAMTOOLS" view -b -h "$BAM" chrM` from the same GIAB BAM, then name-sort and `fastq` as in Task 3.1. Downsample to 300x if the FASTQs exceed 10 MB (`-s 0.25`); record the fraction.

- [ ] **Step 2: Write `regenerate.sh`**

```bash
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
"$CLI" assemble --assembler spades --read-type illumina-short-reads --paired \
  --name HG002-chrM -o expected/spades HG002.chrM.R1.fastq.gz HG002.chrM.R2.fastq.gz
```

- [ ] **Step 3: Run both, check sizes, write README (source, license, citation, sizes, note that the expected assembly should be one contig near 16.5 kb), commit**

```bash
git add docs/user-manual/fixtures/human-mito
git commit -m "Add the human mitochondrial fixture for the assembly chapters

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 3.3: Primate mitochondrial genome set

**Files:**
- Create: `docs/user-manual/fixtures/primate-mito/README.md`, `fetch.sh`, `regenerate.sh`
- Create (generated): `primate-mito.fasta` (five records), `expected/primate-mito.aligned.fasta`, `expected/primate-mito.treefile`

**Interfaces:**
- Accessions: human `NC_012920.1`, chimpanzee `NC_001643.1`, gorilla `NC_011120.1`, rhesus macaque `NC_005943.1`, cynomolgus macaque `NC_012670.1`. Used by the MSA and tree chapters.

- [ ] **Step 1: Verify the accessions**

Run:

```bash
for a in NC_012920.1 NC_001643.1 NC_011120.1 NC_005943.1 NC_012670.1; do
  curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=nuccore&id=$a&retmode=json" | python3 -c "import sys,json; r=json.load(sys.stdin)['result']; k=[x for x in r if x!='uids'][0]; print('$a', r[k]['title'], r[k]['slen'])"; done
```

Expected: five lines naming Homo sapiens, Pan troglodytes, Gorilla gorilla, Macaca mulatta, Macaca fascicularis mitochondrion, each about 16.5 kb. Replace any accession that resolves to something else with the current RefSeq mitochondrion for that species and record it.

- [ ] **Step 2: Write `fetch.sh`** (efetch each into `primate-mito.fasta`, headers rewritten to `Human_NC_012920.1` and so on so the tree tips read well), **`regenerate.sh`**:

```bash
CLI=/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli
rm -rf expected/tmp-project && mkdir -p expected/tmp-project
"$CLI" align mafft --strategy auto --name "Primate mitochondria" --project expected/tmp-project primate-mito.fasta
MSA=$(find expected/tmp-project -name '*.lungfishmsa' | head -1)
"$CLI" tree infer iqtree --help > /dev/null   # confirm flags before the next line
"$CLI" tree infer iqtree "$MSA" --project expected/tmp-project
```

Read `cli-help/tree.txt` (Task 2.1) for the exact `tree infer iqtree` flags before writing the last line, and copy the aligned FASTA and treefile out of the bundles into `expected/`.

- [ ] **Step 3: Run, check, write README (RefSeq, public domain, cite the NCBI RefSeq release), commit**

```bash
git add docs/user-manual/fixtures/primate-mito
git commit -m "Add the primate mitochondrial genome fixture for the alignment and tree chapters

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 3.4: Human gene record with annotations

**Files:**
- Create: `docs/user-manual/fixtures/hbb-gene/README.md`, `fetch.sh`
- Create (generated): `NG_000007.3.gb` (RefSeqGene HBB, about 81 kb, with gene, mRNA, CDS, and exon features)

**Interfaces:**
- Used by the sequence-viewing, annotation, extraction, and translation chapters. Sickle cell (HbS, Glu6Val) is the worked example for "why you would do this".

- [ ] **Step 1: Write `fetch.sh`** (`efetch ... id=NG_000007.3&rettype=gbwithparts&retmode=text`), run it, confirm the file has `CDS` features with `grep -c "     CDS " NG_000007.3.gb` (expected 1 or more), write the README (RefSeq, public domain), commit.

```bash
git add docs/user-manual/fixtures/hbb-gene
git commit -m "Add the HBB RefSeqGene fixture for the sequence chapters

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 3.5: NVD import fixture and the genotyping demo asset note

**Files:**
- Create: `docs/user-manual/fixtures/nvd-demo/README.md`
- Create: `docs/user-manual/fixtures/nvd-demo/results/05_labkey_bundling/demo_blast_concatenated.csv` (copied from `Tests/Fixtures/nvd/test_blast_concatenated.csv`)
- Create: `docs/user-manual/fixtures/demo-assets/README.md`

- [ ] **Step 1: Build the NVD directory and prove it imports**

Run:

```bash
mkdir -p docs/user-manual/fixtures/nvd-demo/results/05_labkey_bundling
cp Tests/Fixtures/nvd/test_blast_concatenated.csv docs/user-manual/fixtures/nvd-demo/results/05_labkey_bundling/demo_blast_concatenated.csv
mkdir -p /tmp/nvd-import-check && /Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli import nvd docs/user-manual/fixtures/nvd-demo/results -o /tmp/nvd-import-check --name nvd-demo
ls /tmp/nvd-import-check
```

Expected: an `nvd-demo` bundle directory appears. If import rejects the layout, read `Sources/LungfishWorkflow/Metagenomics/MetagenomicsImportService.swift` for the expected file names and adjust.

- [ ] **Step 2: Write `demo-assets/README.md`**

Document the genotyping demo asset: path `/Users/dho/Downloads/32566_MS267_Williams1.lungfish`, contents (30 MiSeq FASTQ bundles, reference bundle `26128_ipd-mhc-mamu-2021-07-09.lungfishref`, seven genotype result bundles under `Analyses/Amplicon genotyping results/`, a primer scheme folder, barcode sheet `32566_MS267_Williams1_barcodes.txt`), size 475 MB, why it is not committed, the user's decision that the genotyping chapters use it as a genotyping-only example with a labeled placeholder section for haplotype analysis (no worked MCM example), and the open question about animal identifiers in screenshots (spec open item 3). Instruct capture recipes to reference it as `{demo_assets}/32566_MS267_Williams1.lungfish`.

- [ ] **Step 3: Commit**

```bash
git add docs/user-manual/fixtures/nvd-demo docs/user-manual/fixtures/demo-assets
git commit -m "Add the NVD import fixture and document the genotyping demo asset

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 3.6: Fixture README tiers

**Files:**
- Modify: `docs/user-manual/fixtures/README.md`

- [ ] **Step 1: Replace the "Pathogen tiers" section with "Example data tiers"** listing human, rhesus macaque, primate comparative, and viral-by-design exactly as the spec states, and replace the "Sets" section with one paragraph per fixture directory (the four new sets, `nvd-demo`, `demo-assets`, and the two SARS-CoV-2 sets marked "viral by design, used by the Viral Recon, Freyja, EsViritu, classification, and NVD chapters").

- [ ] **Step 2: Lint (non-chapter, so only prose rules apply) and commit**

```bash
bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/fixtures/README.md
git add docs/user-manual/fixtures/README.md
git commit -m "Flip the fixture tiers to human and macaque data first

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 3.7: Demo project build script

**Files:**
- Create: `docs/user-manual/fixtures/demo-project/build-demo-project.sh`
- Create: `docs/user-manual/fixtures/demo-project/README.md`

**Interfaces:**
- Produces `$LUNGFISH_DEMO_ROOT/LGE Manual Demo.lungfish` (default `$HOME/Documents/LGE Manual Demo.lungfish`) with, in order: the HBB reference bundle, the chr20 reference bundle with a minimap2 track and bcftools and LoFreq variant tracks, the chrM reads and a SPAdes assembly, the primate MSA and IQ-TREE tree, a Kraken 2 Viral classification of the SARS-CoV-2 fixture reads with Bracken, the NVD demo import, and a Viral Recon run on the SARS-CoV-2 fixture. Every recipe in Phase 5 opens this project. The script is idempotent (skips a step whose output exists) and logs to `build.log`.
- Project creation: there is no `project create` command. A project directory becomes a project when the first import writes into it. The script creates the directory and runs `import-fastq --project` first.

- [ ] **Step 1: Write the script**

```bash
#!/usr/bin/env bash
# Build the manual's demo project from the committed fixtures. Idempotent.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; FX="$HERE/.."
CLI="${LUNGFISH_CLI:-/Users/dho/Documents/lungfish-genome-explorer/.build/debug/lungfish-cli}"
ROOT="${LUNGFISH_DEMO_ROOT:-$HOME/Documents}"
P="$ROOT/LGE Manual Demo.lungfish"
mkdir -p "$P"; exec > >(tee -a "$P/build.log") 2>&1
step() { echo; echo "== $1 ($(date +%H:%M:%S))"; }
done_if() { [ -e "$1" ] && { echo "   exists, skipping"; return 0; } || return 1; }

step "1 reads"
done_if "$P/Imports/HG002" || "$CLI" import-fastq --project "$P" --platform illumina --no-optimize-storage \
  "$FX/hg002-chr20/HG002.chr20.10.0-10.5Mb.R1.fastq.gz" "$FX/hg002-chr20/HG002.chr20.10.0-10.5Mb.R2.fastq.gz"
done_if "$P/Imports/HG002.chrM" || "$CLI" import-fastq --project "$P" --platform illumina --no-optimize-storage \
  "$FX/human-mito/HG002.chrM.R1.fastq.gz" "$FX/human-mito/HG002.chrM.R2.fastq.gz"
done_if "$P/Imports/SRR36291587" || "$CLI" import-fastq --project "$P" --platform illumina --no-optimize-storage "$FX/sarscov2-srr36291587"

step "2 references"
REFDIR="$P/Reference Sequences"; mkdir -p "$REFDIR"
done_if "$REFDIR/HBB.lungfishref" || "$CLI" import fasta "$FX/hbb-gene/NG_000007.3.gb" --name HBB -o "$REFDIR"
done_if "$REFDIR/chr20.lungfishref" || "$CLI" import fasta "$FX/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta" --name "chr20 10.0-10.5Mb" -o "$REFDIR"

step "3 mapping and variants"
CHR20=$(ls -d "$REFDIR"/*chr20*.lungfishref | head -1)
done_if "$P/Analyses/mapping-HG002" || "$CLI" map --paired --mapper minimap2 --preset sr --reference "$FX/hg002-chr20/GRCh38.chr20.10.0-10.5Mb.fasta" \
  --sample-name HG002 -o "$P/Analyses/mapping-HG002" "$FX/hg002-chr20/HG002.chr20.10.0-10.5Mb.R1.fastq.gz" "$FX/hg002-chr20/HG002.chr20.10.0-10.5Mb.R2.fastq.gz"
"$CLI" bam adopt-mapping --bundle "$CHR20" --mapping-result "$P/Analyses/mapping-HG002" --name "HG002 minimap2" --track-id hg002-minimap2 || true
"$CLI" variants call --bundle "$CHR20" --alignment-track hg002-minimap2 --caller bcftools --name "HG002 bcftools" || true
"$CLI" variants call --bundle "$CHR20" --alignment-track hg002-minimap2 --caller lofreq --name "HG002 LoFreq" || true

step "4 assembly"
done_if "$P/Assemblies/HG002-chrM" || "$CLI" assemble --assembler spades --read-type illumina-short-reads --paired --name HG002-chrM \
  -o "$P/Assemblies/HG002-chrM" "$FX/human-mito/HG002.chrM.R1.fastq.gz" "$FX/human-mito/HG002.chrM.R2.fastq.gz"

step "5 alignment and tree"
ls "$P"/*.lungfishmsa "$P"/Analyses/*.lungfishmsa >/dev/null 2>&1 || "$CLI" align mafft --name "Primate mitochondria" --project "$P" "$FX/primate-mito/primate-mito.fasta"
MSA=$(find "$P" -name '*.lungfishmsa' -maxdepth 3 | head -1)
find "$P" -name '*.lungfishtree' -maxdepth 3 | grep -q . || "$CLI" tree infer iqtree "$MSA" --project "$P"

step "6 classification"
done_if "$P/Analyses/kraken2-SRR36291587" || "$CLI" conda classify --db Viral --profile --paired -o "$P/Analyses/kraken2-SRR36291587" \
  "$FX"/sarscov2-srr36291587/*_1.fastq.gz "$FX"/sarscov2-srr36291587/*_2.fastq.gz

step "7 NVD import"
done_if "$P/Analyses/nvd-demo" || "$CLI" import nvd "$FX/nvd-demo/results" -o "$P/Analyses" --name nvd-demo

step "8 Viral Recon (needs Docker Desktop running)"
docker info >/dev/null 2>&1 || { echo "   Docker not running; skipping Viral Recon. Start Docker Desktop and re-run."; exit 0; }
done_if "$P/Analyses/viralrecon" || "$CLI" workflow run nf-core/viralrecon --help > /dev/null
echo "   Viral Recon is run once from the app's Tools > Mapping > Viral Recon wizard on the SRR36291587 sample; see README."
echo "== done"
```

- [ ] **Step 2: Confirm each command's flags against the help dumps before running**

For every `"$CLI"` line, open the matching `cli-help/*.txt` file and check the flags exist. Fix the script where they differ (the `variants call --alignment-track` id, the `tree infer iqtree` positional and `--project`, and the `import nvd` output layout are the three most likely to need adjustment). Record each adjustment in the README.

- [ ] **Step 3: Run the script**

Run: `bash docs/user-manual/fixtures/demo-project/build-demo-project.sh`
Expected: steps 1 to 7 complete; step 8 prints the Viral Recon note. Open the project in the Preview app (`open -a "Lungfish Preview" "$HOME/Documents/LGE Manual Demo.lungfish"`) and confirm each result appears in the sidebar. Then run Viral Recon once from the wizard on the SRR36291587 sample (Docker running) so the Viral Recon chapter has a result to screenshot; note the wall-clock time in the README.

- [ ] **Step 4: Write the README and commit**

README: what the project contains, how long each step takes, the environment variables, and the manual Viral Recon step.

```bash
git add docs/user-manual/fixtures/demo-project
git commit -m "Add the demo project build script for the manual's screenshots

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

---

## Phase 4: Chapter rewrite pipeline

This phase runs once per roster row in `DRIFT.md` Part B, in nav order. The task below is written in full once and applied to every chapter; each application is one commit. Track progress in `DRIFT.md` Part B by adding a `status` column (`queued`, `authored`, `reviewed`, `edited`, `gated`, `committed`).

### Task 4.N: Rewrite chapter `<chapter_id>`

**Files:**
- Modify: `docs/user-manual/chapters/<chapter_id>.md`
- Modify: `docs/user-manual/GLOSSARY.md` (new terms only, alphabetised)
- Modify: `docs/user-manual/build/mkdocs.yml` (only when the roster changes the nav)
- Modify: `docs/user-manual/help-ids.yaml` (only when an H2 or H3 the app links to is renamed)
- Create: `docs/user-manual/reviews/fidelity-2026-09/chapters/<chapter_id with / replaced by __>/fidelity.md`, `readers.md`, `editor.md`, `fable-gate.md`

**Interfaces:**
- Consumes: the chapter's section in `DRIFT.md` Part A, its reality map, its `parameters_refs` ids in `parameters.yaml`, and its fixture.
- Produces: a chapter whose frontmatter has `parameters_refs` set, `shots` listing every marker in the body, `brand_reviewed: true`, `lead_approved: true`, and which passes strict lint.

- [ ] **Step 1: Author (one Opus agent, bioinformatics-educator persona)**

Prompt:

```
You are the bioinformatics-educator persona (read .claude/agents/bioinformatics-educator.md including its Campaign rules block, and docs/user-manual/STYLE.md in full). Worktree: <path>.

Rewrite docs/user-manual/chapters/<chapter_id>.md to the chapter template. Inputs, all of which you must read before writing: the chapter's section in docs/user-manual/reviews/fidelity-2026-09/DRIFT.md, its reality map docs/user-manual/reviews/fidelity-2026-09/ground-truth/<part>.md, the registry entries <ids> in docs/user-manual/parameters.yaml, the fixture <fixture path> and its README and expected/ outputs, and docs/user-manual/GLOSSARY.md.

Rules. Every claim about the app comes from the reality map or the registry; if neither covers it, read the Swift source it cites, and if that does not settle it, leave it out. In the 09-genotyping chapters, haplotyping is covered only by a section headed "## Haplotype analysis (placeholder)" with two sentences: the feature exists, and a worked example with an MCM dataset will be added later. The Settings section has one paragraph per registry setting in the fixed three-sentence shape, beginning with **<label>.** exactly as the registry spells the label. Keep every <!-- SHOT: id --> the drift report marked valid, remove the ones it marked stale, and add a marker (with a shots[] entry carrying a one-sentence caption) wherever a reader needs to see the screen; do not capture anything. Worked numbers come from the fixture's expected/ outputs, never invented. Set frontmatter parameters_refs to <ids>, keep brand_reviewed and lead_approved false. Add any new term to GLOSSARY.md in alphabetical order with the existing entry shape.

Voice. Write for the undergraduate reader in the style guide. Short sentences. One idea each. Gloss every term at first use. No em dashes, semicolons, in-sentence colons, or listed words. "Lungfish Genome Explorer" first, then "LGE".

Finish by running LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/<chapter_id>.md and fixing everything it reports. Report what you removed from the old chapter and why.
```

- [ ] **Step 2: Fidelity review (one Opus agent with the manual-fidelity-reviewer persona, then Fable)**

Dispatch with: "Review docs/user-manual/chapters/<chapter_id>.md per your definition; write reviews/fidelity-2026-09/chapters/<dir>/fidelity.md." Then read `fidelity.md` yourself, spot-check every "false" row and three "true" rows against the source. If any false claim remains, send the author agent the rows and repeat Step 1 on the affected sections only.

- [ ] **Step 3: Reader team (four agents in parallel, then one synthesizer)**

Dispatch four `undergraduate-reader` agents, one per persona, with: "Persona: <persona sentence>. Read docs/user-manual/chapters/<chapter_id>.md cold and write your report to reviews/fidelity-2026-09/chapters/<dir>/reader-<n>.md." Then dispatch one Sonnet agent: "Merge reader-1.md to reader-4.md into readers.md. One table: location, what stopped readers, how many of the four hit it (4 first), the shortest suggested fix. Then a three-line summary of the most common failure. Do not add opinions of your own."

- [ ] **Step 4: Editor (one Opus agent, brand-copy-editor persona)**

Prompt: "Apply readers.md to docs/user-manual/chapters/<chapter_id>.md: fix every item hit by two or more readers, and the single-reader items where the fix is one sentence. Then the style pass per your definition. Do not change any factual claim; if a reader was confused by something the fidelity review confirmed as true, add explanation rather than changing the fact. Record every change in reviews/fidelity-2026-09/chapters/<dir>/editor.md. Run strict lint and finish green."

- [ ] **Step 5: Lint strict**

Run: `LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/<chapter_id>.md`
Expected: no messages.

- [ ] **Step 6: Fable gate**

Read the full diff (`git diff docs/user-manual/chapters/<chapter_id>.md`) and the full new chapter. Check: template order, every registry setting present, every number traceable to `expected/`, every menu path matches the reality map, no removed content without a note, glossary entries alphabetised, nav and help-ids updated if headings changed. Write `fable-gate.md` with pass or the list of blocking items (blocking items go back to Step 4). On pass, set `brand_reviewed: true` and `lead_approved: true` in the frontmatter and update the `status` column in `DRIFT.md`.

- [ ] **Step 7: Commit**

```bash
git add docs/user-manual/chapters/<chapter_id>.md docs/user-manual/GLOSSARY.md docs/user-manual/build/mkdocs.yml docs/user-manual/help-ids.yaml docs/user-manual/reviews/fidelity-2026-09/chapters/<dir> docs/user-manual/reviews/fidelity-2026-09/DRIFT.md
git commit -m "Rewrite <chapter title> for the 2026-09 fidelity campaign

Author: educator (Opus). Fidelity: reviewer (Opus) + Fable. Readers: four undergraduate personas, synthesized. Editor: copy editor (Opus). Gate: Fable.

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 4.Z: Part checkpoints

After the last chapter of each part (Foundations, Sequences, Reads, Alignments, Variants, Classification, Human Germline Variants, Assembly, Workflows, Genotyping, Appendices):

- [ ] **Step 1: Run the checkers over the whole manual**

```bash
LUNGFISH_MANUAL_STRICT=1 bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/*/*.md > /tmp/lint.txt; echo exit=$?
node docs/user-manual/build/scripts/campaign/check-links.mjs docs/user-manual
```

Expected: strict lint exits 0 for every chapter already rewritten (chapters not yet rewritten may still report), and `links ok`.

- [ ] **Step 2: Send the user the part's chapters**

Use `SendUserFile` on the rewritten chapter files with a one-line caption naming the part and the count of corrections from DRIFT.md, so the user can read along while the next part runs.

---

## Phase 5: Screenshots

Capture runs after Phase 4 so every marker reflects final procedures. It needs the user present to grant access once per session.

### Task 5.1: Shot manifest

**Files:**
- Create: `docs/user-manual/reviews/fidelity-2026-09/SHOTS.md`

- [ ] **Step 1: Generate the manifest**

Run:

```bash
grep -rno '<!-- SHOT: [a-z0-9-]* -->' docs/user-manual/chapters | sed -E 's#docs/user-manual/chapters/([^/]+)/([^:]+):([0-9]+):<!-- SHOT: ([a-z0-9-]+) -->#| \1 | \2 | \3 | \4 |#' | sort > /tmp/shots.md
node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual > /tmp/shot-check.txt || true
```

Write `SHOTS.md` as a table (chapter dir, file, line, id, caption from frontmatter, status: `new`, `stale`, or `existing`, the project state needed, the dialog or viewport to show), one row per marker, with the check output attached. Every `stale` and `new` row is captured; `existing` rows whose procedure did not change are kept only if the Fable gate for that chapter said so.

### Task 5.2: Capture session (repeat until SHOTS.md has no open rows)

**Files:**
- Create: `docs/user-manual/assets/screenshots/<chapter-dir>/<id>.png`
- Create: `docs/user-manual/assets/recipes/<chapter-dir>/<id>.yaml`

- [ ] **Step 1: Prepare the app**

Run `open -a "Lungfish Preview" "$HOME/Documents/LGE Manual Demo.lungfish"`. Confirm the process list shows only the Preview app. Set the Mac to light appearance for the session (System Settings is off limits to computer use; ask the user to switch if it is dark). Load the computer-use tools (`ToolSearch` query `computer-use`, max 30) and request access to "Lungfish Genome Explorer Preview" alone.

- [ ] **Step 2: For each open row in SHOTS.md, in chapter order**

1. Drive the app to the state in the row: `app_menu` for menu paths, `app_ax_find` then `app_click` for buttons and sidebar rows, `app_type` for fields. Resize the main window to 1600 by 1000 with `osascript -e 'tell application "System Events" to tell process "Lungfish Genome Explorer Preview" to set size of front window to {1600, 1000}'` before full-app shots.
2. `app_screenshot` of the window (never the full display). Save it to `assets/screenshots/<chapter-dir>/<id>.png`. If the tool returns a display capture, crop to the window with `sips --cropToHeightWidth` using the window bounds from System Events.
3. Write the recipe YAML matching `build/scripts/shot/schema.json`: `id`, `chapter`, `caption` (from the frontmatter), `viewport_class`, `app_state` (`fixture: "{demo_project}"`, `open_files`, `window_size: [1600, 1000]`, `appearance: light`), `steps` with the runner's `open_application`, `wait_ready`, `resize_window` actions plus every click recorded as a `# PROSE-ONLY:` comment line, `crop.mode`, and `post: {retina: true, format: png}`.
4. Update the row's status in SHOTS.md to `captured`.
5. Close the dialog with Cancel. Never click Run inside a capture session unless the row says the shot is the running state, and then only on the demo project.

- [ ] **Step 3: After each session**

Run: `node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual`
Expected: fewer problems than before; zero when SHOTS.md is closed out. Commit the session:

```bash
git add docs/user-manual/assets/screenshots docs/user-manual/assets/recipes docs/user-manual/reviews/fidelity-2026-09/SHOTS.md
git commit -m "Capture manual screenshots from Preview 2026.9.13 (<part names>)

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

- [ ] **Step 4: Remove orphans**

For every `orphan png` or `orphan recipe` the checker lists, `git rm` the file and note it in RESULTS.md under Screenshots.

---

## Phase 6: Verification and delivery

### Task 6.1: Flip lint to strict by default

**Files:**
- Modify: `docs/user-manual/build/scripts/lint/rules/severity.js`

- [ ] **Step 1: Change `report()`** so `msg.fatal = false` only when `process.env.LUNGFISH_MANUAL_STRICT === "0"`, and update the comment: strict is now the default, `LUNGFISH_MANUAL_STRICT=0` relaxes it.

- [ ] **Step 2: Run the whole manual**

Run: `bash docs/user-manual/build/scripts/lint-chapter.sh docs/user-manual/chapters/*/*.md docs/user-manual/GLOSSARY.md docs/user-manual/index.md; echo exit=$?`
Expected: `exit=0`. Fix any chapter that reports.

- [ ] **Step 3: Commit**

```bash
git add docs/user-manual/build/scripts/lint/rules/severity.js
git commit -m "Make the campaign prose rules strict by default

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

### Task 6.2: Site build

- [ ] **Step 1: Build with mkdocs in a scratch virtualenv**

```bash
python3 -m venv /tmp/lge-docs-venv && /tmp/lge-docs-venv/bin/pip install -q -r docs/requirements.txt
/tmp/lge-docs-venv/bin/mkdocs build --strict -f docs/user-manual/build/mkdocs.yml -d /tmp/lge-docs-site 2>&1 | tail -20
```

Expected: `--strict` exits 0 with no warnings. Warnings about nav entries or missing files are fixed in `mkdocs.yml`.

- [ ] **Step 2: Run every checker**

```bash
node docs/user-manual/build/scripts/campaign/check-links.mjs docs/user-manual
node docs/user-manual/build/scripts/campaign/check-shots.mjs docs/user-manual
node docs/user-manual/build/scripts/campaign/validate-parameters.mjs docs/user-manual/parameters.yaml
python3 - <<'EOF'
import re,glob,yaml
bad=0
for f in glob.glob('docs/user-manual/chapters/*/*.md'):
    fm=yaml.safe_load(re.match(r'^---\n(.*?)\n---',open(f).read(),re.S).group(1))
    for k in ('brand_reviewed','lead_approved'):
        if fm.get(k) is not True: print(f, k, fm.get(k)); bad+=1
print('frontmatter flags:', 'ok' if bad==0 else f'{bad} not approved')
EOF
```

Expected: `links ok`, `shots ok`, `parameters ok`, `frontmatter flags: ok`.

- [ ] **Step 3: Preview in the browser**

Serve `/tmp/lge-docs-site` with a `.claude/launch.json` entry (`python3 -m http.server 8766 --directory /tmp/lge-docs-site`), open it in the Browser pane, and read three chapters end to end (one Foundations, one Reads, one Genotyping) checking rendering of Settings paragraphs, screenshots, and code blocks. Fix what you find and rebuild.

### Task 6.3: Remove the "not ready for use" banner decision

**Files:**
- Modify: `docs/user-manual/overrides/main.html`

- [ ] **Step 1: Ask the user** whether the banner ("This documentation is under active development and is not ready for use") should come down with this campaign. If yes, replace the block with an empty `{% block announce %}{% endblock %}` and commit. If no, leave it.

### Task 6.4: Memory and agent hygiene

- [ ] **Step 1: Update the docs prose rules memory** at `/Users/dho/.claude/projects/-Users-dho-Documents-lungfish-genome-explorer/memory/lungfish_docs_prose_rules.md` so rule 1 no longer recommends a colon as the em-dash replacement, and add the semicolon, colon, overused-word, and app-name rules with a pointer to the lint rule files. Add a line to `MEMORY.md` if the description changes.

### Task 6.5: Results report and merge

**Files:**
- Modify: `docs/user-manual/reviews/fidelity-2026-09/RESULTS.md`

- [ ] **Step 1: Fill RESULTS.md** from `DRIFT.md`, the per-chapter `fidelity.md` files (false rows become "Factual corrections"; features under Missing that now have chapters become "Features the old manual omitted"; unverifiable rows become their table), `SHOTS.md`, and the app defects noted during the audit. Write the Summary last: chapters rewritten, corrections count, new chapters, deleted chapters, shots captured, and the three largest fixes in one sentence each.

- [ ] **Step 2: Commit and hand off**

```bash
git add docs/user-manual/reviews/fidelity-2026-09/RESULTS.md
git commit -m "Close the 2026-09 manual fidelity campaign with the results report

Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>"
```

Then use `superpowers:finishing-a-development-branch`: present the branch to the user, and on approval fast-forward `main` from the primary checkout, push, confirm the Read the Docs build at https://lungfish-genome-explorer.readthedocs.io/en/latest/ succeeds, and remove the worktree.

---

## Self-review notes

- Spec coverage: Stage 1 (reality maps 2.2, registry 2.3 and 2.4, fixtures 3.1 to 3.6), Stage 2 (rules 1.1 to 1.5, STYLE 1.7, agents 1.8, memory 6.4), Stage 3 (template 1.7, pipeline 4.N, reader team 4.N step 3, model policy in Global Constraints), Stage 4 (demo project 3.7, capture 5.1 and 5.2), Stage 5 (6.1 to 6.5). Open item 3 (animal identifiers) is carried in Task 3.5 README and must be answered before genotyping shots in Task 5.2.
- The roster is deliberately produced by Task 2.5, not hard-coded here, because the reality maps decide which chapters split, merge, or are added. Phase 4 iterates the roster.
- `tree infer iqtree` flags and the `import nvd` layout are the two CLI details this plan could not confirm from the help text captured on 2026-09-06; Tasks 3.3 and 3.5 verify them before use.
