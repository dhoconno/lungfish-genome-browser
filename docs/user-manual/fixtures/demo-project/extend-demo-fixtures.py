#!/usr/bin/env python3
"""Add fixture bundles without rebuilding the live demo or changing its project DB.
Each command retains native CLI provenance and an additional execution audit.
"""
import argparse, datetime, hashlib, json, os, pathlib, platform, shlex, subprocess, sys, time
HERE = pathlib.Path(__file__).resolve().parent
REPO = HERE.parents[3]
FX = HERE.parent
CLI = pathlib.Path(os.environ.get('LUNGFISH_CLI', REPO / '.build/debug/lungfish-cli'))
ROOT = pathlib.Path(os.environ.get('LUNGFISH_DEMO_ROOT', pathlib.Path.home() / 'Desktop/lge-docs')).resolve()
P = ROOT / 'LGE Manual Demo.lungfish'
AUDIT = ROOT / 'LGE Manual Demo.build/fixture-provenance'

def files(paths):
    records = []
    for raw in paths:
        p = pathlib.Path(raw)
        for f in sorted(p.rglob('*')) if p.is_dir() else [p]:
            if f.is_file() and f.name != 'fixture-execution.json':
                h = hashlib.sha256()
                with f.open('rb') as stream:
                    for chunk in iter(lambda: stream.read(1024 * 1024), b''): h.update(chunk)
                records.append(dict(path=str(f.resolve()), size_bytes=f.stat().st_size, sha256=h.hexdigest()))
    return records

def verify_native_provenance(output, workflow):
    """Verify existing native records without rewriting scientific data or provenance."""
    output = pathlib.Path(output).resolve()
    pending = [output / '.lungfish-provenance.json']
    visited, checked = set(), set()
    while pending:
        sidecar = pending.pop()
        if sidecar in visited: continue
        visited.add(sidecar)
        envelope = json.loads(sidecar.read_text())
        for key in ('workflowName', 'workflowVersion', 'toolName', 'toolVersion', 'argv', 'reproducibleCommand', 'runtimeIdentity', 'options', 'files'):
            if not envelope.get(key): raise ValueError(f'{sidecar}: missing {key}')
        if envelope['workflowName'] != workflow: raise ValueError(f'{sidecar}: unexpected workflow')
        if envelope.get('exitStatus') != 0: raise ValueError(f'{sidecar}: unsuccessful execution')
        if not isinstance(envelope.get('wallTimeSeconds'), (int, float)) or envelope['wallTimeSeconds'] < 0:
            raise ValueError(f'{sidecar}: missing wall time')
        for key in ('appVersion', 'architecture', 'operatingSystemVersion'):
            if not envelope['runtimeIdentity'].get(key): raise ValueError(f'{sidecar}: missing runtime {key}')
        for key in ('explicit', 'defaults', 'resolvedDefaults'):
            if key not in envelope['options']: raise ValueError(f'{sidecar}: missing options {key}')
        roles = {file['role'] for file in envelope['files']}
        if not {'input', 'output'}.issubset(roles): raise ValueError(f'{sidecar}: missing input/output descriptors')
        if envelope['toolName'] == 'flye' and not envelope['runtimeIdentity'].get('condaEnvironment'):
            raise ValueError(f'{sidecar}: missing managed Flye environment')
        for descriptor in envelope['files']:
            path = pathlib.Path(descriptor['path'])
            if not path.is_absolute(): path = sidecar.parent / path
            path = path.resolve()
            if not path.exists(): raise ValueError(f'{sidecar}: missing recorded path {path}')
            if descriptor['role'] in ('output', 'report', 'log') and not path.is_relative_to(output):
                raise ValueError(f'{sidecar}: output points outside final fixture {path}')
            if path.is_dir():
                source = descriptor.get('sourceProvenancePath')
                if not source: raise ValueError(f'{sidecar}: directory has no native child provenance')
                child = pathlib.Path(source)
                if not child.is_absolute(): child = sidecar.parent / child
                child = child.resolve()
                if not child.is_relative_to(path): raise ValueError(f'{sidecar}: child provenance points outside its bundle')
                pending.append(child)
                continue
            expected_hash = descriptor.get('checksumSHA256') or descriptor.get('sha256')
            expected_size = descriptor.get('fileSize', descriptor.get('sizeBytes'))
            if not expected_hash or expected_size is None: raise ValueError(f'{sidecar}: missing file identity for {path}')
            record = files([path])[0]
            if record['sha256'] != expected_hash or record['size_bytes'] != expected_size:
                raise ValueError(f'{sidecar}: recorded file identity differs for {path}')
            checked.add(path)
    print(f'Native provenance verified: {len(visited)} sidecars, {len(checked)} recorded files in {output}', flush=True)


