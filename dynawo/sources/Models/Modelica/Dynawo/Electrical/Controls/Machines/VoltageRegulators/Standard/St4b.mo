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

model St4b "IEEE exciter type ST4B model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt4(
    max1.nu = 2,
    max2.nu = 2,
    min2.nu = 2,
    sum1.k = {-1, 1, 1, 1, 1},
    sum1.nin = 5);

  Modelica.Blocks.Math.Gain gain(k = Kg) annotation(
    Placement(visible = true, transformation(origin = {250, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  add.u2 = 0;
  max1.u[2] = max1.u[1];
  max2.u[2] = max2.u[1];
  min2.u[2] = UOelPu;
  sum1.u[3] = UPssPu;
  sum1.u[4] = 0;
  sum1.u[5] = UUelPu;

  connect(potentialCircuit.vE, division.u2) annotation(
    Line(points = {{-298, -140}, {60, -140}, {60, -126}, {78, -126}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, product1.u2) annotation(
    Line(points = {{-298, -140}, {60, -140}, {60, -146}, {178, -146}}, color = {0, 0, 127}));
  connect(add.y, limPI1.u) annotation(
    Line(points = {{-138, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{322, 0}, {340, 0}, {340, 160}, {262, 160}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u2) annotation(
    Line(points = {{240, 160}, {20, 160}, {20, 88}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St4b;
