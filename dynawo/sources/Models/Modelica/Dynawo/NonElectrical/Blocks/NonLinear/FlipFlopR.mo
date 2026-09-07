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

block FlipFlopR "RS flip flop with priority to reset"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseRSFlipFlop;

equation
  when s and not r then
    y = true;
  elsewhen r then
    y = false;
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>
The output <code>y</code>&nbsp; becomes true when s is true and r is false. y remains true as long as r is false.</p>
</body></html>"),
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-10, -90}, {-70, -30}}, endAngle = 360)}));
end FlipFlopR;
