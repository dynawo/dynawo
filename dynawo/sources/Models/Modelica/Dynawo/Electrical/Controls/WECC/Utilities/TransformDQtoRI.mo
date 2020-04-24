within Dynawo.Electrical.Controls.WECC.Utilities;

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

block TransformDQtoRI "Transformation from d/q rotating reference frame with rotation angle phi to real/imaginary in stationary reference frame"
  import Modelica.Blocks;

  Modelica.Blocks.Interfaces.RealInput ud annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uq annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput cosphi annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sinphi annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ur annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ui annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  ur = ud * cosphi - uq * sinphi;
  ui = ud * sinphi + uq * cosphi;

annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-118, 85}, extent = {{-14, 7}, {14, -7}}, textString = "ud"), Text(origin = {-118, 45}, extent = {{-14, 7}, {14, -7}}, textString = "uq"), Text(origin = {-114, -18}, extent = {{-25, 14}, {14, -7}}, textString = "cos(phi)"), Text(origin = {-114, -58}, extent = {{-25, 14}, {14, -7}}, textString = "sin(phi)"), Text(origin = {114, 71}, extent = {{-14, 7}, {14, -7}}, textString = "ur"), Text(origin = {114, -50}, extent = {{-14, 7}, {14, -7}}, textString = "ui"), Text(origin = {-20, 14}, extent = {{-60, 66}, {100, -94}}, textString = "DQ/RI"), Rectangle(extent = {{-100, 100}, {100, -100}})}));end TransformDQtoRI;
