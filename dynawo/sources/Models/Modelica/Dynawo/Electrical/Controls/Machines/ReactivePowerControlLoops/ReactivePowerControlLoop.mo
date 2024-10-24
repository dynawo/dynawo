within Dynawo.Electrical.Controls.Machines.ReactivePowerControlLoops;

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

model ReactivePowerControlLoop "Simplified Reactive Power Control Loop model"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.PerUnit DerURefMaxPu "Maximum variation rate of UStatorRefPu in pu/s (base UNom)";
  parameter Types.ReactivePowerPu QrPu "Participation factor of the generator to the secondary voltage control in pu (base QNomAlt)";
  parameter Types.Time TiQ "Reactive power control loop integrator time constant in s";
  parameter Types.VoltageModulePu UStatorRefMinPu = 0.85 "Minimum reference voltage for the generator voltage regulator in pu (base UNom)";
  parameter Types.VoltageModulePu UStatorRefMaxPu = 1.15 "Maximum reference voltage for the generator voltage regulator in pu (base UNom)";

  type UStatus = enumeration(Standard, LimitUMin, LimitUMax);

  // Input variables
  Modelica.Blocks.Interfaces.RealInput level "Level received from the secondary voltage control [-1;1] " annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput limUQDown(start = limUQDown0) "Whether the minimum reactive power limits are reached or not" annotation(
    Placement(visible = true, transformation(origin = {-170, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput limUQUp(start = limUQUp0) "Whether the maximum reactive power limits are reached or not" annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Modelica.Blocks.Continuous.Integrator integrator(k = 1, y_start = UStatorRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainIntegrator(k = 1 / TiQ) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter rampLim(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch swLimUp annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch swLimDown annotation(
    Placement(visible = true, transformation(origin = {-88, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = DerURefMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = -DerURefMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-170, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter_UStatorRefMinMaxPu(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = UStatorRefMaxPu, uMin = UStatorRefMinPu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Boolean limUQDown0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter Boolean limUQUp0 "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter Types.ReactivePowerPu QStator0Pu "Start value of the generator stator reactive power in pu (base QNomAlt) (generator convention)";
  parameter Types.VoltageModulePu UStatorRef0Pu "Start value of the generator stator voltage reference in pu (base UNom)";

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
    Line(points = {{-22, 0}, {-59, 0}}, color = {0, 0, 127}));
  connect(integrator.u, rampLim.y) annotation(
    Line(points = {{18, 0}, {1, 0}}, color = {0, 0, 127}));
  connect(errQ.u2, QStatorPu) annotation(
    Line(points = {{-100, -8}, {-100, -40}, {-172, -40}}, color = {0, 0, 127}));
  connect(errQ.u1, participation.y) annotation(
    Line(points = {{-108, 0}, {-119, 0}}, color = {0, 0, 127}));
  connect(level, participation.u) annotation(
    Line(points = {{-170, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(limUQUp, swLimUp.u2) annotation(
    Line(points = {{-170, 80}, {-122, 80}}, color = {255, 0, 255}));
  connect(limUQDown, swLimDown.u2) annotation(
    Line(points = {{-170, -120}, {-100, -120}}, color = {255, 0, 255}));
  connect(errQ.y, gainIntegrator.u) annotation(
    Line(points = {{-91, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(const2.y, swLimUp.u3) annotation(
    Line(points = {{-159, 40}, {-140, 40}, {-140, 72}, {-122, 72}}, color = {0, 0, 127}));
  connect(const.y, swLimUp.u1) annotation(
    Line(points = {{-159, 120}, {-140, 120}, {-140, 88}, {-122, 88}}, color = {0, 0, 127}));
  connect(const1.y, swLimDown.u1) annotation(
    Line(points = {{-158, -80}, {-140, -80}, {-140, -112}, {-100, -112}}, color = {0, 0, 127}));
  connect(const3.y, swLimDown.u3) annotation(
    Line(points = {{-158, -160}, {-140, -160}, {-140, -128}, {-100, -128}}, color = {0, 0, 127}));
  connect(swLimUp.y, rampLim.limit1) annotation(
    Line(points = {{-99, 80}, {-40, 80}, {-40, 8}, {-22, 8}}, color = {0, 0, 127}));
  connect(swLimDown.y, rampLim.limit2) annotation(
    Line(points = {{-76, -120}, {-40, -120}, {-40, -8}, {-22, -8}}, color = {0, 0, 127}));
  connect(integrator.y, limiter_UStatorRefMinMaxPu.u) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(limiter_UStatorRefMinMaxPu.y, UStatorRefPu) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -180}, {100, 140}})),
    Documentation(info = "<html><body>The reactive control loop gets a level K from the secondary voltage control and transforms it into a voltage reference for the generator voltage regulator</body></html>"));
end ReactivePowerControlLoop;
