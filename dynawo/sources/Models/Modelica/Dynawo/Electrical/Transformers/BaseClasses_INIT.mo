within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package BaseClasses_INIT

function TapEstimation "Function that estimates the initial tap of a transformer"

/*
  It is done using the voltage and current values on side 1 and the set point value for the voltage module on side 2.

  The algorithm uses the following equations related to the input data:
    (1) rcTfo0Pu² * Re(u10Pu) - Re(ZPu * i10Pu) = rcTfo0Pu * Re(u20Pu)
    (2) rcTfo0Pu² * Im(u10Pu) - Im(ZPu * i10Pu) = rcTfo0Pu * Im(u20Pu)
    (3) Uc20Pu² = Re(u20Pu)² + Im(u20Pu)²
  (1) and (2) are the real and imaginary parts of the transformer equation: rTfo0Pu * rTfo0Pu * u10Pu = rTfo0Pu * u20Pu + ZPu * i10Pu

  By adding (1)² + (2)² and substituting Re(u20Pu)² + Im(u20Pu)² with Uc20Pu² from (3), we get:
    (4) rcTfo0Pu⁴ * U10Pu² + rcTfo0Pu² * (-2 * Re(ZPu * i10Pu) * Re(u10Pu) - 2 * Im(ZPu * i10Pu) * Im(u10Pu) - Uc20Pu²) + (|ZPu|*I10Pu)² = 0
  That we can rewrite as:
    (5) Ax² + Bx + C = 0 with x = rcTfo0Pu²

  We then solve for (rcTfo0Pu²) and deduce rcTfo0Pu that is used to find the closest tap - Tap0 -.
*/

  input Types.AC.Impedance ZPu " Transformer impedance in p.u (base U2Nom, SnRef)";
  input SIunits.PerUnit rTfoMinPu "Minimum transformation ratio in p.u: U2/U1 in no load conditions";
  input SIunits.PerUnit rTfoMaxPu "Maximum transformation ratio in p.u: U2/U1 in no load conditions";
  input Integer NbTap "Number of taps";
  input Types.AC.Voltage u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
  input Types.AC.Current i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
  input Types.AC.VoltageModule Uc20Pu "Voltage set-point on side 2 in p.u (base U2Nom)";

  output Integer Tap0 "Estimated tap";

protected
  SIunits.PerUnit rcTfo0Pu "Ratio value corresponding to the voltage set point on side 2 in p.u.: U2/U1 in no load conditions";
  Types.AC.Voltage deltauPu "Voltage drop due to the impedance in p.u. (base U2Nom, SnRef)";

  // Mathematical intermediate variables for resolving (5)
  Real A, B, C "Polynomial coefficients";
  Real delta "Discriminant";
  Real root "Largest root";

  Real tapEstimation "Intermediate real value corresponding to the tap estimation based on the minimum and maximum tap values";

algorithm

  // Handling the one tap case
  if (NbTap == 1) then
    Tap0 := 0;
    return;
  end if;

  // Handling zero voltage case
  if (ComplexMath. 'abs'(u10Pu) == 0) then
    Tap0 := 0;
    return;
  end if;

  // Determining the ratio voltage corresponding to the voltage set point based on equation (5)
  deltauPu := ZPu * i10Pu;
  A := ComplexMath. 'abs'(u10Pu) * ComplexMath. 'abs'(u10Pu);
  B := -2 * deltauPu.re * u10Pu.re -2 * deltauPu.im * u10Pu.im - Uc20Pu * Uc20Pu;
  C := ComplexMath. 'abs'(deltauPu) * ComplexMath. 'abs'(deltauPu);
  delta := B * B - 4 * A * C;
  assert(delta > 0, "The power flow through the transformer is incoherent: rTfo0Pu is supposed to be positive");
  root := (-B + sqrt(delta)) / (2 * A);
  assert(root > 0, "The power flow through the transformer is incoherent: rTfo0Pu is supposed to be positive");
  rcTfo0Pu := sqrt(root);

  // Finding the tap position closest to the ratio calculated (rounded to an integer)
  tapEstimation := ((rcTfo0Pu - rTfoMinPu) / (rTfoMaxPu - rTfoMinPu)) * (NbTap - 1);
  if tapEstimation <= 0 then
    Tap0 := 0;
  elseif tapEstimation >= (NbTap -1) then
    Tap0 := NbTap - 1;
  elseif (tapEstimation - floor(tapEstimation)) < (ceil(tapEstimation) - tapEstimation) then
   Tap0 := integer(floor(tapEstimation));
  else
    Tap0 := integer(ceil(tapEstimation));
  end if;

