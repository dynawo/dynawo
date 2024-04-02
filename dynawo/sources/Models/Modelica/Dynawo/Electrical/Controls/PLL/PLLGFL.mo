within Dynawo.Electrical.Controls.PLL;

model PLLGFL "Phase-Locked Loop"
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
  //Parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit Vpllb "PLL Hysteresis lower limit";
  parameter Types.PerUnit Vpllu "PLL Hysteresis upper limit";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency of the system in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = SystemBase.omegaRef0Pu) "Measured frequency in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput phi(start = Modelica.ComplexMath.arg(u0Pu)) "Voltage phase at PCC in rad" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Modelica.ComplexMath.arg(u0Pu), k = SystemBase.omegaNom) annotation(
    Placement(transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = 1) annotation(
    Placement(transformation(origin = {98, -84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = uPu.im*cos(phi) - uPu.re*sin(phi)) annotation(
    Placement(transformation(origin = {-92, 0}, extent = {{-45, -15}, {45, 15}})));
  Modelica.Blocks.Continuous.Integrator integrator1(k = Ki, y_start = 0) annotation(
    Placement(transformation(origin = {38, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = 1) annotation(
    Placement(transformation(origin = {68, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(transformation(origin = {38, 20}, extent = {{-10, -10}, {10, 10}})));
  //Initial parameter
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at PCC in pu (base UNom)";
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow = Vpllb, uHigh = Vpllu) annotation(
    Placement(transformation(origin = {-14, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = (uPu.re^2 + uPu.im^2)^0.5) annotation(
    Placement(transformation(origin = {-92, -44}, extent = {{-45, -15}, {45, 15}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-60, -22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {-6, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(add2.y, omegaPLLPu) annotation(
    Line(points = {{109, -84}, {150, -84}}, color = {0, 0, 127}));
  connect(omegaRefPu, add2.u2) annotation(
    Line(points = {{-150, -90}, {86, -90}}, color = {0, 0, 127}));
  connect(integrator.y, phi) annotation(
    Line(points = {{109, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{79, 0}, {86, 0}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{79, 0}, {82, 0}, {82, -78}, {86, -78}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{49, 20}, {49, 6}, {56, 6}}, color = {0, 0, 127}));
  connect(realExpression2.y, hysteresis.u) annotation(
    Line(points = {{-42.5, -44}, {-26, -44}}, color = {0, 0, 127}));
  connect(const.y, switch1.u3) annotation(
    Line(points = {{-49, -22}, {-39, -22}, {-39, -8}, {-18, -8}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch1.u2) annotation(
    Line(points = {{-3, -44}, {0, -44}, {0, -18}, {-28, -18}, {-28, 0}, {-18, 0}}, color = {255, 0, 255}));
  connect(realExpression.y, switch1.u1) annotation(
    Line(points = {{-42, 0}, {-33, 0}, {-33, 8}, {-18, 8}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{5, 0}, {9, 0}, {9, 20}, {26, 20}}, color = {0, 0, 127}));
  connect(integrator1.y, add1.u2) annotation(
    Line(points = {{49, -18}, {49, -6}, {56, -6}}, color = {0, 0, 127}));
  connect(switch1.y, integrator1.u) annotation(
    Line(points = {{5, 0}, {5, -0.25}, {9, -0.25}, {9, 0.5}, {8, 0.5}, {8, 0}, {9, 0}, {9, -18}, {26, -18}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> The PLL calculates the frequency of the grid voltage by synchronizing the internal phase angle with measured voltage phasor. q-component of internal voltage phasor is therefore controlled to be zero. </p>

<p> Following relationship is used to calculate internal voltage phasor q-component: </p>
<pre>   uqPu = uiPu * cos(phi) - urPu * sin(phi);
</pre>

<p> If uqPu is zero, the internal phasor is locked with the measured phasor and rotates with the same frequency.</p>

</body></html>"),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}}, initialScale = 1, grid = {1, 1})),
    __OpenModelica_commandLineOptions = "",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLLGFL"), Text(origin = {131, 71}, extent = {{-23, 13}, {49, -25}}, textString = "omegaPLLPu"), Text(origin = {-137, -41}, extent = {{-31, 17}, {37, -19}}, textString = "omegaRefPu"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {143, 39}, extent = {{-23, -4}, {7, -19}}, textString = "phi")}, coordinateSystem(initialScale = 0.1)));
end PLLGFL;
