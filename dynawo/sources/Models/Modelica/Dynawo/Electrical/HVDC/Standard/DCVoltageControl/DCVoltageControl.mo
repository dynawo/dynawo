within Dynawo.Electrical.HVDC.Standard.DCVoltageControl;

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

model DCVoltageControl "DC Voltage Control for HVDC"

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu UdcRefMaxPu;
  parameter Types.VoltageModulePu UdcRefMinPu;
  parameter Types.PerUnit Kpdc;
  parameter Types.PerUnit Kidc;
  parameter Types.PerUnit IpMaxcstPu;

  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "Reference DC voltage in p.u (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in p.u (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ipRefUdcPu(start = Ip0Pu) "Active current reference in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = UdcRefMaxPu, uMin = UdcRefMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kidc, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpdc)  annotation(
    Placement(visible = true, transformation(origin = {-10, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = IpMaxcstPu, uMin = -IpMaxcstPu)  annotation(
    Placement(visible = true, transformation(origin = {56, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {26, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {86, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Udc0Pu;
  parameter Types.PerUnit Ip0Pu;

equation
  connect(UdcRefPu, limiter.u) annotation(
    Line(points = {{-120, 0}, {-92, 0}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-69, 0}, {-52, 0}}, color = {0, 0, 127}));
  connect(UdcPu, feedback.u2) annotation(
    Line(points = {{-120, -40}, {-44, -40}, {-44, -8}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{-35, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-35, 0}, {-34, 0}, {-34, 30}, {-22, 30}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{37, 6}, {44, 6}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{1, 0}, {14, 0}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{1, 30}, {6, 30}, {6, 12}, {14, 12}}, color = {0, 0, 127}));
  connect(limiter1.y, gain1.u) annotation(
    Line(points = {{67, 6}, {73, 6}, {73, 6}, {74, 6}}, color = {0, 0, 127}));
  connect(gain1.y, ipRefUdcPu) annotation(
    Line(points = {{97, 6}, {101, 6}, {101, 6}, {110, 6}}, color = {0, 0, 127}));

annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DCVoltageControl;
