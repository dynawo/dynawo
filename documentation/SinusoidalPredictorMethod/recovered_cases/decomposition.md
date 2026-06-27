# Decomposing the flat GFf_Load_InfBus back into components

The recovered `GFf_Load_InfBus.mo` is a single **flattened** model: OMC inlined
the whole component tree into one list of scalar equations. This note records
how the original modular structure is recovered from it, so the case can be
re-assembled from proper Modelica components (most of which already exist in the
ported `Dynawo.Electrical.EMT` library) instead of a 1371-line blob.

Tool: `decompose_flat_model.py` (full output in `GFf_decomposition_report.txt`).
It runs on the **dotted** flat dump (the de-escaped `class GFf_Load_InfBus_test`
block from `dynamoCompiler.log`, before `recover_gff.py` mangles `.`→`_`). The
dots still encode the instance hierarchy `Top.instance.subinstance…pin.var`, so
the tool rebuilds the tree, buckets every parameter and equation to its owning
instance, classifies each against the EMT component signatures, and separates the
**connection** (multi-instance) equations from the constitutive ones.

## Top-level architecture (18 instances, 49 connection equations)

| flat instance | original component | maps to (ported EMT lib) |
|---|---|---|
| `RL1`, `RL2`, `RL3` | 3-phase R-L series branch | **`RLBranchDisym`** (exists) |
| `Load1`, `Load2` | PQ load (R∥L∥C with dq init) | PQ-load model (port needed) |
| `bus1` | bus / node init | **`Bus`** (exists) |
| `sineVoltage1` | 3-phase sine source = infinite bus | **`SignalVoltage`** (exists) |
| `GRND` | ground | **`Ground`** (exists) |
| `StepPref`, `StepPref2`, `StepQref` | reference steps | `Modelica.Blocks.Sources.Step` |
| `const`..`const3` | constants | `Modelica.Blocks.Sources.Constant` |
| `converter_Grid_Forming1` | grid-forming converter (composite) | custom (see below) |
| `converter_Grid_Feeding1` | grid-feeding converter (composite) | custom (see below) |
| `converter_Grid_InstFunction` | — | **not a component** (OMC error artifact) |

Each `RLi` reconstructs cleanly to the canonical branch:
```
v = R*i + L*der(i);   v = p.v - n.v;   0 = p.i + n.i;   i = p.i;   // per phase
```
i.e. exactly `Dynawo.Electrical.EMT.RLBranchDisym`. The network half of the model
is therefore re-modularisable today from already-ported library components.

## Connection topology (the electrical nodes)

The 49 connection equations resolve to two main AC nodes plus the converter
interfaces and the control wiring:

- **Infinite-bus node:** `RL1 – RL2 – RL3 – bus1 – sineVoltage1` (the grid side;
  `sineVoltage1 – GRND` returns the source).
- **Grid-forming PCC + load node:** `Load1 – Load2 – RL1 – RL2 – Grid_Forming1`.
- **Grid-feeding interface:** `RL3 – Grid_Feeding1` (6 eqs) — this is the
  series-inductor / zero-current-sensor node that makes the flat daeMode model
  over-determined (see `daemode_investigation.md`); in the modular form it is the
  converter's output terminal feeding the `RL3` line.
- **Control wiring:** `StepPref/StepPref2/StepQref → Grid_Feeding1` (P/Q refs),
  `const1/const2 → Grid_Forming1`, `const/const2 → Grid_Forming1` references.

## Converter internals (the custom part)

Both converters are composites of control + power sub-components (2nd level):

- **`Grid_Forming1`** (90 params, 332 eqs):
  `Conv` (averaged ideal voltage source), `RL_converter` (filter inductor),
  `C_converter` (filter capacitor = `CParallel`), `V_Sensor` / `Ig_Sensor` /
  `Is_Sensor` (sensors), `CurrentControl` + `VoltageControl` (cascaded dq PI),
  `Park_invr` (inverse Park), `F_cal` (power/droop), `Add1..4`, `TVI1`, `T_LP`,
  `Ground`.
