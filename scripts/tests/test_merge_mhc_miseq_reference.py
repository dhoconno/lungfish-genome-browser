import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'reference' / 'merge_mhc_miseq_reference.py'

class MergeMHCReferenceTests(unittest.TestCase):
    def test_preserves_primary_and_maps_both_strands_without_inventing_diagnostics(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            primary_header = 'MCM_MHC_MiSeq_0001|source_loci=MHC-E|alleles=Mafa-E_01:01'
            (root/'full.fa').write_text('>MCM_MHC_MiSeq_0001|source_loci=MHC-E\nAACC\n>other|source_loci=MHC-B\nACAC\n>classA|source_loci=MHC-A|alleles=Mafa-A1_01:01\nCCCG\n')
            (root/'primary.fa').write_text(f'>{primary_header}\nAACC\n')
            (root/'raw.fa').write_text('>11_M1_E_old\nAACC\n>12_M2_B_old\nGTGT\n>06_M5_A2_05_21\nAGCC\n>16_A102\nAAAA\n')
            definition = b'{"locusDefinitions":[{"haplotypes":[{"diagnosticAlleles":["MCM_MHC_MiSeq_0001"]}]}]}\n'
            (root/'definition.json').write_bytes(definition)
            args = [sys.executable, str(SCRIPT), '--full-fasta', str(root/'full.fa'), '--primary-fasta', str(root/'primary.fa'), '--raw-fasta', str(root/'raw.fa'), '--haplotype-definition', str(root/'definition.json'), '--output-dir', str(root/'out')]
            result = subprocess.run(args, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            output = root/'out'
            fasta = (output/'reference.fasta').read_text()
            self.assertIn('>'+primary_header+'\nAACC\n', fasta)
            self.assertEqual(fasta.count('>'), 5)
            self.assertIn('source_loci=MHC-A2|alleles=Mafa-A2_05_21', fasta)
            self.assertLess(fasta.index('alleles=Mafa-A1_01:01'), fasta.index('alleles=Mafa-A2_05_21'))
            self.assertLess(fasta.index('alleles=Mafa-A2_05_21'), fasta.index('alleles=Mafa-E_01:01'))
            control_header = next(line for line in fasta.splitlines() if 'alleles=16_A102' in line)
            self.assertIn('source_loci=Unknown', control_header)
            self.assertNotIn('haplotypes=', fasta)
            self.assertEqual((output/'haplotype-definition.json').read_bytes(), definition)
            mapping = json.loads((output/'sequence-map.json').read_text())
            reverse = next(row for row in mapping['records'] if row['id']=='other')['sources']
            self.assertEqual(next(row for row in reverse if row['role']=='raw')['orientation'], 'reverse-complement')
            provenance = json.loads((output/'provenance.json').read_text())
            self.assertEqual(provenance['exit_status'], 0)
            self.assertTrue(all(row['sha256'] and row['size_bytes'] > 0 for row in provenance['outputs']))
            self.assertIn('--output-dir', provenance['argv'])
            self.assertEqual(subprocess.run(args, capture_output=True).returncode, 1)
            # A primary sequence mismatch must stop the merge and record failure,
            # rather than preserving its identifier on a different sequence.
            (root/'primary.fa').write_text(f'>{primary_header}\nAACA\n')
            args[-1] = str(root/'rejected')
            rejected = subprocess.run(args, capture_output=True, text=True)
            self.assertEqual(rejected.returncode, 1)
            failure = json.loads((root/'rejected'/'provenance.json').read_text())
            self.assertEqual(failure['exit_status'], 1)
            self.assertIn('differs in full reference', failure['stderr'])
            self.assertFalse((root/'rejected'/'reference.fasta').exists())


if __name__ == '__main__':
    unittest.main()
