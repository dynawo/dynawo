within Dynawo.NonElectrical.Blocks.NonLinear;

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

block FixedBooleanDelay "Delay block with fixed delay time for boolean input"

  import Modelica;
  import Dynawo;

  extends Modelica.Blocks.Interfaces.BooleanSISO(y(start = yStart));

  parameter Dynawo.Types.Time delayTime "Delay time of output with respect to input signal";
  parameter Boolean yStart "Initial value of output";

  Integer yInteger;

equation
  yInteger = floor(delay(if u then 1 else 0, delayTime));

  when yInteger <> pre(yInteger) then
    y = not(pre(y));
  end when;

  annotation(
    Icon(graphics = {Line(points = {{-62, 0}, {-50.7, 34.2}, {-43.5, 53.1}, {-37.1, 66.4}, {-31.4, 74.6}, {-25.8, 79.1}, {-20.2, 79.8}, {-14.6, 76.6}, {-8.9, 69.7}, {-3.3, 59.4}, {3.1, 44.1}, {11.17, 21.2}, {28.1, -30.8}, {35.3, -50.2}, {41.7, -64.2}, {47.3, -73.1}, {53, -78.4}, {58.6, -80}, {64.2, -77.6}, {69.9, -71.5}, {75.5, -61.9}, {81.9, -47.2}, {90, -24.8}, {98, 0}}, color = {160, 160, 164}, smooth = Smooth.Bezier), Line(origin = {0, -0.32}, points = {{-92, 0}, {-80.7, 34.2}, {-73.5, 53.1}, {-67.1, 66.4}, {-61.4, 74.6}, {-55.8, 79.1}, {-50.2, 79.8}, {-44.6, 76.6}, {-38.9, 69.7}, {-33.3, 59.4}, {-26.9, 44.1}, {-18.83, 21.2}, {-1.9, -30.8}, {5.3, -50.2}, {11.7, -64.2}, {17.3, -73.1}, {23, -78.4}, {28.6, -80}, {34.2, -77.6}, {39.9, -71.5}, {45.5, -61.9}, {51.9, -47.2}, {60, -24.8}, {68, 0}}, color = {255, 0, 255}, smooth = Smooth.Bezier)}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end FixedBooleanDelay;
