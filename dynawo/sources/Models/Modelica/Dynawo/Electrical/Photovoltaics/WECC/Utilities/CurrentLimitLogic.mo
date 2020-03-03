within Dynawo.Electrical.Photovoltaics.WECC.Utilities;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/


block CurrentLimitLogic
  import Modelica.Blocks;
  import Dynawo.Types;
  parameter Types.PerUnit Imax "Maximum inverter current amplitude";
  parameter Boolean Pqflag "Priority: reactive power (false) or active power (true) ";
  Blocks.Interfaces.RealInput Ipcmd annotation(
    Placement(visible = true, transformation(origin = {-110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput Iqcmd annotation(
    Placement(visible = true, transformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput Ipmax annotation(
    Placement(visible = true, transformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput Iqmax annotation(
    Placement(visible = true, transformation(origin = {110, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput Ipmin annotation(
    Placement(visible = true, transformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput Iqmin annotation(
    Placement(visible = true, transformation(origin = {110, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  Types.PerUnit Ip_lim = max(min(abs(Ipcmd), Imax), 0);
  Types.PerUnit Iq_lim = max(min(abs(Iqcmd), Imax), -Imax);
equation
  if Pqflag then
  // P priority
    Ipmax = Imax;
    Ipmin = 0;
    Iqmax = sqrt(Imax ^ 2 - Ip_lim ^ 2);
    Iqmin = -Iqmax;
  else
  // Q priority
    Ipmax = sqrt(Imax ^ 2 - Iq_lim ^ 2);
    Ipmin =0;
    Iqmax = Imax;
    Iqmin = -Iqmax;
  end if;
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 1}, extent = {{-84, 71}, {78, -71}}, textString = "CurLim")}));
end CurrentLimitLogic;
