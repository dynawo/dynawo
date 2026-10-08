# `GeneratorPVDiagramPQRpcl2SignalN` — Preassembled Model

**File:** `GeneratorPVDiagramPQRpcl2SignalN.xml`
**License:** MPL 2.0 — RTE

---

## Overview

`GeneratorPVDiagramPQRpcl2SignalN` is a preassembled Dynawo model combining a voltage-regulated synchronous generator with a Reactive Power Control Loop (RPCL). It is designed for studies involving secondary voltage control and primary frequency regulation.

The assembly connects two unit models:

| Internal ID | Modelica model | Role |
|-------------|---------------|------|
| `generator` | [`Dynawo.Electrical.Machines.SignalN.GeneratorPVDiagramPQ`](../Dynawo/Electrical/Machines/SignalN/GeneratorPVDiagramPQ.mo) | PV generator with N-signal frequency regulation and PQ capability diagram |
| `reactivePowerControlLoop` | [`Dynawo.Electrical.Controls.Machines.ReactivePowerControlLoops.ReactivePowerControlLoop2`](../Dynawo/Electrical/Controls/Machines/ReactivePowerControlLoops/ReactivePowerControlLoop2.mo) | Simplified RPCL translating a secondary voltage control level into a stator voltage reference |

**Name decomposition:** Generator **PV** (voltage-regulated) + **Diagram** (PQ capability chart) + **Rpcl2** (Reactive Power Control Loop type 2) + **SignalN** (frequency via N signal)

---

## Functional diagram

```
  ┌─────────────────────────────────────────────────────────────────────────┐
  │                     GeneratorPVDiagramPQRpcl2SignalN                    │
  │                                                                         │
  │   terminal.V.re ──►┌─────────────────────────────────┐                  │
  │   terminal.V.im ──►│                                 ├────► terminal    │◄──► Network
  │   N ──────────────►│  generator                      │                  │
  │   PRefPu (opt.) ──►│  (GeneratorPVDiagramPQ)         │                  │
  │   switchOffSignal1►│                                 │                  │
  │   switchOffSignal2►│                                 │                  │
  │   switchOffSignal3►│                      URefPu ◄───┼──────────────┐   │
  │                    └───────┬──────────┬──────────────┘              │   │
  │                       QStatorPu  limUQUp                      UStatorRefPu
  │                            │     limUQDown                          │   │
  │                            │          │                             │   │
  │                            ▼          ▼                             │   │
  │                    ┌────────────────────────────────────────────┐   │   │
  │   level ──────────►│  reactivePowerControlLoop                  ├───┘   │
  │                    │  (ReactivePowerControlLoop2)               │       │
  │                    └────────────────────────────────────────────┘       │
  └─────────────────────────────────────────────────────────────────────────┘
```
---
## Parameters

### Initialization parameters

Load-flow values used by the generator init model. The RPCL init model has no user-facing parameters.

| Name | Unit | Convention | Description |
|------|------|------------|-------------|
| `generator_P0Pu` | pu (SnRef) | receptor | Active power at terminal from load flow |
| `generator_Q0Pu` | pu (SnRef) | receptor | Reactive power at terminal from load flow |
| `generator_U0Pu` | pu (UNom) | — | Voltage amplitude at terminal from load flow |
| `generator_UPhase0` | rad | — | Voltage angle at terminal from load flow |

### Generator sub-model (`GeneratorPVDiagramPQ`)

#### Machine parameters

| Name | Unit | Base | Description |
|------|------|------|-------------|
| `generator_KGover` | pu | — | Mechanical power sensitivity to frequency |
| `generator_PNom` | MW | — | Nominal active power |
| `generator_PMax` | MW | — | Maximum active power |
| `generator_PMin` | MW | — | Minimum active power |
| `generator_PRef0Pu` | pu | SnRef | Initial active power setpoint (start value of `PRefPu`, receptor convention) |
| `generator_QNomAlt` | Mvar | — | Nominal reactive power on alternator side |

#### Voltage regulation parameters

