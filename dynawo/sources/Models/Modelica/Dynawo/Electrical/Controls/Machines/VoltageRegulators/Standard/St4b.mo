within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model St4b "IEEE exciter type ST4B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt4(
    sum1.k = {-1, 1, 1, 1, 1},
    sum1.nin = 5);

  Modelica.Blocks.Math.Gain gain(k = Kg) annotation(
    Placement(visible = true, transformation(origin = {250, 180}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tA, y_start = Kg * Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  add.u2 = 0;
  sum1.u[4] = 0;

  connect(potentialCircuit.vE, division.u2) annotation(
    Line(points = {{-298, -140}, {80, -140}, {80, -126}, {98, -126}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, product1.u2) annotation(
    Line(points = {{-298, -140}, {80, -140}, {80, -146}, {198, -146}}, color = {0, 0, 127}));
  connect(add.y, limPI1.u) annotation(
    Line(points = {{-158, 80}, {-62, 80}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{322, 0}, {360, 0}, {360, 180}, {262, 180}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u2) annotation(
    Line(points = {{239, 180}, {40, 180}, {40, 88}}, color = {0, 0, 127}));
  connect(min2.yMin, product.u1) annotation(
    Line(points = {{222, 80}, {300, 80}, {300, 6}, {318, 6}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-400, 40}, {-320, 40}, {-320, 80}, {-302, 80}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[5]) annotation(
    Line(points = {{-400, 0}, {-320, 0}, {-320, 80}, {-302, 80}}, color = {0, 0, 127}));
  connect(UOelPu, min2.u[2]) annotation(
    Line(points = {{-400, 160}, {180, 160}, {180, 86}, {200, 86}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(limPI1.y, firstOrder1.u) annotation(
    Line(points = {{-38, 80}, {-22, 80}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u1) annotation(
    Line(points = {{2, 80}, {32, 80}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St4b;
