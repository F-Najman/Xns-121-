#!/bin/bash
# Runs every computation of the paper from the repository root and writes
# logs/<name>.log.  At most 3 Magma processes run at the same time.
# Total wall time on the Mordell server: about 4 minutes (10 minutes of CPU time).
set -u
cd "$(dirname "$0")"
mkdir -p logs data
run() { local name=$1; shift; local t0=$(date +%s)
  magma -b "$@" < /dev/null > logs/$name.log 2>&1
  echo "$name exit=$? seconds=$(( $(date +%s)-t0 ))" >> logs/run_all.status; }
: > logs/run_all.status
( run model code/model.m
  run genus code/genus.m
  run cm_lifts code/cm_lifts.m
  run sieve_bruteforce code/sieve_bruteforce.m
  run sieve_bruteforce_conservative CONSERVATIVE_O:=1 code/sieve_bruteforce.m
  run setup code/setup.m
  run class_groups code/class_groups.m
  run odd_geometry code/odd_geometry.m
  run odd_singular_reduction code/odd_singular_reduction.m
  run even_geometry code/even_geometry.m
  run nontorsion code/nontorsion.m
  run odd_depth_examples code/odd_depth_examples.m ) &
( run odd_selmer_p160 PADPREC:=160 OUTTAG:=p160 code/odd_selmer.m code/odd_directions.m
  run odd_selmer_p80 PADPREC:=80 OUTTAG:=p80 code/odd_selmer.m code/odd_directions.m ) &
( for n in -2 0 2 4; do run even_selmer_$n NN:=$n code/even_selmer.m; done ) &
wait
run single_place code/single_place.m
echo ALL_DONE >> logs/run_all.status
