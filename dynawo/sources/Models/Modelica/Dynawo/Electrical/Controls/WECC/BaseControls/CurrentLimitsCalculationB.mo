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

model CurrentLimitsCalculationB "Current limiter for the WECC REEC type B"

  //Parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current limit of the device in pu (base SNom, UNom) (typical: 1..2)";
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipCmdPu "Active command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "Reactive command current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "Maximum active current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "Minimum active current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "Maximum reactive current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-40, 110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "Minimum reactive current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, 110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

equation
  ipMinPu = 0;
  iqMinPu = -iqMaxPu;

  if PQFlag then
    ipMaxPu = IMaxPu;
    iqMaxPu = noEvent(if IMaxPu > abs(ipCmdPu) then sqrt(IMaxPu ^ 2 - ipCmdPu ^ 2) else 0);
  else
    ipMaxPu = noEvent(if IMaxPu > abs(iqCmdPu) then sqrt(IMaxPu ^ 2 - iqCmdPu ^ 2) else 0);
    iqMaxPu = IMaxPu;
  end if;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {149, 73}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {147, -77}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {77, 113}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {-65, 113}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {73, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {-63, -117}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationB;
