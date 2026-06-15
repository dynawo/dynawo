within Dynawo.Electrical.Controls.WECC.BaseControls;

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

model LineDropCompensation "This block calculates the voltage drop in an RcPu, XcPu line knowing the current and the voltage on one side"

  parameter Types.PerUnit RcPu "Line drop compensation resistance in pu (base UNom, SnRef)";
  parameter Types.PerUnit XcPu "Line drop compentation reactance in pu (base UNom, SnRef)";

  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu "Line complex current in pu (base UNom, SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u2Pu "Complex voltage at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput U1Pu "Voltage module at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput U2Pu "Voltage module at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  U1Pu = ComplexMath.'abs'(u2Pu + iPu * Complex(RcPu, XcPu));
  U2Pu = ComplexMath.'abs'(u2Pu);

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 2}, extent = {{-76, 78}, {84, -82}}, textString = "|V-Z*I|"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "iPu"), Text(origin = {-141, -31}, extent = {{3, -3}, {37, -19}}, textString = "u2Pu"), Text(origin = {89, -33}, extent = {{9, -7}, {37, -19}}, textString = "U2Pu"), Text(origin = {89, 87}, extent = {{9, -7}, {37, -19}}, textString = "U1Pu")}, coordinateSystem(initialScale = 0.1)));
end LineDropCompensation;
