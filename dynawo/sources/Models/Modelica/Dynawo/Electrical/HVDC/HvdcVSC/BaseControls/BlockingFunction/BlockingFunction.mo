within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.BlockingFunction;

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

model BlockingFunction "Undervoltage blocking function for one side of an HVDC link"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.Parameters.ParamsBlockingFunction;

  //Input variable
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.BooleanOutput blocked(start = false) "If true, converter is blocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";

protected
  Types.Time tMaintainBlock(start = Modelica.Constants.inf) "Timer to maintain the blocking for a duration of at least TBlock";
  Types.Time tPrepareBlock(start = Modelica.Constants.inf) "Timer to prepare the blocking";
  Types.Time tPrepareDeblock(start = Modelica.Constants.inf) "Timer to prepare the deactivation of the blocking";
  Types.Time tStartBlock(start = Modelica.Constants.inf) "Timer to start the blocking";
  Types.VoltageModulePu UFilteredPu(start = U0Pu) "Filtered voltage module in pu (base UNom)";

equation
  UFilteredPu + tMeasureUBlock * der(UFilteredPu) = UPu;

  when UFilteredPu < UBlockUnderVPu then
    tPrepareBlock = time;
  elsewhen UFilteredPu > UBlockUnderVPu then
    tPrepareBlock = Modelica.Constants.inf;
  end when;

  when time - tPrepareBlock > tBlockUnderV then
    tStartBlock = time;
  elsewhen time - tPrepareBlock < tBlockUnderV then
    tStartBlock = Modelica.Constants.inf;
  end when;

  when blocked == true and UFilteredPu < UMaxDbPu and UFilteredPu > UMinDbPu then
    tPrepareDeblock = time;
  elsewhen blocked == false or UFilteredPu > UMaxDbPu or UFilteredPu < UMinDbPu then
    tPrepareDeblock = Modelica.Constants.inf;
  end when;

  when time - tStartBlock > 0 then
    blocked = true;
    tMaintainBlock = time;
  elsewhen time - tStartBlock < 0 and time > pre(tMaintainBlock) + tBlock and time > pre(tPrepareDeblock) + tUnblock + tBlock then
    blocked = false;
    tMaintainBlock = Modelica.Constants.inf;
  end when;

  annotation(preferredView = "text");
end BlockingFunction;
