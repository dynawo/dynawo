within Dynawo.NonElectrical.Blocks.NonLinear;

block ConstantSwitch "Switch that uses the input value or let the output as a constant value"
  /*
  * Copyright (c) 2025, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  extends Modelica.Blocks.Icons.PartialBooleanBlock;
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
    Placement(transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 72}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanInput u2 annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -2}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(transformation(origin = {117, 1}, extent = {{-17, -17}, {17, 17}}), iconTransformation(origin = {121, 29}, extent = {{-21, -21}, {21, 21}})));
equation
  if u2 then
    der(y) = 0;
  else
    y = u1;
  end if;
  annotation(
    defaultComponentName = "switch1",
    Documentation(info = "<html>
<p>The Logical.Switch switches, depending on the
logical connector u2 (the middle connector)
between the input signal u1 and letting its output y constant.</p>
<p>If u2 is <strong>true</strong>, the output signal y is set equal to
u1, else y is constant.</p>
</html>"));
end ConstantSwitch;
