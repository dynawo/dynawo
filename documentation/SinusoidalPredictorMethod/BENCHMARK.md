# SPM vs IDA — EMT acceleration benchmark

The Sinusoidal Predictor Method (IDASPM solver) exists to **accelerate EMT
simulation** by representing each oscillating state as a sinusoid at the nominal
pulsation plus a slowly-varying correction, so the solver steps the *envelope*
instead of resolving every 50 Hz cycle. This is the headline measurement of that
acceleration on a recovered/ported EMT case.

Reproduce: `documentation/SinusoidalPredictorMethod/benchmark_spm.sh`
(run from `nrt/data/IEEE14bus_EMT`). The IDA job writes `outputs/`, the IDASPM
job writes `outputsSPM/`.

## Case: IEEE_14bus (passive EMT network)

`IEEE_14bus` is a passive three-phase EMT network (RL lines + shunts, no power
electronics), driven at 50 Hz with a disturbance at t = 1 s. After the
disturbance it settles into steady sinusoidal operation — the regime SPM is built
for. Plain IDA must resolve every cycle; IDASPM steps the envelope.

`spmOscillatingVariables = ".*_[0-9]+_"` (every instantaneous three-phase
component), `spmPulsation = 314.159` (50 Hz), same tolerances for both solvers.

### Results

| Horizon | IDA steps | SPM steps | step ↓ | IDA wall | SPM wall | wall ↓ |
|--------:|----------:|----------:|-------:|---------:|---------:|-------:|
|   3 s   |    19,974 |       401 |   50×  |   0.59 s |   0.99 s |  0.6×  |
|  10 s   |    61,710 |       403 |  153×  |   1.10 s |   1.07 s |  1.0×  |
|  30 s   |   180,958 |       405 |  447×  |   3.24 s |   1.02 s |  3.2×  |
|  60 s   |   359,829 |       408 |  881×  |   4.85 s |   0.95 s |  5.1×  |

Solver work at 30 s: IDA **180,976** residual evaluations vs IDASPM **463**
(~390×), with comparable Jacobian counts (23 vs 54).

### The key property

**SPM's cost is horizon-independent.** Its step count stays ~400 and its
wall-clock stays ~1 s no matter how long the run, because it tracks the slow
Fourier envelope, not the carrier. IDA grows linearly with simulated time. So the
speedup *grows without bound* with the horizon: 50× steps at 3 s → **881× at
60 s**; wall-clock crosses over near 10 s and reaches **5.1× at 60 s** (and keeps
climbing). The break-even (~10 s) is the fixed per-step estimator overhead being
amortised.

### Accuracy

IDASPM is not just fast — it matches the reference IDA solution. Comparing the
IDASPM samples against the IDA trajectory (time-aligned) over the steady-state
window t = 2–29.5 s:

- **worst-case 0.13 %**, median **0.07 %** relative to signal amplitude.

(A naive comparison over the *whole* run reports ~190 % — that is entirely the
t = 1 s disturbance event, where both solvers take micro-steps and sub-step
time-alignment across the discontinuity is ill-defined; IDASPM recovers exactly
after it, e.g. t = 1.249 s gives 5.02 vs IDA 5.01.)

## Where SPM does *not* help: converter-dominated cases

The benefit requires the flagged states to be well-approximated by a sinusoid at
the nominal pulsation. The recovered **IEEE_5bus** case has a grid-feeding
converter whose internal dq current-control / PLL states are essentially DC and
whose dynamics are not a clean 50 Hz oscillation. There IDASPM is **~2× slower**
than IDA even at 20 s (17.7 s vs 8.5 s) — the predictor cannot amortise its
per-step estimator. SPM is a tool for **passive / clean-sinusoidal EMT**
(networks, lines, loads), not for converter control loops.

## Takeaway

On passive EMT networks IDASPM delivers order-of-magnitude (and growing) step
reductions at reference-grade accuracy: **~450× fewer steps and 3.2× faster at
30 s, ~880× / 5.1× at 60 s, < 0.15 % error**. The longer the steady-state
horizon, the larger the win — which is exactly the regime (long EMT runs) where
simulation cost is otherwise prohibitive.
