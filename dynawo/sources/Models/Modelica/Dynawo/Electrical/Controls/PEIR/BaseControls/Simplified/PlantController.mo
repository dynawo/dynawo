within Dynawo.Electrical.Controls.PEIR.BaseControls.Simplified;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model PlantController "Plant control model for an injector in the modified Nordic system"

  parameter Types.PerUnit Ki "Integrator gain of plant control";
  parameter Types.PerUnit Kp "Proportional gain of plant control";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SNom)";
  parameter Types.Time t1 "Filter time constant for the voltage at the PCC, in s";
  parameter Types.Time t2 "Lead time constant of plant control in s";
  parameter Types.Time t3 "Lag time constant of plant control in s";
  parameter Types.VoltageModulePu VRegDbPu "Half-width of dead band for voltage at the PCC in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput VRefPu(start = VReg0Pu) "Reference voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-160, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRegPu(start = VReg0Pu) "Voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-160, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput QExtPu(start = QExt0Pu) "Reactive power output of the plant controller in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = VRegDbPu) annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.TransferFunction transferFunction(b = {t2, 1}, a = {t3, 1}, initType = Modelica.Blocks.Types.Init.SteadyState, u_start = QExt0Pu) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.PI pi(Ki = Ki, Kp = Kp, Y0 = QExt0Pu) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = QMaxPu, uMin = QMinPu) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = t1, y_start = VReg0Pu) annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));

  parameter Types.ReactivePowerPu QExt0Pu "Initial reactive power output of the plant controller in pu (base SNom, UNom) (generator convention)";
  parameter Types.VoltageModulePu VReg0Pu "Initial voltage amplitude at the PCC in pu (base UNom)";

equation
  connect(VRefPu, add.u1) annotation(
    Line(points = {{-160, 20}, {-80, 20}, {-80, 6}, {-62, 6}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{-39, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(deadZone.y, pi.u) annotation(
    Line(points = {{1, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(pi.y, limiter.u) annotation(
    Line(points = {{41, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(limiter.y, transferFunction.u) annotation(
    Line(points = {{81, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(VRegPu, firstOrder3.u) annotation(
    Line(points = {{-160, -20}, {-122, -20}}, color = {0, 0, 127}));
  connect(firstOrder3.y, add.u2) annotation(
    Line(points = {{-99, -20}, {-80, -20}, {-80, -6}, {-63, -6}}, color = {0, 0, 127}));
  connect(transferFunction.y, QExtPu) annotation(
    Line(points = {{121, 0}, {150, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -120}, {140, 120}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><div>The control model is described in the paper <a href=\"https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9446224\">\"Impact of Inverter-Based Generation on Voltage Stability in a Modiﬁed Nordic Test System\"</a>.</div><div><p dir=\"auto\">Plant control : V control</p>
<p dir=\"auto\">Converter control :<br>
Q control : constant reactive power control + voltage control for reactive current injection during voltage dips<br>
P control : constant active power control</p>
<p dir=\"auto\">Current limits logic with Q priority</p></div></body></html>"));
end PlantController;