| Name | Unit | Base | Description |
|------|------|------|-------------|
| `generator_URef0Pu` | pu | UNom | Initial voltage regulation setpoint |
| `generator_UDeadBandPu` | pu | UNom | Voltage deadband around the target (≥ 0) |
| `generator_QDeadBandPu` | pu | SnRef | Reactive power deadband around the target (≥ 0) |

#### PQ capability diagram parameters

| Name | Type | Description |
|------|------|-------------|
| `generator_QMaxTableFile` | String | Path to the text file containing the QMax table |
| `generator_QMaxTableName` | String | Name of the QMax table in the file |
| `generator_QMinTableFile` | String | Path to the text file containing the QMin table |
| `generator_QMinTableName` | String | Name of the QMin table in the file |
| `generator_QMax0` | Mvar | Initial maximum reactive power |
| `generator_QMin0` | Mvar | Initial minimum reactive power |

### RPCL sub-model (`ReactivePowerControlLoop2`)

#### Control parameters

| Name | Unit | Base | Default | Description |
|------|------|------|---------|-------------|
| `reactivePowerControlLoop_CqMaxPu` | pu | UNom, QNom | — | Maximum Cq in all exploitation schemes |
| `reactivePowerControlLoop_DeltaURefMaxPu` | pu | UNom | — | Maximum URef variation per activation period |
| `reactivePowerControlLoop_QrPu` | pu | QNom | — | Generator participation factor in secondary voltage control |
| `reactivePowerControlLoop_Tech` | s | — | — | Sampling time |
| `reactivePowerControlLoop_Tech2` | s | — | `= Tech` | Integrator time constant |
| `reactivePowerControlLoop_Ti` | s | — | — | Filter time constant |
| `reactivePowerControlLoop_UStatorRefMinPu` | pu | UNom | `0.85` | Minimum stator voltage reference |
| `reactivePowerControlLoop_UStatorRefMaxPu` | pu | UNom | `1.15` | Maximum stator voltage reference |
| `reactivePowerControlLoop_QDeadBandPu` | pu | QNomAlt | `0` | Deadband on the Q error signal |

---
## Connections

Variables that can or must be connected from outside the preassembled model.

| Variable | Component | Type | Required | Description |
|----------|-----------|------|----------|-------------|
| `generator_terminal.V.re` | generator | continuous | ✅ | Real part of network voltage at terminal |
| `generator_terminal.V.im` | generator | continuous | ✅ | Imaginary part of network voltage at terminal |
| `generator_N` | generator | continuous | ✅ | Frequency regulation signal from the network (pu, base SnRef) |
| `reactivePowerControlLoop_level` | RPCL | continuous | ✅ | Secondary voltage control level in [-1, 1] |
| `generator_switchOffSignal1.value` | generator | discrete | ✅ | Switch-off signal — node disconnection (default: `false`) |
| `generator_switchOffSignal2.value` | generator | discrete | ✅ | Switch-off signal — user event (default: `false`) |
| `generator_switchOffSignal3.value` | generator | discrete | ✅ | Switch-off signal — protection automaton (default: `false`) |
| `generator_PRefPu` | generator | continuous | ⬜ optional | Active power setpoint (pu, base SnRef, receptor convention) |

---

## Initialization models

| Component | Init model |
|-----------|-----------|
| `generator` | [`Dynawo.Electrical.Machines.SignalN.GeneratorPVQNomAltParDiagram_INIT`](../Dynawo/Electrical/Machines/SignalN/GeneratorPVQNomAltParDiagram_INIT.mo) |
| `reactivePowerControlLoop` | [`Dynawo.Electrical.Controls.Machines.ReactivePowerControlLoops.ReactivePowerControlLoop_INIT`](../Dynawo/Electrical/Controls/Machines/ReactivePowerControlLoops/ReactivePowerControlLoop_INIT.mo) |

### Functional diagram (initialization)

