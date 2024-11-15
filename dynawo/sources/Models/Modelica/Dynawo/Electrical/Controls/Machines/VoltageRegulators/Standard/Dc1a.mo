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

model Dc1a "IEEE excitation system type DC1A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseDc1(
    max1.nu = 2,
    sum1.nin = 3);

  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tE, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  sum1.u[2] = 0;

  connect(feedback1.y, integrator.u) annotation(
    Line(points = {{109, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(integrator.y, EfdPu) annotation(
    Line(points = {{201, 0}, {310, 0}}, color = {0, 0, 127}));
  connect(integrator.y, derivative.u) annotation(
    Line(points = {{201, 0}, {280, 0}, {280, -100}, {62, -100}}, color = {0, 0, 127}));
  connect(integrator.y, power.u) annotation(
    Line(points = {{202, 0}, {280, 0}, {280, -40}, {262, -40}}, color = {0, 0, 127}));
  connect(integrator.y, product.u2) annotation(
    Line(points = {{202, 0}, {280, 0}, {280, -100}, {160, -100}, {160, -86}, {142, -86}}, color = {0, 0, 127}));
  connect(max1.yMax, limitedFirstOrder.u) annotation(
    Line(points = {{-18, 6}, {0, 6}, {0, 0}, {38, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Dc1a;
