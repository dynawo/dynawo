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

model St7b "IEEE excitation system type ST7B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt7;

equation
  connect(min2.yMin, variableLimiter.u) annotation(
    Line(points = {{222, 0}, {298, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St7b;
