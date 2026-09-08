#!/usr/bin/env python3
"""Verify the simulated teaching result against native records and mixture truth."""
import csv, hashlib, json, pathlib, sys
HERE=pathlib.Path(__file__).resolve().parent

def verify_file(f):
    p=pathlib.Path(f['path'])
    assert p.is_file(), f'Missing native recorded file {p}'
    checksum=f.get('checksumSHA256',f.get('sha256'))
    size=f.get('fileSize',f.get('sizeBytes'))
    assert checksum and size is not None, f'Incomplete identity {p}'
    assert hashlib.sha256(p.read_bytes()).hexdigest()==checksum and p.stat().st_size==size, f'Changed {p}'

def main():
    output=pathlib.Path(sys.argv[1]).resolve()
    native=json.loads((output/'.lungfish-provenance.json').read_text())
    for key in ['workflowName','workflowVersion','toolName','toolVersion','argv','reproducibleCommand','runtimeIdentity','options']:
        assert native.get(key), key
    assert native['exitStatus']==0 and native['wallTimeSeconds']>=0
    for key in ['explicit','defaults','resolvedDefaults']: assert key in native['options']
    for f in native['files']: verify_file(f)
    for step in native['steps']:
        assert step['argv'] and step['exitStatus']==0 and step['wallTimeSeconds']>=0
    managed=json.loads((output/'retained-demux-genotyping-provenance.json').read_text())
    for tool in managed['managedTools']:
        assert tool['version']!='unknown' and tool['packageSpec'] and tool['environment']
    manifest=json.loads((output/'genotype-result.json').read_text())
    assert manifest['workflowMode']=='genotypeOnly'
    rows=list(csv.DictReader((output/manifest['longSummaryCSVPath']).open()))
    truth=json.loads((HERE/'simulation-truth.json').read_text())
    observed={(r['sample'],r['genotype']):int(r['passed_unique_reads']) for r in rows}
    expected={(sample+'-pairs',record['allele']+'|'+record['accession']):n for sample,counts in truth['pairCounts'].items() for record,n in zip(truth['referenceRecords'],counts)}
    assert observed==expected, (observed,expected)
    stats=json.loads((output/manifest['statsJSONPath']).read_text())
    assert stats['pairMergePerformedDuringRun'] and stats['totalInputReads']==752 and stats['retainedUniqueReads']==376
    assert stats['assignedUniqueRetainedReads']==376 and stats['unassignedUniqueRetainedReads']==0
    for revision in manifest['workbookRevisions']:
        verify_file(dict(revision,path=str(output/revision['path'])))
    print(f'PASS: {len(native["files"])} native file identities, {len(native["steps"])} successful steps, six exact mixture counts, genotype-only workbook')
if __name__=='__main__': main()
