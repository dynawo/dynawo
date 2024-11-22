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

model Ac6a "IEEE excitation system type AC6A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc6(
    sum1.nin = 2,
    VeMinPu = 0,
    VfeMaxPu = 999);

equation
  connect(limitedLeadLag.y, feedback.u1) annotation(
    Line(points = {{-38, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-360, -80}, {-200, -80}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(preferredView = "diagram");
end Ac6a;
