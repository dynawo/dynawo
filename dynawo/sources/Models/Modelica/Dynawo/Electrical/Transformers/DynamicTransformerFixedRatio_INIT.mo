within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model DynamicTransformerFixedRatio_INIT

import Dynawo.Types;

  extends AdditionalIcons.Init;

  parameter Types.PerUnit rTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RPu "Resistance in pu (base SnRef, UNom) ";
  parameter Types.PerUnit LPu "Inductance in pu (base SnRef, UNom, omegaNom)";
  parameter Types.PerUnit GPu "Conductance in pu (base SnRef, UNom)";
  parameter Types.PerUnit CPu "Capacitance in pu (base SnRef, UNom, omegaNom)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of the complex voltage on side 1 (base UNom) ";
  parameter Types.ComplexVoltagePu u20Pu "Start value of the complex voltage on side 2 (base Unom) ";
  Types.ComplexCurrentPu i10Pu "Start value of the complex current on side 1 in pu (base SnRef, UNom)(receptor convention) ";
  Types.ComplexCurrentPu i20Pu "Start value of the complex current on side 2 in pu (base SnRef, UNom)(receptor convention)";


equation
    rTfoPu * rTfoPu * u10Pu = rTfoPu * u20Pu + Complex(RPu, LPu) * i10Pu;
    i10Pu = rTfoPu * (Complex(GPu, CPu) * u20Pu - i20Pu);


  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body>Initialization of a fixed ratio transformer considerating the dynamics of the inductance and the capacitance with the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo----R+jX-------&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)                   |      (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                                |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               ---</span><!--EndFragment--></pre></div><div><br></div></body></html>"));

end DynamicTransformerFixedRatio_INIT;
