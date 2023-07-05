within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl;

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
  import Dynawo;
  import Dynawo.Types;

  parameter Types.PerUnit SlopeRPFault "Slope of the recovery of rpfault after a fault in pu/s";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput blocked1(start = false) "If true, HVDC link is blocked on side 1" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 29}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked2(start = false) "If true, HVDC link is blocked on side 2" annotation(
    Placement(visible = true, transformation(origin = {-120, -31}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput rpfault(start = 1) "Signal that is equal to 1 in normal conditions, 0 when the HVDC link is blocked, and that goes back to 1 with a ramp when it is unblocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.Time timer(start = 0);

equation
  when (blocked1 or blocked2) == true then
    timer = Modelica.Constants.inf;
  elsewhen (blocked1 and blocked2) == false then
    timer = time;
  end when;

  rpfault = if timer == 0 then 1 else min(SlopeRPFault * max(time - timer, 0), 1);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This function calculates a signal that is equal to 1 in normal conditions, 0 when the HVDC link is blocked, and that goes back to 1 with a ramp when it is unblocked.</body></html>"));
end RPFaultFunction;
