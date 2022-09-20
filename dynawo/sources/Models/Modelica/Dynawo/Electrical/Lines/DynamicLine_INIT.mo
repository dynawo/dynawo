within Dynawo.Electrical.Lines;

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

model DynamicLine_INIT "Initialization for dynamic PI line"
  import Dynawo.Types;

  extends AdditionalIcons.Init;

  parameter Types.PerUnit RPu = 0.010829289412251938 "Resistance in pu (base SnRef, UNom) ";
  parameter Types.PerUnit LPu = 0.03609763137417313 "Inductance in pu (base SnRef, UNom, omegaNom)";
  parameter Types.PerUnit GPu = 0 "Half-conductance in pu (base SnRef, UNom)";
  parameter Types.PerUnit CPu = 0 "Half-capacitance in pu (base SnRef, UNom, omegaNom)";
  Types.ComplexVoltagePu u10Pu = Complex(0.8627206, -0.0966988) "Start value of the complex voltage on side 1 (base UNom) ";
  Types.ComplexVoltagePu u20Pu = Complex(0.9837572, 0.2697138) "Start value of the complex voltage on side 2 (base Unom) ";

  Types.ComplexCurrentPu i10Pu "Start value of the complex current on side 1 in pu (base SnRef, UNom)(receptor convention) ";
  Types.ComplexCurrentPu i20Pu "Start value of the complex current on side 2 in pu (base SnRef, UNom)(receptor convention)";
  Types.ComplexCurrentPu iRL0Pu "Start value of the complex current in the R,L part of the line in pu (base SnRef, UNom)(receptor convention)";
  Types.ComplexCurrentPu iGC10Pu "Start value of the complex current in the G,C part of the line on side 1 in pu (base SnRef, UNom) (receptor convention)" ;
  Types.ComplexCurrentPu iGC20Pu  "Start value of the complex current in the G,C part of the line on side 2 in pu (base SnRef, UNom) (receptor convention)" ;

equation
  i10Pu = iGC10Pu + iRL0Pu;
  i20Pu = iGC20Pu - iRL0Pu;
  iGC10Pu = Complex(GPu, CPu) * u10Pu;
  u10Pu - u20Pu = Complex(RPu, LPu) * iRL0Pu;
  iGC20Pu = Complex(GPu, CPu) * u20Pu;


  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
Initialization of a PI model parameters considering the dynamics of the inductance and the capacitances with the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1                  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">   (terminal1) --&gt;-------R+jX-------&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                  G+jB         G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                   ---         ---</span><!--EndFragment--></pre></div><div><div><pre style=\"text-align: center; margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div></div></body></html>"));

end DynamicLine_INIT;
