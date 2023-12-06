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
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit omegaRef0;
  parameter Types.PerUnit omegaPLL0Pu;
  parameter Types.PerUnit thetaPLL0Pu;
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = omegaPLL0Pu) "Measured frequency in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {149, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-46, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-46, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {-16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {24, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sin sinPhi1 annotation(
    Placement(visible = true, transformation(origin = {-86, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Cos cosPhi1 annotation(
    Placement(visible = true, transformation(origin = {-85, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {-86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = Ki, y_start = omegaPLL0Pu) annotation(
    Placement(visible = true, transformation(origin = {22, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator( use_reset = false, y_start = thetaPLL0Pu) annotation(
    Placement(visible = true, transformation(origin = {111, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput thetaPLLPu(start = thetaPLL0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRef(start = omegaRef0) annotation(
    Placement(visible = true, transformation(origin = {-150, -85}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -49}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {77, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {43, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(uPu, complexToReal.u) annotation(
    Line(points = {{-150, 0}, {-98, 0}}, color = {85, 170, 255}));
  connect(product.y, add.u1) annotation(
    Line(points = {{-35, 40}, {-32, 40}, {-32, 6}, {-28, 6}}, color = {0, 0, 127}));
  connect(product1.y, add.u2) annotation(
    Line(points = {{-35, -40}, {-32, -40}, {-32, -6}, {-28, -6}}, color = {0, 0, 127}));
  connect(complexToReal.re, product.u2) annotation(
    Line(points = {{-74, 6}, {-66, 6}, {-66, 34}, {-58, 34}}, color = {0, 0, 127}));
  connect(complexToReal.im, product1.u1) annotation(
    Line(points = {{-74, -6}, {-66, -6}, {-66, -34}, {-58, -34}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-5, 0}, {4, 0}, {4, 20}, {12, 20}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{35, 20}, {44, 20}, {44, 6}, {52, 6}}, color = {0, 0, 127}));
  connect(add.y, integrator1.u) annotation(
    Line(points = {{-5, 0}, {4, 0}, {4, -12}, {10, -12}}, color = {0, 0, 127}));
  connect(integrator1.y, add1.u2) annotation(
    Line(points = {{33, -12}, {43, -12}, {43, -6}, {52, -6}}, color = {0, 0, 127}));
  connect(add1.y, omegaPLLPu) annotation(
    Line(points = {{75, 0}, {149, 0}}, color = {0, 0, 127}));
  connect(integrator.y, thetaPLLPu) annotation(
    Line(points = {{122, -52}, {150, -52}}, color = {0, 0, 127}));
  connect(integrator.y, sinPhi1.u) annotation(
    Line(points = {{122, -52}, {130, -52}, {130, 69}, {-110, 69}, {-110, 46}, {-98, 46}}, color = {0, 0, 127}));
  connect(integrator.y, cosPhi1.u) annotation(
    Line(points = {{122, -52}, {130, -52}, {130, -90}, {-110, -90}, {-110, -46}, {-97, -46}}, color = {0, 0, 127}));
  connect(sinPhi1.y, product.u1) annotation(
    Line(points = {{-75, 46}, {-58, 46}}, color = {0, 0, 127}));
  connect(cosPhi1.y, product1.u2) annotation(
    Line(points = {{-74, -46}, {-58, -46}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{86, -52}, {99, -52}}, color = {0, 0, 127}));
  connect(add1.y, gain1.u) annotation(
    Line(points = {{75, 0}, {90, 0}, {90, -34}, {14, -34}, {14, -52}, {31, -52}}, color = {0, 0, 127}));
  connect(omegaRef, feedback.u2) annotation(
    Line(points = {{-150, -85}, {77, -85}, {77, -60}}, color = {0, 0, 127}));
  connect(gain1.y, feedback.u1) annotation(
    Line(points = {{54, -52}, {69, -52}}, color = {0, 0, 127}));
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
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLLGFL"), Text(origin = {131, 71}, extent = {{-23, 13}, {49, -25}}, textString = "omegaPLLPu", fontSize = 16), Text(origin = {-141, -27}, extent = {{-31, 17}, {37, -19}}, textString = "omegaRef"), Text(origin = {-141, 79}, extent = {{3, -3}, {37, -19}}, textString = "uPu"), Text(origin = {129, -29}, extent = {{-23, 13}, {49, -25}}, textString = "thetaPLLPu", fontSize = 16)}, coordinateSystem(initialScale = 0.1, extent = {{-100, -100}, {100, 100}})));
end PLLGFL;
