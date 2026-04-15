import { test } from "node:test";
import assert from "node:assert/strict";
import sharp from "sharp";
import { mkdir } from "node:fs/promises";
import { resolve } from "node:path";
import { tmpdir } from "node:os";
import { phashDistance } from "../phash-diff.mjs";

const t = resolve(tmpdir(), "lf-phash");

test("identical images have distance 0", async () => {
  const a = resolve(t, "a.png");
  await mkdir(t, { recursive: true });
  await sharp({ create: { width: 64, height: 64, channels: 3, background: "#FAF4EA" } }).png().toFile(a);
  const d = await phashDistance(a, a);
  assert.equal(d, 0);
});

test("obviously-different images have distance > 10", async () => {
  const a = resolve(t, "a.png");
  const b = resolve(t, "b.png");
  await mkdir(t, { recursive: true });
  await sharp({ create: { width: 64, height: 64, channels: 3, background: "#FAF4EA" } }).png().toFile(a);
  await sharp({ create: { width: 64, height: 64, channels: 3, background: "#1F1A17" } }).png().toFile(b);
  const d = await phashDistance(a, b);
  assert.ok(d > 10, `expected > 10, got ${d}`);
});
