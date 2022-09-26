within Dynawo.Electrical.Controls.Voltage;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model VRRemote "Model for centralized remote voltage regulation"

import Dynawo.Connectors;
import Dynawo.Types;
import Modelica;

  parameter Types.VoltageModule URef0 "Start value of the regulated voltage reference in kV";
  parameter Types.VoltageModule U0 "Start value of the regulated voltage in kV";
  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Time integration constant";

  Modelica.Blocks.Interfaces.RealInput URegulated(start = U0) "Regulated voltage in kV" annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URef(start = URef0) "Voltage regulation set point in kV" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput NQ "Signal to change the reactive power generation of the generators participating in the centralized distant voltage regulation (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI pi(T = tIntegral, k = Gain, x_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(URef, feedback.u1) annotation(
    Line(points = {{-99, 0}, {-49, 0}, {-49, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(URegulated, feedback.u2) annotation(
    Line(points = {{-120, -50}, {-40, -50}, {-40, -8}, {-40, -8}}, color = {0, 0, 127}));
  connect(feedback.y, pi.u) annotation(
    Line(points = {{-31, 0}, {-13, 0}, {-13, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(pi.y, NQ) annotation(
    Line(points = {{11, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));

annotation(preferredView = "diagram");
end VRRemote;
