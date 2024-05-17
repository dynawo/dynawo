within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

block LimitedPI "Proportional-integrator controller with limited value of output"
  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit Ki "Integrator gain";
  parameter Types.PerUnit Kp "Proportional gain";
  parameter Types.PerUnit Tol = 1e-5 "Tolerance on limit crossing as a fraction of the difference between limits";
  parameter Types.PerUnit YMax "Upper limit of output";
  parameter Types.PerUnit YMin "Upper limit of output";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(Placement(
        visible = true, transformation(extent = {{-200, -20}, {-160, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(Placement(
        visible = true, transformation(extent = {{160, -10}, {180, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = Kp) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Ki, y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresisMax(uHigh = YMax, uLow = YMax - Tol * (YMax - YMin)) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresisMin(pre_y_start = true, uHigh = YMin + Tol * (YMax - YMin), uLow = YMin, y(start = true)) annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 = 0 "Initial value of output";

equation
  connect(add.y, limiter1.u) annotation(
    Line(points = {{81, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{22, -20}, {40, -20}, {40, -6}, {59, -6}}, color = {0, 0, 127}));
  connect(limiter1.y, y) annotation(
    Line(points = {{141, 0}, {169, 0}}, color = {0, 0, 127}));
  connect(switch1.u2, or1.y) annotation(
    Line(points = {{-42, -20}, {-60, -20}, {-60, -60}, {-41, -60}}, color = {255, 0, 255}));
  connect(hysteresisMax.y, or1.u1) annotation(
    Line(points = {{59, -40}, {0, -40}, {0, -60}, {-18, -60}}, color = {255, 0, 255}));
  connect(add.y, hysteresisMax.u) annotation(
    Line(points = {{81, 0}, {100, 0}, {100, -40}, {81, -40}}, color = {0, 0, 127}));
  connect(add.y, hysteresisMin.u) annotation(
    Line(points = {{81, 0}, {100, 0}, {100, -80}, {81, -80}}, color = {0, 0, 127}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{-79, 20}, {-60, 20}, {-60, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{-19, -20}, {-1, -20}}, color = {0, 0, 127}));
  connect(u, switch1.u3) annotation(
    Line(points = {{-180, 0}, {-120, 0}, {-120, -28}, {-42, -28}}, color = {0, 0, 127}));
  connect(u, add.u1) annotation(
    Line(points = {{-180, 0}, {-120, 0}, {-120, 60}, {40, 60}, {40, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(hysteresisMin.y, not1.u) annotation(
    Line(points = {{60, -80}, {42, -80}}, color = {255, 0, 255}));
  connect(not1.y, or1.u2) annotation(
    Line(points = {{20, -80}, {0, -80}, {0, -68}, {-18, -68}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{60, -100}, {60, -80}}, color = {255, 0, 255}, pattern = LinePattern.Dot), Line(origin = {-14.38, -5.34}, points = {{8, 10}, {8, 0}}), Line(origin = {-7.71, 0}, points = {{-6, 0}, {8, 0}}), Line(origin = {29.79, 69.79}, points = {{-29.7929, -9.79289}, {-9.79289, 10.2071}, {30.2071, 10.2071}, {30.2071, 10.2071}, {30.2071, 10.2071}}), Line(points = {{80, 0}, {100, 0}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, extent = {{-80, 60}, {80, -60}}), Text(origin = {42, 60}, extent = {{-8, 60}, {60, 2}}, textString = "uMax"), Line(points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {17.67, 0}, points = {{-6, 0}, {56, 0}}), Text(origin = {-96, -122}, extent = {{-8, 60}, {60, 2}}, textString = "uMin"), Text(origin = {16, 0}, extent = {{-8, -2}, {60, -60}}, textString = "s"), Text(origin = {18, 0}, extent = {{-8, 60}, {60, 2}}, textString = "Ki"), Line(origin = {-29.79, -69.79}, points = {{-30.2071, -10.2071}, {9.79289, -10.2071}, {29.7929, 9.79289}}), Text(origin = {-72, -30}, extent = {{-8, 60}, {60, 2}}, textString = "Kp")}),
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This blocks computes&nbsp;<strong>y</strong>&nbsp;as&nbsp;<em>integral</em>&nbsp;of the input&nbsp;<strong>u</strong>&nbsp;multiplied by gain&nbsp;<i>Ki </i>plus input <b>u</b> multiplied by <i>Kp</i>.</p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">If the result reaches a given upper or lower&nbsp;<b>limit</b>, the integration is halted and only restarted if the input drives the integral away from the bounds, with a sufficient margin defined by&nbsp;<em>Tol</em>.</p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This margin is aimed at avoiding chattering i.e. rapid swings between frozen and unfrozen sates.</p><p style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The integrator is initialized with the value&nbsp;<em>Y0.</em></p></body></html>"));
end LimitedPI;
