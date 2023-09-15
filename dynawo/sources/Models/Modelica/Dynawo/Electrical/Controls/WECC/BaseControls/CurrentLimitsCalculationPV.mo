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

model CurrentLimitsCalculationPV "This block calculates the current limits of the WECC PV regulation"

  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in pu (base UNom, SNom)";
  parameter Boolean PPriority "Priority: reactive power (false) or active power (true)";

  Modelica.Blocks.Interfaces.RealInput ipCmdPu "p-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu "q-axis command current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ipMaxPu "p-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu "p-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.PerUnit ipLimPu = max(min(abs(ipCmdPu), IMaxPu), 0);
  Types.PerUnit iqLimPu = max(min(abs(iqCmdPu), IMaxPu), - IMaxPu);

equation
  if PPriority then
    ipMaxPu = IMaxPu;
    ipMinPu = 0;
    iqMaxPu = sqrt(IMaxPu ^ 2 - ipLimPu ^ 2);
    iqMinPu = - iqMaxPu;
  else
    ipMaxPu = sqrt(IMaxPu ^ 2 - iqLimPu ^ 2);
    ipMinPu = 0;
    iqMaxPu = IMaxPu;
    iqMinPu = - iqMaxPu;
  end if;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-115, -25}, extent = {{-27, 9}, {13, -3}}, textString = "iqCmdPu"), Text(origin = {-115, 53}, extent = {{-27, 9}, {13, -3}}, textString = "ipCmdPu"), Text(origin = {127, -9}, extent = {{-27, 9}, {13, -3}}, textString = "iqMinPu"), Text(origin = {127, -49}, extent = {{-27, 9}, {13, -3}}, textString = "iqMaxPu"), Text(origin = {127, 71}, extent = {{-27, 9}, {13, -3}}, textString = "ipMinPu"), Text(origin = {127, 31}, extent = {{-27, 9}, {13, -3}}, textString = "ipMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculationPV;
