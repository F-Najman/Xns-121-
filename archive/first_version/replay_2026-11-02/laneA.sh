#!/bin/bash
cd ~/xns121/replay
run() { local name=$1; shift; local t0=$(date +%s); magma -b "$@" < /dev/null > logs/$name.log 2>&1; echo "$name exit=$? secs=$(( $(date +%s)-t0 ))" >> logs/laneA.status; }
run verify_model outputs/verify_model.m
run cm_classes outputs/cm_classes.m
run verify_cm_lifts outputs/verify_cm_lifts.m
run verify_descent outputs/verify_descent.m
run verify_genus5 outputs/retry/verify_genus5.m
run verify_nontorsion outputs/retry/verify_nontorsion.m
run verify_class_obstruction outputs/odd/verify_class_obstruction.m
run verify_odd_depth outputs/odd/verify_odd_depth.m
run verify_odd_geometry outputs/continuation/verify_odd_geometry.m
run verify_even_geometry outputs/continuation/verify_even_geometry.m
run verify_local_depth_examples outputs/odd/verify_local_depth_examples.m
t0=$(date +%s); magma -b outputs/odd/generate_six_prime_sieve.m < /dev/null > logs/six_prime_sieve_data.txt 2>&1; echo "gen_sieve exit=$? secs=$(( $(date +%s)-t0 ))" >> logs/laneA.status
cmp <(grep -v '^#' logs/six_prime_sieve_data.txt) <(grep -v '^#' /home/fnajman/Documents/Codex/2026-10-29/can-you-find-the-rational-points/outputs/level121_paper/ancillary/outputs/odd/six_prime_sieve_data.txt) && echo "sieve data identical to archived" >> logs/laneA.status
cp logs/six_prime_sieve_data.txt outputs/odd/six_prime_sieve_data.txt
python3 outputs/odd/six_prime_sieve.py > logs/six_prime_sieve.log 2>&1; echo "sieve.py exit=$?" >> logs/laneA.status
python3 outputs/odd/audit_saved_certificates.py > logs/audit_saved_certificates.log 2>&1; echo "audit exit=$?" >> logs/laneA.status
echo LANE_A_DONE >> logs/laneA.status
