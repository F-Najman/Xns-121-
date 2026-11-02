#!/usr/bin/env python3
"""Exhaustive six-prime cusp-class sieve; standard-library Python only.

Run from the workspace root after generating six_prime_sieve_data.txt.
All cusp residues are retained conservatively; no mod-121 cusp test is used.
"""
import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent


def add_equation(rows, coefficients, rhs):
    row = [int(a) % 11 for a in coefficients] + [int(rhs) % 11]
    for old in rows:
        pivot = next(i for i in range(5) if old[i])
        multiplier = row[pivot]
        row = [(a - multiplier * b) % 11 for a, b in zip(row, old)]
    pivot = next((i for i in range(5) if row[i]), None)
    if pivot is None:
        return rows if row[5] == 0 else None
    inverse = pow(row[pivot], -1, 11)
    row = tuple(a * inverse % 11 for a in row)
    result = [tuple((a - old[pivot] * b) % 11
                    for a, b in zip(old, row)) for old in rows]
    result.append(row)
    result.sort(key=lambda old: next(i for i in range(5) if old[i]))
    return tuple(result)


def read_tables():
    text = (HERE / 'six_prime_sieve_data.txt').read_text()
    assert text.rstrip().endswith('# DONE')
    assert 'Runtime error' not in text and 'User error' not in text
    expected_header = [
        '# basis b = [pi11, u1..u4]: [', '-z + 2,',
        'z^4 - 3*z^2 + 1,', 'z^2 + z - 1,', 'z,',
        '-z^4 - z^3 + 3*z^2 + 3*z', ']']
    assert text.splitlines()[:7] == expected_header
    tables = {}
    for line in text.splitlines():
        if not line.startswith('L '):
            continue
        header, *parts = line.split('|')
        p, order, index, degree, *chi = map(int, header.split()[1:])
        values = [list(map(int, part.split())) for part in parts]
        assert len(chi) == 5 and len(values) == 3
        assert all(len(row) == order for row in values)
        assert all(0 <= a < 11 for a in chi)
        assert all(-1 <= a < 11 for row in values for a in row)
        datum = tables.setdefault(p, {'order': order, 'degree': degree, 'rows': []})
        assert datum['order'] == order and datum['degree'] == degree
        datum['rows'].append((index, chi, values))
    assert set(tables) == {23, 53, 353, 3301, 12101, 15731}
    for p, datum in tables.items():
        count = 5 if datum['degree'] == 1 else 1
        assert sorted(row[0] for row in datum['rows']) == list(range(1, count + 1))
    return tables


def main():
    tables = read_tables()
    modulus = 1
    states = [(0, ((), (), ()))]
    history = []
    for prime in [353, 23, 3301, 12101, 15731, 53]:
        datum = tables[prime]
        order = datum['order']
        growth = order // math.gcd(order, modulus)
        survivors = []
        for n, systems in states:
            for lift in range(growth):
                candidate = n + lift * modulus
                residue = candidate % order
                updated = list(systems)
                valid = True
                for _, chi, values in datum['rows']:
                    if values[0][residue] < 0:
                        assert all(row[residue] < 0 for row in values)
                        continue
                    for m in range(3):
                        updated[m] = add_equation(updated[m], chi, -values[m][residue])
                        if updated[m] is None:
                            valid = False
                            break
                    if not valid:
                        break
                if valid:
                    survivors.append((candidate, tuple(updated)))
        modulus *= growth
        states = survivors
        row = {'prime': prime, 'order_G': order, 'modulus': modulus,
               'states': len(states),
               'ranks': sorted(set(tuple(len(s) for s in systems)
                                   for _, systems in states))}
        history.append(row)
        print(json.dumps(row), flush=True)
    assert modulus == 4356
    expected = {
        -2: [[0, 2, 8, 10, 5], [0, 1, 6, 8, 10], [0, 4, 9, 2, 6]],
        -1: [[0, 8, 7, 8, 6], [0, 4, 0, 8, 8], [0, 0, 5, 10, 4]],
         0: [[0]*5]*3,
         1: [[0, 7, 1, 0, 7], [0, 6, 4, 5, 10], [0, 6, 10, 7, 4]],
         2: [[0, 9, 3, 1, 6], [0, 0, 1, 1, 5], [0, 5, 8, 7, 6]],
         3: [[0, 6, 6, 3, 8], [0, 8, 8, 2, 1], [0, 0, 7, 3, 10]],
         4: [[0, 7, 6, 2, 1], [0, 1, 9, 0, 3], [0, 7, 3, 0, 8]],
    }
    centered = []
    for n, systems in states:
        n0 = (n + modulus//2) % modulus - modulus//2
        centered.append(n0)
        assert all(len(system) == 5 for system in systems)
        assert all(tuple(row[:5]) == tuple(int(i == j) for i in range(5))
                   for system in systems for j, row in enumerate(system))
        classes = [[(-row[5]) % 11 for row in system] for system in systems]
        assert classes == expected[n0]
    assert sorted(centered) == list(range(-2, 5))
    result = {'modulus': modulus, 'residues': sorted(centered),
              'CM_classes': expected, 'history': history,
              'all_input_regenerated': True,
              'cusp_residues_retained_conservatively': True}
    (HERE / 'six_prime_sieve_result.json').write_text(json.dumps(result, indent=2)+'\n')
    print('SIX_PRIME_SIEVE_VERIFIED modulus=4356 states=7 CM_classes_match=true')


if __name__ == '__main__':
    main()
