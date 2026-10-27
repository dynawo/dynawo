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

model ElectricalController "Electrical control model for an injector in the modified Nordic system"

  parameter Types.CurrentModulePu IMaxPu "Maximum current module in pu (base SNom, UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Time t4 "Filter time constant for the voltage, in s";
  parameter Types.Time t5 "Reactive current filter time constant in s";
  parameter Types.Time t6 "Active power filter time constant in s";
  parameter Types.VoltageModulePu VtDbPu "Half-width of dead band for voltage at the terminal in pu (base UNom)";

  Types.PerUnit IdMaxPu "Maximum active current in pu (base SNom, UNom)";
  Types.PerUnit IdMinPu "Minimum active current in pu (base SNom, UNom)";
  Types.PerUnit IqMaxPu "Maximum reactive current in pu (base SNom, UNom)";
  Types.PerUnit IqMinPu "Minimum reactive current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QExtPu(start = QExt0Pu) "Reactive power output of the plant controller in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {-200, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtPu(start = U0Pu) "Voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtRefPu(start = U0Pu) "Reference voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput IdRefPu(start = Id0Pu) "Active current reference in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {190, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput IqRefPu(start = Iq0Pu) "Reactive current reference in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {190, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(y_start = U0Pu, T = t4) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(uMax = VtDbPu) annotation(
    Placement(transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(y_start = -P0Pu * SystemBase.SnRef / SNom, T = t6) annotation(
    Placement(transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = t5, y_start = -Iq0Pu) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = IqMaxPu) annotation(
    Placement(transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = IqMinPu) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = IdMaxPu) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = IdMinPu) annotation(
    Placement(transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(transformation(origin = {148, 40}, extent = {{-10, -10}, {10, 10}})));

  parameter Types.PerUnit Id0Pu "Initial active current in pu (base SNom, UNom)";
  parameter Types.PerUnit Iq0Pu "Initial reactive current in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu P0Pu "Initial active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QExt0Pu "Initial reactive power output of the plant controller in pu (base SNom, UNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at the terminal in pu (base UNom)";

equation
  IdMinPu = 0;
  IdMaxPu = sqrt(max(0, IMaxPu^2 - noEvent(min(IqRefPu^2, 1))));
  IqMaxPu = IMaxPu;
  IqMinPu = -IMaxPu;

  connect(VtPu, firstOrder1.u) annotation(
    Line(points = {{-200, 40}, {-162, 40}}, color = {0, 0, 127}));
  connect(VtRefPu, add1.u2) annotation(
    Line(points = {{-200, 0}, {-120, 0}, {-120, 14}, {-82, 14}}, color = {0, 0, 127}));
  connect(add1.y, deadZone1.u) annotation(
    Line(points = {{-59, 20}, {-22, 20}}, color = {0, 0, 127}));
  connect(deadZone1.y, add2.u2) annotation(
    Line(points = {{1, 20}, {20, 20}, {20, 34}, {38, 34}}, color = {0, 0, 127}));
  connect(PRefPu, firstOrder.u) annotation(
    Line(points = {{-200, -60}, {-162, -60}}, color = {0, 0, 127}));
  connect(firstOrder.y, division1.u1) annotation(
    Line(points = {{-139, -60}, {-100, -60}, {-100, -46}, {-82, -46}}, color = {0, 0, 127}));
  connect(division.y, firstOrder2.u) annotation(
    Line(points = {{-59, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add2.u1) annotation(
    Line(points = {{1, 60}, {20, 60}, {20, 46}, {38, 46}}, color = {0, 0, 127}));
  connect(add2.y, variableLimiter.u) annotation(
    Line(points = {{61, 40}, {98, 40}}, color = {0, 0, 127}));
  connect(variableLimiter.y, gain.u) annotation(
    Line(points = {{121, 40}, {136, 40}}, color = {0, 0, 127}));
  connect(gain.y, IqRefPu) annotation(
    Line(points = {{159, 40}, {190, 40}}, color = {0, 0, 127}));
  connect(realExpression.y, variableLimiter.limit1) annotation(
    Line(points = {{61, 80}, {80, 80}, {80, 48}, {98, 48}}, color = {0, 0, 127}));
  connect(realExpression1.y, variableLimiter.limit2) annotation(
    Line(points = {{61, 0}, {80, 0}, {80, 32}, {98, 32}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{-59, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(realExpression2.y, variableLimiter1.limit1) annotation(
    Line(points = {{-59, -20}, {-40, -20}, {-40, -32}, {-22, -32}}, color = {0, 0, 127}));
  connect(realExpression3.y, variableLimiter1.limit2) annotation(
    Line(points = {{-59, -80}, {-40, -80}, {-40, -48}, {-22, -48}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, IdRefPu) annotation(
    Line(points = {{1, -40}, {190, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, division1.u2) annotation(
    Line(points = {{-139, 40}, {-100, 40}, {-100, -34}, {-82, -34}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add1.u1) annotation(
    Line(points = {{-139, 40}, {-100, 40}, {-100, 26}, {-82, 26}}, color = {0, 0, 127}));
  connect(firstOrder1.y, division.u2) annotation(
    Line(points = {{-139, 40}, {-100, 40}, {-100, 54}, {-82, 54}}, color = {0, 0, 127}));
  connect(QExtPu, division.u1) annotation(
    Line(points = {{-200, 80}, {-100, 80}, {-100, 66}, {-82, 66}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><div>The control model is described in the paper <a href=\"https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9446224\">\"Impact of Inverter-Based Generation on Voltage Stability in a Modiﬁed Nordic Test System\"</a>.</div><div><p dir=\"auto\">Plant control : V control</p>
<p dir=\"auto\">Converter control :<br>
Q control : constant reactive power control + voltage control for reactive current injection during voltage dips<br>
P control : constant active power control</p>
<p dir=\"auto\">Current limits logic with Q priority</p></div></body></html>"));
end ElectricalController;
