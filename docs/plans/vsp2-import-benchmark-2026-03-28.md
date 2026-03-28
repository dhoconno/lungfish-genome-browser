# VSP2 FASTQ Import Benchmark (2026-03-28)

## Goal
Benchmark and optimize the VSP2 FASTQ import workflow with focus on:
- user-visible ETA/progress behavior,
- operation ordering,
- interleave timing,
- integrating FASTQ stats into import completion.

## Inputs
Paired FASTQ test dataset:
- `/Volumes/nvd_remote/M010624/20260306_LH00283_0308_B23GW53LT3/School005-20260202_S41_L006_R1_001.fastq.gz`
- `/Volumes/nvd_remote/M010624/20260306_LH00283_0308_B23GW53LT3/School005-20260202_S41_L006_R2_001.fastq.gz`

Subset dataset used for ordering/interleave matrix:
- `/tmp/lungfish-vsp2-bench/subset/R1.sub.fastq.gz`
- `/tmp/lungfish-vsp2-bench/subset/R2.sub.fastq.gz`

## Benchmark Harness
Script:
- `/tmp/lungfish-vsp2-bench/run_vsp2_bench.sh`

Outputs:
- Step timings TSV: `/tmp/lungfish-vsp2-bench/results/steps.tsv`
- Run summary TSV: `/tmp/lungfish-vsp2-bench/results/summary.tsv`
- Per-step logs: `/tmp/lungfish-vsp2-bench/logs/...`

Variants benchmarked:
- `legacy_old`: old behavior approximation (pre-clumpify + old step order + per-step count scans).
- `optimized_new`: interleave-first, new order, no per-step count scans.
- `delayed_interleave`: paired-file prefix steps before interleave (dedup/adapter/quality on R1/R2 directly).

## Results

### 1) Subset Matrix (measured)
| Variant | Total (s) | Throughput (MiB/s) |
|---|---:|---:|
| `legacy_old` | 61.66 | 3.613 |
| `optimized_new` | 37.23 | 5.983 |
| `delayed_interleave` | 34.46 | 6.464 |

Key subset findings:
- `human_scrub` is the dominant step in all variants.
- Legacy per-step read-count scans (`count_*`) add **17.44s** overhead on subset alone.
- Delaying interleave (paired prefix processing) is faster than interleave-first on subset.

### 2) Full Dataset (measured)
Measured full-run totals:

| Variant | Total (s) | Total (min) | Throughput (MiB/s) |
|---|---:|---:|---:|
| `optimized_new` | 1763.23 | 29.39 | 6.367 |
| `delayed_interleave` | 1681.15 | 28.02 | 6.678 |

Measured full savings:
- `delayed_interleave` vs `optimized_new`: **82.08s** faster (**1.37 min**, ~4.7%).

Per-step wall times (`full`, `optimized_new`):
- `interleave`: 312.35s
- `dedup`: 189.45s
- `adapter_trim`: 103.16s
- `quality_trim`: 89.42s
- `human_scrub`: 504.81s
- `merge`: 230.11s
- `length_filter`: 12.35s
- `final_clumpify`: 38.60s
- `stats_seqkit`: 143.38s
- `stats_length_scan`: 139.60s

Per-step wall times (`full`, `delayed_interleave`):
- `dedup_pair`: 426.02s
- `adapter_pair`: 76.13s
- `quality_pair`: 51.62s
- `interleave`: 33.43s
- `human_scrub`: 526.10s
- `merge`: 231.82s
- `length_filter`: 13.01s
- `final_clumpify`: 40.41s
- `stats_seqkit`: 142.96s
- `stats_length_scan`: 139.65s

Main bottleneck share on full run:
- `human_scrub`: 28.6%
- `interleave` (up-front): 17.7%
- `merge`: 13.1%
- post-import stats (`stats_seqkit` + `stats_length_scan`): 16.0%

### 3) Full Legacy Notes
`legacy_old` full run was started to validate baseline scaling; it was intentionally stopped after initial high-cost phases to avoid spending additional >1 hour of wall-clock on repeated full passes.

Measured full legacy step:
- `preclumpify`: **428.78s**

Completed full runs (`optimized_new`, `delayed_interleave`) plus the complete subset matrix were used to estimate full legacy total:
- Subset ratio `legacy_old / optimized_new` = **1.6562**

