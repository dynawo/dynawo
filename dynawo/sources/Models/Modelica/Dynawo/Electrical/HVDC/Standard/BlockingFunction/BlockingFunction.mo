within Dynawo.Electrical.HVDC.Standard.BlockingFunction;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model BlockingFunction "Blocking function"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu UBlockUVPu "Minimum voltage that triggers the blocking function in p.u (base UNom)";
  parameter Types.Time TBlockUV "If UPu < UBlockUVPu during TBlockUV then the blocking is activated";
  parameter Types.Time TBlock "The blocking is activated during at least TBlock";
  parameter Types.Time TDeblockU "When UPu goes back between UMindbPu and UMaxdbPu for TDeblockU then the blocking is deactivated";
  parameter Types.VoltageModulePu UMindbPu "Minimum voltage that deactivate the blocking function in p.u (base UNom)";
  parameter Types.VoltageModulePu UMaxdbPu "Maximum voltage that deactivate the blocking function in p.u (base UNom)";

  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanOutput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu U0Pu;

  Types.Time TimerPrepareBlock(start = Modelica.Constants.inf) "Timer to prepare the blocking";
  Types.Time TimerStartBlock(start = Modelica.Constants.inf) "Timer to start the blocking, TBlockUV after TimerPrepareBlock";
  Types.Time TimerMaintainBlock(start = Modelica.Constants.inf) "Timer to maintain the blocking at least TBlock";
  Types.Time TimerPrepareDeblock(start = Modelica.Constants.inf) "Timer to prepare the deactivation of the blocking";

equation

  when UPu < UBlockUVPu then
    TimerPrepareBlock = time;
  elsewhen UPu > UBlockUVPu then
    TimerPrepareBlock = Modelica.Constants.inf;
  end when;

  when time - TimerPrepareBlock > TBlockUV then
    TimerStartBlock = time;
  elsewhen time - TimerPrepareBlock < TBlockUV then
    TimerStartBlock = Modelica.Constants.inf;
  end when;

  when blocked == true and UPu < UMaxdbPu and UPu > UMindbPu then
    TimerPrepareDeblock = time;
  elsewhen blocked == false or UPu > UMaxdbPu or UPu < UMindbPu then
    TimerPrepareDeblock = Modelica.Constants.inf;
  end when;

  when time - TimerStartBlock > 0 then
    blocked = true;
    TimerMaintainBlock = time;
  elsewhen time - TimerStartBlock < 0 and time > pre(TimerMaintainBlock) + TBlock and time > pre(TimerPrepareDeblock) + TDeblockU then
    blocked = false;
    TimerMaintainBlock = Modelica.Constants.inf;
  end when;

  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));


end BlockingFunction;
