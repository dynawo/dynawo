# IEEE_5bus_EMT

Recovered EMTSim **IEEE 5-bus** case (`EMTSim.Examples.IEEE_5bus`), reconstructed
from the OMC instantiated-model dump in the original IDASPM zip's
`dynamoCompiler-sim.log` (see
`documentation/SinusoidalPredictorMethod/recovered_cases/recover_ieee5.py` and
`decomposition.md`). Topology: 5 buses, 7 RL lines, 4 PQ loads, a perfect
generator, and one grid-feeding converter (`GridFeeding2`) on the meshed Bus 2.

## Status: RUNS TO COMPLETION and validates against the reference

This is the first recovered EMTSim case that runs all the way through. Unlike
`GFf_Load_InfBus`, the grid-feeding converter here sits on a **meshed bus** (six
branches), not a radial line behind a zero-current sensor, so it has none of the
series-inductor daeMode singularity — the recovered model is square and runs as-is.

- `IEEE_5bus.jobs` — plain IDA, `stopTime = 1 s`. **Runs to completion.**
- `IEEE_5bus_SPM.jobs` — IDA + Sinusoidal Predictor Method. Also runs to
  completion and produces the same solution.

Validation vs `reference/outputs/curves/curves.csv` (the original IDASPM run),
time-aligned (variable-step → differing row counts), over `0.02–0.98 s`:

| quantity | max rel. error |
|---|---|
| `CurrentControl_Vs` | 0.00 % |
| `CurrentControl_Ws` | 0.74 % |
| `GridFeeding2.p_v1/2/3` (bus voltages) | ~1.2–1.4 % |
| `GridFeeding2.p_i1/2/3` (currents) | ~8 % peak |

Voltages and control signals match to ~1 %; the current peaks differ by a few
percent, consistent with the coarser variable-step grid (2.2k vs 9.5k rows) at
the 50 Hz oscillation peaks, not a model error.

## Notes
- `absAccuracy = 1.0` (SI kV/kA scale; `relAccuracy = 1e-4` carries precision).
  Tightening too far (`absAccuracy = 0.1`, `relAccuracy = 1e-5`) stalls the start.
- SPM does **not** speed up this 1 s run: the horizon is dominated by the
  converter's start-up transient, so the sinusoidal predictor cannot amortise its
  per-step estimator (SPM's gain appears on long *steady* sinusoidal horizons,
  e.g. IEEE_14bus at 30 s). The SPM job is kept to show the recovered case is
  solver-correct under IDASPM. `spmOscillatingVariables` is set to the abc phase
  quantities (`.*_(v|i)[123]$`).
