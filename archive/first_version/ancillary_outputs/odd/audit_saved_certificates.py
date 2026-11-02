#!/usr/bin/env python3
"""Audit saved finite certificates; run from the workspace/archive root."""
import json
import os
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
HERE = ROOT / 'outputs' / 'odd'
MAGMA = os.environ.get('MAGMA', 'magma')


def run(command, marker):
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
    output = result.stdout + result.stderr
    print(output, end='', flush=True)
    assert result.returncode == 0, command
    assert marker in output, (command, 'missing completion marker')
    assert not re.search(r'(Runtime error|User error|Assertion failed)', output)


run([sys.executable, 'outputs/odd/six_prime_sieve.py'], 'SIX_PRIME_SIEVE_VERIFIED')
result = json.loads((HERE / 'six_prime_sieve_result.json').read_text())
expected = result['CM_classes']
actual = {str(n): [[0]*5 for _ in range(3)] for n in range(-2, 5)}
pattern = re.compile(r'm=(\d) n=(-?\d+): delta exponents \(pi11,u1\.\.u4\) = \[ ([\d, ]+) \]')
matches = pattern.findall((ROOT/'outputs/cm_classes.log').read_text())
assert len(matches) == 18
for m, n, values in matches:
    actual[n][int(m)-1] = list(map(int, values.split(',')))
assert actual == expected
print('EXACT_CM_CLASS_LOG_MATCHES_SIX_PRIME_SIEVE', flush=True)

for precision in [80, 160]:
    for n in [-1, 1, 3]:
        print(f'ODD CASE n={n} precision={precision}', flush=True)
        run([MAGMA, '-b', f'outputs/odd/selmer_{n}_cert{precision}_data.m',
             f'outputs/odd/formal_{n}_cert{precision}_data.m',
             'outputs/odd/audit_matrices.m'], 'ODD_MATRIX_AUDIT_PASSED')

for tag in ['minus2', '0', '2', '4']:
    print(f'EVEN CASE tag={tag}', flush=True)
    run([MAGMA, '-b', f'outputs/continuation/formal_{tag}_data.m',
         'outputs/continuation/audit_matrices.m'], 'MATRIX_CERTIFICATE_VERIFIED')

print('ALL_SAVED_CERTIFICATE_AUDITS_PASSED')
