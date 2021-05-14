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

model CurrentLimitation "Current Limitation with active power prioritization"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;

  parameter Types.PerUnit PmaxPu      "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit ImaxPu      "Maximal converter valve current in p.u (base UNom, SNom)";

  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu   "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu   "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";

  Modelica.Blocks.Interfaces.RealInput idConvRefNLPu(start = IdConv0Pu) "d-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 25}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -105, 72}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefNLPu(start = IqConv0Pu) "q-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, -32}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = { -105, -68}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idMaxPu(start = PmaxPu/UdFilter0Pu) "d-axis maximal valve current in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 17}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis reference for the valve current after limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, 25}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis reference for the valve current after limitation in p.u (base UNom, SNom) " annotation(
    Placement(visible = true, transformation(origin = {67, -32}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -37}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {44, 25}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {46, -32}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {21, 15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = ImaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-48, -19}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {9, -19}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {28, -41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-8, -19}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-25, -10}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-25, -21}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-8.5, 14.5}, extent = {{-4.5, -4.5}, {4.5, 4.5}}, rotation = 0)));

equation

  connect(variableLimiter1.y, iqConvRefPu) annotation(
    Line(points = {{53, -32}, {67, -32}}, color = {0, 0, 127}));
  connect(variableLimiter.y, idConvRefPu) annotation(
    Line(points = {{51, 25}, {67, 25}}, color = {0, 0, 127}));
  connect(idConvRefNLPu, variableLimiter.u) annotation(
    Line(points = {{-58, 25}, {37, 25}}, color = {0, 0, 127}));
  connect(gain.y, variableLimiter.limit2) annotation(
    Line(points = {{26.5, 15}, {32.5, 15}, {32.5, 20}, {37, 20}}, color = {0, 0, 127}));
  connect(iqConvRefNLPu, variableLimiter1.u) annotation(
    Line(points = {{-58, -32}, {39, -32}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter1.limit2) annotation(
    Line(points = {{33.5, -41}, {34, -41}, {34, -37}, {39, -37}}, color = {0, 0, 127}));
  connect(sqrt1.y, variableLimiter1.limit1) annotation(
    Line(points = {{13, -19}, {26, -19}, {26, -27}, {39, -27}}, color = {0, 0, 127}));
  connect(sqrt1.y, gain1.u) annotation(
    Line(points = {{13, -19}, {19, -19}, {19, -41}, {22, -41}}, color = {0, 0, 127}));
  connect(product1.y, add.u2) annotation(
    Line(points = {{-21, -21}, {-13, -21}}, color = {0, 0, 127}));
  connect(const.y, product1.u1) annotation(
    Line(points = {{-44, -19}, {-30, -19}}, color = {0, 0, 127}));
  connect(const.y, product1.u2) annotation(
    Line(points = {{-44, -19}, {-41, -19}, {-41, -23}, {-30, -23}}, color = {0, 0, 127}));
  connect(variableLimiter.y, product.u2) annotation(
    Line(points = {{51, 25}, {58, 25}, {58, 4}, {-34, 4}, {-34, -12}, {-30, -12}}, color = {0, 0, 127}));
  connect(variableLimiter.y, product.u1) annotation(
    Line(points = {{51, 25}, {58, 25}, {58, 4}, {-34, 4}, {-34, -8}, {-30, -8}}, color = {0, 0, 127}));
  connect(idMaxPu, min.u1) annotation(
    Line(points = {{-58, 17}, {-14, 17}}, color = {0, 0, 127}));
  connect(min.y, gain.u) annotation(
    Line(points = {{-4, 15}, {15, 15}}, color = {0, 0, 127}));
  connect(min.y, variableLimiter.limit1) annotation(
    Line(points = {{-4, 15}, {4, 15}, {4, 30}, {37, 30}}, color = {0, 0, 127}));
  connect(const.y, min.u2) annotation(
    Line(points = {{-44, -19}, {-41, -19}, {-41, 11}, {-14, 11}, {-14, 12}}, color = {0, 0, 127}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-4, -19}, {5, -19}, {5, -19}, {4, -19}}, color = {0, 0, 127}));
  connect(product.y, add.u1) annotation(
    Line(points = {{-21, -10}, {-16, -10}, {-16, -17}, {-13, -17}, {-13, -17}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {-0.5, -1}, extent = {{-63.5, 47}, {63.5, -47}}, textString = "CurrentLim")}));

end CurrentLimitation;
