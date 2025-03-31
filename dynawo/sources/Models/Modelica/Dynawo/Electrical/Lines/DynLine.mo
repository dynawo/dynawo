within Dynawo.Electrical.Lines;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DynLine "AC power line - Dynamic PI model"

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------R+jX-------<-- (terminal2)

*/
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Dynawo.Connectors.ACPower terminal1(V(re(start = u01Pu.re), im(start = u01Pu.im)), i(re(start = i01Pu.re), im(start = i01Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u02Pu.re), im(start = u02Pu.im)), i(re(start = i02Pu.re), im(start = i02Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin omegaPu(value(start = SystemBase.omegaRef0Pu));

  parameter Types.PerUnit RPu "Resistance in pu (base SnRef)";
  parameter Types.PerUnit LPu "Inductance in pu (base SnRef)";

  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";

  parameter Types.VoltageModulePu U01Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase01 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P01Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q01Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u01Pu = ComplexMath.fromPolar(U01Pu, UPhase01) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i01Pu = ComplexMath.conj(Complex(P01Pu, Q01Pu) / u01Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";

  parameter Types.VoltageModulePu U02Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase02 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P02Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q02Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u02Pu = ComplexMath.fromPolar(U02Pu, UPhase02) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i02Pu = ComplexMath.conj(Complex(P02Pu, Q02Pu) / u02Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";


equation
  LPu / SystemBase.omegaNom * der(terminal1.i.re) + RPu * terminal1.i.re - omegaPu.value * LPu * terminal1.i.im = terminal1.V.re - terminal2.V.re;
  LPu / SystemBase.omegaNom * der(terminal1.i.im) + RPu * terminal1.i.im + omegaPu.value * LPu * terminal1.i.re = terminal1.V.im - terminal2.V.im;
  terminal2.i = - terminal1.i;

  P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
  Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
  P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
  Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
The line model is a classical Pi-line mode with the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1                  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">   (terminal1) --&gt;-------R+jX-------&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                  G+jB         G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                   ---         ---</span><!--EndFragment--></pre></div><div><div><pre style=\"text-align: center; margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div></div></body></html>"));
end DynLine;
