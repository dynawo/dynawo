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
  extends Icons.BasesPackage;

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

function IdealTransformerTapEstimation "Function that estimates the initial tap of an ideal transformer"
  extends Icons.Function;

  /*
  It is done using the voltage value on side 1 and the set point value for the voltage module on side 2.
  The tap is determined as the closest value to an estimated tap based on the minimum and maximum tap values.
  */

  input Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  input Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  input Integer NbTap "Number of taps";
  input Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  input Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  output Integer Tap0 "Estimated tap";

protected
  Types.PerUnit rcTfo0Pu "Ratio value corresponding to the voltage set point on side 2 in pu: U2/U1 in no load conditions";
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

  // Initial ratio calculation
  rcTfo0Pu := Uc20Pu / ComplexMath. 'abs'(u10Pu);

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
end IdealTransformerTapEstimation;


// Base model for initialization of transformers with parameters
partial model BaseTransformerParameters_INIT "Base model for initialization of transformers"
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";

equation
  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

  annotation(preferredView = "text");
end BaseTransformerParameters_INIT;

// Base model for initialization of transformers with variables
partial model BaseTransformerVariables_INIT "Base model for initialization of transformers"
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";

  Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  U10Pu = ComplexMath.'abs' (u10Pu);
  P10Pu = ComplexMath.real(u10Pu * ComplexMath.conj(i10Pu));
  Q10Pu = ComplexMath.imag(u10Pu * ComplexMath.conj(i10Pu));

  annotation(preferredView = "text");
end BaseTransformerVariables_INIT;

// Base model for initialization of transformers with variable tap
partial model BaseTransformerVariableTapCommon_INIT "Base model for initialization of transformers with variable tap"

/*
  The initialization scheme is specific and considers that the values on only one side of the transformer are known plus the voltage set point on the other side.
  From these values, the tap position and its corresponding ratio are determined.
  From the tap and ratio values, the final U2, P2 and Q2 values are calculated.
*/
  import Dynawo.Electrical.SystemBase;

  // Transformer's parameters
  parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer NbTap "Number of taps";
  parameter Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  // Transformer start values
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

  Integer Tap0 "Start value of transformer tap";
  Types.PerUnit rTfo0Pu "Start value of transformer ratio";
  Constants.state state0 = Constants.state.Closed "Start value of connection state";

equation
  // Initial ratio estimation
  if (NbTap == 1) then
    rTfo0Pu = rTfoMinPu;
  else
    rTfo0Pu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (Tap0 / (NbTap - 1));
  end if;

  // Voltage at terminal 2
  U20Pu = ComplexMath.'abs' (u20Pu);

  annotation(preferredView = "text");
end BaseTransformerVariableTapCommon_INIT;

partial model BaseTransformerVariableTap_INIT "Base model for initialization of TransformerVariableTap"
  extends BaseTransformerVariableTapCommon_INIT;

/*  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";

protected
  // Transformer's impedance and susceptance
  parameter Types.ComplexImpedancePu ZPu(re = R / 100 * SystemBase.SnRef / SNom, im = X / 100 * SystemBase.SnRef / SNom) "Transformer impedance in pu (base U2Nom, SnRef)";
  parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in pu (base U2Nom, SnRef)";

  annotation(preferredView = "text");
end BaseTransformerVariableTap_INIT;

partial model BaseGeneratorTransformer_INIT "Base model for initialization of GeneratorTransformer"

/*
  This model enables to initialize the generator model when the load-flow inputs are not known at the generator terminal but at the generator transformer terminal.
  Usually, terminal 1 in the network terminal and terminal 2 in the generator terminal.

  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/
  import Dynawo.Electrical.SystemBase;

  // Start values at terminal (network terminal side)
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 (base U1Nom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (base U1Nom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 (base U2Nom)";
  Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (base U2Nom, SnRef) (receptor convention)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";
  Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu Q20Pu "Start value of reactive power at terminal 2 in pu (base SnRef) (generator convention)";
  Types.Angle U2Phase0 "Start value of voltage angle in rad";

equation
  s10Pu = Complex(P10Pu, Q10Pu);
  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

  P20Pu = - ComplexMath.real(u20Pu * ComplexMath.conj(i20Pu));
  Q20Pu = - ComplexMath.imag(u20Pu * ComplexMath.conj(i20Pu));
  U20Pu = ComplexMath.'abs' (u20Pu);
  U2Phase0 = ComplexMath.arg(u20Pu);

  annotation(preferredView = "text");
end BaseGeneratorTransformer_INIT;


annotation(preferredView = "text");
end BaseClasses_INIT;
