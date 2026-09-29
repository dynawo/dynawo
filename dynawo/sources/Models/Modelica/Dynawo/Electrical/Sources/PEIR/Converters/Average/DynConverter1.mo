within Dynawo.Electrical.Sources.PEIR.Converters.Average;

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

model DynConverter1 "Converter physical part comprising an AVM voltage source, a dynamic RLC Filter and a dynamic RL Transformer"

  // Nominal Parameters
  parameter Types.AngularVelocity omegaNom "Nominal angular frequency in rad/s";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // VSC delay parameter
  parameter Types.Time tVSC "VSC time response / filter time constant in s";

  // Filter parameters
  parameter Types.PerUnit RfPu "Filter series resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LfPu "Filter series inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CfPu "Filter shunt capacitance at right node in pu (base UNom, SNom)";

  // Transformer parameters
  parameter Types.PerUnit RPu "Transformer series resistance in pu (base UNom, SnRef)";
  parameter Types.PerUnit LPu "Transformer series inductance in pu (base UNom, SnRef)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Electrical frequency from PLL in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uiConvRefPu(start = UiConv0Pu) "Imag-axis converter voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput urConvRefPu(start = UrConv0Pu) "Real-axis converter voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));

  // Output variables
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iConvPu(re(start = IrConv0Pu), im(start = IiConv0Pu)) "Complex current from converter into filter in pu (base UNom, SNom)"annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uFiltPu(re(start = UrFilter0Pu), im(start = UiFilter0Pu)) "Complex voltage at filter capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.VSCConverterRI vSCdelay(UiConv0Pu = UiConv0Pu, UrConv0Pu = UrConv0Pu, tVSC = tVSC) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.DynRLCFilterRI2 dynRLCFilter(CfPu = CfPu, LfPu = LfPu, RfPu = RfPu, SNom = SNom, IiConv0Pu = IiConv0Pu, IrConv0Pu = IrConv0Pu, IrPcc0Pu = IrPcc0Pu*SystemBase.SnRef/SNom, IiPcc0Pu = IiPcc0Pu*SystemBase.SnRef/SNom, omegaNom = omegaNom, Omega0Pu = Omega0Pu, UiConv0Pu = UiConv0Pu, UrConv0Pu = UrConv0Pu, UiFilter0Pu = UiFilter0Pu, UrFilter0Pu = UrFilter0Pu) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters.DynRLTransformerRI2 Trafo(IiPcc0Pu = IiPcc0Pu, IrPcc0Pu = IrPcc0Pu, LPu = LPu, Omega0Pu = Omega0Pu, RPu = RPu) annotation(
    Placement(transformation(origin = {59, 0}, extent = {{-20, -20}, {20, 20}})));
  Connectors.ACPower terminal annotation(
    Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit IiConv0Pu "Initial imag-axis current from converter into filter in pu (base UNom, SNom)";
  parameter Types.PerUnit IiPcc0Pu "Initial imag-axis current injected into the grid in pu (base UNom, SnRef) (generator convention)";
  parameter Types.PerUnit IrConv0Pu "Initial real-axis current from converter into filter in pu (base UNom, SNom)";
  parameter Types.PerUnit IrPcc0Pu "Initial real-axis current injected into the grid in pu (base UNom, SnRef) (generator convention)";
  parameter Types.PerUnit Omega0Pu "Initial electrical frequency in pu (base omegaNom)";
  parameter Types.PerUnit UiConv0Pu "Initial imag-axis converter voltage in pu (base UNom)";
  parameter Types.PerUnit UiFilter0Pu "Initial imag-axis filter capacitor voltage in pu (base UNom)";
  parameter Types.PerUnit UrConv0Pu "Initial real-axis converter voltage in pu (base UNom)";
  parameter Types.PerUnit UrFilter0Pu "Initial real-axis filter capacitor voltage in pu (base UNom)";

equation
  connect(Trafo.terminal2, terminal) annotation(
    Line(points = {{79, 0}, {102, 0}}, color = {0, 0, 255}));
  connect(dynRLCFilter.terminalFilter, Trafo.terminal1) annotation(
    Line(points = {{20, 0}, {39, 0}}, color = {0, 0, 255}));
  connect(urConvRefPu, vSCdelay.urConvRefPu) annotation(
    Line(points = {{-110, 20}, {-90, 20}, {-90, 8}, {-82, 8}}, color = {0, 0, 127}));
  connect(uiConvRefPu, vSCdelay.uiConvRefPu) annotation(
    Line(points = {{-110, -20}, {-90, -20}, {-90, -8}, {-82, -8}}, color = {0, 0, 127}));
  connect(vSCdelay.urConvPu, dynRLCFilter.urConvPu) annotation(
    Line(points = {{-38, 8}, {-22, 8}}, color = {0, 0, 127}));
  connect(vSCdelay.uiConvPu, dynRLCFilter.uiConvPu) annotation(
    Line(points = {{-38, -8}, {-22, -8}}, color = {0, 0, 127}));
  connect(omegaPu, dynRLCFilter.omegaPu) annotation(
    Line(points = {{-110, -60}, {-12, -60}, {-12, -22}}, color = {0, 0, 127}));
  connect(omegaPu, Trafo.omegaPu) annotation(
    Line(points = {{-110, -60}, {59, -60}, {59, -22}}, color = {0, 0, 127}));
  connect(dynRLCFilter.iConvPu, iConvPu) annotation(
    Line(points = {{0, -22}, {0, -80}, {110, -80}}, color = {85, 170, 255}));
  connect(dynRLCFilter.uFiltPu, uFiltPu) annotation(
    Line(points = {{8, -22}, {8, -40}, {110, -40}}, color = {85, 170, 255}));

  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-60, 40}, {60, -40}}, textString = "Converter")}),
    Documentation(info = "<html>
<h4>Converter physical part (RI coordinates, per-unit) &ndash; GFL plant</h4>

<p>Physical (electrical) part of the grid-following converter. From the converter to the grid, it chains:</p>
<ol>
  <li><code>vSCdelay</code> (<code>VSCConverterRI</code>): average-value voltage source with a first-order lag <code>tVSC</code>
      on the voltage reference;</li>
  <li><code>dynRLCFilter</code> (<code>DynRLCFilterRI2</code>): dynamic output filter, series <code>RfPu</code>, <code>LfPu</code>
      and shunt <code>CfPu</code>;</li>
  <li><code>Trafo</code> (<code>DynRLTransformerRI2</code>): dynamic RL branch <code>RPu</code>, <code>LPu</code> representing the
      transformer (LV + HV) / equivalent impedance up to <code>terminal</code>.</li>
</ol>

<h4>Equivalent circuit</h4>
<pre>
  uConvRefPu          uConvPu, iConvPu              uFiltPu, iPccPu                   -iPccPu, uPccPu
  ---&gt; [ VSC ] ---&gt;--- RfPu + j*omegaPu*LfPu ---+---&gt;--- RPu + j*omegaPu*LPu ---&lt;--- (terminal)
       1/(1+s*tVSC)                              |
                                          j*omegaPu*CfPu
                                                 |
                                                ---
       |&lt;------- filter: base UNom, SNom -------&gt;|&lt;---- transformer: base UNom, SnRef ----&gt;|
</pre>
<p>The arrows give the positive direction of the currents. At <code>terminal</code>, the current entering the plant
(receptor convention) is <code>terminal.i = -iPccPu</code>.</p>

<h4>Inputs</h4>
<ul>
  <li><code>urConvRefPu</code>, <code>uiConvRefPu</code>: converter voltage reference in pu (base UNom), from the control;</li>
  <li><code>omegaPu</code>: electrical frequency in pu (base omegaNom), from the PLL. It is used by both the filter and the transformer.</li>
</ul>

<h4>Outputs</h4>
<ul>
  <li><code>iConvPu</code>: current from the converter into the filter in pu (base UNom, SNom);</li>
  <li><code>uFiltPu</code>: filter capacitor voltage in pu (base UNom).</li>
</ul>
<p>Both outputs are sent to the measurement block.</p>

<h4>Connector</h4>
<ul>
  <li><code>terminal</code>: plant AC terminal (PCC side), Dynawo <code>ACPower</code> receptor convention, base SnRef.</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>Filter parameters (<code>RfPu</code>, <code>LfPu</code>, <code>CfPu</code>) and converter-side currents
      (<code>iConvPu</code>, <code>IrConv0Pu</code>, <code>IiConv0Pu</code>) are on the machine base (UNom, SNom).</li>
  <li>Transformer parameters (<code>RPu</code>, <code>LPu</code>) and PCC current start values
      (<code>IrPcc0Pu</code>, <code>IiPcc0Pu</code>) are on the system base (UNom, SnRef). The upper-level model converts them
      from the machine base.</li>
  <li>The PCC current start values are converted to SNom for the filter: <code>IrPcc0Pu*SnRef/SNom</code>, <code>IiPcc0Pu*SnRef/SNom</code>.</li>
  <li>Voltages are in pu (base UNom).</li>
  <li>The filter uses the parameter <code>omegaNom</code> and the transformer uses <code>SystemBase.omegaNom</code>. They must be equal.</li>
</ul>

<h4>Sign conventions</h4>
<ul>
  <li><code>iConvPu</code> &gt; 0: current flowing from the converter into the filter.</li>
  <li><code>IrPcc0Pu</code>, <code>IiPcc0Pu</code>: current injected into the grid (generator convention).</li>
  <li><code>terminal.i</code>: positive when entering the plant (receptor convention), so <code>terminal.i = -iPccPu</code>.</li>
</ul>

<h4>Initialization</h4>
<ul>
  <li><code>UrConv0Pu</code>, <code>UiConv0Pu</code>: converter voltage in pu (base UNom);</li>
  <li><code>UrFilter0Pu</code>, <code>UiFilter0Pu</code>: filter capacitor voltage in pu (base UNom);</li>
  <li><code>IrConv0Pu</code>, <code>IiConv0Pu</code>: converter current in pu (base UNom, SNom);</li>
  <li><code>IrPcc0Pu</code>, <code>IiPcc0Pu</code>: grid current in pu (base UNom, SnRef), generator convention;</li>
  <li><code>Omega0Pu</code>: frequency in pu (base omegaNom).</li>
</ul>
<p>All start values are computed by the upper-level model (<code>DynGFLPlant</code>) and passed down to the sub-models.</p>
</html>"));
end DynConverter1;
