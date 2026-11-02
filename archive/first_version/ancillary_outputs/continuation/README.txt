X_ns^+(121): continuation, 29 October 2026

MAIN RESULT
even_classes.pdf gives the argument excluding additional points in the four
even sieve states n0 = -2, 0, 2, 4. This uses the inherited finite sieve and
cusp-descent equation from the earlier reports. The new even-case Selmer
calculations have certificates independent of GRH. The odd states -1, 1, 3
remain unresolved. The seven known CM points are not proved exhaustive.

Run all commands from the original workspace root (or an unpacked archive
root containing the outputs/ tree). Magma V2.30-1 is required.

EVEN-CASE REPRODUCTION
python3 outputs/continuation/create_descent.py
magma -b NN:=0 TAG:=0 outputs/continuation/compute_selmer.m outputs/continuation/local_formal_test.m
Repeat with NN:=-2 TAG:=minus2, NN:=2 TAG:=2, NN:=4 TAG:=4.
The completed logs are selmer_formal_0.log, selmer_formal_minus2.log,
selmer_formal_2.log, selmer_formal_4.log.

FAST MATRIX AUDIT
magma -b outputs/continuation/formal_0_data.m outputs/continuation/audit_matrices.m
Repeat with formal_minus2_data.m, formal_2_data.m, formal_4_data.m.
This checks U intersect T_local = 0 and
Sel_local intersect (U + T_local) = T_global.
The combined output is audit_matrices.log.

EXACT GEOMETRY AND FORMAL INPUTS
magma -b outputs/continuation/verify_even_geometry.m
The completed log is verify_even_geometry.log. The mathematical formal
group argument is in the PDF; this script checks its algebraic and finite
field inputs, not a formalization of the entire proof.

ODD SUBFIELDS
magma -b TWIST:=1 outputs/continuation/odd_subfields.m
magma -b TWIST:=-11 outputs/continuation/odd_subfields.m
These compute degree-30 subfield class groups under GRH and discover units.
The completed logs and exact unit data are included.

The files create_biquad_descent.py and biquad_kummer.m develop a replacement
for the direct degree-60 Kummer computation. See results.json for the tested
status. They do not supply an odd-class exclusion certificate.

DEPENDENCIES AND LIMITATIONS
The scripts load outputs/retry/verify_genus5.m, which in turn loads
outputs/verify_descent.m. create_descent.py uses
outputs/retry/create_fast_descent.py and the user's licensed Magma package
at /opt/magma-2.30-1/package/Geometry/CycCov/picndescent.m. Change its
--source argument/default if Magma is installed elsewhere. No licensed
Magma source is distributed; local generated copies go in work/.

The earlier reports xns121_report.pdf and retry/new_attack.pdf explain the
finite sieve and the genus-five reduction. In the finite sieve, all eligible
local tables up to prime 200 were regenerated; the higher-prime tables were
reused. The new exclusion proof inherits that input and does not replace it.

sha256.json records the packaged files. The original /home/fnajman/121
directory and the installed Magma package were not modified.
