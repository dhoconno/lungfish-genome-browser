#!/usr/bin/env python3
"""Generate deterministic simulated macaque MHC reads from verified public records."""
import datetime, hashlib, json, pathlib, platform, re, shlex, sys, time, urllib.request
HERE = pathlib.Path(__file__).resolve().parent
REPO = HERE.parents[3]
BUNDLE = REPO/'Sources/LungfishWorkflow/Resources/MCMHaplotyping/MCM-MHC-miSeq-20260617.lungfishmhcref'
SELECTED = [('MCM_MHC_MiSeq_0002', 'OR823640'), ('MCM_MHC_MiSeq_0005', 'OR823568'), ('MCM_MHC_MiSeq_0007', 'OR823525')]
MIXTURES = {'SIMULATED-MHC-A': [120, 80, 4], 'SIMULATED-MHC-B': [12, 60, 100]}
def identity(p):
    return {'path': str(p.resolve()), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest(), 'sizeBytes': p.stat().st_size}
def rc(s): return s.translate(str.maketrans('ACGT','TGCA'))[::-1]
def main():
    start=time.monotonic(); began=datetime.datetime.now(datetime.timezone.utc).isoformat()
    provenance=HERE/'fixture-generation-provenance.json'
    if provenance.exists():
        prior=json.loads(provenance.read_text())
        for f in prior['inputs']+prior['outputs']:
            p=pathlib.Path(f['path']); assert identity(p)==f, f'Changed fixture source/output {p}'
        print('Verified existing simulated MHC fixture'); return
    source=BUNDLE/'mcm_mhc_miseq_reference.trimmed.unique.fasta'
    bundled=json.loads((BUNDLE/'.lungfish-provenance.json').read_text())
    for f in bundled['bundleDirectoryManifest']:
        p=BUNDLE/f['path']; assert identity(p)['sha256']==f['sha256'] and p.stat().st_size==f['sizeBytes']
    records={}
    for block in source.read_text().split('>')[1:]:
        header,*lines=block.splitlines(); records[header.split('|')[0]]=(header,''.join(lines))
    inputs=[source,BUNDLE/'.lungfish-provenance.json',pathlib.Path(__file__).resolve()]
    outputs=[]; selected=[]
    cache=HERE/'public-records'; cache.mkdir(exist_ok=True)
    for key,accession in SELECTED:
        header,seq=records[key]; assert f'accessions={accession}|' in header
        path=cache/(accession+'.embl'); url=f'https://www.ebi.ac.uk/ena/browser/api/embl/{accession}?download=false'
        if not path.exists(): path.write_bytes(urllib.request.urlopen(url,timeout=30).read())
        record=path.read_text(); assert 'OS   Macaca fascicularis' in record and 'AC   '+accession+';' in record
        public=re.sub('[^acgtACGT]','',record.split('\nSQ   ',1)[1].split('\n',1)[1].split('//')[0]).upper()
        assert seq in public or rc(seq) in public, f'{key} does not match public accession'
        allele=re.search(r'alleles=([^|]+)',header).group(1)
        selected.append({'id':key,'allele':allele,'accession':accession,'sourceURL':url,'sequence':seq,'sourceHeader':header})
        inputs.append(path)
    ref=HERE/'SIMULATED-MHC-reference.fasta'
    ref.write_text(''.join(f">{s['allele']}|{s['accession']}\n{s['sequence']}\n" for s in selected)); outputs.append(ref)
    for sample,counts in MIXTURES.items():
        mates=[[],[]]
        for source,n in zip(selected,counts):
            seq=source['sequence']; length=min(150,len(seq))
            for i in range(n):
                for mate,read in enumerate([seq[:length],rc(seq[-length:])]):
                    mates[mate].append(f"@{sample}_{source['id']}_{i:04d}/{mate+1}\n{read}\n+\n{'I'*len(read)}\n")
        interleaved=HERE/f'{sample}-pairs.fastq'
        interleaved.write_text(''.join(a+b for a,b in zip(*mates))); outputs.append(interleaved)
        for mate,text in enumerate(mates):
            p=HERE/f'{sample}_R{mate+1}.fastq'; p.write_text(''.join(text)); outputs.append(p)
    truth=HERE/'simulation-truth.json'
    truth.write_text(json.dumps({'observationType':'SIMULATED; no animals or biological observations','referenceRecords':selected,'pairCounts':MIXTURES,'errorModel':'none; constant Phred 40','mateLength':150,'selectionPurpose':'UI teaching only; mixtures are not inferred individual genotypes or haplotypes'},indent=2)+'\n'); outputs.append(truth)
    argv=[sys.executable,str(pathlib.Path(__file__).resolve())]
    provenance.write_text(json.dumps({'schemaVersion':1,'workflowName':'manual-simulated-macaque-mhc-fixture','workflowVersion':'1','toolName':'generate.py','toolVersion':'1','argv':argv,'reproducibleCommand':shlex.join(argv),'options':{'explicit':{},'defaults':{'mateLength':150,'phred':40,'errors':0,'seed':None},'resolvedDefaults':{'mixtures':MIXTURES,'referenceSelection':SELECTED}},'runtimeIdentity':{'python':sys.version,'executable':sys.executable,'operatingSystemVersion':platform.platform(),'architecture':platform.machine()},'inputs':[identity(p) for p in inputs],'outputs':[identity(p) for p in outputs],'startedAt':began,'completedAt':datetime.datetime.now(datetime.timezone.utc).isoformat(),'wallTimeSeconds':time.monotonic()-start,'exitStatus':0,'stderr':'','notice':'Deterministic simulated observations derived from public primate immune-gene references. No biological specimen, private reads, or pathogen data.'},indent=2)+'\n')
    print('Generated 376 simulated read pairs across two samples; public accession sequences and bundled source checksums verified')
if __name__=='__main__': main()
