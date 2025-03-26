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
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput BVarMaxPu(start = BMaxPu) "Maximum value for the variable susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput BVarMinPu(start = BMinPu) "Minimum value for the variable susceptance in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min annotation(
    Placement(visible = true, transformation(origin = {30, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MaxDynawo max annotation(
    Placement(visible = true, transformation(origin = {30, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Placement(visible = true, transformation(origin = {-86, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant iMinPu(k = IMinPu) annotation(
    Placement(visible = true, transformation(origin = {-86, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MaxDynawo max1 annotation(
    Placement(visible = true, transformation(origin = {70, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min1 annotation(
    Placement(visible = true, transformation(origin = {70, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(bMaxPu.y, min.u2) annotation(
    Line(points = {{2, 20}, {10, 20}, {10, 48}, {18, 48}, {18, 48}}, color = {0, 0, 127}));
  connect(bMinPu.y, max1.u2) annotation(
    Line(points = {{2, -20}, {50, -20}, {50, 42}, {58, 42}, {58, 42}}, color = {0, 0, 127}));
  connect(bMinPu.y, max.u1) annotation(
    Line(points = {{2, -20}, {10, -20}, {10, -48}, {18, -48}, {18, -48}}, color = {0, 0, 127}));
  connect(bMaxPu.y, min1.u1) annotation(
    Line(points = {{2, 20}, {46, 20}, {46, -42}, {58, -42}, {58, -42}}, color = {0, 0, 127}));
  connect(min.y, max1.u1) annotation(
    Line(points = {{41, 54}, {57, 54}, {57, 54}, {57, 54}}, color = {0, 0, 127}));
  connect(max1.y, BVarMaxPu) annotation(
    Line(points = {{81, 48}, {92, 48}, {92, 48}, {103, 48}, {103, 48}, {106, 48}, {106, 48}, {109, 48}}, color = {0, 0, 127}));
  connect(iMaxPu.y, add1.u1) annotation(
    Line(points = {{-75, 76}, {-73.5, 76}, {-73.5, 76}, {-72, 76}, {-72, 76}, {-69, 76}, {-69, 66}, {-65.5, 66}, {-65.5, 66}, {-62, 66}}, color = {0, 0, 127}));
  connect(add1.y, limIntegratorMax.u) annotation(
    Line(points = {{-39, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(IPu, add1.u2) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 54}, {-62, 54}}, color = {0, 0, 127}));
  connect(limIntegratorMax.y, min.u1) annotation(
    Line(points = {{1, 60}, {17, 60}}, color = {0, 0, 127}));
  connect(max.y, min1.u2) annotation(
    Line(points = {{41, -54}, {49, -54}, {49, -54}, {57, -54}, {57, -54}, {57, -54}, {57, -54}, {57, -54}}, color = {0, 0, 127}));
  connect(min1.y, BVarMinPu) annotation(
    Line(points = {{81, -48}, {92, -48}, {92, -48}, {103, -48}, {103, -48}, {106, -48}, {106, -48}, {109, -48}}, color = {0, 0, 127}));
  connect(iMinPu.y, add2.u2) annotation(
    Line(points = {{-75, -76}, {-73.5, -76}, {-73.5, -76}, {-72, -76}, {-72, -76}, {-69, -76}, {-69, -66}, {-65.5, -66}, {-65.5, -66}, {-63.75, -66}, {-63.75, -66}, {-62, -66}}, color = {0, 0, 127}));
  connect(add2.y, limIntegratorMin.u) annotation(
    Line(points = {{-39, -60}, {-22, -60}}, color = {0, 0, 127}));
  connect(IPu, add2.u1) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, -54}, {-62, -54}}, color = {0, 0, 127}));
  connect(limIntegratorMin.y, max.u2) annotation(
    Line(points = {{1, -60}, {17, -60}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 6}, extent = {{-63, 24}, {123, -32}}, textString = "Limitations")}));
end Limitations;
