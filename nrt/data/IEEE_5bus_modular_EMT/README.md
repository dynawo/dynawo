# IEEE_5bus_modular_EMT

Runs the **friendly modular reconstruction** of the recovered IEEE 5-bus case
(`lib="IEEE_5bus_modular"`, package `Dynawo.Electrical.EMT.IEEE_5bus_modular`,
top model `Circuit`). Unlike the flat `IEEE_5bus`, this version is de-flattened
into one component class per type (`EMT5_Bus`, `EMT5_RLLine`, `EMT5_PQLoad`,
`EMT5_PerfectGen`, `EMT5_GridFeeding`, `EMT5_Ground`, `EMT5_ConstSource`) sharing
a three-phase `Terminal` connector, wired by `connect()` per the recovered
topology (see `documentation/.../recovered_cases/decomposition.md` and
`deflatten_ieee5.py`).

It is a **lossless** regrouping of the flat equations, so it is mathematically
identical to `IEEE_5bus` and **runs to completion** with the same result. Against
`reference/outputs/curves/curves.csv` (time-aligned, 0.02-0.98 s): control
signals `Vs/Ws` within <1 %, bus voltages within ~1.3 %, currents within ~8-11 %
peak (coarser variable-step grid at the 50 Hz peaks). Same `absAccuracy = 1.0`
note as `IEEE_5bus_EMT`.
