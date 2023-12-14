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
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
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

  Types.PerUnit ipMaxFrzPu(start = 0) "Freeze value of ipMaxPu (and ipCmdPu) afer a voltage dip, in pu (base SNom, UNom)";
  Types.PerUnit iqMaxFrzPu(start = 0) "Freeze value of iqMaxPu (and iqCmdPu) afer a voltage dip, in pu (base SNom, UNom)";

  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay holdIqAfterDip(tDelay = abs(tHld)) "True for |tHld| seconds after a voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-76, 40}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay holdIpAfterDip(tDelay = tHld2) "True for tHld2 seconds after a voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-76, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay holdAfterBlock(tDelay = tBlkDelay) "True for tBlkDelay seconds after the converter is released from being blocked" annotation(
    Placement(visible = true, transformation(origin = {84, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold = UBlkLPu) annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold = UBlkHPu) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  when edge(holdIpAfterDip.y) then
    ipMaxFrzPu = pre(ipMaxPu);
    iqMaxFrzPu = pre(iqMaxPu);
  end when;

  if holdAfterBlock.u or holdAfterBlock.y then
    ipMaxPu = 0;
    ipMinPu = 0;
    iqMaxPu = 0;
    iqMinPu = 0;
  else
    ipMinPu = -Ke * ipMaxPu;
    if iqMaxPu < 0 then
      iqMinPu = iqMaxPu;
    else
      iqMinPu = -iqMaxPu;
    end if;
    if PQFlag then
      if holdIpAfterDip.y then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, IMaxPu);
      end if;
      if holdIqAfterDip.y then
        iqMaxPu = if tHld < 0 then IqFrzPu else iqMaxFrzPu;
      else
        iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu ^ 2 > ipCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
      end if;
    else
      if holdIpAfterDip.y then
        ipMaxPu = ipMaxFrzPu;
      else
        ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu ^ 2 > iqCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
      end if;
      if holdIqAfterDip.y then
        iqMaxPu = if tHld < 0 then IqFrzPu else iqMaxFrzPu;
      else
        iqMaxPu = min(iqVdlPu, IMaxPu);
      end if;
    end if;
  end if;

  connect(vDip, holdIpAfterDip.u) annotation(
    Line(points = {{-110, 0}, {-82, 0}}, color = {255, 0, 255}));
  connect(vDip, holdIqAfterDip.u) annotation(
    Line(points = {{-110, 0}, {-90, 0}, {-90, 40}, {-82, 40}}, color = {255, 0, 255}));
  connect(UFilteredPu, lessEqualThreshold.u) annotation(
    Line(points = {{-40, 0}, {-10, 0}, {-10, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(UFilteredPu, greaterEqualThreshold.u) annotation(
    Line(points = {{-40, 0}, {-10, 0}, {-10, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(or1.y, holdAfterBlock.u) annotation(
    Line(points = {{62, 0}, {78, 0}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.y, or1.u1) annotation(
    Line(points = {{22, 20}, {30, 20}, {30, 0}, {38, 0}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold.y, or1.u2) annotation(
    Line(points = {{22, -20}, {30, -20}, {30, -8}, {38, -8}}, color = {255, 0, 255}));

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-150, 8}, extent = {{-12, 6}, {12, -6}}, textString = "vDip"), Text(origin = {-140, 76}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu"), Text(origin = {-140, -74}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-61, 111}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {147, -77}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {-61, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {75, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {73, 111}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {147, 73}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {147, 13}, extent = {{-27, 9}, {13, -3}}, textString = "UFilteredPu")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationD;
