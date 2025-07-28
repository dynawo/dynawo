within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model CurrentLimitsCalculationE "This block calculates the current limits of the WECC REEC-C regulation"

  parameter Types.CurrentModulePu IMaxPu "Maximum inverter current amplitude in pu (base SNom, UNom)";
  parameter Real Ke "Allow for modeling of energy storage";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Boolean PQFlagFRT "Q/P priority: Q (0) or P (1) priority selection on current limit flag during defaults";
  parameter Types.Time tBlkDelay "Time delay for unblocking after voltage recovers in s";
  parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after a voltage dip in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "p-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, 73}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "q-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -75}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, -35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vBlk "Ongoing voltage block" annotation(
    Placement(transformation(origin = {0, 112}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput vDip "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-111, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "p-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "p-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit ipMaxFrzPu(start = 0);
  Types.Time tEndVBlk(start = -1);
  Types.Time tEndVDipFrz(start = -1);
  
equation
  when (vDip == false and pre(vDip) == true) or (time < pre(tEndVDipFrz) and pre(tEndVDipFrz) >= 0) then
    tEndVDipFrz = time + abs(tHoldIpMax);
  elsewhen (vDip == true or pre(vDip) == false) and (time >= pre(tEndVDipFrz) or pre(tEndVDipFrz) < 0) then
    tEndVDipFrz = -1;
  end when;

  when time < tEndVDipFrz and tEndVDipFrz >= 0 then
    ipMaxFrzPu = pre(ipMaxPu);
  elsewhen time >= tEndVDipFrz or tEndVDipFrz < 0 then
    ipMaxFrzPu = 0;
  end when;

  when (vBlk == false and pre(vBlk) == true) or (time < pre(tEndVBlk) and pre(tEndVBlk) >= 0) then
    tEndVBlk = time + tBlkDelay;
  elsewhen(vBlk == true or pre(vBlk) == false) and (time >= pre(tEndVBlk) or pre(tEndVBlk) < 0) then
    tEndVBlk = -1;
  end when;

  if vBlk or time <= tEndVBlk then
    iqMaxPu = 0;
    iqMinPu = 0;
    ipMaxPu = 0;
    ipMinPu = 0;
  elseif not(vDip) then
    if PQFlag == false then
      if time <= tEndVDipFrz and tEndVDipFrz >= 0 then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu > iqCmdPu then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
      end if;
      iqMaxPu = min(iqVdlPu, IMaxPu);
      iqMinPu = -abs(iqMaxPu);
      ipMinPu = -Ke * ipMaxPu;
    else
      if time <= tEndVDipFrz and tEndVDipFrz >= 0 then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, IMaxPu);
      end if;
      iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu > ipCmdPu then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
      iqMinPu = -abs(iqMaxPu);
      ipMinPu = -Ke * ipMaxPu;
    end if;
  else
    if PQFlagFRT == false then
      if time <= tEndVDipFrz and tEndVDipFrz >= 0 then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu > iqCmdPu then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
      end if;
      iqMaxPu = min(iqVdlPu, IMaxPu);
      iqMinPu = -abs(iqMaxPu);
      ipMinPu = -Ke * ipMaxPu;
    else
      if time <= tEndVDipFrz and tEndVDipFrz >= 0 then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, IMaxPu);
      end if;
      iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu > ipCmdPu then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
      iqMinPu = -abs(iqMaxPu);
      ipMinPu = -Ke * ipMaxPu;
    end if;
  end if;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {-141, 83}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {135, -59}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {135, -13}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {135, 43}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {133, 87}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-146, 52}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-146, -36}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {9, -135}, extent = {{-27, 9}, {13, -3}}, textString = "SOC")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationE;
