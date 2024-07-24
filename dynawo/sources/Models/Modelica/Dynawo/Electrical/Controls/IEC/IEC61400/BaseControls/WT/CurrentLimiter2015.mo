within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentLimiter2015 "Current limitation module for wind turbines (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseCurrentLimiter;

  //Current limiter parameters
  parameter Types.Time tUFiltcl "Voltage filter time constant in s" annotation(
    Dialog(tab = "CurrentLimiter"));

  //Input variables
  Modelica.Blocks.Interfaces.IntegerInput fUvrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post fault)" annotation(
    Placement(visible = true, transformation(origin = {-320, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tUFiltcl, y_start = U0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-284, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(fUvrt, switch2.f) annotation(
    Line(points = {{-320, 40}, {-250, 40}, {-250, 12}}, color = {255, 127, 0}));
  connect(switch2.y, product2.u1) annotation(
    Line(points = {{-238, 0}, {-200, 0}, {-200, 6}, {-162, 6}}, color = {0, 0, 127}));
  connect(switch2.y, product2.u2) annotation(
    Line(points = {{-238, 0}, {-200, 0}, {-200, -6}, {-162, -6}}, color = {0, 0, 127}));
  connect(UWTPu, firstOrder.u) annotation(
    Line(points = {{-320, -80}, {-296, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, combiTable1Ds.u) annotation(
    Line(points = {{-272, -80}, {-268, -80}, {-268, -60}, {-262, -60}}, color = {0, 0, 127}));
  connect(firstOrder.y, combiTable1Ds1.u) annotation(
    Line(points = {{-272, -80}, {-268, -80}, {-268, -100}, {-262, -100}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u2) annotation(
    Line(points = {{-272, -80}, {20, -80}, {20, -26}, {38, -26}}, color = {0, 0, 127}));
  connect(fUvrt, product1.u[1]) annotation(
    Line(points = {{-320, 40}, {40, 40}}, color = {255, 127, 0}));
  connect(combiTable1Ds.y[1], switch1.u[2]) annotation(
    Line(points = {{-238, -60}, {-46, -60}, {-46, 98}, {100, 98}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], switch1.u[3]) annotation(
    Line(points = {{-238, -60}, {-46, -60}, {-46, 96}, {100, 96}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.y[1], min3.u1) annotation(
    Line(points = {{-238, -100}, {-230, -100}, {-230, -134}, {-222, -134}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], min1.u2) annotation(
    Line(points = {{-238, -60}, {-46, -60}, {-46, 108}, {58, 108}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-300, -160}, {300, 160}})),
    Icon(graphics = {Text(origin = {60, -63}, extent = {{-42, 28}, {36, -16}}, textString = "2015")}));
end CurrentLimiter2015;
