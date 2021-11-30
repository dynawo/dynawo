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

block FlipFlopR "RS flip flop with priority to reset"

  import Dynawo;

  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseRSFlipFlop;

equation
  when S and not R then
    y = true;
  elsewhen R then
    y = false;
  end when;

  annotation(
    Documentation(info = "<html><head></head><body><p>
The output <code>y</code>&nbsp; becomes true when S is true and R is false. y remains true as long as R is false.</p>
</body></html>"),
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-10, -90}, {-70, -30}}, endAngle = 360)}));
end FlipFlopR;
