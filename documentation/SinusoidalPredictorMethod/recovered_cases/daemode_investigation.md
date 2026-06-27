# How Dynawo's daeMode works, and why GFf_Load_InfBus is over-determined by 4

This note records an investigation of Dynawo's daeMode Modelica pipeline, prompted
by the `variables number 196 != equations number 200` error on the recovered
`GFf_Load_InfBus` converter case. It explains the mechanism end-to-end and pins
the exact failure.

## 1. Dynawo always uses OMC `+daeMode`

`DYNCompileModelicaModel.cpp::runOptions()` unconditionally passes `+daeMode` to
OMC; there is **no non-daeMode path** in the current chain. The old Dynawo
(0.1.0) that produced this case's flat dump used the *classic* OMC chain (full
causalization → index reduction → dynamic state selection → an explicit ODE/DAE
in state-space form). daeMode is a different contract, described next.

## 2. What OMC emits in daeMode

In daeMode OMC does **not** causalize the whole model. It splits the flattened
equations into two groups (visible in the generated `<Model>_Dyn.cpp`):

- **Assignments** — `var = expr(...)` for variables it could solve explicitly.
  For GFf there are **120** of these (each `f[i] = var - (expr)`).
- **Residuals** — `$DAEres_k = expr(...)` for the implicit part (states and the
  algebraic loops it left for the numerical solver). For GFf there are **80**
  (`daeModeData->nResidualVars = 80`), plus 2 common-subexpression
  `auxiliaryVars` that are *not* counted as variables.

A standalone OMC `+daeMode` run of the same model emits the **same 80 residuals**
— so the residual count is OMC's, not Dynawo's.

OMC's reduced daeMode system is square in OMC's own bookkeeping: its 80 residuals
act on 80 unknowns **with the 120 assignments inlined**. The squareness lives in
that *substituted* form.

## 3. How Dynawo reconstructs and counts the system

Dynawo does **not** keep OMC's reduced 80×80 form. In `factory.py` it rebuilds
the *full* system: it gathers the equation that evaluates every system variable
(`list_vars_syst` + der vars + residual vars + kept auxiliaries), numbers them
(`nb_eq_dyn`), and emits them all as `f[0..nbF-1]`:

```
nbF   = get_nb_eq_dyn()                                  # factory.py: all eqs
nbVars = len(list_vars_syst) - len(auxiliary_vars_counted_as_variables)
        # modelWriter.py:511-512
```

So the full residual vector is **120 assignments + 80 residuals = nbF = 200**,
against **nbVars = 196** real variables.

For a *well-behaved* model these are equal, because the 120 assignments define
120 distinct variables and the 80 residuals define 80 **more** (states + pure
algebraics) → 200 variables for 200 equations. The squareness is recovered by
the variable/equation counts matching one-for-one.

The only mechanism Dynawo has to remove a surplus differential residual,
`readerOMC.remove_fictitious_fequation()`, fires **only** for variables declared
in a model's `.extvar` file (`fictive_continuous_vars_der` is populated solely by
`read_eq_fictive_xml()`). No EMT model here has an `.extvar`, so this mechanism
is inert for all of them — yet ISGT and IEEE_14bus are square and run. The
counting balance is therefore a property of each model's topology, not of this
removal step.

## 4. Where GFf breaks: 4 surplus, all in the grid-feeding interface

A maximum bipartite matching of GFf's 200 residuals against its 196 variables
(see `diagnose_daemode_surplus.py`) matches **196** and leaves **4**
unmatchable. The Dulmage–Mendelsohn over-determined block is **29 eqs / 25 vars
(surplus 4)**, lying entirely in `Grid_Feeding1`'s connection to the grid:

| # | residual | meaning |
|---|---|---|
| 1–3 | `$DAEres38 / 27 / 2` (phases) | `RL_converter` branch eqs, `der(RL_converter_i[k])` |
| 4 | `$DAEres10` | a redundant PLL `Park_PLL` rotation / Concordia constraint |

