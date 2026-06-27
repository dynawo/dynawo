# IEEE14bus_EMT — `SolverIDASPM` scaling on a 754-equation EMT network

The IEEE 14-bus reference network in EMT form: 5 balanced 50 Hz sources, 14
buses, 17 mutually-coupled three-phase RL lines, 3 ideal transformers, and 11
resistive loads — the load at **Bus 4 steps at `t = 1 s`** (`R: 1.0 → 0.5 Ω`).
The model (`Dynawo.Electrical.EMT.IEEE_14bus`, preassembled model `IEEE_14bus`,
754 differential+algebraic equations) is the Dynawo-library port of the SPM
paper's larger validation case.

This is the **scaling** check: a much larger coupled network than ISGT,
exercising the sparse CSR Fourier-coefficient estimator at size.

## Run

```sh
./myEnvDynawo.sh jobs nrt/data/IEEE14bus_EMT/IEEE_14bus.jobs         # plain IDA -> outputs/
./myEnvDynawo.sh jobs nrt/data/IEEE14bus_EMT/IEEE_14bus_IDASPM.jobs  # IDASPM    -> outputsSPM/
```

`solvers.par` holds the `IDA` and `IDASPM` sets (identical `1e-4` tolerances);
SPM flags every three-phase instantaneous component as oscillating
(`spmOscillatingVariables = ".*_[0-9]+_"`, `spmPulsation = 314.159…`).

## Result (tol = 1e-4, 0→3 s)

| | plain IDA | IDASPM |
|---|---:|---:|
| time steps | 19 974 | 401 |
| ratio | — | **~50× fewer** |

**Step-size adaptation:** 0.08–0.33 s in pre-event steady state (up to ~16
carrier periods), drops to ~2e-3 s at the t = 1 s load step, recovers to ~0.27 s
(max step 0.75 s) — the same large→small→large behaviour as ISGT.

**Accuracy vs the IDA reference (steady state):** line currents 0.1–0.3 %, node
voltages 0.4–1.2 %. As with ISGT, the apparent error spikes *at* `t = 1.0000 s`
are a comparison artifact across the load discontinuity; in addition, for ~0.15 s
after the event the line currents deviate transiently (up to a few percent) while
the estimator re-converges its Fourier coefficients to the new operating point,
then return to ~0.1 %.

The step-count ratio is lower than `Circuit_RLC_EMT` (243×) and `ISGT_EMT` (75×)
because this 0→3 s window has larger transient fractions and the estimator's
dense normal-equations solve grows with the number of oscillating variables;
the steady-state step sizes (up to 0.75 s ≈ 37 carrier periods) still show the
full SPM benefit. Outputs are git-ignored; regenerate with the two jobs above.