- **`Grid_Feeding1`** (66 params, 253 eqs):
  `Conv`, `RL_converter`, `V_Sensor` / `I_Sensor`, `CurrentControl` (dq PI),
  `PLL` (synchronisation), `RefCalculation` (P/Q → current refs), `Ground`.
  Note it has **no `C_converter`** — that missing output-filter capacitor is
  exactly the source of the daeMode singularity (and what the `_shunt` variant
  adds back).

These map to a converter library (ideal-source + RL/LC filter + dq Park current
control + PLL + droop/voltage control) that is **not** in the ported EMT set. The
sub-component equations are all present in the flat dump and bucketed by the
tool, but reconstructing them faithfully (PI states, limiters, Park rotations,
PLL) is best done from the **original EMTSim converter sources**, not by
decompiling the flattened controllers, because the flatten has already inlined
limiter `smooth/if`, homotopy init, and folded parameters.

## Porting status

- **`PQLoad` — ported.** The PQ-load (parallel R // L // C sized from `P, Q, V`)
  is reconstructed as `Dynawo.Electrical.EMT.PQLoad` (clean modular component,
  receptor convention, `PwPin`). It is validated end-to-end by the modular case
  `nrt/data/PQLoad_Circuit_EMT` — `SignalVoltage → RLBranchDisym → PQLoad` wired
  with `connect()` from library components only — which **runs to completion**
  with the load voltage settling to the expected balanced 50 Hz set. This is the
  network half re-modularised and proven from components, not a flat blob. (EMT
  energisation lessons that case bakes in: soft, event-free source ramp, and an
  absolute solver tolerance scaled to SI kV/kA variables.)
- **Converters — need sources.** See below; the EMTSim converter library is not
  in the recovered material.

## Re-modularisation path

1. **Network (done):** the passive network components are all available —
   `SignalVoltage`, `RLBranchDisym`, `Bus`, `Ground`, and now `PQLoad` — and the
   topology above gives the `connect()` wiring. `PQLoad_Circuit` demonstrates it.
2. **Converters (needs sources):** port the EMTSim grid-forming / grid-feeding
   converter library (Conv, filters, dq `CurrentControl`/`VoltageControl`, `PLL`,
   `RefCalculation`, droop). The decomposition here gives the exact sub-component
   list, parameters, and interface nodes to target.
3. With both, the case is a normal modular Dynawo `.dyd` of black-box models —
   and the grid-feeding converter would carry its real output filter, removing
   the daeMode singularity without the `_shunt` numerical workaround.

## Friendly modular reconstruction (IEEE_5bus)

`deflatten_ieee5.py` goes one step further than the report: it **regenerates a
runnable modular model** from the flat IEEE_5bus dump. It buckets every
parameter/equation to its owning instance, groups instances into types, and emits
one clean component class per type (`EMT5_Bus`, `EMT5_RLLine`, `EMT5_PQLoad`,
`EMT5_PerfectGen`, `EMT5_GridFeeding`, `EMT5_Ground`, `EMT5_ConstSource`) sharing
a three-phase `Terminal` connector, plus a top-level `Circuit` model that
instantiates them with their parameters and wires them with `connect()` per the
recovered topology (voltage-equality + KCL connection equations → connection
sets). The converter and the perfect generator keep their internal sub-structure
flattened inside their class; the rest are fully parameterised.

The result (`Dynawo.Electrical.EMT.IEEE_5bus_modular`, nrt case
`IEEE_5bus_modular_EMT`) is a **lossless** regrouping — mathematically identical
to the flat `IEEE_5bus`, so it **builds, runs to completion, and validates against
the same reference** (control <1 %, bus voltages ~1.3 %). It is the human-readable
"how the case was originally assembled" form.

## Reproduce
```
python3 decompose_flat_model.py <flat dotted dump>.mo [TopName]   # report
python3 deflatten_ieee5.py                                        # -> IEEE_5bus_modular.mo
```
