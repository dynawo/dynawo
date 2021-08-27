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

  parameter Types.PerUnit IMax "Maximum inverter current amplitude";
  parameter Boolean PPriority "Priority: reactive power (false) or active power (true)";

  Modelica.Blocks.Interfaces.RealInput IpCmd annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IqCmd annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IpMax annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IqMax annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IpMin annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IqMin annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.PerUnit IpLim = max(min(abs(IpCmd), IMax), 0);
  Types.PerUnit IqLim = max(min(abs(IqCmd), IMax), - IMax);

equation
  if PPriority then
    IpMax = IMax;
    IpMin = 0;
    IqMax = sqrt(IMax ^ 2 - IpLim ^ 2);
    IqMin = - IqMax;
  else
    IpMax = sqrt(IMax ^ 2 - IqLim ^ 2);
    IpMin = 0;
    IqMax = IMax;
    IqMin = - IqMax;
  end if;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-115, -25}, extent = {{-27, 9}, {13, -3}}, textString = "IqCmd"), Text(origin = {-115, 53}, extent = {{-27, 9}, {13, -3}}, textString = "IpCmd"), Text(origin = {125, -9}, extent = {{-27, 9}, {13, -3}}, textString = "IqMin"), Text(origin = {125, -49}, extent = {{-27, 9}, {13, -3}}, textString = "IqMax"), Text(origin = {125, 71}, extent = {{-27, 9}, {13, -3}}, textString = "IpMin"), Text(origin = {125, 31}, extent = {{-27, 9}, {13, -3}}, textString = "IpMax"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limits")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculation;