def run(name, args, inputs, output, defaults, native_workflow=None):
    output = pathlib.Path(output)
    if native_workflow and output.exists():
        # Native GUI/CLI outputs may predate this helper's additional execution audit.
        # Keep their original identity and refuse to rerun over incomplete outputs.
        verify_native_provenance(output, native_workflow)
        print('Already complete:', output, flush=True)
        return
    audit = AUDIT / name
    audit.mkdir(parents=True, exist_ok=True)
    if output.exists() and (audit / 'execution.json').exists():
        prior = json.loads((audit / 'execution.json').read_text())
        if prior['exit_status'] == 0:
            print('Already complete:', output, flush=True)
            return
    command = [str(CLI), *map(str, args)]
    input_records = files(inputs)
    started = datetime.datetime.now(datetime.timezone.utc).isoformat()
    start = time.monotonic()
    with (audit / 'stdout.log').open('w') as stdout, (audit / 'stderr.log').open('w') as stderr:
        result = subprocess.run(command, stdout=stdout, stderr=stderr)
    record = dict(workflow=name, tool='lungfish-cli', tool_version=subprocess.check_output([str(CLI), '--version'], text=True).strip(), argv=command, shell_command=shlex.join(command), cwd=os.getcwd(), options_and_resolved_defaults=defaults, runtime=dict(os=platform.platform(), architecture=platform.machine(), executable=files([CLI])[0], conda_root=str(pathlib.Path.home()/'.lungfish/conda'), note='Native CLI provenance records per-tool managed environments when used'), inputs=input_records, outputs=files([output]), started_at=started, wall_time_seconds=time.monotonic()-start, exit_status=result.returncode, stdout=str(audit/'stdout.log'), stderr=(audit/'stderr.log').read_text())
    (audit / 'execution.json').write_text(json.dumps(record, indent=2)+'\n')
    if result.returncode == 0 and not output.exists(): raise RuntimeError('Expected output missing: '+str(output))
    if result.returncode == 0 and native_workflow: verify_native_provenance(output, native_workflow)
    if output.is_dir(): (output / 'fixture-execution.json').write_text(json.dumps(record, indent=2)+'\n')
    print(name, 'exit', result.returncode, 'output', output, flush=True)
    print((audit/'stdout.log').read_text()[-2500:], flush=True)
    if result.returncode: raise SystemExit(result.returncode)

parser = argparse.ArgumentParser()
parser.add_argument('--project', type=pathlib.Path, help='Existing .lungfish project to populate; defaults to LGE Manual Demo under LUNGFISH_DEMO_ROOT')
parser.add_argument('steps', nargs='*', default=['ont', 'hifi', 'barcode', 'amplicon', 'nao', 'czid', '12s', 'benchmark'])
options = parser.parse_args()
if options.project is not None:
    P = options.project.expanduser().resolve()
    ROOT = P.parent
    AUDIT = P.with_suffix('.build')/'fixture-provenance'
if not (P/'.project.db').exists(): raise SystemExit('Create the demo project in the app first')
common = dict(format='text', verbose=0, quiet=False, debug=False, progress='auto', threads='auto')
for name, source, sample, sequencing in [('ont', FX/'hg002-long-reads/HG002.chrM.ont.fastq.gz', 'HG002.chrM.ont', 'ont'), ('hifi', FX/'hg002-long-reads/HG002.chrM.hifi.fastq.gz', 'HG002.chrM.hifi', 'pacbio'), ('barcode', FX/'hg002-long-reads/ont-run/fastq_pass/barcode01/HG002_chrM_pass_barcode01_0.fastq.gz', 'HG002_chrM_pass_barcode01_0', 'ont'), ('amplicon', FX/'primate-12s/HG002-12S-amplicon.fastq.gz', 'HG002-12S-amplicon', 'illumina')]:
    if name not in options.steps: continue
    run(name, ['import-fastq', source, '--project', P, '--platform', sequencing, '--recipe', 'none', '--quality-binning', 'none', '--compression', 'balanced', '--no-optimize-storage'], [source], P/'Imports'/(sample+'.lungfishfastq'), dict(common, platform=sequencing, recipe='none', quality_binning='none', compression='balanced', optimize_storage=False, pairing='single-end'))
