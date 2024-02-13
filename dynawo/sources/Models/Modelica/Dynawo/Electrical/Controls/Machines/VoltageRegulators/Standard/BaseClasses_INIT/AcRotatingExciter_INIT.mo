within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses_INIT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model AcRotatingExciter_INIT "Rotating exciter initialization model for IEEE regulations type AC"
  extends AdditionalIcons.Init;

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kd "Exciter internal reactance";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";

  //Rectifier regulation characteristic parameters
  parameter Real UHigh = 0.75 "Upper limit of non-linear mode";
  parameter Real ULow = 0.433 "Lower limit of non-linear mode";

  final parameter Real A1 = (1 - sqrt(UHigh - ULow ^ 2)) / ULow "Characteristic coefficient of first linear mode";
  final parameter Real A2 = sqrt(UHigh / (1 - UHigh)) "Characteristic coefficient of second linear mode";

  Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  Real U01, U02, U03, U04 "Possible initial input values for the rectifier regulation characteristic";
  Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";
  Real Y0 "Output value of the rectifier regulation characteristic";

  Modelica.Blocks.Sources.RealExpression realExpressionInit(y = Ve0Pu);

equation
  U01 = Kc * Ir0Pu / Efd0Pu;
  U02 = Kc * Ir0Pu / (Efd0Pu + A1 * Kc * Ir0Pu);
  U03 = Kc * Ir0Pu * sqrt(UHigh / (Efd0Pu ^ 2 + (Kc * Ir0Pu) ^ 2));
  U04 = Kc * Ir0Pu / (Efd0Pu / A2 + Kc * Ir0Pu);

  if U01 <= 0 then
    Y0 = 1;
  elseif U02 > 0 and U02 <= ULow then
    Y0 = 1 - A1 * U02;
  elseif U03 > ULow and U03 < UHigh then
    Y0 = sqrt(UHigh - U03 ^ 2);
  elseif U04 >= UHigh and U04 <= 1 then
    Y0 = A2 * (1 - U04);
  else
    Y0 = 1;
  end if;

  Efd0Pu = Ve0Pu * Y0;
  Efe0Pu = Kd * Ir0Pu + Ve0Pu * (Ke + AEx * exp(BEx * Ve0Pu));
  VeMax0Pu = (VfeMaxPu - Kd * Ir0Pu) / (Ve0Pu * (Ke + AEx * exp(BEx * Ve0Pu)));

  annotation(preferredView = "text");
end AcRotatingExciter_INIT;
