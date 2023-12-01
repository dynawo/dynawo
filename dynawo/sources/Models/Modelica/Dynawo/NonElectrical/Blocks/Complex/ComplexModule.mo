within Dynawo.NonElectrical.Blocks.Complex;

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

block ComplexModule "Calculates module of complex input"
  extends Modelica.Blocks.Icons.Block;

  Modelica.ComplexBlocks.Interfaces.ComplexInput u annotation(
    Placement(transformation(extent = {{-140, -20}, {-100, 20}})));

  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true,transformation(extent = {{100, -20}, {140, 20}}, rotation = 0), iconTransformation(extent = {{100, -20}, {140, 20}}, rotation = 0)));

equation
  y = noEvent(if (u.re ^ 2 + u.im ^ 2) > 0 then sqrt(u.re ^ 2 + u.im ^ 2) else 0);

  annotation(preferredView = "text",
    Icon(graphics = {Text(extent = {{-90, 60}, {90, -60}}, textString = "u", textStyle = {TextStyle.UnderLine}), Text(extent = {{-100, 60}, {0, -60}}, textString = "|"), Text(extent = {{0, 60}, {100, -60}}, textString = "|")}));
end ComplexModule;
