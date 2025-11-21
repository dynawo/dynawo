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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block TransformRItoDQ "Transformation from real/imaginary in stationary reference frame to d/q rotating reference frame with rotation angle phi"

  Modelica.Blocks.Interfaces.RealInput phi "Angle of the dq transform in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u "Complex input" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ud "d-axis output" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uq "q-axis output" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  ud = ComplexMath.real(u) * cos(phi) + ComplexMath.imag(u) * sin(phi);
  uq = (-ComplexMath.real(u) * sin(phi)) + ComplexMath.imag(u) * cos(phi);

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-114, -38}, extent = {{-25, 14}, {14, -7}}, textString = "phi"), Text(origin = {135, 63}, extent = {{-14, 7}, {14, -7}}, textString = "ydPu"), Text(origin = {134, -58}, extent = {{-14, 7}, {14, -7}}, textString = "yqPu"), Text(origin = {-130, 85}, extent = {{-14, 7}, {14, -7}}, textString = "uPu"), Text(origin = {-20, 14}, extent = {{-60, 66}, {100, -94}}, textString = "RI/DQ"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end TransformRItoDQ;
