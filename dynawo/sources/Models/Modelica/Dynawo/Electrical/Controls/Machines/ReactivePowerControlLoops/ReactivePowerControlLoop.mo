within Dynawo.Electrical.Controls.Machines.ReactivePowerControlLoops;

model ReactivePowerControlLoop "Simplified Reactive Power Control Loop model"
  /*
  * Copyright (c) 2022, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  parameter Types.PerUnit DerURefMaxPu "Maximum variation rate of UStatorRefPu in pu/s (base UNom)";
  parameter Types.ReactivePowerPu QrPu "Participation factor of the generator to the secondary voltage control in pu (base QNomAlt)";
  parameter Types.Time TiQ "Reactive power control loop integrator time constant in s";
  parameter Types.VoltageModulePu UStatorRefMinPu = 0.85 "Minimum reference voltage for the generator voltage regulator in pu (base UNom)";
  parameter Types.VoltageModulePu UStatorRefMaxPu = 1.15 "Maximum reference voltage for the generator voltage regulator in pu (base UNom)";
  parameter Types.ReactivePowerPu QDeadBand = 0 "Deadband of the difference between actual and requested generator stator reactive power in pu (base QNomAlt)";
  type UStatus = enumeration(Standard, LimitUMin, LimitUMax);
  // Input variables
  Modelica.Blocks.Interfaces.RealInput level "Level received from the secondary voltage control [-1;1] " annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocker(start = blocker0) "Whether the the reactive power control loop is blocked or not" annotation(
    Placement(transformation(origin = {-170, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QStatorPu(start = QStator0Pu) "Generator stator reactive power in pu (base QNomAlt) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-172, -40}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-164, -28}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  // Output variables
  Modelica.Blocks.Interfaces.RealOutput UStatorRefPu(start = UStatorRef0Pu) "Reference voltage for the generator voltage regulator in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {218, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Blocks
  Modelica.Blocks.Math.Gain participation(k = QrPu) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback errQ annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainIntegrator(k = 1/TiQ) annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter rampLim(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {22, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = DerURefMaxPu) annotation(
    Placement(transformation(origin = {-168, 122}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const3(k = -DerURefMaxPu) annotation(
    Placement(transformation(origin = {-170, -120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter_UStatorRefMinMaxPu(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = UStatorRefMaxPu, uMin = UStatorRefMinPu) annotation(
    Placement(transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator limitedIntegrator(Y0 = UStatorRef0Pu, YMax = UStatorRefMaxPu, YMin = UStatorRefMinPu) annotation(
    Placement(transformation(origin = {52, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression blocking(y = ((uStatus == UStatus.LimitUMax and errQ.y <= 0) or (uStatus == UStatus.LimitUMin and errQ.y >= 0) or blocker)) "Expression determining  if the reactive power or voltage have reached a limit" annotation(
    Placement(transformation(origin = {52, 88}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput UQBlocker annotation(
    Placement(transformation(origin = {110, 88}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {188, 86}, extent = {{-10, -10}, {10, 10}})));
  parameter Boolean blocker0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter Types.ReactivePowerPu QStator0Pu "Start value of the generator stator reactive power in pu (base QNomAlt) (generator convention)";
  parameter Types.VoltageModulePu UStatorRef0Pu "Start value of the generator stator voltage reference in pu (base UNom)";
  Dynawo.NonElectrical.Blocks.NonLinear.DeadZone deadZone(uMax = QDeadBand, uMin = -QDeadBand) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.ConstantSwitch errQLim annotation(
    Placement(transformation(origin = {-74, 0}, extent = {{-10, -10}, {10, 10}})));
protected
  UStatus uStatus(start = UStatus.Standard) "Status of the voltage reference";
equation
  when limiter_UStatorRefMinMaxPu.u >= limiter_UStatorRefMinMaxPu.uMax and pre(uStatus) <> UStatus.LimitUMax then
    uStatus = UStatus.LimitUMax;
    Timeline.logEvent1(TimelineKeys.RPCLLimitationUsRefMax);
  elsewhen limiter_UStatorRefMinMaxPu.u <= limiter_UStatorRefMinMaxPu.uMin and pre(uStatus) <> UStatus.LimitUMin then
    uStatus = UStatus.LimitUMin;
    Timeline.logEvent1(TimelineKeys.RPCLLimitationUsRefMin);
  elsewhen limiter_UStatorRefMinMaxPu.u < limiter_UStatorRefMinMaxPu.uMax and pre(uStatus) == UStatus.LimitUMax then
    uStatus = UStatus.Standard;
    Timeline.logEvent1(TimelineKeys.RPCLStandard);
  elsewhen limiter_UStatorRefMinMaxPu.u > limiter_UStatorRefMinMaxPu.uMin and pre(uStatus) == UStatus.LimitUMin then
    uStatus = UStatus.Standard;
    Timeline.logEvent1(TimelineKeys.RPCLStandard);
  end when;
  connect(rampLim.u, gainIntegrator.y) annotation(
    Line(points = {{10, 0}, {1, 0}}, color = {0, 0, 127}));
  connect(errQ.u2, QStatorPu) annotation(
    Line(points = {{-100, -8}, {-100, -40}, {-172, -40}}, color = {0, 0, 127}));
  connect(errQ.u1, participation.y) annotation(
    Line(points = {{-108, 0}, {-119, 0}}, color = {0, 0, 127}));
  connect(level, participation.u) annotation(
    Line(points = {{-170, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(limiter_UStatorRefMinMaxPu.y, UStatorRefPu) annotation(
    Line(points = {{95, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(rampLim.y, limitedIntegrator.u) annotation(
    Line(points = {{33, 0}, {40, 0}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, limiter_UStatorRefMinMaxPu.u) annotation(
    Line(points = {{63, 0}, {72, 0}}, color = {0, 0, 127}));
  connect(const3.y, rampLim.limit2) annotation(
    Line(points = {{-159, -120}, {-4, -120}, {-4, -8}, {10, -8}}, color = {0, 0, 127}));
  connect(const2.y, rampLim.limit1) annotation(
    Line(points = {{-156, 122}, {10, 122}, {10, 8}}, color = {0, 0, 127}));
  connect(deadZone.y, gainIntegrator.u) annotation(
    Line(points = {{-28, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(blocking.y, UQBlocker) annotation(
    Line(points = {{63, 88}, {110, 88}}, color = {255, 0, 255}));
  connect(errQLim.u1, errQ.y) annotation(
    Line(points = {{-86, 7}, {-86, 8.5}, {-90, 8.5}, {-90, 0}}, color = {0, 0, 127}));
  connect(errQLim.y, deadZone.u) annotation(
    Line(points = {{-62, 3}, {-62, 0}, {-52, 0}}, color = {0, 0, 127}));
  connect(errQLim.u2, blocker) annotation(
    Line(points = {{-86, 0}, {-86, -80}, {-170, -80}}, color = {255, 0, 255}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -180}, {100, 140}})),
    Documentation(info = "<html><body>The reactive control loop gets a level K from the secondary voltage control and transforms it into a voltage reference for the generator voltage regulator</body></html>"));
end ReactivePowerControlLoop;
