within Dynawo.Electrical.PEIR.Plants.Average;

/**
 * Author Gaia Bergamaschi
 * Dynamic RL branch model in RI coordinates (per-unit) for the GFL plant.
 *
 * This model represents a series RL element between two AC terminals in
 * real/imag (R/I) coordinates. It is typically used to model:
 *   - transformer leakage impedance (LV or HV winding), or
 *   - an equivalent line / grid impedance.
 *
 * The branch has impedance:
 *   Z = RPu + j · omegaPu · LPu   (in per-unit),
 * where:
 *   - RPu : series resistance (pu, base UNom, SNom)
 *   - LPu : series inductance (pu, base UNom, SNom)
 *   - omegaPu : per-unit electrical frequency (base SystemBase.omegaNom)
 *
 * State variables:
 *   - iRe, iIm : branch current components flowing from left to right (pu).
 *
 * Connectors:
 *   - left.V.re/im,  right.V.re/im : node voltages (pu)
 *   - left.i.re/im, right.i.re/im : currents positive when entering the device
 *                                   (Dynawo ACPower flow convention).
 *
 * Current / power sign conventions:
 *   - iRe, iIm > 0 : current flows from left terminal to right terminal
 *                    (generator convention for the branch).
 *   - left.i  = +iRe/iIm : current enters the device from the left node
 *   - right.i = -iRe/iIm : current exits the device at the right node.
 *
 * All electrical quantities are expressed in per-unit on the system base.
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
      Placement(transformation(extent = {{-110,-10},{-90,10}})));

  Dynawo.Connectors.ACPower right
    "Right electrical terminal (e.g. HV/PCC side)" annotation(
      Placement(transformation(extent = {{90,-10},{110,10}})));

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
  der(iRe) = 0;
  der(iIm) = 0;

equation
  // ────────────────────────────────────────────────────────────
  // Connector equations (ACPower convention: .i positive entering device)
  // ────────────────────────────────────────────────────────────
  //
  // The branch current iRe/iIm flows from left to right:
  //   - left.i = +iRe/iIm : current enters the device from the left node
  //   - right.i = -iRe/iIm : current exits the device at the right node,
  //                           so it appears negative entering from the right
  //
  left.i.re  =  iRe;
  left.i.im  =  iIm;
  right.i.re = -iRe;
  right.i.im = -iIm;

  // ────────────────────────────────────────────────────────────
  // Dynamic equations of the RL branch in RI frame
  // ────────────────────────────────────────────────────────────
  //
  // LPu / omegaNom * der(iRe) =
  //     left.V.re - RPu*iRe + omegaPu*LPu*iIm - right.V.re
  //
  // LPu / omegaNom * der(iIm) =
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
