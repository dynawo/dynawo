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

model Ac8b "IEEE exciter type AC8B model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc8(sum1.nin = 2);

equation
  sum1.u[2] = UPssPu;

  connect(sum1.y, pid.u_s) annotation(
    Line(points = {{-198, -40}, {18, -40}}, color = {0, 0, 127}));
  connect(pid.y, limitedFirstOrder.u) annotation(
    Line(points = {{42, -40}, {158, -40}}, color = {0, 0, 127}));
  connect(constant1.y, product.u1) annotation(
    Line(points = {{-258, 40}, {200, 40}, {200, 6}, {218, 6}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac8b;
