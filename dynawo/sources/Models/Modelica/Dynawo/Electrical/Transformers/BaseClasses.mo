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

package BaseClasses
  extends Icons.BasesPackage;

record TransformerParameters "Classical transformer parameters"

  parameter Types.PerUnit RPu "Resistance of the generator transformer in p.u (base U2Nom, SnRef)";
  parameter Types.PerUnit BPu "Susceptance of the generator transformer in p.u (base U2Nom, SnRef)";
  parameter Types.PerUnit XPu "Reactance of the generator transformer in p.u (base U2Nom, SnRef)";
  parameter Types.PerUnit GPu "Conductance of the generator transformer in p.u (base U2Nom, SnRef)";

  final parameter Types.ComplexImpedancePu ZPu = Complex(RPu, XPu) "Impedance in p.u (base U2Nom, SnRef)";
  final parameter Types.ComplexAdmittancePu YPu = Complex(GPu, BPu) "Admittance in p.u (base U2Nom, SnRef)";

annotation(preferredView = "text");
end TransformerParameters;


partial model BaseTransformer "Base model for transformer"

/*
  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffTransformer;

equation
  if (running.value) then
    rTfoPu * rTfoPu * terminal1.V = rTfoPu * terminal2.V + ZPu * terminal1.i;
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);
  else
    terminal1.i = Complex (0);
    terminal2.i = Complex (0);
  end if;

annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body>The transformer has the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo----R+jX-------&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)                   |      (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                                |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               ---</span><!--EndFragment--></pre></div><div><br></div></body></html>"));
end BaseTransformer;


annotation(preferredView = "text");
end BaseClasses;
