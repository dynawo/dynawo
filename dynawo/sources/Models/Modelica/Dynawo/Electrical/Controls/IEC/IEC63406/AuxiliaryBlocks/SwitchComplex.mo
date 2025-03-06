within Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block SwitchComplex "Switch between two Complex signals"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput u1 annotation(
    Placement(visible = true, transformation(origin = {-120, 58}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput u2 annotation(
    Placement(visible = true, transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u3 annotation(
    Placement(visible = true, transformation(origin = {-122, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.ComplexBlocks.Interfaces.ComplexOutput y annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  y = if u2 then u1 else u3;

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
    Icon(graphics = {Line(points = {{-38, 80}, {6, 2}}, color = {0, 0, 127}, thickness = 1), Line(points = {{-100, 0}, {-40, 0}}, color = {255, 0, 255}), Line(points = {{12, 0}, {100, 0}}, color = {0, 0, 127}), Line(points = {{-40, 12}, {-40, -12}}, color = {255, 0, 255}), Line(points = {{-100, 80}, {-38, 80}}, color = {0, 0, 127}), Ellipse(lineColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{2, -8}, {18, 8}}), Line(points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127})}));
end SwitchComplex;
