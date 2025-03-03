within Dynawo.Electrical.Transformers.TransformersFixedTap;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model NetworkTransformer "Two windings transformer with a fixed ratio, same model as the Network one."

/* Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo------R+jX-----<-- U2,P2,Q2
  (terminal1)          |               (terminal2)
                      G+jB
                       |
                      ---
*/
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffTransformer;
  extends AdditionalIcons.Transformer;

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";

  Types.VoltageModulePu U1Pu "Voltage on side 1 in pu (base U1Nom)";
  Types.VoltageModulePu U2Pu "Voltage on side 2 in pu (base U2Nom)";

  Types.CurrentModulePu I1Pu "Current on side 1 in pu (base U1Nom, SnRef) (receptor convention)";
  Types.CurrentModulePu I2Pu "Current on side 2 in pu (base U2Nom, SnRef) (receptor convention)";

  Types.CurrentModule ISide1 "Current on side 1 in A (receptor convention)";
  Types.CurrentModule ISide2 "Current on side 2 in A (receptor convention)";

  // Transformer start values
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 (base U1Nom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 (base U2Nom)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (base U2Nom, SnRef) (receptor convention)";

  parameter Types.VoltageModule RatedU1 "Rated voltage at terminal 1 in kV";
  parameter Types.VoltageModule RatedU2 "Rated voltage at terminal 2 in kV";
  parameter Types.VoltageModule U1Nom "Nominal voltage at terminal 1 in kV";
  parameter Types.VoltageModule U2Nom "Nominal voltage at terminal 2 in kV";

  final parameter Types.PerUnit rTfoPu = RatedU2 / RatedU1 * U1Nom / U2Nom "Transformation ratio in pu: U2/U1 in no load conditions";

  parameter Modelica.SIunits.Resistance R "Resistance of the transformer in ohm";
  parameter Modelica.SIunits.Reactance X "Reactance of the transformer in ohm";
  parameter Modelica.SIunits.Conductance G "Conductance of the transformer in S";
  parameter Modelica.SIunits.Susceptance B "Susceptance of the transformer in S";

  final parameter Modelica.SIunits.ComplexImpedance Z = Complex(R, X) "Impedance of the transformer";
  final parameter Modelica.SIunits.ComplexAdmittance Y = Complex(G, B) "Admittance of the transformer";

  final parameter Types.ComplexImpedancePu ZPu = Complex(R / (U2Nom * U2Nom / SystemBase.SnRef), X / (U2Nom * U2Nom / SystemBase.SnRef)) "Impedance in pu (base U2Nom, SnRef)";
  final parameter Types.ComplexAdmittancePu YPu = Complex(G * (U2Nom * U2Nom / SystemBase.SnRef), B * (U2Nom * U2Nom / SystemBase.SnRef)) "Admittance in pu (base U2Nom, SnRef)";

  final parameter Real factorPuToASide1 = 1000. * SystemBase.SnRef / (sqrt(3.) * U1Nom);
  final parameter Real factorPuToASide2 = 1000. * SystemBase.SnRef / (sqrt(3.) * U2Nom);

equation
  if (running.value) then
    terminal2.V = rTfoPu * terminal1.V + ZPu * terminal2.i;
    terminal1.i = rTfoPu * rTfoPu * YPu * terminal1.V - rTfoPu * terminal2.i;
    // Equations can also be rewritten with the following
    // terminal1.i = rTfoPu * rTfoPu * (1 / ZPu + YPu) * terminal1.V - rTfoPu * terminal2.V / ZPu;
    // terminal2.i = - rTfoPu * terminal1.V / ZPu + terminal2.V / ZPu;
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

  P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
  Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
  P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
  Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

  if (running.value) then
    U1Pu = ComplexMath.'abs'(terminal1.V);
    U2Pu = ComplexMath.'abs'(terminal2.V);
    I1Pu = ComplexMath.'abs'(terminal1.i);
    I2Pu = ComplexMath.'abs'(terminal2.i);
  else
    U1Pu = 0;
    U2Pu = 0;
    I1Pu = 0;
    I2Pu = 0;
  end if;

  ISide1 = factorPuToASide1 * I1Pu;
  ISide2 = factorPuToASide2 * I2Pu;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The transformer has the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo-------R+jX---&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)           |             (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                       G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                        |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                       ---</span><!--EndFragment--></pre></div><div><br></div></body></html>"));
end NetworkTransformer;
