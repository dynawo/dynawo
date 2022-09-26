within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ActivePowerControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model RPFaultFunction "rpfault function for HVDC"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_RPFaultFunction;

  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput rpfault(start = 1) "Signal that is equal to 1 in normal conditions, 0 when the HVDC link is blocked, and that goes back to 1 with a ramp when it is unblocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.Time Timer(start = 0);

equation
  when blocked == true then
    Timer = Modelica.Constants.inf;
  elsewhen blocked == false then
    Timer = time;
  end when;

  rpfault = if Timer == 0 then 1 else min(SlopeRPFault * max(time - Timer, 0), 1);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This function calculates a signal that is equal to 1 in normal conditions, 0 when the HVDC link is blocked, and that goes back to 1 with a ramp when it is unblocked.</body></html>"),
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end RPFaultFunction;
