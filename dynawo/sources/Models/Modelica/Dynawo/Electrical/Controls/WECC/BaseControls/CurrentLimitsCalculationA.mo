within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentLimitsCalculationA "This block calculates the current limits of the WECC REEC-A regulation"

  parameter Types.CurrentModulePu IMaxPu "Maximum inverter current amplitude in pu (base UNom, SNom)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after a voltage dip in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "p-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "q-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vDip "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-112, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-111, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, 73}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -75}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, -35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "p-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "p-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.CurrentModulePu ipMaxFrzPu(start = 0);
  Types.PerUnit ipRawMaxPu "p-axis maximum current (not accounting for voltage-dependent limit) in pu (base SNom, UNom)";
  Types.PerUnit iqRawMaxPu "q-axis maximum current (not accounting for voltage-dependent limit) in pu (base SNom, UNom)";
  Types.Time vDipFrzEndTime(start = -1);

equation
  /*  The following equations in this block are similar to the one in the IqInjectionLogic model,
   *  where it handles time sensitive output control. For a detailed description,
   *  see the IqInjectionLogic block.
   *  1. At the time the voltage dip ends, the momentary value of ipMaxPu is memorized
   *     thanks to the when clause, assigned to ipmaxFrzPu and the end timing is
   *     calculated. During this time, ipMaxPu is set to ipmaxFrzPu.
   *  2. When the end timing is reached, ipmaxFrzPu is reset and the ipMaxPu uses then
   *     usual calculation formula.
   */
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

  if PQFlag then
    if time <= vDipFrzEndTime and vDipFrzEndTime >= 0 then
      ipMaxPu = ipMaxFrzPu;
    else
      ipMaxPu = if ipVdlPu < IMaxPu then ipVdlPu else IMaxPu;
    end if;
    ipRawMaxPu = 0;
    iqRawMaxPu = noEvent(if IMaxPu ^ 2 > ipCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0);
    iqMaxPu = if iqVdlPu < iqRawMaxPu then iqVdlPu else iqRawMaxPu;
  else
    if time <= vDipFrzEndTime and vDipFrzEndTime >= 0 then
      ipMaxPu = ipMaxFrzPu;
    else
      ipMaxPu = if ipVdlPu < ipRawMaxPu then ipVdlPu else ipRawMaxPu;
    end if;
    ipRawMaxPu = noEvent(if IMaxPu ^ 2 > iqCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0);
    iqRawMaxPu = 0;
    iqMaxPu = if iqVdlPu < IMaxPu then iqVdlPu else IMaxPu;
  end if;

  ipMinPu = 0;
  iqMinPu = -iqMaxPu;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {-141, 83}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {135, -59}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {135, -13}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {135, 43}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {133, 87}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-146, 52}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-150, 8}, extent = {{-12, 6}, {12, -6}}, textString = "vDip"), Text(origin = {-146, -36}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationA;
