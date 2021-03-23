within Dynawo.Electrical.Controls.Converters.BaseControls;

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

model IECWT4APll

  import Modelica;
  import Dynawo.Types;

  /*PLL*/
  parameter Types.PerUnit Tpll "Time constant for PLL first order filter model" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered and possibly also frozen" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen" annotation(
    Dialog(group = "group", tab = "PLL"));

  /*Operational Parameters*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in rad" annotation(
  Dialog(group = "group", tab = "Operating point"));

  //Inputs
  Modelica.Blocks.Interfaces.RealInput uWTCPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Outputs
  Modelica.Blocks.Interfaces.RealOutput y(start = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {120, 4.44089e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Blocks
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / Tpll)  annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = UPhase0)  annotation(
    Placement(visible = true, transformation(origin = {30, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {0, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {-40, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = Upll2) annotation(
    Placement(visible = true, transformation(origin = {-80, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = Upll1) annotation(
    Placement(visible = true, transformation(origin = {-9, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(switch11.y, integrator.u) annotation(
    Line(points = {{11, -12}, {18, -12}}, color = {0, 0, 127}));
  connect(const1.y, switch11.u1) annotation(
    Line(points = {{-39, 10}, {-20, 10}, {-20, -4}, {-12, -4}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-61, -20}, {-50, -20}}, color = {0, 0, 127}));
  connect(integrator.y, feedback1.u2) annotation(
    Line(points = {{41, -12}, {50, -12}, {50, -40}, {-70, -40}, {-70, -28}}, color = {0, 0, 127}));
  connect(less1.y, switch11.u2) annotation(
    Line(points = {{-29, -62}, {-20, -62}, {-20, -12}, {-12, -12}}, color = {255, 0, 255}));
  connect(gain.y, switch11.u3) annotation(
    Line(points = {{-31, -20}, {-12, -20}}, color = {0, 0, 127}));
  connect(constant1.y, less1.u2) annotation(
    Line(points = {{-69, -70}, {-52, -70}}, color = {0, 0, 127}));
  connect(uWTCPu, less1.u1) annotation(
    Line(points = {{-120, -50}, {-60, -50}, {-60, -62}, {-52, -62}}, color = {0, 0, 127}));
  connect(uWTCPu, lessThreshold.u) annotation(
    Line(points = {{-120, -50}, {-90, -50}, {-90, 60}, {-21, 60}}, color = {0, 0, 127}));
  connect(lessThreshold.y, switch1.u2) annotation(
    Line(points = {{2, 60}, {20, 60}, {20, 20}, {58, 20}}, color = {255, 0, 255}));
  connect(switch1.y, y) annotation(
    Line(points = {{82, 20}, {90, 20}, {90, 0}, {120, 0}, {120, 0}}, color = {0, 0, 127}));
  connect(integrator.y, switch1.u1) annotation(
    Line(points = {{41, -12}, {50, -12}, {50, 28}, {58, 28}}, color = {0, 0, 127}));
  connect(theta, feedback1.u1) annotation(
    Line(points = {{-120, 0}, {-100, 0}, {-100, -20}, {-78, -20}, {-78, -20}}, color = {0, 0, 127}));
  connect(theta, switch1.u3) annotation(
    Line(points = {{-120, 0}, {-70, 0}, {-70, 30}, {0, 30}, {0, 12}, {58, 12}, {58, 12}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}})),
    Icon(coordinateSystem(extent = {{-100, -80}, {100, 80}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 80}, {100, -80}}), Text(origin = {8, -9}, extent = {{-78, 57}, {66, -39}}, textString = "PLL")}));

end IECWT4APll;