```
  ┌─────────────────────────────────────────────────────────────────────────┐
  │             GeneratorPVDiagramPQRpcl2SignalN (initialization)           │
  │                                                                         │
  │  generator_P0Pu ──────►┌──────────────────────────────────┐             │
  │  generator_Q0Pu ──────►│                                  │             │
  │  generator_U0Pu ──────►│  generator (init)                │             │
  │  generator_UPhase0 ───►│  (GeneratorPVQNomAltParDiagram   │             │
  │  generator_PMax ──────►│   _INIT)                         │             │
  │  generator_PMin ──────►│                                  │             │
  │  generator_QMax0 ─────►│                                  │             │
  │  generator_QMin0 ─────►│                    URef0PuVar ◄──┼──────────┐  │
  │  generator_QNomAlt ───►│                                  │          │  │
  │  generator_URef0Pu ───►│                                  │          │  │
  │                        └───────┬──────────┬───────────────┘     UStatorRef0Pu
  │                          QStator0Pu  limUQUp0                         │  │
  │                                │     limUQDown0                       │  │
  │                                │          │                           │  │
  │                                ▼          ▼                           │  │
  │                        ┌────────────────────────────────────────┐     │  │
  │                        │  reactivePowerControlLoop (init)       ├─────┘  │
  │                        │  (ReactivePowerControlLoop_INIT)       │        │
  │                        └────────────────────────────────────────┘        │
  └──────────────────────────────────────────────────────────────────────────┘
```

### Variables initialized by the generator init model

Final values of these init model variables are passed as parameters to `GeneratorPVDiagramPQ`.

| Init variable | Dynamic parameter | Unit | Description |
|---------------|-------------------|------|-------------|
| `PGen0Pu` | `generator_PGen0Pu` | pu (SnRef) | Initial active power (generator convention) |
| `QGen0Pu` | `generator_QGen0Pu` | pu (SnRef) | Initial reactive power (generator convention) |
| `U0PuVar` | `generator_U0Pu` | pu (UNom) | Initial voltage amplitude |
| `u0Pu` | `generator_u0Pu` | pu (UNom) | Initial complex voltage |
| `i0Pu` | `generator_i0Pu` | pu (UNom, SnRef) | Initial complex current (receptor convention) |
| `PMaxPu` | `generator_PMaxPu` | pu (SnRef) | Maximum active power (= `PMax` / SnRef) |
| `PMinPu` | `generator_PMinPu` | pu (SnRef) | Minimum active power (= `PMin` / SnRef) |
| `QMax0Pu` | `generator_QMax0Pu` | pu (SnRef) | Initial maximum reactive power (= `QMax0` / SnRef) |
| `QMin0Pu` | `generator_QMin0Pu` | pu (SnRef) | Initial minimum reactive power (= `QMin0` / SnRef) |
| `limUQUp0` | `generator_limUQUp0` | — | Initial status: Q max limit reached |
| `limUQDown0` | `generator_limUQDown0` | — | Initial status: Q min limit reached |
| `qStatus0` | `generator_qStatus0` | — | Initial voltage regulation status |

### Variables initialized by the RPCL init model

The RPCL init model receives its inputs via init connections from the generator init model, then passes them as parameters to `ReactivePowerControlLoop2`.

| Init variable | Source (generator init) | Dynamic parameter | Unit | Description |
|---------------|------------------------|-------------------|------|-------------|
| `UStatorRef0Pu` | `URef0PuVar` (= `URef0Pu`) | `reactivePowerControlLoop_UStatorRef0Pu` | pu (UNom) | Initial stator voltage reference |
| `QStator0Pu` | `QStator0Pu` (= `QGen0Pu` × SnRef / QNomAlt) | `reactivePowerControlLoop_QStator0Pu` | pu (QNomAlt) | Initial stator reactive power |
| `limUQUp0` | `limUQUp0` | `reactivePowerControlLoop_limUQUp0` | — | Initial status: Q max limit reached |
| `limUQDown0` | `limUQDown0` | `reactivePowerControlLoop_limUQDown0` | — | Initial status: Q min limit reached |
