within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block RectReg "Rectifier Regulation"
  import Modelica;
  
  Modelica.Blocks.Interfaces.RealInput In "Rectifier Load Current" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Fex "Rectifier Regulation" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if In <= 0.433 then
    Fex = 1 - 0.577 * In;
  elseif In >= 0.75 then
    Fex = 1.732 * (1-In);
  else 
    Fex = abs(0.75 - In ^ 2) ^ 0.5;
  end if;

annotation(
    Diagram,
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 2},extent = {{-80, 80}, {80, -80}}, textString = "RectReg")}));
end RectReg;
