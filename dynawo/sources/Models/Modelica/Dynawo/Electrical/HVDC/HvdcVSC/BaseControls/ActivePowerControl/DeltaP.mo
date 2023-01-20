within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ActivePowerControl;

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

model DeltaP "Function that calculates a DeltaP for the active power control side of the HVDC link to help the other side maintain the DC voltage"
  import Modelica;
  import Dynawo.NonElectrical.Blocks;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_DeltaP;
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput DeltaPRawPu(start = 0) "Corrective signal to adjust the active power in the case where the DC voltage control side of the HVDC link cannot control the DC voltage anymore" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = UdcMaxPu, uMin = UdcMinPu) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.PIAntiWindup PI(Ki = KiDeltaP, Kp = KpDeltaP, uMax = IpMaxCstPu, uMin = -IpMaxCstPu) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Udc0Pu "Start value of dc voltage in pu (base SNom, UNom)";
  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";

equation
  connect(UdcPu, limiter.u) annotation(
    Line(points = {{-120, 0}, {-72, 0}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-49, 0}, {-18, 0}}, color = {0, 0, 127}));
  connect(UdcPu, feedback.u2) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, -20}, {-10, -20}, {-10, -8}}, color = {0, 0, 127}));
  connect(feedback.y, PI.u) annotation(
    Line(points = {{-1, 0}, {30, 0}, {30, 0}, {32, 0}}, color = {0, 0, 127}));
  connect(PI.y, gain.u) annotation(
    Line(points = {{55, 0}, {66, 0}, {66, 0}, {66, 0}}, color = {0, 0, 127}));
  connect(gain.y, DeltaPRawPu) annotation(
    Line(points = {{89, 0}, {104, 0}, {104, 0}, {110, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DeltaP;
