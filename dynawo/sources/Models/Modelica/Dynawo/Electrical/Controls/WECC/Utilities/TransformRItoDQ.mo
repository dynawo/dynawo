within Dynawo.Electrical.Controls.WECC.Utilities;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model TransformRItoDQ "Transformation from real/imaginary in stationary reference frame to d/q rotating reference frame with rotation angle phi"

  //Input variables
  Modelica.Blocks.Interfaces.RealInput phi "Angle of the dq transform in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput xPu "Complex quantity in pu (base XNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput xdPu "d-axis quantity in pu (base XNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput xqPu "q-axis quantity in pu (base XNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  xdPu = ComplexMath.real(xPu) * cos(phi) + ComplexMath.imag(xPu) * sin(phi);
  xqPu = -ComplexMath.real(xPu) * sin(phi) + ComplexMath.imag(xPu) * cos(phi);

  annotation(
    preferredView = "text",
    Icon(graphics = {Text(origin = {32, -118}, extent = {{-25, 14}, {14, -7}}, textString = "phi"), Text(origin = {122, 75}, extent = {{-14, 7}, {14, -7}}, textString = "udPu"), Text(origin = {122, -76}, extent = {{-14, 7}, {14, -7}}, textString = "uqPu"), Text(origin = {-130, 15}, extent = {{-14, 7}, {14, -7}}, textString = "uPu"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-20, 14}, extent = {{-60, 66}, {100, -94}}, textString = "RI/DQ")}));
end TransformRItoDQ;
