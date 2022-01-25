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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model TransformDQtoRI "Transformation from d/q rotating reference frame with rotation angle phi to real/imaginary in stationary reference frame"
  import Modelica.Blocks.Interfaces;

  Interfaces.RealInput udPu "d-axis voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealInput uqPu "q-axis voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealInput cosPhi "cos(Phi) with Phi the angle of the dq transform" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealInput sinPhi "sin(Phi) with Phi the angle of the dq transform" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealOutput urPu "Real part of the complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.RealOutput uiPu "Imaginary part of the complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  urPu = udPu * cosPhi - uqPu * sinPhi;
  uiPu = udPu * sinPhi + uqPu * cosPhi;

annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-118, 85}, extent = {{-14, 7}, {14, -7}}, textString = "udPu"), Text(origin = {-118, 45}, extent = {{-14, 7}, {14, -7}}, textString = "uqPu"), Text(origin = {-114, -18}, extent = {{-25, 14}, {14, -7}}, textString = "cos(phi)"), Text(origin = {-114, -58}, extent = {{-25, 14}, {14, -7}}, textString = "sin(phi)"), Text(origin = {114, 71}, extent = {{-14, 7}, {14, -7}}, textString = "urPu"), Text(origin = {114, -50}, extent = {{-14, 7}, {14, -7}}, textString = "uiPu"), Text(origin = {-20, 14}, extent = {{-60, 66}, {100, -94}}, textString = "DQ/RI"), Rectangle(extent = {{-100, 100}, {100, -100}})}));end TransformDQtoRI;
