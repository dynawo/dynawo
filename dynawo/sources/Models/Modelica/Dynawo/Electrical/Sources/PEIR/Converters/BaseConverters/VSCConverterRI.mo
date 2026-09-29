within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model VSCConverterRI "VSC in RI with first-order lag"

  // Parameter
  parameter Types.Time tVSC "VSC time response / filter time constant in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput urConvRefPu(start = UrConv0Pu) "Converter real-axis voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uiConvRefPu(start = UiConv0Pu) "Converter imag-axis voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-112, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput urConvPu(start = UrConv0Pu) "Converter real-axis voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uiConvPu(start = UiConv0Pu) "Converter imag-axis voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {108, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  // First Order lag for VSC
  Modelica.Blocks.Continuous.FirstOrder firstOrderre(T = tVSC, y_start = UrConv0Pu) annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrderim(T = tVSC, y_start = UiConv0Pu) annotation(
    Placement(transformation(origin = {-2, -40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit UrConv0Pu "Initial real-axis converter voltage in pu (base UNom)";
  parameter Types.PerUnit UiConv0Pu "Initial imag-axis converter voltage in pu (base UNom)";

equation
  connect(urConvRefPu, firstOrderre.u) annotation(
    Line(points = {{-110, 40}, {-12, 40}}, color = {0, 0, 127}));
  connect(firstOrderre.y, urConvPu) annotation(
    Line(points = {{11, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(uiConvRefPu, firstOrderim.u) annotation(
    Line(points = {{-112, -40}, {-14, -40}}, color = {0, 0, 127}));
  connect(firstOrderim.y, uiConvPu) annotation(
    Line(points = {{9, -40}, {108, -40}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-60, 30}, {60, -30}}, textString = "VSC RI", lineColor = {0, 0, 0})}),
    Documentation(info = "<html>
<h4>VSC with first-order lag (RI coordinates, per-unit) &ndash; GFL plant</h4>

<p>Average-value model of the voltage-source converter (VSC). The converter voltage follows its reference through a
first-order lag, which represents the finite response / modulation delay of the converter.</p>

<h4>Equations</h4>
<p>For each axis (real and imaginary):</p>
<pre>
  urConvPu = urConvRefPu / (1 + s*tVSC)
  uiConvPu = uiConvRefPu / (1 + s*tVSC)
</pre>
<p>i.e. <code>tVSC * der(uConvPu) = uConvRefPu - uConvPu</code> on each axis, with unity gain.</p>

<h4>Inputs</h4>
<ul>
  <li><code>urConvRefPu</code>, <code>uiConvRefPu</code>: converter voltage reference, real and imaginary parts, in pu (base UNom), from the control.</li>
</ul>

<h4>Outputs</h4>
<ul>
  <li><code>urConvPu</code>, <code>uiConvPu</code>: converter voltage, real and imaginary parts, in pu (base UNom), applied to the filter.</li>
</ul>

<h4>Parameters</h4>
<ul>
  <li><code>tVSC</code>: VSC response time constant in s.</li>
</ul>

<h4>Initialization</h4>
<p>The lag outputs are initialized to <code>UrConv0Pu</code>, <code>UiConv0Pu</code> (pu, base UNom). </p>

</html>"));
end VSCConverterRI;
