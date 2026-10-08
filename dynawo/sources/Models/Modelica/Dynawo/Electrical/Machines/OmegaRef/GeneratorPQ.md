# `GeneratorPQ` — Simplified P/Q Generator

**Package:** `Dynawo.Electrical.Machines.OmegaRef`
**File:** `GeneratorPQ.mo`
**License:** MPL 2.0 — RTE

---

## Description

`GeneratorPQ` is a simplified synchronous generator model designed for frequency dynamics and voltage plan studies. It is based on two core assumptions:

- **Active power**: modulated as a function of the network frequency deviation (primary frequency containment reserves). The raw active power is bounded between a minimum `PMin` and a maximum `PMax`.
- **Reactive power**: fixed at its initial value `QGen0Pu` — neither regulated nor sensitive to voltage variations.

The model also handles generator disconnection through three independent switch-off signals (node, user event, protection automaton).

### Inheritance hierarchy

```
SwitchOffLogic (NbSwitchOffSignals = 3)
  └── SwitchOffGenerator
        └── BaseGeneratorSimplified
              └── BaseGeneratorSimplifiedPFBehavior
                    └── GeneratorPQ  ◄── this model
```

---

## Functional diagram

```
                    ┌──────────────────────────────────────────┐
  omegaRefPu ──────►│                                          │
                    │   PGenRawPu = PGen0Pu                    │
  deltaPmRefPu ────►│             + ΔPmRef · PNom/SnRef        ├────► terminal
   (optional)       │             + α · (1 − ωref)             │     (ACPower)
                    │                                          │
  switchOffSignal1 ►│   PGenPu = clamp(PGenRawPu, PMin, PMax) │
  switchOffSignal2 ►│                                          │
  switchOffSignal3 ►│   QGenPu = QGen0Pu  (fixed)             │
                    └──────────────────────────────────────────┘
```

---

## Parameters

### User-defined parameters

| Name | Unit | Base | Description |
|------|------|------|-------------|
| `PMin` | MW | — | Minimum active power |
| `PMax` | MW | — | Maximum active power |
| `PNom` | MW | — | Nominal active power |
| `AlphaPuPNom` | pu | PNom, OmegaNom | Frequency sensitivity (droop) |
| `PGen0Pu` | pu | SnRef | Initial active power at terminal (generator convention) |
| `QGen0Pu` | pu | SnRef | Initial reactive power at terminal (generator convention) |
| `U0Pu` | pu | UNom | Initial voltage amplitude at terminal |
| `u0Pu` | pu (complex) | UNom | Initial complex voltage at terminal |
| `i0Pu` | pu (complex) | UNom, SnRef | Initial complex current at terminal (receptor convention) |
| `State0` | — | — | Initial connection state (default: `Closed`) |

### Derived parameters (computed automatically)

| Name | Expression | Unit | Description |
|------|------------|------|-------------|
| `PMinPu` | `PMin / SnRef` | pu (SnRef) | Minimum active power in pu |
| `PMaxPu` | `PMax / SnRef` | pu (SnRef) | Maximum active power in pu |
| `AlphaPu` | `AlphaPuPNom × PNom / SnRef` | pu (SnRef, OmegaNom) | Frequency sensitivity normalized to SnRef |

---

## Internal variables

| Name | Unit | Description |
|------|------|-------------|
| `PGen` | MW | Active power at terminal |
| `PGenPu` | pu (SnRef) | Active power at terminal |
| `QGenPu` | pu (SnRef) | Reactive power at terminal |
| `SGenPu` | pu (SnRef) | Complex apparent power at terminal |
| `UPu` | pu (UNom) | Voltage amplitude at terminal |
| `PGenRawPu` | pu (SnRef) | Active power before saturation limits |
| `pStatus` | — | P/f regulation status: `Standard` / `LimitPMin` / `LimitPMax` |
| `state` | — | Connection state: `Open` / `Closed` |
| `running.value` | boolean | True when the generator is in service |

---

## Equations

### Active power (primary frequency regulation)

When the generator is in service (`running.value = true`):

```
PGenRawPu = PGen0Pu + deltaPmRefPu · (PNom / SnRef) + AlphaPu · (1 − omegaRefPu)
```

The effective active power is bounded:

```
         ┌ PMaxPu      if pStatus = LimitPMax
PGenPu = ┤ PMinPu      if pStatus = LimitPMin
         └ PGenRawPu   otherwise  (Standard)
```

Discrete state transitions (events):

