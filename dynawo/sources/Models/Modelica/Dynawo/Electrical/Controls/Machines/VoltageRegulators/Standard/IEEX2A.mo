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

model IEEX2A "IEEE excitation system type 2A model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseIEEEX(
    derivative.x_start = Efd0Pu * (Ke + AEx * exp(BEx * Efd0Pu)));

equation
  connect(product.y, derivative.u) annotation(
    Line(points = {{40, -80}, {20, -80}, {20, -60}, {-58, -60}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end IEEX2A;
