within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model CurrentCompensation "Local current-compensation block"

  parameter Types.PerUnit RcPu "Current-compensation resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XcPu "Current-compensation reactance in pu (base UNom, SNom)";

  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu "Complex current at generator terminal in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu "Complex voltage at generator terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput UPu "Voltage module after current-compensation in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  UPu = ComplexMath.'abs'(uPu - iPu * Complex(RcPu, XcPu));

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 2}, extent = {{-76, 78}, {84, -82}}, textString = "|V-Z*I|"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "iPu"), Text(origin = {-141, -31}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {89, 27}, extent = {{9, -7}, {37, -19}}, textString = "UPu")}, coordinateSystem(initialScale = 0.1)));
end CurrentCompensation;
