# Recovered EMTSim cases (from OMC compiler-log dumps)

The original IDASPM zip shipped 7 `tnr` cases but the EMTSim **source** models for
4 of them (`SimpleODE`, `IEEE_5bus`, `IEEE_5bus_Split`, `GFf_Load_InfBus`) were
not included — only the OMC *instantiated-model* dump survives inside each case's
`outputs/.../logs/dynamoCompiler*.log` (a fully flattened `class <Name>_test … end`).

This directory holds work to recover those models from the log dumps.

## `recover_gff.py` — GFf_Load_InfBus recovery pipeline

Turns the raw `dynamoCompiler.log` dump of `EMTSim.Examples.GFf_Load_InfBus`
(a dual grid-forming / grid-feeding converter case, ~1870 flat lines) into
compilable Modelica. Each transform was driven by an actual compiler error:

1. extract the `class GFf_Load_InfBus_test` block, de-escape the JSON wrapper
2. repair the one injected OMC error that split `converter_Grid_Forming1` mid-token
3. drop 13 unused `enumeration` init-type params (removes the `Modelica.Blocks.Types.Init` dep)
4. strip 400 non-standard per-declaration `protected` prefixes
5. mangle dotted instance names (`X.Bus1.p.v[1]` → `X_Bus1_p_v[1]`)
6. parenthesize unary-minus-after-operator (`a + -b` → `a + (-b)`)
7. coalesce element-wise array / 2D-matrix declarations into proper arrays
   (`Real x[3] = {…}`, `Real M[3,3] = {{…}}`)
8. drop `assert()`s (OMC-internal `String()` overload), `mod(θ,2π)` angle-wraps
   (redundant before sin/cos), and `homotopy()` / `smooth()` hints
9. force `fixed = true` initialization on the 13 differential states (the dump
   gives `start` but not `fixed`; the original set this via the `Modelica.Blocks`
   `initType` dropped in step 3)
10. expand integer powers `x^2.0` → `(x*x)`, `x^(-2.0)` → `1/(x*x)` (Dynawo's
    codegen emits a non-compiling `threadData`-taking power function otherwise)

Output: `GFf_Load_InfBus.mo` (+ `GFf_Load_InfBus.xml` preassembled binding).

### Status: model COMPILES to a .so; case runs to global initialization

The recovered model **compiles** through Dynawo's full chain (OMC front-end +
backend + Dynawo codegen) and produces an installable `GFf_Load_InfBus.so`.
The dump came from the **old Dynawo's** `dynamoCompiler.log`, so the model *had*
compiled through this chain before — the earlier "inherent high-index" reading
was wrong. The real blockers, and their fixes:

| Blocker | Root cause | Fix |
|---|---|---|
| `mixed-determined [index > 3]` | OMC's **default cap** of 3 on the mixed-determined index; the converter init exceeds it (it can still solve those loops numerically in daeMode) | raise the cap: `--maxMixedDeterminedIndex=100` in `DYNCompileModelicaModel.cpp runOptions()` |
| limiter "Failed to solve", spurious init loops | collapsing `homotopy(actual, simplified)` → `actual` removed the operator OMC uses to build a solvable **initialization** system | keep `homotopy()`/`smooth()` (do NOT collapse them) |
| `real_int_pow` C++ `threadData` mismatch | OMC re-folds `1/wn_i^2` in `Ti_i` into the integer-power runtime fn whose `threadData` signature Dynawo's codegen strips | inline the constant `Ti_i` to its evaluated value |
| unbound parameters at run | converter init inputs (`init_theta_e_rad`, `F_cal_Q0_pu`) had no value in the flatten | supply them in the case `.par` |

Earlier mechanical fixes (steps 1–8, 10) still apply; the `fixed=true` injection
(an earlier wrong guess) was removed.

**Remaining (runtime, not compile):** the case reaches Dynawo's *global
initialization* and reports `variables number 196 != equations number 200` —
the generated daeMode system is over-determined by exactly 4. The
**model itself is registered and compiles**; this is the last item to make the
case *run*.

