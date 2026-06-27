# PQLoad_Circuit_EMT

Modular EMT case assembled **entirely from ported library components** —
`SignalVoltage` (source) → `RLBranchDisym` (line) → `PQLoad` (load) with
`Ground` and `VoltageSensor`. It validates the ported `PQLoad` component
(recovered by decomposing the `GFf_Load_InfBus` flat model; see
`documentation/SinusoidalPredictorMethod/recovered_cases/decomposition.md`) and
demonstrates re-modularising the GFf network half from components instead of one
flattened blob.

Status: **runs to completion** (`stopTime = 0.5 s`). The source amplitude rises
smoothly from rest (event-free 20 ms energisation), and the load-node voltage
settles to a balanced 50 Hz three-phase set of the expected magnitude
(~241 kV peak at the load = 320 kV RMS line-to-line source minus the line drop).

Notes:
- `absAccuracy` is set to `1.0` (not `1e-4`) because the variables are SI
  voltages/currents at kV/kA scale; `relAccuracy = 1e-4` carries the precision.
- `PQLoad` parameters here (`P = 600 MW, Q = 120 Mvar, V = 320 kV`) are Load1's
  from the GFf case.
