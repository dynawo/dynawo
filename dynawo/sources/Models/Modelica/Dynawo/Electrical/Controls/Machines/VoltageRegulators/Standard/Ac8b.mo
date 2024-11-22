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

model Ac8b "IEEE exciter type AC8B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc8(
    limitedFirstOrder.Y0 = Efe0Pu,
    pid.xi_start = Efe0Pu / Ka,
    pid.y_start = Efe0Pu / Ka,
    sum1.nin = 2);

equation
  connect(sum1.y, pid.u_s) annotation(
    Line(points = {{-198, -40}, {18, -40}}, color = {0, 0, 127}));
  connect(pid.y, limitedFirstOrder.u) annotation(
    Line(points = {{42, -40}, {158, -40}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[2]) annotation(
    Line(points = {{-380, -100}, {-240, -100}, {-240, -40}, {-222, -40}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, acRotatingExciter.EfePu) annotation(
    Line(points = {{182, -40}, {260, -40}, {260, 0}, {276, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac8b;
