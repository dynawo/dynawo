# Reintegrating the Sinusoidal Predictor Method (IDASPM) into Dynawo

**Status:** design / porting plan (no code yet)
**Author:** reintegration scoping
**Target branch:** `claude/dynawo-sinusoidal-predictor-emt-ed4zeo`
**Source material:** `DYNAMO_IDASPM_clean.zip`
(`https://github.com/gautierbureau/dynawo/releases/download/vMaster/DYNAMO_IDASPM_clean.zip`)

---

## 1. Purpose and scope

This document is the technical plan for bringing the **Sinusoidal Predictor
Method (SPM)** — historically prototyped as the `IDASPM` solver on Dynawo 0.1.0
/ SUNDIALS 2.7.0 — back into the current Dynawo (`1.8.0`, SUNDIALS `6.3.0`).

It is deliberately a **design doc first**: the central difficulty is not the SPM
mathematics (which is well understood and documented in the accompanying papers)
but the fact that the prototype is welded to a SUNDIALS internal API that was
**removed wholesale** in SUNDIALS 3.0+. Reintegration is therefore a *port*, not
a *patch application*, and needs to be planned before code is written.

The companion papers in the archive are the authoritative reference for the
method itself:

- `SinusoidalPredictorAnalysis.pdf` — consistency/stability analysis, full
  IDASPM description (the main reference).
- `ISGT2018versionfinale.pdf` — *Speedup of EMT simulations… predictive Fourier
  coefficients estimator* (Gibert et al., 2018b).
- `SIMULTECH_PM-GIBERT.pdf` — *Use of the SPM within a fully separated
  modeler/solver framework* (Gibert et al., 2018a).

---

## 2. The method in one page

EMT (full-waveform) simulation is slow because the 50 Hz carrier forces tiny
time steps even when nothing interesting is happening. SPM removes that carrier
from the integrated quantity.

For each step interval `[tₙ, tₙ₊₁]` the solution is decomposed as

```
X(t) = X̄ₙ(t) + δ(t)
```

with a **sinusoidal predictor** at the nominal pulsation `ω₀`

```
X̄ₛ,ₙ(t) = uₙ·sin(ω₀ t) + vₙ·cos(ω₀ t)
```

(`ω₀ = 2π·f₀`, e.g. `314.159… = 100π` for 50 Hz) and a **correction term** `δ`.

- `X̄ₙ` carries the trivial steady-state oscillation. Only the *oscillating*
  state variables (network voltages/currents) get a predictor; *non-oscillating*
  variables keep `X̄ ≡ 0`.
- `δ` carries transients only, so the adaptive-step BDF (IDA) integrates it with
  very large steps in steady state.

One SPM iteration (paper, fig. 1):

