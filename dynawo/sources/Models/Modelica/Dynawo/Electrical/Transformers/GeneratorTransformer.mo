within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GeneratorTransformer "Two winding transformer with a fixed ratio"

/*
  This transformer model is supposed to be used with its initialisation model GeneratorTransformer_INIT.
  It enables to initialize the generator model when the load-flow inputs are not known at the generator terminal but at the generator transformer terminal.
  Equivalent circuit and conventions:

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
  extends BaseClasses.TransformerParameters;
  extends AdditionalIcons.Transformer;

  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit rTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";

  // Transformer variables for display
  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P1GenPu "Active power on side 1 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu Q1GenPu "Reactive power on side 1 in pu (base SnRef) (generator convention)";
  Types.VoltageModulePu U1Pu "Voltage on side 1 in pu (base U1Nom)";

  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";
  Types.VoltageModulePu U2Pu "Voltage on side 2 in pu (base U2Nom)";

  // Transformer start values
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";

  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q20Pu "Start value of reactive power at terminal 2 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 (base U1Nom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 (base U2Nom)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (base U2Nom, SnRef) (receptor convention)";

equation
  if (running.value) then
    rTfoPu * rTfoPu * terminal1.V = rTfoPu * terminal2.V + ZPu * terminal1.i;
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);
  else
    terminal1.i = terminal2.i;
    terminal2.V = Complex (0);
  end if;

  if (running.value) then
    U1Pu = ComplexMath.'abs' (terminal1.V);
    P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
    P1GenPu = - P1Pu;
    Q1GenPu = - Q1Pu;
    U2Pu = ComplexMath.'abs' (terminal2.V);
    P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
    Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));
  else
    U1Pu = 0;
    P1Pu = 0;
    Q1Pu = 0;
    P1GenPu = 0;
    Q1GenPu = 0;
    U2Pu = 0;
    P2Pu = 0;
    Q2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
The transformer has the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo----R+jX-------&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)                   |      (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                                |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               ---</span><!--EndFragment--></pre></div><div><br></div>
This model enables to initialize a generator model when the load-flow inputs are not known at the generator terminal but at the generator transformer terminal.</body></html>"));
end GeneratorTransformer;
