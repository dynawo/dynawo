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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block VariableDelayFlag "Provides an extended fault flag fO which adds a post-fault value 2 to the input fault flag fI for a variable duration of tD"

  parameter Types.Time tS "Integration step";

  Modelica.Blocks.Interfaces.BooleanInput fI(start = FI0) "Input fault flag (boolean)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tD(start = tD0) "Delay time in s, specifies the duration of post-fault flag" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput fO(start = FO0) "Output fault flag (value 0, 1 or 2)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = tS) annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Dynawo.NonElectrical.Blocks.Continuous.DecreaseDetection decreaseDetection(U0 = tD0, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-10, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IncreaseDetection increaseDetection(U0 = tD0, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay1(delayTime = tS) annotation(
    Placement(visible = true, transformation(origin = {30, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Boolean FI0 "Initial input fault flag (boolean)";
  parameter Integer FO0 "Initial output fault flag (value 0, 1 or 2)";
  parameter Types.Time tD0 "Initial delay time in s";

equation
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
  connect(switch3.y, less1.u2) annotation(
    Line(points = {{-10, -9}, {-10, 72}, {-2, 72}}, color = {0, 0, 127}));
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
  connect(tD, increaseDetection.u) annotation(
    Line(points = {{-120, -40}, {-90, -40}, {-90, -60}, {-80, -60}}, color = {0, 0, 127}));
  connect(increaseDetection.y, or1.u1) annotation(
    Line(points = {{-60, -60}, {-42, -60}}, color = {255, 0, 255}));
  connect(tD, switch3.u1) annotation(
    Line(points = {{-120, -40}, {-18, -40}, {-18, -32}}, color = {0, 0, 127}));
  connect(or1.y, switch3.u2) annotation(
    Line(points = {{-18, -60}, {-10, -60}, {-10, -32}}, color = {255, 0, 255}));
  connect(switch2.y, integerToReal.u) annotation(
    Line(points = {{94, 0}, {96, 0}, {96, -80}, {82, -80}}, color = {255, 127, 0}));
  connect(integerToReal.y, fixedDelay.u) annotation(
    Line(points = {{60, -80}, {42, -80}}, color = {0, 0, 127}));
  connect(fixedDelay.y, decreaseDetection.u) annotation(
    Line(points = {{20, -80}, {2, -80}}, color = {0, 0, 127}));
  connect(decreaseDetection.y, or1.u2) annotation(
    Line(points = {{-21, -80}, {-50, -80}, {-50, -68}, {-42, -68}}, color = {255, 0, 255}));
  connect(fixedDelay1.y, switch3.u3) annotation(
    Line(points = {{20, -40}, {-2, -40}, {-2, -32}}, color = {0, 0, 127}));
  connect(switch3.y, fixedDelay1.u) annotation(
    Line(points = {{-10, -8}, {-10, -6}, {20, -6}, {20, -20}, {60, -20}, {60, -40}, {42, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {6, -5}, extent = {{-52, 59}, {42, -47}}, textString = "Delay"), Text(origin = {-2, -61}, extent = {{-38, 45}, {42, -47}}, textString = "Flag"), Text(origin = {6, 59}, extent = {{-42, 49}, {32, -37}}, textString = "Var")}, coordinateSystem(initialScale = 0.1)));
end VariableDelayFlag;
