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

model Ac1a "IEEE exciter type AC1A model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc1(
    max1.nu = 2,
    min1.nu = 2,
    VeMinPu = 0,
    VfeMaxPu = 999);

equation
  max1.u[2] = UUelPu;
  min1.u[2] = UOelPu;

  connect(add3.y, feedback.u1) annotation(
    Line(points = {{-178, -20}, {-88, -20}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac1a;
