within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ActivePowerControl "Active power control for the HVDC VSC model"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl.BaseActivePowerControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDeltaP;

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput activateDeltaP(start = false) "If true, DeltaP is activated" annotation(
    Placement(visible = true, transformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UDcPu(start = UDc0Pu) "DC voltage in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = UDcMaxPu, uMin = UDcMinPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup PI(Ki = KiDeltaP, Kp = KpDeltaP, Y0 = 0, YMax = IpMaxPu, YMin = -IpMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-120, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu UDc0Pu "Start value of DC voltage in pu (base UDcNom)";

equation
  connect(activateDeltaP, switch.u2) annotation(
    Line(points = {{-220, 60}, {-22, 60}}, color = {255, 0, 255}));
  connect(PI.y, switch.u1) annotation(
    Line(points = {{-59, 100}, {-40, 100}, {-40, 68}, {-22, 68}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-59, 20}, {-40, 20}, {-40, 52}, {-22, 52}}, color = {0, 0, 127}));
  connect(switch.y, add1.u1) annotation(
    Line(points = {{1, 60}, {20, 60}, {20, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(UDcPu, limiter1.u) annotation(
    Line(points = {{-220, 100}, {-180, 100}, {-180, 80}, {-162, 80}}, color = {0, 0, 127}));
  connect(limiter1.y, feedback1.u2) annotation(
    Line(points = {{-138, 80}, {-120, 80}, {-120, 92}}, color = {0, 0, 127}));
  connect(UDcPu, feedback1.u1) annotation(
    Line(points = {{-220, 100}, {-128, 100}}, color = {0, 0, 127}));
  connect(feedback1.y, PI.u) annotation(
    Line(points = {{-110, 100}, {-82, 100}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -160}, {200, 160}})));
end ActivePowerControl;
