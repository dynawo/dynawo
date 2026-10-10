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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Ac1a "IEEE exciter type AC1A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc1(
    VeMinPu = 0,
    VfeMaxPu = 999);

equation
  max1.u[3] = max1.u[2];
  min1.u[3] = min1.u[2];

  connect(add3.y, feedback.u1) annotation(
    Line(points = {{-178, -20}, {-88, -20}}, color = {0, 0, 127}));
  connect(UOelPu, min1.u[2]) annotation(
    Line(points = {{-300, 60}, {100, 60}, {100, -20}, {120, -20}}, color = {0, 0, 127}));
  connect(UUelPu, max1.u[2]) annotation(
    Line(points = {{-300, -100}, {40, -100}, {40, -20}, {60, -20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(preferredView = "diagram");
end Ac1a;
