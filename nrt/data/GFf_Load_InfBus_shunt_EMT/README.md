# GFf_Load_InfBus_shunt_EMT

Runs the **shunt-capacitor variant** (`lib="GFf_Load_InfBus_shunt"`) of the
recovered grid-forming/grid-feeding converter case.

The faithful recovery (`GFf_Load_InfBus`) is over-determined by 4 in daeMode and
fails global initialization with `variables number 196 != equations number 200`
(see `documentation/SinusoidalPredictorMethod/recovered_cases/daemode_investigation.md`).
The `_shunt` model adds an output filter capacitor at the grid-feeding PCC node,
which makes the daeMode system **square**: this case therefore **compiles,
passes local + global initialization, and enters time-domain integration**.

Status: integrates the energization transient to **t ≈ 0.15 s** (currents build
toward rated) and then stalls — the added L-C resonance is undamped, and every
damper topology tried re-introduces a coupled capacitor state that Dynawo's IDA
cannot take the first step on (see the investigation note). A full 10 s run
needs the original EMTSim LCL-filter + damper design, which the flattened dump
does not carry. The capacitance (`Cf = 0.66 pu`) is chosen for numerical
conditioning, not from a real filter spec.

This case is kept as a runnable demonstration that the structural daeMode fix is
correct; it is not a validated reference case.
