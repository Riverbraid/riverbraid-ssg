#!/usr/bin/env bash
set -e
echo "size,time_ms" > results/runtime.csv

for size in 100 500 1000 5000 10000; do
  # Generate a synthetic workload
  rm -f programs/bench.ir
  for i in $(seq 1 $size); do
    echo "LOAD 1" >> programs/bench.ir
    echo "STORE 2" >> programs/bench.ir
  done
  echo "HALT" >> programs/bench.ir

  # Measure execution with nanosecond precision
  START=$(date +%s%N)
  ./riverbraid_vm programs/bench.ir > /dev/null
  END=$(date +%s%N)
  
  DURATION=$(( (END - START)/1000000 ))
  echo "$size,$DURATION" >> results/runtime.csv
  echo "Measured size $size: $DURATION ms"
done
