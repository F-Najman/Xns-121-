#!/bin/bash
# Runs every computation of the paper from the repository root and writes
# logs/<name>.log.  At most 3 Magma processes run at the same time.
# Total wall time on the Mordell server: about 4 minutes (10 minutes of CPU time).
#
# A job passes only if its log contains each of its success markers (printed
# after the script's asserts) and no Magma error message; the exit code of
# Magma alone is not enough, as Magma can exit with 0 after a failed assert.
# logs/run_all.status gets one line per job, and as its last line ALL_PASSED
# if every job passed, or FAILED otherwise (the script then exits with 1).
set -u
cd "$(dirname "$0")"
mkdir -p logs data
BAD='Runtime error|User error|Assertion failed|Syntax error|Internal error|Fatal error|has not been declared'
# run NAME "MARKER1;MARKER2;..." MAGMA-ARGUMENTS...
run() { local name=$1 markers=$2; shift 2; local t0=$(date +%s) res=PASS m
  magma -b "$@" < /dev/null > logs/$name.log 2>&1
  local rc=$?
  IFS=';' read -ra ms <<< "$markers"
  for m in "${ms[@]}"; do grep -qF -- "$m" logs/$name.log || res="FAIL(missing: $m)"; done
  grep -qE -- "$BAD" logs/$name.log && res="FAIL(Magma error)"
  echo "$name exit=$rc seconds=$(( $(date +%s)-t0 )) $res" >> logs/run_all.status; }
: > logs/run_all.status
( run model "MW_GROUP_VERIFIED;AUDIT_DONE" code/model.m
  run genus "G1 index=6655 nu2=67 nu3=1 cusps=55 genus=511" code/genus.m
  run cm_lifts "C1 VERIFIED;C2 n0=4:" code/cm_lifts.m
  run sieve_bruteforce "SIEVE_BRUTEFORCE_VERIFIED conservative_O=0" code/sieve_bruteforce.m
  run sieve_bruteforce_conservative "CONSERVATIVE_RUN_DONE: 10 residue classes survive" CONSERVATIVE_O:=1 code/sieve_bruteforce.m
  run setup "SETUP_DONE" code/setup.m
  run class_groups "unramified degree-11 extensions excluded unconditionally" code/class_groups.m
  run odd_geometry "ODD_DEPTH_AND_BRANCH_INPUTS_VERIFIED" code/odd_geometry.m
  run odd_singular_reduction "ODD_SINGULAR_REDUCTION_VERIFIED" code/odd_singular_reduction.m
  run even_geometry "EVEN_BRANCH_FORMAL_INPUTS_VERIFIED" code/even_geometry.m
  run nontorsion "ALL_SEVEN_KNOWN_DIVISORS_HAVE_INFINITE_ORDER" code/nontorsion.m
  run odd_depth_examples "ALL_ODD_LOCAL_DEPTH_EXAMPLES_VERIFIED" code/odd_depth_examples.m ) &
( run odd_selmer_p160 "ODD_SELMER_BOUNDS_DONE;ODD_FORMAL_DIRECTION_TESTS_DONE" PADPREC:=160 OUTTAG:=p160 code/odd_selmer.m code/odd_directions.m
  run odd_selmer_p80 "ODD_SELMER_BOUNDS_DONE;ODD_FORMAL_DIRECTION_TESTS_DONE" PADPREC:=80 OUTTAG:=p80 code/odd_selmer.m code/odd_directions.m ) &
( run even_selmer_-2 "EVEN_SELMER_DONE n0=-2 dimSel=5" NN:=-2 code/even_selmer.m
  run even_selmer_0 "EVEN_SELMER_DONE n0=0 dimSel=5" NN:=0 code/even_selmer.m
  run even_selmer_2 "EVEN_SELMER_DONE n0=2 dimSel=4" NN:=2 code/even_selmer.m
  run even_selmer_4 "EVEN_SELMER_DONE n0=4 dimSel=4" NN:=4 code/even_selmer.m ) &
wait
run single_place "E6 n0=4 place=2:;SINGLE_PLACE_VERIFIED" code/single_place.m
if [ "$(grep -c ' PASS$' logs/run_all.status)" -eq 19 ]; then
  echo ALL_PASSED >> logs/run_all.status
else
  echo FAILED >> logs/run_all.status; exit 1
fi