| Condition | Transition |
|-----------|-----------|
| `PGenRawPu ≥ PMaxPu` | → `LimitPMax` + log `ActivatePMAX` |
| `PGenRawPu ≤ PMinPu` | → `LimitPMin` + log `ActivatePMIN` |
| `PGenRawPu > PMinPu` and state was `LimitPMin` | → `Standard` + log `DeactivatePMIN` |
| `PGenRawPu < PMaxPu` and state was `LimitPMax` | → `Standard` + log `DeactivatePMAX` |

When the generator is disconnected (`running.value = false`):

```
PGenRawPu = 0
terminal.i.re = 0
```

### Reactive power (fixed)

```
QGenPu = QGen0Pu      (when running)
terminal.i.im = 0     (when disconnected)
```

### Power balance at terminal

```
PGen    = SnRef · PGenPu
SGenPu  = PGenPu + j · QGenPu
SGenPu  = −terminal.V · conj(terminal.i)
UPu     = |terminal.V|
```

### Disconnection logic

```
when not(running):               state = Open   + log GeneratorDisconnected
when running and was not(running): state = Closed + log GeneratorConnected
```

---

## External connections (`.extvar`)

These variables must be connected by the simulation network (DYD/Dynawo).

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `terminal.V.re` | continuous | ✅ | Real part of the network terminal voltage |
| `terminal.V.im` | continuous | ✅ | Imaginary part of the network terminal voltage |
| `omegaRefPu.value` | continuous | ✅ | Network angular reference frequency in pu (base OmegaNom) |
| `deltaPmRefPu.value` | continuous | ⬜ optional | Additional active power reference in pu (base PNom) |
| `switchOffSignal1.value` | discrete | ✅ | Switch-off signal — node disconnection (default: `false`) |
| `switchOffSignal2.value` | discrete | ✅ | Switch-off signal — user event (default: `false`) |
| `switchOffSignal3.value` | discrete | ✅ | Switch-off signal — protection automaton, e.g. under-voltage (default: `false`) |

> **Note:** `deltaPmRefPu` allows superimposing an external active power setpoint (e.g. secondary frequency regulation). When left unconnected, it defaults to zero (start value = 0).

---

## Initialization model (`GeneratorPQ_INIT`)

**File:** `GeneratorPQ_INIT.mo`
**Base class:** `BaseClasses_INIT.BaseGeneratorParameters_INIT`

The initialization model computes the steady-state operating point from load-flow results. Its final variable values are passed as parameters to the dynamic model under the same names.

### Initialization inputs (load-flow data)

| Name | Unit | Convention | Description |
|------|------|------------|-------------|
| `P0Pu` | pu (SnRef) | receptor | Active power at terminal from load flow |
| `Q0Pu` | pu (SnRef) | receptor | Reactive power at terminal from load flow |
| `U0Pu` | pu (UNom) | — | Voltage amplitude at terminal from load flow |
| `UPhase0` | rad | — | Voltage angle at terminal from load flow |
| `iStart0Pu` | pu (UNom, SnRef) | receptor | Start value for current iteration (default: `0 + 0j`) |

### Initialization equations

```
u0Pu  = U0Pu · exp(j · UPhase0)         (complex voltage from polar form)
s0Pu  = P0Pu + j · Q0Pu                 (complex apparent power, receptor convention)
s0Pu  = u0Pu · conj(i0Pu)               (power balance → computes i0Pu)

PGen0Pu = −P0Pu                          (convention change: receptor → generator)
QGen0Pu = −Q0Pu                          (convention change: receptor → generator)
```

### Mapping: init outputs → dynamic model parameters

The final values of the init model variables initialize the parameters of `GeneratorPQ` with the same name:

| Init variable | Dynamic parameter | Unit | Description |
|---------------|------------------|------|-------------|
| `PGen0Pu` | `PGen0Pu` | pu (SnRef) | Initial active power (generator convention) |
| `QGen0Pu` | `QGen0Pu` | pu (SnRef) | Initial reactive power (generator convention) |
| `u0Pu` | `u0Pu` | pu (UNom) | Initial complex voltage |
| `i0Pu` | `i0Pu` | pu (UNom, SnRef) | Initial complex current (receptor convention) |
| `U0PuVar` (= `U0Pu`) | `U0Pu` | pu (UNom) | Initial voltage amplitude |

---

## Conventions

- **Generator convention**: positive power = power injected into the network.
- **Receptor convention**: positive current `i0Pu` = current flowing into the terminal.
- Powers in pu are normalized to `SnRef` (system base power), except `AlphaPuPNom` which uses `PNom` as its base.
