within Dynawo.Electrical.PEIR.BaseControls.Simplified;

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

model ElectricalControlNordic "Control model for an injector in the modified Nordic system"

  parameter Types.CurrentModulePu IMaxPu "Maximum current module in pu (base SNom, UNom)";
  parameter Real Ki "Integrator gain of voltage control";
  parameter Real Kp "Proportional gain of voltage control";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Time t1 "Filter time constant for the voltage at the PCC, in s";
  parameter Types.Time t2 "Lead time constant of voltage control in s";
  parameter Types.Time t3 "Lag time constant of voltage control in s";
  parameter Types.Time t4 "Filter time constant for the voltage, in s";
  parameter Types.Time t5 "Reactive current filter time constant in s";
  parameter Types.Time t6 "Active power filter time constant in s";

  Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SNom)";
  Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SNom)";
  Types.PerUnit IdMaxPu "Maximum active current in pu (base SNom, UNom)";
  Types.PerUnit IdMinPu "Minimum active current in pu (base SNom, UNom)";
  Types.PerUnit IqMaxPu "Maximum reactive current in pu (base SNom, UNom)";
  Types.PerUnit IqMinPu "Minimum reactive current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-240, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRefPu "Reference voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRegPu "Voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtPu(start = U0Pu) "Voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtRefPu(start = U0Pu) "Reference voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput IdRefPu(start = Id0Pu) "Active current reference in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {210, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput IqRefPu(start = Iq0Pu) "Reactive current reference in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QExtPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power output of the plant controller in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {210, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = 0.01) annotation(
    Placement(transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.TransferFunction transferFunction(b = {t2, 1}, a = {t3, 1}, initType = Modelica.Blocks.Types.Init.SteadyState, u_start = -Q0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(y_start = U0Pu, T = t4) annotation(
    Placement(transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(uMax = 0.01) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(y_start = -P0Pu * SystemBase.SnRef / SNom, T = t6) annotation(
    Placement(transformation(origin = {-190, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-50, -80}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = t5, y_start = -Iq0Pu) annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = IqMaxPu) annotation(
    Placement(transformation(origin = {70, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = IqMinPu) annotation(
    Placement(transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(transformation(origin = {10, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = IdMaxPu) annotation(
    Placement(transformation(origin = {-50, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = IdMinPu) annotation(
    Placement(transformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.PI pi(Ki = Ki, Kp = Kp, Y0 = -Q0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter2 annotation(
    Placement(transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = QMaxPu) annotation(
    Placement(transformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y = QMinPu) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 10) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(transformation(origin = {168, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = t1, y_start = VReg0Pu) annotation(
    Placement(transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}})));

  parameter Types.PerUnit Id0Pu "Initial active current in pu (base SNom, UNom)";
  parameter Types.PerUnit Iq0Pu "Initial reactive current in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu P0Pu "Initial active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at the terminal in pu (base UNom)";
  parameter Types.VoltageModulePu VReg0Pu "Initial voltage amplitude at the PCC in pu (base UNom)";

equation
  IdMinPu = 0;
  IdMaxPu = sqrt(max(0, IMaxPu ^ 2 - noEvent(min(IqRefPu ^ 2, 1))));
  IqMaxPu = IMaxPu;
  IqMinPu = -IMaxPu;
  QMaxPu = VtPu * IqMaxPu;
  QMinPu = VtPu * IqMinPu;

  connect(VRefPu, add.u1) annotation(
    Line(points = {{-240, 100}, {-160, 100}, {-160, 86}, {-142, 86}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{-119, 80}, {-102, 80}}, color = {0, 0, 127}));
  connect(VtPu, firstOrder1.u) annotation(
    Line(points = {{-240, 0}, {-202, 0}}, color = {0, 0, 127}));
  connect(VtRefPu, add1.u2) annotation(
    Line(points = {{-240, -40}, {-100, -40}, {-100, -26}, {-62, -26}}, color = {0, 0, 127}));
  connect(add1.y, deadZone1.u) annotation(
    Line(points = {{-39, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(deadZone1.y, add2.u2) annotation(
    Line(points = {{21, -20}, {40, -20}, {40, -6}, {58, -6}}, color = {0, 0, 127}));
  connect(PRefPu, firstOrder.u) annotation(
    Line(points = {{-240, -100}, {-202, -100}}, color = {0, 0, 127}));
  connect(firstOrder.y, division1.u1) annotation(
    Line(points = {{-179, -100}, {-80, -100}, {-80, -86}, {-62, -86}}, color = {0, 0, 127}));
  connect(transferFunction.y, division.u1) annotation(
    Line(points = {{61, 80}, {80, 80}, {80, 40}, {-80, 40}, {-80, 26}, {-62, 26}}, color = {0, 0, 127}));
  connect(division.y, firstOrder2.u) annotation(
    Line(points = {{-39, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add2.u1) annotation(
    Line(points = {{21, 20}, {40, 20}, {40, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(add2.y, variableLimiter.u) annotation(
    Line(points = {{81, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, gain.u) annotation(
    Line(points = {{142, 0}, {156, 0}}, color = {0, 0, 127}));
  connect(gain.y, IqRefPu) annotation(
    Line(points = {{180, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(realExpression.y, variableLimiter.limit1) annotation(
    Line(points = {{81, 30}, {100, 30}, {100, 8}, {118, 8}}, color = {0, 0, 127}));
  connect(realExpression1.y, variableLimiter.limit2) annotation(
    Line(points = {{81, -30}, {100, -30}, {100, -8}, {118, -8}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{-39, -80}, {-3, -80}}, color = {0, 0, 127}));
  connect(realExpression2.y, variableLimiter1.limit1) annotation(
    Line(points = {{-39, -50}, {-20, -50}, {-20, -72}, {-2, -72}}, color = {0, 0, 127}));
  connect(realExpression3.y, variableLimiter1.limit2) annotation(
    Line(points = {{-39, -110}, {-20, -110}, {-20, -88}, {-3, -88}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, IdRefPu) annotation(
    Line(points = {{21, -80}, {210, -80}}, color = {0, 0, 127}));
  connect(deadZone.y, pi.u) annotation(
    Line(points = {{-79, 80}, {-62, 80}}, color = {0, 0, 127}));
  connect(pi.y, variableLimiter2.u) annotation(
    Line(points = {{-39, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(variableLimiter2.y, transferFunction.u) annotation(
    Line(points = {{21, 80}, {38, 80}}, color = {0, 0, 127}));
  connect(realExpression4.y, variableLimiter2.limit1) annotation(
    Line(points = {{-39, 110}, {-20, 110}, {-20, 88}, {-2, 88}}, color = {0, 0, 127}));
  connect(realExpression5.y, variableLimiter2.limit2) annotation(
    Line(points = {{-39, 50}, {-20, 50}, {-20, 72}, {-2, 72}}, color = {0, 0, 127}));
  connect(firstOrder1.y, limiter.u) annotation(
    Line(points = {{-179, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(limiter.y, division1.u2) annotation(
    Line(points = {{-99, 0}, {-80, 0}, {-80, -74}, {-62, -74}}, color = {0, 0, 127}));
  connect(limiter.y, add1.u1) annotation(
    Line(points = {{-99, 0}, {-80, 0}, {-80, -14}, {-62, -14}}, color = {0, 0, 127}));
  connect(limiter.y, division.u2) annotation(
    Line(points = {{-99, 0}, {-80, 0}, {-80, 14}, {-62, 14}}, color = {0, 0, 127}));
  connect(VRegPu, firstOrder3.u) annotation(
    Line(points = {{-240, 60}, {-202, 60}}, color = {0, 0, 127}));
  connect(firstOrder3.y, add.u2) annotation(
    Line(points = {{-178, 60}, {-160, 60}, {-160, 74}, {-142, 74}}, color = {0, 0, 127}));
  connect(transferFunction.y, QExtPu) annotation(
    Line(points = {{62, 80}, {210, 80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-220, -120}, {200, 120}}), graphics = {Rectangle(lineColor = {196, 160, 0}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-210, 120}, {100, 42.5}}), Text(textColor = {196, 160, 0}, extent = {{-20, 120}, {100, 100}}, textString = "Plant controller"), Rectangle(lineColor = {206, 92, 0}, pattern = LinePattern.Dash, lineThickness = 1, extent = {{-210, 37.5}, {190, -120}}), Text(textColor = {206, 92, 0}, extent = {{40, -100}, {180, -120}}, textString = "Electrical control")}),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html><head></head><body><div>The control model is described in the paper <a href=\"https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9446224\">\"Impact of Inverter-Based Generation on Voltage Stability in a Modiﬁed Nordic Test System\"</a>.</div><div><p dir=\"auto\">Plant control : V control</p>
<p dir=\"auto\">Converter control :<br>
Q control : constant reactive power control + voltage control for reactive current injection during voltage dips<br>
P control : constant active power control</p>
<p dir=\"auto\">Current limits logic with Q priority</p></div></body></html>"));
end ElectricalControlNordic;
