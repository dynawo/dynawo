within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ActivePowerControl;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ActivePowerControlDangling "Active power control for the HVDC VSC model with terminal2 connected to a switched-off bus (P control on terminal 1)"

  import Modelica;
  import Dynawo.Electrical.HVDC;

  extends HVDC.HvdcVSC.BaseControls.ActivePowerControl.BaseActivePowerControl;

  Modelica.Blocks.Sources.Constant zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(zero1.y, add1.u1) annotation(
    Line(points = {{-109, 80}, {15, 80}, {15, -2}, {19, -2}, {19, -2}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-110, -95}, {130, 105}})),
    Icon(coordinateSystem(grid = {1, 1})));
end ActivePowerControlDangling;
