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

  parameter Types.PerUnit Imax "Maximum inverter current amplitude";
  parameter Boolean PPriority "Priority: reactive power (false) or active power (true)";

  Modelica.Blocks.Interfaces.RealInput Ipcmd annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Iqcmd annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Ipmax annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Iqmax annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Ipmin annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Iqmin annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Types.PerUnit Ip_lim = max(min(abs(Ipcmd), Imax), 0);
  Types.PerUnit Iq_lim = max(min(abs(Iqcmd), Imax), - Imax);

equation
  if PPriority then
    Ipmax = Imax;
    Ipmin = 0;
    Iqmax = sqrt(Imax ^ 2 - Ip_lim ^ 2);
    Iqmin = - Iqmax;
  else
    Ipmax = sqrt(Imax ^ 2 - Iq_lim ^ 2);
    Ipmin = 0;
    Iqmax = Imax;
    Iqmin = - Iqmax;
  end if;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {44, -1}, extent = {{-124, 81}, {36, 21}}, textString = "Current"), Text(origin = {-115, -25}, extent = {{-27, 9}, {13, -3}}, textString = "Iqcmd"), Text(origin = {-115, 53}, extent = {{-27, 9}, {13, -3}}, textString = "Ipcmd"), Text(origin = {125, -9}, extent = {{-27, 9}, {13, -3}}, textString = "Iqmin"), Text(origin = {125, -49}, extent = {{-27, 9}, {13, -3}}, textString = "Iqmax"), Text(origin = {125, 71}, extent = {{-27, 9}, {13, -3}}, textString = "Ipmin"), Text(origin = {125, 31}, extent = {{-27, 9}, {13, -3}}, textString = "Ipmax"), Text(origin = {44, -61}, extent = {{-124, 41}, {36, -19}}, textString = "limiter")}, coordinateSystem(initialScale = 0.1)));
end CurrentLimitsCalculation;
