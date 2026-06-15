within Dynawo.Electrical.StaticVarCompensators.BaseControls;

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

model Limitations "Variable susceptance limits computation"
  extends Parameters.ParamsLimitations;

  Modelica.Blocks.Interfaces.RealInput IPu "Current of the static var compensator in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput BVarMaxPu(start = BMaxPu) "Maximum value for the variable susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput BVarMinPu(start = BMinPu) "Minimum value for the variable susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Min min2 annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max2 annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant bMaxPu(k = BMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant bMinPu(k = BMinPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratorMax(k = KCurrentLimiter, outMax = BMaxPu, outMin = 0, y_start = BMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratorMin(k = KCurrentLimiter, outMax = 0, outMin = BMinPu, y_start = BMinPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant iMaxPu(k = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant iMinPu(k = IMinPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(bMaxPu.y, min2.u2) annotation(
    Line(points = {{2, 20}, {20, 20}, {20, 34}, {38, 34}}, color = {0, 0, 127}));
  connect(bMinPu.y, max1.u2) annotation(
    Line(points = {{2, -20}, {80, -20}, {80, 14}, {98, 14}}, color = {0, 0, 127}));
  connect(bMinPu.y, max2.u1) annotation(
    Line(points = {{2, -20}, {20, -20}, {20, -34}, {38, -34}}, color = {0, 0, 127}));
  connect(bMaxPu.y, min1.u1) annotation(
    Line(points = {{2, 20}, {60, 20}, {60, -14}, {98, -14}}, color = {0, 0, 127}));
  connect(min2.y, max1.u1) annotation(
    Line(points = {{61, 40}, {80, 40}, {80, 26}, {98, 26}}, color = {0, 0, 127}));
  connect(max1.y, BVarMaxPu) annotation(
    Line(points = {{121, 20}, {150, 20}}, color = {0, 0, 127}));
  connect(iMaxPu.y, add1.u1) annotation(
    Line(points = {{-99, 80}, {-80, 80}, {-80, 66}, {-62, 66}}, color = {0, 0, 127}));
  connect(add1.y, limIntegratorMax.u) annotation(
    Line(points = {{-39, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(IPu, add1.u2) annotation(
    Line(points = {{-160, 0}, {-80, 0}, {-80, 54}, {-62, 54}}, color = {0, 0, 127}));
  connect(limIntegratorMax.y, min2.u1) annotation(
    Line(points = {{1, 60}, {20, 60}, {20, 46}, {38, 46}}, color = {0, 0, 127}));
  connect(max2.y, min1.u2) annotation(
    Line(points = {{61, -40}, {80, -40}, {80, -26}, {98, -26}}, color = {0, 0, 127}));
  connect(min1.y, BVarMinPu) annotation(
    Line(points = {{121, -20}, {150, -20}}, color = {0, 0, 127}));
  connect(iMinPu.y, add2.u2) annotation(
    Line(points = {{-99, -80}, {-80, -80}, {-80, -66}, {-62, -66}}, color = {0, 0, 127}));
  connect(add2.y, limIntegratorMin.u) annotation(
    Line(points = {{-39, -60}, {-22, -60}}, color = {0, 0, 127}));
  connect(IPu, add2.u1) annotation(
    Line(points = {{-160, 0}, {-80, 0}, {-80, -54}, {-62, -54}}, color = {0, 0, 127}));
  connect(limIntegratorMin.y, max2.u2) annotation(
    Line(points = {{1, -60}, {20, -60}, {20, -46}, {38, -46}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 6}, extent = {{-63, 24}, {123, -32}}, textString = "Limitations")}),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end Limitations;
