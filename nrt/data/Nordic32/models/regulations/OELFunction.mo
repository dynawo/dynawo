/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model OELFunction
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-129, 1}, extent = {{-29, -29}, {29, 29}}, rotation = 0), iconTransformation(origin = {-120, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = y_start) annotation(
    Placement(visible = true, transformation(origin = {112, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {108, 4.44089e-16}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  parameter Real f;
  parameter Real r;
  parameter Real y_start;
equation

  if u < (-0.1) then
    y = -1;
  elseif (-0.1) < u and u < 0 then
    y = 0;
  else
    y = f + r*u;
  end if;
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {-44, 40}, extent = {{-56, 60}, {144, -140}}),  Text(origin = {-77, 45}, extent = {{-13, 11}, {167, -99}}, textString = "OELFunction")}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Rectangle(origin = {-72, 82}, extent = {{-28, 18}, {172, -182}})}, coordinateSystem(initialScale = 0.1)));

end OELFunction;
