within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/
  
model CurrentLimitsCalculationD "This block calculates the current limits of the WECC REEC-C regulation"
  
  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in pu (base SNom, UNom)";
  parameter Real Ke "Allow for modeling of energy storage";  
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Types.Time tBlkDelay "Time delay for unblocking after voltage recovers";
  parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after a voltage dip in s";
  
  // Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "p-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "q-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, 73}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -75}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, -35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vBlk "Ongoing voltage block" annotation(
    Placement(transformation(origin = {0, 112}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));  
  Modelica.Blocks.Interfaces.BooleanInput vDip "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-111, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  
  // Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "p-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "p-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Types.CurrentModulePu ipMaxFrzPu(start = 0);
  Types.Time vBlkEndTime(start = -1);
  Types.Time vDipFrzEndTime(start = -1);
 

equation
  when (vDip == false and pre(vDip) == true) or (time < pre(vDipFrzEndTime) and pre(vDipFrzEndTime) >= 0) then
    vDipFrzEndTime = time + abs(tHoldIpMax);
  elsewhen (vDip == true or pre(vDip) == false) and (time >= pre(vDipFrzEndTime) or pre(vDipFrzEndTime) < 0) then
    vDipFrzEndTime = -1;
  end when;
  when time < vDipFrzEndTime and vDipFrzEndTime >= 0 then
    ipMaxFrzPu = pre(ipMaxPu);
  elsewhen time >= vDipFrzEndTime or vDipFrzEndTime < 0 then
    ipMaxFrzPu = 0;
  end when;
  when (vBlk == false and pre(vBlk) == true) or (time < pre(vBlkEndTime) and pre(vBlkEndTime) >= 0) then
    vBlkEndTime=time+tBlkDelay;
    elsewhen(vBlk == true or pre(vBlk) == false) and (time >= pre(vBlkEndTime) or pre(vBlkEndTime) < 0) then
    vBlkEndTime=-1;
    end when;
  if vBlk or time<=vBlkEndTime then
    iqMaxPu = 0;
    iqMinPu = 0;
    ipMaxPu = 0;
    ipMinPu = 0;
  else
    if PQFlag == false then
      if time <= vDipFrzEndTime and vDipFrzEndTime >= 0 then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu > iqCmdPu then sqrt(IMaxPu^2 - iqCmdPu^2) else 0));
      end if;
      iqMaxPu = min(iqVdlPu, IMaxPu);
      iqMinPu = -abs(iqMaxPu);
      ipMinPu = -Ke*ipMaxPu;
    else
      if time <= vDipFrzEndTime and vDipFrzEndTime >= 0 then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, IMaxPu);
      end if;
      iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu > ipCmdPu then sqrt(IMaxPu^2 - ipCmdPu^2) else 0));
      iqMinPu = -abs(iqMaxPu);
      ipMinPu = -Ke*ipMaxPu;
    end if;
  end if 
  
  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {-141, 83}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {135, -59}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {135, -13}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {135, 43}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {133, 87}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-146, 52}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-146, -36}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {9, -135}, extent = {{-27, 9}, {13, -3}}, textString = "SOC")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationD;
