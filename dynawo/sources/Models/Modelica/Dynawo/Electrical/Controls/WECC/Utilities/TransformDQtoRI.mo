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

model TransformDQtoRI "Transformation from d/q rotating reference frame with rotation angle phi to real/imaginary in stationary reference frame"

  Modelica.Blocks.Interfaces.RealInput phi "Angle of the dq transform in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ud "d-axis input" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uq "q-axis input" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ui "Imaginary part of the complex variable" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ur "Real part of the complex variable" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  ur = ud * cos(phi) - uq * sin(phi);
  ui = ud * sin(phi) + uq * cos(phi);

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-118, 85}, extent = {{-14, 7}, {14, -7}}, textString = "udPu"), Text(origin = {-118, 45}, extent = {{-14, 7}, {14, -7}}, textString = "uqPu"), Text(origin = {-114, -43}, extent = {{-25, 14}, {14, -7}}, textString = "phi"), Text(origin = {114, 71}, extent = {{-14, 7}, {14, -7}}, textString = "urPu"), Text(origin = {114, -46}, extent = {{-14, 7}, {14, -7}}, textString = "uiPu"), Text(origin = {-20, 14}, extent = {{-60, 66}, {100, -94}}, textString = "DQ/RI"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end TransformDQtoRI;