# Human ONT/Flye additions are explicit steps so they can be verified independently.
# Example: python3 extend-demo-fixtures.py ont-run flye
if 'ont-run' in options.steps:
    source = FX/'hg002-long-reads/ont-run/fastq_pass'
    run('ont-run', ['fastq', 'import-ont', source, '--output', P/'ont-run'], [source], P/'ont-run', dict(common, concurrency=4, include_unclassified=False, optimize_storage=False, quality_binning='none', storage_mode='chunked', use_virtual_concatenation=True, processing_recipe=None), native_workflow='lungfish fastq import-ont')
if 'flye' in options.steps:
    source = FX/'hg002-long-reads/HG002.chrM.ont.fastq.gz'
    output = P/'Analyses/HG002-chrM-flye'
    run('flye', ['assemble', '--assembler', 'flye', '--read-type', 'ont-reads', '--name', 'HG002-chrM-flye', '--threads', '4', '-o', output, source], [source], output, dict(common, assembler='flye', read_type='ont-reads', name='HG002-chrM-flye', threads=4, profile='default', paired_end=False, memory_gb=None, min_contig_length=None, extra_arguments=[]), native_workflow='lungfish.assemble')
if 'nao' in options.steps:
    source = REPO/'Tests/Fixtures/naomgs/virus_hits_final.tsv.gz'
    run('nao', ['import', 'nao-mgs', source, '--sample-name', 'nao-mgs-demo', '-o', P/'Analyses', '--no-fetch-references'], [source], P/'Analyses/naomgs-nao-mgs-demo', dict(common, fetch_references=False, sample_name='nao-mgs-demo'))
if 'czid' in options.steps:
    source = REPO/'Tests/Fixtures/czid/minimal_taxon_report.tsv'
    run('czid', ['import', 'cz-id', source, '--project', P, '--sample-name', 'czid-demo'], [source], P/'Classifications/czid-demo.lungfishtax', dict(common, sample_name='czid-demo', metadata=None, non_host_fastq=None))
if '12s' in options.steps:
    source, ref, metadata = [FX/'primate-12s'/f for f in ['HG002-12S-oriented.fastq', 'primate-12s-dedup.fasta', 'primate-12s-targets.tsv']]
    run('12s', ['fastq', '12s-match', source, '--reference', ref, '--reference-metadata', metadata, '--output-dir', P/'Analyses', '--output-name', 'HG002-12S', '--min-soft-clip', '1', '--max-indels', '3', '--matching-mode', 'illumina-exact', '--ambiguity-resolution', 'strict', '--chimera-review'], [source, ref, metadata], P/'Analyses/HG002-12S.lungfish12s', dict(common, min_soft_clip=1, max_indels=3, matching_mode='illumina-exact', ambiguity_resolution='strict', chimera_review=True, sample_metadata=None, force=False))
if 'benchmark' in options.steps:
    source = FX/'hg002-chr20/HG002.chr20.10.0-10.5Mb.benchmark.vcf.gz'
    run('benchmark', ['import', 'vcf', source, '-o', P], [source, str(source)+'.tbi'], P/source.name, common)
if 'sra' in options.steps:
    output = ROOT/'LGE Manual Demo.build/_scratch/SRR32909537'
    run('sra', ['fetch', 'sra', 'download', 'SRR32909537', '--output-dir', output], [], output, dict(common, accession='SRR32909537', use_toolkit=False, download_source='ENA default'))
if 'sra-import' in options.steps:
    source = ROOT/'LGE Manual Demo.build/_scratch/SRR32909537'
    pair = [source/'SRR32909537_1.fastq.gz', source/'SRR32909537_2.fastq.gz']
    run('sra-import', ['import-fastq', *pair, '--project', P, '--platform', 'illumina', '--recipe', 'none', '--quality-binning', 'none', '--compression', 'balanced', '--no-optimize-storage'], pair + [source/'fixture-execution.json'], P/'Imports/SRR32909537.lungfishfastq', dict(common, platform='illumina', recipe='none', quality_binning='none', compression='balanced', optimize_storage=False, pairing='paired-end'))
    # Preserve the upstream download audit with final imported payload identities.
    # Native import provenance already identifies the final interleaved FASTQ.
    bundle = P/'Imports/SRR32909537.lungfishfastq'
    receipt = json.loads((source/'fixture-execution.json').read_text())
    receipt['adopted_bundle'] = str(bundle)
    receipt['adopted_payloads'] = files(list(bundle.glob('*.fastq.gz')))
    (bundle/'provenance/source-sra-download.json').write_text(json.dumps(receipt, indent=2)+'\n')
