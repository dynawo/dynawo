within Dynawo.Electrical.Events;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model LineFault "AC power line with fault - PI models"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  //Line connectors
  Dynawo.Connectors.ACPower terminal1 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Fault connectors
  Dynawo.Connectors.BPin lineFault(value(start = false)) "True when the fault is ongoing, false otherwise";
  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(extent = {{0, 0}, {0, 0}}, rotation = 0)));

  //Line parameters
  parameter Types.PerUnit RPu "Line resistance in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Line reactance in pu (base SnRef, UNom)";
  parameter Types.PerUnit GPu "Line half-conductance in pu (base SnRef, UNom)";
  parameter Types.PerUnit BPu "Line half-susceptance in pu (base SnRef, UNom)";

  //Fault parameters
  parameter Types.PerUnit D "Distance between terminal 1 and the fault as a fraction of line length";
  parameter Types.PerUnit RFaultPu "Fault resistance in pu (base SnRef, UNom)";
  parameter Types.PerUnit XFaultPu "Fault reactance in pu (base SnRef, UNom)";
  parameter Types.Time tBegin "Time when the fault begins in s";
  parameter Types.Time tEnd "Time when the fault ends in s";

  final parameter Types.ComplexImpedancePu ZFaultPu(re = RFaultPu, im = XFaultPu) "Fault impedance in pu (base SnRef, UNom)";

  // Output variables
  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";

  Dynawo.Electrical.Lines.Line line1(RPu = D * RPu, XPu = D * XPu, GPu = D * GPu, BPu = D * BPu);
  Dynawo.Electrical.Lines.Line line2(RPu = (1 - D) * RPu, XPu = (1 - D) * XPu, GPu = (1 - D) * GPu, BPu = (1 - D) * BPu);

equation
  line1.switchOffSignal1.value = switchOffSignal1.value;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = switchOffSignal1.value;
  line2.switchOffSignal2.value = false;

  when time >= tEnd then
    Timeline.logEvent1(TimelineKeys.LineFaultEnd);
    lineFault.value = false;
  elsewhen time >= tBegin then
    Timeline.logEvent1(TimelineKeys.LineFaultBegin);
    lineFault.value = true;
  end when;

  if lineFault.value or switchOffSignal1.value then
    terminal.V = ZFaultPu * terminal.i;
  else
    terminal.i = Complex(0);
  end if;

  P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
  Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
  P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
  Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

  connect(terminal1, line1.terminal1);
  connect(line1.terminal2, line2.terminal1);
  connect(line2.terminal2, terminal2);
  connect(terminal, line1.terminal2);

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>
The LineFault model is a juxtaposition of two classical Pi-line models with a possible fault between them. The equivalent circuit and conventions are as follows:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">            I1                   (</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">terminal)</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                      I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">(terminal1) --&gt;-------D*(R+jX)-------*-------(1-D)*(R+jX)--</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">-----</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |          |           </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">|              </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">|</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                 D*(G+jB)   </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">D*(G+jB)  </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">(1-</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">D)*(G+jB)   </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">(1-</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">D)*(G+jB)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |          |           </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">|              </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">|</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                   ---        ---         </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">---            </span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">---</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\"><br></span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">
</span><p><span style=\"font-family: -webkit-standard; white-space: normal;\">Since the impedances are in series, the total impedance is their sum : R+jX.</span></p><p><span style=\"font-family: -webkit-standard; white-space: normal;\">Since the admittances are in parallel, the total admittance is their sum : G+jB.&nbsp;</span></p><!--EndFragment--></pre></div><div><div><pre style=\"text-align: center; margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div></div></body></html>"),
  Icon(graphics = {Polygon(origin = {0, -57}, fillPattern = FillPattern.Solid, points = {{0, 45}, {-6, 5}, {20, 5}, {0, -45}, {6, -5}, {-20, -5}, {0, 45}, {0, 45}})}));
end LineFault;
