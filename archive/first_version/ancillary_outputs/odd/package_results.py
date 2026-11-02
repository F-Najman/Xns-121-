#!/usr/bin/env python3
"""Package the completed proof and its dependencies, excluding experiments."""
import hashlib
import json
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[2]
paths = set()


def add(relative):
    path = ROOT / relative
    assert path.is_file(), relative
    paths.add(relative)


for name in ['verify_model', 'verify_descent', 'verify_cm_lifts', 'cm_classes']:
    for ext in ['m', 'log']:
        add(f'outputs/{name}.{ext}')
for name in ['original_jmap.m', 'compact_jmap.m']:
    add(f'outputs/{name}')
for name in ['verify_genus5', 'verify_nontorsion']:
    for ext in ['m', 'log']:
        add(f'outputs/retry/{name}.{ext}')
add('outputs/retry/create_fast_descent.py')

for name in ['README.txt', 'even_classes.pdf', 'even_classes.tex',
             'compute_selmer.m', 'create_descent.py', 'local_formal_test.m',
             'audit_matrices.m', 'audit_matrices.log',
             'verify_even_geometry.m', 'verify_even_geometry.log',
             'verify_odd_geometry.m', 'verify_odd_geometry.log']:
    add(f'outputs/continuation/{name}')
for tag in ['minus2', '0', '2', '4']:
    for name in [f'formal_{tag}_data.m', f'selmer_{tag}_data.m',
                 f'selmer_formal_{tag}.log']:
        add(f'outputs/continuation/{name}')

for name in ['README.txt', 'rational_points.pdf', 'rational_points.tex',
             'six_prime_sieve.py', 'six_prime_sieve.log',
             'six_prime_sieve_data.txt', 'six_prime_sieve_result.json',
             'generate_six_prime_sieve.m', 'odd_selmer.m', 'formal_directions.m',
             'audit_matrices.m', 'audit_matrices.log',
             'audit_saved_certificates.py', 'audit_saved_certificates.log',
             'package_results.py', 'results.json']:
    add(f'outputs/odd/{name}')
for name in ['verify_class_obstruction', 'verify_odd_depth',
             'verify_local_depth_examples']:
    for ext in ['m', 'log']:
        add(f'outputs/odd/{name}.{ext}')
for precision in [80, 160]:
    add(f'outputs/odd/odd_certificate_p{precision}.log')
    add(f'outputs/odd/global_basis_cert{precision}_data.m')
    for n in [-1, 1, 3]:
        for kind in ['selmer', 'formal']:
            add(f'outputs/odd/{kind}_{n}_cert{precision}_data.m')

hashes = {name: hashlib.sha256((ROOT/name).read_bytes()).hexdigest()
          for name in sorted(paths)}
hashes['README.txt'] = hashes['outputs/odd/README.txt']
manifest = ROOT/'outputs/odd/sha256.json'
manifest.write_text(json.dumps(hashes, indent=2)+'\n')
archive = ROOT/'outputs/xns121_rational_points.zip'
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
    for name in sorted(paths):
        zf.write(ROOT/name, name)
    zf.write(ROOT/'outputs/odd/README.txt', 'README.txt')
    zf.write(manifest, 'outputs/odd/sha256.json')
with zipfile.ZipFile(archive) as zf:
    assert zf.testzip() is None
    for name, digest in hashes.items():
        assert hashlib.sha256(zf.read(name)).hexdigest() == digest
print(f'PACKAGED_AND_HASH_VERIFIED files={len(hashes)+1} bytes={archive.stat().st_size}')
print(archive)
