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

model DynRLCFilterRI2 "RLC filter in RI coordinates in pu between a left port (VSC) and a right AC terminal (to network)"
    /*
    Equivalent circuit and conventions:

   uConvPu,iConvPu                         -iPccPu, uFiltPu
   (Converter) -->-------Rf+j*omegaPu*LfPu-------<-- (terminalFilter)
                                |
                            j*omegaPu*CfPu
                                |
    */

  // Nominal Parameters
  parameter Types.AngularVelocity omegaNom "Nominal angular frequency in rad/s";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Filter parameters
  parameter Types.PerUnit RfPu "Series resistance Rf in pu (base UNom, SNom)";
  parameter Types.PerUnit LfPu "Series inductance Lf in pu (base UNom, SNom)";
  parameter Types.PerUnit CfPu "Shunt capacitance Cf at right node in pu (base UNom, SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput urConvPu(start = UrConv0Pu) "Left-side real-axis voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uiConvPu(start = UiConv0Pu) "Left-side imag-axis voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Electrical frequency from PLL in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-111, -81}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variable
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iConvPu(re(start = IrConv0Pu), im(start = IiConv0Pu)) "Complex current from converter into filter in pu (base SNom, UNom)" annotation(
    Placement(transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uFiltPu "Complex voltage at filter capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Connectors.ACPower terminalFilter "Right node electrical terminal (to transformer / grid)" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));

  // Initial parameters
  parameter Types.PerUnit IiConv0Pu "Initial imag-axis inductor current from left into filter in pu (base UNom, SNom)";
  parameter Types.PerUnit IiPcc0Pu "Initial imag-axis current from right node to network in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IrConv0Pu "Initial real-axis inductor current from left into filter in pu (base UNom, SNom)";
  parameter Types.PerUnit IrPcc0Pu "Initial real-axis current from right node to network in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Omega0Pu "Initial electrical frequency in pu (base omegaNom)";
  parameter Types.PerUnit UiConv0Pu "Initial left-side imag-axis voltage in pu (base UNom)";
  parameter Types.PerUnit UiFilter0Pu "Initial imag-axis right-node voltage in pu (base UNom)";
  parameter Types.PerUnit UrConv0Pu "Initial left-side real-axis voltage in pu (base UNom)";
  parameter Types.PerUnit UrFilter0Pu "Initial real-axis right-node voltage in pu (base UNom)";

equation
  LfPu/omegaNom*der(iConvPu.re) = urConvPu - RfPu*iConvPu.re + omegaPu*LfPu*iConvPu.im - uFiltPu.re;
  LfPu/omegaNom*der(iConvPu.im) = uiConvPu - RfPu*iConvPu.im - omegaPu*LfPu*iConvPu.re - uFiltPu.im;
  CfPu/omegaNom*der(uFiltPu.re) = iConvPu.re + omegaPu*CfPu*uFiltPu.im - (-terminalFilter.i.re*SystemBase.SnRef/SNom);
  CfPu/omegaNom*der(uFiltPu.im) = iConvPu.im - omegaPu*CfPu*uFiltPu.re - (-terminalFilter.i.im*SystemBase.SnRef/SNom);
  uFiltPu = terminalFilter.V;

  annotation(
    Icon(graphics = {Line(origin = {0.292174, 0}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {-19.5757, 0.292221}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {10, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {40, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {40, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {70, 0}, points = {{-60, 0}, {-59, 6}, {-52, 14}, {-38, 14}, {-31, 6}, {-30, 0}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {139.367, 0.29217}, points = {{-100, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {68.0764, 39.1513}, rotation = 90, points = {{-64, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -25.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -29.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {68.3686, 11.1026}, rotation = 90, points = {{-76, 0}, {-40, 0}}, color = {0, 0, 255}), Line(origin = {157.19, -65.4192}, points = {{-100, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {155.19, -67.4192}, points = {{-94, 0}, {-80, 0}}, color = {0, 0, 255}), Line(origin = {151.19, -69.4192}, points = {{-86, 0}, {-80, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.01)),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Documentation(info = "<html>
<pre>
  uConvPu, iConvPu                        -iPccPu, uFiltPu
  (converter) --&gt;----- RfPu + j*omegaPu*LfPu -----&lt;-- (terminalFilter)
                                         |
                                  j*omegaPu*CfPu
                                         |
</pre>       iPccPu (base SNom) = -terminalFilter.i (base SnRef) * SnRef/SNom
<h4>RLC filter (RI coordinates, per-unit) &ndash; GFL plant</h4>

<p>Dynamic model of the converter-side output RLC filter, written in real/imaginary (RI) coordinates.
The filter sits between:</p>
<ul>
  <li>the <b>left side</b>: the voltage-source converter (VSC), whose voltage is given by the inputs
      <code>urConvPu</code>, <code>uiConvPu</code>;</li>
  <li>the <b>right node</b> (<code>terminalFilter</code>): the AC terminal connected to the transformer / grid.</li>
</ul>

<h4>Topology</h4>
<ul>
  <li>Series RL branch (<code>RfPu</code>, <code>LfPu</code>) between the left side and the right node;</li>
  <li>Shunt capacitor <code>CfPu</code> from the right node to ground.</li>
</ul>

<h4>Inputs</h4>
<ul>
  <li><code>urConvPu</code>, <code>uiConvPu</code>: converter (left-side) voltage, real and imaginary parts, in pu (base UNom);</li>
     <li><code>omegaPu</code>: electrical angular frequency in pu (base omegaNom), from the PLL.</li>
</ul>

<h4>State variables / outputs</h4>
<ul>
  <li><code>iConvPu</code> (<code>.re</code>, <code>.im</code>): inductor current, flowing from the converter into the filter, in pu (base SNom, UNom);</li>
  <li><code>uFiltPu</code> (<code>.re</code>, <code>.im</code>): right-node (capacitor) voltage, in pu (base UNom).
      It is equal to the terminal voltage <code>terminalFilter.V</code>.</li>
</ul>

<h4>Equations</h4>
<p>Series inductor (converter to right node):</p>
<pre>
  LfPu/omegaNom * der(iConvPu.re) = urConvPu - RfPu*iConvPu.re + omegaPu*LfPu*iConvPu.im - uFiltPu.re
  LfPu/omegaNom * der(iConvPu.im) = uiConvPu - RfPu*iConvPu.im - omegaPu*LfPu*iConvPu.re - uFiltPu.im
</pre>
<p>Shunt capacitor (right node):</p>
<pre>
  CfPu/omegaNom * der(uFiltPu.re) = iConvPu.re + omegaPu*CfPu*uFiltPu.im - iPccPu.re
  CfPu/omegaNom * der(uFiltPu.im) = iConvPu.im - omegaPu*CfPu*uFiltPu.re - iPccPu.im
</pre>
<p>with the current from the right node to the grid, converted to the machine base:</p>
<pre>
  iPccPu = -terminalFilter.i * SystemBase.SnRef / SNom
</pre>
<p>and the terminal voltage:</p>
<pre>
  uFiltPu = terminalFilter.V
</pre>

<h4>Units and base</h4>
<ul>
  <li>Filter parameters and internal variables are in per-unit on the machine base (<code>UNom</code>, <code>SNom</code>).</li>
  <li><code>terminalFilter.i</code> is expressed on the system base <code>SystemBase.SnRef</code>, hence the factor
      <code>SnRef/SNom</code>.</li>
  <li>Dynamics use the nominal angular frequency <code>omegaNom</code> as the time base.</li>
</ul>

<h4>Sign conventions</h4>
<ul>
  <li><code>iConvPu</code> &gt; 0: current flowing from the converter into the filter.</li>
  <li><code>terminalFilter.i</code> follows the Dynawo receptor (load) convention: positive when flowing <i>into</i> the terminal.</li>
  <li>The current from the right node to the grid is therefore <code>-terminalFilter.i</code> (positive from the filter node to the network),
      consistent with the initial values <code>IrPcc0Pu</code>, <code>IiPcc0Pu</code>.</li>
</ul>

   <h4>Initialization</h4>
   <ul>
     <li><code>IrConv0Pu</code>, <code>IiConv0Pu</code>: converter current in pu (base UNom, SNom);</li>
     <li><code>IrPcc0Pu</code>, <code>IiPcc0Pu</code>: current from the right node to the grid in pu (base UNom, SNom), generator convention;</li>
     <li><code>UrConv0Pu</code>, <code>UiConv0Pu</code>, <code>UrFilter0Pu</code>, <code>UiFilter0Pu</code>: voltages in pu (base UNom);</li>
     <li><code>Omega0Pu</code>: frequency in pu (base omegaNom).</li>
   </ul>
</html>"));
end DynRLCFilterRI2;
