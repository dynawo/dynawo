within Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses;

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

partial block BasePulse "Base block of pulse"
  extends Modelica.Blocks.Interfaces.BooleanSISO;

  parameter Types.Time tPulse "Duration of the pulse in s";

  Types.Time tTrigger(start = -Modelica.Constants.inf) "Start time of pulse in s";

equation
  when time - pre(tTrigger) >= tPulse then
    tTrigger = pre(tTrigger);
  elsewhen u and time - pre(tTrigger) >= tPulse then
    tTrigger = time;
  end when;

  annotation(
   preferredView = "text",
   Icon(graphics={Line(points = {{-80, -60}, {-40, -60}, {-40, 60}, {40, 60}, {40, -60}, {80, -60}}), Text(extent = {{-30, 30}, {30, -30}}, textString = "%tPulse")}),
   Diagram(graphics={Text(origin = {10, 0}, extent = {{-60, -74}, {-19, -82}}, textString = "tTrigger"), Line(origin = {10, 0}, points = {{-70, -70}, {-40, -70}, {-40, 20}, {20, 20}, {20, -70}, {50, -70}}, color = {255, 0, 255}, thickness = 0.5), Line(origin = {10, 0}, points = {{20, 50}, {20, 20}}, color = {95, 95, 95}), Line(origin = {10, 0}, points = {{-40, 35}, {20, 35}}, color = {95, 95, 95}), Text(origin = {10, 0}, extent = {{-33, 47}, {14, 37}}, textString = "tPulse"), Line(origin = {10, 0}, points = {{-70, 20}, {-41, 20}}, color = {95, 95, 95}), Polygon(origin = {10, 0}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, points = {{-40, 35}, {-31, 37}, {-31, 33}, {-40, 35}}), Polygon(origin = {10, 0}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, points = {{20, 35}, {12, 37}, {12, 33}, {20, 35}}), Text(origin = {10, 0}, extent = {{-95, 26}, {-66, 17}}, textString = "true"), Text(origin = {10, 0}, extent = {{-96, -60}, {-75, -69}}, textString = "false"), Line(origin = {-50.15, 0}, points = {{20, 50}, {20, 20}}, color = {95, 95, 95})}));
end BasePulse;
