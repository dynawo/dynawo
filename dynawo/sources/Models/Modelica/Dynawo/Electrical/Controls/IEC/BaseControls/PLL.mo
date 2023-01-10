within Dynawo.Electrical.Controls.IEC.BaseControls;

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

model PLL "Phase locked loop for angle detection (IEC N°61400-27-1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  //PLL parameters
  parameter Types.Time tPll "PLL first order filter time constant in s" annotation(
    Dialog(tab = "PLL"));
  parameter Types.VoltageModulePu UPll1Pu "Voltage below which the angle of the voltage is filtered and possibly also frozen, in pu (base UNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.VoltageModulePu UPll2Pu "Voltage below which the angle of the voltage is frozen, in pu (base UNom) (UPll2Pu < UPll1Pu typically)" annotation(
    Dialog(tab = "PLL"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter and grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput thetaPll(start = UPhase0) "Phase shift after phase locked loop in rad" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze(DyMax = 999, UseLimits = false, Y0 = UPhase0, YMax = 999, tI = tPll) annotation(
    Placement(visible = true, transformation(origin = {10, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh = (-UPll1Pu) + 1e-3, uLow = -UPll1Pu, y(start = U0Pu < UPll1Pu)) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis1(uHigh = (-UPll2Pu) + 1e-3, uLow = -UPll2Pu, y(start = U0Pu < UPll2Pu)) annotation(
    Placement(visible = true, transformation(origin = {-30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(theta, switch.u3) annotation(
    Line(points = {{-120, 0}, {40, 0}, {40, 8}, {58, 8}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, switch.u1) annotation(
    Line(points = {{21, -40}, {40, -40}, {40, -8}, {58, -8}}, color = {0, 0, 127}));
  connect(theta, absLimRateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-120, 0}, {-20, 0}, {-20, -40}, {-2, -40}}, color = {0, 0, 127}));
  connect(switch.y, thetaPll) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(hysteresis1.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{-19, -80}, {10, -80}, {10, -52}}, color = {255, 0, 255}));
  connect(gain.y, hysteresis1.u) annotation(
    Line(points = {{-58, 60}, {-50, 60}, {-50, -80}, {-42, -80}}, color = {0, 0, 127}));
  connect(UWTPu, gain.u) annotation(
    Line(points = {{-120, 60}, {-82, 60}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch.u2) annotation(
    Line(points = {{22, 60}, {50, 60}, {50, 0}, {58, 0}}, color = {255, 0, 255}));
  connect(gain.y, hysteresis.u) annotation(
    Line(points = {{-58, 60}, {-2, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {8, -9}, extent = {{-78, 57}, {66, -39}}, textString = "PLL")}));
end PLL;
