within Dynawo.Electrical.HVDC.Standard.ActivePowerControl;

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

model DeltaPCalc

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu VdcMinPu;
  parameter Types.VoltageModulePu VdcMaxPu;
  parameter Types.PerUnit Kpdeltap;
  parameter Types.PerUnit Kideltap;
  parameter Types.CurrentModulePu IpMaxcstPu;
  parameter Types.CurrentModulePu DUDC;

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-44, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdcPu(start = Vdc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kideltap, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-10, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpdeltap)  annotation(
    Placement(visible = true, transformation(origin = {-10, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = IpMaxcstPu, uMin = -IpMaxcstPu)  annotation(
    Placement(visible = true, transformation(origin = {56, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {26, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput deltaP(start = 0) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = VdcMaxPu, uMin = VdcMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-70, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {50, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipRefVdcPu(start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 51}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = IpMaxcstPu - DUDC)  annotation(
    Placement(visible = true, transformation(origin = {-70, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = (-IpMaxcstPu) + DUDC)  annotation(
    Placement(visible = true, transformation(origin = {-70, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-30, 51}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Vdc0Pu;
  parameter Types.CurrentModulePu Ip0Pu;

equation
  connect(vdcPu, feedback.u2) annotation(
    Line(points = {{-120, -54}, {-44, -54}, {-44, -22}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{-35, -14}, {-22, -14}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{37, -8}, {44, -8}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{1, -14}, {14, -14}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{1, 16}, {6, 16}, {6, -2}, {14, -2}}, color = {0, 0, 127}));
  connect(vdcPu, limiter.u) annotation(
    Line(points = {{-120, -54}, {-90, -54}, {-90, -14}, {-82, -14}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-59, -14}, {-52, -14}}, color = {0, 0, 127}));
  connect(limiter1.y, switch1.u3) annotation(
    Line(points = {{67, -8}, {74, -8}}, color = {0, 0, 127}));
  connect(switch1.y, deltaP) annotation(
    Line(points = {{97, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{61, 76}, {70, 76}, {70, 8}, {74, 8}}, color = {0, 0, 127}));
  connect(ipRefVdcPu, greaterThreshold.u) annotation(
    Line(points = {{-120, 51}, {-90, 51}, {-90, 66}, {-82, 66}}, color = {0, 0, 127}));
  connect(ipRefVdcPu, lessThreshold.u) annotation(
    Line(points = {{-120, 51}, {-90, 51}, {-90, 36}, {-82, 36}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, or1.u1) annotation(
    Line(points = {{-59, 66}, {-50, 66}, {-50, 51}, {-42, 51}}, color = {255, 0, 255}));
  connect(lessThreshold.y, or1.u2) annotation(
    Line(points = {{-59, 36}, {-50, 36}, {-50, 43}, {-42, 43}}, color = {255, 0, 255}));
  connect(or1.y, switch1.u2) annotation(
    Line(points = {{-19, 51}, {68, 51}, {68, 0}, {74, 0}}, color = {255, 0, 255}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-35, -14}, {-30, -14}, {-30, 16}, {-22, 16}, {-22, 16}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DeltaPCalc;
