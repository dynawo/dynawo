within Dynawo.Electrical.Transformers.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

function TapEstimation "Function that estimates the initial tap of a transformer"
  extends Icons.Function;

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

  input Types.ComplexImpedancePu ZPu " Transformer impedance in pu (base U2Nom, SnRef)";
  input Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  input Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  input Integer NbTap "Number of taps";
  input Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  input Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  input Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  output Integer Tap0 "Estimated tap";

protected
  Types.PerUnit rcTfo0Pu "Ratio value corresponding to the voltage set point on side 2 in pu: U2/U1 in no load conditions";
  Types.ComplexVoltagePu deltauPu "Voltage drop due to the impedance in pu (base U2Nom, SnRef)";

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

  annotation(preferredView = "text");
end TapEstimation;