Root cause: the grid-feeding converter reaches the infinite bus through a chain
`Conv → RL_converter → [V_Sensor node, i = 0] → RL3 line → sineVoltage1`. The
voltage sensor draws **no current**, so the node has only the two inductors in
series. OMC aliases the two currents to one state (`RL3_i ≡ RL_converter_i`),
removing the variable `RL3_i` — but **both** inductor branch equations
(`RL_converter` and `RL3`, with different R, L) survive as residuals. That is
two `der(i)` equations for one surviving state, per phase → 3 surplus. The PLL
Park transform reading the same zero-current voltage supplies the 4th
(redundant) rotation constraint.

The grid-**forming** converter in the *same* model is square: it carries a shunt
filter capacitor `C_converter` whose voltage is a genuine state, so its PCC node
voltage is independent and no current aliasing occurs
(`RL_converter_v = Conv_VSource_v − C_converter_p_v`, a state — visible in
`f[2]`).

## 4b. Ruling out aliasing: the `--useAliasing false` experiment

Dynawo can compile a model with alias elimination switched off
(`<dyn:modelicaModel ... useAliasing="false">`, which adds
`--preOptModules-=comSubExp,removeSimpleEquations` in `runOptions()`; it is
exercised by `ModelicaCompiler/test/Test.cpp` as `compilationNoAlias`). If the
surplus came from OMC aliasing `RL3_i ≡ RL_converter_i` while keeping both
inductor equations, turning aliasing off — which keeps `RL3_i` as its own
variable — should rebalance the counts.

It does **not**. Rebuilt with `useAliasing="false"`, the case reports
`variables number 730 != equations number 734` — still **over-determined by
exactly 4**. Alias elimination only un-collapses ~534 trivial `a = b` pairs (196
→ 730 variables); the +4 imbalance is invariant, because keeping `RL3_i` also
keeps its defining KCL equation `RL_converter_i = RL3_i`, so a variable *and* an
equation are added together.

Conclusion: the 4-surplus is a genuine **structural (high-index) singularity**
of the flattened model — two series inductances meeting at a zero-current node —
not an artifact of alias collapsing. This is exactly the case that **index
reduction / dynamic state selection** resolves (by differentiating the coupling
constraint and introducing dummy derivatives); OMC's `+daeMode` does not run it,
the classic non-daeMode chain old Dynawo used did. (The experiment was reverted;
the model is built with default aliasing.)

## 5. Why it ran in old Dynawo, and the fix

Old Dynawo's non-daeMode chain ran index reduction + dynamic state selection,
which collapses exactly this structure (it would pick one current as the state
and re-causalize the second inductor equation to define an algebraic node
voltage, and eliminate the PLL redundancy by alias). daeMode skips that and
relies on the variable/equation counts already balancing — which they do not for
this topology.

Two ways forward:

- **Model fix (makes the case run):** give the grid-feeding converter's PCC the
  independent node voltage the grid-forming side already has — a small shunt
  capacitance (LC/LCL output filter) at the `V_Sensor` node. That de-aliases
  `RL_converter_i` from `RL3_i` (removing the 3 series-inductor residuals) and
  turns the sensed voltage into a state (removing the PLL Park redundancy),
  making the daeMode count square. It is a topology change that slightly alters
  the physics, so it is a deliberate follow-up rather than part of the
  mechanical log recovery.

- **Pipeline fix (general):** teach the daeMode importer to detect a
  structurally over-determined differential pair from two series inductances
  sharing an aliased current (a zero-current node) and drop/repurpose the
  surplus residual — i.e. reproduce the index reduction daeMode skips. This is a
  larger change to `factory.py`/`readerOMC.py` and out of scope here.

## 5b. Validating the model fix: the shunt-capacitor experiment

The model fix was implemented and tested directly. A shunt capacitor was added
to the grid-feeding converter at its PCC node (the `RL_converter_n` /
`V_Sensor_p` node), mirroring the grid-forming converter's `C_converter`. Per
phase (3 phases), the flat model gains:

