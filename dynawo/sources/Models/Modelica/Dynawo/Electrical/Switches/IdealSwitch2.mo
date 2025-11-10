within Dynawo.Electrical.Switches;

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

model IdealSwitch2 "Ideal switch with initial values"
  extends Dynawo.Electrical.Switches.IdealSwitch(
    terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))),
    terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))));

  // Switch start values
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (receptor convention)";

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>When the switch is closed, the voltages on both terminals are equal and the current is going through the switch.<div>When the switch is open, the current going through the switch is zero.</div><div><br></div><div>The equivalent circuit and conventions are:</div><div>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1                  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    (terminal1) --&gt;-------/ -------&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><br><!--EndFragment--></pre></div></body></html>"));
end IdealSwitch2;
