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
  parameter Types.PerUnit Kd "Demagnetizing factor, function of exciter alternator reactances";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";

  Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

  Modelica.Blocks.Sources.RealExpression realExpressionInit(y = Ve0Pu);
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic fRectInit;

equation
  fRectInit.u = Kc * Ir0Pu / Ve0Pu;
  Efd0Pu = Ve0Pu * fRectInit.y;
  Efe0Pu = Kd * Ir0Pu + Ve0Pu * (Ke + AEx * exp(BEx * Ve0Pu));
  VeMax0Pu = (VfeMaxPu - Kd * Ir0Pu) / (Ve0Pu * (Ke + AEx * exp(BEx * Ve0Pu)));

  annotation(preferredView = "text");
end AcRotatingExciter_INIT;
