within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model OELNordic "Overexcitation limitation model for the Nordic 32 test system used for voltage stability studies"

  parameter Real OelMode "For positive field current error signal : if 1, OEL output constant, if 0, OEL output equal to error signal";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput u "Error signal of field current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output of OEL" annotation(
    Placement(visible = true, transformation(origin = {112, 0}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Start value of OEL output";

equation
  if u < -0.1 then
    y = -1;
  elseif u < 0 then
    y = 0;
  elseif OelMode > 0.5 then
    y = 1;
  else
    y = u;
  end if;

  annotation(preferredView = "text",
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(origin = {-44, 40}, extent = {{-56, 60}, {144, -140}}), Text(origin = {-77, 45}, extent = {{-13, 11}, {167, -99}}, textString = "OverExcitationLimitation")}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Rectangle(origin = {-72, 82}, extent = {{-28, 18}, {172, -182}})}, coordinateSystem(initialScale = 0.1)));
end OELNordic;
