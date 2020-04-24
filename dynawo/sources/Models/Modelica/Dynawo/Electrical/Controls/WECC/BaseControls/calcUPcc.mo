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

model calcUPcc
  import Modelica;
  import Dynawo.Types;

  parameter Types.PerUnit Rc "Line drop compensation resistance";
  parameter Types.PerUnit Xc "Line drop compentation reactance";

  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput UPuLineDrop annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  UPuLineDrop = ComplexMath.'abs'(uPu + iPu * Complex(Rc,Xc));
  UPu = ComplexMath.'abs'(uPu);

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 2}, extent = {{-76, 78}, {84, -82}}, textString = "|V-Z*I|"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "iPu"), Text(origin = {-141, -31}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {112.5, 82}, extent = {{-10.5, 7}, {49.5, -24}}, textString = "UPuLineDrop"), Text(origin = {89, -35}, extent = {{9, -7}, {37, -19}}, textString = "UPu")}, coordinateSystem(initialScale = 0.1)));
end calcUPcc;
