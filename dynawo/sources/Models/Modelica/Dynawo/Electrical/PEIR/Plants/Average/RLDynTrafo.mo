within Dynawo.Electrical.PEIR.Plants.Average;

/**
 * Dynamic RL element in RI frame (per unit) between two AC terminals.
 *
 * - Series branch with impedance Z = RPu + j·omegaPu·LPu (in pu).
 * - Currents follow generator convention from left to right:
 *   iRe, iIm > 0 → power flows from left terminal to right terminal.
 *
 * - left.V.re/im, right.V.re/im : node voltages (pu)
 * - left.i.re/im, right.i.re/im : node currents (pu, flow into the node)
 */
model RLDynTrafo
  "Dynamic RL element in RI frame (pu) between two AC terminals"

  // ────────────────────────────────────────────────────────────
  // Parameters (pu, base UNom, SNom)
  // ────────────────────────────────────────────────────────────
  parameter Dynawo.Types.PerUnit RPu 
    "Series resistance in pu (base UNom, SNom)";
  parameter Dynawo.Types.PerUnit LPu
    "Series inductance in pu (base UNom, SNom)";

  // Initial electrical frequency (pu)
  parameter Dynawo.Types.PerUnit Omega0Pu
    "Initial electrical frequency in pu (base SystemBase.omegaNom)";

  // Initial branch current from left to right (generator convention)
  parameter Dynawo.Types.PerUnit Ir0Pu
    "Initial real-axis branch current from left to right in pu";
  parameter Dynawo.Types.PerUnit Ii0Pu
    "Initial imag-axis branch current from left to right in pu";

  // ────────────────────────────────────────────────────────────
  // Electrical connectors
  // ────────────────────────────────────────────────────────────

  Dynawo.Connectors.ACPower left 
    "Left electrical terminal (e.g. LV side)" annotation(
      Placement(transformation(extent={{-110,-10},{-90,10}})));

  Dynawo.Connectors.ACPower right 
    "Right electrical terminal (e.g. HV/PCC side)" annotation(
      Placement(transformation(extent={{90,-10},{110,10}})));

  // Electrical frequency in pu
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu)
    "Electrical frequency in pu (base SystemBase.omegaNom)" annotation(
      Placement(transformation(origin = {0,-110},
                               extent = {{-20,-20},{20,20}},
                               rotation = 90)));


  // Internal state: branch current from left to right
  Dynawo.Types.PerUnit iRe(start = Ir0Pu, fixed = false)
    "Real-axis branch current from left to right in pu";
  Dynawo.Types.PerUnit iIm(start = Ii0Pu, fixed = false)
    "Imag-axis branch current from left to right in pu";
initial equation
  iRe = Ir0Pu;
  iIm = Ii0Pu;
equation
  // ────────────────────────────────────────────────────────────
  // Current orientation and connector equations
  // ────────────────────────────────────────────────────────────
  //
  // Currents follow generator convention from left to right:
  //   iRe, iIm > 0 → power flows from left terminal to right terminal.
  //
  // On each ACPower connector, .i is a flow variable:
  //  - left.i is the current injected into the network at the left node.
  //  - right.i is the current injected into the network at the right node.
  //
  // For a series branch:
  //  - left node sees +i (current leaving the node towards right),
  //  - right node sees -i (current entering the node from left).
  //
  left.i.re  = iRe;
  left.i.im  =  iIm;
  right.i.re = -iRe;
  right.i.im = -iIm;

  // ────────────────────────────────────────────────────────────
  // Dynamic equations of the RL branch in RI frame
  // ────────────────────────────────────────────────────────────
  //
  // LPu / omegaBase * der(iRe) =
  //     left.V.re - RPu*iRe + omegaPu*LPu*iIm - right.V.re
  //
  // LPu / omegaBase * der(iIm) =
  //     left.V.im - RPu*iIm - omegaPu*LPu*iRe - right.V.im
  //
  LPu / Dynawo.Electrical.SystemBase.omegaNom * der(iRe) =
      left.V.re 
    - RPu * iRe 
    + omegaPu * LPu * iIm 
    - right.V.re;

  LPu / Dynawo.Electrical.SystemBase.omegaNom * der(iIm) =
      left.V.im 
    - RPu * iIm 
    - omegaPu * LPu * iRe 
    - right.V.im;

  annotation(
    preferredView = "text",
    Icon(graphics = {
      Rectangle(extent = {{-100, 100},{100,-100}}),
      Text(origin = {0,20},
           extent = {{-80,20},{80,-20}},
           textString = "RL\ntrafo AC")
    }));
end RLDynTrafo;
