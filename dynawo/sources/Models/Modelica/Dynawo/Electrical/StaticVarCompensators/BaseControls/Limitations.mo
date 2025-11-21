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
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model Limitations "Variable susceptance limits computation"
  extends Parameters.ParamsLimitations;

  Modelica.Blocks.Interfaces.RealInput IPu "Current of the static var compensator in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput BVarMaxPu(start = BMaxPu) "Maximum value for the variable susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput BVarMinPu(start = BMinPu) "Minimum value for the variable susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.LimIntegrator limIntegratorMax(k = KCurrentLimiter, outMax = BMaxPu, outMin = 0, y_start = BMaxPu) annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratorMin(k = KCurrentLimiter, outMax = 0, outMin = BMinPu, y_start = BMinPu) annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant iMaxPu(k = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant iMinPu(k = IMinPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterMax(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = BMaxPu, uMin = BMinPu) annotation(
    Placement(visible = true, transformation(origin = {70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterMin(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = BMaxPu, uMin = BMinPu) annotation(
    Placement(visible = true, transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(iMaxPu.y, add1.u1) annotation(
    Line(points = {{-59, 80}, {-40, 80}, {-40, 66}, {-22, 66}}, color = {0, 0, 127}));
  connect(add1.y, limIntegratorMax.u) annotation(
    Line(points = {{1, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(IPu, add1.u2) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, 54}, {-22, 54}}, color = {0, 0, 127}));
  connect(iMinPu.y, add2.u2) annotation(
    Line(points = {{-59, -80}, {-40, -80}, {-40, -66}, {-22, -66}}, color = {0, 0, 127}));
  connect(add2.y, limIntegratorMin.u) annotation(
    Line(points = {{1, -60}, {18, -60}}, color = {0, 0, 127}));
  connect(IPu, add2.u1) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, -54}, {-22, -54}}, color = {0, 0, 127}));
  connect(limIntegratorMax.y, limiterMax.u) annotation(
    Line(points = {{42, 60}, {58, 60}}, color = {0, 0, 127}));
  connect(limIntegratorMin.y, limiterMin.u) annotation(
    Line(points = {{42, -60}, {58, -60}}, color = {0, 0, 127}));
  connect(limiterMax.y, BVarMaxPu) annotation(
    Line(points = {{82, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(limiterMin.y, BVarMinPu) annotation(
    Line(points = {{82, -60}, {110, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 6}, extent = {{-63, 24}, {123, -32}}, textString = "Limitations")}));
end Limitations;
