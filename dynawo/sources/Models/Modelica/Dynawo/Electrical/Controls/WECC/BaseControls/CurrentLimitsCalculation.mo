within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block CurrentLimitsCalculation "This block calculates the current limits"
  import Modelica;
  import Dynawo.Types;

  parameter Types.PerUnit IMaxPu "Maximum inverter current amplitude in p.u (base UNom, SNom)";
  parameter Boolean PPriority "Priority: reactive power (false) or active power (true)";

  Modelica.Blocks.Interfaces.RealInput IpCmdPu "p-axis command current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IqCmdPu "q-axis command current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IpMaxPu "p-axis maximum current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IqMaxPu "q-axis maximum current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IpMinPu "p-axis minimum current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IqMinPu "q-axis minimum current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.PerUnit IpLimPu = max(min(abs(IpCmdPu), IMaxPu), 0);
  Types.PerUnit IqLimPu = max(min(abs(IqCmdPu), IMaxPu), - IMaxPu);

equation
  if PPriority then
    IpMaxPu = IMaxPu;
    IpMinPu = 0;
    IqMaxPu = sqrt(IMaxPu ^ 2 - IpLimPu ^ 2);
    IqMinPu = - IqMaxPu;
  else
    IpMaxPu = sqrt(IMaxPu ^ 2 - IqLimPu ^ 2);
    IpMinPu = 0;
    IqMaxPu = IMaxPu;
    IqMinPu = - IqMaxPu;
  end if;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-115, -25}, extent = {{-27, 9}, {13, -3}}, textString = "IqCmdPu"), Text(origin = {-115, 53}, extent = {{-27, 9}, {13, -3}}, textString = "IpCmdPu"), Text(origin = {127, -9}, extent = {{-27, 9}, {13, -3}}, textString = "IqMinPu"), Text(origin = {127, -49}, extent = {{-27, 9}, {13, -3}}, textString = "IqMaxPu"), Text(origin = {127, 71}, extent = {{-27, 9}, {13, -3}}, textString = "IpMinPu"), Text(origin = {127, 31}, extent = {{-27, 9}, {13, -3}}, textString = "IpMaxPu"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculation;
