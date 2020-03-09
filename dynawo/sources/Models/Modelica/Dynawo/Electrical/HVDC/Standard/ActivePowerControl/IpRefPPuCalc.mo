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

model IpRefPPuCalc

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Kppcontrol;
  parameter Types.PerUnit Kipcontrol;
  parameter Types.PerUnit IpMaxPu;
  parameter Types.PerUnit IpMinPu;
  parameter Types.ActivePowerPu PMaxOp;
  parameter Types.ActivePowerPu PMinOp;
  parameter Types.Time TFilterPRef;

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-26, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kipcontrol, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {40, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kppcontrol)  annotation(
    Placement(visible = true, transformation(origin = {40, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = IpMaxPu, uMin = IpMinPu)  annotation(
    Placement(visible = true, transformation(origin = {106, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {76, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {136, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {100, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pRefPu(start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) annotation(
    Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput deltaP(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-160, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {7, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = TFilterPRef)  annotation(
    Placement(visible = true, transformation(origin = {-120, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput rpfault(start = 1) annotation(
    Placement(visible = true, transformation(origin = {-160, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PMaxOp, uMin = PMinOp)  annotation(
    Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu Ip0Pu;
  parameter Types.CurrentModulePu P0Pu;

equation
  connect(add.y, limiter1.u) annotation(
    Line(points = {{87, -8}, {94, -8}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{51, -14}, {64, -14}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{51, 16}, {56, 16}, {56, -2}, {64, -2}}, color = {0, 0, 127}));
  connect(limiter1.y, switch1.u3) annotation(
    Line(points = {{117, -8}, {124, -8}}, color = {0, 0, 127}));
  connect(switch1.y, ipRefPPu) annotation(
    Line(points = {{147, 0}, {160, 0}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{111, 76}, {120, 76}, {120, 8}, {124, 8}}, color = {0, 0, 127}));
  connect(pPu, feedback.u2) annotation(
    Line(points = {{-160, -90}, {-26, -90}, {-26, -28}}, color = {0, 0, 127}));
  connect(blocked, switch1.u2) annotation(
    Line(points = {{-160, 60}, {118, 60}, {118, 0}, {124, 0}}, color = {255, 0, 255}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{18, -14}, {28, -14}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{-17, -20}, {-5, -20}}, color = {0, 0, 127}));
  connect(deltaP, add1.u1) annotation(
    Line(points = {{-160, 30}, {-10, 30}, {-10, -8}, {-5, -8}}, color = {0, 0, 127}));
  connect(pRefPu, firstOrder.u) annotation(
    Line(points = {{-160, -14}, {-132, -14}}, color = {0, 0, 127}));
  connect(firstOrder.y, product.u1) annotation(
    Line(points = {{-109, -14}, {-102, -14}}, color = {0, 0, 127}));
  connect(rpfault, product.u2) annotation(
    Line(points = {{-160, -50}, {-103, -50}, {-103, -36.5}, {-102, -36.5}, {-102, -26}}, color = {0, 0, 127}));
  connect(product.y, limiter.u) annotation(
    Line(points = {{-79, -20}, {-72, -20}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-49, -20}, {-34, -20}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{18, -14}, {20, -14}, {20, 16}, {28, 16}, {28, 16}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end IpRefPPuCalc;