Projected full totals from measured full `optimized_new` (1763.23s):
- Projected `legacy_old`: **2920.25s (48.67 min)**

Measured + projected savings:
- Measured `delayed_interleave` vs `optimized_new`: **82.08s (~1.37 min)**
- Projected `optimized_new` vs `legacy_old`: **1157.02s (~19.28 min)**
- Projected `delayed_interleave` vs `legacy_old`: **1239.10s (~20.65 min)**

## Conclusions
1. Human scrub is the primary bottleneck and dominates total runtime after early filtering.
2. Removing per-step read-count rescans is a high-impact optimization.
3. Delaying interleave is consistently faster on subset and is also faster on full data (measured).
4. Stats must remain part of import completion to avoid deferred wait in first-open UX.

## Multi-Sample Orchestration Evaluation (Nextflow vs In-App)

### Expert-grounded constraints
- Nextflow local executor runs tasks on the local machine and supports controlling process concurrency via `maxForks` and queue behavior (`queueSize`) in configuration.
- Nextflow process-level `cpus`, `memory`, and retry semantics are strong for batch reproducibility and resumable execution.
- For GUI-driven import UX, we need per-sample operation lifecycle integration (cancel buttons, inline progress, import visibility gating, and immediate provenance serialization).

References:
- Nextflow executors and local executor semantics: [Nextflow docs](https://www.nextflow.io/docs/latest/executor.html)
- Nextflow process directives (`cpus`, `maxForks`): [Nextflow process reference](https://www.nextflow.io/docs/latest/reference/process.html)
- Nextflow config (`queueSize`, resource defaults): [Nextflow config reference](https://www.nextflow.io/docs/latest/reference/config.html)

### Pros/cons

Current in-app orchestrator:
- Pros: direct integration with Operations Panel, cancellation hooks, and bundle/metadata lifecycle; lower startup overhead for single-sample and small batches.
- Pros: easiest path for tightly coupled app state changes (processing marker, sidebar visibility, inspector metadata).
- Cons: currently needs explicit global resource scheduling to avoid oversubscription when many imports are started at once.

Nextflow local executor:
- Pros: robust DAG scheduling primitives, built-in retry/caching/resume model, good for large unattended batch runs.
- Pros: explicit process-level resource declarations improve repeatability across environments.
- Cons: higher integration complexity for real-time GUI operation state and per-step app-native provenance UX.
- Cons: without careful config (`maxForks`, `queueSize`), local runs can still overcommit host resources.

### Recommendation
1. Keep the in-app orchestrator as the default ingestion backend.
2. Add a bounded multi-import scheduler in-app (global queue + per-import CPU budget) as the immediate optimization.
3. Add an optional Nextflow backend in a later phase for headless/high-volume batch mode, while preserving OperationCenter parity through an adapter layer.

## Compression/Decompression + Threading Audit

### Verified in current code
- Ingestion clumpify path enables parallel gzip output (`pigz=t`) and passes thread count.
- Standalone compression uses `bgzip -@ <threads>` when available, otherwise `pigz -p <threads>`.
- Human scrub path decompresses gzipped inputs with pigz and passes explicit thread count to `scrub.sh` (`-p`).
- `fastp` and `seqkit` paths are thread-aware where applicable (`-w`, `-j`).

Reference:
- pigz as parallel gzip implementation: [gzip.org pigz link](https://gzip.org/)

### Remaining opportunities
- Replace fixed single-slot queueing with adaptive multi-slot scheduling (e.g., 1-3 concurrent imports based on CPU+I/O pressure).
- Cap heavy steps (especially human scrub + merge + clumpify) under multi-import load to reduce cross-job slowdown.
- Emit queue state and allocated CPU budget into OperationCenter detail/manifest for auditability.

## Implementation Status (in code)
Implemented changes include:
- Integrated FASTQ stats into import completion path.
- Added shared `FASTQStatisticsService` and reused it in viewport load path.
- Hid processing bundles in sidebar until import+stats finalize.
- Added Operations Panel ETA column.
- Added import slot coordination so heavy ingestion jobs queue instead of competing concurrently.
- Reordered VSP2 recipe steps to reduce scrub workload.
- Added delayed-interleave VSP2 execution path in ingestion service.
- Removed mandatory per-step read-count rescans in materialized recipe runs for ingestion hot path.
- Switched merge concatenation to streaming in `FASTQDerivativeService` to avoid loading whole files into memory.
