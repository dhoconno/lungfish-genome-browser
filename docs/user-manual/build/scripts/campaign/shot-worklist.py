#!/usr/bin/env python3
"""Emit a per-part capture worklist from reviews/fidelity-2026-09/SHOTS.md.

    shot-worklist.py <part-dir> [<out-file>]

Prints (or writes) one block per open row (status new or stale) in that
part: id, chapter file, line, caption, fixture, app state, prerequisites.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
part = sys.argv[1]
out = Path(sys.argv[2]) if len(sys.argv) > 2 else None
rows = []
for line in (ROOT / "reviews" / "fidelity-2026-09" / "SHOTS.md").read_text().splitlines():
    if not line.startswith(f"| {part} |"):
        continue
    cells = [c.strip() for c in line.strip().strip("|").split(" | ")]
    if len(cells) < 9:
        continue
    _, chapter, ln, sid, caption, status, fixture, state, prereq = cells[:9]
    if status not in ("new", "stale"):
        continue
    rows.append((chapter, ln, sid.strip("`"), caption, fixture, state, prereq, status))
text = [f"# Capture worklist for {part}: {len(rows)} open shots\n"]
for chapter, ln, sid, caption, fixture, state, prereq, status in rows:
    text.append(f"## {sid}\n- chapter: {chapter} (line {ln}), status {status}\n- caption: {caption}\n- fixture: {fixture}\n- state: {state}\n- prerequisites: {prereq}\n")
body = "\n".join(text)
if out:
    out.write_text(body)
    print(out, len(rows))
else:
    print(body)
