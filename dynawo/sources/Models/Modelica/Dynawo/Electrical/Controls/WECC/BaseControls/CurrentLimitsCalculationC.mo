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

model CurrentLimitsCalculationC "Current limiter for the WECC REEC type C"

  //Parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current limit of the device in pu (base SNom, UNom) (typical: 1..2)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Types.PerUnit SOCMax "Maximum state of charge in pu (base SNom)";
  parameter Types.PerUnit SOCMin "Minimum state of charge in pu (base SNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "Active command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "Reactive command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput SOC(start = SOC0) "State of charge of the battery in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "Maximum active current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "Minimum active current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "Maximum reactive current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "Minimum reactive current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Initial parameter
  parameter Types.PerUnit SOC0 "Initial state of charge in pu (base SNom)";

equation
  iqMinPu = -iqMaxPu;

  if SOC >= SOCMax then
    ipMinPu = 0;
  else
    ipMinPu = -ipMaxPu;
  end if;

  if PQFlag then
    if SOC <= SOCMin then
      ipMaxPu = 0;
    else
      ipMaxPu = min(ipVdlPu, IMaxPu);
    end if;
    iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu ^ 2 > ipCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
  else
    if SOC <= SOCMin then
      ipMaxPu = 0;
    else
      ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu ^ 2 > iqCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
    end if;
    iqMaxPu = min(iqVdlPu, IMaxPu);
  end if;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {147, 71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {147, -77}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {75, 113}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {-63, 113}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {75, -119}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {-59, -119}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-142, -74}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-150, 8}, extent = {{-12, 6}, {12, -6}}, textString = "vDip"), Text(origin = {-140, 74}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu"), Text(origin = {-17, -119}, extent = {{-27, 9}, {13, -3}}, textString = "SOC")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationC;
