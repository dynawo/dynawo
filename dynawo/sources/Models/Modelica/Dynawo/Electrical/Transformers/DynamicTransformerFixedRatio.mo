within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DynamicTransformerFixedRatio "Two winding transformer with a fixed ratio considering the dynamics of the inductance and the capacitances "

/* Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/

  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffTransformer;
  extends AdditionalIcons.Transformer;

  input Types.AngularVelocityPu omegaPu(start = SystemBase.omega0Pu) "Grid frequency in pu (base omegaNom) ";
  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ComplexVoltagePu u10Pu "Start value of the complex voltage on side 1 (base UNom) ";
  parameter Types.ComplexVoltagePu u20Pu "Start value of the complex voltage on side 2 (base Unom) ";
  parameter Types.ComplexCurrentPu i10Pu "Start value of the complex current on side 1 in pu (base SnRef, UNom)(receptor convention) ";
  parameter Types.ComplexCurrentPu i20Pu "Start value of the complex current on side 2 in pu (base SnRef, UNom)(receptor convention)";
  parameter Types.PerUnit rTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RPu "Resistance in pu (base SnRef, UNom) ";
  parameter Types.PerUnit LPu "Inductance in pu (base SnRef, UNom, omegaNom)";
  parameter Types.PerUnit GPu "Conductance in pu (base SnRef, UNom)";
  parameter Types.PerUnit CPu "Capacitance in pu (base SnRef, UNom, omegaNom)";

equation

  if (running.value) then
    rTfoPu * rTfoPu * terminal1.V.re = rTfoPu * terminal2.V.re + RPu * terminal1.i.re + LPu * der(terminal1.i.re / SystemBase.omegaNom) - LPu * omegaPu * terminal1.i.im;
    rTfoPu * rTfoPu * terminal1.V.im = rTfoPu * terminal2.V.im + RPu * terminal1.i.im + LPu * der(terminal1.i.im / SystemBase.omegaNom) + LPu * omegaPu * terminal1.i.re;
    terminal1.i.re = rTfoPu * (GPu * terminal2.V.re + CPu * der(terminal2.V.re / SystemBase.omegaNom) - CPu * omegaPu * terminal2.V.im - terminal2.i.re);
    terminal1.i.im = rTfoPu * (GPu * terminal2.V.im + CPu * der(terminal2.V.im / SystemBase.omegaNom) + CPu * omegaPu * terminal2.V.re - terminal2.i.im);
  else
    terminal1.i = Complex (0);
    terminal2.i = Complex (0);
  end if;

annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body>This fixed ratio transformer considerating the dynamics of the inductance and the capacitance has the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo----R+jX-------&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)                   |      (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                                |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               ---</span><!--EndFragment--></pre></div><div><br></div></body></html>"));
end DynamicTransformerFixedRatio;
