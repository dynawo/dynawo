within Dynawo.Electrical.Controls.PLL;

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

model PLL "Phase-Locked Loop"

  //Parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency of the system in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = SystemBase.omegaRef0Pu) "Measured frequency in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput phi(start = Modelica.ComplexMath.arg(u0Pu)) "Voltage phase at PCC in rad" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(y_start = Modelica.ComplexMath.arg(u0Pu), k = SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = uPu.im * cos(phi) - uPu.re * sin(phi)) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-50, -15}, {50, 15}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Ki, outMax = OmegaMaxPu - SystemBase.omegaRef0Pu, outMin = SystemBase.omegaRef0Pu - OmegaMinPu, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at PCC in pu (base UNom)";

equation
  connect(realExpression.y, limIntegrator.u) annotation(
    Line(points = {{-34, 0}, {-20, 0}, {-20, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(realExpression.y, gain.u) annotation(
    Line(points = {{-34, 0}, {-20, 0}, {-20, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{22, 20}, {40, 20}, {40, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{22, -20}, {40, -20}, {40, -6}, {58, -6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{82, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{82, 0}, {100, 0}, {100, -54}, {118, -54}}, color = {0, 0, 127}));
  connect(add2.y, omegaPLLPu) annotation(
    Line(points = {{142, -60}, {170, -60}}, color = {0, 0, 127}));
  connect(integrator.y, phi) annotation(
    Line(points = {{142, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu, add2.u2) annotation(
    Line(points = {{-170, -60}, {100, -60}, {100, -66}, {118, -66}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> The PLL calculates the frequency of the grid voltage by synchronizing the internal phase angle with measured voltage phasor. q-component of internal voltage phasor is therefore controlled to be zero. </p>

<p> Following relationship is used to calculate internal voltage phasor q-component: </p>
<pre>   uqPu = uiPu * cos(phi) - urPu * sin(phi);
</pre>

<p> If uqPu is zero, the internal phasor is locked with the measured phasor and rotates with the same frequency.</p>

</body></html>"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLL"), Text(origin = {127, -69}, extent = {{-23, 13}, {49, -25}}, textString = "omegaPLLPu"), Text(origin = {-155, -75}, extent = {{-31, 17}, {37, -19}}, textString = "omegaRefPu"), Text(origin = {-153, 87}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {129, 89}, extent = {{-23, -4}, {7, -19}}, textString = "phi")}, coordinateSystem(initialScale = 0.1)));
end PLL;
