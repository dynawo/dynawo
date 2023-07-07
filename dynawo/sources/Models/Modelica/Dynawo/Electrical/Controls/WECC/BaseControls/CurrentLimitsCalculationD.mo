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

model CurrentLimitsCalculationD "Current limiter for the WECC REEC type D"

  //Parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current limit of the device in pu (base SNom, UNom) (typical: 1..2)";
  parameter Types.PerUnit IqFrzPu "Value to which reactive-current command is frozen after a voltage-dip in pu (base SNom, UNom) (typical: 0)";
  parameter Types.PerUnit Ke "Scaling on ipMinPu; set to 0 for a generator, set to a value between 0 and 1 for a storage device, as appropriate, in pu (base SNom, UNom) (typical: 0..1)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Types.Time tBlkDelay "Time delay following blocking of the converter after which the converter is released from being blocked, in s (typical: 0.04..0.1)";
  parameter Types.Time tHld "Time for which reactive-current command is frozen after a voltage-dip; if positive then iqCmdPu is frozen to its final value during the voltage-dip; if negative then iqCmdPu is frozen to IqFrzPu; in s (typical: 0)";
  parameter Types.Time tHld2 "Time for which active current is held at its value during a voltage-dip, following the termination of the voltage-dip; in s (typical: 0..1, set to 0 to disable)";
  parameter Types.VoltageModulePu UBlkHPu "Voltage above which the converter is blocked (i.e. Iq = Ip = 0), in pu (base UNom)";
  parameter Types.VoltageModulePu UBlkLPu "Voltage below which the converter is blocked (i.e. Iq = Ip = 0), in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "Active command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "Reactive command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilteredPu "Filtered voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.BooleanInput vDip "Ongoing voltage dip" annotation(
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
  Types.Time blkEndTime(start = -1) "Time before which the converter is released from being blocked, in s";
  Types.PerUnit ipMaxFrzPu(start = 0) "Freeze value of ipCmdPu, afer a voltage dip, in pu (base SNom, UNom)";
  Types.PerUnit iqMaxFrzPu(start = 0) "Freeze value of iqMaxPu, afer a voltage dip, in pu (base SNom, UNom)";
  Types.Time vDipFrzIpEndTime(start = -1) "Time during which ipMaxPu is frozen, afer a voltage dip, in s";
  Types.Time vDipFrzIqEndTime(start = -1) "Time during which iqMaxPu is frozen, afer a voltage dip, in s";

equation
  /*  The following equations in this block combines the one in the IqInjectionLogic model,
   *  used in REECa, the ones in the CurrentLimitsCalculationA model, and the addition of
   *  a total blocking logic when the voltage is too high or too low.
   *  1. The converter can be fully blocked (i.e. Iq = Ip = 0). At the time the voltage
   *     goes back to nominal values, the timing of the release is calculated. During
   *     this time, the converter is still blocked. Then, the next logic is applied.
   *  2. At the time the voltage dip ends, the momentary value of ipCmdPu and iqCmdPu are
   *     memorized thanks to the when clause, assigned to ipMaxFrzPu and iqMaxFrzPu
   *     (except if tHld is negative, then IqFrzPu is selected), and the end timing is
   *     calculated. During this time, ipCmdPu (resp. iqCmdPu) is forced to the value of
   *     ipMaxFrzPu (resp. iqMaxFrzPu) because ipMaxPu and ipMinPu (resp. iqMaxPu and iqMinPu)
   *     are both set to ipMaxFrzPu (resp. iqMaxFrzPu).
   *  3. When the end timing is reached, ipMaxPu, ipMinPu, iqMaxPu and iqMinPu are back to
   *     the usual logic (note that ipMinPu can be negative to represent a storing device).
   */
  when not(vDip) then
    vDipFrzIpEndTime = time + tHld2;
    vDipFrzIqEndTime = time + abs(tHld);
    ipMaxFrzPu = pre(ipCmdPu);
    if tHld < -Modelica.Constants.eps then
      iqMaxFrzPu = IqFrzPu;
    else
      iqMaxFrzPu = pre(iqCmdPu);
    end if;
  elsewhen vDip then
    vDipFrzIpEndTime = -1;
    vDipFrzIqEndTime = -1;
    ipMaxFrzPu = 1;
    iqMaxFrzPu = 1;
  end when;

  when UFilteredPu > UBlkLPu or UFilteredPu < UBlkHPu then
    blkEndTime = time + tBlkDelay;
  elsewhen UFilteredPu <= UBlkLPu or UFilteredPu >= UBlkHPu then
    blkEndTime = -1;
  end when;

  if UFilteredPu <= UBlkLPu or UFilteredPu >= UBlkHPu or time <= blkEndTime then
    ipMaxPu = 0;
    ipMinPu = 0;
    iqMaxPu = 0;
    iqMinPu = 0;
  else
    if PQFlag then
      if time <= vDipFrzIpEndTime then
        ipMaxPu = ipMaxFrzPu;
        ipMinPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, IMaxPu);
        ipMinPu = -Ke * ipMaxPu;
      end if;
      if time <= vDipFrzIqEndTime then
        iqMaxPu = iqMaxFrzPu;
        iqMinPu = iqMaxFrzPu;
      else
        iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu > abs(ipCmdPu) then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
        if iqMaxPu < 0 then
          iqMinPu = iqMaxPu;
        else
          iqMinPu = -iqMaxPu;
        end if;
      end if;
    else
      if time <= vDipFrzIpEndTime then
        ipMaxPu = ipMaxFrzPu;
        ipMinPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu > abs(iqCmdPu) then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
        ipMinPu = -Ke * ipMaxPu;
      end if;
      if time <= vDipFrzIqEndTime then
        iqMaxPu = iqMaxFrzPu;
        iqMinPu = iqMaxFrzPu;
      else
        iqMaxPu = min(iqVdlPu, IMaxPu);
        if iqMaxPu < 0 then
          iqMinPu = iqMaxPu;
        else
          iqMinPu = -iqMaxPu;
        end if;
      end if;
    end if;
  end if;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-150, 8}, extent = {{-12, 6}, {12, -6}}, textString = "vDip"), Text(origin = {-140, 76}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu"), Text(origin = {-140, -74}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-61, 111}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {147, -77}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {-61, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {75, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {73, 111}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {147, 73}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {147, 13}, extent = {{-27, 9}, {13, -3}}, textString = "UFilteredPu")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationD;
