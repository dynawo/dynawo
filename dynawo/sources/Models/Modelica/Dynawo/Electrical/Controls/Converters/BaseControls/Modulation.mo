within Dynawo.Electrical.Controls.Converters.BaseControls;

model Modulation "Modulation"
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

  import Modelica;
  import Dynawo.Types;

  parameter Types.PerUnit Udc0Pu "Start value of the DC bus voltage in pu (base UNom)";
  parameter Types.PerUnit UdConv0Pu "Start value of the d-axis converter modulated voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of the q-axis converter modulated voltage in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC bus voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-121, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-111, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "DC Voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-121, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-111, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "d-axis reference for the converter modulated voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-121, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-111, 71}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "q-axis reference for the converter modulated voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-122, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-111, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvPu(start = UdConv0Pu) "d-axis converter modulated voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {119.5, 29.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvPu(start = UqConv0Pu) "q-axis converter modulated voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {120, -31}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -51}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit UConvPu(start = sqrt(UdConv0Pu ^ 2 + UqConv0Pu ^ 2)) "Module of the modulated voltage (base UNom)";

  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {70, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-9, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-12, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-62, -51}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {-12, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

/* Modulated voltage module */

  UConvPu = sqrt(udConvPu ^ 2 + uqConvPu ^ 2);

  connect(division.y, udConvPu) annotation(
    Line(points = {{81, 29}, {100, 29}, {100, 30}, {120, 30}}, color = {0, 0, 127}));
  connect(division1.y, uqConvPu) annotation(
    Line(points = {{81, -30}, {102, -30}, {102, -31}, {120, -31}}, color = {0, 0, 127}));
  connect(product1.y, division1.u1) annotation(
    Line(points = {{-1, -24}, {58, -24}}, color = {0, 0, 127}));
  connect(product.y, division.u1) annotation(
    Line(points = {{2, 74}, {28, 74}, {28, 35}, {58, 35}}, color = {0, 0, 127}));
  connect(udConvRefPu, product.u1) annotation(
    Line(points = {{-121, 80}, {-21, 80}}, color = {0, 0, 127}));
  connect(uqConvRefPu, product1.u2) annotation(
    Line(points = {{-122, -30}, {-24, -30}}, color = {0, 0, 127}));
  connect(UdcPu, product.u2) annotation(
    Line(points = {{-121, 30}, {-61, 30}, {-61, 68}, {-21, 68}}, color = {0, 0, 127}));
  connect(UdcPu, product1.u1) annotation(
    Line(points = {{-121, 30}, {-61, 30}, {-61, -18}, {-24, -18}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{-1, -55}, {25, -55}, {25, -37}, {58, -37}, {58, -36}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{-1, -55}, {25, -55}, {25, 23}, {58, 23}, {58, 23}}, color = {0, 0, 127}));
  connect(const.y, max.u1) annotation(
    Line(points = {{-51, -51}, {-24, -51}, {-24, -49}, {-24, -49}}, color = {0, 0, 127}));
  connect(UdcRefPu, max.u2) annotation(
    Line(points = {{-121, -80}, {-40, -80}, {-40, -61}, {-24, -61}, {-24, -61}}, color = {0, 0, 127}));

annotation(
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-53.5, 59}, extent = {{-37.5, 19}, {143.5, -137}}, textString = "Modulation")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, initialScale = 0.1)));

end Modulation;
