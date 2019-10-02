within Dynawo.Electrical.Controls.Voltage.StaticVarCompensator;

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
  import Modelica.Blocks;

  extends Parameters.Params_Limitations;

  Blocks.Interfaces.RealInput IPu "Current of the static var compensator in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Blocks.Interfaces.RealOutput BVarMaxPu(start = BMaxPu) "Maximum value for the variable susceptance in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput BVarMinPu(start = BMinPu) "Minimum value for the variable susceptance in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {62, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {62, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant bMaxPu(k = BMaxPu) annotation(
    Placement(visible = true, transformation(origin = {16, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant bMinPu(k = BMinPu) annotation(
    Placement(visible = true, transformation(origin = {18, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.LimIntegrator limIntegratorMax(k = KCurrentLimiter, outMax = BMaxPu, outMin = 0, y_start = BMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {18, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.LimIntegrator limIntegratorMin(k = KCurrentLimiter, outMax = 0, outMin = BMinPu, y_start = BMinPu)  annotation(
    Placement(visible = true, transformation(origin = {16, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add add1(k1 = 1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-24, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add add2(k1 = -1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-22, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant iMaxPu(k = IMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-64, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant iMinPu(k = IMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-64, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(bMinPu.y, max.u2) annotation(
    Line(points = {{30, -70}, {40, -70}, {40, -46}, {50, -46}, {50, -46}}, color = {0, 0, 127}));
  connect(bMaxPu.y, min.u1) annotation(
    Line(points = {{28, 70}, {40, 70}, {40, 46}, {50, 46}, {50, 46}}, color = {0, 0, 127}));
  connect(IPu, add1.u2) annotation(
    Line(points = {{-120, 0}, {-74, 0}, {-74, 28}, {-36, 28}}, color = {0, 0, 127}));
  connect(IPu, add2.u1) annotation(
    Line(points = {{-120, 0}, {-74, 0}, {-74, -28}, {-34, -28}}, color = {0, 0, 127}));
  connect(limIntegratorMax.y, min.u2) annotation(
    Line(points = {{29, 34}, {47, 34}, {47, 34}, {49, 34}}, color = {0, 0, 127}));
  connect(min.y, BVarMaxPu) annotation(
    Line(points = {{73, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(limIntegratorMin.y, max.u1) annotation(
    Line(points = {{27, -34}, {47, -34}, {47, -34}, {49, -34}}, color = {0, 0, 127}));
  connect(max.y, BVarMinPu) annotation(
    Line(points = {{73, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(add1.y, limIntegratorMax.u) annotation(
    Line(points = {{-13, 34}, {5, 34}, {5, 34}, {5, 34}}, color = {0, 0, 127}));
  connect(add2.y, limIntegratorMin.u) annotation(
    Line(points = {{-11, -34}, {3, -34}, {3, -34}, {3, -34}}, color = {0, 0, 127}));
  connect(iMinPu.y, add2.u2) annotation(
    Line(points = {{-53, -50}, {-47, -50}, {-47, -40}, {-35, -40}, {-35, -40}}, color = {0, 0, 127}));
  connect(iMaxPu.y, add1.u1) annotation(
    Line(points = {{-53, 50}, {-47, 50}, {-47, 40}, {-37, 40}, {-37, 40}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 6}, extent = {{-63, 24}, {123, -32}}, textString = "Limitations")}));end Limitations;