end TapEstimation;

// Base model for initialization of TransformerVariableTap
partial model BaseTransformerVariableTap_INIT "Base model for initialization of TransformerVariableTap"

/*
  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---

  The initialization scheme is specific and considers that the values on only one side of the transformer are known plus the voltage set point on the other side.
  From these values, the tap position and its corresponding ratio are determined.
  From the tap and ratio values, the final U2, P2 and Q2 values are calculated.
*/

  import Dynawo.Electrical.SystemBase;

  public

    // Transformer's parameters
    parameter Types.AC.ApparentPowerModule SNom "Nominal apparent power in MVA";
    parameter SIunits.Resistance R "Resistance in % (base U2Nom, SNom)";
    parameter SIunits.Reactance X "Reactance in % (base U2Nom, SNom)";
    parameter SIunits.Conductance G "Conductance in % (base U2Nom, SNom)";
    parameter SIunits.Susceptance B "Susceptance in % (base U2Nom, SNom)";
    parameter SIunits.PerUnit rTfoMinPu "Minimum transformation ratio in p.u: U2/U1 in no load conditions";
    parameter SIunits.PerUnit rTfoMaxPu "Maximum transformation ratio in p.u: U2/U1 in no load conditions";
    parameter Integer NbTap "Number of taps";
    parameter Types.AC.VoltageModule Uc20Pu "Voltage set-point on side 2 in p.u (base U2Nom)";

  protected

    // Transformer's impedance and susceptance
    parameter Types.AC.Impedance ZPu(re = R / 100 * SystemBase.SnRef/ SNom , im  = X / 100 * SystemBase.SnRef/ SNom) "Transformer impedance in p.u (base U2Nom, SnRef)";
    parameter Types.AC.Admittance YPu(re = G / 100 * SNom / SystemBase.SnRef, im  = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in p.u (base U2Nom, SnRef)";

    // Transformer start values
    Types.AC.Voltage u20Pu  "Start value of complex voltage at terminal 2 in p.u (base U2Nom)";
    flow Types.AC.Current i20Pu  "Start value of complex current at terminal 2 in p.u (base U2Nom, SnRef) (receptor convention)";
    Types.AC.VoltageModule U20Pu "Start value of voltage amplitude at terminal 2 in p.u (base U2Nom)";

    Integer Tap0 "Start value of transformer tap";
    SIunits.PerUnit rTfo0Pu "Start value of transformer ratio";
    Constants.state state0 = Constants.state.Closed "Start value of connection state";

equation

  // Initial tap and ratio estimation
  Tap0 = TapEstimation (ZPu, rTfoMinPu, rTfoMaxPu, NbTap, u10Pu, i10Pu, Uc20Pu);
  if (NbTap == 1) then
    rTfo0Pu = rTfoMinPu;
  else
    rTfo0Pu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (Tap0 / (NbTap - 1));
  end if;

  // Transformer equations
  i10Pu = rTfo0Pu * (YPu * u20Pu - i20Pu);
  rTfo0Pu * rTfo0Pu * u10Pu = rTfo0Pu * u20Pu + ZPu * i10Pu;

  // Voltage at terminal 2
  U20Pu = ComplexMath.'abs' (u20Pu);

end BaseTransformerVariableTap_INIT;

end BaseClasses_INIT;
