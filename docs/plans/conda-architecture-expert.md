# Conda Plugin System — Swift Architecture Expert Plan

## Key Recommendations (vs current implementation)

### Already Implemented ✅
- CondaManager as actor in LungfishWorkflow/Conda/
- Per-tool environments
- CLI with 8 subcommands
- Nextflow conda profile integration
- PluginPack model with built-in packs
- Plugin Manager UI (SwiftUI window)

### Differences from Expert Recommendations
1. **Root prefix**: Expert suggested `~/Library/Application Support/`. We used `~/.lungfish/conda` because spaces in path break bioinformatics tools. This is the correct choice.
2. **CondaToolProvider**: Expert recommends a separate actor bridging CondaManager to NativeToolRunner. Not yet implemented — good future addition.
3. **Separate model files**: Expert recommends CondaPackage.swift, CondaEnvironment.swift, CondaError.swift as separate files. Currently all in CondaManager.swift. Can refactor later.
4. **PluginPackRegistry with JSON manifest**: Expert recommends bundled JSON. Currently hardcoded in PluginPack.builtIn. Can externalize later.
5. **Snakemake integration**: Not yet implemented (--use-conda, --conda-frontend micromamba).

### Future Work (from expert)
- CondaToolProvider actor for two-tier tool resolution (bundled → conda)
- WorkflowExecutionProfile enum (conda/docker/apple/local)
- Rosetta-mode environments for x86_64-only packages
- Plugin pack JSON manifest in Resources/Conda/
- Comprehensive integration tests with temp directories
