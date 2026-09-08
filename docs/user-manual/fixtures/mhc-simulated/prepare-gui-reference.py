#!/usr/bin/env python3
"""Add explicit MHC allele metadata to the verified teaching reference."""
import datetime, hashlib, json, pathlib, platform, shlex, sys, time
HERE=pathlib.Path(__file__).resolve().parent

def record(p): return dict(path=str(p.resolve()),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),sizeBytes=p.stat().st_size)
def main():
    started=time.monotonic();now=datetime.datetime.now(datetime.timezone.utc).isoformat()
    source=HERE/'simulation-truth.json';output=HERE/'SIMULATED-MHC-annotated-reference.gb';provenance=HERE/'gui-reference-provenance.json'
    if provenance.exists():
        d=json.loads(provenance.read_text())
        for f in d['inputs']+d['outputs']: assert record(pathlib.Path(f['path']))==f, f'Changed annotated reference source/output {f["path"]}'
        print('Verified annotated MHC reference');return
    records=json.loads(source.read_text())['referenceRecords'];text=[]
    for r in records:
        allele=r['allele'].replace('_','*',1);gene=allele.split('*')[0];seq=r['sequence'];n=len(seq);name=r['allele']+'|'+r['accession']
        text.append(f'LOCUS       {name} {n} bp DNA linear MAM 08-SEP-2026\nDEFINITION  {allele} public genomic reference amplicon for simulated-read teaching.\nACCESSION   {name}\nVERSION     {name}\nSOURCE      Macaca fascicularis\n  ORGANISM  Macaca fascicularis\nCOMMENT     Reference slice verified against public accession {r["accession"]}.\n            This is a reference sequence, not a simulated biological observation.\nFEATURES             Location/Qualifiers\n     source          1..{n}\n                     /organism="Macaca fascicularis"\n                     /mol_type="genomic DNA"\n                     /db_xref="taxon:9541"\n                     /note="Public reference accession {r["accession"]}; partial reference amplicon"\n     gene            1..{n}\n                     /gene="{gene}"\n                     /allele="{allele}"\nORIGIN\n')
        for i in range(0,n,60):text.append(f'{i+1:9d} '+ ' '.join(seq[j:j+10].lower() for j in range(i,min(i+60,n),10))+'\n')
        text.append('//\n')
    output.write_text(''.join(text))
    argv=[sys.executable,str(pathlib.Path(__file__).resolve())]
    d=dict(schemaVersion=1,workflowName='prepare-simulated-mhc-gui-reference',workflowVersion='1',toolName='prepare-gui-reference.py',toolVersion='1',argv=argv,reproducibleCommand=shlex.join(argv),options=dict(explicit={},defaults=dict(format='GenBank',moleculeType='genomic DNA'),resolvedDefaults=dict(alleleNormalization='Replace bundled allele separator underscore with canonical star',sequenceChanges=False)),runtimeIdentity=dict(python=sys.version,executable=sys.executable,operatingSystemVersion=platform.platform(),architecture=platform.machine()),inputs=[record(p) for p in [source,HERE/'fixture-generation-provenance.json',pathlib.Path(__file__).resolve()]],outputs=[record(output)],startedAt=now,completedAt=datetime.datetime.now(datetime.timezone.utc).isoformat(),wallTimeSeconds=time.monotonic()-started,exitStatus=0,stderr='')
    provenance.write_text(json.dumps(d,indent=2)+'\n');print('Generated annotated public MHC reference with unchanged sequences')
if __name__=='__main__':main()
