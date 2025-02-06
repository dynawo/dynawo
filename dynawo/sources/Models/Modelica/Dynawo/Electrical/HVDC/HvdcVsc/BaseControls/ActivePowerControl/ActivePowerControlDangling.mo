within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ActivePowerControlDangling "Active power control for the HVDC VSC model with terminal2 connected to a switched-off bus (P control on terminal 1)"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl.BaseActivePowerControl;

  Modelica.Blocks.Sources.Constant zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(zero1.y, add1.u1) annotation(
    Line(points = {{-38, 80}, {20, 80}, {20, 6}, {38, 6}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end ActivePowerControlDangling;