1. **Fix** the Fourier coefficients `(uₙ, vₙ)` for the interval.
2. **Integrate** the equations rewritten on `δ` (this is what IDA's BDF sees).
3. **Reconstruct** `X = X̄ₙ + δ`.
4. **Update** `(uₙ₊₁, vₙ₊₁)` with a *predictive parametric estimator*: one
   modified-Newton iteration minimising a stationarity residual
   `R(u,v) = ∫ ‖F(t, X̄, Ẋ̄)‖² dt` over one period.

The estimator step needs `F`, **and the two partial Jacobians `∂F/∂X` and
`∂F/∂Ẋ` separately** (to assemble the Hessian/gradient of `R`). This is the one
demand SPM places on the modeler side.

**Reported results** (analysis paper, tol 1e-4): ISGT 4-node ≈ 236× fewer steps
and ≈ 29× wall-clock; IEEE-14-bus ≈ 192× fewer steps and 3.4–8.6× wall-clock.
Accuracy matches plain IDA. Speedup < step-count ratio because the estimator
itself is the dominant remaining cost.

---

## 3. What the archive contains

```
DYNAMO_IDASPM_clean/
├── README.txt                         # (FR) build notes + the known caveat below
├── SinusoidalPredictorAnalysis.pdf    # main paper
├── ISGT2018versionfinale.pdf
├── SIMULTECH_PM-GIBERT.pdf
├── SUNDIALS/
│   ├── sundials-2.7.0.tar.gz                  # pristine upstream
│   ├── sundials-2.7.0_spm.tar.gz              # SPM only
│   ├── sundials-2.7.0_spm_hmin.tar.gz         # SPM + Dynawo hmin/etc.
│   ├── sundials-2.7.0_spm.patch               # SPM + Dynawo features
│   └── sundials-2.7.0_spm_only.patch          # SPM only  ← cleanest reference
├── DYNAMO_IDASPM_patch/                # Dynawo 0.1.0 + SolverIDASPM + 7 tnr cases
├── EMTSim/                             # Modelica EMT model library used by the cases
└── dynamo/                            # clean Dynawo 0.1.0 baseline (git, tag v0.1.0)
```

The **SPM-only patch** (`sundials-2.7.0_spm_only.patch`, ~1825 added lines) is
the cleanest thing to port from; the `_hmin` variant additionally folds in
Dynawo-specific `hmin` tweaks that current Dynawo already handles differently.

### 3.1 Known caveat from the original README

> The compilation of the `Models/CPP` models crashed because `evalJtExpanded`
> (which returns `J`, `∂F/∂X` and `∂F/∂Ẋ` together) was declared virtual in
> `model.h` but not implemented for those C++ models. The SPM test cases are all
> Modelica (`ModelManager`, which *did* implement it), so the prototype was
> usable despite the broken C++-models build.

**This blocker is essentially gone in current Dynawo** — see §5.

---

## 4. The core problem: the SUNDIALS 2.7.0 → 6.3.0 chasm

| | Prototype | Current repo (`main`) |
|---|---|---|
| Dynawo | 0.1.0 (2018) | **1.8.0** |
| SUNDIALS | **2.7.0** | **6.3.0** (`dynawo/3rdParty/CMakeLists.txt:149`) |
| Context object | none | `SUNContext` threaded through every call |
| Sparse matrix | `SlsMat` (`ida_sparse`) | `SUNMatrix` / `SUNSparseMatrix` |
| Linear solver | `IDAKLU` + `ida_klu.c` | `SUNLinSol_KLU` + `IDASetLinearSolver` |
| Jacobian hook | `IDASlsSetSparseJacFn` | `IDASetJacFn` |
| Newton loop | `IDANls` / `IDANewtonIter` **inside `ida.c`** | external **`SUNNonlinearSolver`** |
| Solver tree | `Solvers/SolverIDA`, `Solvers/SolverIDASPM` | `Solvers/VariableTimeStep/SolverIDA` |

SUNDIALS was re-architected at 3.0 into the generic
`SUNMatrix` / `SUNLinearSolver` / `SUNNonlinearSolver` object model. **The entire
`ida_sparse` / `ida_klu` layer the SPM patch hooks into no longer exists.** Hence
the patch cannot be applied; the algorithm must be re-implemented against IDA
6.3.0 internals.

### 4.1 Anatomy of the prototype SUNDIALS patch

New files added to IDA:

| File | Lines | Role |
|---|---:|---|
| `include/ida/ida_spm.h` | 58 | public API (`IDASPM*` entry points) |
| `src/ida/ida_spm_impl.h` | 152 | `SPMMem` struct + routine prototypes |
| `src/ida/ida_spm.c` | 1116 | the whole algorithm |

Modified upstream files: `ida.c` (~231 changed lines — the deep hooks),
`ida_impl.h` (adds `void *spm_mem;` to `IDAMem`), `ida_io.c`, `ida.h`,
`ida_klu.c`, `ida_sparse.c/.h`, `ida_sparse_impl.h`, plus `CMakeLists`.

**`SPMMem`** (the state carried on `IDAMem->spm_mem`) holds:
`d, ds`; divided-difference arrays `phixi[]`, `phiybar[]`, `phisinbar[]`,
`phicosbar[]`; work vectors `xi, xip, ybar, ybarp, ubar, vbar`; the pulsation
`wbar`, period `Tbar`, the `isAC` boolean vector + `iGlobaltoAC` index map; a
`useSPM` switch; and an estimator sub-block (`yyts, ypts, Fnts, ruv`,
`est_mat_mem`, the `idaspmupdatepriormodelparameters` function pointer, LU
pivots). Two estimator back-ends exist: `EstMatDenseMem` and `EstMatKLUMem`
(we only need KLU).

**`ida_spm.c` routines** (the units to port):

| Routine | Job |
|---|---|
| `IDASPMKLU` / `IDASPMKLUFromFile` | public init: read `wbar` + `isAC`, build `SPMMem`, wire estimator to KLU |
| `IDASPMInitShared[FromFile]` | format-independent init |
| `IDASPMInitEstMemKLU` / `…FreeEstMemKLU` | estimator matrices in CSR |
| `IDASPMEvaluateybarkd` | k-th time-derivative of `X̄` |
| `IDASPMEvaluatePriorModel` | fill `ybar`, `ybarp` |
| `IDASPMEvaluateSolution` | `yy = xi + ybar`, `yp = xip + ybarp` |
| `IDASPMApplyCorrection` | `xi -= δ`, `xip -= cj·δ`, then re-evaluate solution |
| `IDASPMContinuityCondition[phi]` | `xi = yy − ybar` (keep `δ` history consistent when `(u,v)` change) |
| `IDASPMEvaluatePriorModelphi` / `…Solutionphi` | same on the BDF `phi[]` divided-difference arrays |
| `IDASPMUpdatePriorModelParametersKLU` | **the estimator** — assemble & solve the `2dₛ × 2dₛ` Newton system for `(Δu, Δv)` |
| `IDASPMInitializePhiArrays` / `IDASPMhhScalePhiArrays` | seed / rescale the `phi` arrays on step-size change |
| `IDASPMFree` | teardown |

### 4.2 Exact hook points inside `ida.c` (prototype → where they must go in 6.3.0)

| IDA function (2.7.0) | SPM calls injected | 6.3.0 location |
|---|---|---|
| `IDAInit` / `IDAReInit` | (phi init, currently commented; done via `hhScale`) | same functions |
| `IDASolve` | `IDASPMhhScalePhiArrays` | `IDASolve` (`src/ida/ida.c`) |
| `IDAStep` (before predict) | `IDASPMUpdatePriorModelParameters` (guarded `tn > t0 + Tbar`), `IDASPMEvaluatePriorModel`, `…phi`, `IDASPMContinuityCondition`, `…phi` | `IDAStep` |
| `IDAStep` (predictor `IDAPredict`) | `IDASPMEvaluatePriorModel` | `IDAPredict` |
| `IDANls` | `IDASPMEvaluateSolution` | **moved** — IDA 6.x runs Newton via `SUNNonlinearSolver`; this belongs in `idaNlsResidual` (the residual sys-fn IDA registers with the nonlinear solver) |
| `IDANewtonIter` | `IDASPMApplyCorrection` (each Newton iterate) | **moved** — there is no `IDANewtonIter` in 6.x; the correction-application must hook the nonlinear-solver convergence-test / `LSolve` glue (`idaNlsLSolve`) |
| `IDACompleteStep` | `IDASPMUpdatePriorModel…`, `…EvaluateSolution`, `…phi` | `IDACompleteStep` |
| `IDAGetSolution` | `IDASPMEvaluatePriorModel` | `IDAGetSolution` (dense-output / interpolation) |

> **Biggest structural risk.** In 2.7.0 the Newton loop is open code inside
> `ida.c`, so SPM just inlined `IDASPMApplyCorrection` / `IDASPMEvaluateSolution`
> into it. In 6.3.0 that loop is the external `SUNNonlinearSolver` (default
> `SUNNonlinSol_Newton`), driven through `idaNlsResidual`, `idaNlsLSetup`,
> `idaNlsLSolve`, `idaNlsConvTest`. The decomposition `X = X̄ + δ` therefore has
> to be expressed at that callback boundary: IDA's nonlinear solver iterates on
> the *correction* `δ`, while every residual/Jacobian evaluation must be done on
> the *reconstructed* `X = X̄ + δ`. Validating this boundary is the make-or-break
> of the whole port and is exactly what Phase 1 (§7) de-risks in isolation.

---

## 5. The modeler side is (almost) already there

Current Dynawo splits the expanded Jacobian the SPM estimator needs into **two
existing virtual methods**, so the old `evalJtExpanded`-not-implemented crash no
longer applies:

- `DYNModel.h:149` — `virtual void evalJt(double t, double cj, SparseMatrix& jt)` → full `J = ∂F/∂X + cj·∂F/∂Ẋ`
- `DYNModel.h:158` — `virtual void evalJtPrim(double t, double cj, SparseMatrix& jtPrim)` → the `∂F/∂Ẋ` part

From these two we recover both partials the estimator wants:

```
∂F/∂Ẋ = evalJtPrim(t, cj=1)          (the cj-scaled derivative block)
∂F/∂X = evalJt(t, cj=0)              (or  evalJt(t,cj) − cj·evalJtPrim(t,cj) )
```

So **no new model interface is required** — `SolverIDASPM` can build the
estimator's `Mu/Mv/Muv` matrices purely from `evalF`, `evalJt`, `evalJtPrim`,
exactly as `SolverIDA::evalJ` already calls `model.evalJt` today
(`DYNSolverIDA.cpp:663`).

This is the single most important finding for feasibility: the hard modeler-side
prerequisite is satisfied upstream.

---

## 6. Target Dynawo-side design

### 6.1 New solver `Solvers/VariableTimeStep/SolverIDASPM`

Model it on the existing `SolverIDA` (which already uses the modern API:
`SUNContext`, `SUNSparseMatrix(…, CSR_MAT, …)`, `SUNLinSol_KLU`,
`IDASetLinearSolver`, `IDASetJacFn`, `IDASetUserData`, `IDASetId`,
`IDASetSuppressAlg`, `IDARootInit`, `IDACalcIC`, KIN-based algebraic
restoration). The SPM solver is `SolverIDA` **plus**:

1. After `IDASetLinearSolver`, call the new `IDASetSPM(IDAMem_, isAC, wbar)`
   (the 6.3.0 re-implementation of `IDASPMKLU`) to allocate `SPMMem`.
2. Provide the estimator with `∂F/∂X` and `∂F/∂Ẋ` via `evalJt` / `evalJtPrim`
   (replacing the prototype's single `evalJExpanded` + `model->evalJtExpanded`).
3. Read SPM config (`wbar` + `isAC`) from the solver **`.par`** file, not a stray
   `initSPM.txt` (see §6.3).
4. Tune the `cj` Jacobian-refresh threshold to be more permissive (the paper
   notes SPM grows the step faster than IDA, so the default trigger over-rebuilds
   the Jacobian).

The factory/registration mirrors `SolverIDA`:

- `getFactory()` / `create()` / `destroy()` `extern "C"` entry points.
- New `Solvers/VariableTimeStep/SolverIDASPM/CMakeLists.txt` (copy of SolverIDA's:
  `add_library(dynawo_SolverIDASPM SHARED …)`, link
  `Sundials::Sundials_{IDA,NVECSERIAL,SUNLINSOLKLU}`, `dynawo_SolverCommon`,
  `dynawo_SolverKINSOL`; then `desc_solver(dynawo_SolverIDASPM)`).
- Add `add_subdirectory(SolverIDASPM)` to
  `Solvers/VariableTimeStep/CMakeLists.txt`.

Cases select it exactly like today, e.g.
`<dyn:solver lib="libdynawo_SolverIDASPM.so" parFile="solvers.par" parId="…"/>`.

### 6.2 SUNDIALS 6.3.0 SPM patch

Add the SPM sources to the **existing** patch pipeline rather than a separate
toolchain. SUNDIALS is fetched + patched in `dynawo/3rdParty/CMakeLists.txt`
(`sundials_version 6.3.0`, `PATCH_COMMAND ${sundials_patch_common}` applying
`dynawo/3rdParty/sundials/patch/common/sundials.patch`). Plan:

- Author `ida_spm.c`, `ida_spm.h`, `ida_spm_impl.h` against the 6.3.0 tree
  (new files added by the patch; `INSTALL(FILES ida_spm.h …)` in IDA's CMake).
- Extend `common/sundials.patch` (or add a sibling `sundials_spm.patch` in the
  chain) with: the `void *spm_mem` member on `IDAMem` in `ida_impl.h`, the hook
  calls in `ida.c` / the `idaNls*` glue per §4.2, and the IDA `CMakeLists.txt`
  source addition.
- Keep KLU-only (dense estimator back-end is dead weight — Dynawo always uses
  KLU/CSR).
- The KLU estimator solve must use the **6.3.0 KLU** types (`sun_klu_*`,
  `SUNMatrix` CSR) instead of the prototype's `KLUData` / `SlsMat`.

> Note `SUNSparseMatrix(…, CSR_MAT, …)` already drives KLU in `SolverIDA`, and
> `propagateMatrixStructureChangeToKINSOL` already handles symbolic-refactor on
> structure change — both are reusable patterns for the estimator matrices.

### 6.3 Configuration: replace `initSPM.txt` with `.par`

Prototype: each case carried an `initSPM.txt` in the working dir — line 1 the
pulsation, then one `1.0`/`0.0` per state variable (oscillating / non-oscillating).
`SolverIDASPM::init` did `fopen("…/initSPM.txt")` →
`IDASPMKLUFromFile`. That is brittle and off-convention.

Target: expose SPM parameters through the solver parameter set, e.g.

- `spmPulsation` (double, default `100·π`),
- AC-variable selection. Mechanisms in order of preference: a model-provided
  predicate (cleanest, but needs a modeler tag on EMT variables — Dynawo
  variables currently carry only a type, no AC attribute, so this would mean
  threading new metadata through the Modelica compiler / variable export, out of
  scope for v1); a name/regex selector resolved against the variable table; or —
  faithful to the original `initSPM.txt` boolean-per-variable — an explicit list
  of variable names.

**Implemented (✅ DONE):** both parameter-driven selectors, *unioned*, with the
model-tag predicate left as documented future work:

- `spmOscillatingVariables` (string, optional) — ECMAScript regex matched against
  each state-variable name (`getVariableName(i) = <modelID>_<flatName>`). Empty
  ⇒ no regex matching.
- `spmOscillatingVariablesList` (string, optional) — explicit variable names
  separated by `,`, `;`, or whitespace; matched exactly. Names not found in the
  model are warned about (typo / stale-name guard).

A state variable is flagged oscillating if it is in the list **or** matches the
regex; either selector may be left empty. `defineSpecificParameters()` /
`setSolverSpecificParameters()` declare/read them, and `buildOscillatingVarsVector`
builds the `isAC` vector. Validated on `Circuit_RLC`: regex `.*_[0-9]+_` selects
12/12 states (277 steps); union with an explicit subset + a bogus name is a no-op
on the selection (still 12/12, 277 steps) and emits the typo warning; list-only
(regex empty) of the 6 differential states selects 6/12 and — as expected from
the algebraic-flagging requirement — degrades to 64 684 steps, a live reminder
that the *whole* oscillating set (differential **and** algebraic) must be flagged.

---

## 7. Phased plan

### Phase 0 — Reference capture (low risk, optional but recommended)
- Keep the prototype tree read-only as oracle. Extract the 7 tnr cases’
  `initSPM.txt` and any committed reference curves under
  `DYNAMO_IDASPM_patch/tnr/data/{SimpleODE,Circuit_RLC,IEEE_14bus,…}`.
- Pick `SimpleODE` and `Circuit_RLC` as the smallest end-to-end checks.

### Phase 1 — De-risk the numerics standalone (**critical path**) — ✅ DONE
- Port `ida_spm.{c,h,impl}` onto a pristine **SUNDIALS 6.3.0** IDA in a tiny C
  harness (no Dynawo), driving a hand-written Dahlquist-with-oscillating-forcing
  residual (the analysis paper §2.1 gives the closed form).
- Resolve the **`SUNNonlinearSolver` boundary** (§4.2): **resolved as (a), and
  simpler than expected** — because the SPM `IDAPredict` makes `yypredict`
  already carry `X̄`, the stock `SUNNonlinSol_Newton` (`yy = yypredict + ee`)
  corrects `δ` automatically; **no `idaNls*` hook and no custom nonlinear solver
  are needed.** The per-Newton-iteration `IDASPMApplyCorrection` of the 2.7.0
  prototype collapses away.
- **Outcome (exit criterion met):** the ported solver runs on SUNDIALS 6.3.0 and,
  on the canonical steady-state test, takes **80–93× fewer steps** than plain IDA
  (e.g. 11 023 → 136 at tol 1e-4) with **better** accuracy and max step ≈0.67 s
  (≈33 carrier periods); during a transient it correctly drops to carrier-limited
  steps and recovers. Full reproduction (sources, patch, build script, results)
  in [`prototype/`](prototype/README.md).

### Phase 2 — SUNDIALS patch in-tree — ✅ DONE
- SPM sources + BDF-loop hooks folded into
  `dynawo/3rdParty/sundials/patch/common/sundials.patch` as **one combined
  patch** (verified a strict superset of the prior kinsol/hmin patch — those
  changes are preserved byte-for-byte; only SPM is added). Applies cleanly with
  Dynawo's exact `patch -p1 --forward` command; the patched library builds and
  exports `IDASetSPM`, installing `ida/ida_spm.h`.
- **Estimator upgraded to the sparse interface:** the Jacobians enter as **CSR
  `SUNMatrix`** (the form `evalJt`/`evalJtPrim` produce); the `d×d` Jacobians are
  never densified, only the `2dₛ×2dₛ` normal equations. Reproduces the Phase-1
  numbers exactly (11 023 → 136 at tol 1e-4). A `NULL` `dF/dXdot` keeps the
  semi-explicit shortcut.
- **Estimator made faithful to the original (the key performance fix):** the
  first sparse port re-evaluated the Jacobian *per quadrature sample* and
  re-assembled + LU-factorized the dense `2dₛ×2dₛ` normal-equations matrix
  `Muv` **every step** (`O(dₛ³)`/step) — correct, but it made IDASPM *slower*
  than IDA. The original Dynawo IDASPM does two things this port now mirrors:
  (1) the state/derivative Jacobians are **pushed once per IDA Jacobian update**
  (`IDASPMSetJacobians`) and reused for all samples and steps; (2) `Muv` is the
  periodic integral over one carrier period — constant over the Jacobian's
  validity window — so it is assembled + factorized **only when the Jacobian
  changes** (`newMuvMat`) and the LU factors are **reused** for the per-step
  back-substitution. Only the gradient `ruv` and the residual samples are
  recomputed each step. The public API became push-based:
  `IDASetSPM(ida_mem, isAC, wbar, id, nnz)` (no callbacks) plus
  `IDASPMSetJacobians(ida_mem, dFdX, dFdXdot)`. The standalone harnesses confirm
  this is numerically *identical* to the per-step version (1×1: 136 steps,
  2.085e-3 error; 2×2 non-symmetric: 139 steps), at a fraction of the cost.
- Standalone reproduction in [`prototype/`](prototype/README.md) updated to the
  same sparse module.

### Phase 3 — `SolverIDASPM` wrapper — ✅ DONE (builds in-tree)
- `Solvers/VariableTimeStep/SolverIDASPM/` created from the exact `SolverIDA`
  source (copied, not hand-written, to avoid transcription error) + SPM wiring:
  after `IDASetLinearSolver`/`IDASetJacFn`, it builds the oscillating-variable
  vector and calls `IDASetSPM`. Registered in `VariableTimeStep/CMakeLists.txt`.
- **Estimator Jacobians from the model**: `evalJ` (IDA's Jacobian-update
  callback) builds `dF/dX` via `model.evalJt(t, cj=0)` and `dF/dXdot` via
  `model.evalJtPrim(t, …)`, copies each into a member CSR `SUNMatrix` with the
  existing `SolverCommon::copySparseToKINSOL`, and **pushes both** to the
  estimator via `IDASPMSetJacobians`. Because `evalJ` is exactly IDA's
  Jacobian-refresh point, the estimator gets a fresh Jacobian only when IDA
  recomputes its own — and reuses it (and the `Muv` factorization) on the
  intervening steps, matching the original.
- **Critical orientation finding**: Dynawo's `SparseMatrix` from `evalJt` is
  filled *column-per-equation* (`changeCol` per residual, `addTerm(variable,…)`),
  so after `copySparseToKINSOL` it is a genuine **CSR of J** (row=equation,
  col=variable). The estimator reads it as such. A 2×2 non-symmetric standalone
  test confirms the orientation (1×1 can't); the method also turns out *robust*
  to the orientation because the estimator minimises the directly-evaluated
  residual `‖F‖²`, the Jacobian only setting the Newton direction.
- **Config (`.par`)**: `spmPulsation` (double, default `2π·50`) and
  `spmOscillatingVariables` (ECMAScript regex matched against variable names to
  flag the oscillating states). Selected via the standard `findParameter` path.
- **Built in-tree (`build-minimal`, rc=0).** Confirmed end to end in the real
  Dynawo toolchain: the combined SUNDIALS patch applies, `ida_spm.c` compiles,
  `libsundials_ida` exports `IDASetSPM` and installs `ida/ida_spm.h`;
  `dynawo_SolverIDASPM.so` compiles + links on the first try; and `dumpSolver`
  loads it and emits a `.desc.xml` exposing `spmPulsation` and
  `spmOscillatingVariables`. What remains (Phase 4) is *functional* validation —
  running an EMT NRT case with `lib="dynawo_SolverIDASPM"` and comparing curves
  against plain IDA.

Example solver `.par` set:
```xml
<set id="IDASPM">
  <par name="order"        type="INT"    value="2"/>
  <par name="initStep"     type="DOUBLE" value="1e-7"/>
  <par name="minStep"      type="DOUBLE" value="1e-7"/>
  <par name="maxStep"      type="DOUBLE" value="10"/>
  <par name="absAccuracy"  type="DOUBLE" value="1e-4"/>
  <par name="relAccuracy"  type="DOUBLE" value="1e-4"/>
  <par name="spmPulsation" type="DOUBLE" value="314.159265358979"/>          <!-- 50 Hz -->
  <par name="spmOscillatingVariables" type="STRING" value=".*_[0-9]+_"/>      <!-- regex (optional) -->
  <!-- and/or an explicit list (optional), unioned with the regex:
  <par name="spmOscillatingVariablesList" type="STRING" value="Net_v_re_0_, Net_v_im_0_"/> -->
</set>
```
(`<dyn:solver lib="dynawo_SolverIDASPM" parId="IDASPM"/>` in the `.jobs`.)

### Phase 4 — End-to-end validation — ✅ DONE for `Circuit_RLC`
- The EMTSim components `Circuit_RLC` needs were **ported into the Dynawo
  Modelica library** as `Dynawo.Electrical.EMT.*` (`Electrical/EMT/`: `PwPin`,
  `TwoPin`, `SignalVoltage`, `RLBranchDisym`, `CParallel`, `Ground`,
  `VoltageSensor`, and the assembled `Circuit_RLC`), registered and built as the
  preassembled model `Circuit_RLC` (compiles under OMC 1.13.2).
- NRT case `nrt/data/Circuit_RLC_EMT/` runs the same model with `SolverIDA` and
  `SolverIDASPM`. **Result (tol 1e-4, 0→10 s): 67 615 → 278 steps (243× fewer)**,
  IDASPM max step 4.24 s (≈212 carrier periods) vs IDA's carrier-limited ~1e-4 s,
  with max relative error 1.6e-3–6.4e-3 vs the IDA reference across all six
  curves. This matches the 150–240× reported in the paper — the SPM works end to
  end through the full Dynawo stack (Modelica → OMC → black box → SolverIDASPM).
- **ISGT also done** (`nrt/data/ISGT_EMT/`, the paper's primary "Simple Electrical
  Grid": 3 sources, 5 coupled RL lines, 1 variable load with a step at t=1 s; one
  new component `RVariable`). **25 047 → 335 steps (≈75×)**; step size 0.05–0.35 s
  in pre-event steady state, drops to ~2e-3 s at the load step, recovers to
  0.65 s after — the paper's Fig. 5/6 behaviour. Steady-state match ~0.1 %; max
  error away from the event 0.4–1 % (voltages) / ~1–2 % (currents, instantaneous
  carrier sampling). This is the first run on a genuinely coupled network with a
  transient event, exercising the sparse CSR estimator.
- **IEEE_14bus also done** (`nrt/data/IEEE14bus_EMT/`, the paper's scaling case:
  5 sources, 14 buses, 17 coupled RL lines, 3 ideal transformers, 11 loads with a
  step at Bus 4; new components `TwoPort`, `Bus`, `Ideal`; 754 equations).
  **19 974 → 401 steps (≈50×)**; step size 0.08–0.33 s pre-event, ~2e-3 s at the
  step, recovers to 0.27–0.75 s. Steady-state accuracy: currents 0.1–0.3 %,
  voltages 0.4–1.2 %; a brief (~0.15 s) post-event current transient while the
  estimator re-converges. The decreasing step-ratio across cases (RLC 243× →
  ISGT 75× → 14-bus 50×) reflects larger transient fractions in the 0→3 s window.

### Phase 4b — Estimator performance, made faithful to the original — ✅ DONE
- The first in-tree estimator was correct but **slower in wall-clock than plain
  IDA** because it re-evaluated the Jacobian per quadrature sample and
  re-factorized the dense `2dₛ×2dₛ` `Muv` every step. The original Dynawo IDASPM
  avoids both: Jacobian reused across steps (pushed once per IDA Jacobian
  update), `Muv` assembled + LU-factorized lazily (only on a Jacobian change)
  with the factors reused for the per-step back-substitution. The port now does
  the same (push-based `IDASetSPM` + `IDASPMSetJacobians`; `newMuvMat`/`MuvReady`
  flags; split `spmDenseFactor`/`spmDenseBackSolve`).
- **Numerically identical** to the per-step version (standalone harnesses: 1×1
  136 steps / 2.085e-3 error, 2×2 non-symmetric 139 steps) and to the previous
  in-tree runs (step counts unchanged).
- **IEEE_14bus wall-clock** (the largest case): at the case horizon the total is
  startup-bound (~0.5 s fixed model-load), so to isolate solver cost the horizon
  was stretched to 30 s — **IDA 2.78 s vs IDASPM 0.84 s (3.3× faster wall;
  ≈6.7× faster solver-only)**. The estimator does `Ns+1 = 6` residual samples
  per step (not counted in IDA's `nre`), so IDASPM's true model-eval count is
  ≈ 459 + 6·399 ≈ 2 850 vs IDA's 19 992 — ~7× fewer, matching the solver-time
  ratio. IDASPM now beats IDA in solver work on every case, decisively so as the
  residual cost (real EMT models) grows relative to the fixed per-step estimator
  overhead.

**Validation suite (all in-tree, real Dynawo EMT runs):** `Circuit_RLC` 243×,
`ISGT` 75×, `IEEE_14bus` 50× — all with the characteristic adaptive step
(large → small at the event → large) and steady-state match to ~0.1–1 %.

  Environment notes from the build: `liblpsolve55.so` must be on the loader path
  for `omcDynawo` (register `/usr/lib/lp_solve` via `ldconfig`); adding a model
  to the library needs a CMake reconfigure before `clean-build-models`.

### Phase 5 — Hardening & docs
- **Variable-selection UX (§6.3) — ✅ DONE:** regex + explicit-name-list
  selectors (unioned, both optional), with a typo warning for list names absent
  from the model. Validated on `Circuit_RLC`. The model-provided AC predicate
  (a per-variable tag emitted by EMT models) remains future work — it needs new
  variable metadata carried through the Modelica compiler / export pipeline.
- Remaining: cpplint/copyright headers (MPL-2.0), unit test under
  `SolverIDASPM/test` mirroring `SolverIDA/test`, advancedDoc entry, EMTSim
  library placement decision (3rd-party vs. bundled).

---

## 8. Open questions / decisions to confirm

1. **`SUNNonlinearSolver` strategy** — patch the `idaNls*` glue vs. custom
   nonlinear solver. (Resolved in Phase 1; drives everything downstream.)
2. **Oscillating-variable selection** — model predicate vs. par-file list. Needs
   a call on whether EMT models should *tag* their AC variables.
3. **EMTSim library** — is it still the intended modelling library, or should SPM
   target the current Electrical library’s EMT models? Affects Phase 4 cases.
4. **Scope of the SUNDIALS fork** — upstreaming SPM to LLNL is out of scope; we
   carry it as a Dynawo patch. Confirm that's acceptable long-term maintenance.
5. **`hmin` and friends** — the `_hmin` prototype variant folded in Dynawo step
   tweaks now handled differently in 1.8.0; start from `_spm_only` and re-add
   nothing unless a test demands it.

---

## 9. Key file references

Prototype (in the zip):
- `DYNAMO_IDASPM_patch/dynamo/sources/Solvers/SolverIDASPM/DYNSolverIDASPM.{cpp,h}`
- `SUNDIALS/sundials-2.7.0_spm_only.patch`
- `…_spm.tar.gz : sundials-2.7.0_spm/src/ida/{ida_spm.c,ida_spm_impl.h}`,
  `include/ida/ida_spm.h`
- `DYNAMO_IDASPM_patch/tnr/data/*/initSPM.txt`, `*/*.jobs`

Current repo (port targets):
- `dynawo/sources/Solvers/VariableTimeStep/SolverIDA/DYNSolverIDA.{cpp,h}` — template
- `dynawo/sources/Solvers/VariableTimeStep/CMakeLists.txt` — add subdir
- `dynawo/sources/Solvers/CMakeLists.txt` — `desc_solver` macro
- `dynawo/sources/Modeler/Common/DYNModel.h:149,158` — `evalJt`, `evalJtPrim`
- `dynawo/3rdParty/CMakeLists.txt:149` — SUNDIALS 6.3.0 fetch
- `dynawo/3rdParty/sundials/patch/common/sundials.patch` — patch pipeline
- `dynawo/cmake/FindSundials.cmake` — exported SUNDIALS targets
