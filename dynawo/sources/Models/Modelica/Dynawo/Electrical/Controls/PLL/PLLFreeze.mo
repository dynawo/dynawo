within Dynawo.Electrical.Controls.PLL;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PLLFreeze "Phase-Locked Loop whose angle can be frozen"
  import Modelica;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  //Parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency of the system in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = SystemBase.omegaRef0Pu) "Measured frequency in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput phi(start = Modelica.ComplexMath.arg(u0Pu)) "Voltage phase at PCC in rad" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(y_start = Modelica.ComplexMath.arg(u0Pu), k = SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {70, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = uPu.im*cos(phi) - uPu.re*sin(phi)) annotation(
    Placement(visible = true, transformation(origin = {-85, 0}, extent = {{-45, -15}, {45, 15}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Ki, outMax = OmegaMaxPu - SystemBase.omegaRef0Pu, outMin = SystemBase.omegaRef0Pu - OmegaMinPu, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {75, -8}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(visible = true, transformation(origin = {-150.5, -49.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at PCC in pu (base UNom)";

equation
  connect(add2.y, omegaPLLPu) annotation(
    Line(points = {{81, -84}, {170, -84}}, color = {0, 0, 127}));
  connect(omegaRefPu, add2.u2) annotation(
    Line(points = {{-150, -90}, {58, -90}, {58, -90}, {58, -90}}, color = {0, 0, 127}));
  connect(integrator.y, phi) annotation(
    Line(points = {{151, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(realExpression.y, limIntegrator.u) annotation(
    Line(points = {{-35, 0}, {-20, 0}, {-20, -20}, {-12, -20}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{11, -20}, {20, -20}, {20, -6}, {28, -6}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{51, 0}, {54, 0}, {54, -78}, {58, -78}}, color = {0, 0, 127}));
  connect(realExpression.y, gain.u) annotation(
    Line(points = {{-35, 0}, {-20, 0}, {-20, 20}, {-12, 20}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{11, 20}, {20, 20}, {20, 6}, {28, 6}}, color = {0, 0, 127}));
  connect(add1.y, switch1.u1) annotation(
    Line(points = {{51, 0}, {54, 0}, {54, 8}, {88, 8}}, color = {0, 0, 127}));
  connect(const.y, switch1.u3) annotation(
    Line(points = {{80.5, -8}, {87.5, -8}}, color = {0, 0, 127}));
  connect(freeze, switch1.u2) annotation(
    Line(points = {{-150, -49}, {60, -49}, {60, 0}, {88, 0}}, color = {255, 0, 255}));
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{111, 0}, {128, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> The PLL calculates the frequency of the grid voltage by synchronizing the internal phase angle with measured voltage phasor. q-component of internal voltage phasor is therefore controlled to be zero. </p>

<p> Following relationship is used to calculate internal voltage phasor q-component: </p>
<pre>   uqPu = uiPu * cos(phi) - urPu * sin(phi);
</pre>

<p> If uqPu is zero, the internal phasor is locked with the measured phasor and rotates with the same frequency.</p>

</body></html>"),
    Diagram(coordinateSystem(extent = {{-140, -100}, {160, 100}}, initialScale = 1, grid = {1, 1})),
    __OpenModelica_commandLineOptions = "",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLL"), Text(origin = {131, 71}, extent = {{-23, 13}, {49, -25}}, textString = "omegaPLLPu"), Text(origin = {-137, -41}, extent = {{-31, 17}, {37, -19}}, textString = "omegaRefPu"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {143, 39}, extent = {{-23, -4}, {7, -19}}, textString = "phi")}, coordinateSystem(initialScale = 0.1, extent = {{-100, -100}, {100, 100}})));
end PLLFreeze;