if 'mhc-simulated' in options.steps:
    source = FX/'mhc-simulated'
    subprocess.run(['python3', str(source/'generate.py')], check=True)
    samples = ['SIMULATED-MHC-A', 'SIMULATED-MHC-B']
    bundles = []
    for sample in samples:
        pair = [source/f'{sample}-pairs.fastq']
        bundle = P/'Imports'/f'{sample}-pairs.lungfishfastq'
        run(sample+'-pairs', ['import-fastq', *pair, '--project', P, '--platform', 'illumina', '--recipe', 'none', '--quality-binning', 'none', '--compression', 'balanced', '--no-optimize-storage', '--threads', '2'], pair + [source/'fixture-generation-provenance.json'], bundle, dict(common, threads=2, platform='illumina', recipe='none', quality_binning='none', compression='balanced', optimize_storage=False, pairing='paired-end'))
        bundles.append(bundle)
    output = P/'Analyses/SIMULATED-MHC-native-teaching'
    run('mhc-simulated-native-genotype', ['fastq', 'genotype-cohort', *bundles, '--reference', source/'SIMULATED-MHC-reference.fasta', '--mode', 'illumina-paired', '--read-type', 'illumina', '--output-dir', output, '--output-name', 'SIMULATED-MHC-native-teaching', '--analysis-name', 'SIMULATED MHC teaching reads', '--keep-intermediates', '--threads', '2', '--sort-threads', '2'], bundles + [source/'SIMULATED-MHC-reference.fasta', source/'fixture-generation-provenance.json'], output, dict(common, threads=2, sort_threads=2, mode='illumina-paired', read_type='illumina', min_support=1, haplotyping='none', extra_args=None, keep_intermediates=True))
    # Keep explicit simulation provenance beside each imported/result bundle.
    # This supplements the native records without changing their scientific history.
    for destination in [*bundles, output]:
        target = destination/'teaching-source'
        target.mkdir(exist_ok=True)
        for filename in ['fixture-generation-provenance.json', 'simulation-truth.json']:
            data = (source/filename).read_bytes()
            path = target/filename
            if path.exists() and path.read_bytes() != data:
                raise ValueError(f'Existing teaching provenance differs: {path}')
            if not path.exists(): path.write_bytes(data)
    # Native provenance records managed package versions for minimap2, samtools,
    # pysam and openpyxl; preserve the actual BBMerge package identity too.
    target = output/'teaching-source/bbmerge-runtime.json'
    if not target.exists():
        packages = pathlib.Path.home()/'.lungfish/conda/envs/bbtools/conda-meta'
        identities = [dict(package=json.loads(p.read_text()), **files([p])[0]) for p in sorted(packages.glob('*.json')) if p.name.startswith(('bbmap-', 'openjdk-'))]
        if not identities: raise ValueError('Missing BBMerge managed runtime identity')
        target.write_text(json.dumps(identities, indent=2)+'\n')
    subprocess.run(['python3', str(source/'validate.py'), str(output)], check=True)

if 'mhc-simulated' in options.steps or 'mhc-gui-reference' in options.steps:
    source = FX/'mhc-simulated'
    subprocess.run(['python3', str(source/'generate.py')], check=True)
    subprocess.run(['python3', str(source/'prepare-gui-reference.py')], check=True)
    reference = P/'Reference Sequences/SIMULATED-MHC-annotated-reference.lungfishref'
    run('mhc-simulated-annotated-reference', ['import', 'fasta', source/'SIMULATED-MHC-annotated-reference.gb', '--name', 'SIMULATED-MHC-annotated-reference', '-o', P], [source/'SIMULATED-MHC-annotated-reference.gb', source/'gui-reference-provenance.json'], reference, dict(common, name='SIMULATED-MHC-annotated-reference'), native_workflow='lungfish import fasta')
    bundles = [P/'Imports'/f'SIMULATED-MHC-{sample}-pairs.lungfishfastq' for sample in ['A', 'B']]
    output = P/'Analyses/SIMULATED-MHC-bundle-validated'
    run('mhc-simulated-bundle-genotype', ['fastq', 'genotype-cohort', *bundles, '--reference', reference, '--mode', 'illumina-paired', '--read-type', 'illumina', '--output-dir', output, '--output-name', 'SIMULATED-MHC-bundle-validated', '--analysis-name', 'SIMULATED-MHC-bundle-teaching', '--keep-intermediates', '--threads', '2', '--sort-threads', '2'], bundles + [reference, source/'gui-reference-provenance.json'], output, dict(common, threads=2, sort_threads=2, mode='illumina-paired', read_type='illumina', min_support=1, haplotyping='none', extra_args=None, keep_intermediates=True), native_workflow='Illumina Paired Amplicon Genotyping')
    for destination in [reference, output]:
        target = destination/'teaching-source'
        target.mkdir(exist_ok=True)
        for filename in ['fixture-generation-provenance.json', 'simulation-truth.json', 'gui-reference-provenance.json']:
            data = (source/filename).read_bytes()
            path = target/filename
            if path.exists() and path.read_bytes() != data:
                raise ValueError(f'Existing teaching provenance differs: {path}')
            if not path.exists(): path.write_bytes(data)
    runtime_target = output/'teaching-source/bbmerge-runtime.json'
    if not runtime_target.exists():
        packages = pathlib.Path.home()/'.lungfish/conda/envs/bbtools/conda-meta'
        identities = [dict(package=json.loads(p.read_text()), **files([p])[0]) for p in sorted(packages.glob('*.json')) if p.name.startswith(('bbmap-', 'openjdk-'))]
        if not identities: raise ValueError('Missing BBMerge managed runtime identity')
        runtime_target.write_text(json.dumps(identities, indent=2)+'\n')
    subprocess.run(['python3', str(source/'validate.py'), str(output)], check=True)

