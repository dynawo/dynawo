within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentLimiter2020 "Current limitation module for wind turbines (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseCurrentLimiter;

  //Input variables
  Modelica.Blocks.Interfaces.IntegerInput fFrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post fault)" annotation(
    Placement(visible = true, transformation(origin = {-320, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iMaxHookPu(start = 0) "Maximum hook current at converter terminal in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMaxHookPu(start = 0) "Maximum hook reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-224, -20}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UWTCFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-224, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
  connect(UWTCFiltPu, add1.u2) annotation(
    Line(points = {{-320, -80}, {20, -80}, {20, -26}, {38, -26}}, color = {0, 0, 127}));
  connect(switch2.y, feedback1.u1) annotation(
    Line(points = {{-238, 0}, {-208, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, product2.u1) annotation(
    Line(points = {{-190, 0}, {-180, 0}, {-180, 6}, {-162, 6}}, color = {0, 0, 127}));
  connect(feedback1.y, product2.u2) annotation(
    Line(points = {{-190, 0}, {-180, 0}, {-180, -6}, {-162, -6}}, color = {0, 0, 127}));
  connect(fFrt, switch2.f) annotation(
    Line(points = {{-320, 40}, {-250, 40}, {-250, 12}}, color = {255, 127, 0}));
  connect(iMaxHookPu, feedback1.u2) annotation(
    Line(points = {{-200, -40}, {-200, -8}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, combiTable1Ds1.u) annotation(
    Line(points = {{-320, -80}, {-290, -80}, {-290, -100}, {-262, -100}}, color = {0, 0, 127}));
  connect(UWTCFiltPu, combiTable1Ds.u) annotation(
    Line(points = {{-320, -80}, {-290, -80}, {-290, -60}, {-262, -60}}, color = {0, 0, 127}));
  connect(fFrt, product1.u[1]) annotation(
    Line(points = {{-320, 40}, {40, 40}}, color = {255, 127, 0}));
  connect(iqMaxHookPu, feedback3.u2) annotation(
    Line(points = {{-224, -20}, {-224, -52}}, color = {0, 0, 127}));
  connect(feedback3.y, switch1.u[2]) annotation(
    Line(points = {{-215, -60}, {-52, -60}, {-52, 60}, {90, 60}, {90, 96}, {100, 96}}, color = {0, 0, 127}));
  connect(feedback3.y, switch1.u[3]) annotation(
    Line(points = {{-215, -60}, {-52, -60}, {-52, 60}, {90, 60}, {90, 98}, {100, 98}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], feedback3.u1) annotation(
    Line(points = {{-259, -60}, {-232, -60}}, color = {0, 0, 127}));
  connect(feedback3.y, min3.u1) annotation(
    Line(points = {{-214, -60}, {-208, -60}, {-208, -120}, {-226, -120}, {-226, -134}, {-222, -134}}, color = {0, 0, 127}));
  connect(feedback3.y, min1.u2) annotation(
    Line(points = {{-214, -60}, {-52, -60}, {-52, 108}, {58, 108}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-300, -160}, {300, 160}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {-36, 96}, extent = {{-43, 23}, {107, -90}}, textString = "Current"), Text(origin = {-32, 29}, extent = {{-61, 49}, {125, -106}}, textString = "Limitation"), Text(origin = {6, -78}, extent = {{-106, 84}, {92, -48}}, textString = "Module 2020")}));
end CurrentLimiter2020;
