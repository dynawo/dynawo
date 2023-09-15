within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block DelayFlag "Provides an extended fault flag fO which adds a post-fault value 2 to the input fault flag fI for a set duration of tD"

  parameter Types.Time tD "Delay time constant in s, specifies the duration of post-fault flag";
  parameter Types.Time tS "Integration time step in s";

  Modelica.Blocks.Interfaces.BooleanInput fI(start = FI0) "Input fault flag (boolean)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput fO(start = FO0) "Output fault flag (value 0, 1 or 2)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = tS) annotation(
    Placement(visible = true, transformation(origin = {10, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch18 annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const7(k = tD) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInteger switch1 annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = 2) annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.SwitchInteger switch2 annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Boolean FI0 "Initial input fault flag (boolean)";
  parameter Integer FO0 "Initial output fault flag (value 0, 1 or 2)";

equation
  connect(const7.y, switch18.u1) annotation(
    Line(points = {{-79, -40}, {-60, -40}, {-60, -32}, {-42, -32}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch18.u3) annotation(
    Line(points = {{-1, -80}, {-60, -80}, {-60, -48}, {-42, -48}}, color = {0, 0, 127}));
  connect(fI, switch18.u2) annotation(
    Line(points = {{-120, 0}, {-50, 0}, {-50, -40}, {-42, -40}}, color = {255, 0, 255}));
  connect(less1.y, switch1.u2) annotation(
    Line(points = {{21, 80}, {30, 80}, {30, 40}, {38, 40}}, color = {255, 0, 255}));
  connect(switch2.y, fO) annotation(
    Line(points = {{93, 0}, {110, 0}}, color = {255, 127, 0}));
  connect(fI, not1.u) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 80}, {-82, 80}}, color = {255, 0, 255}));
  connect(not1.y, timer.u) annotation(
    Line(points = {{-59, 80}, {-42, 80}}, color = {255, 0, 255}));
  connect(timer.y, less1.u1) annotation(
    Line(points = {{-19, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(switch18.y, fixedDelay.u) annotation(
    Line(points = {{-19, -40}, {60, -40}, {60, -80}, {22, -80}}, color = {0, 0, 127}));
  connect(switch18.y, less1.u2) annotation(
    Line(points = {{-19, -40}, {-10, -40}, {-10, 72}, {-2, 72}}, color = {0, 0, 127}));
  connect(integerConstant.y, switch1.u1) annotation(
    Line(points = {{-19, 40}, {20, 40}, {20, 48}, {38, 48}}, color = {255, 127, 0}));
  connect(booleanToInteger.y, switch1.u3) annotation(
    Line(points = {{-59, 20}, {30, 20}, {30, 32}, {38, 32}}, color = {255, 127, 0}));
  connect(fI, booleanToInteger.u) annotation(
    Line(points = {{-120, 0}, {-90, 0}, {-90, 20}, {-82, 20}}, color = {255, 0, 255}));
  connect(fI, switch2.u2) annotation(
    Line(points = {{-120, 0}, {70, 0}}, color = {255, 0, 255}));
  connect(booleanToInteger.y, switch2.u1) annotation(
    Line(points = {{-58, 20}, {30, 20}, {30, -8}, {70, -8}}, color = {255, 127, 0}));
  connect(switch1.y, switch2.u3) annotation(
    Line(points = {{62, 40}, {66, 40}, {66, 8}, {70, 8}}, color = {255, 127, 0}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {6, 25}, extent = {{-52, 59}, {42, -47}}, textString = "Delay"), Text(origin = {-2, -31}, extent = {{-38, 45}, {42, -47}}, textString = "Flag")}, coordinateSystem(initialScale = 0.1)));
end DelayFlag;
