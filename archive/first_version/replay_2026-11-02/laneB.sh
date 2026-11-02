#!/bin/bash
cd ~/xns121/replay
t0=$(date +%s); magma -b PADPREC:=160 OUTTAG:=replay160 outputs/odd/odd_selmer.m outputs/odd/formal_directions.m < /dev/null > logs/odd_certificate_replay160.log 2>&1
echo "odd160 exit=$? secs=$(( $(date +%s)-t0 ))" >> logs/laneB.status
echo LANE_B_DONE >> logs/laneB.status
