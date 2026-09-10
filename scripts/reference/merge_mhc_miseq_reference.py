#!/usr/bin/env python3
"""Stage an exact-sequence MHC reference union without changing diagnostic definitions.

Existing target IDs and primary headers are immutable. Raw records match complete
sequences in either orientation; novel raw sequences retain their supplied strand
and length. No trimming, near-match merging, allele-resolution inference, or new
haplotype diagnostics are performed. The output is staging data, not a bundle.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
import platform
from pathlib import Path
import re
import shlex
import shutil
import sys
import time
import traceback

VERSION = '1.0.0'
DEFAULT_ORDER = ['F', 'G', 'AG', 'A1', 'A2', 'A3', 'A4', 'A5', 'K', 'L', 'E', 'B', 'DRB', 'DQA', 'DQB', 'DPA', 'DPB']


def descriptor(path):
    data = path.read_bytes()
    return {'path': str(path.resolve()), 'sha256': hashlib.sha256(data).hexdigest(), 'size_bytes': len(data)}


def read_fasta(path):
    records = []
    for line in path.read_text().splitlines():
        if line.startswith('>'):
            records.append([line[1:], ''])
        elif line.strip():
            if not records:
                raise ValueError(f'{path}: sequence before header')
            records[-1][1] += line.strip().upper()
    ids = [header.split('|', 1)[0].split()[0] for header, _ in records]
    if len(ids) != len(set(ids)):
        raise ValueError(f'{path}: duplicate target IDs')
    if any(not sequence or set(sequence) - set('ACGT') for _, sequence in records):
        raise ValueError(f'{path}: empty or non-ACGT sequence; manual review required')
    return records


def metadata(header):
    return dict(field.split('=', 1) for field in header.split('|')[1:] if '=' in field)


def reverse_complement(sequence):
    return sequence.translate(str.maketrans('ACGT', 'TGCA'))[::-1]


def legacy_label_and_locus(header):
    first = header.split('|', 1)[0]
    label = re.sub(r'^\d+_', '', first)
    label = re.sub(r'^(?:M\d+)+_', '', label)
    match = re.match(r'^(F|G|AG\d*|A[1-6]|K|L|E|B(?:\d+(?:Ps|L)?)?|I|J|DRB\d*|DQA\d*|DQB\d*|DPA\d*|DPB\d*)_', label, re.IGNORECASE)
    if not match:
        return first, 'Unknown'
    return 'Mafa-' + label, 'MHC-' + match.group(1)


def locus_group(locus):
    locus = locus.removeprefix('MHC-').upper()
    for prefix in ['DRB', 'DQA', 'DQB', 'DPA', 'DPB', 'AG']:
        if locus.startswith(prefix):
            return prefix
    if re.fullmatch(r'B(?:\d+(?:PS|L)?)?', locus):
        return 'B'
    return locus


def natural_key(value):
    return tuple((1, int(part)) if part.isdigit() else (0, part) for part in re.split(r'(\d+)', value.casefold()))


def write_json(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def merge(args, output):
    source_paths = {role: Path(getattr(args, role + '_fasta')).resolve() for role in ['full', 'primary', 'raw']}
    full, primary, raw = [read_fasta(source_paths[role]) for role in ['full', 'primary', 'raw']]
    definition_path = Path(args.haplotype_definition).resolve()
    definition = json.loads(definition_path.read_bytes())
    records = {}
    sequence_to_id = {}
    for header, sequence in full:
        identifier = header.split('|', 1)[0].split()[0]
        if sequence in sequence_to_id or reverse_complement(sequence) in sequence_to_id:
            raise ValueError('Full reference has strand-equivalent duplicate IDs; manual review required to preserve diagnostics')
        sequence_to_id[sequence] = identifier
        records[identifier] = {'id': identifier, 'header': header, 'sequence': sequence, 'sources': [{'role': 'full', 'header': header, 'orientation': 'forward'}]}
    for header, sequence in primary:
        identifier = header.split('|', 1)[0].split()[0]
        if identifier not in records or records[identifier]['sequence'] != sequence:
            raise ValueError(f'Primary ID {identifier} is missing or differs in full reference')
        records[identifier]['header'] = header
        records[identifier]['sources'].append({'role': 'primary', 'header': header, 'orientation': 'forward'})
    diagnostics = {identifier for locus in definition['locusDefinitions'] for haplotype in locus['haplotypes'] for identifier in haplotype['diagnosticAlleles']}
    primary_ids = {header.split('|', 1)[0].split()[0] for header, _ in primary}
    if not diagnostics <= primary_ids:
        raise ValueError('Every preserved diagnostic ID must be present in primary reference')
    counts = {'full_targets': len(full), 'primary_targets': len(primary), 'raw_records': len(raw), 'raw_forward_matches': 0, 'raw_reverse_complement_matches': 0, 'new_targets': 0}
    for header, sequence in raw:
        identifier = sequence_to_id.get(sequence)
        orientation = 'forward'
        if identifier is None:
            identifier = sequence_to_id.get(reverse_complement(sequence))
            orientation = 'reverse-complement' if identifier else 'forward'
        if identifier:
            counts['raw_' + ('forward_matches' if orientation == 'forward' else 'reverse_complement_matches')] += 1
        else:
            counts['new_targets'] += 1
            identifier = f'MCM_MHC_MiSeq_supplement_{counts["new_targets"]:04d}'
            if identifier in records:
                raise ValueError(f'Supplement ID collision: {identifier}')
            label, locus = legacy_label_and_locus(header)
            if any(character in label for character in '|\r\n,'):
                raise ValueError(f'Unsafe metadata label: {label}')
            legacy_aliases = header.split('|')[1:]
            legacy_field = '|legacy_aliases=' + ';'.join(legacy_aliases) if legacy_aliases else ''
            merged_header = f'{identifier}|source_loci={locus}|alleles={label}{legacy_field}|length={len(sequence)}|naming_status=legacy_unresolved'
            records[identifier] = {'id': identifier, 'header': merged_header, 'sequence': sequence, 'sources': []}
            sequence_to_id[sequence] = identifier
        records[identifier]['sources'].append({'role': 'raw', 'header': header, 'orientation': orientation})
    order = args.locus_order or DEFAULT_ORDER
    def sort_key(record):
        fields = metadata(record['header'])
        loci = fields.get('source_loci', 'Unknown').split(',')
        groups = {locus_group(locus) for locus in loci}
        label = fields.get('alleles', record['id']).split(',')[0]
        allele_locus = re.match(r'^(?:Mafa-)?([A-Za-z][A-Za-z0-9]*)[_*]', label)
        display_group = locus_group(allele_locus.group(1)) if allele_locus else None
        rank = order.index(display_group) if display_group in order else min((order.index(group) for group in groups if group in order), default=len(order))
        unknown = all(group == 'UNKNOWN' for group in groups)
        return rank, unknown, natural_key(label), record['id']
    sorted_records = sorted(records.values(), key=sort_key)
    with (output/'reference.fasta').open('w') as handle:
        for record in sorted_records:
            handle.write('>' + record['header'] + '\n' + record['sequence'] + '\n')
    shutil.copyfile(definition_path, output/'haplotype-definition.json')
    sources_dir = output/'sources'
    sources_dir.mkdir()
    for role, path in source_paths.items():
        shutil.copyfile(path, sources_dir/(role + '.fasta'))
    shutil.copyfile(definition_path, sources_dir/'haplotype-definition.json')
    counts['output_targets'] = len(records)
    mapping = []
    for record in sorted_records:
        mapping.append({key: value for key, value in record.items() if key != 'sequence'} | {'length': len(record['sequence']), 'sequence_sha256': hashlib.sha256(record['sequence'].encode()).hexdigest()})
    write_json(output/'sequence-map.json', {'schema_version': 1, 'counts': counts, 'locus_order': order, 'unlisted_locus_policy': 'After every named locus; Unknown last', 'records': mapping})
    return counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for role in ['full', 'primary', 'raw']:
        parser.add_argument('--' + role + '-fasta', required=True)
    parser.add_argument('--haplotype-definition', required=True)
    parser.add_argument('--output-dir', required=True)
    parser.add_argument('--locus-order', action='append', help='Repeat once per group; default: ' + ','.join(DEFAULT_ORDER))
    args = parser.parse_args()
    output = Path(args.output_dir).resolve()
    if output.exists():
        print('Output directory already exists; refusing to overwrite: ' + str(output), file=sys.stderr)
        return 1
    output.mkdir(parents=True)
    start = time.monotonic()
    provenance = {'schema_version': 1, 'workflow': 'merge-mhc-miseq-reference', 'version': VERSION, 'started_at': datetime.now(timezone.utc).isoformat(), 'argv': [sys.executable, str(Path(__file__).resolve()), *sys.argv[1:]], 'options': vars(args) | {'locus_order': args.locus_order or DEFAULT_ORDER}, 'runtime': {'python': sys.version, 'executable': sys.executable, 'platform': platform.platform(), 'conda_prefix': os.environ.get('CONDA_PREFIX'), 'conda_environment': os.environ.get('CONDA_DEFAULT_ENV')}, 'inputs': [], 'outputs': [], 'exit_status': 1, 'stderr': ''}
    provenance['command'] = shlex.join(provenance['argv'])
    provenance['working_directory'] = str(Path.cwd())
    provenance['provenance_self_checksum_policy'] = 'provenance.json is excluded from its own output checksum list'
    try:
        provenance['inputs'] = [descriptor(Path(path)) for path in [args.full_fasta, args.primary_fasta, args.raw_fasta, args.haplotype_definition, __file__]]
        provenance['counts'] = merge(args, output)
        provenance['exit_status'] = 0
    except Exception:
        provenance['stderr'] = traceback.format_exc()
        print(provenance['stderr'], file=sys.stderr)
    provenance['wall_time_seconds'] = time.monotonic() - start
    provenance['outputs'] = [descriptor(path) for path in sorted(output.rglob('*')) if path.is_file()]
    write_json(output/'provenance.json', provenance)
    (output/'PROVENANCE.md').write_text('# Reference staging provenance\n\nWorkflow: merge-mhc-miseq-reference ' + VERSION + '\n\nCommand: `' + provenance['command'] + '`\n\nSee provenance.json for resolved options, runtime, input/output checksums and sizes, exit status, wall time, and stderr. sequence-map.json preserves source headers and strand mappings. No sequences were trimmed or inferred. Haplotype definition bytes were copied unchanged.\n')
    provenance['outputs'].append(descriptor(output/'PROVENANCE.md'))
    provenance['wall_time_seconds'] = time.monotonic() - start
    write_json(output/'provenance.json', provenance)
    if provenance['exit_status'] == 0:
        print(json.dumps(provenance['counts'], sort_keys=True))
    return provenance['exit_status']


if __name__ == '__main__':
    raise SystemExit(main())
