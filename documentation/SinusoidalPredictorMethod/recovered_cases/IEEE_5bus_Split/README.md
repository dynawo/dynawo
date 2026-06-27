# IEEE_5bus_Split — modular (split) recovery: status and structure

`IEEE_5bus_Split` is **not** a third network — it is the *same* IEEE 5-bus system
as `IEEE_5bus`, deliberately **partitioned into two separately-compiled Dynawo
models coupled at run time** via Dynawo's external-variable mechanism. It is the
co-simulation / model-splitting variant. This directory holds the recovered
pieces and documents what remains for a full coupled run.

## Structure (from the original `.dyd` + `.extvar`)

Two models, coupled at **Bus 2**:

- `IEEE5bus_network` — the passive grid: 5 buses, 7 RL lines, 4 PQ loads, the
  perfect generator. Exposes Bus 2's terminal as 6 **external variables**
  (`Bus2_p_v_1..3`, `Bus2_p_i_1..3`) — see `IEEE5bus_network.extvar`.
- `IEEE5bus_gridfeeding` — the grid-feeding converter + its `Bus2` measurement
  node + the **P/Q reference step events** (`StepPrefE1/E2`, `StepQrefE1/E2` at
  t = 6.0 s and 6.5 s). Exposes `GridFeeding2.p` as 6 external variables — see
  `IEEE5bus_gridfeeding.extvar`.

The `.dyd` (`IEEE_5bus_Split.dyd`) couples them with 6 `<dyn:connect>` lines
(3 voltages + 3 currents) joining `network.Bus2.p` ↔ `gridfeeding.GridFeeding2.p`.
Unlike the single `IEEE_5bus` (constant Vs), the Split drives a **reference-step
disturbance** at t = 6 s, `stopTime = 10 s`.

## What is recovered

- `IEEE5bus_gridfeeding.mo` — the grid-feeding sub-model, recovered from the OMC
  dump (`recover_ieee5split_gf.py`; same array-aware pipeline as GFf — drop
  enum/protected/assert, coalesce arrays, keep homotopy/smooth, expand integer
  powers, repair the one injection). It carries the converter, its `Bus2`, and
  the four reference steps. **Parses**, but does not yet build standalone (below).
- `IEEE5bus_network.extvar`, `IEEE5bus_gridfeeding.extvar`, `IEEE_5bus_Split.dyd`
  — the exact original interface + coupling, kept verbatim.

## Why the full coupled run is a larger effort (the blockers)

Unlike `IEEE_5bus` (single square model, ran on the first try), the Split needs
three things this project hasn't required before:

1. **External-variable (non-square) compilation.** Each sub-model is non-square
   by 6 (the Bus 2 interface). Dynawo *does* support this (`.extvar` →
   `read_eq_fictive_xml`), and on the first build attempt Dynawo correctly
   detected the gridfeeding model as non-square and auto-emitted an
   external-variable template — so the mechanism is reachable. No EMT model in
   the tree currently uses it, so it is new ground here.
2. **Unbound converter init parameters.** In the standalone gridfeeding model the
   converter's initial operating point (`vgd0`, `vgq0`, `Vg0`, `isd0/q0`, …)
   depends on the *external* Bus 2 voltage, so those parameters are unbound (the
   single `IEEE_5bus` had them all resolved internally). They must be supplied
   (as GFf's two init params were, via the `.par`) — but there are many more here.
3. **No network dump.** Only the gridfeeding model was dumped to the logs; the
   `IEEE5bus_network` model must be rebuilt from components (the modular
   `EMT5_*` classes already exist, minus the converter, with Bus 2 exposed as the
   external terminal) — itself a non-square model with the same `.extvar` work.
4. **No saved reference.** This case ships no `curves.csv`, and the step
   disturbance makes it diverge from `IEEE_5bus`, so there is nothing to validate
   a coupled run against here.

## Path to completion

1. Bake/supply the gridfeeding init parameters (compute from the IEEE_5bus
   solved operating point, where `GridFeeding2` is fully determined) and add
   `IEEE5bus_gridfeeding.extvar` (the 6 terminal vars) → build it standalone.
2. Build `IEEE5bus_network` from the modular `EMT5_*` components with Bus 2 as an
   external terminal + its `.extvar`.
3. Wire the two with a `.dyd` (the 6 Bus 2 connects, names matched to the
   current-Dynawo array element naming) + the step events, and run under
   IDA/IDASPM.

The single `IEEE_5bus` (committed, running, validated) already demonstrates the
same physical case end-to-end; the Split additionally demonstrates Dynawo's
**modular co-simulation** of two separately-compiled EMT models, which is the
remaining, well-scoped piece.
