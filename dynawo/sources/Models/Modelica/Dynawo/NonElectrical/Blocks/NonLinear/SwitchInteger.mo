within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block SwitchInteger "Switch between two Integer signals"

  import Modelica;

  Modelica.Blocks.Interfaces.IntegerInput u0 "Connector of second Real input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput u1 "Connector of first Real input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput M "Connector of switch input signal" annotation(
    Placement(visible = true, transformation(origin = {-120,0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 1.77636e-15}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));

  Modelica.Blocks.Interfaces.IntegerOutput y "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {120, -4.44089e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  y = if M then u1 else u0;

  annotation(
    defaultComponentName = "switch1",
    Documentation(info = "<html>
<p>The Logical.Switch switches, depending on the
logical connector u2 (the middle connector)
between the two possible input signals
u1 (upper connector) and u3 (lower connector).</p>
<p>If u2 is <strong>true</strong>, the output signal y is set equal to
u1, else it is set equal to u3.</p>
</html>"),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {210, 210, 210}, fillPattern = FillPattern.Solid, borderPattern = BorderPattern.Raised, extent = {{-100, 100}, {100, -100}}), Line(points = {{-40, 12}, {-40, -12}}, color = {255, 0, 255}), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Line(points = {{-38, 80}, {6, 2}}, color = {245, 121, 0}, thickness = 1), Line(origin = {0.279255, 0}, points = {{-100, 0}, {-40, 0}}, color = {255, 0, 255}), Line(points = {{-100, 80}, {-38, 80}}, color = {245, 121, 0}), Line(points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {245, 121, 0}), Line(points = {{12, 0}, {100, 0}}, color = {245, 121, 0}), Ellipse(lineColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{2, -8}, {18, 8}})}));
end SwitchInteger;
