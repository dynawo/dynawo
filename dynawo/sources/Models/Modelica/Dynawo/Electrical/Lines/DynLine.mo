within Dynawo.Electrical.Lines;

model DynLine "AC dynamic power line model"
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
  /*
    Equivalent circuit and conventions:

                 I1                  I2
     (terminal1) -->-------R+jX-------<-- (terminal2)

  */
  extends Electrical.Controls.Basics.SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Connectors.ACPower terminal1 annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2 annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.PerUnit RPu "Resistance in pu (base SnRef)";
  parameter Types.PerUnit LPu "Inductance in pu (base SnRef)";

  Types.PerUnit IModulePu "Module of the current flowing through the line";
  Modelica.Blocks.Interfaces.RealOutput didtModulePu "Rate of change of the current module" annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  if running then
    LPu * der(terminal1.i.re) + RPu * terminal1.i.re = terminal1.V.re - terminal2.V.re;
    LPu * der(terminal1.i.im) + RPu * terminal1.i.im = terminal1.V.im - terminal2.V.im;
    terminal2.i = - terminal1.i;
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

  IModulePu = sqrt(terminal1.i.re^2 + terminal1.i.im^2 + 1e-8);
  didtModulePu = der(IModulePu);

  annotation(
    preferredView = "text",
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
