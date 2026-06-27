# ISGT_EMT — `SolverIDASPM` on a coupled multi-node EMT network with an event

The ISGT 2018 "Simple Electrical Grid": three balanced 50 Hz sources, five
mutually-coupled three-phase RL lines, and one variable resistive load that
**steps at `t = 1 s`** (`R: 1.0 → 0.5 Ω`, 1 ms time constant). The model
(`Dynawo.Electrical.EMT.ISGT`, preassembled model `ISGT`) is the Dynawo-library
port of the case the Sinusoidal Predictor Method paper uses as its primary
example (188 equations, 15 differential).

This case extends the `Circuit_RLC_EMT` check to a **genuinely coupled network
with a transient event** — the regime where SPM's adaptive step size matters
most, and a real exercise of the sparse CSR Fourier-coefficient estimator.

## Run

```sh
./myEnvDynawo.sh jobs nrt/data/ISGT_EMT/ISGT.jobs         # plain IDA -> outputs/
./myEnvDynawo.sh jobs nrt/data/ISGT_EMT/ISGT_IDASPM.jobs  # IDASPM    -> outputsSPM/
```

Solver sets in `solvers.par` (`IDA`, `IDASPM`, identical `1e-4` tolerances);
the SPM set flags every three-phase instantaneous component as oscillating
(`spmOscillatingVariables = ".*_[0-9]+_"`, `spmPulsation = 314.159…`).

## Result (tol = 1e-4, 0→3 s)

| | plain IDA | IDASPM |
|---|---:|---:|
| time steps | 25 047 | 335 |
| ratio | — | **~75× fewer** |

**Step-size adaptation (the paper's Fig. 5/6 behaviour):**

| phase | IDASPM step size |
|---|---|
| pre-event steady (0.3–0.9 s) | 0.05 – 0.35 s (up to ~17 carrier periods) |
| **at the load step (t = 1 s)** | **drops to ~2e-3 s** |
| post-event steady (2–3 s) | 0.65 s (≈32 carrier periods) |

The SPM takes large steps in steady state, **steps down sharply at the event**,
and recovers — exactly the adaptive behaviour the method is designed for.

**Accuracy vs the IDA reference:** in steady state the two solutions agree to
~0.1 % at sampled points; the max relative error away from the event instant is
0.4–1 % on the node voltages and ~1–2 % on the line currents (instantaneous
sampling of a 50 Hz carrier at the sparse SPM output points). The large apparent
error *at* `t = 1.0000 s` is a comparison artifact — interpolating the sparse
SPM output across IDA's near-discontinuous load step — not an SPM error.

Outputs are git-ignored; regenerate with the two jobs above.
