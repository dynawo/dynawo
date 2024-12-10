within Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block Max3 "Pass through the smallest signal"
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(visible = true, transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u3 annotation(
    Placement(visible = true, transformation(origin = {-118, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u2 annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y1;

equation
  y1 = max(u1, u2);
  y = max(y1, u3);

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Text(lineColor = {160, 160, 164}, extent = {{-90, 36}, {90, -36}}, textString = "max()"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    Documentation(info = "<html>
<p>
This block computes the output <strong>y</strong> as <em>maximum</em> of
the two Real inputs <strong>u1</strong> and <strong>u2</strong>:
</p>
<pre>    y = <strong>max</strong> ( u1 , u2 );
</pre>
</html>"));
end Max3;
