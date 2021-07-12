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

block UdqRef "Calculation of setpoints udRef and uqRef with source impedance R+jX based on current setpoints idRef and iqRef and measured terminal voltage ud and uq "

  import Modelica.Blocks;
  import Dynawo.Types;

  parameter Types.PerUnit R "Resistance equivalence ";
  parameter Types.PerUnit X "Reactance equivalence ";

  Modelica.Blocks.Interfaces.RealInput idRef annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqRef annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ud annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uq annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udRef annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqRef annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  udRef = ud + idRef * R - iqRef * X;
  uqRef = uq + iqRef * R + idRef * X;
  annotation(preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Text(origin = {-121.5, 96}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idRef"), Text(origin = {-121.5, 46}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqRef"), Text(origin = {-130.5, -11}, extent = {{0.5, 1}, {15.5, -10}}, textString = "ud"), Text(origin = {-130.5, -61}, extent = {{0.5, 1}, {15.5, -10}}, textString = "uq"), Text(origin = {119.5, 52}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "udRef"), Text(origin = {119.5, -29}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "uqRef"), Text(origin = {-10.5, 12}, extent = {{-69.5, 68}, {90.5, -92}}, textString = "UdqRef"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end UdqRef;
