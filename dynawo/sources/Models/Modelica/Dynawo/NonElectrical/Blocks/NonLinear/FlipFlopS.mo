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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block FlipFlopS "RS flip flop with priority to set"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseRSFlipFlop;

equation
  when r and not s then
    y = false;
  elsewhen s then
    y = true;
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>
The output <code>y</code>&nbsp; becomes false when r is true and s is false. y remains false as long as s is false.</p>
</body></html>"),
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-10, 30}, {-70, 90}}, endAngle = 360)}));
end FlipFlopS;
