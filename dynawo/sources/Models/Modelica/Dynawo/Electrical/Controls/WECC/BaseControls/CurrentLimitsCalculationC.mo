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

model CurrentLimitsCalculationC "This block calculates the current limits of the WECC REEC-C regulation"

  parameter Types.CurrentModulePu IMaxPu "Maximum inverter current amplitude in pu (base SNom, UNom)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";
  parameter Types.PerUnit SOCMaxPu "Maximum allowable state of charge in pu (base SNom) (typical: 0.8..1)";
  parameter Types.PerUnit SOCMinPu "Minimum allowable state of charge in pu (base SNom) (typical: 0..0.2)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "p-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "q-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipVdlPu "Voltage-dependent limit for active current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, 73}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqVdlPu "Voltage-dependent limit for reactive current command in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-111, -75}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-111, -35}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "p-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "p-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput SOCPu(start = SOC0Pu) "State of charge in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Initial parameter
  parameter Types.PerUnit SOC0Pu "Initial state of charge in pu (base SNom)";

equation
  if PQFlag then
    if SOCPu <= SOCMinPu then
      ipMaxPu = 0;
    else
      ipMaxPu = min(ipVdlPu, IMaxPu);
    end if;
    if SOCPu >= SOCMaxPu then
      ipMinPu = 0;
    else
      ipMinPu = - min(ipVdlPu, IMaxPu);
    end if;
    iqMaxPu = min(iqVdlPu, noEvent(if IMaxPu ^ 2 > ipCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0));
  else
    if SOCPu <= SOCMinPu then
      ipMaxPu = 0;
    else
      ipMaxPu = min(ipVdlPu, noEvent(if IMaxPu ^ 2 > iqCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
    end if;
    if SOCPu >= SOCMaxPu then
      ipMinPu = 0;
    else
      ipMinPu = - min(ipVdlPu, noEvent(if IMaxPu ^ 2 > iqCmdPu ^ 2 then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0));
    end if;
    iqMaxPu = min(iqVdlPu, IMaxPu);
  end if;

  iqMinPu = - iqMaxPu;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {-141, 83}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {135, -59}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {135, -13}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {135, 43}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {133, 87}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits"), Text(origin = {-146, 52}, extent = {{-20, 10}, {20, -10}}, textString = "ipVdlPu"), Text(origin = {-150, 8}, extent = {{-12, 6}, {12, -6}}, textString = "vDip"), Text(origin = {-146, -36}, extent = {{20, 6}, {-20, -6}}, textString = "iqVdlPu"), Text(origin = {-141, -71}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {9, -135}, extent = {{-27, 9}, {13, -3}}, textString = "SOC")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationC;
