# Circuit_RLC_EMT — functional validation of `SolverIDASPM`

A three-phase EMT (full-waveform) RL line feeding a shunt capacitor, energised
at `t = 1.1 s` by a balanced 50 Hz source. The model
(`Dynawo.Electrical.EMT.Circuit_RLC`, built into the preassembled model
`Circuit_RLC`) is the Dynawo-library port of the historical `EMTSim` RLC case
that the Sinusoidal Predictor Method was originally demonstrated on.

This case is the Phase-4 functional check of the reintegrated SPM: the same
problem is solved with plain IDA and with `SolverIDASPM`, and the two solutions
are compared.

## Run

```sh
./myEnvDynawo.sh jobs nrt/data/Circuit_RLC_EMT/Circuit_RLC.jobs         # plain IDA   -> outputs/
./myEnvDynawo.sh jobs nrt/data/Circuit_RLC_EMT/Circuit_RLC_IDASPM.jobs  # IDASPM      -> outputsSPM/
```

Both write `curves.csv` (3 line currents + 3 capacitor voltages). The solver
parameter sets live in `solvers.par` (`IDA` and `IDASPM`, identical tolerances
`1e-4`). The SPM set adds:

- `spmPulsation = 314.159…` (50 Hz carrier),
- `spmOscillatingVariables = ".*_[0-9]+_"` (flags every three-phase instantaneous
  voltage/current component as oscillating).

Oscillating variables can be selected by the `spmOscillatingVariables` regex
and/or an explicit `spmOscillatingVariablesList` (exact state-variable names,
separated by `,` `;` or whitespace); the two are unioned and either may be
omitted. Both the differential *and* the algebraic oscillating states must be
flagged — flagging only the differential ones breaks the BDF step growth (here
selecting just the 6 differential states inflates 277 → ~65 k steps).

## Result (tol = 1e-4, 0→10 s)

| | plain IDA | IDASPM |
|---|---:|---:|
| time steps | 67 615 | 278 |
| ratio | — | **243× fewer** |
| max step size | ~1e-4 s (carrier-limited) | **4.24 s** (≈212 carrier periods) |
| max rel. error vs IDA (6 curves) | — | 1.6e-3 – 6.4e-3 |

The SPM solution matches the IDA reference across all curves while taking 243×
fewer steps — in line with the 150–240× reported in the original paper. The
step size climbs to several seconds in steady state, i.e. the 50 Hz carrier is
fully removed from the integrated quantity, and correctly drops back to small
steps around the `t = 1.1 s` switch-on transient.

Outputs (`outputs/`, `outputsSPM/`) are git-ignored; regenerate by running the
two jobs above.
