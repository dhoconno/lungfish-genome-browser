# Conda Plugin System — Experimental Findings (2026-03-22)

## Micromamba Binary
- **Source**: `https://github.com/mamba-org/micromamba-releases/releases/latest/download/micromamba-osx-arm64`
- **Version**: 2.5.0
- **Size**: 14 MB standalone binary
- **Architecture**: Mach-O 64-bit arm64
- **Dependencies**: None (statically linked)
- **Verified**: Works on macOS 26 arm64

## Storage Location
- Tested: `~/Library/Application Support/Lungfish/conda/`
- Works correctly with `MAMBA_ROOT_PREFIX` env var
- **CRITICAL**: Path contains spaces ("Application Support") which breaks some tools
- **FIX NEEDED**: Create symlink at `~/.lungfish/conda` → actual path, or change root prefix

## Environment Tests

### samtools (C binary, native macOS arm64)
- **Install**: `micromamba create -n test-env -c bioconda -c conda-forge samtools --yes`
- **Version**: samtools 1.23.1 / htslib 1.23.1
- **Size**: 20 MB (41.6 MB with deps)
- **Status**: WORKS perfectly via CLI

### pbaa (PacBio tool)
- **Install**: Succeeded but binary is Linux x86-64 ELF
- **Architecture**: `ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux)`
- **Status**: CANNOT execute natively on macOS arm64
- **All builds**: `noarch` on bioconda — contains Linux binary
- **Resolution**: Must use Apple Container runtime with Rosetta for Linux-only tools

### freyja (Python-based, native macOS arm64)
- **Install**: `micromamba create -n freyja-env -c bioconda -c conda-forge freyja --yes`
- **Version**: freyja 2.0.3
- **Size**: 1.3 GB (Python + numpy + scipy + samtools + usher + etc.)
- **Status**: WORKS perfectly, native arm64

### Freyja Pipeline Test (paired Illumina FASTQs)
- **Alignment**: minimap2 -a -x sr → 3,654 sequences mapped in 13.5 seconds ✅
- **Sorting**: samtools sort + index → BAM created ✅
- **Variants**: freyja variants → FAILED due to spaces in path ❌
  - `samtools mpileup -f` breaks on paths with spaces in "Application Support"
  - **FIX**: Use `~/.lungfish/conda` symlink or `TMPDIR`-based working directory

## Key Architectural Findings

### 1. Per-tool environments are necessary
- Freyja (1.3 GB) vs samtools (20 MB) — wildly different sizes
- Dependency conflicts between Python-heavy and C-only tools
- `micromamba run -n <env> <tool>` cleanly isolates execution

### 2. Linux-only tools need container fallback
- Some bioconda packages only have Linux builds (pbaa, some legacy tools)
- App already has AppleContainerRuntime with Rosetta for amd64
- Architecture: try native conda first → fall back to container if Linux-only

### 3. Spaces in paths are a problem
- `~/Library/Application Support/` contains a space
- Many bioinformatics tools (especially those using shell pipes internally) break
- **Solution**: Use `~/.lungfish/conda` as the root prefix (no spaces)
- Alternative: Create symlink from no-space path to Application Support

### 4. Micromamba invocation pattern
```
MAMBA_ROOT_PREFIX=~/.lungfish/conda \
  micromamba run -n <env-name> <tool> [args...]
```

### 5. Channel priority
Always specify: `-c bioconda -c conda-forge`
bioconda requires conda-forge as a dependency channel.
