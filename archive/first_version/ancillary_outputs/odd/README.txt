X_ns^+(121): rational-point determination, 30 October 2026

RESULT
rational_points.pdf contains the combined proof draft. It concludes that
there are exactly seven rational points, all CM, with discriminants
-3, -4, -12, -16, -27, -67, -163. Each is the unique rational lift of the
corresponding point nG on X_ns^+(11), for n=-2,-1,0,1,2,3,4.

The new work excludes the three odd classes. It also replaces the large
inherited sieve by six fully regenerated local tables. Neither GRH nor an
unproved height bound is a hypothesis of the argument. The local formal
group lemmas are proved in the PDF; the scripts check their arithmetic
inputs and finite certificates, not a machine formalization of the proof.

Run commands from the archive/workspace root containing outputs/.
Magma V2.30-1 and Python 3 were used. The six-prime Python sieve needs no
third-party packages. Full odd computations take a few minutes and use
only public Magma intrinsics. The older even driver makes a local modified
copy of the user's licensed Magma descent source; this source is not
distributed and the installed package is never modified.

SIX-PRIME SIEVE
magma -b outputs/odd/generate_six_prime_sieve.m > outputs/odd/six_prime_sieve_data.txt
python3 outputs/odd/six_prime_sieve.py

Expected final marker:
SIX_PRIME_SIEVE_VERIFIED modulus=4356 states=7 CM_classes_match=true

The primes, in sieve order, are 353,23,3301,12101,15731,53. The successive
state counts are 7,10,7,12,7,7. The classes start unrestricted. Cusp residues
are retained conservatively at every stage. The final three classes match
the exact CM classes computed by outputs/cm_classes.m.

NEW EXACT NUMBER-FIELD AND GEOMETRY CHECKS
magma -b outputs/odd/verify_class_obstruction.m
magma -b outputs/odd/verify_odd_depth.m
magma -b outputs/continuation/verify_odd_geometry.m
magma -b outputs/odd/verify_local_depth_examples.m

The last script checks nearby images n=n0+4356 and n=n0+11*4356 at both
ramified places, confirming the depth and exponent-three direction.
These examples supplement the all-k proof in the PDF.

FULL ODD SELMER AND DIRECTION CALCULATION
magma -b PADPREC:=160 OUTTAG:=rerun outputs/odd/odd_selmer.m outputs/odd/formal_directions.m

The script certifies the 15-dimensional anti-invariant global Kummer
space. At each of the three 11-adic places it generates the complete
five-dimensional local image using actual degree-two divisors. The
intersection has dimension one for each odd class. Its localization at
the two ramified places is injective, with zero intersection with the
two-dimensional space of possible final formal directions.

GRH is used only to discover candidate generators in the degree-30
subfields. Each candidate is checked by ideal factorization, exact norm,
and local independence. The global dimension is proved unconditionally
from the discriminants and Odlyzko's Table 4. Thus discovery under GRH
does not make the resulting basis or Selmer bound conditional.

Completed runs are odd_certificate_p80.log and odd_certificate_p160.log.
Their exact outputs are global_basis_cert*_data.m,
selmer_{-1,1,3}_cert*_data.m and formal_{-1,1,3}_cert*_data.m.
The global files include exact representatives in B as pairs of elements
of F, together with F's defining polynomial and eta. They are large because
candidate S-units were not optimized for coefficient size.

FAST EXACT MATRIX AUDIT
python3 outputs/odd/audit_saved_certificates.py

This runs the six-prime sieve, checks the exact CM class log against it,
reconstructs all six odd Selmer intersections (three cases at each of two
precisions), and rechecks the four previous even matrix certificates.
It does not rerun the number-field arithmetic or generate local points.
Its saved transcript is audit_saved_certificates.log.

A single odd case can be audited directly, for example:
magma -b outputs/odd/selmer_-1_cert160_data.m outputs/odd/formal_-1_cert160_data.m outputs/odd/audit_matrices.m

EVEN CASES AND EARLIER EXACT INPUTS
The complete even calculation and its reproduction instructions are in
outputs/continuation/README.txt and even_classes.pdf. Its proof uses only
the descent equation, n-n0 divisible by 4, and v_11(n-n0)>=2. The new sieve
modulus 4356 supplies these conditions. The old large modulus is unnecessary.

Supporting scripts:
magma -b outputs/verify_model.m
magma -b outputs/cm_classes.m
magma -b outputs/verify_descent.m
magma -b outputs/retry/verify_genus5.m
magma -b outputs/retry/verify_nontorsion.m
magma -b outputs/verify_cm_lifts.m

The older reports and README files retain their historical status text.
Their statements that the odd cases/completeness remain unresolved are
superseded by rational_points.pdf. The earlier large sieve and abandoned
degree-60/PARI experiments are not needed for this result.

PROOF CHECKPOINTS
1. Six-prime sieve gives n=n0 mod 4356 and the exact cusp classes.
2. Exact function identity gives x(nG-3s)=alpha+delta_n0*w^11.
3. The two-descent gives the seven genus-five auxiliary curves.
4. Global Kummer bases and local Selmer images have certificates.
5. The odd depth is 20k-13 over a ramified branch completion; after
   10k-7 lambda-divisions the tangent direction is (-1)^(j-1)/j^3.
6. This direction is incompatible with the localized odd Selmer line.
7. The earlier even division argument excludes the other four classes.
8. CM reciprocity gives one rational lift over each surviving base point.

Original /home/fnajman/121 files were not changed. sha256.json records
the files included in the final archive. No licensed Magma source is
included in that archive.
