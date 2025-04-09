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

model St1a "IEEE excitation system type ST1A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt1(
    sum1.nin = 3);

equation
  sum1.u[2] = 0;

  connect(max1.yMax, transferFunction1.u) annotation(
    Line(points = {{-78, 6}, {-40, 6}, {-40, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(UOelPu, min2.u[2]) annotation(
    Line(points = {{-440, 80}, {280, 80}, {280, 6}, {300, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(preferredView = "diagram");
end St1a;
