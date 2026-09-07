within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model MAXEX2 "Overexcitation limitation for standard voltage regulator"

  parameter Types.CurrentModulePu Ifd1Pu = 1.1 "Field current of first characteristic point in pu (base SNom, user-selected base voltage)";
  parameter Types.CurrentModulePu Ifd2Pu = 1.2 "Field current of second characteristic point in pu (base SNom, user-selected base voltage)";
  parameter Types.CurrentModulePu Ifd3Pu = 1.5 "Field current of third characteristic point in pu (base SNom, user-selected base voltage)";
  parameter Types.CurrentModule IfdRated = 2.6355 "Synchronous generator rated field current in kA";
  parameter Types.PerUnit Kmx = 0.2 "Integrator gain of overexcitation limitation";
  parameter Types.Time t1 = 60 "Time of first characteristic point in s";
  parameter Types.Time t2 = 30 "Time of second characteristic point in s";
  parameter Types.Time t3 = 15 "Time of third characteristic point in s";
  parameter Types.PerUnit ULowPu = -0.05 "Lower limit of overexcitation limitation output voltage in pu (base UNom)";

  final parameter Types.PerUnit FOel[:, :] = [t3 - 1, Ifd3Pu; t3, Ifd3Pu; t2, Ifd2Pu; t1, Ifd1Pu; t1 + 1, Ifd1Pu] "Time characteristic of the overexcitation limitation";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput IfdPu(start = Ifd0Pu) "Generator field current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UOelPu(start = 0) "Output voltage of overexcitation limitation in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kmx, outMax = 0, outMin = ULowPu, strict = true) annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = IfdRated) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.FlipFlopR flipFlopR annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = Ifd1Pu * IfdRated) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold = 0.98 * Ifd1Pu * IfdRated) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = FOel) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.CurrentModulePu Ifd0Pu "Initial generator field current in pu (base SNom, user-selected base voltage)";

equation
  connect(limIntegrator.y, UOelPu) annotation(
    Line(points = {{161, 0}, {190, 0}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, flipFlopR.s) annotation(
    Line(points = {{-119, 20}, {-100, 20}, {-100, 6}, {-83, 6}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.y, flipFlopR.r) annotation(
    Line(points = {{-119, -20}, {-100, -20}, {-100, -6}, {-83, -6}}, color = {255, 0, 255}));
  connect(flipFlopR.y, timer.u) annotation(
    Line(points = {{-59, 0}, {-43, 0}}, color = {255, 0, 255}));
  connect(timer.y, combiTable1Ds.u) annotation(
    Line(points = {{-19, 0}, {-3, 0}}, color = {0, 0, 127}));
  connect(IfdPu, greaterThreshold.u) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, 20}, {-142, 20}}, color = {0, 0, 127}));
  connect(IfdPu, lessEqualThreshold.u) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(IfdPu, feedback.u2) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, -60}, {100, -60}, {100, -8}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], gain.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u1) annotation(
    Line(points = {{62, 0}, {92, 0}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator.u) annotation(
    Line(points = {{110, 0}, {138, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})));
end MAXEX2;
