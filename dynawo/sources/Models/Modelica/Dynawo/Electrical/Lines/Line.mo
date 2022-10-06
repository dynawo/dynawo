within Dynawo.Electrical.Lines;

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

model Line "AC power line - PI model"

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------R+jX-------<-- (terminal2)
                    |           |
                  G+jB         G+jB
                    |           |
                   ---         ---
*/
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Connectors.ACPower terminal1 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit RPu "Resistance in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance in pu (base SnRef)";
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef)";
  parameter Types.PerUnit BPu "Half-susceptance in pu (base SnRef)";

  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef)";
  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef)";

protected
  parameter Types.ComplexImpedancePu ZPu(re = RPu, im = XPu) "Line impedance";
  parameter Types.ComplexAdmittancePu YPu(re = GPu, im = BPu) "Line half-admittance";

equation
  if (running.value) then
    ZPu * (terminal2.i - YPu * terminal2.V) = terminal2.V - terminal1.V;
    ZPu * (terminal1.i - YPu * terminal1.V) = terminal1.V - terminal2.V;
  else
    terminal1.i = Complex (0);
    terminal2.i = Complex (0);
  end if;

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
end Line;