### daeMode diagnosis — the precise 4 surplus equations

Dynawo always compiles Modelica with OMC's `+daeMode` (see
`DYNCompileModelicaModel.cpp runOptions()`); there is no non-daeMode path in
the current chain. The old Dynawo (0.1.0) that produced this dump used the
classic non-daeMode chain, where OMC ran full causalization + **index
reduction + dynamic state selection**, collapsing the structures below. daeMode
keeps the DAE in residual form and instead *counts*: it expects
`nbF == nbVars`. For this model the counts are `nbVars = 196`, `nbF = 200`.

A maximum bipartite matching of the 200 generated residuals against the 196
real variables (built directly from the `realVars[k]`/`derivativesVars[k]`
references and their `STATE`/`variable`/`STATE_DER` tags in
`GFf_Load_InfBus_Dyn.cpp::setFomc`) matches **196** and leaves **4** equations
unmatchable. The Dulmage–Mendelsohn over-determined block is **29 eqs / 25
vars (surplus 4)** and lies *entirely inside the `Grid_Feeding1` converter's
grid interface*. The 4 surplus are:

| # | residual | what it is |
|---|---|---|
| 1–3 | `$DAEres38/27/2` (phases 1-3) | `Grid_Feeding1` `RL_converter` branch eqs — `der(RL_converter_i[k])` |
| 4 | `$DAEres10` | `Grid_Feeding1` PLL `Park_PLL` rotation / Concordia constraint |

**Root cause (series inductors through a zero-current sensor).** The
grid-feeding converter reaches the infinite bus as
`Conv → RL_converter → [V_Sensor node, i = 0] → RL3 line → sineVoltage1`.
Because the voltage sensor draws no current, the only two branches at that node
are the two inductors *in series*, so OMC aliases their currents to one state
(`RL3_i ≡ RL_converter_i`) — yet **both** inductor branch equations survive,
giving two `der(i)` equations for one state (3 phases → 3 surplus). The PLL
Park transform on that same zero-current sensed voltage contributes the 4th
(redundant) rotation constraint. In non-daeMode this is exactly what index
reduction / state selection eliminates.

The grid-**forming** converter in the *same* model is **not** over-determined:
it carries a shunt filter capacitor `C_converter` whose voltage is a genuine
state (`RL_converter_v = Conv_VSource_v − C_converter_p_v`), so its node voltage
is independent and no current aliasing occurs.

**Fix path (to make the case run).** Give the grid-feeding converter's PCC the
same independent node voltage the grid-forming side already has — i.e. a small
shunt capacitance at the `V_Sensor` node (an LC/LCL output filter). That
de-aliases `RL_converter_i` from `RL3_i` (removing the 3 series-inductor
surplus) and turns the sensed voltage into a state (removing the PLL Park
redundancy), making the daeMode system square. This is a topology change to the
flattened model and changes the physics slightly, so it is left for a
follow-up rather than baked into the mechanical recovery.

To regenerate: point `recover_gff.py` at the case's `dynamoCompiler.log` and run.

## Note on the other unported cases
- `SimpleODE` — a scalar oscillating ODE; already reproduced as the Phase-1
  Dahlquist standalone harness.
- `IEEE_5bus` — **recovered and runs to completion** (`recover_ieee5.py`,
  `nrt/data/IEEE_5bus_EMT`). It is not strictly passive — it has one grid-feeding
  converter (`GridFeeding2`) — but the converter sits on a **meshed bus**, not a
  radial line behind a zero-current sensor, so it has none of GFf's series-inductor
  daeMode singularity: the recovered model is square and runs as-is under both IDA
  and IDASPM, matching the reference to ~1 % on bus voltages. This is the first
  recovered EMTSim case running end-to-end. The four `PQLoad`s here are the same
  load type ported as `Dynawo.Electrical.EMT.PQLoad`.
