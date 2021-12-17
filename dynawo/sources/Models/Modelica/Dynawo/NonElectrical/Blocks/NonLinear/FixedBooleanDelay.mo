within Dynawo.NonElectrical.Blocks.NonLinear;

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

block FixedBooleanDelay "Delay block with fixed delay time for boolean input"

  import Modelica;
  import Dynawo;

  extends Modelica.Blocks.Interfaces.BooleanSISO(y(start = Y0));

  parameter Dynawo.Types.Time tDelay "Delay time of output with respect to input signal, in s";
  parameter Boolean Y0 "Initial value of output";

protected
  Integer yInteger;

equation
  yInteger = floor(delay(if u then 1 else 0, tDelay));

  when yInteger <> pre(yInteger) then
    y = not(pre(y));
  end when;

  annotation(
  preferredView = "text",
  Icon(graphics = {Line(points = {{-60, -80}, {10, -80}, {10, 80}, {60, 80}, {60, -80}, {92, -80}}, color = {160, 160, 164}), Line(points = {{-92, -80}, {-60, -80}, {-60, 80}, {-10, 80}, {-10, -80}, {92, -80}}, color = {255, 0, 255})}),
  Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end FixedBooleanDelay;
