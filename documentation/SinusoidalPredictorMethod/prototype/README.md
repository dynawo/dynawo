# IDASPM Phase-1 prototype — SPM ported onto SUNDIALS 6.3.0 (standalone)

This directory is the **Phase 1** deliverable from
[`../SPM_reintegration_design.md`](../SPM_reintegration_design.md): a standalone
port of the Sinusoidal Predictor Method (IDASPM) onto the **SUNDIALS 6.3.0** IDA
solver — the version current Dynawo (1.8.0) uses — with no Dynawo dependency.

Its purpose was to **de-risk the hard part** before touching the Dynawo codebase:
re-implementing the SPM's deep BDF-loop hooks against the post-3.0 SUNDIALS
architecture (generic `SUNMatrix` / `SUNLinearSolver` / `SUNNonlinearSolver`),
where the original prototype's `ida_sparse`/`ida_klu` layer no longer exists.

**Result: it works.** On the paper's canonical test problem, the ported solver
takes 80–93× fewer time steps than plain IDA in steady state while *improving*
accuracy, and correctly falls back to small steps during transients.

## Contents

| File | Role |
|---|---|
| `ida_spm.h` / `ida_spm_impl.h` / `ida_spm.c` | the SPM module (new IDA source files) — core decomposition + sparse Fourier-coefficient estimator with reused Jacobian and lazily-factorized normal equations |
| `sundials-6.3.0-spm.patch` | patch to pristine 6.3.0 `ida.c`, `ida_impl.h`, `src/ida/CMakeLists.txt` (the BDF-loop hooks) |
| `dahlquist.h` | the test problem: Dahlquist equation with oscillating forcing term (closed-form solution; `SinusoidalPredictorAnalysis.pdf` §2.1) |
| `baseline.c` | integrate the 1×1 problem with **plain IDA** (reference) |
| `spm.c` | integrate the 1×1 problem with **IDASPM** enabled |
| `spm2d.c` | a **2×2 non-symmetric** oscillating system — validates the CSR Jacobian orientation the estimator relies on (a 1×1 test cannot) |
| `build_and_run.sh` | fetch + patch + build SUNDIALS, build & run the harnesses |

The same SPM module is wired into Dynawo by `Solvers/VariableTimeStep/SolverIDASPM`
(Phase 3), which pushes the estimator `dF/dX` via `model.evalJt(cj=0)` and
`dF/dXdot` via `model.evalJtPrim` from its IDA Jacobian callback
(`IDASPMSetJacobians`).

## Reproduce

```sh
./build_and_run.sh          # downloads SUNDIALS 6.3.0, patches, builds, runs
```

Harness args: `./spm <tol> <tEnd> [u0 v0 [lambda w]]`
(`u0=1 v0=0` starts the system exactly on the steady sinusoid).

## Results

**Steady state** (`u0=uinf=1, v0=vinf=0`, 50 Hz, 2 s) — step-count reduction
grows as the tolerance tightens, mirroring the paper:

| tol | IDA steps | IDASPM steps | ratio |
|---|---:|---:|---:|
| 1e-3 | 5 880 | 72 | 81.6× |
| 1e-4 | 11 023 | 136 | 81.0× |
| 1e-5 | 23 578 | 266 | 88.6× |
| 1e-6 | 50 559 | 542 | 93.2× |

At tol 1e-4: IDASPM max step **0.666 s** (≈33 carrier periods/step) vs plain IDA
5.3e-4 s; IDASPM max error **2.1e-3** vs plain IDA 5.8e-3. The carrier is fully
removed from the integrated quantity.

**Transient → settle** (`u0=0.2, v0=-0.5, lambda=-4`, 3 s): the step size stays
small (~5e-4) while the envelope is moving, then climbs to **0.13 s** as the
system reaches steady state — exactly the adaptive behaviour of paper Fig. 6/9.

## Estimator interface (Phase 2: sparse, push-based, Dynawo-ready)