if 'hello-workflow' in options.steps:
    source = REPO/'Examples/WorkflowPackages/hello-world-nextflow.lungfishflowpkg'
    output = ROOT/source.name
    manifest = json.loads((source/'manifest.json').read_text())
    assert manifest['schemaVersion'] == 1 and manifest['id'].strip()
    assert manifest['runner']['kind'] == 'nextflow'
    assert manifest['runtime']['kind'] == 'none'
    assert manifest['inputs'] and all(i['bundleTypes'] for i in manifest['inputs'])
    assert all(any(i.get('required', True) and kind in i['bundleTypes'] for i in manifest['inputs']) for kind in ['lungfishref', 'lungfishfastq'])
    assert manifest['outputs']
    entrypoint = (source/manifest['runner']['entrypoint']).resolve()
    assert entrypoint.is_relative_to(source.resolve()) and entrypoint.is_file()
    output.mkdir(exist_ok=True)
    started = datetime.datetime.now(datetime.timezone.utc).isoformat()
    start = time.monotonic()
    source_files = sorted(p for p in source.rglob('*') if p.is_file())
    for src in source_files:
        destination = output/src.relative_to(source)
        data = src.read_bytes()
        if destination.exists() and destination.read_bytes() != data:
            raise ValueError(f'Existing linked workflow differs: {destination}')
        if not destination.exists():
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(data)
    audit = output/'fixture-copy-provenance.json'
    if not audit.exists():
        command = [str(CLI), 'workflow', 'validate', str(output/manifest['runner']['entrypoint'])]
        result = subprocess.run(command, capture_output=True, text=True)
        record = dict(schemaVersion=1, workflowName='copy-manual-hello-world-workflow', workflowVersion='1', toolName='extend-demo-fixtures.py', toolVersion='1', argv=[sys.executable, str(pathlib.Path(__file__).resolve()), 'hello-workflow'], reproducibleCommand=shlex.join([sys.executable, str(pathlib.Path(__file__).resolve()), 'hello-workflow']), options=dict(explicit=dict(step='hello-workflow'), defaults={}, resolvedDefaults=dict(source=str(source), output=str(output), workflowExecuted=False)), runtimeIdentity=dict(python=sys.version, executable=sys.executable, operatingSystemVersion=platform.platform(), architecture=platform.machine()), inputs=files(source_files), outputs=files([output/src.relative_to(source) for src in source_files]), startedAt=started, completedAt=datetime.datetime.now(datetime.timezone.utc).isoformat(), wallTimeSeconds=time.monotonic()-start, exitStatus=result.returncode, stderr=result.stderr, validation=dict(argv=command, stdout=result.stdout, stderr=result.stderr, exitStatus=result.returncode, toolVersion=subprocess.check_output([str(CLI), '--version'], text=True).strip()), sourceManifestVersion=manifest['version'])
        audit.write_text(json.dumps(record, indent=2)+'\n')
        if result.returncode: raise RuntimeError('Hello World workflow static validation failed')
    prior = json.loads(audit.read_text())
    assert prior['exitStatus'] == 0
    for f in prior['inputs'] + prior['outputs']:
        if files([f['path']])[0] != f: raise ValueError('Copied workflow provenance differs')
    print('Validated Hello World Nextflow package, required reference/FASTQ inputs, declared output, Runnable contract:', output)
