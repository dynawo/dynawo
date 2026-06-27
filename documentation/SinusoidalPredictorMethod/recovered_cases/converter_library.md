# Modular grid-feeding converter library

`deflatten_converter.py` decomposes the recovered EMTSim grid-feeding converter
(`GridFeeding2`, from the flat IEEE_5bus) into a **reusable component library**,
the converter counterpart of the network de-flattening (`deflatten_ieee5.py`).
Output: `Dynawo.Electrical.EMT.GridFeedingConverter` (one `.mo` package).

## Structure recovered

The flat converter (one ~250-equation blob inside `EMT5_GridFeeding`) becomes
**8 reusable sub-component classes** sharing a three-phase `Terminal` connector:

| class | role |
|---|---|
| `Conv` | averaged voltage source + per-phase modulation limiters |
| `RL_converter` | output filter inductor |
| `I_Sensor`, `V_Sensor` | current / voltage measurement |
| `CurrentControl` | dq PI current control + inverse Park |
| `PLL` | grid synchronisation (Park + PI + integrator) |
| `RefCalculation` | P/Q references → dq current setpoints |
| `Ground` | neutral reference |

…wired in a `GridFeeding` composite:
- **power chain** (`connect`): `Conv → I_Sensor → RL_converter → V_Sensor → p` (terminal), `Ground → V_Sensor.n`
- **control signals** (equations): `V_Sensor → PLL → CurrentControl ← RefCalculation`, `CurrentControl → Conv` (modulation)
- converter-level inputs `Vs` (DC bus), `Pref`/`Qref` threaded to the sub-components

## How the generator works

Same lossless de-flattening as the network, one level deeper, plus three things
the converter needs that the passive network did not:
1. **Parameter resolution.** The 44 converter-level parameters (formulas, nested
   `if`/`min`/`max` clamps, dq init from the operating point) are evaluated to
   numbers (`gf2_params.json`) and baked, so each sub-component is self-contained.
2. **Cross-reference threading.** Variables a sub-component shares with another
   (or with the converter level) — `Vs`, `Pref`, `Qref`, the modulation `fg1..3`,
   the dq feedback — are detected (decl- and equation-aliases, both directions)
   and turned into `input`s wired in the composite.
3. **External terminal.** The composite `p` is `connect`ed to the boundary sub
   pin so the terminal current is determined (without it the control loop is
   structurally singular).

## Status: BUILDS and RUNS

`GridFeeding_test` (the composite into a stiff 50 Hz grid, `nrt/data/
GridFeeding_test_EMT`) compiles to a `.so` and runs to completion, injecting a
balanced three-phase current of the expected magnitude (~360 A peak for the
~44 MW `Pref0` at 103.67 kV) — i.e. the modular converter tracks its power
reference, validating the decomposition.

Parameters are baked to the recovered operating point; re-exposing them on the
sub-components (full re-parameterisation) and swapping the modular `GridFeeding`
into `IEEE_5bus_modular` in place of the flat `EMT5_GridFeeding` are the natural
follow-ups.
