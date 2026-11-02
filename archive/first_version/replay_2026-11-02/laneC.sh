#!/bin/bash
cd ~/xns121/replay
python3 outputs/continuation/create_descent.py > logs/create_descent.log 2>&1; echo "create exit=$?" >> logs/laneC.status
for NN in 0 -2 2 4; do
  TAG=replay${NN/-/minus}
  t0=$(date +%s); magma -b NN:=$NN TAG:=$TAG outputs/continuation/compute_selmer.m outputs/continuation/local_formal_test.m < /dev/null > logs/selmer_formal_$TAG.log 2>&1
  echo "even NN=$NN exit=$? secs=$(( $(date +%s)-t0 ))" >> logs/laneC.status
done
echo LANE_C_DONE >> logs/laneC.status
