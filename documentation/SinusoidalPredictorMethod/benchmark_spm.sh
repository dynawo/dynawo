#!/bin/bash
# Reproduce the SPM vs IDA benchmark on the passive IEEE_14bus EMT case.
# Run from nrt/data/IEEE14bus_EMT. SPM job writes to outputsSPM, IDA to outputs.
set -e
bench() { # $1 = stopTime (s)
  sed -i "s/stopTime=\"[0-9]*\"/stopTime=\"$1\"/" IEEE_14bus.jobs IEEE_14bus_IDASPM.jobs
  t0=$(date +%s.%N); ../../../myEnvDynawo.sh jobs IEEE_14bus.jobs >/dev/null 2>&1; t1=$(date +%s.%N)
  t2=$(date +%s.%N); ../../../myEnvDynawo.sh jobs IEEE_14bus_IDASPM.jobs >/dev/null 2>&1; t3=$(date +%s.%N)
  is=$(($(wc -l <outputs/curves/curves.csv)-1)); ss=$(($(wc -l <outputsSPM/curves/curves.csv)-1))
  printf "%4ss | IDA %7d steps %6.2fs | SPM %4d steps %6.2fs | %.0fx steps  %.2fx wall\n" \
    "$1" "$is" "$(echo "$t1-$t0"|bc)" "$ss" "$(echo "$t3-$t2"|bc)" "$(echo "$is/$ss"|bc -l)" "$(echo "($t1-$t0)/($t3-$t2)"|bc -l)"
}
for H in 3 10 30 60; do bench $H; done
sed -i 's/stopTime="[0-9]*"/stopTime="3"/' IEEE_14bus.jobs IEEE_14bus_IDASPM.jobs