```
// declarations
Real  ..._Grid_Feeding1_C_converter_p_v[3];   // PCC node voltage -> becomes a state
Real  ..._Grid_Feeding1_C_converter_p_i[3];
parameter Real ..._Grid_Feeding1_C_converter_C = Cpu / (Zb * wb);
// equations
..._C_converter_p_i[k] = der(..._C_converter_p_v[k]) * ..._C_converter_C;  // i = C dv/dt
..._C_converter_p_v[k] = ..._RL_converter_n_v[k];                          // cap across the PCC node
// and  + ..._C_converter_p_i[k]  added to the node-A KCL (V_Sensor_p_i - p_i + RL_converter_n_i = 0)
```

This adds 6 variables and 6 equations (balanced) per the 3 phases.

**Structural result — confirmed.** The `196 != 200` error is **gone**. The
recovered case now compiles, and **local + global initialization succeed** (the
daeMode counts are square). This validates both the diagnosis and the fix: the
4-surplus was the series-inductor / zero-current-node high-index singularity, and
giving the node its own capacitor state removes it.

**Time-domain result — partial.** Integration then starts and runs. It is
sensitive to the (fictitious) capacitance value, which sets the new node's
dynamics — there is no original filter design in the flattened dump to copy, so
it must be chosen:

| Cf (pu) | LC resonance | reached |
|---|---|---|
| 0.066 | ~250 Hz (fast, stiff node) | t ≈ 0.0008 s |
| 0.66  | ~80 Hz | **t ≈ 0.15 s** (energization transient, currents build toward rated) |
| 2.0   | ~45 Hz (huge inrush) | t ≈ 0.0008 s |

`Cf = 0.66 pu` is the best; the relation is non-monotonic (too small → stiff
fast node; too large → energization inrush saturates the converter limiters
immediately). With the clean undamped form the PCC node voltage is a genuine
state, which is what makes it integrate.

**Damping does not help in daeMode (Dynawo first-step limitation).** Three
damper topologies were tried to damp the L-C resonance that grows the currents
into the stall at ~0.15 s: (a) a series-R snubber on the capacitor, (b) the same
with the redundant node variable removed, and (c) a textbook **RC parallel
damper** (a pure C keeping the node a state, plus a separate series Rd-Cd branch
in parallel). All three pass local + global initialization but **stall on the
very first integration step** (`h ≤ 1e-6`), and this is **independent of the
damping magnitude** — light damping (`Rd = 0.1·Z0`) stalls identically to
`Rd = Z0`. The common factor is the extra capacitor *state* coupled to the node
through an algebraic `Rd` relation: Dynawo's IDA cannot take the first step on
it even though `IDACalcIC` reports a consistent initial point. The undamped
pure-C form (no `Rd` relation) is the only one that integrates. So damping the
resonance is blocked at the solver level, not by filter design — making a clean
full run require either the original EMTSim filter parameters or solver-side work
on the daeMode initial step.

**Conclusion.** The shunt fix is the right structural remedy (confirmed: square +
initializes + integrates). A full 10 s run needs a proper LCL-filter + damper
design matched to the converter's current-control bandwidth (`wn_i ≈ 48 Hz`) and
PLL (`50 Hz`) — i.e. the original EMTSim filter parameters, which the flat dump
does not carry. That is converter-modeling work beyond the mechanical recovery.
The committed `GFf_Load_InfBus.mo` is left as the faithful flat recovery (which
exposes the daeMode diagnosis above); the shunt variant is reproducible from the
snippet here.

## 6. Reproduce

With the model built and `removeAllInDirectory(compilationDir1)` in
`DYNCompileModelicaModel.cpp` temporarily disabled (so the generated sources are
kept), run:

```
python3 diagnose_daemode_surplus.py <build>/.../GFf_Load_InfBus/GFf_Load_InfBus_Dyn.cpp
# -> equations 200  variables 196  matched 196  -> SURPLUS 4
#    DM over-determined block: 29 eqs / 25 vars (surplus 4)
```
