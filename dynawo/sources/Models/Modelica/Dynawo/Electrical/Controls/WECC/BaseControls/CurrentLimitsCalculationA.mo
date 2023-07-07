within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model CurrentLimitsCalculationA "Current limiter for the WECC REEC type A"

  //Parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current limit of the device in pu (base SNom, UNom) (typical: 1..2)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Types.Time tHld2 "Time for which active current is held at its value during a voltage-dip, following the termination of the voltage-dip; in s (typical: 0..1, set to 0 to disable)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "Active command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "Reactive command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput vDip "True if voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "Maximum active current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "Minimum active current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "Maximum reactive current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "Minimum reactive current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

protected
  Types.PerUnit ipMaxFrzPu(start = 0) "Freeze value of ipCmdPu, afer a voltage dip, in pu (base SNom, UNom)";
  Types.Time vDipFrzIpEndTime(start = -1) "Time during which ipCmdPu is frozen, afer a voltage dip, in s";

equation
  /*  The following equations regarding ipMaxPu are similar to the ones in the IqInjectionLogic
   *  model,  where it handles time sensitive output control. For a detailed description,
   *  see the IqInjectionLogic block.
   *  1. At the time the voltage dip ends, the momentary value of ipCmdPu is memorized
   *     thanks to the when clause, assigned to ipMaxFrzPu and the end timing is
   *     calculated. During this time, ipCmdPu is forced to the value of ipMaxFrzPu
   *     because ipMaxPu and ipMinPu are both set to ipMaxFrzPu.
   *  2. When the end timing is reached, ipMaxPu and ipMinPu are back to the usual logic.
   */
  when not(vDip) then
    vDipFrzIpEndTime = time + tHld2;
    ipMaxFrzPu = pre(ipCmdPu);
  elsewhen vDip then
    vDipFrzIpEndTime = -1;
    ipMaxFrzPu = 1;
  end when;

  iqMinPu = -iqMaxPu;

  if PQFlag then
    if time <= vDipFrzIpEndTime then
      ipMaxPu = ipMaxFrzPu;
      ipMinPu = ipMaxFrzPu;
    else
      ipMaxPu = min(ipVdlPu, IMaxPu);
      ipMinPu = 0;
    end if;
    iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu > abs(ipCmdPu) then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
  else
    if time <= vDipFrzIpEndTime then
      ipMaxPu = ipMaxFrzPu;
      ipMinPu = ipMaxFrzPu;
    else
      ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu > abs(iqCmdPu) then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
      ipMinPu = 0;
    end if;
    iqMaxPu = min(iqVdlPu, IMaxPu);
  end if;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {147, 73}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {147, -77}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {73, 111}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {-61, 111}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {75, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {-61, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-140, -74}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-150, 8}, extent = {{-12, 6}, {12, -6}}, textString = "vDip"), Text(origin = {-140, 76}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationA;
