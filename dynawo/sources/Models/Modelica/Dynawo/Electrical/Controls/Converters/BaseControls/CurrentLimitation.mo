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

  parameter Types.PerUnit PMaxPu "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit IMaxPu "Maximal converter valve current in p.u (base UNom, SNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";

  Modelica.Blocks.Interfaces.RealInput idConvRefNLPu(start = IdConv0Pu) "d-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-65, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefNLPu(start = IqConv0Pu) "q-axis reference for the valve current before limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-65, -31}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -61}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idMaxPu(start = PMaxPu/UdFilter0Pu) "d-axis maximal valve current in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-65, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis reference for the valve current after limitation in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {74, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis reference for the valve current after limitation in p.u (base UNom, SNom) " annotation(
    Placement(visible = true, transformation(origin = {73.5, -32.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 0), iconTransformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {40, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {40, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {15, 15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = IMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-48, -19}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {1, -12}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {16, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-27, -10}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-27, -21}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {-15, 15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {-12, -12}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
equation
  connect(idConvRefNLPu, variableLimiter.u) annotation(
    Line(points = {{-65, 40}, {-10.5, 40}, {-10.5, 30}, {28, 30}}, color = {0, 0, 127}));
  connect(gain.y, variableLimiter.limit2) annotation(
    Line(points = {{20.5, 15}, {32.5, 15}, {32.5, 22}, {28, 22}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter1.limit2) annotation(
    Line(points = {{21.5, -40}, {28, -40}}, color = {0, 0, 127}));
  connect(sqrt1.y, variableLimiter1.limit1) annotation(
    Line(points = {{5, -12}, {19, -12}, {19, -24}, {28, -24}}, color = {0, 0, 127}));
  connect(const.y, product1.u1) annotation(
    Line(points = {{-44, -19}, {-32, -19}}, color = {0, 0, 127}));
  connect(const.y, product1.u2) annotation(
    Line(points = {{-44, -19}, {-40, -19}, {-40, -23}, {-32, -23}}, color = {0, 0, 127}));
  connect(variableLimiter.y, product.u2) annotation(
    Line(points = {{51, 30}, {58, 30}, {58, 4}, {-34, 4}, {-34, -12}, {-32, -12}}, color = {0, 0, 127}));
  connect(variableLimiter.y, product.u1) annotation(
    Line(points = {{51, 30}, {58, 30}, {58, 4}, {-34, 4}, {-34, -8}, {-32, -8}}, color = {0, 0, 127}));
  connect(idMaxPu, min.u1) annotation(
    Line(points = {{-65, 18}, {-21, 18}}, color = {0, 0, 127}));
  connect(min.y, gain.u) annotation(
    Line(points = {{-9.5, 15}, {9, 15}}, color = {0, 0, 127}));
  connect(min.y, variableLimiter.limit1) annotation(
    Line(points = {{-9.5, 15}, {4, 15}, {4, 38}, {28, 38}}, color = {0, 0, 127}));
  connect(const.y, min.u2) annotation(
    Line(points = {{-44, -19}, {-40, -19}, {-40, 12}, {-21, 12}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, iqConvRefPu) annotation(
    Line(points = {{51, -32}, {67, -32}, {67, -32.5}, {73.5, -32.5}}, color = {0, 0, 127}));
  connect(variableLimiter.y, idConvRefPu) annotation(
    Line(points = {{51, 30}, {74, 30}}, color = {0, 0, 127}));
  connect(sqrt1.y, gain1.u) annotation(
    Line(points = {{5, -12}, {7, -12}, {7, -40}, {10, -40}}, color = {0, 0, 127}));
  connect(iqConvRefNLPu, variableLimiter1.u) annotation(
    Line(points = {{-65, -31}, {28, -31}, {28, -32}}, color = {0, 0, 127}));
  connect(product1.y, add.u2) annotation(
    Line(points = {{-23, -21}, {-20, -21}, {-20, -14}, {-17, -14}}, color = {0, 0, 127}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-8, -12}, {-4, -12}}, color = {0, 0, 127}));
  connect(product.y, add.u1) annotation(
    Line(points = {{-23, -10}, {-17, -10}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {15.5, -14}, extent = {{-101.5, 79}, {71.5, -52}}, textString = "CurrentLim")}));

end CurrentLimitation;