The estimator takes the state and derivative Jacobians **`dF/dX` and `dF/dXdot`
as CSR sparse `SUNMatrix`** — exactly the form Dynawo's `evalJt` / `evalJtPrim`
produce (design doc §5, so no new model interface is needed). The large `d×d`
Jacobians are never densified; only the small `2dₛ×2dₛ` normal-equations system
is dense (partial-pivot LU). Passing a `NULL` `dF/dXdot` keeps the semi-explicit
`dF/dXdot = I` shortcut for simple DAEs.

The API is **push-based**, mirroring the original Dynawo IDASPM:

- `IDASetSPM(ida_mem, isAC, wbar, id, nnz)` — enable the SPM (no callbacks).
- `IDASPMSetJacobians(ida_mem, dFdX, dFdXdot)` — called from the caller's IDA
  Jacobian function (i.e. whenever IDA refreshes its Newton Jacobian) to push a
  fresh Jacobian. The estimator **reuses** that Jacobian for all quadrature
  samples and across the intervening steps, and assembles + LU-factorizes its
  `2dₛ×2dₛ` matrix `Muv` **only when the Jacobian changes**, reusing the factors
  for the per-step back-substitution. Only the gradient and the residual samples
  are recomputed each step. This is what makes IDASPM faster than IDA in
  wall-clock (the earlier per-step refactorization was `O(dₛ³)`/step and lost the
  step-count win); it is numerically identical (1×1: 136 steps; 2×2: 139 steps).

The same `ida_spm.{c,h,_impl.h}` sources here are what the in-tree SUNDIALS
patch installs — see below.

## In-tree integration (Phase 2)

These SPM sources and the BDF-loop hooks are folded into Dynawo's SUNDIALS
build via `dynawo/3rdParty/sundials/patch/common/sundials.patch` (a strict
superset of the prior kinsol/hmin patch — the original changes are preserved
byte-for-byte). Building Dynawo's 3rd parties therefore produces a
`libsundials_ida` that exports `IDASetSPM` and installs `ida/ida_spm.h`. The
standalone `build_and_run.sh` here uses an SPM-only subset of that patch for a
minimal, Dynawo-free reproduction.

## Port notes (SUNDIALS 2.7.0 → 6.3.0)

The SPM keeps IDA's BDF prediction/error-control running on the **correction
history `phixi`** (smooth δ), not the full oscillating solution — that is why the
step size grows. Key 6.3.0 mapping decisions, all in the patch:

- `IDAMem` gains a `void *ida_spm` pointer (NULL ⇒ stock IDA, zero overhead).
- `IDAStep` (pre-loop): estimate `(u,v)` → re-evaluate predictor `ybar` →
  re-base `phixi`/`phi` (continuity).
- `IDAPredict`: predict `xi` from `phixi`, then `yypredict = xi + ybar`.
- **`IDANls` is left stock.** Because `yypredict` already carries `ybar`, the
  6.3.0 `SUNNonlinearSolver` (`yy = yypredict + ee`) automatically corrects δ —
  the per-Newton-iteration `IDASPMApplyCorrection` hook of the 2.7.0 prototype
  is unnecessary. This is the cleanest consequence of the new architecture.
- `IDATestError`: lower-order error estimates use `phixi[k]` instead of `phi[k]`.
- `IDASetCoeffs` / `IDARestore` / `IDAReset`: the β / 1/β / η scalings of the φ
  divided differences are mirrored onto `phixi`, `phiybar`, and the scalar
  `phisinbar`/`phicosbar` predictor divided differences.
- `IDACompleteStep`: the BDF history update runs on `phixi` + sin/cos divided
  differences; `phi`, `yy`, `yp` are then rebuilt from `X = phixi + ybar`.

## Next (Phase 2/3, see design doc §7)

1. Fold this patch into `dynawo/3rdParty/sundials/patch/`, add the KLU estimator.
2. Create `Solvers/VariableTimeStep/SolverIDASPM` wired to `evalJt`/`evalJtPrim`,
   with `wbar` + oscillating-variable selection from the solver `.par`.
3. Validate an NRT (Circuit_RLC, then IEEE-14-bus) against plain IDA.
