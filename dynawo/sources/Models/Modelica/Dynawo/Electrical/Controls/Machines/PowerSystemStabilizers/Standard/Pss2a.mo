within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

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

model Pss2a "IEEE power system stabilizer type 2A"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss2;

equation
  connect(transferFunction1.y, limiter2.u) annotation(
    Line(points = {{162, 0}, {258, 0}}, color = {0, 0, 127}));
  connect(limiter2.y, VPssPu) annotation(
    Line(points = {{282, 0}, {300, 0}, {300, -40}, {370, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss2a;
